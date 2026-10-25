import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/platform_image.dart';

const _categoryIcons = <ExpenseCategory, IconData>{
  ExpenseCategory.meal: Icons.restaurant,
  ExpenseCategory.travel: Icons.directions_car,
  ExpenseCategory.accommodation: Icons.hotel,
  ExpenseCategory.other: Icons.category,
};

class ExpenseReviewScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> extractedData;
  const ExpenseReviewScreen({super.key, required this.extractedData});

  @override
  ConsumerState<ExpenseReviewScreen> createState() =>
      _ExpenseReviewScreenState();
}

class _ExpenseReviewScreenState extends ConsumerState<ExpenseReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountCtrl;
  ExpenseCategory _category = ExpenseCategory.meal;
  DateTime _expenseDate = DateTime.now();
  bool _isSaving = false;
  double _maxAllowance = AppConstants.defaultMaxMealAllowance;
  bool _exceedsAllowance = false;
  Timer? _debounce;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    final extractedAmount = widget.extractedData['amount'] as double?;
    _amountCtrl = TextEditingController(
      text: extractedAmount?.toStringAsFixed(2) ?? '',
    );
    final dateStr = widget.extractedData['date'] as String?;
    if (dateStr != null) {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null && !parsed.isAfter(DateTime.now())) {
        _expenseDate = parsed;
      }
    }
    _amountCtrl.addListener(_markDirty);
    _fetchAllowance();
    _checkAllowance();
  }

  void _markDirty() {
    if (!_hasUnsavedChanges) setState(() => _hasUnsavedChanges = true);
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved expense data. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Discard')),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _fetchAllowance() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setDefaults({
        AppConstants.settingMaxMealAllowance:
            AppConstants.defaultMaxMealAllowance,
      });
      await remoteConfig.fetchAndActivate();
      if (!mounted) return;
      setState(() {
        _maxAllowance = remoteConfig.getDouble(
          AppConstants.settingMaxMealAllowance,
        );
      });
      _checkAllowance();
    } catch (_) {
      // Fallback to default
    }
  }

  void _debouncedCheckAllowance() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _checkAllowance);
  }

  void _checkAllowance() {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    setState(() {
      _exceedsAllowance =
          _category == ExpenseCategory.meal && amount > _maxAllowance;
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expenseDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => _expenseDate = date);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_exceedsAllowance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Warning: Amount exceeds daily meal allowance of Rs. ${_maxAllowance.toStringAsFixed(0)}',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }

    setState(() => _isSaving = true);

    try {
      final user = ref.read(authStateProvider).value;
      final expenseRepo = ref.read(expenseRepositoryProvider);
      final storageService = ref.read(storageServiceProvider);
      final userId = user?.uid ?? '';
      final expenseId = const Uuid().v4();

      String? receiptPath = widget.extractedData['imagePath'] as String?;

      if (receiptPath != null &&
          receiptPath.isNotEmpty &&
          !StorageService.isDownloadUrl(receiptPath)) {
        try {
          final downloadUrl = await storageService.uploadReceiptImage(
            userId: userId,
            expenseId: expenseId,
            localPath: receiptPath,
          );
          receiptPath = downloadUrl;
        } catch (e) {
          debugPrint('Receipt upload failed, saving with local path: $e');
        }
      }

      final expense = Expense(
        id: expenseId,
        amount: double.tryParse(_amountCtrl.text) ?? 0,
        date: _expenseDate,
        category: _category,
        receiptImagePath: receiptPath,
        isApproved: false,
        warningFlag: _exceedsAllowance,
        createdAt: DateTime.now(),
        mrId: userId,
      );

      await expenseRepo.save(expense);

      await ref.read(activityLogRepositoryProvider).log(
            userId: userId,
            action: 'submit_expense',
            entityType: 'expense',
            entityId: expense.id,
            details: 'Expense submitted: ${_category.name}, amount: ${expense.amount}',
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense saved successfully')),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Something went wrong. Please try again.')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _amountCtrl.removeListener(_markDirty);
    _amountCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rawText = widget.extractedData['rawText'] as String? ?? '';
    final imagePath = widget.extractedData['imagePath'] as String?;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
      appBar: AppBar(title: const Text('Review Expense')),
      body: SafeArea(
        child: ResponsiveBuilder(
          builder: (context, screenType) {
            if (screenType != ScreenType.compact && imagePath != null) {
              return _buildWideLayout(theme, imagePath, rawText);
            }
            return _buildFormContent(theme, imagePath, rawText);
          },
        ),
      ),
    ));
  }

  Widget _buildWideLayout(
      ThemeData theme, String? imagePath, String rawText) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: adaptiveMaxWidth(context)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null)
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _showFullImage(context, imagePath),
                        child: PlatformImage(
                          path: imagePath,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      if (rawText.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Extracted Text',
                                  style: theme.textTheme.labelMedium
                                      ?.copyWith(
                                    color: theme
                                        .colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  rawText,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            const VerticalDivider(width: 1),
            Expanded(
              flex: 3,
              child: _buildFormOnly(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(
      ThemeData theme, String? imagePath, String rawText) {
    return SingleChildScrollView(
      padding: adaptivePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: adaptiveFormMaxWidth(context),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (imagePath != null) ...[
                  GestureDetector(
                    onTap: () => _showFullImage(context, imagePath),
                    child: SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: PlatformImage(
                        path: imagePath,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (rawText.isNotEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Extracted Text',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            rawText,
                            style: theme.textTheme.bodySmall,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                ..._formFields(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormOnly(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _formFields(theme),
        ),
      ),
    );
  }

  List<Widget> _formFields(ThemeData theme) {
    return [
              if (_exceedsAllowance) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Amount exceeds daily meal allowance of Rs. ${_maxAllowance.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount (Rs.)',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                onChanged: (_) => _debouncedCheckAllowance(),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Amount is required';
                  final num = double.tryParse(v);
                  if (num == null) return 'Enter a valid number';
                  if (num <= 0) return 'Amount must be greater than zero';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ExpenseCategory>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: ExpenseCategory.values.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        Icon(_categoryIcons[c] ?? Icons.category, size: 20),
                        const SizedBox(width: 8),
                        Text(c.name[0].toUpperCase() + c.name.substring(1)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _category = v);
                    _checkAllowance();
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_month),
                title: Text(
                  'Date: ${DateFormat.yMMMd().format(_expenseDate)}',
                ),
                trailing: TextButton(
                  onPressed: _pickDate,
                  child: const Text('Change'),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Save Expense'),
              ),
    ];
  }

  void _showFullImage(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          child: PlatformImage(path: path, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
