import 'package:flutter/material.dart';
import 'package:my_money_v3/features/dollar_rate/data/models/dollar_rate_model.dart';
import 'package:my_money_v3/injection_container.dart' as di;

import '../../../../core/db/db.dart';

class DollarRateScreen extends StatefulWidget {
  const DollarRateScreen({super.key});

  @override
  State<DollarRateScreen> createState() => _DollarRateScreenState();
}

class _DollarRateScreenState extends State<DollarRateScreen> {
  late final DatabaseHelper _db;
  List<DollarRateModel> _rates = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _db = di.sl<DatabaseHelper>();
    _load();
  }

  Future<void> _load() async {
    final list = await _db.getAllDollarRates();
    setState(() {
      _rates = list;
      _loading = false;
    });
  }

  Future<void> _addOrEdit({DollarRateModel? initial}) async {
    final result = await showDialog<DollarRateModel>(
      context: context,
      builder: (_) => _DollarRateDialog(initial: initial),
    );
    if (result != null) {
      await _db.upsertDollarRate(result);
      await _load();
    }
  }

  Future<void> _delete(DollarRateModel item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف نرخ دلار'),
        content: Text('حذف ${item.year}/${item.month}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _db.deleteDollarRate(item.year, item.month);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نرخ دلار ماهانه')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEdit(),
        icon: const Icon(Icons.add),
        label: const Text('افزودن نرخ'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _rates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _rates[index];
                return Card(
                  child: ListTile(
                    title: Text('سال ${item.year} - ماه ${item.month}'),
                    subtitle: Text('قیمت: ${item.price}'),
                    onTap: () => _addOrEdit(initial: item),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _delete(item),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _DollarRateDialog extends StatefulWidget {
  final DollarRateModel? initial;
  const _DollarRateDialog({this.initial});

  @override
  State<_DollarRateDialog> createState() => _DollarRateDialogState();
}

class _DollarRateDialogState extends State<_DollarRateDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _year;
  late final TextEditingController _month;
  late final TextEditingController _price;

  @override
  void initState() {
    super.initState();
    _year =
        TextEditingController(text: widget.initial?.year.toString() ?? '1404');
    _month =
        TextEditingController(text: widget.initial?.month.toString() ?? '1');
    _price =
        TextEditingController(text: widget.initial?.price.toString() ?? '0');
  }

  @override
  void dispose() {
    _year.dispose();
    _month.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'افزودن نرخ' : 'ویرایش نرخ'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _year,
                decoration: const InputDecoration(labelText: 'سال (جلالی)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 1300 || n > 1600) return 'سال نامعتبر';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _month,
                decoration: const InputDecoration(labelText: 'ماه (1..12)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 1 || n > 12) return 'ماه نامعتبر';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                decoration: const InputDecoration(labelText: 'قیمت (تومان)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'قیمت نامعتبر';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('انصراف'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final model = DollarRateModel(
              year: int.parse(_year.text),
              month: int.parse(_month.text),
              price: int.parse(_price.text),
            );
            Navigator.pop(context, model);
          },
          child: Text(widget.initial == null ? 'افزودن' : 'ویرایش'),
        ),
      ],
    );
  }
}
