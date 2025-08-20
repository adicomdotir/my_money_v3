import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/template_bloc.dart';
import '../widgets/create_template_dialog.dart';
import '../widgets/template_filter_bar.dart';
import '../widgets/template_list_item.dart';

/// Example screen using BLoC pattern
class TemplateListScreen extends StatefulWidget {
  const TemplateListScreen({super.key});

  @override
  State<TemplateListScreen> createState() => _TemplateListScreenState();
}

class _TemplateListScreenState extends State<TemplateListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<TemplateBloc>().add(const LoadTemplateItemsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Feature'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<TemplateBloc>().add(
                                const SearchTemplateItemsEvent(query: ''),
                              );
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                context.read<TemplateBloc>().add(
                      SearchTemplateItemsEvent(query: value),
                    );
              },
            ),
          ),

          // Filter bar
          BlocBuilder<TemplateBloc, TemplateState>(
            buildWhen: (previous, current) =>
                current is TemplateLoaded &&
                previous is TemplateLoaded &&
                current.hasActiveFilter != previous.hasActiveFilter,
            builder: (context, state) {
              if (state is TemplateLoaded && state.hasActiveFilter) {
                return TemplateFilterBar(
                  fromDate: state.currentFromDate,
                  toDate: state.currentToDate,
                  isActive: state.currentIsActiveFilter,
                  onClearFilters: () {
                    context.read<TemplateBloc>().add(
                          const LoadTemplateItemsEvent(),
                        );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Main content
          Expanded(
            child: BlocConsumer<TemplateBloc, TemplateState>(
              listener: (context, state) {
                if (state is TemplateLoaded && state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                if (state is TemplateLoaded && state.lastCreatedItem != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Created: ${state.lastCreatedItem!.title}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is TemplateLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TemplateError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TemplateBloc>().add(
                                  const LoadTemplateItemsEvent(),
                                );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is TemplateLoaded) {
                  if (state.displayItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            state.isFiltered
                                ? Icons.filter_alt_off
                                : Icons.inbox,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.isFiltered
                                ? 'No items match your filters'
                                : 'No items yet',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          if (!state.isFiltered) ...[
                            const SizedBox(height: 8),
                            const Text('Tap + to create your first item'),
                          ],
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<TemplateBloc>().add(
                            const RefreshTemplateItemsEvent(),
                          );
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.displayItems.length,
                      itemBuilder: (context, index) {
                        final item = state.displayItems[index];
                        return TemplateListItem(
                          item: item,
                          onTap: () => _navigateToDetail(item.id),
                          onDelete: () => _confirmDelete(item.id),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterDialog() {
    // Show filter dialog implementation
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Items'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date range picker
            // Active status filter
            // Apply button
          ],
        ),
      ),
    );
  }

  void _showCreateDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateTemplateDialog(
        onSubmit: (title, description, amount) {
          context.read<TemplateBloc>().add(
                CreateTemplateItemEvent(
                  title: title,
                  description: description,
                  amount: amount,
                ),
              );
        },
      ),
    );
  }

  void _navigateToDetail(String id) {
    // Navigate to detail screen
    Navigator.pushNamed(context, '/template_detail', arguments: id);
  }

  void _confirmDelete(String id) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement delete functionality
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
