part of 'index.dart';

/// TextSpan 库定义的基本组件
/// 此组件使用限制：
///   每一个 range 范围，只能有一个组件，
class TextSpanWidget implements Comparable<TextSpanWidget> {
  /// 范围
  TextRange range;

  /// 是否以块的形式展示，当 black 为true时，范围内的内容将不能被光标定位，且删除内容时会将一整块的内容均删除
  final bool block;

  /// 组件
  final TextSpan span;

  TextSpanWidget({
    required this.range,
    this.block = false,
    required this.span,
  });

  @override
  int compareTo(TextSpanWidget other) {
    return range.start.compareTo(other.range.start);
  }
}

/// At功能的TextSpan
class AtTextSpan extends TextSpan {
  /// 被@用户的ID
  final String id;

  const AtTextSpan({
    required this.id,
    required String super.text,
    super.children,
    super.style,
    super.recognizer,
    super.semanticsLabel,
  });
}
