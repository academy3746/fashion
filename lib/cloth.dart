import 'package:fashion/data/preference.dart';
import 'package:fashion/data/weather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClothPage extends StatefulWidget {
  const ClothPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ClothPageState();
  }
}

class _ClothPageState extends State<ClothPage> {
  List<ClothTmp> clothes = [];

  List<List<String>> sets = [
    [
      "assets/img/jumper.png",
      "assets/img/long_sleeve.png",
      "assets/img/pants.png"
    ],
    [
      "assets/img/jumper01.png",
      "assets/img/long_sleeve01.png",
      "assets/img/pants01.png"
    ]
  ];

  void getCloth() async {
    final pref = Preference();
    clothes = await pref.getTmp();

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCloth();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: List.generate(clothes.length, (idx) {
          return InkWell(
            child: Container(
              child: Column(
                children: [
                  Text("${clothes[idx].tmp}℃"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(clothes[idx].cloth.length, (idx_) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          clothes[idx].cloth[idx_],
                          fit: BoxFit.contain,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            onTap: (){
              showDialog(
                  context: context,
                  builder: (ctx){
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(sets.length, (idx_){
                          return InkWell(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: List.generate(sets[idx_].length, (idx__) {
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    width: 50,
                                    height: 50,
                                    child: Image.asset(
                                      sets[idx_][idx__],
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                }),
                              ),
                            ),
                            onTap: () async {
                              clothes[idx].cloth = sets[idx_];

                              final pref = Preference();
                              await pref.setTmp(clothes[idx]);

                              Navigator.of(context).pop();

                              setState(() {});
                            },
                          );
                        }),
                      ),
                      actions: [
                        TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: const Text("닫기"))
                      ],
                    );
                  }
              );
            },
          );
        }),
      ),
    );
  }
}