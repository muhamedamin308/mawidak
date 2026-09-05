import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/service_entity.dart';
import '../notifiers/services_notifier.dart';

class ServiceFormPage extends ConsumerStatefulWidget {
  final ServiceEntity? existing; // null = create, non-null = edit

  const ServiceFormPage({super.key, this.existing});

  @override
  ConsumerState<ServiceFormPage> createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends ConsumerState<ServiceFormPage> {
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _duration;
  late final TextEditingController _price;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _description = TextEditingController(text: e?.description ?? '');
    _duration = TextEditingController(
      text: e?.durationMinutes.toString() ?? '',
    );
    _price = TextEditingController(text: e?.price.toString() ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _duration.dispose();
    _price.dispose();
    super.dispose();
  }

  void _submit() {
    final service = ServiceEntity(
      id: widget.existing?.id,
      name: _name.text.trim(),
      description: _description.text.trim(),
      durationMinutes: int.tryParse(_duration.text) ?? 0,
      price: double.tryParse(_price.text) ?? 0,
    );
    ref.read(servicesProvider.notifier).upsert(service);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(servicesProvider) is ServicesLoading;

    ref.listen(servicesProvider, (prev, next) {
      if (next is ServicesLoaded) Navigator.of(context).pop();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'New Service' : 'Edit Service'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Service Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _description,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _duration,
            decoration: const InputDecoration(labelText: 'Duration (minutes)'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _price,
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
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
