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
  static const String commethApiKey = "a83131c6-6c56-48d2-bacd-09ad4c24428b";
  static const String formatDate = 'dd MMMM yyyy';

  static const List<String> profileImages = [
    "https://firebasestorage.googleapis.com/v0/b/cengli-dev.appspot.com/o/profile-four.png?alt=media&token=800b14d8-cccd-4efb-b97a-d4cd811e61d7&_gl=1*5b6gkl*_ga*MzQ3OTIyOTguMTY5NTA5ODgwMQ..*_ga_CW55HF8NVT*MTY5NzcwMTg4OS4xMDUuMS4xNjk3NzAzODI5LjI3LjAuMA..",
    "https://firebasestorage.googleapis.com/v0/b/cengli-dev.appspot.com/o/profile-one.png?alt=media&token=ae6f338e-f662-4445-8210-7f1d8404c217&_gl=1*3jj4fr*_ga*MzQ3OTIyOTguMTY5NTA5ODgwMQ..*_ga_CW55HF8NVT*MTY5NzcwMTg4OS4xMDUuMS4xNjk3NzAzODQ3LjkuMC4w",
    "https://firebasestorage.googleapis.com/v0/b/cengli-dev.appspot.com/o/profile-three.png?alt=media&token=759780f9-080a-4327-8e7a-a31664715bac&_gl=1*10sd3m8*_ga*MzQ3OTIyOTguMTY5NTA5ODgwMQ..*_ga_CW55HF8NVT*MTY5NzcwMTg4OS4xMDUuMS4xNjk3NzAzODYzLjYwLjAuMA..",
    "https://firebasestorage.googleapis.com/v0/b/cengli-dev.appspot.com/o/profile-two.png?alt=media&token=4958edcd-d796-4f2a-bfde-82836f1451db&_gl=1*12dotqe*_ga*MzQ3OTIyOTguMTY5NTA5ODgwMQ..*_ga_CW55HF8NVT*MTY5NzcwMTg4OS4xMDUuMS4xNjk3NzAzODc2LjQ3LjAuMA.."
  ];
}
