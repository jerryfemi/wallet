import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/custom_sheet.dart';
import '../../domain/utils/auth_exception_mapper.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends HookConsumerWidget {
  final String? initialEmail;
  const ForgotPasswordScreen({super.key, required this.initialEmail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController(text: initialEmail);
    final isLoading = useState(false);

    Future<void> onResetPassword() async {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;

        try {
          final authRepo = ref.read(authRepositoryProvider);
          await authRepo.sendPasswordResetEmail(emailController.text.trim());

          if (context.mounted) {
            await CustomSheet.show(
              context,
              title: 'Check Your Inbox',
              message: 'We\'ve sent a password reset link to ${emailController.text.trim()}.\nPlease check your spam folder if you don\'t see it.',
              type: CustomSheetType.success,
            );
            
            if (context.mounted) {
              context.pop();
            }
          }
        } catch (e) {
          if (context.mounted) {
            final message = AuthExceptionMapper.mapException(e);
            CustomSheet.show(
              context,
              title: 'Reset Failed',
              message: message,
              type: CustomSheetType.error,
            );
          }
        } finally {
          if (context.mounted) {
            isLoading.value = false;
          }
        }
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
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your email address and we will send you a link to reset your password.',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 40),
                  AppTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/icons/email.svg',
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onSurfaceVariant,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
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
                  const SizedBox(height: 40),
                  AppButton(
                    text: 'Send Reset Link',
                    isLoading: isLoading.value,
                    onPressed: onResetPassword,
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
