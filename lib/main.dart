import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/Currency.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:intl/intl.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

//MyApp class--StateLess
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localizations Sample App',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'), // farsi
      ],
      theme: ThemeData(
          fontFamily: 'Microsoft Uighur',
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontFamily: 'MSUIGHUB.ttf',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            headlineMedium: TextStyle(
                fontFamily: 'MSUIGHUR.ttf',
                fontSize: 16,
                fontWeight: FontWeight.w700),
            titleLarge: TextStyle(
                fontFamily: 'MSUIGHUB.ttf',
                fontSize: 16,
                color: Color.fromARGB(255, 1, 110, 5)),
            titleMedium: TextStyle(
                fontFamily: "MSUIGHUB.ttf", fontSize: 16, color: Colors.red),
          )),
      debugShowCheckedModeBanner: false,
      home: const ApBar(),
    );
  }
}

//class ApBar man Hamoon Home dar dars ast
//body application dar class Apbar

// ignore: must_be_immutable
class ApBar extends StatefulWidget {
  const ApBar({super.key});

  @override
  State<ApBar> createState() => _ApBarState();
}

class _ApBarState extends State<ApBar> {
  List<Currency> currency = [];

  Future getResponse(BuildContext cntx) async {
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";

    var value = await http.get(Uri.parse(url));

    if (currency.isEmpty && value.statusCode == 200) {
      // ignore: use_build_context_synchronously
      _showSnackBar(context, "بروز رسانی با موفقیت انحام شد ");
      List jsonList = convert.jsonDecode(value.body);
      if (jsonList.isNotEmpty) {
        for (int i = 0; i < jsonList.length; i++) {
          setState(() {
            currency.add(Currency(
                id: jsonList[i]["id"],
                title: jsonList[i]["title"],
                price: jsonList[i]["price"],
                changes: jsonList[i]["changes"],
                status: jsonList[i]["status"]));
          });
        }
      }
    }

    return value;
  }

  @override
  void initState() {
    super.initState();
    getResponse(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(elevation: 0, backgroundColor: Colors.blueGrey[200], actions: [
        Image.asset("assets/image/dollar.png"),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "قیمت بروز ارز ",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Image.asset("assets/image/icons-menu.png"),
            ),
          ),
        ),
      ]),
      body: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("assets/image/question.png"),

                    //in sizbox bayad hazf bshe

                    Text(
                      "  نرخ ارز آزاد چیست ؟",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
                Text(
                  ''' نرخ ارزها در معاملت نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله ارز و ریال را با هم تبادل می نمایند .''',
                  style: Theme.of(context).textTheme.headlineMedium,
                  // textDirection: TextDirection.rtl,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 25, 0, 5),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(1000)),
                      color: Colors.grey[300],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("نام آزاد ارز",
                            style: Theme.of(context).textTheme.bodyLarge),
                        Text("قیمت",
                            style: Theme.of(context).textTheme.bodyLarge),
                        Text("تغییر",
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                ),
                //list
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: listFutureBuilder(context),
                ),

                //updayt btn box
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 16,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(1000)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //update btn
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 16,
                          child: Row(children: [
                            TextButton.icon(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.amber),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(1000)))),
                                onPressed: () {
                                  currency.clear();
                                  listFutureBuilder(context);
                                },
                                icon: const Icon(CupertinoIcons.refresh_bold),
                                label: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 0, 0, 0),
                                  child: Text(
                                    "بروز زسانی",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                )),
                          ]),
                        ),

                        //update btn
                        Text("آخرین بروز رسانی${_getTIme()}"),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: currency.length,
                itemBuilder: (BuildContext context, int postion) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 3),
                    child: MyItem(postion, currency),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  if (index % 6 == 0) {
                    return const Reklam();
                  } else {
                    return const SizedBox.shrink();
                  }
                })
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
      future: getResponse(context),
    );
  }

  String _getTIme() {
    DateTime now = DateTime.now();

    return DateFormat('kk:mm:ss').format(now);
  }
}

// ignore: must_be_immutable
class MyItem extends StatelessWidget {
  int postion;
  List<Currency> currency;
  MyItem(this.postion, this.currency, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[BoxShadow(blurRadius: 1, color: Colors.grey)],
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        color: Colors.grey,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            currency[postion].title!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            getFarsiNumber(currency[postion].price.toString()),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            getFarsiNumber(currency[postion].changes.toString()),
            style: currency[postion].status == "n"
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class Reklam extends StatelessWidget {
  const Reklam({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(blurRadius: 1, color: Colors.redAccent)
        ],
        borderRadius: BorderRadius.all(Radius.circular(1000)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "تبلیغات",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

void _showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: Theme.of(context).textTheme.bodyLarge,
    ),
    backgroundColor: Colors.green,
  ));
}

String getFarsiNumber(String number) {
  const en = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  for (var element in en) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  }
  return number;
}
