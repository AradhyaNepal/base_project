import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GenericElevatedButton extends StatelessWidget {
  static TextStyle get buttonTextStyle=>StylesConstants.kWhite14w500Noto;
  final String title;
  final bool loading;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final double? elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final EdgeInsets? padding;

  ///Replaces title
  final Widget? child;

  const GenericElevatedButton({
    Key? key,
    required this.title,
    this.isDisabled = false,
    this.onPressed,
    this.height,
    this.width,
    this.textStyle,
    this.loading = false,
    this.child,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
    this.splashColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 46.h,
      width: width ?? MediaQuery.of(context).size.width,
      child: Semantics(
        label: title,
        child: ElevatedButton(
          style: buildButtonStyle(
            context,
            isDisabled: isDisabled,
            elevation: elevation,
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
            splashColor: splashColor,
            padding: padding,
          ),
          onPressed: (isDisabled || loading) ? null : onPressed,
          child: DefaultTextStyle(
            style: textStyle ?? buttonTextStyle,
            child: loading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitFadingCircle(
                        color: Colors.white,
                        size: 20.r,
                        duration: const Duration(milliseconds: 1000),
                      ),
                      SizedBox(width: 6.w,),
                      const Text("Submitting...")
                    ],
                  )
                : child ??
                    Text(
                      title,
                      textAlign: TextAlign.center,
                    ),
          ),
        ),
      ),
    );
  }

  static ButtonStyle buildButtonStyle(
    BuildContext context, {
    double? elevation,
    bool isDisabled = false,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    Color? splashColor,
    EdgeInsets? padding,
  }) {
    const buttonColor = ColorConstants.primaryColor;
    return ButtonStyle(
      padding: padding == null
          ? null
          : MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
              (Set<MaterialState> states) {
                return padding;
              },
            ),
      overlayColor: MaterialStateProperty.resolveWith(
        (states) {
          return states.contains(MaterialState.pressed)
              ? splashColor ?? ColorConstants.buttonSplash
              : null;
        },
      ),
      elevation: MaterialStateProperty.all(elevation ?? 0),
      backgroundColor: MaterialStateProperty.all(
        isDisabled
            ? Theme.of(context).disabledColor
            : backgroundColor ?? buttonColor,
      ),
      splashFactory: InkRipple.splashFactory,
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(15.r),
        ),
      ),
    );
  }
}
