import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'application/song_book/song_book_state.dart';
import 'config/injectable/injectable.dart';
import 'config/localizations/app_localizations.dart';
import 'presentation/song_book/pages/HistoryPage.dart';
import 'presentation/song_book/pages/lyricsPage.dart';
import 'presentation/song_book/pages/searchPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initConfig();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
      ),
      supportedLocales: SUPPORTED_LOCALES,
      localizationsDelegates: [
        // To manage the translation in material widgets like DatePicker.
        GlobalMaterialLocalizations.delegate,
        // The delegate to check if there will be texts in LTR or RTL format.
        GlobalWidgetsLocalizations.delegate,
        // The custom delegate to manage the translations.
        AppLocalizations.delegate
      ],
      home: MyHomePage(),
      routes: {
        '/lyrics': (context) => LyricsPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _i18n = AppLocalizations.of(context);
    return ChangeNotifierProvider<SongBookState>.value(
      value: GetIt.I.get<SongBookState>(),
      builder: (context, child) {
        return Consumer<SongBookState>(
          builder: (context, state, widget) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                    _i18n.translate("song_book.pages.search.labels.title")),
              ),
              body: state.index == 0 ? SearchPage() : HistoryPage(),
              bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  Provider.of<SongBookState>(context, listen: false)
                      .changePage(index);
                },
                currentIndex: state.index,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt),
                    label: 'History',
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
