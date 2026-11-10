import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cospace_customer/l10n/app_localizations.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/theme/app_theme.dart';
import 'package:cospace_customer/core/theme/theme_cubit.dart';
import 'package:cospace_customer/core/utils/locale_cubit.dart';
import 'package:cospace_customer/features/auth/view/login_screen.dart';
import 'package:cospace_customer/features/auth/view_model/auth_cubit.dart';
import 'package:cospace_customer/features/home/view_model/home_cubit.dart';
import 'package:cospace_customer/features/reservation/view_model/reservation_cubit.dart';

/// Root widget of the Co-Working Space Customer App.
class CoSpaceCustomerApp extends StatelessWidget {
  const CoSpaceCustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => ReservationCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(
          AppSizes.designWidth,
          AppSizes.designHeight,
        ),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return BlocBuilder<LocaleCubit, Locale>(
                builder: (context, locale) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'CoSpace',

                    // ── Theme ──
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeMode,

                    // ── Localization ──
                    locale: locale,
                    supportedLocales: AppLocalizations.supportedLocales,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,

                    // ── Lock text scaling ──
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.noScaling,
                        ),
                        child: child!,
                      );
                    },

                    home: const LoginScreen(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

