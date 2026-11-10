import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/features/auth/view/register_screen.dart';
import 'package:cospace_customer/features/auth/view_model/auth_cubit.dart';
import 'package:cospace_customer/features/auth/view_model/auth_state.dart';
import 'package:cospace_customer/features/auth/widgets/auth_form_fields.dart';
import 'package:cospace_customer/features/home/view/customer_home_screen.dart';
import 'package:cospace_customer/shared/custom_button.dart';

/// Login screen for existing customers.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const CustomerHomeScreen(),
              ),
            );
          } else if (state is AuthError) {
            context.showSnackBar(state.message, isError: true);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSizes.p24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.login,
                    style: TextStyle(
                      fontSize: AppFonts.heading1,
                      fontWeight: AppFonts.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSizes.v32),
                  AuthFormFields(
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),
                  SizedBox(height: AppSizes.v32),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: context.l10n.login,
                        isLoading: state is AuthLoading,
                        onPressed: _onLogin,
                      );
                    },
                  ),
                  SizedBox(height: AppSizes.v12),
                  // Skip / Demo Mode button
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeight,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const CustomerHomeScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(
                        context.l10n.skipLogin,
                        style: TextStyle(
                          fontSize: AppFonts.bodyMedium,
                          fontWeight: AppFonts.semiBold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.r12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.v16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(context.l10n.dontHaveAccount),
                    ),
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
