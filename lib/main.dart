import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pulse_india/localization/app_translations_delegate.dart';
import 'package:pulse_india/localization/application.dart';
import 'package:pulse_india/pages/home_page.dart';
import 'package:pulse_india/themes/app_settings_change_notifier.dart';
import 'package:pulse_india/themes/theme_constants.dart';
import 'package:pulse_india/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  SharedPreferences.getInstance().then((preferences) {
    runApp(PulseIndia(preferences: preferences));
  });
}

class PulseIndia extends StatefulWidget {
  final SharedPreferences preferences;
  PulseIndia({
    this.preferences,
  });

  @override
  _PulseIndiaState createState() => _PulseIndiaState();
}

class _PulseIndiaState extends State<PulseIndia> {
  @override
  Widget build(BuildContext context) {
    String themeName =
        (widget.preferences.getString('theme') ?? ThemeNames.Red);

    Locale locale =
        new Locale((widget.preferences.getString('localeLang') ?? 'en'));

    return ChangeNotifierProvider<AppSettingsChangeNotifier>(
      create: (_) => AppSettingsChangeNotifier(
          _handleThemeConfiguration(), themeName, locale),
      child: AppWithCustomTheme(
        preferences: widget.preferences,
      ),
    );
  }

  ThemeData _handleThemeConfiguration() {
    String themeName =
        (widget.preferences.getString('theme') ?? ThemeNames.Amber);

    switch (themeName) {
      case ThemeNames.Purple:
        return ThemeConfig.purpleThemeData(context);
      case ThemeNames.Blue:
        return ThemeConfig.blueThemeData(context);
      case ThemeNames.Teal:
        return ThemeConfig.tealThemeData(context);
      case ThemeNames.Amber:
        return ThemeConfig.amberThemeData(context);
      case ThemeNames.Red:
        return ThemeConfig.redThemeData(context);
    }
  }
}

class AppWithCustomTheme extends StatefulWidget {
  final SharedPreferences preferences;
  AppWithCustomTheme({@required this.preferences});

  @override
  _AppWithCustomThemeState createState() => _AppWithCustomThemeState();
}

class _AppWithCustomThemeState extends State<AppWithCustomTheme> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppSettingsChangeNotifier>(context);
    onLocaleChange(theme.getLocale());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      color: Colors.white,
      title: 'Pulse India',
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
      darkTheme: theme.getTheme(),
      themeMode: ThemeMode.light,
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
      },
      home: WelcomePage(
        preferences: widget.preferences,
      ),
      localizationsDelegates: [
        _newLocaleDelegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en", ""),
        const Locale("mr", ""),
      ],
    );
  }
}
