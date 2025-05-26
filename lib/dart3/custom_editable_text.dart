
part of 'index.dart';

/// 自定义文本编辑器
/// 1. 重写 buildTextSpan 方法达到样式控制
/// 2. 增加 style 属性达到动态样式控制
class CustomEditableText extends EditableText {
  /// 构建器
  final TextSpanBuilder builder;

  CustomEditableText({
    super.key,
    required this.builder,
    required super.controller,
    required super.focusNode,
    super.readOnly = false,
    super.obscureText = false,
    super.autocorrect = true,
    super.enableSuggestions = true,
    required super.style,
    super.strutStyle,
    required super.cursorColor,
    required super.backgroundCursorColor,
    super.textAlign = TextAlign.start,
    super.textDirection,
    super.locale,
    super.textScaleFactor,
    super.maxLines = 1,
    super.minLines,
    super.expands = false,
    super.forceLine = true,
    super.textWidthBasis = TextWidthBasis.parent,
    super.autofocus = false,
    super.showCursor,
    super.showSelectionHandles = false,
    super.selectionColor,
    super.selectionControls,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization = TextCapitalization.none,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onSelectionChanged,
    super.onSelectionHandleTapped,
    super.inputFormatters,
    super.rendererIgnoresPointer = false,
    super.cursorWidth = 2.0,
    super.cursorRadius,
    super.cursorOpacityAnimates = false,
    super.cursorOffset,
    super.paintCursorAboveText = false,
    super.scrollPadding = const EdgeInsets.all(20.0),
    super.keyboardAppearance = Brightness.light,
    super.dragStartBehavior = DragStartBehavior.start,
    super.enableInteractiveSelection = true,
    super.scrollController,
    super.scrollPhysics,
  });

  @override
  createState() => _EditableTextSpan();
}

class _EditableTextSpan extends EditableTextState {
  @override
  CustomEditableText get widget => super.widget as CustomEditableText;

  @override
  TextSpan buildTextSpan() {
    return TextSpan(
        style: widget.style,
        children: widget.builder.buildSpan(textEditingValue.text));
  }
}
