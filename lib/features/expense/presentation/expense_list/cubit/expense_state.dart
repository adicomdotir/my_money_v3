part of 'expense_cubit.dart';

class ExpenseState extends Equatable {
  final List<Expense>? expenses;
  final int? calenderFilterType;
  final Jalali? fromDate;
  final Jalali? toDate;
  final bool? loading;
  final String? error;

  const ExpenseState({
    this.calenderFilterType,
    this.expenses,
    this.loading,
    this.error,
    this.fromDate,
    this.toDate,
  });

  ExpenseState copyWith({
    List<Expense>? expenses,
    int? calenderFilterType,
    bool? loading,
    String? error,
    Jalali? fromDate,
    Jalali? toDate,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      error: error ?? this.error,
      loading: loading ?? this.loading,
      calenderFilterType: calenderFilterType ?? this.calenderFilterType,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object> get props => [
        expenses ?? [],
        calenderFilterType ?? 0,
        loading ?? false,
        error ?? '',
        fromDate ?? Jalali.now(),
        toDate ?? Jalali.now(),
      ];
}
