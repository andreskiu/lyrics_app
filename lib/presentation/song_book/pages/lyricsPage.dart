import 'package:flutter/material.dart';
import '../../../domain/soon_book/models/song.dart';

class LyricsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LyricsPageArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.song.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Text(
            args.song.lyrics,
          ),
        ),
      ),
    );
  }
}

class LyricsPageArguments {
  final Song song;
  LyricsPageArguments({@required this.song});
}
