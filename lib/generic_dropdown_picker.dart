import 'dart:developer';
import 'package:flutter/material.dart';


class GenericDropDownPicker<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) headingMapper;
  final void Function(T?)? onChanged;
  final String header;
  final ValueNotifier<T?> selectedValueController;
  final String? Function(T?)? validate;

  const GenericDropDownPicker({
    super.key,
    required this.items,
    required this.headingMapper,
    required this.selectedValueController,
    this.onChanged,
    required this.header,
    required this.validate,
  });

  @override
  State<GenericDropDownPicker<T>> createState() =>
      _GenericDropDownPickerState<T>();
}

class _GenericDropDownPickerState<T> extends State<GenericDropDownPicker<T>> {
  late T? initialValue = widget.selectedValueController.value;

  @override
  void initState() {
    super.initState();
    _safelySetInitialValue();
  }

  @override
  void didUpdateWidget(covariant GenericDropDownPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _safelySetInitialValue() {
    if (initialValue != null && !widget.items.contains(initialValue)) {
      initialValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    log(initialValue.toString());
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField<T>(
        style: StylesConstants.kFontBlack14w500,
        icon: const Icon(Icons.keyboard_arrow_down),
        iconEnabledColor: Colors.black,
        //Todo: Test render overflow with these two and is filled true in getDecoration
        isDense: true,
        isExpanded: true,
        validator: widget.validate,
        value: initialValue,
        hint: Transform.translate(
          offset: _leftTransformOffset(),
          child: Text(
            widget.header,
            style: StylesConstants.dropdownHint14w400,
          ),
        ),
        items: _getItemsList(false),
        selectedItemBuilder: (context) => _getItemsList(true),
        onChanged: (value) {
          widget.selectedValueController.value = value;
          widget.onChanged?.call(value);
        },
        decoration: CustomDecoration.getDecoration(hintText: ''),
      ),
    );
  }

  List<DropdownMenuItem<T>> _getItemsList(bool forSelected) {
    return [
      for (int i = 0; i < widget.items.length; i++)
        DropdownMenuItem<T>(
          value: widget.items[i],
          child: Transform.translate(
            offset: forSelected ? _leftTransformOffset() : Offset.zero,
            child: Text(widget.headingMapper(widget.items[i])),
          ),
        )
    ];
  }

  Offset _leftTransformOffset() => Offset(-SizeConstants.hPadding, 0);
}
