import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BaseRepository {
  final bool _isTokenBasedRepo;

  ///Defaults to true,
  ///If this is set true, token is passed in all of the request
  bool get isTokenBasedRepo => _isTokenBasedRepo;

  final int _repoTimeout;

  ///On Dio request, its the duration after which the repo hits the timeout
  ///which is measured in seconds
  ///
  ///If nothing is set, then its 60 seconds
  int get repoTimeout => _repoTimeout;
  final Dio _client;

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

  ///In order to do the testing, you can pass Mocked Dio on [dio].
  ///
  /// For Security purpose, the logs of the network dio request will only will
  /// displayed on debug and profile mode, those logs will on work on release.
  BaseRepository({
    bool isTokenBasedRepo = true,
    int repoTimeout = 60,
    ResponseManipulator responseManipulate = _defaultResponseManipulator,
    Dio? dio,
  })  : _client = dio ?? Dio(),
        _isTokenBasedRepo = isTokenBasedRepo,
        _repoTimeout = repoTimeout,
        _responseManipulate = responseManipulate {
    if (!kReleaseMode) {
      _client.interceptors.add(
        LogInterceptor(
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          requestBody: true,
        ),
      );
    }
  }

  static dynamic _defaultResponseManipulator(dynamic map) {
    return (map as Map)["data"];
  }

  static dynamic noneResponseManipulator(dynamic map)=>map;


  Future<T> get<T>(
    String url, {
    Map? header,
    Map? params,
    RepositoryDetails? overrideRepo,
  }) async {
    return throw UnimplementedError();
  }

  Future<T> post<T>() async {
    return throw UnimplementedError();
  }

  Future<T> delete<T>() async {
    return throw UnimplementedError();
  }

  Future<T> put<T>() async {
    return throw UnimplementedError();
  }

  Future<T> patch<T>() async {
    return throw UnimplementedError();
  }
}

typedef ResponseManipulator = dynamic Function(dynamic);

class RepositoryDetails {
  final bool? haveToken;
  final int? timeoutSeconds;
  final ResponseManipulator? responseManipulator;

  ///Can be used to override [haveToken], [timeoutSeconds] and [responseManipulator] of the repository
  ///
  /// On not passing [RepositoryDetails], or any of its inner variable, [BaseRepository] value will be used
  RepositoryDetails({
    this.haveToken,
    this.timeoutSeconds,
    this.responseManipulator,
  });
}
