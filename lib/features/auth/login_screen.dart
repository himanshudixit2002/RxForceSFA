import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' as drift;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/services/sync_service.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart' as db;

final _emailRegex = RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,}$');

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  bool _resetLoading = false;
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final cred = await ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          );
      if (cred.user != null) {
        await _fetchAndStoreProfile(cred.user!.uid);
        await SyncService.performSync();
      }
      if (mounted) context.go('/');
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _friendlyAuthError(e.code));
    } catch (e) {
      setState(() => _error = 'Login failed. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    if (_resetLoading) return;
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !_emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email address first')),
      );
      return;
    }

    setState(() => _resetLoading = true);
    try {
      await ref
          .read(firebaseAuthProvider)
          .sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent to $email')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_friendlyAuthError(e.code))),
        );
      }
    } finally {
      if (mounted) setState(() => _resetLoading = false);
    }
  }

  Future<void> _fetchAndStoreProfile(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('users').doc(uid);
      final doc = await docRef.get();

      String email;
      String name;
      String role;
      String parentId;
      String territoryId;
      bool isActive;
      String phone;
      String profileImageUrl;

      if (doc.exists) {
        final d = doc.data()!;
        email = d['email'] as String? ?? '';
        name = d['name'] as String? ?? '';
        role = d['role'] as String? ?? 'mr';
        parentId = d['parentId'] as String? ?? '';
        territoryId = d['territoryId'] as String? ?? '';
        isActive = d['isActive'] as bool? ?? true;
        phone = d['phone'] as String? ?? '';
        profileImageUrl = d['profileImageUrl'] as String? ?? '';
      } else {
        final authUser = ref.read(firebaseAuthProvider).currentUser;
        email = authUser?.email ?? '';
        name = authUser?.displayName ?? '';
        role = 'mr';
        parentId = '';
        territoryId = '';
        isActive = true;
        phone = '';
        profileImageUrl = '';

        await docRef.set({
          'id': uid,
          'email': email,
          'name': name,
          'role': role,
          'parentId': parentId,
          'territoryId': territoryId,
          'isActive': isActive,
          'phone': phone,
          'profileImageUrl': profileImageUrl,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await ref.read(userRepositoryProvider).insertLocalOnly(
            db.UsersCompanion(
              id: drift.Value(uid),
              email: drift.Value(email),
              name: drift.Value(name),
              role: drift.Value(role),
              parentId: drift.Value(parentId),
              territoryId: drift.Value(territoryId),
              isActive: drift.Value(isActive),
              phone: drift.Value(phone),
              profileImageUrl: drift.Value(profileImageUrl),
            ),
          );
    } catch (_) {
      // Profile fetch failed -- will use defaults until next sync
    }
  }

  String _friendlyAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: adaptiveFormMaxWidth(context)),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'RxForce SFA',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
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
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: Semantics(
                          label: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          child: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password is required';
                        }
                        if (v.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _resetLoading ? null : _forgotPassword,
                        child: _resetLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            : const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: _loading ? null : _login,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign In'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => context.go('/register'),
                          child: const Text('Sign Up'),
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
