import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../config/localizations/app_localizations.dart';
import '../../../domain/song_book/models/song.dart';
import '../../../application/song_book/history_state.dart.dart';
import 'package:provider/provider.dart';

import 'lyricsPage.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key key}) : super(key: key);

  Future<void> _onTap({
    @required BuildContext context,
    @required Song song,
  }) async {
    final _song = await Provider.of<HistoryState>(context, listen: false)
        .getLyrics(song.artist.name, song.name);

    if (_song != null) {
      Navigator.of(context).pushNamed(
        "/lyrics",
        arguments: LyricsPageArguments(song: _song),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _i18n = AppLocalizations.of(context);
    return FutureProvider<HistoryState>(
      create: (context) => GetIt.I.getAsync<HistoryState>(),
      builder: (context, child) {
        return Consumer<HistoryState>(
          builder: (context, state, child) {
            if (state == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.history.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _i18n.translate(
                        "song_book.pages.history.labels.history_empty"),
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.history.length,
              itemBuilder: (context, index) {
                final _song = state.history[index];
                return ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text(_song.name),
                  subtitle: Text(_song.artist.name),
                  onTap: () {
                    _onTap(context: context, song: _song);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
