import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget to display active filters
class TemplateFilterBar extends StatelessWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool? isActive;
  final VoidCallback onClearFilters;

  const TemplateFilterBar({
    required this.onClearFilters,
    super.key,
    this.fromDate,
    this.toDate,
    this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatDate = DateFormat('MMM dd, yyyy');
    final activeFilters = <Widget>[];

    // Date range filter chip
    if (fromDate != null || toDate != null) {
      String dateText = '';
      if (fromDate != null && toDate != null) {
        dateText =
            '${formatDate.format(fromDate!)} - ${formatDate.format(toDate!)}';
      } else if (fromDate != null) {
        dateText = 'From ${formatDate.format(fromDate!)}';
      } else if (toDate != null) {
        dateText = 'Until ${formatDate.format(toDate!)}';
      }

      activeFilters.add(
        Chip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.date_range, size: 16),
              const SizedBox(width: 4),
              Text(dateText),
            ],
          ),
          onDeleted: onClearFilters,
          backgroundColor: theme.colorScheme.primaryContainer,
          deleteIconColor: theme.colorScheme.onPrimaryContainer,
        ),
      );
    }

    // Active status filter chip
    if (isActive != null) {
      activeFilters.add(
        Chip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive! ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: isActive! ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(isActive! ? 'Active' : 'Inactive'),
            ],
          ),
          onDeleted: onClearFilters,
          backgroundColor: theme.colorScheme.secondaryContainer,
          deleteIconColor: theme.colorScheme.onSecondaryContainer,
        ),
      );
    }

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active Filters:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Clear All'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: activeFilters,
          ),
        ],
      ),
    );
  }
}
