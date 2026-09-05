import 'package:mawidak/features/busniess/domain/entities/working_hours_entity.dart';

class WorkingHoursModel {
  final int staffId;
  final List<Map<String, dynamic>> rawSchedule;

  const WorkingHoursModel({required this.staffId, required this.rawSchedule});

  factory WorkingHoursModel.fromJson(int staffId, List<dynamic> json) =>
      WorkingHoursModel(
        staffId: staffId,
        rawSchedule: json.map((e) => e as Map<String, dynamic>).toList(),
      );

  WorkingHoursEntity toEntity() => WorkingHoursEntity(
    staffId: staffId,
    daySchedule: rawSchedule.map((row) {
      final dayIndex = int.tryParse(row['dayofweek']?.toString() ?? '0') ?? 0;
      return DaySchedule(
        day: Weekdays.values[dayIndex.clamp(0, Weekdays.values.length - 1)],
        isWorking: row['is_working'] as bool? ?? true,
        startTime: row['hour_from']?.toString(),
        endTime: row['hour_to']?.toString(),
      );
    }).toList(),
  );
}
