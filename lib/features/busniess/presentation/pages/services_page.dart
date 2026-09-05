import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/service_entity.dart';
import '../notifiers/services_notifier.dart';

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.serviceForm),
        child: const Icon(Icons.add),
      ),
      body: switch (state) {
        ServicesLoading() => const Center(child: CircularProgressIndicator()),
        ServicesError(:final message) => _ErrorView(
          message: message ?? 'Unknown error occurred',
          onRetry: () =>
              ref.read(servicesProvider.notifier).loadServices(),
        ),
        ServicesLoaded(:final services) when services.isEmpty =>
          const _EmptyView(),
        ServicesLoaded(:final services) => ListView.separated(
          itemCount: services.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) => _ServiceTile(
            service: services[i],
            onEdit: () =>
                context.push(AppRoutes.serviceForm, extra: services[i]),
            onDelete: () => ref
                .read(servicesProvider.notifier)
                .delete(services[i].id!),
          ),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final ServiceEntity service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ServiceTile({
    required this.service,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(service.name, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(
        '${service.durationMinutes} minutes • ${service.price} EGP',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: onEdit),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: onDelete,
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
      child: Text('No services yet — add a new service'));
}
