import 'dart:developer';

import 'package:dio_base_by_a2/dio_base_by_a2.dart';

void main() {}

class PropertyRepository extends BaseRepository {
  PropertyRepository()
      : super(
          repositoryDetails: RepositoryDetails(
              tokenNeeded: false,
              requestTimeout: 10,
              responseManipulate: (value) {
                return value["bello"];
              }),
        );

  void getProperty() async {
    final value = await get<int>(
      RequestInput(
        "google.com",
        data: "",
        params: {"avs": "fasdf"},
        repositoryDetails: RepositoryDetails(
          tokenNeeded: true,
          requestTimeout: 20,
          responseManipulate: (value) {
            return value["hello"];
          },
        ),
      ),
    );
    log(value.toString());
  }

  void deleteProperty() async {
    await delete(RequestInput("abcd.google"));
  }
}
