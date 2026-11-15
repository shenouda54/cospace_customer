import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/features/auth/view/auth_messages.dart';
import 'package:cospace_customer/features/auth/view/login_screen.dart';
import 'package:cospace_customer/features/auth/view_model/auth_cubit.dart';
import 'package:cospace_customer/features/auth/view_model/auth_state.dart';
import 'package:cospace_customer/features/home/view/customer_home_screen.dart';

/// Restores the session and shows login or home.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthCubit>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return current is AuthError ||
            (current is AuthAuthenticated && current.isNewAccount);
      },
      listener: (context, state) {
        if (state is AuthError) {
          context.showSnackBar(
            authFailureMessage(context.l10n, state.code),
            isError: true,
          );
        } else if (state is AuthAuthenticated && state.isNewAccount) {
          context.showSnackBar(context.l10n.registrationSuccess);
        }
      },
      builder: (context, state) {
        if (state is AuthInitial || state is AuthChecking) {
          return const _AuthSplash();
        }
        if (state is AuthAuthenticated) {
          return const CustomerHomeScreen();
        }
        return const _AuthFlow();
      },
    );
  }
}

class _AuthSplash extends StatelessWidget {
  const _AuthSplash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.appTitle,
              style: TextStyle(
                fontSize: AppFonts.heading1,
                fontWeight: AppFonts.bold,
                color: context.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppSizes.v24),
            CircularProgressIndicator(
              color: context.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Nested navigator so register can be pushed without covering home.
class _AuthFlow extends StatelessWidget {
  const _AuthFlow();

  @override
  Widget build(BuildContext context) {
    return const Navigator(
      onGenerateRoute: _onGenerateRoute,
    );
  }

  static Route<void> _onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const LoginScreen(),
    );
  }
}
