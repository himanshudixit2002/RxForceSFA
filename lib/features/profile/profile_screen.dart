import 'package:drift/drift.dart' hide Column;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/user_role.dart';
import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart' as db;
import '../../presentation/widgets/shimmer_loading.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _editing = false;
  bool _saving = false;
  bool _loaded = false;

  void _populateFields(db.User user) {
    if (_loaded) return;
    _nameCtrl.text = user.name;
    _phoneCtrl.text = user.phone;
    _loaded = true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(db.User current) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      await ref.read(userRepositoryProvider).upsertUser(
            db.UsersCompanion(
              id: Value(current.id),
              email: Value(current.email),
              name: Value(_nameCtrl.text.trim()),
              role: Value(current.role),
              parentId: Value(current.parentId),
              territoryId: Value(current.territoryId),
              isActive: Value(current.isActive),
              phone: Value(_phoneCtrl.text.trim()),
              profileImageUrl: Value(current.profileImageUrl),
            ),
          );

      try {
        await FirebaseAuth.instance.currentUser
            ?.updateDisplayName(_nameCtrl.text.trim());
      } catch (_) {}

      ref.invalidate(currentUserProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
        setState(() => _editing = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to update profile. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _changePassword() async {
    final currentPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPassCtrl,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Current Password'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: newPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (v.length < 6) return 'Min 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirmPassCtrl,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm New Password'),
                validator: (v) {
                  if (v != newPassCtrl.text) return 'Passwords do not match';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null || user.email == null) return;

        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassCtrl.text,
        );
        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(newPassCtrl.text);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully')),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          final msg = e.code == 'wrong-password'
              ? 'Current password is incorrect'
              : 'Failed to change password';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        }
      }
    }

    currentPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(currentUserProfileProvider);
    final role = ref.watch(currentUserRoleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (!_editing)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Profile',
              onPressed: () => setState(() => _editing = true),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: adaptiveFormMaxWidth(context)),
            child: profileAsync.when(
              loading: () => const ShimmerLoading(itemCount: 5),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,
                        size: 48, color: theme.colorScheme.error),
                    const SizedBox(height: 12),
                    const Text('Failed to load profile'),
                    const SizedBox(height: 8),
                    FilledButton.tonalIcon(
                      onPressed: () =>
                          ref.invalidate(currentUserProfileProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (profile) {
                if (profile == null) {
                  return const Center(child: Text('Profile not found'));
                }
                _populateFields(profile);

                if (_editing) {
                  return _buildEditForm(theme, profile);
                }
                return _buildProfileView(theme, profile, role);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView(ThemeData theme, db.User profile, UserRole role) {
    final initials = profile.name
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              initials,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              role.label,
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _infoTile(theme, Icons.email, 'Email', profile.email),
                  const Divider(height: 24),
                  _infoTile(theme, Icons.phone, 'Phone',
                      profile.phone.isEmpty ? 'Not set' : profile.phone),
                  const Divider(height: 24),
                  _infoTile(
                      theme,
                      Icons.calendar_today,
                      'Member Since',
                      _formatDate(profile.createdAt)),
                  if (profile.territoryId.isNotEmpty) ...[
                    const Divider(height: 24),
                    _infoTile(theme, Icons.map, 'Territory ID',
                        profile.territoryId),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _changePassword,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(ThemeData theme, db.User profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: profile.email,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: UserRole.fromString(profile.role).label,
              decoration: const InputDecoration(
                labelText: 'Role',
                prefixIcon: Icon(Icons.badge),
              ),
              enabled: false,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _nameCtrl.text = profile.name;
                      _phoneCtrl.text = profile.phone;
                      setState(() => _editing = false);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : () => _save(profile),
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(
      ThemeData theme, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(value,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
