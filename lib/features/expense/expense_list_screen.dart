import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _expensesProvider = StreamProvider<List<Expense>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value([]);
  return ref.watch(expenseRepositoryProvider).watchByMr(uid);
});

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  String? _selectedCategory;

  void _showExpenseDetail(BuildContext context, Expense expense) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, controller) => Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('Expense Details', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _infoRow(theme, 'Amount', '\u20B9${expense.amount.toStringAsFixed(2)}'),
              _infoRow(theme, 'Category', expense.category.name[0].toUpperCase() + expense.category.name.substring(1)),
              _infoRow(theme, 'Date', DateFormat.yMMMMd().format(expense.date)),
              _infoRow(theme, 'Status', expense.isApproved ? 'Approved' : 'Pending'),
              if (expense.warningFlag)
                _infoRow(theme, 'Warning', 'Flagged for review'),
              if (expense.receiptImagePath != null && expense.receiptImagePath!.isNotEmpty)
                _infoRow(theme, 'Receipt', 'Attached'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expensesAsync = ref.watch(_expensesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Expense History')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/expense/capture'),
        icon: const Icon(Icons.receipt),
        label: const Text('New Expense'),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedCategory == null,
                      onSelected: (_) => setState(() => _selectedCategory = null),
                    ),
                    const SizedBox(width: 8),
                    ...ExpenseCategory.values.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(c.name[0].toUpperCase() + c.name.substring(1)),
                          selected: _selectedCategory == c.name,
                          onSelected: (_) => setState(() => _selectedCategory = c.name),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => ref.invalidate(_expensesProvider),
                  child: expensesAsync.when(
                    data: (expenses) {
                      final filtered = _selectedCategory == null
                          ? expenses
                          : expenses.where((e) => e.category.name == _selectedCategory).toList();
                      if (filtered.isEmpty) {
                        return CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: const EmptyState(
                                icon: Icons.receipt_long_outlined,
                                title: 'No expenses recorded',
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final e = filtered[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: e.warningFlag
                                    ? Colors.red.withValues(alpha: 0.15)
                                    : theme.colorScheme.secondaryContainer,
                                child: Icon(
                                  Icons.receipt,
                                  color: e.warningFlag ? Colors.red : theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                              title: Text('\u20B9${e.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  '${DateFormat.yMMMd().format(e.date)} \u2022 ${e.category.name}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (e.warningFlag)
                                    const Icon(Icons.warning, color: Colors.orange, size: 18),
                                  const SizedBox(width: 4),
                                  Icon(
                                    e.isApproved ? Icons.check_circle : Icons.pending,
                                    color: e.isApproved ? Colors.green : Colors.grey,
                                    size: 18,
                                  ),
                                ],
                              ),
                              onTap: () => _showExpenseDetail(context, e),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const ShimmerLoading(),
                    error: (e, _) => CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: ErrorRetryCard(
                            message: e.toString(),
                            onRetry: () => ref.invalidate(_expensesProvider),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
