import 'package:flutter/material.dart';
import '../../../domain/soon_book/failures/song_book_failures.dart';
import '../../../domain/soon_book/song_book_objects/song_book_objects.dart';
import '../../core/form_field/formFields.dart';

class ArtistNameFormField extends StatelessWidget with SongBookFailureManager {
  ArtistNameFormField({
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
      tag: 'artistNameField',
      hintText: "Artist ",
      labelText: "Artist",
      validator: (String value) {
        final artistOrFailure = FieldArtistName(value);
        if (artistOrFailure.isValid()) {
          return null;
        }
        var error = getSongBookErrorContent(FieldArtistName(value).getError());
        return error.message;
      },
      onSaved: onSaved,
    );
  }
}
