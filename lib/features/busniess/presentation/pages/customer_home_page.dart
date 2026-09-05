import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mawidak/config/router/app_routes.dart';
import 'package:mawidak/core/constants/app_colors.dart';
import 'package:mawidak/features/busniess/domain/entities/service_entity.dart';
import 'package:mawidak/features/busniess/domain/entities/staff_entity.dart';
import 'package:mawidak/features/busniess/presentation/notifiers/services_notifier.dart';
import 'package:mawidak/features/busniess/presentation/notifiers/staff_notifier.dart';

class CustomerHomePage extends ConsumerStatefulWidget {
  const CustomerHomePage({super.key});

  @override
  ConsumerState<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends ConsumerState<CustomerHomePage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Hair', 'Beard', 'Skin'];

  @override
  Widget build(BuildContext context) {
    final servicesState = ref.watch(servicesProvider);
    final staffState = ref.watch(staffProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'موعدك',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'الرئيسية (Customer)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'لوحة الإدارة (Admin Dashboard)',
            icon: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.primary),
            onPressed: () => context.push(AppRoutes.adminDashboard),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(servicesProvider.notifier).loadServices();
          ref.read(staffProvider.notifier).loadStaff();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Welcome Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'أهلاً بك! 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'احجز موعدك القادم مع أفضل المتخصصين بسهولة وسرعة.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن خدمة أو متخصص...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() => _searchQuery = val.toLowerCase());
              },
            ),
            const SizedBox(height: 16),

            // Categories Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat == 'All' ? 'الكل' : cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCategory = cat);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Services Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الخدمات المتاحة',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.services),
                  child: const Text('إدارة الخدمات'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Services List
            switch (servicesState) {
              ServicesLoading() => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ServicesError(:final message) => Center(
                  child: Text(message ?? 'حدث خطأ في تحميل الخدمات'),
                ),
              ServicesLoaded(:final services) => _buildServicesList(services),
              _ => const SizedBox.shrink(),
            },
            const SizedBox(height: 24),

            // Specialists Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'فريق العمل والمتخصصين',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.staff),
                  child: const Text('إدارة الفريق'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Staff List
            switch (staffState) {
              StaffLoading() => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              StaffError(:final message) => Center(
                  child: Text(message ?? 'حدث خطأ في تحميل فريق العمل'),
                ),
              StaffLoaded(:final staff) => _buildStaffList(staff),
              _ => const SizedBox.shrink(),
            },
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(List<ServiceEntity> services) {
    final filtered = services.where((s) {
      final matchesSearch = s.name.toLowerCase().contains(_searchQuery) ||
          (s.description?.toLowerCase().contains(_searchQuery) ?? false);
      final matchesCat = _selectedCategory == 'All' ||
          (s.category?.toLowerCase() == _selectedCategory.toLowerCase());
      return matchesSearch && matchesCat;
    }).toList();

    if (filtered.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: Text('لا توجد خدمات مطابقة')),
      );
    }

    return Column(
      children: filtered.map((service) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 1.5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.content_cut,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      if (service.description != null && service.description!.isNotEmpty)
                        Text(
                          service.description!,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${service.durationMinutes} دقيقة',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${service.price} EGP',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _showBookingDialog(service),
                  child: const Text('حجز'),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStaffList(List<StaffEntity> staff) {
    if (staff.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: Text('لا يوجد متخصصين مضافين')),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: staff.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final member = staff[i];
          return Container(
            width: 180,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.accent.withOpacity(0.2),
                      child: Text(
                        member.name.isNotEmpty ? member.name[0] : 'S',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        member.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${member.assignedServiceIds.length} خدمات معتمدة',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBookingDialog(ServiceEntity service) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تأكيد الحجز: ${service.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المدة: ${service.durationMinutes} دقيقة'),
            const SizedBox(height: 4),
            Text('السعر: ${service.price} EGP'),
            const SizedBox(height: 16),
            const Text(
              'سيتم توجيهك لاختيار الوقت والمختص المتاح.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم اختيار خدمة "${service.name}" بنجاح!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('تأكيد الموعد'),
          ),
        ],
      ),
    );
  }
}
