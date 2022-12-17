import 'package:http/http.dart' as http;
import 'package:fashion/data/weather.dart';
import 'dart:convert';
import 'package:collection/collection.dart';

class WeatherApi {
  final BASE_URL = "http://apis.data.go.kr";

  final String key =
      "VKcfRu%2FyjZ6ftGwn%2FS01DkZLL0mStDbMkH4QO2rjTlkCAM90p61BLBznC78QIadnKi8tanvisXVPVFwB3pEz0w%3D%3D";

  Future<List<Weather>> getWeather(
      int x, int y, int date, String base_time) async {
    String url =
        "$BASE_URL/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=$key&pageNo=1&numOfRows=1000&dataType=json&base_date=$date&base_time=$base_time&nx=$x&ny=$y";

    final response = await http.get(url);

    List<Weather> weather = [];

    if (response.statusCode == 200) {
      // Request well...
      String body = utf8.decode(response.bodyBytes);

      var res = json.decode(body) as Map<String, dynamic>;

      List<dynamic> data_ = [];

      data_ = res["response"]["body"]["items"]["item"] as List<dynamic>;

      final data = groupBy(data_, (obj) => "${obj["fcstTime"]}").entries.toList();

      for (final r_ in data) {

        final data_ = {
          "fcstTime": r_.key,
          "fcstDate": r_.value.first["fcstDate"]
        };

        for (final d_ in r_.value) {
          data_[d_["category"]] = d_["fcstValue"];
        }

        final w =  Weather.fromJson(data_);

        weather.add(w);
      }

      return weather;

    } else {
      return [];
    }
  }
}
