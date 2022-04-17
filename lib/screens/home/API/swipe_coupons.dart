import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mash/configs/base_url.dart';

// swipedService(int eventId, bool right) async {
//   var response = await ApiBaseHelper.put(
//       WebApi.swipedService, {"event_id": eventId, "swiped": right}, true);
//   print("RESPONSE ::: $response");
// }

swipeCoupons(bool right) async {
  var response = await http.put(
      Uri.parse(WebApi.baseUrl + WebApi.swipedService),
      headers: WebApi.header,
      body: jsonEncode({"type": "ab_expi", "status": 0, "id": "1281"}));
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
  } else if (response.statusCode == 400) {
  } else {}
}
