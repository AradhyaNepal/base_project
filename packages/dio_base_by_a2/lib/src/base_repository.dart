import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class BaseRepository {
  ///Defaults to true,
  ///If this is set true, in all request, token is passed in all of the request
  //Todo: Make it private
  final bool repoNeedToken;

  ///If nothing is set, then its 60 seconds
  //Todo: Make it private
  final int repoTimeout;
  final Dio _client;


  ///In order to do the testing, you can pass Mocked Dio on [dio].
  ///
  /// For Security purpose, the logs of the network dio request will only will
  /// displayed on debug and profile mode, those logs will on work on release.
  BaseRepository({
    this.repoNeedToken = true,
    this.repoTimeout = 60,
    Dio? dio,
  }):_client=dio??Dio(){
    if(!kReleaseMode){
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

  ///On not passing [haveToken], [repoNeedToken]  value will be used
  ///On not passing [timeoutSeconds], [repoTimeout]  value will be used
  Future<T> get<T>(
    String url, {
    Map? header,
    Map? params,
    bool? haveToken,
    int? timeoutSeconds,
  }) async {
    haveToken ??= repoNeedToken;
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
