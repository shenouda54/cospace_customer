import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_icons.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/shared/custom_text_field.dart';

/// Reusable form fields for login and register screens.
class AuthFormFields extends StatelessWidget {
  const AuthFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.fullNameController,
    this.phoneController,
    this.isRegister = false,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? fullNameController;
  final TextEditingController? phoneController;
  final bool isRegister;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isRegister) ...[
          CustomTextField(
            controller: fullNameController!,
            hintText: context.l10n.fullName,
            prefixIcon: AppIcons.person,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: AppSizes.v16),
        ],
        CustomTextField(
          controller: emailController,
          hintText: context.l10n.email,
          prefixIcon: AppIcons.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: AppSizes.v16),
        CustomTextField(
          controller: passwordController,
          hintText: context.l10n.password,
          prefixIcon: AppIcons.lock,
          obscureText: true,
          textInputAction:
              isRegister ? TextInputAction.next : TextInputAction.done,
        ),
        if (isRegister) ...[
          SizedBox(height: AppSizes.v16),
          CustomTextField(
            controller: phoneController!,
            hintText: context.l10n.phoneNumber,
            prefixIcon: AppIcons.phone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
          ),
        ],
      ],
    );
  }
}
