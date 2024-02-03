import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDecoration {
  static InputDecoration getDecoration({
    required String hintText,
    Color? labelTextColor,
    IconData? passwordIcon,
    Widget? prefixWidget,
    Widget? suffixWidget,
    VoidCallback? onPasswordToggle,
    double? borderRadius,
    Color? fillColor,
    Color? borderColor,
    Color? hintColor,
    String? maxLengthCounter,
    VoidCallback? onClear,
  }) {
    //Todo: May implement D1E6FF Double border on focus only if the team make me to do
    return InputDecoration(
      counterText: maxLengthCounter,
      counterStyle: StylesConstants.primary10w600,
      contentPadding: EdgeInsets.only(
        left: prefixWidget == null ? 10.w : 0,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 14.r),
        borderSide: const BorderSide(
          color: ColorConstants.textRed,
          width: 1.25,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 14.r),
        borderSide: const BorderSide(
          color: ColorConstants.textRed,
          width: 1.25,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 14.r),
        borderSide: BorderSide(
          color: borderColor ?? ColorConstants.primaryColor,
          width: 1.25,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 14.r),
        borderSide: BorderSide(
          width: 1.25,
          color: borderColor ?? ColorConstants.authBorderGrey,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 14.r),
        borderSide: const BorderSide(
          width: 1,
          color: ColorConstants.disabledTextField,
        ),
      ),
      errorMaxLines: 10,
      hintText: hintText,
      hintStyle: StylesConstants.hintGrey14w400,
      suffixIcon: _getSuffixIcon(
        suffixWidget,
        passwordIcon,
        onPasswordToggle,
        onClear,
      ),
      prefixIcon: prefixWidget,
      fillColor: fillColor ?? Colors.white,
      filled: true,
      errorStyle: StylesConstants.kRed12,
    );
  }

  static Widget? _getSuffixIcon(
      Widget? suffixWidget,
      IconData? passwordIcon,
      VoidCallback? onClickSuffixToggle,
      VoidCallback? onClear,
      ) {
    Widget? returnWidget;
    if (passwordIcon != null) {
      returnWidget = IconButton(
        onPressed: onClickSuffixToggle,
        icon: Icon(
          passwordIcon,
          color: ColorConstants.textFieldIconColor,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
      );
    } else {
      if (suffixWidget != null) returnWidget = suffixWidget;
    }
    if (onClear != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              onClear();
            },
            child: Icon(
              Icons.close,
              color: ColorConstants.textFieldIconColor,
              size: 20.sp,
            ),
          ),
          returnWidget ?? const SizedBox(),
        ],
      );
    } else {
      return returnWidget;
    }
  }

  static InputDecoration rsStyleDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.only(
          top: 10.h
      ),
      hintText: "0",
      hintStyle: StylesConstants.fontBlack18w600,
      prefixIcon: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Text(
          "Rs.",
          style: StylesConstants.sipAmount,
        ),
      ),
      errorStyle: StylesConstants.kRed12,
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: ColorConstants.textRed,
          width: 1.25,
        ),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: ColorConstants.textRed,
          width: 1.25,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: ColorConstants.primaryColor,
          width: 1.25,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          width: 1.25,
          color: ColorConstants.authBorderGrey,
        ),
      ),
      disabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: ColorConstants.disabledTextField,
        ),
      ),
    );
  }
}
