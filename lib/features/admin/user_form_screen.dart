import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/models/user_role.dart';
import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart' as db;

class UserFormScreen extends ConsumerStatefulWidget {
  final String? userId;

  const UserFormScreen({super.key, this.userId});

  @override
  ConsumerState<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends ConsumerState<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  UserRole _selectedRole = UserRole.mr;
  String _selectedTerritoryId = '';
  String _parentId = '';
  bool _isActive = true;
  bool _isLoading = false;
  bool _isEdit = false;
  bool _hasChanges = false;
  bool _obscurePassword = true;
  bool _createdSuccessfully = false;
  String? _createdEmail;
  String? _createdPassword;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.userId != null && widget.userId != 'new';
    if (_isEdit) _loadUser();
  }

  Future<void> _loadUser() async {
    final user =
        await ref.read(userRepositoryProvider).getUserById(widget.userId!);
    if (user != null && mounted) {
      setState(() {
        _nameCtrl.text = user.name;
        _emailCtrl.text = user.email;
        _phoneCtrl.text = user.phone;
        _selectedRole = UserRole.fromString(user.role);
        _selectedTerritoryId = user.territoryId;
        _parentId = user.parentId;
        _isActive = user.isActive;
        _hasChanges = false;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      String userId;

      if (_isEdit) {
        userId = widget.userId!;
      } else {
        userId = await _createFirebaseAuthAccount();
      }

      final companion = db.UsersCompanion(
        id: Value(userId),
        email: Value(_emailCtrl.text.trim()),
        name: Value(_nameCtrl.text.trim()),
        role: Value(_selectedRole.name),
        parentId: Value(_parentId),
        territoryId: Value(_selectedTerritoryId),
        isActive: Value(_isActive),
        phone: Value(_phoneCtrl.text.trim()),
        profileImageUrl: const Value(''),
      );

      await ref.read(userRepositoryProvider).upsertUser(companion);

      final currentUid = ref.read(authStateProvider).value?.uid ?? '';
      await ref.read(activityLogRepositoryProvider).log(
            userId: currentUid,
            action: _isEdit ? 'update_user' : 'create_user',
            entityType: 'user',
            entityId: userId,
            details:
                '${_isEdit ? 'Updated' : 'Created'} user ${_nameCtrl.text.trim()} (${_selectedRole.label})',
          );

      if (mounted) {
        if (_isEdit) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully')),
          );
          setState(() => _hasChanges = false);
          context.pop();
        } else {
          setState(() {
            _createdSuccessfully = true;
            _createdEmail = _emailCtrl.text.trim();
            _createdPassword = _passwordCtrl.text;
            _hasChanges = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${_friendlyError(e)}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<String> _createFirebaseAuthAccount() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    FirebaseApp? secondaryApp;
    try {
      secondaryApp = await Firebase.initializeApp(
        name: 'userCreation_${const Uuid().v4()}',
        options: Firebase.app().options,
      );
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
      final cred = await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;

      try {
        await cred.user!.updateDisplayName(_nameCtrl.text.trim());
      } catch (_) {}

      await secondaryAuth.signOut();
      return uid;
    } finally {
      if (secondaryApp != null) {
        try {
          await secondaryApp.delete();
        } catch (_) {}
      }
    }
  }

  String _friendlyError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'An account with this email already exists';
        case 'weak-password':
          return 'Password is too weak (min 6 characters)';
        case 'invalid-email':
          return 'Invalid email address';
        default:
          return 'Authentication error: ${e.message}';
      }
    }
    return 'Something went wrong. Please try again.';
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameCtrl.clear();
    _emailCtrl.clear();
    _phoneCtrl.clear();
    _passwordCtrl.clear();
    setState(() {
      _selectedRole = UserRole.mr;
      _selectedTerritoryId = '';
      _parentId = '';
      _isActive = true;
      _createdSuccessfully = false;
      _createdEmail = null;
      _createdPassword = null;
      _hasChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final territories = ref.watch(allTerritoriesProvider).value ?? [];
    final users = ref.watch(allUsersProvider).value ?? [];

    if (_createdSuccessfully) {
      return _buildSuccessScreen(theme);
    }

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final discard = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text('You have unsaved changes that will be lost.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Keep Editing'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Discard'),
              ),
            ],
          ),
        );
        if (discard == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_isEdit ? 'Edit User' : 'Create User')),
        body: SafeArea(
          child: ResponsiveCenter(
            padding: adaptivePadding(context),
            child: Form(
              key: _formKey,
              onChanged: () {
                if (!_hasChanges) setState(() => _hasChanges = true);
              },
              child: ListView(
                children: [
                  if (!_isEdit) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 20,
                              color: theme.colorScheme.onPrimaryContainer),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This will create a login account for the user. Share the credentials with them so they can sign in.',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Name required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !_isEdit,
                    validator: (v) => v == null || !v.contains('@')
                        ? 'Valid email required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  if (!_isEdit) ...[
                    TextFormField(
                      controller: _passwordCtrl,
                      decoration: InputDecoration(
                        labelText: 'Temporary Password',
                        prefixIcon: const Icon(Icons.lock),
                        helperText:
                            'The user can change this after their first login',
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password is required';
                        }
                        if (v.length < 6) {
                          return 'Min 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  DropdownButtonFormField<UserRole>(
                    value: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      prefixIcon: Icon(Icons.badge),
                    ),
                    items: UserRole.values
                        .map(
                          (r) => DropdownMenuItem(
                              value: r, child: Text(r.label)),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedRole = v);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedTerritoryId.isEmpty
                        ? null
                        : _selectedTerritoryId,
                    decoration: const InputDecoration(
                      labelText: 'Territory',
                      prefixIcon: Icon(Icons.map),
                    ),
                    items: [
                      const DropdownMenuItem(value: '', child: Text('None')),
                      ...territories.map(
                        (t) => DropdownMenuItem(
                            value: t.id, child: Text(t.name)),
                      ),
                    ],
                    onChanged: (v) =>
                        setState(() => _selectedTerritoryId = v ?? ''),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _parentId.isEmpty ? null : _parentId,
                    decoration: const InputDecoration(
                      labelText: 'Reports To',
                      prefixIcon: Icon(Icons.supervisor_account),
                    ),
                    items: [
                      const DropdownMenuItem(value: '', child: Text('None')),
                      ...users
                          .where((u) => u.id != widget.userId)
                          .map(
                            (u) => DropdownMenuItem(
                              value: u.id,
                              child: Text('${u.name} (${u.role})'),
                            ),
                          ),
                    ],
                    onChanged: (v) => setState(() => _parentId = v ?? ''),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Active'),
                    subtitle: const Text('Inactive users cannot log in'),
                    value: _isActive,
                    onChanged: (v) => setState(() {
                      _isActive = v;
                      _hasChanges = true;
                    }),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _save,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isEdit ? 'Update User' : 'Create User'),
                  ),
                  if (_isEdit) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _resetPassword,
                      icon: const Icon(Icons.lock_reset),
                      label: const Text('Send Password Reset Email'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessScreen(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Created')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: adaptiveFormMaxWidth(context)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle,
                      size: 80, color: Colors.green.shade400),
                  const SizedBox(height: 24),
                  Text(
                    'User Created Successfully!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share these login credentials with the new user:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _credentialRow(
                              theme, 'Name', _nameCtrl.text.trim()),
                          const Divider(height: 16),
                          _credentialRow(theme, 'Email', _createdEmail ?? ''),
                          const Divider(height: 16),
                          _credentialRow(
                              theme, 'Password', _createdPassword ?? ''),
                          const Divider(height: 16),
                          _credentialRow(
                              theme, 'Role', _selectedRole.label),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      final text =
                          'RxForce SFA Login\nEmail: $_createdEmail\nPassword: $_createdPassword\nRole: ${_selectedRole.label}';
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Credentials copied to clipboard')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Credentials'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetForm,
                          child: const Text('Create Another'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => context.pop(),
                          child: const Text('Done'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _credentialRow(ThemeData theme, String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant)),
        ),
        Expanded(
          child: Text(value,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Future<void> _resetPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent to $email')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send reset email')),
        );
      }
    }
  }
}
