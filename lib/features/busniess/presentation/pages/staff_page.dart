import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/router/app_routes.dart';
import '../../domain/entities/staff_entity.dart';
import '../notifiers/staff_notifier.dart';

class StaffPage extends ConsumerWidget {
  const StaffPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(staffProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Staff')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.staffForm),
        child: const Icon(Icons.add),
      ),
      body: switch (state) {
        StaffLoading() => const Center(child: CircularProgressIndicator()),
        StaffError(:final message) => _ErrorView(
          message: message ?? 'Unknown error occurred',
          onRetry: () => ref.read(staffProvider.notifier).loadStaff(),
        ),
        StaffLoaded(:final staff) when staff.isEmpty => const _EmptyView(),
        StaffLoaded(:final staff) => ListView.separated(
          itemCount: staff.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) => _StaffTile(
            staff: staff[i],
            onEdit: () => context.push(AppRoutes.staffForm, extra: staff[i]),
            onManageHours: () {
              final staffId = staff[i].id ?? staff[i].userId;
              context.pushNamed(
                'workingHours',
                pathParameters: {'staffId': '$staffId'},
              );
            },
          ),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _StaffTile extends StatelessWidget {
  final StaffEntity staff;
  final VoidCallback onEdit;
  final VoidCallback onManageHours;

  const _StaffTile({
    required this.staff,
    required this.onEdit,
    required this.onManageHours,
  });

  @override
  Widget build(BuildContext context) {
    final serviceCount = staff.assignedServiceIds.length;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(staff.name, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(
        '${staff.email} • $serviceCount assigned ${serviceCount == 1 ? 'service' : 'services'}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.access_time_outlined),
            tooltip: 'Working Hours',
            onPressed: onManageHours,
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: onEdit,
          ),
        ],
      ),
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

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) => const Center(
    child: Text('No staff members yet — add a new staff member'),
  );
}
