import 'package:fashion/data/api.dart';
import 'package:fashion/data/weather.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color[level],
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 50,
            ),
            const Text("구로구", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              alignment: Alignment.centerRight,
              child: Image.asset(sky[level]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("-8℃", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),),
                Column(
                  children: [
                    const Text("12월 17일", style: TextStyle(color: Colors.white, fontSize: 14),),
                    Text(status[level], style: const TextStyle(color: Colors.white, fontSize: 14),),
                  ],
                ),
              ],
            ),
            Container(
              height: 30,
            ),
             Container(
               margin: const EdgeInsets.symmetric(horizontal: 20),
               child: const Text("오늘 어울리는 옷을 코디해줄게요.", style: TextStyle(color: Colors.white, fontSize: 18),),
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
              height: 15,
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(10, (idx) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("온도", style: TextStyle(color: Colors.white, fontSize: 12),),
                        const Text("강수확률", style: TextStyle(color: Colors.white, fontSize: 12),),
                        Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          child: Image.asset("assets/img/sky01.png"),
                        ),
                        const Text("0800", style: TextStyle(color: Colors.white, fontSize: 12),),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final api = WeatherApi();

          List<Weather> weather = await api.getWeather(1, 1, 20221217, "0500");

          for (final w in weather) {
            if (kDebugMode) {
              print(w.date);
              print(w.time);
              print(w.tmp);
            }
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), //
    );
  }
}
