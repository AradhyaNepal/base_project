import 'dart:io';

import 'package:dio/dio.dart';
//No Idea why i am getting this warning
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class CustomMultipart {
  static Future<Object> parseBody(
    Map<String, dynamic> data, {
    bool removeNull = true,
  }) async {
    final output = FormData.fromMap({
      for (var value in data.entries) ...?await _getData(value, removeNull)
    });
    return output;
  }

  static Future<Map<String, dynamic>?> _getData(
      MapEntry mapEntry, bool removeNull) async {
    if (mapEntry.value == null && removeNull) return null;
    if (mapEntry.value is! File) {
      return {
        mapEntry.key: mapEntry.value,
      };
    } else if (mapEntry.value != null) {
      final fileName=mapEntry.value.path.split('/').last as String;
      return {

        mapEntry.key: await MultipartFile.fromFile(mapEntry.value.path,
            filename: fileName,
            contentType:MediaType('image', fileName.split(".").last),
        )
      };
    } else {
      return null;
    }
  }
}
