import 'package:mawidak/features/busniess/domain/entities/working_hours_entity.dart';
import 'package:mawidak/features/busniess/presentation/providers/business_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'working_hours_notifier.g.dart';

sealed class WorkingHoursState {
  const WorkingHoursState();
}

class WorkingHoursInitial extends WorkingHoursState {
  const WorkingHoursInitial();
}

class WorkingHoursLoading extends WorkingHoursState {
  const WorkingHoursLoading();
}

class WorkingHoursLoaded extends WorkingHoursState {
  final WorkingHoursEntity workingHours;
  const WorkingHoursLoaded(this.workingHours);
}

class WorkingHoursError extends WorkingHoursState {
  final String? message;
  const WorkingHoursError(this.message);
}

@riverpod
class WorkingHoursNotifier extends _$WorkingHoursNotifier {
  @override
  WorkingHoursState build(int staffId) {
    loadWorkingHours();
    return const WorkingHoursLoading();
  }

  Future<void> loadWorkingHours() async {
    state = const WorkingHoursLoading();
    final result = await ref.read(getWorkingHoursUseCaseProvider)(
      staffId,
    ); // ← pass it
    state = result.fold(
      (f) => WorkingHoursError(f.message),
      (entity) => WorkingHoursLoaded(entity), // ← single entity
    );
  }

  Future<void> update(WorkingHoursEntity workingHours) async {
    final result = await ref.read(updateWorkingHoursUseCaseProvider)(
      workingHours,
    );
    result.fold(
      (f) => state = WorkingHoursError(f.message),
      (_) => loadWorkingHours(),
    );
  }
}
