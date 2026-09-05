import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mawidak/config/di/injection.dart';
import 'package:mawidak/features/busniess/domain/usecases/delete_service_use_case.dart';
import 'package:mawidak/features/busniess/domain/usecases/get_services_use_case.dart';
import 'package:mawidak/features/busniess/domain/usecases/get_staff_use_case.dart';
import 'package:mawidak/features/busniess/domain/usecases/get_working_hours_use_case.dart';
import 'package:mawidak/features/busniess/domain/usecases/update_working_hours_use_case.dart';
import 'package:mawidak/features/busniess/domain/usecases/upsert_service_use_case.dart';
import 'package:mawidak/features/busniess/domain/usecases/upsert_staff_use_case.dart';

part 'business_providers.g.dart';

@riverpod
GetServicesUseCase getServicesUseCase(Ref ref) => getIt<GetServicesUseCase>();

@riverpod
UpsertServiceUseCase upsertServiceUseCase(Ref ref) =>
    getIt<UpsertServiceUseCase>();

@riverpod
DeleteServiceUseCase deleteServiceUseCase(Ref ref) =>
    getIt<DeleteServiceUseCase>();

@riverpod
GetStaffUseCase getStaffUseCase(Ref ref) => getIt<GetStaffUseCase>();

@riverpod
UpsertStaffUseCase upsertStaffUseCase(Ref ref) => getIt<UpsertStaffUseCase>();

@riverpod
GetWorkingHoursUseCase getWorkingHoursUseCase(Ref ref) =>
    getIt<GetWorkingHoursUseCase>();

@riverpod
UpdateWorkingHoursUseCase updateWorkingHoursUseCase(Ref ref) =>
    getIt<UpdateWorkingHoursUseCase>();
