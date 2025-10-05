import 'package:flutter/material.dart';

/// A generic dropdown widget that can be used for any type of data
/// with customizable item builders and styling.
class AppDropdownWidget<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String? labelText;
  final String? hintText;
  final String? Function(T)? itemToString;
  final Widget Function(T)? itemBuilder;
  final void Function(T?)? onChanged;
  final bool isRequired;
  final bool isError;
  final String? errorText;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool allowEmpty;
  final String? emptyText;
  final T? emptyValue;
  final InputDecoration? decoration;

  const AppDropdownWidget({
    required this.items,
    super.key,
    this.value,
    this.isRequired = false,
    this.isError = false,
    this.borderRadius = 16.0,
    this.allowEmpty = false,
    this.labelText,
    this.hintText,
    this.itemToString,
    this.itemBuilder,
    this.onChanged,
    this.errorText,
    this.contentPadding,
    this.emptyText,
    this.emptyValue,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    // Create the list of items, optionally adding an empty option
    final List<T?> allItems = [];

    if (allowEmpty) {
      allItems.add(emptyValue);
    }

    allItems.addAll(items);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText! + (isRequired ? ' *' : ''),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
        ],
        InputDecorator(
          decoration: decoration ??
              InputDecoration(
                contentPadding: contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(
                    color: isError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                errorText: errorText,
              ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T?>(
              value: value,
              hint: hintText != null ? Text(hintText!) : null,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              onChanged: onChanged,
              items: allItems.map<DropdownMenuItem<T?>>((T? item) {
                if (item == null || item == emptyValue) {
                  return DropdownMenuItem<T?>(
                    value: emptyValue,
                    child: Text(
                      emptyText ?? 'انتخاب کنید',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  );
                }

                return DropdownMenuItem<T?>(
                  value: item,
                  child: itemBuilder?.call(item) ??
                      Text(itemToString?.call(item) ?? item.toString()),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
