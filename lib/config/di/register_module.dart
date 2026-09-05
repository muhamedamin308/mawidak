import 'package:dio/dio.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/constants/app_constants.dart';

@module
abstract class RegisterModule {
  @LazySingleton()
  Dio get dio => Dio(
    BaseOptions(
      baseUrl: AppConstants.localAPI,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  @preResolve
  @lazySingleton
  Future<Box> get bookingCacheBox async {
    await Hive.initFlutter();
    return Hive.openBox('booking_cache');
  }
}
