import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    this.defaultTextStyle,
    this.matchTextStyle,
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

   RegExp referenceRegExp = RegExp(
    r'(?:\b(?:Genesis|Gen|Exodus|Exo|Leviticus|Lev|Numbers|Num|Deuteronomy|Deut|Joshua|Josh|Judges|Jdg|Ruth|1\sSamuel|1\sSam|2\sSamuel|2\sSam|1\sKings|1\sKin|2\sKings|2\sKin|1\sChronicles|1\sChr|2\sChronicles|2\sChr|Ezra|Nehemiah|Neh|Esther|Est|Job|Psalms|Psalm|Proverbs|Prov|Ecclesiastes|Eccles|Song\sof\sSolomon|Song\sSol|Isaiah|Isa|Jeremiah|Jer|Lamentations|Lam|Ezekiel|Ezek|Daniel|Dan|Hosea|Hos|Joel|Jl|Amos|Obadiah|Obad|Jonah|Jon|Micah|Mic|Nahum|Nah|Habakkuk|Hab|Zephaniah|Zeph|Haggai|Hag|Zechariah|Zech|Malachi|Mal|Matthew|Matt|Mark|Mk|Luke|Lk|John|Jn|Acts|Romans|Rom|1\sCorinthians|1\sCor|2\sCorinthians|2\sCor|Galatians|Gal|Ephesians|Eph|Philippians|Phil|Colossians|Col|1\sThessalonians|1\sThes|2\sThessalonians|2\sThes|1\sTimothy|1\sTim|2\sTimothy|2\sTim|Titus|Tt|Philemon|Philem|Hebrews|Heb|James|Jas|1\sPeter|1\sPet|2\sPeter|2\sPet|1\sJohn|1\sJn|2\sJohn|2\sJn|3\sJohn|3\sJn|Jude|Jd|Revelation|Rev)\b(?:\s\d+(?::\d+)?(?:-\d+(?::\d+)?)?|\s\d+(?::\d+)?)?)\b',
    caseSensitive: false,
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
          style: plainTextStyle?? GoogleFonts.openSans(color: Colors.black, fontSize: 16, height: 1.8),
        ));
      }

      // Add the clickable reference
      spans.add(TextSpan(
        text: matchText,
        style: matchTextStyle?? GoogleFonts.openSans(
          color: Colors.black, 
          fontSize: 16, height: 1.8,
        ),
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
        style: plainTextStyle?? GoogleFonts.openSans(
          color: Colors.black, 
          fontSize: 16, height: 1.8,
        )
      ));
    }

    return TextSpan(children: spans);
  }
}

