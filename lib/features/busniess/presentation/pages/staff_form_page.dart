import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/staff_entity.dart';
import '../notifiers/services_notifier.dart';
import '../notifiers/staff_notifier.dart';

class StaffFormPage extends ConsumerStatefulWidget {
  final StaffEntity? existing; // null = create, non-null = edit

  const StaffFormPage({super.key, this.existing});

  @override
  ConsumerState<StaffFormPage> createState() => _StaffFormPageState();
}

class _StaffFormPageState extends ConsumerState<StaffFormPage> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _userId;
  late final Set<int> _selectedServiceIds;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _email = TextEditingController(text: e?.email ?? '');
    _userId = TextEditingController(text: e?.userId.toString() ?? '');
    _selectedServiceIds = Set<int>.from(e?.assignedServiceIds ?? []);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _userId.dispose();
    super.dispose();
  }

  void _submit() {
    final staff = StaffEntity(
      id: widget.existing?.id,
      userId: int.tryParse(_userId.text.trim()) ?? widget.existing?.userId ?? 0,
      name: _name.text.trim(),
      email: _email.text.trim(),
      assignedServiceIds: _selectedServiceIds.toList(),
    );
    ref.read(staffProvider.notifier).upsert(staff);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(staffProvider) is StaffLoading;
    final servicesState = ref.watch(servicesProvider);

    ref.listen(staffProvider, (prev, next) {
      if (next is StaffLoaded) Navigator.of(context).pop();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existing == null ? 'New Staff Member' : 'Edit Staff Member',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Staff Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _userId,
            decoration: const InputDecoration(
              labelText: 'User ID',
              hintText: 'Account user identifier',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          Text(
            'Assigned Services',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          switch (servicesState) {
            ServicesLoading() => const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LinearProgressIndicator(),
            ),
            ServicesLoaded(:final services) when services.isNotEmpty => Wrap(
              spacing: 8,
              runSpacing: 4,
              children: services.map((service) {
                final serviceId = service.id;
                if (serviceId == null) return const SizedBox.shrink();
                final isSelected = _selectedServiceIds.contains(serviceId);
                return FilterChip(
                  label: Text(service.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedServiceIds.add(serviceId);
                      } else {
                        _selectedServiceIds.remove(serviceId);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            _ => const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No services available yet. Create services first to assign.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          },
          const SizedBox(height: 32),
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
                  : const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
