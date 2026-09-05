import 'package:mawidak/features/busniess/domain/entities/service_entity.dart';
import 'package:mawidak/features/busniess/presentation/providers/business_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'services_notifier.g.dart';

sealed class ServicesState {
  const ServicesState();
}

class ServicesInitial extends ServicesState {
  const ServicesInitial();
}

class ServicesLoading extends ServicesState {
  const ServicesLoading();
}

class ServicesLoaded extends ServicesState {
  final List<ServiceEntity> services;
  const ServicesLoaded(this.services);
}

class ServicesError extends ServicesState {
  final String? message;
  const ServicesError(this.message);
}

@riverpod
class ServicesNotifier extends _$ServicesNotifier {
  @override
  ServicesState build() {
    loadServices();
    return const ServicesLoading();
  }

  Future<void> loadServices() async {
    state = const ServicesLoading();
    final result = await ref.read(getServicesUseCaseProvider)();
    state = result.fold(
      (f) => ServicesError(f.message),
      (list) => ServicesLoaded(list),
    );
  }

  Future<void> upsert(ServiceEntity service) async {
    final result = await ref.read(upsertServiceUseCaseProvider)(service);
    result.fold((f) => state = ServicesError(f.message), (_) => loadServices());
  }

  Future<void> delete(int id) async {
    final result = await ref.read(deleteServiceUseCaseProvider)(id);
    result.fold((f) => state = ServicesError(f.message), (_) => loadServices());
  }
}
