import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ready_go_project/data/models/purchases/purchase_model.dart';
import 'package:ready_go_project/domain/repositories/purchases_repo.dart';

class PurchaseManager with ChangeNotifier {
  final logger = Logger();

  List<PurchaseModel> _purchaseList = [];

  List<PurchaseModel> _purchases = [];
  List<ProductDetails> _products = [];

  List<PurchaseModel> get purchases => _purchases;
  List<ProductDetails> get products => _products;

  bool get isRemoveAdsUser {
    return purchases.any((item) => item.productId.contains("cash_3300"));
  }

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // 디바이스에 저장된 구매완료 리스트 가져오기
  Future<void> getPurchases() async{
    final list = await GetIt.I.get<PurchasesRepo>().getPurchasesList();
    _purchases = list;
    notifyListeners();
  }

  // 판매 상품 목록 요청
  Future<void> queryProducts(Set<String> productIds) async {
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);
    if (response.error != null) {
      // 오류 처리
      logger.e('Error querying products: ${response.error}');
      return;
    }
    _products = response.productDetails;
    notifyListeners();
    // UI 업데이트 등 처리
  }

  // 구매 목록 상태 stream 요청
  Future<void> loadPurchase() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // 오류 처리
      logger.e("purchase load failed");
    });
    // loadPastPurchases();
  }

  // 판매 상품 데이터 실시간 받기 && 상태에 따른 처리
  Future<void> listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // 구매 보류 중 (사용자 인증 필요 등)
        logger.i('Purchase pending: ${purchaseDetails.productID}');
        // 로딩 UI 표시 등
      } else {
        if (purchaseDetails.status == PurchaseStatus.purchased) {
          // 구매 성공
          logger.i('Purchase successful: ${purchaseDetails.productID}');
          // logger.i('Purchase successful: ${purchaseDetails.verificationData.serverVerificationData}');
          final isVerify = await verifyPurchase(purchaseDetails); // 구매 검증 (서버 또는 로컬)
          if(isVerify && purchaseDetails.pendingCompletePurchase){
            await _inAppPurchase.completePurchase(purchaseDetails);// 구매 완료 처리
            final platform = Platform.isIOS ? "ios" : "android";
            final item = PurchaseModel(
                productId: purchaseDetails.productID,
                purchaseDate: purchaseDetails.transactionDate.toString(),
                platform: platform,
                isVerified: true);
            final list = await GetIt.I.get<PurchasesRepo>().addPurchasesData(item);
            _purchases = list;
            notifyListeners();
          }
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          // logger.i('Purchase restore: ${purchaseDetails.productID}');
          final isVerify = await verifyPurchase(purchaseDetails); // 구매 검증 (서버 또는 로컬)
          if(isVerify){
            final platform = Platform.isIOS ? "ios" : "android";
            final item = PurchaseModel(
                productId: purchaseDetails.productID,
                purchaseDate: purchaseDetails.transactionDate.toString(),
                platform: platform,
                isVerified: true);
            _purchaseList.add(item);
          }
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          // 구매 실패
          logger.e('Purchase failed: ${purchaseDetails.error}');
          // 오류 메시지 표시
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          // content: Text("구매중 오류가 발생했습니다."),
          // duration: Duration(milliseconds: 1000),
          // ));
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          // 구매 취소
          logger.i('Purchase canceled: ${purchaseDetails.productID}');
        }
        //
        // if (purchaseDetails.pendingCompletePurchase) {
        //   await _inAppPurchase.completePurchase(purchaseDetails); // 구매 완료 처리
        // }
      }
    }

    if(_purchaseList.isNotEmpty){
      await GetIt.I.get<PurchasesRepo>().removePurchasesData(_purchaseList);
    }
  }

  // 영수증 검사 서버 요청 로직..
  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async {
    final bool isIOS = Platform.isIOS;
    final bool isSubscription = purchaseDetails.productID.contains("subscription"); // 구독 여부 구분 (상품 ID에 따라 수정 가능)

    try {
      final Map<String, dynamic> callData;

      if (isIOS) {
        callData = {
          "platform": "ios",
          "type": isSubscription ? "subscription" : "non-subscription",
          "receipt": purchaseDetails.verificationData.serverVerificationData, // base64 string
        };
        logger.i("IOS VerificationData : $callData");
      } else {
        // ✅ Android는 단순한 purchaseToken 문자열임 → JSON 아님
        final purchaseToken = purchaseDetails.verificationData.serverVerificationData;
        final packageInfo = await PackageInfo.fromPlatform();
        final packageName = packageInfo.packageName;

        callData = {
          "platform": "android",
          "type": isSubscription ? "subscription" : "non-subscription",
          "receipt": {
            "packageName": packageName,
            "productId": purchaseDetails.productID,
            "purchaseToken": purchaseToken,
          }
        };
        // logger.i("📦 Android VerificationData: $callData");
      }

      final url = Uri.parse("https://asia-northeast3-readygoapp-5d7c7.cloudfunctions.net/verifyReceipt");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(callData),
      );

      final data = jsonDecode(response.body);
      logger.i("검증 data: $data");
      if (data['status'] == 200) {
        // ✅ 검증 성공
        logger.i("✅ 검증 성공: ${data['productId']}");

        if (data['type'] == 'subscription') {
          // 예: 구독 만료 시간 저장
          final expiresAt = DateTime.fromMillisecondsSinceEpoch(data['expiresAt']);
          logger.i("구독 유효: $expiresAt");
          // TODO: local storage 저장 로직 추가
        } else {
          final purchasedAt = DateTime.fromMillisecondsSinceEpoch(
            data['purchaseDate'] ?? data['purchaseTime'] ?? DateTime.now().millisecondsSinceEpoch,
          );
          logger.i("비구독 구매 시간: $purchasedAt");
          // TODO: local storage 저장 로직 추가
        }
        return true;
      }else if(data['status'] == 201){
        logger.w("검증 완료 => 권한 취소");
        return false;
      } else {
        // ❌ 검증 실패
        logger.i("${data["status"]} : ${data["message"]}" );
        logger.i("error:  ${data["error"]}" );
        logger.w("❌ 검증 실패: ${data['message']}");
        // TODO: 사용자에게 UI 알림 처리
        return false;
      }
    } catch (e) {
      logger.e("🔥 서버 검증 실패: $e");
      rethrow;
      // TODO: 사용자에게 실패 메시지 전달
    }
  }

