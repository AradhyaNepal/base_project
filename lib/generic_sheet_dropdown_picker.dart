
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'generic_bottom_sheet_picker.dart';

class GenericSheetDropdownPicker<T> extends StatefulWidget {
  final bool isLoading;
  final String label;
  final String Function(T) headingMapper;
  final List<T> items;
  final ValueNotifier<T?> selectedValueController;
  final bool searchable;
  final bool disabled;
  final bool readOnly;
  final String? validationHeading;

  ///It adds isEmpty validator
  ///Also add *
  final bool isRequired;

  const GenericSheetDropdownPicker({
    super.key,
    required this.label,
    required this.headingMapper,
    required this.items,
    required this.selectedValueController,
    this.isRequired = false,
    this.searchable = true,
    this.isLoading = false,
    this.disabled=false,
    this.readOnly=false,
    this.validationHeading,
  });

  @override
  State<GenericSheetDropdownPicker<T>> createState() =>
      _GenericSheetDropdownPickerState<T>();
}

class _GenericSheetDropdownPickerState<T> extends State<GenericSheetDropdownPicker<T>> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setText();
  }

  void _setText() {
    final value = widget.selectedValueController.value;
    if (value != null) {
      textController.text = widget.headingMapper(value);
      int index=widget.items.indexWhere((element) => element==value);
      if(index!=-1){
        selectedIndex=index;
      }
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return GenericTextField(
        hintText: "Fetching ${widget.label} ...",
        validate: _mayRequiredValidator(),
        textInputAction: TextInputAction.done,
          isDisabled:true,
      );
    }
    return GenericTextField(
      isDisabled: widget.disabled,
      hintText: widget.label,
      validate: _mayRequiredValidator(),
      textInputAction: TextInputAction.done,
      readonly: true,
      onClear: !widget.isRequired && !widget.readOnly?(){
        textController.clear();
        widget.selectedValueController.value=null;
        selectedIndex=null;
      }:null,
      controller: textController,
      suffixWidget: widget.readOnly?null: IconButton(
        onPressed: onTap,
        icon: const Icon(
            Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }

  ValidatorType? _mayRequiredValidator() {
    return widget.isRequired && !widget.disabled
        ? CustomValidator.validateEmpty("Please enter ${widget.validationHeading??widget.label}")
        : null;
  }

  void onTap() async {
    if(widget.readOnly)return;
    selectedIndex = await showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0.r),
        ),
      ),
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: GenericBottomSheetPicker<T>(
          isSearchable: widget.searchable,
          closeOnSelected: true,
          sheetTitle: widget.label,
          selectedIndex: selectedIndex,
          headingMapper: widget.headingMapper,
          sheetList: widget.items,
        ),
      ),
    );
    if (selectedIndex == null) {
      if (!mounted) return;
      delayedUnFocus(context);
      return;
    }
    widget.selectedValueController.value =
        widget.items.elementAtOrNull(selectedIndex ?? -1);
    _setText();
    setState(() {});
  }
}
