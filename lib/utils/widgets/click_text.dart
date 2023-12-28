import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'bible_view.dart';

class ClickableText extends StatelessWidget {
  final String text;
  final TextStyle? matchTextStyle;
  final TextStyle? plainTextStyle;
  final TextStyle? defaultTextStyle;
  final void Function(String)? onTap;
  final BuildContext context;

  ClickableText({
    this.defaultTextStyle = const TextStyle(
      fontSize: 15,
      height: 1.8,
      color: Colors.black
    ),
    this.matchTextStyle = const TextStyle(
      fontSize: 15,
      height: 1.8,
      color: Colors.blue,
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.dotted
    ),
    this.plainTextStyle,
    required this.context,
    required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _buildTextSpan(),
    );
  }

  TextSpan _buildTextSpan() {
    final List<TextSpan> spans = [];

    final RegExp referenceRegExp = RegExp(r'\b(?:\d\s?(?:[ivxlc]+)?|[ivxlc]+(?:\s?\d)?)?\s?[A-Za-z]+\s?\d{1,3}(?::\d{1,3})?(?:\s?[,-]\s?(?:\d\s?(?:[ivxlc]+)?|[ivxlc]+(?:\s?\d)?)?(?::\d{1,3})?(?:-?\d{1,3})?)?\b',
   );

    int currentIndex = 0;
    referenceRegExp.allMatches(text).forEach((match) {
      final String matchText = match.group(0)!;

      final int matchStart = match.start;
      final int matchEnd = match.end;

      // Add the preceding non-reference text
      if (matchStart > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, matchStart),
          style: plainTextStyle?? defaultTextStyle
        ));
      }

      // Add the clickable reference
      spans.add(TextSpan(
        text: matchText,
        style: matchTextStyle?? defaultTextStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if(onTap != null){
              onTap!(matchText);
            }else{
             Navigator.push(context,
              PageTransition(
                child: BibleViewScreen(bibleRef: matchText,), 
                type: PageTransitionType.fade)
             );
            }
          },
      ));

      currentIndex = matchEnd;
    });

    // Add the remaining non-reference text
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: plainTextStyle?? defaultTextStyle
      ));
    }

    return TextSpan(children: spans);
  }
}
