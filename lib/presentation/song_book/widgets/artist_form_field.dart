import 'package:flutter/material.dart';
import '../../../config/localizations/app_localizations.dart';
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
    final _i18n = AppLocalizations.of(context);
    return CustomFormField(
      enabled: enabled,
      initialValue: initialValue,
      tag: 'artistNameField',
      hintText: _i18n.translate("song_book.fields.artist.label"),
      labelText: _i18n.translate("song_book.fields.artist.label"),
      validator: (String value) {
        final artistOrFailure = FieldArtistName(value);
        if (artistOrFailure.isValid()) {
          return null;
        }
        var error = getSongBookErrorContent(FieldArtistName(value).getError());
        return _i18n.translate(error.message);
      },
      onSaved: onSaved,
    );
  }
}
