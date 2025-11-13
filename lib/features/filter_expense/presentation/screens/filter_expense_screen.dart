import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../../core/bloc/global_bloc.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/components/components.dart';
import '../../../../../shared/domain/entities/expense.dart';
import '../bloc/filter_expnese_bloc.dart';

class FilterExpenseScreen extends StatefulWidget {
  const FilterExpenseScreen({
    required this.categoryId,
    this.initialFromMillis,
    this.initialToMillis,
    this.defaultToCurrentMonth = true,
    super.key,
  });

  final String categoryId;
  final int? initialFromMillis;
  final int? initialToMillis;
  final bool defaultToCurrentMonth;

  @override
  State<FilterExpenseScreen> createState() => _FilterExpenseScreenState();
}

class _FilterExpenseScreenState extends State<FilterExpenseScreen> {
  String? _selectedCategoryId;
  int? _fromMillis;
  int? _toMillis;
  bool _isAllTime = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId =
        widget.categoryId.isNotEmpty ? widget.categoryId : null;
    _fromMillis = widget.initialFromMillis;
    _toMillis = widget.initialToMillis;
    _isAllTime =
        !_shouldUseDefaultRange() && _fromMillis == null && _toMillis == null;

    // Delay to ensure providers are ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedCategoryId != null) {
        _dispatchFilter(initial: true);
      }
    });
  }

  bool _shouldUseDefaultRange() => widget.defaultToCurrentMonth;

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.filter_alt, size: 24),
          SizedBox(width: 8),
          Text('فیلتر هزینه‌ها'),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          _buildFilterControls(),
          Expanded(child: _buildBodyContent()),
        ],
      ),
    );
  }

  Widget _buildFilterControls() {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'تنظیمات فیلتر',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 12),
            CategoryDropdownWidget(
              value: _selectedCategoryId ?? '',
              onSelected: (selectedValue) {
                setState(() {
                  _selectedCategoryId =
                      selectedValue.isEmpty ? null : selectedValue;
                });
              },
              labelText: 'دسته‌بندی',
              isRequired: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DateChip(
                    label: 'از تاریخ',
                    value: _isAllTime ? '---' : _formatDate(_fromMillis),
                    onTap: _isAllTime ? null : _pickFromDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateChip(
                    label: 'تا تاریخ',
                    value:
                        _isAllTime ? '---' : _formatDate(_toMillis, end: true),
                    onTap: _isAllTime ? null : _pickToDate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _isAllTime,
                  onChanged: (value) {
                    setState(() {
                      _isAllTime = value ?? false;
                      if (_isAllTime) {
                        _fromMillis = null;
                        _toMillis = null;
                      }
                    });
                  },
                ),
                const Text('تمام دوره'),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _applyCurrentMonthPreset();
                      _isAllTime = false;
                    });
                  },
                  child: const Text('این ماه'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _applyRelativeDaysPreset(30);
                      _isAllTime = false;
                    });
                  },
                  child: const Text('۳۰ روز گذشته'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _applyFilters,
                icon: const Icon(Icons.playlist_add_check),
                label: const Text('اعمال فیلتر'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    return BlocConsumer<FilterExpneseBloc, FilterExpenseState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is FilterExpenseLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'در حال بارگذاری هزینه‌ها...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        } else if (state is FilterExpenseLoaded) {
          return _buildResults(state.expenses);
        } else if (state is FilterExpenseError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'خطا در بارگذاری',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _dispatchFilter(initial: true),
                  icon: const Icon(Icons.refresh),
                  label: const Text('تلاش مجدد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildResults(List<Expense> expenses) {
    final unit = context.read<GlobalBloc>().state.settings.unit;
    final totalAmount =
        expenses.fold<int>(0, (sum, expense) => sum + expense.price);
    final totalUsd =
        expenses.fold<double>(0, (sum, expense) => sum + expense.usdPrice);
    final categoryTitle = expenses.isNotEmpty
        ? (expenses.first.category?.title ?? 'نامشخص')
        : (_selectedCategoryId == null ? 'انتخاب نشده' : 'بدون نتیجه');
    final categoryColor = expenses.isNotEmpty
        ? (expenses.first.category?.color ?? '#000000')
        : '#1976D2';

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                HexColor(categoryColor).withOpacity(0.18),
                HexColor(categoryColor).withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: HexColor(categoryColor).withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                categoryTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _isAllTime
                    ? 'دوره زمانی: کل تاریخ'
                    : 'از ${_formatDate(_fromMillis)} تا ${_formatDate(_toMillis, end: true)}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'مجموع هزینه‌ها: ${formatPrice(totalAmount, unit)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              if (totalUsd > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'معادل دلاری: ${formatUsd(totalUsd)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('تعداد', '${expenses.length}', Icons.list_alt),
              _buildStatItem(
                'میانگین',
                expenses.isEmpty
                    ? '-'
                    : formatPrice(totalAmount ~/ expenses.length, unit),
                Icons.trending_up,
              ),
              _buildStatItem(
                'بیشترین',
                expenses.isEmpty
                    ? '-'
                    : formatPrice(_getMaxExpense(expenses), unit),
                Icons.arrow_upward,
              ),
              _buildStatItem(
                'جمع دلاری',
                totalUsd > 0 ? formatUsd(totalUsd) : '-',
                Icons.attach_money,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: expenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text('هزینه‌ای یافت نشد'),
                      const SizedBox(height: 8),
                      const Text(
                        'فیلترها را تغییر دهید و دوباره تلاش کنید',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: expenses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _buildExpenseCard(expenses[index], unit),
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  int _getMaxExpense(List<Expense> expenses) {
    return expenses.fold<int>(
      0,
      (max, expense) => expense.price > max ? expense.price : max,
    );
  }

  Widget _buildExpenseCard(Expense expense, int unit) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: HexColor(expense.category?.color ?? '#000000'),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(expense.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (expense.usdPrice > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        formatUsd(expense.usdPrice),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              formatPrice(expense.price, unit),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromDate() async {
    final initial = _fromMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(_fromMillis!)
        : DateTime.now();
    final picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.fromDateTime(initial),
      firstDate: Jalali(1380, 1),
      lastDate: Jalali(1500, 12),
    );
    if (picked != null) {
      setState(() {
        _fromMillis = _startOfDay(picked.toDateTime());
        if (_toMillis != null && _toMillis! <= _fromMillis!) {
          _toMillis = _startOfNextDay(picked.toDateTime());
        }
        _isAllTime = false;
      });
    }
  }

  Future<void> _pickToDate() async {
    final initial = _toMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(_toMillis!)
        : DateTime.now();
    final picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.fromDateTime(initial),
      firstDate: Jalali(1380, 1),
      lastDate: Jalali(1500, 12),
    );
    if (picked != null) {
      setState(() {
        _toMillis = _startOfNextDay(picked.toDateTime());
        if (_fromMillis != null && _toMillis! <= _fromMillis!) {
          _fromMillis = _startOfDay(
            picked.toDateTime().subtract(const Duration(days: 1)),
          );
        }
        _isAllTime = false;
      });
    }
  }

  void _applyCurrentMonthPreset() {
    final now = Jalali.now();
    final start = Jalali(now.year, now.month, 1);
    final end = start.addMonths(1);
    _fromMillis = start.toDateTime().millisecondsSinceEpoch;
    _toMillis = end.toDateTime().millisecondsSinceEpoch;
  }

  void _applyRelativeDaysPreset(int days) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    _fromMillis = _startOfDay(start);
    _toMillis = _startOfNextDay(now);
  }

  void _applyFilters() {
    if (_selectedCategoryId == null || _selectedCategoryId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً دسته‌بندی را انتخاب کنید')),
      );
      return;
    }

    final from = _isAllTime ? 0 : _fromMillis;
    final to = _isAllTime ? null : _toMillis;

    if (!_isAllTime && (from == null || to == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً بازه زمانی را مشخص کنید')),
      );
      return;
    }
    _dispatchFilter(
      categoryId: _selectedCategoryId!,
      from: from,
      to: to,
    );
  }

  void _dispatchFilter({
    bool initial = false,
    String? categoryId,
    int? from,
    int? to,
  }) {
    final id = categoryId ?? _selectedCategoryId;
    if (id == null || id.isEmpty) {
      if (!initial) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('دسته‌بندی نامعتبر است')),
        );
      }
      return;
    }
    final bloc = context.read<FilterExpneseBloc>();
    bloc.add(
      GetFilterExpenseEvent(
        categoryId: id,
        fromDateMillis: from ??
            (_isAllTime
                ? 0
                : (_fromMillis ??
                    (_shouldUseDefaultRange()
                        ? null
                        : DateTime.now()
                            .subtract(const Duration(days: 30))
                            .millisecondsSinceEpoch))),
        toDateMillis: to ?? (_isAllTime ? null : _toMillis),
      ),
    );
  }

  String _formatDate(int? millis, {bool end = false}) {
    if (millis == null) return '--/--/--';
    final dt = DateTime.fromMillisecondsSinceEpoch(
      end ? millis - const Duration(milliseconds: 1).inMilliseconds : millis,
    );
    final jalali = Jalali.fromDateTime(dt);
    return '${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}';
  }

  int _startOfDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day).millisecondsSinceEpoch;

  int _startOfNextDay(DateTime dt) => DateTime(dt.year, dt.month, dt.day)
      .add(const Duration(days: 1))
      .millisecondsSinceEpoch;
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: onTap == null ? Colors.grey[500] : Colors.grey[800],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.date_range,
                    size: 18,
                    color: Colors.grey[600],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
