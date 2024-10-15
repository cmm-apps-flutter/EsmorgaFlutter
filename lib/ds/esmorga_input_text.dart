import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:flutter/material.dart';

class EsmorgaTextField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onValueChange;
  final String title;
  final String placeholder;
  final bool singleLine;
  final TextInputType keyboardType;
  final TextInputAction imeAction;
  final String? errorText;
  final bool isEnabled;
  final VoidCallback onDonePressed;

  const EsmorgaTextField({
    super.key,
    required this.value,
    required this.onValueChange,
    required this.title,
    required this.placeholder,
    this.singleLine = true,
    this.keyboardType = TextInputType.text,
    this.imeAction = TextInputAction.done,
    this.errorText,
    this.isEnabled = true,
    this.onDonePressed = _defaultOnDonePressed,
  });

  static void _defaultOnDonePressed() {}

  @override
  _EsmorgaTextFieldState createState() => _EsmorgaTextFieldState();
}

class _EsmorgaTextFieldState extends State<EsmorgaTextField> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        EsmorgaText(text: widget.title, style: EsmorgaTextStyle.body1),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: widget.value),
          onChanged: widget.onValueChange,
          cursorColor: Theme.of(context).colorScheme.secondary,
          obscureText: widget.keyboardType == TextInputType.visiblePassword && !passwordVisible,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
            ),
            hintText: widget.placeholder,
            errorText: widget.errorText,
            enabled: widget.isEnabled,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
            ),
            suffixIcon: widget.keyboardType == TextInputType.visiblePassword
                ? IconButton(
                    icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  )
                : null,
          ),
          keyboardType: widget.keyboardType,
          textInputAction: widget.imeAction,
          onEditingComplete: widget.onDonePressed,
        ),
      ],
    );
  }
}
