import 'package:velix/velix.dart';

class Constant {
  static const String dynamicLinkBaseUrl = 'https://cengli-dev.web.app';
  static const String dynamicLinkPrefix = 'https://cengli.page.link';

  static String androidBundleId = FlavorConfig.isDevelopment()
      ? "com.cengli.androidapp.dev"
      : "com.cengli.androidapp";
  static String iOSBundleId = FlavorConfig.isDevelopment()
      ? "com.cengli.iosapp.dev"
      : "com.cengli.iosapp";
  static const String appStoreId = "6446429674";
  static const String commethAvaxApiKey =
      "a83131c6-6c56-48d2-bacd-09ad4c24428b";
  static const String commethPolygonApiKey =
      "4a6194e8-d56f-4ec3-bc1e-fe821c689dae";
  static const String formatDate = 'dd MMMM yyyy';
  static const String kycBaseUrl =
      "https://cengli-kyc.engowl.studio/video-call?";

  static const List<String> profileImages = [
    "https://firebasestorage.googleapis.com/v0/b/cengli-dev.appspot.com/o/img-profile1.png?alt=media&token=e07107ae-fbfa-4480-8c22-39cd1902cf10&_gl=1*rfk8n4*_ga*MzQ3OTIyOTguMTY5NTA5ODgwMQ..*_ga_CW55HF8NVT*MTY5NzkxNDU2MS4xMjUuMS4xNjk3OTE0Njg1LjUyLjAuMA..",
    "https://firebasestorage.googleapis.com/v0/b/cengli-dev.appspot.com/o/img-profile2.png?alt=media&token=6af67667-998f-4d03-a78d-d643365a8198&_gl=1*i8m2xw*_ga*MzQ3OTIyOTguMTY5NTA5ODgwMQ..*_ga_CW55HF8NVT*MTY5NzkxNDU2MS4xMjUuMS4xNjk3OTE0NzAxLjM2LjAuMA..",
    "https://firebasestorage.googleapis.com/v0/b/cengli-dev.appspot.com/o/img-profile3.png?alt=media&token=37d4800f-df68-4d72-bbe8-b4f16b8d6c78&_gl=1*mqw8w5*_ga*MzQ3OTIyOTguMTY5NTA5ODgwMQ..*_ga_CW55HF8NVT*MTY5NzkxNDU2MS4xMjUuMS4xNjk3OTE0NzExLjI2LjAuMA..",
    "https://firebasestorage.googleapis.com/v0/b/cengli-dev.appspot.com/o/img-profile4.png?alt=media&token=bb9dd35d-922c-48d2-8a60-91bd5675ccb8&_gl=1*1c3nk4y*_ga*MzQ3OTIyOTguMTY5NTA5ODgwMQ..*_ga_CW55HF8NVT*MTY5NzkxNDU2MS4xMjUuMS4xNjk3OTE0NzI2LjExLjAuMA.."
  ];
}
