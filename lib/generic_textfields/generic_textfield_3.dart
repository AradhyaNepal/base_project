import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class GenericTextField extends StatefulWidget {
  final String hintText;
  final bool isDisabled;
  final VoidCallback? onClear;

  final Widget? prefixWidget;

  /// This value is ignored if the TextField is password
  final Widget? suffixWidget;
  final bool isPassword;
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
  final Iterable<String>? autoFillHints;

  final bool autofocus;
  final bool centerText;
  final Color? hintColor;
  final String? initialValue;
  final List<TextInputFormatter>? formatterList;

  const GenericTextField({
    Key? key,
    required this.hintText,
    required this.textInputAction,
    required this.validate,
    this.formatterList,
    this.maxLines,
    this.borderRadius,
    this.prefixWidget,
    this.suffixWidget,
    this.isPassword = false,
    this.keywordType = TextInputType.name,
    this.onFieldSubmit,
    this.readonly = false,
    this.focusNode,
    this.onSave,
    this.controller,
    this.onChanged,
    this.autofocus = false,
    this.maxLength,
    this.fillColor,
    this.borderColor,
    this.onTap,
    this.centerText = false,
    this.autoFillHints,
    this.isDisabled = false,
    this.hintColor,
    this.initialValue,
    this.nextNode,
    this.onClear,
  }) : super(key: key);

  @override
  State<GenericTextField> createState() => _GenericTextFieldState();
}

class _GenericTextFieldState extends State<GenericTextField> {
  String maxLimitError="";
  var hidePassword = true;

  void _validateInput(String text) {
    final maxLength = widget.maxLength;

    if (maxLength == null) return;
    if (text.length == maxLength) {
      setState(() {
        maxLimitError = 'Max ${widget.maxLength}';
      });
    } else {
      if (maxLimitError.isEmpty) return;
      setState(() {
        maxLimitError = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      contextMenuBuilder: (context, editableTextState) {
        return Theme(
          data: ThemeData(),
          child: AdaptiveTextSelectionToolbar.buttonItems(
            anchors: editableTextState.contextMenuAnchors,
            buttonItems: editableTextState.contextMenuButtonItems,
          ),
        );
      },
      style:StylesConstants.valueGrey14w500,
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
        onClear: widget.onClear,
        hintText: widget.hintText,
        passwordIcon: widget.isPassword
            ? hidePassword
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded
            : null,
        prefixWidget: widget.prefixWidget,
        suffixWidget: widget.suffixWidget,
        onPasswordToggle: () {
          if (widget.isPassword) {
            setState(() {
              hidePassword = !hidePassword;
            });
          }
        },
        borderRadius: widget.borderRadius,
        fillColor: widget.fillColor ??
            (widget.isDisabled
                ? ColorConstants.disabledTextField
                : Colors.white),
        borderColor: widget.borderColor,
        hintColor: widget.hintColor,
        maxLengthCounter: maxLimitError,
      ),
    );
  }
}
