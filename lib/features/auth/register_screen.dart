import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' as drift;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/services/sync_service.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart' as db;

final _emailRegex = RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,}$');

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _orgNameCtrl = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _error;

  bool _checkingFirstUser = true;
  bool _isFirstUser = false;

  @override
  void initState() {
    super.initState();
    _checkIfFirstUser();
  }

  Future<void> _checkIfFirstUser() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .limit(1)
          .get();
      if (mounted) {
        setState(() {
          _isFirstUser = snap.docs.isEmpty;
          _checkingFirstUser = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _checkingFirstUser = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _orgNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final cred = await ref
          .read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          );

      final user = cred.user;
      if (user == null) throw Exception('User creation failed');

      final name = _nameCtrl.text.trim();
      final email = _emailCtrl.text.trim();
      final phone = _phoneCtrl.text.trim();
      final role = _isFirstUser ? 'admin' : 'mr';

      try {
        await user.updateDisplayName(name);
      } catch (_) {}

      final userData = {
        'id': user.uid,
        'email': email,
        'name': name,
        'role': role,
        'parentId': '',
        'territoryId': '',
        'isActive': true,
        'phone': phone,
        'profileImageUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));

      if (_isFirstUser) {
        if (_orgNameCtrl.text.trim().isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('settings')
              .doc('organization')
              .set({
            'name': _orgNameCtrl.text.trim(),
            'createdBy': user.uid,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }

        await _seedAdminDefaults(user.uid);
      }

      if (!kIsWeb) {
        try {
          await ref.read(userRepositoryProvider).insertLocalOnly(
                db.UsersCompanion(
                  id: drift.Value(user.uid),
                  email: drift.Value(email),
                  name: drift.Value(name),
                  role: drift.Value(role),
                  parentId: const drift.Value(''),
                  territoryId: const drift.Value(''),
                  isActive: const drift.Value(true),
                  phone: drift.Value(phone),
                  profileImageUrl: const drift.Value(''),
                ),
              );
        } catch (_) {}
        try {
          await SyncService.performSync();
        } catch (_) {}
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isFirstUser
                ? 'Admin account created! Welcome aboard.'
                : 'Account created successfully'),
          ),
        );
        context.go('/');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _friendlyAuthError(e.code));
    } catch (e) {
      setState(() => _error = 'Registration failed. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _seedAdminDefaults(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    final defaultTerritory = firestore.collection('territories').doc();
    batch.set(defaultTerritory, {
      'name': 'Head Office',
      'parentId': '',
      'level': 0,
      'boundaries': '{}',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    batch.update(firestore.collection('users').doc(uid), {
      'territoryId': defaultTerritory.id,
    });

    final leaveTypes = ['casual', 'sick', 'earned', 'compensatory'];
    for (final type in leaveTypes) {
      final balDoc = firestore.collection('leaveBalances').doc();
      batch.set(balDoc, {
        'mrId': uid,
        'leaveType': leaveTypes.indexOf(type),
        'total': type == 'casual' ? 12 : type == 'sick' ? 12 : type == 'earned' ? 15 : 5,
        'used': 0,
        'remaining': type == 'casual' ? 12 : type == 'sick' ? 12 : type == 'earned' ? 15 : 5,
        'year': DateTime.now().year,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    try {
      await batch.commit();
    } catch (_) {}
  }

  String _friendlyAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      default:
        return 'Registration failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_checkingFirstUser) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Setting up...', style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isFirstUser ? 'Setup Organization' : 'Create Account'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: adaptiveFormMaxWidth(context)),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isFirstUser) ...[
                      Icon(Icons.admin_panel_settings,
                          size: 64, color: theme.colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome to RxForce SFA',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You are the first user. This account will become the organization administrator.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
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
                                'As admin, you can create team members, assign roles, manage territories, and more.',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Join RxForce SFA',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your account to get started',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 32),
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                size: 20,
                                color: theme.colorScheme.onErrorContainer),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
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
                    if (_isFirstUser) ...[
                      TextFormField(
                        controller: _orgNameCtrl,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Organization Name',
                          prefixIcon: Icon(Icons.business),
                          helperText: 'e.g. PharmaCorp India Pvt Ltd',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Organization name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _nameCtrl,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!_emailRegex.hasMatch(v.trim())) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _register(),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      validator: (v) {
                        if (v != _passwordCtrl.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _loading ? null : _register,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isFirstUser
                              ? 'Create Admin Account'
                              : 'Create Account'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