// 구매 복원 요청(앱 재설치 / 디바이스 교체 / 유져 요청 등)
  Future<void> loadPastPurchases() async {
    try {
      // 복원 절차 시작 (반환값 사용 안 함)
      await _inAppPurchase.restorePurchases();
      logger.i('Purchase restoration process initiated successfully.');
      // 필요하다면 사용자에게 복원 절차가 시작되었음을 알리는 UI 피드백 제공
      // 예: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('구매 내역 복원을 시작합니다... 완료 시 자동으로 적용됩니다.')));
    } catch (e) {
      logger.e('구매 내역 복원 시작 오류: $e');
      // TODO: [개선점 4] 사용자에게 오류 발생을 알리는 UI 피드백이 필요합니다.
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('구매 내역 복원 중 오류가 발생했습니다.')));
    }
    // 이 함수에서는 더 이상 구매 내역 리스트를 직접 처리하지 않습니다.
    // 모든 처리는 _listenToPurchaseUpdated 에서 이루어집니다.
  }

// 상품 구맨
  Future<void> buyProduct(ProductDetails productDetails, BuildContext context) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    try {
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam); // 소모품이 아닌 경우
      // 또는 await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam); // 소모품인 경우
      // 또는 await _inAppPurchase.buySubscription(purchaseParam: purchaseParam); // 구독인 경우
    } catch (e) {
      // 구매 시작 실패 처리
      logger.e('Error initiating purchase: $e');
      // 필요에 따라 사용자에게 알림 표시
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }
}
