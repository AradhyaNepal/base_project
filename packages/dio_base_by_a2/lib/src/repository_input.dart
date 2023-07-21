
import 'package:dio/dio.dart';

import 'repository_details.dart';

class RequestInput {
  String url;
  Object? data;
  Map? header;
  Map<String, dynamic>? params;
  RepositoryDetails? repositoryDetails;
  CancelToken? cancelToken;
  ResponseType? responseType;

  RequestInput(
      this.url, {
        this.data,
        this.header,
        this.params,
        this.repositoryDetails,
        this.cancelToken,
        this.responseType,
      });
}