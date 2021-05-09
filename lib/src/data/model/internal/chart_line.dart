import 'dart:ui';

class ChartLine {
  final String? _label;
  final Offset _textOffset;
  final Offset _lineStartOffset;
  final Offset _lineEndOffset;

  ChartLine(this._label, this._textOffset, this._lineStartOffset,
      this._lineEndOffset);

  Offset get lineEndOffset => _lineEndOffset;

  Offset get lineStartOffset => _lineStartOffset;

  Offset get textOffset => _textOffset;

  String? get label => _label;
}
