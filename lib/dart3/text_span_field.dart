part of 'index.dart';

typedef InputCounterWidgetBuilder = Widget Function(
  BuildContext context, {
  required int currentLength,
  required int maxLength,
  required bool isFocused,
});

class _TextSpanFieldSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  _TextSpanFieldSelectionGestureDetectorBuilder({
    required _TextSpanFieldState state,
  })  : _state = state,
        super(delegate: state);

  final _TextSpanFieldState _state;

  @override
  void onForcePressStart(ForcePressDetails details) {
    super.onForcePressStart(details);
    if (delegate.selectionEnabled && shouldShowSelectionToolbar) {
      editableText.showToolbar();
    }
  }

  @override
  void onForcePressEnd(ForcePressDetails details) {}

  @override
  void onSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state.context).platform) {
        case TargetPlatform.iOS:
          renderEditable.selectPositionAt(
            from: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          renderEditable.selectWordsInRange(
            from: details.globalPosition - details.offsetFromOrigin,
            to: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
        default:
          break;
      }
    }
  }

  @override
  void onSingleTapUp(TapDragUpDetails details) {
    editableText.hideToolbar();
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state.context).platform) {
        case TargetPlatform.iOS:
          renderEditable.selectWordEdge(cause: SelectionChangedCause.tap);
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          renderEditable.selectPosition(cause: SelectionChangedCause.tap);
          break;
        default:
          break;
      }
    }
    _state._requestKeyboard();
    _state.widget.onTap?.call();
  }

  @override
  void onSingleLongTapStart(LongPressStartDetails details) {
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state.context).platform) {
        case TargetPlatform.iOS:
          renderEditable.selectPositionAt(
            from: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          renderEditable.selectWord(cause: SelectionChangedCause.longPress);
          Feedback.forLongPress(_state.context);
          break;
        default:
          break;
      }
    }
  }
}

class TextSpanField extends StatefulWidget {
  const TextSpanField({
    super.key,
    required this.textSpanBuilder,
    this.controller,
    this.focusNode,
    this.style,
    this.strutStyle,
    this.decoration = const InputDecoration(
      isCollapsed: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
    ),
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.center,
    this.textDirection = TextDirection.ltr,
    this.readOnly = false,
    this.enabled = true, // 是否可编辑
    this.autofocus = false,
    this.obscureText = false, // 密码输入
    this.autocorrect = true, // 启用自动更正
    this.enableSuggestions = true, // 启用自动建议
    this.maxLines,
    this.minLines = 1,
    this.expands = false,
    this.maxLength = 500,
    this.maxLengthEnforced = true, // 是否限制最大长度
    this.showCursor = true, // 显示光标
    this.cursorWidth = 2.0, // 光标宽度
    this.cursorRadius, // 光标圆角
    this.cursorColor, // 光标颜色
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.send,
    this.textCapitalization = TextCapitalization.none, // 文本输入时的字母大小写转换行为
    this.keyboardAppearance = Brightness.light,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start, // 控制拖动手势的开始行为
    this.enableInteractiveSelection = true, // 启用交互式选择
    this.showCounter = false, // 是否显示计数器
    this.buildCounter, // 计数器小部件构建器
    this.scrollController, // 滚动控制器
    this.scrollPhysics, // 滚动物理特性效果

    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
  })  : assert(minLines == null || minLines > 0, 'minLines的值必须大于0'),
        assert(maxLines == null || maxLines > 0, 'maxLines的值必须大于0'),
        assert(maxLines == null || minLines == null || maxLines >= minLines, 'minLines必须小于等于maxLines'),
        assert(!expands || (minLines == null && maxLines == null), '当expands为true时，minLines和maxLines必须为null'),
        assert(!obscureText || maxLines == 1, '当obscureText为true时，maxLines必须为1'),
        assert(maxLength == null || maxLength == TextSpanField.noMaxLength || maxLength > 0, 'maxLength的值必须大于0');

  final TextSpanBuilder textSpanBuilder;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final InputDecoration decoration;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final TextDirection textDirection;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final bool maxLengthEnforced;
  final bool showCursor;
  final double cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;
  final DragStartBehavior dragStartBehavior;
  final bool enableInteractiveSelection;
  final InputCounterWidgetBuilder? buildCounter;
  final bool showCounter;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;
  bool get selectionEnabled => enableInteractiveSelection;
  static const int noMaxLength = -1;

