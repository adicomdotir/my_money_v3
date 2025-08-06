import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/template_entity.dart';

/// Reusable list item widget
class TemplateListItem extends StatelessWidget {
  final TemplateEntity item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TemplateListItem({
    required this.item,
    super.key,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatDate = DateFormat('yyyy/MM/dd HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Status indicator
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Title
                  Expanded(
                    child: Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration:
                            item.isActive ? null : TextDecoration.lineThrough,
                      ),
                    ),
                  ),

                  // Amount if exists
                  if (item.hasAmount) ...[
                    Text(
                      '\$${item.amount!.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],

                  // Delete button
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: onDelete,
                      color: Colors.red,
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                item.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Date and metadata
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatDate.format(item.createdAt),
                    style: theme.textTheme.bodySmall,
                  ),
                  if (item.updatedAt != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.update,
                      size: 14,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatDate.format(item.updatedAt!),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),

              // Metadata tags
              if (item.metadata != null && item.metadata!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: item.metadata!.entries
                      .take(3)
                      .map(
                        (entry) => Chip(
                          label: Text(
                            '${entry.key}: ${entry.value}',
                            style: theme.textTheme.labelSmall,
                          ),
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
