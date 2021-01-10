import 'package:flutter/material.dart';
import '../../core/widgets/buttons/primary_button.dart';
import '../../../config/localizations/app_localizations.dart';
import '../../../domain/song_book/models/song.dart';
import '../../../domain/song_book/song_book_objects/song_book_objects.dart';
import '../widgets/artist_form_field.dart';
import '../widgets/song_form_field.dart';
import '../../../application/song_book/song_book_state.dart';
import 'package:provider/provider.dart';

import 'lyricsPage.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key key}) : super(key: key);

  final GlobalKey<FormState> _searchSongFormKey = GlobalKey<FormState>();
  final _separation = 10.0;

  Future<void> _displayLyrics(BuildContext context, Song song) {
    return Navigator.of(context).pushNamed(
      "/lyrics",
      arguments: LyricsPageArguments(song: song),
    );
  }

  Future<void> _submit(BuildContext context, SongBookState state) async {
    _closeKeyboard(context);
    if (_searchSongFormKey.currentState.validate()) {
      _searchSongFormKey.currentState.save();
      final _lyricWasFound = await state.getLyrics();
      if (_lyricWasFound) {
        _displayLyrics(context, state.lastSong);
      }
    }
  }

  void _closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _submitPreviousSearch(
      BuildContext context, SongBookState state) async {
    state.setFieldsFromLatestSong();
    await state.getLyrics();
    _displayLyrics(context, state.lastSong);
  }

  @override
  Widget build(BuildContext context) {
    final _i18n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Consumer<SongBookState>(
          builder: (context, state, child) {
            return Form(
              key: _searchSongFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArtistNameFormField(
                    onSaved: (artist) {
                      state.fieldArtistName = FieldArtistName(artist);
                    },
                    initialValue: state.fieldArtistName?.getValue() ?? "",
                  ),
                  SizedBox(
                    height: _separation,
                  ),
                  SongNameFormField(
                    onSaved: (song) {
                      state.fieldSongName = FieldSongName(song);
                    },
                    initialValue: state.fieldSongName?.getValue() ?? "",
                  ),
                  SizedBox(
                    height: _separation,
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      width: MediaQuery.of(context).size.width / 2,
                      child: PrimaryButton(
                        enabled: !state.isLoading,
                        onPressed: () async {
                          _submit(context, state);
                        },
                        textButton: _i18n.translate(
                          "song_book.pages.search.buttons.search",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _separation,
                  ),
                  if (state.lastSong != null)
                    Text(
                      _i18n.translate(
                          "song_book.pages.search.labels.previous_search"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (state.lastSong != null)
                    TextButton(
                        onPressed: () async {
                          _submitPreviousSearch(context, state);
                        },
                        child: Text(
                          state.lastSong.artist.name +
                              ": " +
                              state.lastSong.name,
                        )),
                  if (state.isLoading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!state.isLoading && state.error != null)
                    Center(
                      child: Text(
                        _i18n.translate(state.error.message),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
