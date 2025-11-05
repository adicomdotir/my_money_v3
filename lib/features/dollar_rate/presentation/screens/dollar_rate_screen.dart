import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/dollar_rate/data/models/dollar_rate_model.dart';
import 'package:my_money_v3/features/dollar_rate/domain/entities/dollar_rate.dart';

import '../cubit/dollar_rate_cubit.dart';

class DollarRateScreen extends StatefulWidget {
  const DollarRateScreen({super.key});

  @override
  State<DollarRateScreen> createState() => _DollarRateScreenState();
}

class _DollarRateScreenState extends State<DollarRateScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DollarRateCubit>().getAllDollarRates();
  }

  Future<void> _addOrEdit({DollarRate? initial}) async {
    final result = await showDialog<DollarRateModel>(
      context: context,
      builder: (_) => _DollarRateDialog(initial: initial),
    );
    if (result != null && mounted) {
      context.read<DollarRateCubit>().upsertDollarRate(result);
    }
  }

  Future<void> _delete(DollarRate item) async {
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
    if (ok == true && mounted) {
      context.read<DollarRateCubit>().deleteDollarRate(item.year, item.month);
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
      body: BlocBuilder<DollarRateCubit, DollarRateState>(
        builder: (context, state) {
          if (state is DollarRateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DollarRateError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<DollarRateCubit>().getAllDollarRates(),
                    child: const Text('تلاش مجدد'),
                  ),
                ],
              ),
            );
          } else if (state is DollarRateLoaded) {
            if (state.rates.isEmpty) {
              return const Center(
                child: Text('هیچ نرخ دلاری ثبت نشده است'),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.rates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = state.rates[index];
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
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _DollarRateDialog extends StatefulWidget {
  final DollarRate? initial;
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
