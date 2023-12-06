import "package:app/base/cutil/RestClient.dart";

import "nlpTyped/InstantIntent.dart";

class NlpApi {
  NlpApi(this._restClient);

  final RestClient _restClient;

  Future<RestResult<InstantIntent>> instantIntent(String domain, String modelParams) async {
    return _restClient.get("/be/bas-demo-v4/nlp/instant_intent", queryParameters: {
      "domain": domain,
      "model_params": modelParams,
    }).toModel((p0) => InstantIntent.fromJson(p0));
  }
}