  @override
  State<TextSpanField> createState() => _TextSpanFieldState();
}

class _TextSpanFieldState extends State<TextSpanField> implements TextSelectionGestureDetectorBuilderDelegate {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  TextEditingController get _controller => widget.controller ?? controller;
  FocusNode get _focusNode => widget.focusNode ?? focusNode;

  bool _isHovering = false;

  bool _showSelectionHandles = false;

  late _TextSpanFieldSelectionGestureDetectorBuilder
      _selectionGestureDetectorBuilder;

  late TextSpanBuilder _textSpanBuilder;

  // API for TextSelectionGestureDetectorBuilderDelegate.
  @override
  late bool forcePressEnabled;

  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  bool get selectionEnabled => widget.selectionEnabled;

  // End of API for TextSelectionGestureDetectorBuilderDelegate.

  bool get _isEnabled => widget.enabled;

  int get _currentLength => _controller.value.text.runes.length;

  // 显示计数器部件
  InputDecoration _getEffectiveDecoration() {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final InputDecoration decoration = (widget.decoration)
        .applyDefaults(themeData.inputDecorationTheme)
        .copyWith(
          enabled: widget.enabled,
          hintMaxLines: widget.decoration.hintMaxLines ?? widget.maxLines,
        );

    // 如果没有maxLength或者直接给出counter或counterText，则不需要构建任何东西。
    if (widget.maxLength == null ||
        decoration.counter != null ||
        decoration.counterText != null) {
      return decoration;
    }

    // 如果提供了buildCounter，则使用它来生成计数器小部件。
    if (widget.buildCounter != null) {
      Widget counter;
      final bool isFocused = _focusNode.hasFocus;
      counter = Semantics(
        container: true,
        liveRegion: isFocused,
        child: widget.buildCounter!(
          context,
          currentLength: _currentLength,
          maxLength: widget.maxLength ?? TextSpanField.noMaxLength,
          isFocused: isFocused,
        ),
      );
      return decoration.copyWith(counter: counter);
    }

    String counterText = '$_currentLength';
    String semanticCounterText = '';

    int maxLength = widget.maxLength!;
    counterText += '/$maxLength';
    final int remaining = (maxLength - _currentLength).clamp(0, maxLength);
    semanticCounterText = localizations.remainingTextFieldCharacterCount(remaining);

    // 手柄长度超过最大长度
    if (_controller.value.text.runes.length > maxLength) {
      return decoration.copyWith(
        errorText: decoration.errorText ?? '',
        counterStyle: decoration.errorStyle ??
            themeData.textTheme.bodySmall
                ?.copyWith(color: themeData.colorScheme.error),
        counterText: counterText,
        semanticCounterText: semanticCounterText,
      );
    }

    return decoration.copyWith(
      counterText: counterText,
      semanticCounterText: semanticCounterText,
    );
  }

  @override
  void initState() {
    super.initState();
    _selectionGestureDetectorBuilder = _TextSpanFieldSelectionGestureDetectorBuilder(state: this);
    _textSpanBuilder = widget.textSpanBuilder;
    _focusNode.canRequestFocus = _isEnabled;
  }

  @override
  void didUpdateWidget(TextSpanField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      controller = TextEditingController.fromValue(oldWidget.controller!.value);
    }
    _focusNode.canRequestFocus = _isEnabled;
    if (_focusNode.hasFocus && widget.readOnly != oldWidget.readOnly) {
      if (_controller.selection.isCollapsed) {
        _showSelectionHandles = !widget.readOnly;
      }
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  EditableTextState? get _editableText => editableTextKey.currentState;

  void _requestKeyboard() {
    _editableText?.requestKeyboard();
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) {
      return false;
    }

    if (cause == SelectionChangedCause.keyboard) return false;

    if (widget.readOnly && _controller.selection.isCollapsed) {
      return false;
    }

    if (cause == SelectionChangedCause.longPress) return true;

    if (_controller.text.isNotEmpty) return true;

    return false;
  }

