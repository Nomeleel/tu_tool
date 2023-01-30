import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

typedef Hinter<T> = String? Function(T? value);
typedef HintBuilder = Widget Function(BuildContext context, String hintText);

class TextFormFieldRow extends FormField<String> {
  /// Creates a [CupertinoFormRow] containing a [FormField] that wraps
  /// a [CupertinoTextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [TextEditingController]
  /// will be constructed automatically and its `text` will be initialized
  /// to [initialValue] or the empty string.
  ///
  /// The [prefix] parameter is displayed at the start of the row. Standard iOS
  /// guidelines encourage passing a [Text] widget to [prefix] to detail the
  /// nature of the input.
  ///
  /// The [padding] parameter is used to pad the contents of the row. It is
  /// directly passed to [CupertinoFormRow]. If the [padding]
  /// parameter is null, [CupertinoFormRow] constructs its own default
  /// padding (which is the standard form row padding in iOS.) If no edge
  /// insets are intended, explicitly pass [EdgeInsets.zero] to [padding].
  ///
  /// For documentation about the various parameters, see the
  /// [CupertinoTextField] class and [CupertinoTextField.borderless],
  /// the constructor.
  TextFormFieldRow({
    super.key,
    this.prefix,
    this.padding,
    this.controller,
    String? initialValue,
    FocusNode? focusNode,
    BoxDecoration? decoration,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    super.onSaved,
    super.validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    TextSelectionControls? selectionControls,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
    String? placeholder,
    TextStyle? placeholderStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: CupertinoColors.placeholderText,
    ),
    Widget? textFieldPrefix,
    Widget? textFieldSuffix,
    this.hinter,
    HintBuilder? hintBuilder,
  })  : assert(initialValue == null || controller == null),
        assert(obscuringCharacter.length == 1),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1, 'Obscured fields cannot be multiline.'),
        assert(maxLength == null || maxLength > 0),
        super(
          initialValue: controller?.text ?? initialValue ?? '',
          builder: (FormFieldState<String> field) {
            final _TextFormFieldRowState state = field as _TextFormFieldRowState;

            void onChangedHandler(String value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            final textField = CupertinoTextField.borderless(
              controller: state._effectiveController,
              focusNode: focusNode,
              keyboardType: keyboardType,
              decoration: decoration,
              textInputAction: textInputAction,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textAlignVertical: textAlignVertical,
              textCapitalization: textCapitalization,
              textDirection: textDirection,
              autofocus: autofocus,
              toolbarOptions: toolbarOptions,
              readOnly: readOnly,
              showCursor: showCursor,
              obscuringCharacter: obscuringCharacter,
              obscureText: obscureText,
              autocorrect: autocorrect,
              smartDashesType: smartDashesType,
              smartQuotesType: smartQuotesType,
              enableSuggestions: enableSuggestions,
              maxLines: maxLines,
              minLines: minLines,
              expands: expands,
              maxLength: maxLength,
              onChanged: onChangedHandler,
              onTap: onTap,
              onEditingComplete: onEditingComplete,
              onSubmitted: onFieldSubmitted,
              inputFormatters: inputFormatters,
              enabled: enabled,
              cursorWidth: cursorWidth,
              cursorHeight: cursorHeight,
              cursorColor: cursorColor,
              scrollPadding: scrollPadding,
              scrollPhysics: scrollPhysics,
              keyboardAppearance: keyboardAppearance,
              enableInteractiveSelection: enableInteractiveSelection,
              selectionControls: selectionControls,
              autofillHints: autofillHints,
              placeholder: placeholder,
              placeholderStyle: placeholderStyle,
              prefix: textFieldPrefix,
              suffix: textFieldSuffix,
            );

            return CupertinoFormRow(
              prefix: prefix,
              padding: padding,
              error: (field.errorText == null) ? null : Text(field.errorText!),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  textField,
                  if ((state.hintText?.isNotEmpty ?? false) && hintBuilder != null)
                    hintBuilder(state.context, state.hintText!),
                ],
              ),
            );
          },
        );

  /// A widget that is displayed at the start of the row.
  ///
  /// The [prefix] widget is displayed at the start of the row. Standard iOS
  /// guidelines encourage passing a [Text] widget to [prefix] to detail the
  /// nature of the input.
  final Widget? prefix;

  /// Content padding for the row.
  ///
  /// The [padding] widget is passed to [CupertinoFormRow]. If the [padding]
  /// parameter is null, [CupertinoFormRow] constructs its own default
  /// padding, which is the standard form row padding in iOS.
  ///
  /// If no edge insets are intended, explicitly pass [EdgeInsets.zero] to
  /// [padding].
  final EdgeInsetsGeometry? padding;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  final Hinter<String>? hinter;

  @override
  FormFieldState<String> createState() => _TextFormFieldRowState();
}

class _TextFormFieldRowState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController => _textFormFieldRow.controller ?? _controller;

  TextFormFieldRow get _textFormFieldRow => super.widget as TextFormFieldRow;

  String? hintText;

  @override
  void initState() {
    super.initState();
    if (_textFormFieldRow.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      _textFormFieldRow.controller!.addListener(_handleControllerChanged);
    }
    _setHintText(_controller?.text);
  }

  @override
  void didUpdateWidget(TextFormFieldRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_textFormFieldRow.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _textFormFieldRow.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && _textFormFieldRow.controller == null) {
        _controller = TextEditingController.fromValue(oldWidget.controller!.value);
      }

      if (_textFormFieldRow.controller != null) {
        setValue(_textFormFieldRow.controller!.text);
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  @override
  void dispose() {
    _textFormFieldRow.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    _setHintText(this.value);

    if (value != null && _effectiveController!.text != value) {
      _effectiveController!.text = value;
    }
  }

  @override
  void reset() {
    super.reset();

    _setHintText(widget.initialValue);

    if (widget.initialValue != null) {
      setState(() {
        _effectiveController!.text = widget.initialValue!;
      });
    }
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.text != value) {
      didChange(_effectiveController!.text);
    }
  }

  void _setHintText(String? text) => hintText = _textFormFieldRow.hinter?.call(text);
}
