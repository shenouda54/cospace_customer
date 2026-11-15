import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_icons.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/core/utils/extensions/string_extensions.dart';
import 'package:cospace_customer/shared/custom_text_field.dart';

/// Reusable form fields for login and register screens.
class AuthFormFields extends StatefulWidget {
  const AuthFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.fullNameController,
    this.phoneController,
    this.isRegister = false,
    this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? fullNameController;
  final TextEditingController? phoneController;
  final bool isRegister;
  final VoidCallback? onSubmit;

  @override
  State<AuthFormFields> createState() => _AuthFormFieldsState();
}

class _AuthFormFieldsState extends State<AuthFormFields> {
  bool _obscurePassword = true;

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.fieldRequired;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.isRegister) ...[
          CustomTextField(
            controller: widget.fullNameController!,
            hintText: context.l10n.fullName,
            prefixIcon: AppIcons.person,
            textInputAction: TextInputAction.next,
            validator: _required,
          ),
          SizedBox(height: AppSizes.v16),
        ],
        CustomTextField(
          controller: widget.emailController,
          hintText: context.l10n.email,
          prefixIcon: AppIcons.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            final requiredError = _required(value);
            if (requiredError != null) return requiredError;
            if (!value!.trim().isValidEmail) {
              return context.l10n.invalidEmail;
            }
            return null;
          },
        ),
        SizedBox(height: AppSizes.v16),
        CustomTextField(
          controller: widget.passwordController,
          hintText: context.l10n.password,
          prefixIcon: AppIcons.lock,
          obscureText: _obscurePassword,
          textInputAction:
              widget.isRegister ? TextInputAction.next : TextInputAction.done,
          onFieldSubmitted: widget.isRegister ? null : (_) => widget.onSubmit?.call(),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            icon: Icon(
              _obscurePassword ? AppIcons.visibilityOff : AppIcons.visibility,
              size: AppSizes.iconMedium,
            ),
          ),
          validator: (value) {
            final requiredError = _required(value);
            if (requiredError != null) return requiredError;
            if (!value!.isValidPassword) {
              return context.l10n.invalidPassword;
            }
            return null;
          },
        ),
        if (widget.isRegister) ...[
          SizedBox(height: AppSizes.v16),
          CustomTextField(
            controller: widget.phoneController!,
            hintText: context.l10n.phoneNumber,
            prefixIcon: AppIcons.phone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => widget.onSubmit?.call(),
            validator: (value) {
              final requiredError = _required(value);
              if (requiredError != null) return requiredError;
              if (!value!.trim().isValidPhone) {
                return context.l10n.invalidPhone;
              }
              return null;
            },
          ),
        ],
      ],
    );
  }
}
