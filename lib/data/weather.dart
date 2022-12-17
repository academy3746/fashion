class Weather {
  // 날짜
  String date;

  // 시간
  int time;

  // 강수확률
  int pop;

  // 강수형태
  int pty;

  // 강수량
  String pcp;

  // 대기 상태
  int sky;

  // 풍속
  double wsd;

  // 온도
  int tmp;

  // 상대습도
  int reh;

  Weather(
      {this.date,
      this.time,
      this.pop,
      this.pty,
      this.pcp,
      this.sky,
      this.wsd,
      this.tmp,
      this.reh});

  factory Weather.fromJson(Map<String, dynamic> data) {
    return Weather(
      date: data["fcstDate"],
      time: int.tryParse(data["fcstTime"] ?? "") ?? 0,
      pop: int.tryParse(data["POP"] ?? "") ?? 0,
      pty: int.tryParse(data["PCY"] ?? "") ?? 0,
      pcp: data["PCP"] ?? "",
      sky: int.tryParse(data["SKY"] ?? "") ?? 0,
      wsd: double.tryParse(data["WSD"] ?? "") ?? 0,
      tmp: int.tryParse(data["TMP"] ?? "") ?? 0,
      reh: int.tryParse(data["REH"] ?? "") ?? 0,
    );
  }
}
