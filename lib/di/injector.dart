import 'package:cengli/data/network/header_interceptor.dart';
import 'package:cengli/di/modules/auth_module.dart';
import 'package:cengli/di/modules/membership_module.dart';
import 'package:cengli/di/modules/transaction_module.dart';
import 'package:cengli/di/modules/transfer_module.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:velix/velix.dart';
import 'package:logger/logger.dart';

import '../services/services.dart';

GetIt locator = GetIt.instance;

void injectModules() async {
  BaseOptions commethOptions = BaseOptions(
      connectTimeout: 100000, receiveTimeout: 100000, followRedirects: false);
  BaseOptions cengliOptions = BaseOptions(
      connectTimeout: 100000, receiveTimeout: 100000, followRedirects: false);

  Dio dioCommeth = Dio(commethOptions);
  Dio dioCengli = Dio(cengliOptions);

  dioCommeth.options.baseUrl = "https://api.connect.cometh.io/";
  dioCengli.options.baseUrl = FlavorConfig.baseUrl;

  Logger logger = Logger(printer: PrettyPrinter(colors: true));
  FirebaseFirestore db = FirebaseFirestore.instance;
  DatabaseService database = DatabaseService();
  DynamicLinkService dynamicLinkService = DynamicLinkService();
  NavigationService navigationService = NavigationService();

  dioCommeth.interceptors.add(HeaderInterceptor(logger));
  dioCengli.interceptors.add(HeaderInterceptor(logger));

  locator.registerLazySingleton(() => dioCommeth, instanceName: 'commeth');
  locator.registerLazySingleton(() => dioCengli, instanceName: 'cengli');
  locator.registerLazySingleton(() => database);
  locator.registerLazySingleton(() => dynamicLinkService);
  locator.registerLazySingleton(() => navigationService);

  locator.registerSingleton(db);

  injectAuthModule();
  injectTransactionModule();
  injectMembershipModule();
  injectTransferModule();
}
