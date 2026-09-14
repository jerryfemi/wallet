import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/custom_sheet.dart';
import '../../domain/utils/auth_exception_mapper.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final hasSubmitted = useState(false);
    
    final authState = ref.watch(authControllerProvider);

    // Listen for errors
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
      if (!hasSubmitted.value) return;

      next.whenOrNull(
        error: (error, stackTrace) {
          hasSubmitted.value = false; // Reset on error
          final message = AuthExceptionMapper.mapException(error);
          CustomSheet.show(
            context,
            title: 'Registration Failed',
            message: message,
            type: CustomSheetType.error,
          );
        },
      );
    });

    void onRegister() {
      if (formKey.currentState!.validate()) {
        hasSubmitted.value = true;
        ref.read(authControllerProvider.notifier).signUp(
              emailController.text.trim(),
              passwordController.text,
              nameController.text.trim(),
            );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start your crypto journey with CryptoSim',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  AppTextField(
                    label: 'Display Name',
                    hint: 'Enter your full name',
                    controller: nameController,
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!val.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: 'Password',
                    hint: 'Create a password',
                    controller: passwordController,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (val.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (!val.contains(RegExp(r'[A-Z]')) || !val.contains(RegExp(r'[a-z]'))) {
                        return 'Must contain upper and lowercase letters';
                      }
                      if (!val.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return 'Must contain a special character';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Real-time Password Validation UI
                  HookBuilder(
                    builder: (context) {
                      final passwordText = useValueListenable(passwordController).text;
                      final hasMinLength = passwordText.length >= 8;
                      final hasUpperAndLower = passwordText.contains(RegExp(r'[A-Z]')) && passwordText.contains(RegExp(r'[a-z]'));
                      final hasSpecialChar = passwordText.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PasswordRequirement(text: 'At least 8 characters', isMet: hasMinLength),
                          const SizedBox(height: 8),
                          _PasswordRequirement(text: 'Upper and lowercase letters', isMet: hasUpperAndLower),
                          const SizedBox(height: 8),
                          _PasswordRequirement(text: 'Special character (e.g. @, #, !)', isMet: hasSpecialChar),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  AppButton(
                    text: 'Sign Up',
                    isLoading: authState.isLoading,
                    onPressed: onRegister,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
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
}

class _PasswordRequirement extends StatelessWidget {
  final String text;
  final bool isMet;

  const _PasswordRequirement({required this.text, required this.isMet});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isMet ? Colors.green : Colors.white38,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isMet ? Colors.green : Colors.white38,
            decoration: isMet ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}
