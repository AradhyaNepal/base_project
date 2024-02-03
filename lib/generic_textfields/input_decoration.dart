import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomDecoration {
  static InputDecoration getDecoration(TextTheme textTheme, {
    bool isMandatory = false,
    String? labelText,
    String? suffixText,
    String? hintText,
    String? prefixIconSvg,
    String? suffixIconSvg,
    Color? labelTextColor,
    IconData? suffixIcon,
    Widget? prefixWidget,
    Widget? suffixWidget,
    VoidCallback? onClickSuffixToggle,
    double? borderRadius,
    Color? fillColor,
    Color? borderColor,
    Color? suffixIconColor,
    Color? hintColor,
    String? errorText,
    VoidCallback? onClear,
  }) {
    return InputDecoration(
      counterText: "",
      counterStyle: const TextStyle(
        color: ColorConstant.primaryColor,
      ),
      errorText: errorText,
      contentPadding: EdgeInsets.only(
        left: prefixWidget == null ? 10.w : 0,
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: ColorConstant.darkRedColor,
          width: 1,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        borderSide: const BorderSide(
          color: ColorConstant.darkRedColor,
          width: 2,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        borderSide: BorderSide(
          color: borderColor ?? ColorConstant.primaryColor,
          width: 1.5,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        borderSide: BorderSide(
          width: 4,
          color: borderColor ?? ColorConstant.textFieldBorder,
        ),
      ),
      disabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        borderSide: const BorderSide(
          width: 1.5,
          color: ColorConstant.disabledTextField,
        ),
      ),
      errorMaxLines: 10,
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: labelText),
            if (isMandatory)
              const TextSpan(
                text: "\t*",
                style: TextStyle(
                  color: ColorConstant.primaryColor,
                ),
              ),
          ],
        ),
      ),
      labelStyle: textTheme.bodyLarge?.copyWith(
        color: labelTextColor ?? ColorConstant.textFieldBlackText,
        fontWeight: FontWeight.w300,
      ),
      hintText: hintText,
      hintStyle: textTheme.bodyLarge?.copyWith(
        color: hintColor ?? ColorConstant.textFieldBlackText,
        fontWeight: FontWeight.w300,
      ),
      suffixText: suffixText,
      suffixStyle: textTheme.bodyLarge?.copyWith(
        color: ColorConstant.textFieldBlackText,
        fontWeight: FontWeight.w300,
      ),
      suffixIcon: _getSuffixIcon(
        suffixWidget,
        suffixText,
        textTheme,
        suffixIcon,
        onClickSuffixToggle,
        suffixIconSvg,
        suffixIconColor,
        onClear,
      ),
      prefixIcon: prefixIconSvg != null
          ? SvgPicture.asset(
        prefixIconSvg,
        fit: BoxFit.scaleDown,
      )
          : prefixWidget,
      fillColor: fillColor ?? Colors.white,
      filled: true,
      errorStyle: textTheme.bodyMedium?.copyWith(
        color: Colors.red,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static Widget? _getSuffixIcon(Widget? suffixWidget,
      String? suffixText,
      TextTheme textTheme,
      IconData? suffixIcon,
      VoidCallback? onClickSuffixToggle,
      String? suffixIconSvg,
      Color? suffixIconColor,
      VoidCallback? onIsClear,) {
    Widget? returnWidget;
    if (suffixWidget != null) returnWidget= suffixWidget;
    if (suffixText != null) {
      returnWidget= Padding(
        padding: EdgeInsets.only(top: 14, right: 9.w),
        child: Text(
          suffixText,
          style: textTheme.bodyLarge?.copyWith(
            color: ColorConstant.textFieldBlackText,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    }
    if(suffixIconSvg!=null || suffixIcon!=null){
      returnWidget= IconButton(
        onPressed: onClickSuffixToggle,
        icon: suffixIconSvg != null
            ? SvgPicture.asset(
          suffixIconSvg,
          fit: BoxFit.scaleDown,
        )
            : Icon(
          suffixIcon,
          color: suffixIconColor ??
              ColorConstant.textFieldIconColor,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
      );
    }
    if(onIsClear!=null){
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              onIsClear();
            },
          child: Icon(
              Icons.close,
              color: ColorConstant.textFieldIconColor,
              size: 20.sp,
            ),
          ),
          returnWidget??const SizedBox(),
        ],
      );
    }else{
      return returnWidget;
    }
  }
}

