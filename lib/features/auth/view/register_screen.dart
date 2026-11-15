import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/features/auth/view_model/auth_cubit.dart';
import 'package:cospace_customer/features/auth/view_model/auth_state.dart';
import 'package:cospace_customer/features/auth/widgets/auth_form_fields.dart';
import 'package:cospace_customer/shared/custom_button.dart';

/// Registration screen for new customers.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phoneNumber: _phoneController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: AppSizes.p24,
            vertical: AppSizes.v48,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.register,
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
                  fullNameController: _fullNameController,
                  phoneController: _phoneController,
                  isRegister: true,
                  onSubmit: _onRegister,
                ),
                SizedBox(height: AppSizes.v32),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: context.l10n.register,
                      isLoading: state is AuthLoading,
                      onPressed: _onRegister,
                    );
                  },
                ),
                SizedBox(height: AppSizes.v16),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(context.l10n.alreadyHaveAccount),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
