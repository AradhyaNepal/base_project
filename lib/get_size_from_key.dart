import 'dart:developer';

import 'package:flutter/cupertino.dart';

Future<Size?> getSizeFromKey(GlobalKey key) async {
  try{
    await Future.delayed(Duration.zero);
    final itemContext = key.currentContext;
    if (itemContext == null) return null;
    if (!itemContext.mounted) return null;
    final renderBox = itemContext.findRenderObject() as RenderBox?;
    return renderBox?.size;
  }catch(e,s){
    log(e.toString());
    log(s.toString());
    return null;
  }

}