  void _handleSelectionChanged(
      TextSelection selection, SelectionChangedCause? cause) {
    final bool willShowSelectionHandles =
        _shouldShowSelectionHandles(cause ?? SelectionChangedCause.tap);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() {
        _showSelectionHandles = willShowSelectionHandles;
      });
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        if (cause == SelectionChangedCause.longPress) {
          _editableText?.bringIntoView(selection.base);
        }
        return;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      default:
        break;
      // Do nothing.
    }
  }

  /// Toggle the toolbar when a selection handle is tapped.
  void _handleSelectionHandleTapped() {
    if (_controller.selection.isCollapsed) {
      _editableText?.toggleToolbar();
    }
  }

  void _handleHover(bool hovering) {
    if (hovering != _isHovering) {
      setState(() {
        _isHovering = hovering;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<TextInputFormatter> formatters = widget.inputFormatters ?? [];
    if (widget.maxLengthEnforced) {
      formatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    }

    late TextSelectionControls textSelectionControls;
    bool paintCursorAboveText = false;
    bool cursorOpacityAnimates = false;
    Offset? cursorOffset;

    switch (themeData.platform) {
      case TargetPlatform.iOS:
        forcePressEnabled = true;
        textSelectionControls = cupertinoTextSelectionControls;
        paintCursorAboveText = true;
        cursorOpacityAnimates = true;
        cursorOffset = Offset(iOSHorizontalOffset / MediaQuery.of(context).devicePixelRatio, 0);
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        forcePressEnabled = false;
        textSelectionControls = materialTextSelectionControls;
        paintCursorAboveText = false;
        cursorOpacityAnimates = false;
        break;
      default:
        break;
    }

    CustomEditableText editableTextSpan = CustomEditableText(
      builder: _textSpanBuilder,
      key: editableTextKey,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
      showSelectionHandles: _showSelectionHandles,
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      style: widget.style ?? themeData.textTheme.titleMedium!,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      selectionColor: widget.cursorColor?.withValues(alpha: 0.4) ?? themeData.colorScheme.primary.withValues(alpha: 0.4),
      selectionControls: widget.selectionEnabled ? textSelectionControls : null,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      onSelectionChanged: _handleSelectionChanged,
      onSelectionHandleTapped: _handleSelectionHandleTapped,
      inputFormatters: formatters,
      rendererIgnoresPointer: true,
      cursorWidth: widget.cursorWidth,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor ?? themeData.colorScheme.primary,
      backgroundCursorColor: widget.cursorColor?.withValues(alpha: 0.4) ?? themeData.colorScheme.primary.withValues(alpha: 0.4),
      cursorOpacityAnimates: cursorOpacityAnimates,
      cursorOffset: cursorOffset,
      paintCursorAboveText: paintCursorAboveText,
      scrollPadding: widget.scrollPadding,
      keyboardAppearance: widget.keyboardAppearance,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      dragStartBehavior: widget.dragStartBehavior,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
    );

    _textSpanBuilder.bind(textEditingController: _controller);

    Widget child = RepaintBoundary(
      child: editableTextSpan,
    );

    child = AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[_focusNode, _controller]),
      builder: (BuildContext context, Widget? child) {
        return InputDecorator(
          decoration: widget.showCounter ? _getEffectiveDecoration() : widget.decoration,
          baseStyle: widget.style,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          isHovering: _isHovering,
          isFocused: _focusNode.hasFocus,
          isEmpty: _controller.value.text.isEmpty,
          expands: widget.expands,
          child: child,
        );
      },
      child: child,
    );
    return IgnorePointer(
      ignoring: !_isEnabled,
      child: MouseRegion(
        onEnter: (PointerEnterEvent event) => _handleHover(true),
        onExit: (PointerExitEvent event) => _handleHover(false),
        child: AnimatedBuilder(
          animation: _controller, // changes the _currentLength
          builder: (BuildContext context, Widget? child) {
            return Semantics(
              maxValueLength:
                  widget.maxLengthEnforced && widget.maxLength != null
                      ? widget.maxLength
                      : null,
              currentValueLength: _currentLength,
              onTap: () {
                if (!_controller.selection.isValid) {
                  _controller.selection =
                      TextSelection.collapsed(offset: _controller.text.length);
                }
                _requestKeyboard();
              },
              child: child,
            );
          },
          child: _selectionGestureDetectorBuilder.buildGestureDetector(
            behavior: HitTestBehavior.translucent,
            child: child,
          ),
        ),
      ),
    );
  }
}
