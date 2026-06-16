import 'package:easy_helper/easy_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '/routes.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
import 'core/helper/assets.dart';
import 'core/helper/custom_colors.dart';
import 'core/helper/custom_themes.dart';
import 'core/services/hive_service.dart';
import 'core/services/service_locator.dart';
import 'fcm.dart';
import 'firebase_options.dart';


@pragma('vm:entry-point')
Future<void> background(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FCMManager.init();
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  await setup();

  FirebaseMessaging.onBackgroundMessage(background);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _inti();
    CustomImage.isCashed = true;
    _updateApp();
    HiveService.theme.listen((event) {
      _updateApp();
    });
  }

  void _updateApp() {
    WidgetsBinding.instance.performReassemble();
    setState(() {});
  }

  void _inti() {
    HiveService.languageStream?.listen((event) {
      _locale = Locale(event.value);
      _updateApp();
      updateHeader();
    });
  }

  Locale _locale = Locale(HiveService.ln ?? "fa");

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromView(View.of(context)).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: MaterialApp.router(
        title: 'Masir',
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode &&
                supportedLocale.countryCode == locale?.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        supportedLocales: const [
          Locale('fa'),
          // Locale('en'),
        ],
        locale: _locale,
        localeListResolutionCallback: (locales, supportedLocales) => _locale,
        debugShowCheckedModeBanner: false,
        // navigatorKey: CustomNavigator.navigatorKey,
        // onUnknownRoute: (settings) {
        //   return MaterialPageRoute(
        //     builder: (context) => NotFoundPage(route: "${settings.name}"),
        //   );
        // },
        // onGenerateRoute: onGenerateRoute,
        // navigatorObservers: [LifecycleNavigatorHandler()],
        // initialRoute: initialRoute,
        routerConfig: router,
        builder: (context, widget) {
          GEasyHelper.background = Container(
            color: AppColor.background,
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
          );
          GEasyHelper.body = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomImage(
                assets: Assets.logo,
                width: 200,
              ),
              40.h,
              const Directionality(
                textDirection: TextDirection.rtl,
                child: CustomText(
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.white,
                  "خطای اتصال به سرور\nلطفا اینترنت خود را برسی کنید.",
                ),
              ),
            ],
          );
          GEasyHelper.retryWidget = CustomButton(
            title: "تلاش مجدد",
            width: MediaQuery.sizeOf(context).width,
            height: 48,
          );
          GEasyHelper.backWidget = CustomButton(
            title: "برشگت",
            width: MediaQuery.sizeOf(context).width,
            height: 48,
          );
          GEasyHelper.color = Colors.transparent;
          return widget ?? Container();
        },
        theme: light,
      ),
    );
  }
}
