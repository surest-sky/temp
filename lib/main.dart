import 'package:flutter/material.dart';
import 'package:kwh/view/AppPage.dart';
import 'package:kwh/view/SearchPage.dart';
import 'package:kwh/view/auth/login.dart';
import 'package:kwh/view/auth/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kwh/view/pages/ItemWebViewPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


void main() {
  SharedPreferences.setMockInitialValues({});
  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TutorPage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        'loginPage': (context) => const LoginPage(),
        'registerPage': (context) => const DropDownListExample(),
        'appPage': (context) => const AppPage(),
        'searchPage': (context) => const SearchPage(),
        'itemWebViewPage': (context) => const ItemWebViewPage(),
      },
      initialRoute: 'appPage',
      builder: EasyLoading.init(),
    );
  }
}
