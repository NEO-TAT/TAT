// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

class StrutStyleText extends StatelessWidget {
  const StrutStyleText(
    this._text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    bool softWrap = true,
    int? maxLines,
  })  : _style = style,
        _textAlign = textAlign,
        _overflow = overflow,
        _softWrap = softWrap,
        _maxLines = maxLines,
        super(key: key);

  final String _text;
  final TextStyle? _style;
  final TextAlign? _textAlign;
  final TextOverflow? _overflow;
  final bool _softWrap;
  final int? _maxLines;

  @override
  Widget build(BuildContext context) => Text(
        _text,
        style: _style,
        textAlign: _textAlign,
        overflow: _overflow,
        softWrap: _softWrap,
        maxLines: _maxLines,
        strutStyle: StrutStyle(
          forceStrutHeight: true,
          height: _style?.height ?? 1,
        ),
      );
}
