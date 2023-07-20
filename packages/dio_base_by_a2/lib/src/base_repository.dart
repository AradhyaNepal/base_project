import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

//Todo: Error handling, custom APIException
//Todo: Transformer vs responseManipulator
class BaseRepository {
  final Dio _client;
  final RepositoryDetails _globalRepositoryDetails;

  ///If on a specific request, [RepositoryDetails] are not passed,
  ///then this [globalRepositoryDetails] is used.
  RepositoryDetails get globalRepositoryDetails => _globalRepositoryDetails;

  ///In order to do the testing, you can pass Mocked Dio on [dio].
  ///
  /// For Security purpose, the logs of the network dio request will only will
  /// displayed on debug and profile mode, those logs will on work on release.
  BaseRepository({
    Dio? dio,
    RepositoryDetails? repositoryDetails,
  })  : _client = dio ?? Dio(),
        _globalRepositoryDetails = repositoryDetails ?? RepositoryDetails() {
    if (!kReleaseMode) {
      //Unlike tokenExpired interceptor, Log interception must not be shown on release mode.
      //Because it might expose user sensitive details like there Token, or even
      //our developer's internal data.
      _client.interceptors.add(
        LogInterceptor(
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          requestBody: true,
        ),
      );
    }
    _client.interceptors.add(TokenExpiredInterceptor());
  }

  Future<T> get<T>(
    RepositoryInput input,
  ) async {
    final repositoryDetails =
        input.repositoryDetails ?? _globalRepositoryDetails;
    final heading = await _getHeading(repositoryDetails.tokenNeeded);
    final response = await _client
        .get(
          input.url,
          data: input.data,
          queryParameters: input.params,
          cancelToken: input.cancelToken,
          options: Options(
            headers: heading,
            responseType: input.responseType,
          ),
        )
        .timeout(Duration(seconds: repositoryDetails.requestTimeout));
    return repositoryDetails.responseManipulate(response.data) as T;
  }

  Future<T> post<T>(
    RepositoryInput input,
  ) async {
    final repositoryDetails =
        input.repositoryDetails ?? _globalRepositoryDetails;
    final heading = await _getHeading(repositoryDetails.tokenNeeded);
    final response = await _client
        .post(
          input.url,
          data: input.data,
          queryParameters: input.params,
          cancelToken: input.cancelToken,
          options: Options(
            headers: heading,
            responseType: input.responseType,
          ),
        )
        .timeout(Duration(seconds: repositoryDetails.requestTimeout));
    return repositoryDetails.responseManipulate(response.data) as T;
  }

  Future<T> delete<T>(
    RepositoryInput input,
  ) async {
    final repositoryDetails =
        input.repositoryDetails ?? _globalRepositoryDetails;
    final heading = await _getHeading(repositoryDetails.tokenNeeded);
    final response = await _client
        .delete(
          input.url,
          data: input.data,
          queryParameters: input.params,
          cancelToken: input.cancelToken,
          options: Options(
            headers: heading,
            responseType: input.responseType,
          ),
        )
        .timeout(Duration(seconds: repositoryDetails.requestTimeout));
    return repositoryDetails.responseManipulate(response.data) as T;
  }

  Future<T> put<T>(
    RepositoryInput input,
  ) async {
    final repositoryDetails =
        input.repositoryDetails ?? _globalRepositoryDetails;
    final heading = await _getHeading(repositoryDetails.tokenNeeded);
    final response = await _client
        .put(
          input.url,
          data: input.data,
          queryParameters: input.params,
          cancelToken: input.cancelToken,
          options: Options(
            headers: heading,
            responseType: input.responseType,
          ),
        )
        .timeout(Duration(seconds: repositoryDetails.requestTimeout));
    return repositoryDetails.responseManipulate(response.data) as T;
  }

  Future<T> patch<T>(
    RepositoryInput input,
  ) async {
    final repositoryDetails =
        input.repositoryDetails ?? _globalRepositoryDetails;
    final heading = await _getHeading(repositoryDetails.tokenNeeded);
    final response = await _client
        .patch(
          input.url,
          data: input.data,
          queryParameters: input.params,
          cancelToken: input.cancelToken,
          options: Options(
            headers: heading,
            responseType: input.responseType,
          ),
        )
        .timeout(Duration(seconds: repositoryDetails.requestTimeout));
    return repositoryDetails.responseManipulate(response.data) as T;
  }

  Future<T> download<T>() async {
    return throw UnimplementedError();
  }

  Future<Map<String, String>> _getHeading(bool needToken) async {
    String token = ""; //Todo: Implement token,
    return {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      if (needToken) 'Authorization': 'Bearer $token',
    };
  }
}

typedef ResponseManipulator = dynamic Function(dynamic);

abstract class RepositoryInput {
  String url;
  Object? data;
  Map? header;
  Map<String, dynamic>? params;
  RepositoryDetails? repositoryDetails;
  CancelToken? cancelToken;
  ResponseType? responseType;

  RepositoryInput(
    this.url, {
    this.data,
    this.header,
    this.params,
    this.repositoryDetails,
    this.cancelToken,
    this.responseType,
  });
}

class RepositoryDetails {
  final bool _tokenNeeded;

  ///Defaults to true,
  ///If this is set true, token is passed in all of the request
  bool get tokenNeeded => _tokenNeeded;

  final int _requestTimeout;

  ///On Dio request, its the duration after which the repo hits the timeout
  ///which is measured in seconds
  ///
  ///If nothing is set, then its 60 seconds
  int get requestTimeout => _requestTimeout;

  final ResponseManipulator _responseManipulate;

  ///In most case backend return a generic response,
  ///like:
  ///
  /// {
  ///
  ///   ...
  ///
  ///   "data":{
  ///       ... Actual Result that we need
  ///   }
  ///
  /// }
  ///
  /// This method is used to manipulate those response on every return so that
  /// for every method below, we will only get the value inside the data.
  ResponseManipulator get responseManipulate => _responseManipulate;

  ///By default the token is needed, with 60 seconds timeout and it uses a [defaultResponseManipulator]
  ///
  ///Can be used to override [haveToken], [timeoutSeconds] and [responseManipulator] of the repository
  ///
  /// On not passing [RepositoryDetails], or any of its inner variable, [BaseRepository] value will be used
  RepositoryDetails({
    bool tokenNeeded = true,
    int requestTimeout = 60,
    ResponseManipulator responseManipulate = defaultResponseManipulator,
  })  : _tokenNeeded = tokenNeeded,
        _requestTimeout = requestTimeout,
        _responseManipulate = responseManipulate;

  static dynamic defaultResponseManipulator(dynamic map) {
    try {
      return (map as Map)["data"];
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return map;
    }
  }

  static dynamic noneResponseManipulator(dynamic map) => map;
}

class TokenExpiredInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (err.response?.statusCode == 401) {
      //TODO: Might need to check other condition too, but after that Logout
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    //Todo: Remove once implemented, until its not implemented, keep annoying the developer
    _notImplementedWarning();
  }

  //Todo: Remove it once implemented
  //WARNING: DO NOT REMOVE UNTIL THE FEATURE IS IMPLEMENTED
  //BECAUSE YOU MIGHT GET ANNOYED BY BELOW MESSAGE KEEP POPPING ON YOUR LOG
  void _notImplementedWarning() {
    if (!kReleaseMode) {
      print(
          "Warning: Handling Token Expiry Scenario Is Not Handled Yet, Your Api might Crash If Token Get Expired");
    }
  }
}
