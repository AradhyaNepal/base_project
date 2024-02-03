import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GenericElevatedButton extends StatelessWidget {
  static TextStyle? genericTextStyle(
    BuildContext context, {
    bool borderedButton = false,
  }) {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: borderedButton ? ColorConstant.primaryColor : Colors.white,
          fontWeight: FontWeight.w500,
        );
  }

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
  final bool borderedButton;
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
    this.borderedButton = false,
    this.splashColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 51.h,
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
            borderedButton: borderedButton,
            splashColor: splashColor,
            padding: padding,
          ),
          onPressed: (isDisabled || loading) ? null : onPressed,
          child: loading
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: SpinKitThreeBounce(
                    color: Colors.white,
                    size: 20.r,
                    duration: const Duration(milliseconds: 1000),
                  ),
                )
              : child ??
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: textStyle ??
                        genericTextStyle(
                          context,
                          borderedButton: borderedButton,
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
    bool borderedButton = false,
    Color? splashColor,
    EdgeInsets? padding,
  }) {
    const buttonColor = ColorConstant.primaryColor;
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
              ? splashColor ??
                  (borderedButton
                      ? Colors.grey.shade200
                      : ColorConstant.buttonSplash)
              : null;
        },
      ),
      elevation: MaterialStateProperty.all(elevation ?? 0),
      backgroundColor: MaterialStateProperty.all(
        isDisabled
            ? Theme.of(context).disabledColor
            : borderedButton
                ? Colors.white
                : backgroundColor ?? buttonColor,
      ),
      splashFactory: InkRipple.splashFactory,
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        borderedButton
            ? RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(12.r),
                side: BorderSide(color: backgroundColor ?? buttonColor),
              )
            : RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(12.r),
              ),
      ),
    );
  }
}
