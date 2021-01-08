import 'package:flutter/material.dart';
import '../../../domain/soon_book/failures/song_book_failures.dart';
import '../../../domain/soon_book/song_book_objects/song_book_objects.dart';
import '../../core/form_field/formFields.dart';

class SongNameFormField extends StatelessWidget with SongBookFailureManager {
  SongNameFormField({
    this.onChanged,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.enabled = true,
  });
  final bool enabled;
  final Function(String) onSaved;
  final Function(String) validator;
  final Function(String) onChanged;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return CustomFormField(
      enabled: enabled,
      initialValue: initialValue,
      tag: 'songNameField',
      hintText: "Song",
      labelText: "Song",
      validator: (String value) {
        final _songOrFailure = FieldArtistName(value);
        if (_songOrFailure.isValid()) {
          return null;
        }
        var error = getSongBookErrorContent(FieldSongName(value).getError());
        return error.message;
      },
      onSaved: onSaved,
    );
  }
}