import 'package:dio_base_by_a2/dio_base_by_a2.dart';

void main() {}

class PropertyRepository extends BaseRepository {
  void getProperty() async {
     await get(
      RequestInput("google.com",
          data: "",
          params: {"avs": "fasdf"},
          repositoryDetails: RepositoryDetails(
            tokenNeeded: false,
          )),
    );
  }
}
