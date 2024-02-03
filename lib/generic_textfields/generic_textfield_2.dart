import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/input_decoration.dart';

class GenericTextField extends StatefulWidget {
  ///Shows a * icons if mandatory.
  ///It does not does the validation
  final bool isMandatory;
  final String labelText;
  final String? suffixText;
  final String? hintText;
  final String? prefixIconSvg;
  final String? suffixIconSvg;
  final Color? labelTextColor;
  final bool isDisabled;
  final VoidCallback? onClear;

  ///This value is ignored if the textfield is password
  final IconData? suffixIcon;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool isPassword;
  final VoidCallback? onSuffixClick;
  final VoidCallback? onTap;
  final TextInputType keywordType;
  final String? Function(String?)? validate;
  final Function(String)? onFieldSubmit;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final Function? onSave;
  final Function? onChanged;
  final TextEditingController? controller;
  final bool readonly;
  final int? maxLength;
  final int? maxLines;
  final double? borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? suffixIconColor;
  final Iterable<String>? autoFillHints;
  final bool autofocus;
  final bool centerText;
  final bool isNumber;
  final Color? hintColor;
  final String? initialValue;
  final List<TextInputFormatter>? formatterList;

  const GenericTextField({
    Key? key,
    this.formatterList,
    this.isMandatory=false,
    required this.labelText,
    this.labelTextColor,
    this.suffixIcon,
    this.maxLines,
    this.borderRadius,
    this.prefixWidget,
    this.suffixWidget,
    this.suffixText,
    this.isPassword = false,
    this.onSuffixClick,
    this.keywordType = TextInputType.text,
    required this.validate,
    this.onFieldSubmit,
    required this.textInputAction,
    this.readonly = false,
    this.focusNode,
    this.onSave,
    this.controller,
    this.onChanged,
    this.autofocus = false,
    this.maxLength,
    this.hintText,
    this.fillColor,
    this.borderColor,
    this.onTap,
    this.centerText = false,
    this.suffixIconColor,
    this.autoFillHints,
    this.isDisabled = false,
    this.hintColor,
    this.isNumber = false,
    this.prefixIconSvg,
    this.suffixIconSvg,
    this.initialValue,
    this.nextNode,
    this.onClear,
  }) : super(key: key);

  @override
  State<GenericTextField> createState() => _GenericTextFieldState();
}

class _GenericTextFieldState extends State<GenericTextField> {
  String? maxLimitError;
  var hidePassword = true;

  void _validateInput(String text) {
    final maxLength = widget.maxLength;

    if (maxLength == null) return;
    if (text.length == maxLength) {
      Form.maybeOf(context)?.validate();
      setState(() {
        maxLimitError = 'Maximum ${widget.maxLength} character limit reached';
      });
    } else {
      if (maxLimitError == null) return;
      Form.maybeOf(context)?.validate();
      setState(() {
        maxLimitError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return TextFormField(
      contextMenuBuilder: (context, editableTextState) {

        return Theme(
          data: ThemeData(),
          child: AdaptiveTextSelectionToolbar.buttonItems(
            anchors: editableTextState.contextMenuAnchors,
            buttonItems:editableTextState.contextMenuButtonItems,
          ),
        );
      },
      style: textTheme.displayMedium?.copyWith(
        color: ColorConstant.textFieldBlackText,
      ),
      initialValue: widget.initialValue,
      maxLines: widget.maxLines ?? 1,
      maxLength: widget.maxLength,
      enabled: !widget.isDisabled,
      textAlign: widget.centerText ? TextAlign.center : TextAlign.start,
      autofocus: widget.autofocus,
      onChanged: (newValue) {
        _validateInput(newValue);
        widget.onChanged?.call(newValue);
      },
      controller: widget.controller,
      onSaved: (newValue) {
        if (widget.onSave != null) widget.onSave!(newValue);
      },
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: (newValue) {
        if (widget.onFieldSubmit != null) widget.onFieldSubmit!(newValue);
        FocusScope.of(context).requestFocus(widget.nextNode);
      },
      validator: widget.validate,
      keyboardType: widget.keywordType,
      readOnly: widget.readonly,
      onTap: widget.onTap,
      autofillHints: widget.autoFillHints,
      inputFormatters: widget.formatterList,
      obscureText: widget.isPassword && hidePassword,
      decoration: CustomDecoration.getDecoration(
        textTheme,
        isMandatory: widget.isMandatory,
        onClear: widget.onClear,
        labelText: widget.labelText,
        suffixText: widget.suffixText,
        hintText: widget.hintText,
        prefixIconSvg: widget.prefixIconSvg,
        suffixIconSvg: widget.suffixIconSvg,
        labelTextColor: widget.labelTextColor,
        suffixIcon: widget.isPassword
            ? hidePassword
                ? Icons.visibility
                : Icons.visibility_off
            : widget.suffixIcon,
        prefixWidget: widget.prefixWidget,
        suffixWidget: widget.suffixWidget,
        onClickSuffixToggle: () {
          if (widget.isPassword) {
            setState(() {
              hidePassword = !hidePassword;
            });
          }
          widget.onSuffixClick?.call();
        },
        borderRadius: widget.borderRadius,
        fillColor: widget.fillColor ?? (widget.isDisabled
                ? ColorConstant.disabledTextField
                : ColorConstant.backgroundColor),
        borderColor: widget.borderColor,
        suffixIconColor: widget.suffixIconColor,
        hintColor: widget.hintColor,
        errorText: maxLimitError,
      ),
    );
  }
}
