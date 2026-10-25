import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/user_role.dart';
import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  String _searchQuery = '';
  String? _roleFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Add User',
            onPressed: () => context.go('/admin/users/new'),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: Column(
            children: [
              _buildFilters(theme),
              const SizedBox(height: 16),
              Expanded(
                child: usersAsync.when(
                  data: (users) {
                    var filtered = users;
                    if (_searchQuery.isNotEmpty) {
                      final q = _searchQuery.toLowerCase();
                      filtered = filtered
                          .where((u) =>
                              u.name.toLowerCase().contains(q) ||
                              u.email.toLowerCase().contains(q))
                          .toList();
                    }
                    if (_roleFilter != null) {
                      filtered = filtered
                          .where((u) => u.role == _roleFilter)
                          .toList();
                    }
                    if (filtered.isEmpty) {
                      return const EmptyState(
                        icon: Icons.people_outline,
                        title: 'No users found',
                      );
                    }
                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) =>
                          _buildUserCard(context, filtered[i]),
                    );
                  },
                  loading: () => const ShimmerLoading(),
                  error: (e, _) => ErrorRetryCard(
                    message: e.toString(),
                    onRetry: () => ref.invalidate(allUsersProvider),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ),
        const SizedBox(width: 12),
        DropdownButton<String?>(
          value: _roleFilter,
          hint: const Text('All Roles'),
          items: [
            const DropdownMenuItem(value: null, child: Text('All Roles')),
            ...UserRole.values.map((r) =>
                DropdownMenuItem(value: r.name, child: Text(r.label))),
          ],
          onChanged: (v) => setState(() => _roleFilter = v),
        ),
      ],
    );
  }

  Widget _buildUserCard(BuildContext context, dynamic user) {
    final role = UserRole.fromString(user.role);
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          ),
        ),
        title: Text(user.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${user.email} \u2022 ${role.label}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: user.isActive
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                user.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 12,
                  color: user.isActive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => context.go('/admin/users/${user.id}'),
      ),
    );
  }
}
