enum Weekdays { mondey, tuesday, wednesday, thursday, friday, saturday, sunday }

class DaySchedule {
  final Weekdays day;
  final bool isWorking;
  final String? startTime;
  final String? endTime;

  const DaySchedule({
    required this.day,
    required this.isWorking,
    this.startTime,
    this.endTime,
  });
}

class WorkingHoursEntity {
  final int staffId;
  final List<DaySchedule> daySchedule;

  const WorkingHoursEntity({required this.staffId, required this.daySchedule});
}
