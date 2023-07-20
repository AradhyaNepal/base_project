import 'package:dio_base_by_a2/dio_base_by_a2.dart';
import 'package:dio_base_by_a2/src/repository_details.dart';
import 'package:dio_base_by_a2/src/repository_input.dart';

void main() {}

class PropertyRepository extends BaseRepository {
  void getProperty() async {
    final value = await get(
      RepositoryInput("google.com",
          data: "",
          params: {"avs": "fasdf"},
          repositoryDetails: RepositoryDetails(
            tokenNeeded: false,
          )),
    );
  }
}
