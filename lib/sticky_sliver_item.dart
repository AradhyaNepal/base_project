import 'package:base_project/get_size_from_key.dart';
import 'package:flutter/material.dart';

///Lots of limitation
///
/// * When developer changes a things and do Hot Reload, it won't be reflected here.
///
/// * Lets say image is not loaded, then its size will not be calculated it the height of the image/svg is not given.
class StickySliverItem extends StatefulWidget {
  final Widget child;

  const StickySliverItem({
    super.key,
    required this.child,
  });

  @override
  State<StickySliverItem> createState() => _StickySliverItemState();
}

class _StickySliverItemState extends State<StickySliverItem> {
  final _itemKey = GlobalKey();
  Size? _itemSize;

  @override
  void initState() {
    super.initState();
    _getSize();
  }

  void _getSize() async {
    _itemSize = await getSizeFromKey(_itemKey);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final itemSize = _itemSize;
    if (itemSize == null) {
      return SliverToBoxAdapter(
        child: SizedBox(
          key: _itemKey,
          child: widget.child,
        ),
      );
    } else {
      return SliverPersistentHeader(
        floating: false,
        pinned: true,
        delegate: StickySliverHeaderDelegate(
          height: itemSize.height,
          child: widget.child,
        ),
      );
    }
  }
}

class StickySliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  StickySliverHeaderDelegate({
    required this.child,
    required this.height,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      child;

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
