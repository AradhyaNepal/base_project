import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'generic_textfield.dart';

///Returns the selected index
class GenericBottomSheetPicker<T> extends StatefulWidget {
  final bool isSearchable;
  final bool closeOnSelected;
  final String sheetTitle;
  final int? selectedIndex;

  final List<T> sheetList;
  final String Function(T) headingMapper;

  const GenericBottomSheetPicker({
    super.key,
    required this.sheetTitle,
    required this.selectedIndex,
    required this.headingMapper,
    required this.sheetList,
    this.isSearchable = false,
    this.closeOnSelected = true,
  });

  @override
  State<GenericBottomSheetPicker> createState() =>
      _GenericBottomSheetPickerState<T>();
}

class _GenericBottomSheetPickerState<T>
    extends State<GenericBottomSheetPicker<T>> {
  late int? selectedIndex = widget.selectedIndex;

  String? searchedValue;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (manuallyPopped) {
        if(manuallyPopped)return;
        _popWithValue(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConstants.hPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.h,
            ),
            Row(
              children: [
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Text(
                        widget.sheetTitle,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: double.infinity,
                        child: Divider(
                          thickness: 3,
                          color: ColorConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: IconButton(
                    onPressed: () {
                      _popWithValue(context);
                    },
                    icon: SvgPicture.asset(
                      ImageConstants.closeSvg,
                      fit: BoxFit.scaleDown,
                      colorFilter: const ColorFilter.mode(
                        ColorConstants.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: widget.isSearchable ? height * 0.5 : null,
              constraints: !widget.isSearchable
                  ? BoxConstraints(
                      maxHeight: height * 0.65,
                    )
                  : null,
              child: Builder(
                builder: (context) {
                  if (!widget.isSearchable) {
                    if (widget.sheetList.isEmpty) {
                      return const Center(child: NoMatchWidget());
                    } else if (widget.sheetList.length > 20) {
                      return ListView.builder(
                        itemCount: widget.sheetList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return itemBuilder(index);
                        },
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int index = 0;
                              index < widget.sheetList.length;
                              index++)
                            itemBuilder(index),
                        ],
                      );
                    }
                  } else {
                    return buildSliver();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomScrollView buildSliver() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstants.backgroundColor,
          floating: true,
          title: GenericTextField(
            fillColor: Colors.transparent,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              searchedValue = value;
              setState(() {});
            },
            validate: null,
            hintText: "Search",
            suffixWidget: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ),
        Builder(
          builder: (context) {
            if (haveNoMatch) {
              return const SliverToBoxAdapter(
                child: NoMatchWidget(),
              );
            } else {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return itemBuilder(index);
                  },
                  childCount: widget.sheetList.length,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget itemBuilder(
    int index,
  ) {
    if (!_isMatchedItem(widget.sheetList[index])) return const SizedBox();
    return RadioListTile<int>(
      activeColor: ColorConstants.primaryColor,
      contentPadding: EdgeInsets.zero,
      selected: index == selectedIndex,
      title: Text(
        widget.headingMapper(
          widget.sheetList[index],
        ),
        style:TextStyle(
          fontSize: 16.sp,
        ),
      ),
      value: index,
      groupValue: selectedIndex,
      onChanged: (value) {
        if (selectedIndex == value) {
          selectedIndex = null;
        } else {
          selectedIndex = value ?? selectedIndex;
        }
        setState(() {});
        if (widget.closeOnSelected) {
          _popWithValue(context);
        }
      },
    );
  }

  bool get haveNoMatch => widget.sheetList.fold(true,
      (previousValue, element) => !_isMatchedItem(element) && previousValue);

  bool _isMatchedItem(T e) {
    if (searchedValue == null) return true;
    return widget
        .headingMapper(
          e,
        )
        .toLowerCase()
        .contains((searchedValue ?? "").toLowerCase());
  }

  void _popWithValue(BuildContext context) {
    Navigator.pop(context, selectedIndex);
  }
}
