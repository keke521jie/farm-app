import "package:app/base/api/NlpApi.dart";
import "package:app/base/cutil/RestClient.dart";
import "package:app/base/cutil/StreamClient.dart";
import "package:injectable/injectable.dart";

@Singleton()
class ApiClient {
  ApiClient(this._restClient) {
    _streamClient = StreamClient((_restClient as RestClientBase).dio);
  }

  final RestClient _restClient;

  late final StreamClient _streamClient;

  late NlpApi nlp = NlpApi(_restClient);
}
