import 'package:mawidak/features/busniess/domain/entities/staff_entity.dart';
import 'package:mawidak/features/busniess/presentation/providers/business_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'staff_notifier.g.dart';

sealed class StaffState {
  const StaffState();
}

class StaffInitial extends StaffState {
  const StaffInitial();
}

class StaffLoading extends StaffState {
  const StaffLoading();
}

class StaffLoaded extends StaffState {
  final List<StaffEntity> staff;
  const StaffLoaded(this.staff);
}

class StaffError extends StaffState {
  final String? message;
  const StaffError(this.message);
}

@riverpod
class StaffNotifier extends _$StaffNotifier {
  @override
  StaffState build() {
    loadStaff();
    return const StaffLoading();
  }

  Future<void> loadStaff() async {
    state = const StaffLoading();
    final result = await ref.read(getStaffUseCaseProvider)();
    state = result.fold(
      (f) => StaffError(f.message),
      (list) => StaffLoaded(list),
    );
  }

  Future<void> upsert(StaffEntity staff) async {
    final result = await ref.read(upsertStaffUseCaseProvider)(staff);
    result.fold((f) => state = StaffError(f.message), (_) => loadStaff());
  }
}
