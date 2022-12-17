import 'package:fashion/data/api.dart';
import 'package:fashion/data/weather.dart';
import 'package:fashion/location.dart';
import 'package:fashion/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> clothes = [
    "assets/img/jumper.png",
    "assets/img/long_sleeve.png",
    "assets/img/pants.png"
  ];

  List<Weather> weather = [];

  Weather current;

  LocationData location =
      LocationData(lat: 37.4187416, lng: 126.6826974, name: "우리집", x: 0, y: 0);

  List<String> sky = [
    "assets/img/sky01.png",
    "assets/img/sky02.png",
    "assets/img/sky03.png",
    "assets/img/sky04.png"
  ];

  List<String> status = [
    "날이 아주 좋아요!",
    "가벼운 산책은 어떤가요?",
    "오늘은 조금 흐리네요.",
    "감성 발라드로 우중충한 기분을 날려버리세요!"
  ];

  List<Color> color = [
    const Color(0xFFf78144),
    const Color(0xFF1d9fea),
    const Color(0xFF523de4),
    const Color(0xFF587d9a)
  ];

  int level = 0;

  void getWeather() async {
    final api = WeatherApi();
    final now = DateTime.now();
    Map<String, int> xy = Utils.latLngToXY(location.lat, location.lng);

    int time02 = int.parse("${now.hour}10");
    String time_ = "";

    if (time02 > 2300) {
      time_ = "2300";
    } else if (time02 > 2000) {
      time_ = "2000";
    } else if (time02 > 1700) {
      time_ = "1700";
    } else if (time02 > 1400) {
      time_ = "1400";
    } else if (time02 > 1100) {
      time_ = "1100";
    } else if (time02 > 800) {
      time_ = "0800";
    } else if (time02 > 500) {
      time_ = "0500";
    } else {
      time_ = "0200";
    }

    weather = await api.getWeather(xy["nx"], xy["ny"], Utils.getFormatTime(DateTime.now()), time_);

    int time = int.parse("${now.hour}00");
    weather.removeWhere((w) => w.time < time);

    current = weather.first;
    level = getLevel(current);

    setState(() {});
  }

  int getLevel(Weather w) {
    if (w.sky > 8) {
      return 3;
    } else if (w.sky > 5) {
      return 2;
    } else if (w.sky > 2) {
      return 1;
    }

    return 0;
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color[level],
      body: weather.isEmpty
          ? Container(
              child: const Text("날씨 정보를 로딩중입니다..."),
            )
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 50,
                  ),
                  Text(
                    location.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    alignment: Alignment.centerRight,
                    child: Image.asset(sky[level]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${current.tmp}℃",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      Column(
                        children: [
                          Text(
                            "${Utils.stringToDateTime(current.date).month}월 ${Utils.stringToDateTime(current.date).day}일",
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            status[level],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 30,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "오늘 어울리는 옷을 코디해줄게요.",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Container(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(clothes.length, (idx) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          clothes[idx],
                          fit: BoxFit.contain,
                        ),
                      );
                    }),
                  ),
                  Container(
                    height: 40,
                  ),
                  Expanded(
                    child: Container(
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(weather.length, (idx) {

                          final w = weather[idx];
                          int level_ = getLevel(w);

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${w.tmp}℃",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  "${w.pop}%",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.centerRight,
                                  child: Image.asset(sky[level_]),
                                ),
                                Text(
                                  "${w.time}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Container(height: 80),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          LocationData data = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => const LocationPage()));

          if (data != null) {
            location = data;
            getWeather();
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.location_on),
      ), //
    );
  }
}
