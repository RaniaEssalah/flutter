import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chauffeur_app/core/theme/app_colors.dart';

/// Custom text field with consistent styling
class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.validator,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          validator: widget.validator,
          focusNode: widget.focusNode,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            counterText: '',
          ),
        ),
      ],
    );
  }
}

/// Phone number text field with country code
class PhoneTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const PhoneTextField({
    super.key,
    this.controller,
    this.errorText,
    this.onChanged,
    this.validator,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  String _countryCode = '+1';

  int get _requiredDigits {
    // Basic per-country expected lengths. Extend this map when needed.
    switch (_countryCode) {
      case '+1':
        return 10; // USA/Canada
      case '+33':
        return 9; // France (example)
      case '+44':
        return 10; // UK (example)
      default:
        return 8; // fallback
    }
  }

  Future<void> _changeCountryCode() async {
    final controller = TextEditingController(text: _countryCode);
    final result = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit country code'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: '+1'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              final isValid = text.isNotEmpty &&
                  text.startsWith('+') &&
                  text.length <= 5 &&
                  text.substring(1).runes.every((r) => r >= 48 && r <= 57);
              if (isValid) {
                Navigator.pop(context, text);
              } else {
                // keep dialog open and show a simple validation hint
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Enter a valid country code, e.g. +1')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      setState(() => _countryCode = result);
    }
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < _requiredDigits) {
      return 'Please enter a valid phone number (expected $_requiredDigits digits for $_countryCode)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      hintText: 'Phone number',
      errorText: widget.errorText,
      keyboardType: TextInputType.phone,
      onChanged: widget.onChanged,
      validator: widget.validator ?? _defaultValidator,
      prefixIcon: GestureDetector(
        onTap: _changeCountryCode,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _countryCode,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              const SizedBox(
                height: 24,
                child: VerticalDivider(
                  color: AppColors.divider,
                  thickness: 1,
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(_requiredDigits),
      ],
    );
  }
}
