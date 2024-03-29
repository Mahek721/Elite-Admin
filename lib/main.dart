import 'dart:io';
import 'package:elite_admin_panel/Screen/login_screen.dart';
import 'package:elite_admin_panel/Screen/splash_screen.dart';
import 'package:elite_admin_panel/Theme/theme_color_scheme.dart';
import 'package:elite_admin_panel/Theme/theme_provider.dart';
import 'package:elite_admin_panel/admin_shared_prefernces/loggedadmin.dart';
import 'package:elite_admin_panel/admin_shared_prefernces/save_admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 300));
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String email = "";
  ThemeProvider themeChangeProvider = ThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.themePreference.getTheme();
    getCurrentAppTheme();
  }

  @override
  void initState() {
    super.initState();
    CurrentUser();
  }

  Future<void> CurrentUser() async {
    var res = await SaveAdmin().CurrentAdmin();
    setState(() {
      email = res;
      if(email != "" || email != null){
        LoggedAdmin.email = email;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context,value,child) {
          return GetMaterialApp(
            title: "Elite Admin",
            debugShowCheckedModeBanner: false,
            theme: ThemeColor.themeData(themeChangeProvider.darkTheme, context),
            home: email == "" || email == null ? Login_page_admin() : SplashScreen(),
            // home: Scaffold(),
          );
        },
      ),
    );
    // return GetMaterialApp(
    //   title: "Elite Admin",
    //   debugShowCheckedModeBanner: false,
    //   home: email == "" || email == null ? Login_page_admin() : MainScreen(),
    //   // home: Scaffold(),
    // );
  }
}