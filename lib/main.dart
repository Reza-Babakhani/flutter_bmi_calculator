import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tapsell_plus/tapsell_plus.dart';

void main() {
  runApp(const MyApp());

  const appId =
      "gtspkloicrsmfseiijbjmtgdbqfackjmrblmfnblkjnjprdpblqiqsleadggorkhkaqklh";
  TapsellPlus.instance.initialize(appId);
  TapsellPlus.instance.setGDPRConsent(true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey, fontFamily: "Yekan"),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> ad() async {
    String adId = await TapsellPlus.instance.requestStandardBannerAd(
        "63de1f6eb5ab332b5c1834f7", TapsellPlusBannerType.BANNER_320x50);

    await TapsellPlus.instance.showStandardBannerAd(adId,
        TapsellPlusHorizontalGravity.BOTTOM, TapsellPlusVerticalGravity.CENTER,
        margin: const EdgeInsets.only(bottom: 1), onOpened: (map) {
      // Ad opened
    }, onError: (map) {
      // Error when showing ad
    });
  }

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double _bmiValue = 0;
  @override
  void initState() {
    super.initState();
    _heightController.addListener(() {
      calculateBMI();
    });
    _weightController.addListener(() {
      calculateBMI();
    });
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await ad();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void calculateBMI() {
    double? height = double.tryParse(_heightController.text);
    double? weight = double.tryParse(_weightController.text);

    if (height != null && weight != null) {
      double heightInCm = (height / 100);
      setState(() {
        _bmiValue = weight / (heightInCm * heightInCm);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Neumorphic(
                  style: const NeumorphicStyle(depth: -8),
                  child: SfRadialGauge(
                    enableLoadingAnimation: true,
                    axes: [
                      RadialAxis(
                        canScaleToFit: true,
                        startAngle: 150,
                        endAngle: 30,
                        interval: 5,
                        maximum: 45,
                        minimum: 10,
                        showLastLabel: false,
                        showFirstLabel: false,
                        pointers: [NeedlePointer(value: _bmiValue)],
                        ranges: [
                          GaugeRange(
                            startValue: 0,
                            endValue: 16,
                            color: Colors.red.shade900,
                            label: "لاغری شدید",
                          ),
                          GaugeRange(
                            startValue: 16,
                            endValue: 18.5,
                            color: Colors.yellow,
                            label: "لاغری",
                          ),
                          GaugeRange(
                            startValue: 18.5,
                            endValue: 25,
                            color: Colors.green,
                            label: "مناسب",
                          ),
                          GaugeRange(
                            startValue: 25,
                            endValue: 30,
                            color: Colors.yellow,
                            label: "اضافه وزن",
                          ),
                          GaugeRange(
                            startValue: 30,
                            endValue: 35,
                            color: Colors.red,
                            label: "چاقی کلاس 1",
                          ),
                          GaugeRange(
                            startValue: 35,
                            endValue: 40,
                            color: Colors.red.shade700,
                            label: "چاقی کلاس 2",
                          ),
                          GaugeRange(
                            startValue: 40,
                            endValue: 100,
                            color: Colors.red.shade900,
                            label: "چاقی کلاس 3",
                          ),
                        ],
                        annotations: [
                          GaugeAnnotation(
                            widget: getLabel(),
                            positionFactor: 0.3,
                            angle: 90,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Neumorphic(
                          style: const NeumorphicStyle(depth: -8),
                          child: TextField(
                            decoration: const InputDecoration(
                              label: Text(" قد (سانتی متر)"),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                            controller: _heightController,
                            onTap: () {
                              /* _heightController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _heightController.text.length)); */
                              _heightController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Neumorphic(
                          style: const NeumorphicStyle(depth: -8),
                          child: TextField(
                            decoration: const InputDecoration(
                              label: Text(" وزن (کیلوگرم)"),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                            controller: _weightController,
                            onTap: () {
                              /* _weightController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _weightController.text.length)); */
                              _weightController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text getLabel() {
    var baseStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    if (_bmiValue >= 1 && _bmiValue < 16) {
      return Text(
        "BMI = ${_bmiValue.toStringAsFixed(1)}\nلاغری شدید",
        style: baseStyle.copyWith(color: Colors.red.shade900),
        textAlign: TextAlign.center,
      );
    } else if (_bmiValue >= 16 && _bmiValue <= 18.5) {
      return Text(
        "BMI = ${_bmiValue.toStringAsFixed(1)}\nلاغری",
        style: baseStyle.copyWith(color: Colors.yellow, shadows: [
          const Shadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)
        ]),
        textAlign: TextAlign.center,
      );
    } else if (_bmiValue > 18.5 && _bmiValue <= 25) {
      return Text(
        "BMI = ${_bmiValue.toStringAsFixed(1)}\nمناسب",
        style: baseStyle.copyWith(color: Colors.green),
        textAlign: TextAlign.center,
      );
    } else if (_bmiValue > 25 && _bmiValue <= 30) {
      return Text(
        "BMI = ${_bmiValue.toStringAsFixed(1)}\nاضافه وزن",
        style: baseStyle.copyWith(color: Colors.yellow, shadows: [
          const Shadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)
        ]),
        textAlign: TextAlign.center,
      );
    } else if (_bmiValue > 30 && _bmiValue <= 35) {
      return Text(
        "BMI = ${_bmiValue.toStringAsFixed(1)}\nچاقی کلاس یک",
        style: baseStyle.copyWith(color: Colors.red),
        textAlign: TextAlign.center,
      );
    } else if (_bmiValue > 35 && _bmiValue <= 40) {
      return Text(
        "BMI = ${_bmiValue.toStringAsFixed(1)}\n چاقی کلاس دو",
        style: baseStyle.copyWith(color: Colors.red.shade700),
        textAlign: TextAlign.center,
      );
    } else if (_bmiValue > 40 && _bmiValue <= 60) {
      return Text(
        "BMI = ${_bmiValue.toStringAsFixed(1)}\n چاقی کلاس سه",
        style: baseStyle.copyWith(color: Colors.red.shade900),
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        "",
      );
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();

    super.dispose();
  }
}
