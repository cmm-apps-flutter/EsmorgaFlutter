import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'esmorga_text.dart';

class EsmorgaTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String title;
  final String placeholder;
  final String? errorText;
  final bool isEnabled;
  final bool isPasswordField;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxChars;

  final bool? obscureText; 

  final VoidCallback? onSuffixIconClick;

  const EsmorgaTextField({
    super.key,
    this.controller,
    this.focusNode,
    required this.title,
    required this.placeholder,
    this.errorText,
    this.isEnabled = true,
    this.isPasswordField = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.inputFormatters,
    this.maxChars,
    this.obscureText,
    this.onSuffixIconClick,
  });

  @override
  State<EsmorgaTextField> createState() => _EsmorgaTextFieldState();
}

class _EsmorgaTextFieldState extends State<EsmorgaTextField> {
  late bool _internalObscureText;
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalObscureText = widget.isPasswordField;
    _internalController = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final bool effectiveObscureText = widget.obscureText ?? _internalObscureText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.isEnabled,
          obscureText: widget.isPasswordField ? effectiveObscureText : false,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          maxLength: widget.maxChars,
          inputFormatters: widget.inputFormatters,
          onChanged: (value) {
            setState(() {});
            widget.onChanged?.call(value);
          },
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            errorText: widget.errorText,
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    icon: Icon(
                      effectiveObscureText ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    onPressed: () {
                      if (widget.onSuffixIconClick != null) {
                        widget.onSuffixIconClick!();
                      } else {
                        setState(() {
                          _internalObscureText = !_internalObscureText;
                        });
                      }
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: widget.errorText != null
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: widget.errorText != null
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
            filled: !widget.isEnabled,
            fillColor: !widget.isEnabled
                ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            counterText: '', // Hides the default character counter
          ),
        ),
        if (widget.maxChars != null) ...[
          const SizedBox(height: 4.0),
          Align(
            alignment: Alignment.centerRight,
            child: EsmorgaText(
              text: "${_internalController.text.length}/${widget.maxChars}",
              style: EsmorgaTextStyle.body1Accent,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ],
    );
  }
}
