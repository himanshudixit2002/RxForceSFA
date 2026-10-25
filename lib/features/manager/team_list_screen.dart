import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class TeamListScreen extends ConsumerWidget {
  const TeamListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(teamMembersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Team')),
      body: SafeArea(
        child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: adaptiveMaxWidth(context)),
          child: teamAsync.when(
            data: (members) {
              if (members.isEmpty) {
                return const EmptyState(
                  icon: Icons.people_outline,
                  title: 'No team members',
                  subtitle: 'Team members assigned to you will appear here',
                );
              }
              return ListView.builder(
                padding: adaptivePadding(context),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final m = members[index];
                  return _TeamMemberCard(member: m);
                },
              );
            },
            loading: () => const ShimmerLoading(itemCount: 8),
            error: (e, _) => ErrorRetryCard(
              message: 'Failed to load team: $e',
              onRetry: () => ref.invalidate(teamMembersProvider),
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class _TeamMemberCard extends StatelessWidget {
  final User member;
  const _TeamMemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
            style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          ),
        ),
        title: Text(member.name),
        subtitle: Text(member.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: member.isActive
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                member.isActive ? 'Active' : 'Inactive',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: member.isActive
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => context.push('/manager/team/${member.id}'),
      ),
    );
  }
}
