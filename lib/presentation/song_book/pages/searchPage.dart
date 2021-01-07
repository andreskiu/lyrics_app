import 'package:flutter/material.dart';
import 'package:lyrics_app/domain/soon_book/models/song.dart';
import 'package:lyrics_app/domain/soon_book/song_book_objects/song_book_objects.dart';
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
    if (_searchSongFormKey.currentState.validate()) {
      _searchSongFormKey.currentState.save();
      await state.getLyrics();
      _displayLyrics(context, state.lastSong);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  ),
                  SizedBox(
                    height: _separation,
                  ),
                  SongNameFormField(
                    onSaved: (song) {
                      state.fieldSongName = FieldSongName(song);
                    },
                  ),
                  SizedBox(
                    height: _separation,
                  ),
                  Center(
                    child: FlatButton(
                      onPressed: () async {
                        _submit(context, state);
                      },
                      child: Text("Search"),
                    ),
                  ),
                  SizedBox(
                    height: _separation,
                  ),
                  if (state.lastSong != null) Text("Previous search "),
                  if (state.lastSong != null)
                    FlatButton(
                      onPressed: () async {
                        state.setFieldsFromLatestSong();
                        await state.getLyrics();
                        _displayLyrics(context, state.lastSong);
                      },
                      child: Text(state.lastSong.artist.name +
                          ": " +
                          state.lastSong.name),
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
