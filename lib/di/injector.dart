import 'package:cengli/data/network/header_interceptor.dart';
import 'package:cengli/di/modules/auth_module.dart';
import 'package:cengli/di/modules/transaction_module.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:velix/velix.dart';
import 'package:logger/logger.dart';

import '../services/services.dart';

GetIt locator = GetIt.instance;

void injectModules() async {
  BaseOptions options = BaseOptions(
      connectTimeout: 6000, receiveTimeout: 60000, followRedirects: false);
  Dio dioCommeth = Dio(options);
  dioCommeth.options.baseUrl = "https://api.connect.cometh.io/";

  Logger logger = Logger(printer: PrettyPrinter(colors: true));
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseService database = DatabaseService();
  DynamicLinkService dynamicLinkService = DynamicLinkService();
  NavigationService navigationService = NavigationService();

  dioCommeth.interceptors.add(HeaderInterceptor(logger));

  locator.registerLazySingleton(() => dioCommeth, instanceName: 'commeth');
  locator.registerLazySingleton(() => database);
  locator.registerLazySingleton(() => dynamicLinkService);
  locator.registerLazySingleton(() => navigationService);

  locator.registerSingleton(db);
  locator.registerSingleton(auth);

  injectAuthModule();
  injectTransactionModule();
}
