import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../services/translation_service.dart';

class TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const TranslatedText({super.key, required this.text, this.style});

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String? _translatedText;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen for language changes and re-translate.
    final settings = Provider.of<SettingsProvider>(context);
    _translateText(settings.locale.languageCode);
  }

  Future<void> _translateText(String targetLanguage) async {
    // No need to translate if the target is English (the original language)
    if (targetLanguage == 'en') {
      if (mounted) {
        setState(() {
          _translatedText = widget.text;
        });
      }
      return;
    }

    final translated = await TranslationService().translate(widget.text, targetLanguage);

    if (mounted) {
      setState(() {
        _translatedText = translated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_translatedText == null) {
      // Show a small loading indicator while translating
      return const SizedBox(
        height: 12,
        width: 12,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Text(_translatedText!, style: widget.style);
  }
}
