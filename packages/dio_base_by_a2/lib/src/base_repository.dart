import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_exception.dart';
import 'repository_details.dart';
import 'request_input.dart';
import 'token_expiry_interceptor.dart';
import 'typedef.dart';

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
    RequestInput input,
  ) async {
    return _onErrorManipulator<T>(() async {
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
    });
  }

  Future<T> post<T>(
    RequestInput input,
  ) async {
    return _onErrorManipulator<T>(() async {
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
    });
  }

  Future<T> delete<T>(
    RequestInput input,
  ) async {
    return _onErrorManipulator<T>(() async {
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
    });
  }

  Future<T> put<T>(
    RequestInput input,
  ) async {
    return _onErrorManipulator<T>(() async {
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
    });
  }

  Future<T> patch<T>(
    RequestInput input,
  ) async {
    return _onErrorManipulator<T>(() async {
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
    });
  }

  Future<dynamic> download(RequestInput input, String savePath) async {
    return _onErrorManipulator(() async {
      final repositoryDetails =
          input.repositoryDetails ?? _globalRepositoryDetails;
      final heading = await _getHeading(repositoryDetails.tokenNeeded);
      final response = await _client
          .download(
            input.url,
            savePath,
            data: input.data,
            queryParameters: input.params,
            cancelToken: input.cancelToken,
            options: Options(
              headers: heading,
              responseType: input.responseType,
            ),
          )
          .timeout(Duration(seconds: repositoryDetails.requestTimeout));
      return response.data;
    });
  }

  Future<Map<String, String>> _getHeading(bool needToken) async {
    String token = ""; //Todo: Implement token,
    return {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      if (needToken) 'Authorization': 'Bearer $token',
    };
  }

  ///Throws [APIException] on error
  Future<T> _onErrorManipulator<T>(ErrorGuardReturn<T> run) async {
    try {
      return run();
    } on DioException catch (error, stack) {
      log(error.toString());
      log(stack.toString());
      String genericMessage =
          "Dear customer, we are unable to complete the process. Please try again later.";
      //Todo: Below code combines multiple error list to one value, manipulate below code as per your API requirement
      final errorResponse = error.response?.data?["errors"];
      if (errorResponse != null) {
        final errorList = (errorResponse as Map<String, dynamic>).values;
        if (errorList.isEmpty) {
          throw APIException(
            genericMessage,
            error.response?.statusCode ?? -1,
          );
        }
        final listCombinedMessage =
            errorList.fold("", (previousValue, element) {
          if (previousValue.isEmpty) {
            return element;
          } else {
            return "$previousValue\n\n$element";
          }
        });
        error.toString();
        throw APIException(
          listCombinedMessage,
          error.response?.statusCode ?? -1,
        );
      }
      throw APIException(
        genericMessage,
        error.response?.statusCode ?? -1,
      );
    } catch (error, stack) {
      log(error.toString());
      log(stack.toString());
      throw APIException(
        "Something went wrong with the Application. Please contact the developers.",
        -1,
        error: error,
        stackTrace: stack,
      );
    }
  }
}




