import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradientSystemAppBar extends StatelessWidget {
  final Widget child;
  final Color? systemNavigationBarColor;

  const GradientSystemAppBar({
    super.key,
    required this.child,
    this.systemNavigationBarColor,
  });

  static AppBar get appBar {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      toolbarHeight: 0,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: systemNavigationBarColor??Colors.black,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Stack(
        children: [
          child,
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).viewPadding.top,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorConstant.stackDecoratorRed2,
                    ColorConstant.stackDecoratorRed3,
                  ],
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashSystemAppBar extends StatelessWidget {
  final Widget child;

  const SplashSystemAppBar({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorConstant.backgroundColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: ColorConstant.backgroundColor,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: child,
    );
  }
}

class HomeSystemOverlay extends StatelessWidget {
  final Widget child;

  const HomeSystemOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorConstant.backgroundColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: ColorConstant.backgroundColor,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: child,
    );
  }
}

class CustomOverlay extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;
  final Color? systemNavigationBarColor;
  final Brightness? statusBarIconBrightness;

  const CustomOverlay({
    super.key,
    required this.child,
    this.statusBarColor,
    this.statusBarIconBrightness,
    this.systemNavigationBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? ColorConstant.whiteColor,
        statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor:
            systemNavigationBarColor ?? ColorConstant.whiteColor,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: child,
    );
  }
}
