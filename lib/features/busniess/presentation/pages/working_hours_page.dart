import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/working_hours_entity.dart';
import '../notifiers/working_hours_notifier.dart';

class WorkingHoursPage extends ConsumerStatefulWidget {
  final int staffId;

  const WorkingHoursPage({super.key, required this.staffId});

  @override
  ConsumerState<WorkingHoursPage> createState() => _WorkingHoursPageState();
}

class _WorkingHoursPageState extends ConsumerState<WorkingHoursPage> {
  late List<DaySchedule> _schedules;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _schedules = _defaultSchedules();
  }

  List<DaySchedule> _defaultSchedules() {
    return Weekdays.values.map((day) {
      final isWeekend = day == Weekdays.friday || day == Weekdays.saturday;
      return DaySchedule(
        day: day,
        isWorking: !isWeekend,
        startTime: !isWeekend ? '09:00' : null,
        endTime: !isWeekend ? '17:00' : null,
      );
    }).toList();
  }

  void _initFromEntity(WorkingHoursEntity entity) {
    if (_isInitialized) return;
    if (entity.daySchedule.isNotEmpty) {
      _schedules = Weekdays.values.map((day) {
        return entity.daySchedule.where((s) => s.day == day).firstOrNull ??
            DaySchedule(
              day: day,
              isWorking: false,
              startTime: null,
              endTime: null,
            );
      }).toList();
    }
    _isInitialized = true;
  }

  String _formatWeekday(Weekdays day) => switch (day) {
    Weekdays.mondey => 'Monday',
    Weekdays.tuesday => 'Tuesday',
    Weekdays.wednesday => 'Wednesday',
    Weekdays.thursday => 'Thursday',
    Weekdays.friday => 'Friday',
    Weekdays.saturday => 'Saturday',
    Weekdays.sunday => 'Sunday',
  };

  Future<void> _pickTime(int index, bool isStartTime) async {
    final schedule = _schedules[index];
    final currentStr = isStartTime ? schedule.startTime : schedule.endTime;
    TimeOfDay initial = const TimeOfDay(hour: 9, minute: 0);

    if (currentStr != null && currentStr.contains(':')) {
      final parts = currentStr.split(':');
      initial = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 9,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }

    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        _schedules[index] = DaySchedule(
          day: schedule.day,
          isWorking: schedule.isWorking,
          startTime: isStartTime ? formatted : schedule.startTime,
          endTime: !isStartTime ? formatted : schedule.endTime,
        );
      });
    }
  }

  void _submit() {
    ref
        .read(workingHoursProvider(widget.staffId).notifier)
        .update(
          WorkingHoursEntity(staffId: widget.staffId, daySchedule: _schedules),
        );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Pass staffId — it's a family provider now
    final state = ref.watch(workingHoursProvider(widget.staffId));
    final isLoading = state is WorkingHoursLoading;

    ref.listen(workingHoursProvider(widget.staffId), (prev, next) {
      if (next is WorkingHoursLoaded && prev is WorkingHoursLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Working hours updated successfully')),
        );
      }
    });

    // ✅ Single entity — no list filtering needed
    if (state is WorkingHoursLoaded) {
      _initFromEntity(state.workingHours);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Working Hours')),
      body: switch (state) {
        WorkingHoursLoading() when !_isInitialized => const Center(
          child: CircularProgressIndicator(),
        ),
        WorkingHoursError(:final message) when !_isInitialized => _ErrorView(
          message: message ?? 'Unknown error',
          onRetry: () => ref
              .read(workingHoursProvider(widget.staffId).notifier)
              .loadWorkingHours(),
        ),
        _ => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ..._schedules.asMap().entries.map((entry) {
              final index = entry.key;
              final schedule = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatWeekday(schedule.day),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Switch(
                            value: schedule.isWorking,
                            onChanged: (val) {
                              setState(() {
                                _schedules[index] = DaySchedule(
                                  day: schedule.day,
                                  isWorking: val,
                                  startTime: val
                                      ? (schedule.startTime ?? '09:00')
                                      : null,
                                  endTime: val
                                      ? (schedule.endTime ?? '17:00')
                                      : null,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      if (schedule.isWorking) ...[
                        const Divider(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.login, size: 16),
                                label: Text(schedule.startTime ?? '09:00'),
                                onPressed: () => _pickTime(index, true),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('to'),
                            ),
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.logout, size: 16),
                                label: Text(schedule.endTime ?? '17:00'),
                                onPressed: () => _pickTime(index, false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Working Hours'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}
