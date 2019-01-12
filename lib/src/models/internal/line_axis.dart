import 'dart:ui';

class LineAxis {
  String _label;
  Offset _textOffset;
  Offset _lineStartOffset;
  Offset _lineEndOffset;

  LineAxis(this._label, this._textOffset, this._lineStartOffset,
      this._lineEndOffset);

  Offset get lineEndOffset => _lineEndOffset;

  Offset get lineStartOffset => _lineStartOffset;

  Offset get textOffset => _textOffset;

  String get label => _label;


}