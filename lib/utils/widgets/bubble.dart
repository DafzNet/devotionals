import 'package:devotionals/utils/constants/colors.dart';
import 'package:devotionals/utils/models/chat.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///WhatsApp's chat bubble type
///
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display message can be changed using [text]
///[text] is the only required parameter
///message sender can be changed using [isSender]
///chat bubble [TextStyle] can be customized using [textStyle]

class BubbleSpecialC extends StatelessWidget {
  final bool isSender;
  final String text;
  final bool tail;
  final Color color;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle textStyle;
  final BoxConstraints? constraints;
  final DateTime? timestamp;
  final Chat? reply;
  final String? replyTo;

  const BubbleSpecialC({
    Key? key,
    this.isSender = true,
    this.constraints,
    required this.text,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.timestamp,
    this.reply,
    this.replyTo,
    
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
  }) : super(key: key);

  ///chat bubble builder method
  @override

  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Column(
        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: CustomPaint(
              painter: SpecialChatBubbleOne(
                color: color,
                alignment: isSender ? Alignment.topRight : Alignment.topLeft,
                tail: tail,
              ),
              child: Container(
                constraints: constraints ??
                    BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .7,
                      minWidth: 80
                    ),
                margin: isSender
                    ? stateTick
                        ? EdgeInsets.fromLTRB(7, 7, 14, 7)
                        : EdgeInsets.fromLTRB(7, 7, 17, 7)
                    : EdgeInsets.fromLTRB(17, 7, 7, 7),
                child: Stack(
                  children: [
                    if(reply!=null)...[
                      Padding(
                        padding: stateTick
                          ? EdgeInsets.only(right: 20, bottom: 20)
                          : EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 20),
                        child: Column(
                          crossAxisAlignment: isSender?CrossAxisAlignment.end:CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              constraints: BoxConstraints(
                                minWidth: 80
                              ),

                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: isSender? Border(right: BorderSide(color: cricColor, width: 2)):Border(left: BorderSide(color: cricColor, width: 2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    replyTo??'',
                                    // textAlign: isSender?TextAlign.right:TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    reply!.text,
                                    // textAlign: isSender?TextAlign.right:TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ClickableText(
                              text: text,
                              // style: textStyle,
                              // textAlign: isSender?TextAlign.right:TextAlign.left,
                            ),
                          ],
                        ),
                      )
                    ]else...
                    [
                    Padding(
                      padding: stateTick
                          ? EdgeInsets.only(right: 20, bottom: 20)
                          : EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 20),
                      child: ClickableText(
                        text:text,
                        // style: textStyle,
                        // textAlign: isSender?TextAlign.right:TextAlign.left,
                      ),
                    )],

                    if (timestamp != null && isSender)
                      Positioned(
                        bottom: 0,
                        right: stateTick?20:2,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            DateFormat('HH:mm a').format(timestamp!),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),

                      if (timestamp != null && !isSender)
                      Positioned(
                        bottom: 0,
                        left: stateTick?20:2,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            DateFormat('HH:mm a').format(timestamp!),
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                      ),
                    stateIcon != null && stateTick
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            child: stateIcon,
                          )
                        : SizedBox(
                            width: 1,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

///custom painter use to create the shape of the chat bubble
///
/// [color],[alignment] and [tail] can be changed

class SpecialChatBubbleOne extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;

  SpecialChatBubbleOne({
    required this.color,
    required this.alignment,
    required this.tail,
  });

  double _radius = 10.0;
  double _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (alignment == Alignment.topRight) {
      if (tail) {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0,
              size.width - _x,
              size.height,
              bottomLeft: Radius.circular(_radius),
              bottomRight: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
            ),
            Paint()
              ..color = this.color
              ..style = PaintingStyle.fill);
        var path = new Path();
        path.moveTo(size.width - _x, 0);
        path.lineTo(size.width - _x, 10);
        path.lineTo(size.width, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              size.width - _x,
              0.0,
              size.width,
              size.height,
              topRight: Radius.circular(3),
            ),
            Paint()
              ..color = this.color
              ..style = PaintingStyle.fill);
      } else {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0,
              size.width - _x,
              size.height,
              bottomLeft: Radius.circular(_radius),
              bottomRight: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
            ),
            Paint()
              ..color = this.color
              ..style = PaintingStyle.fill);
      }
    } else {
      if (tail) {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              _x,
              0,
              size.width,
              size.height,
              bottomRight: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
              bottomLeft: Radius.circular(_radius),
            ),
            Paint()
              ..color = this.color
              ..style = PaintingStyle.fill);
        var path = new Path();
        path.moveTo(_x, 0);
        path.lineTo(_x, 10);
        path.lineTo(0, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0.0,
              _x,
              size.height,
              topLeft: Radius.circular(3),
            ),
            Paint()
              ..color = this.color
              ..style = PaintingStyle.fill);
      } else {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              _x,
              0,
              size.width,
              size.height,
              bottomRight: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
              bottomLeft: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
            ),
            Paint()
              ..color = this.color
              ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}










class ClickableText extends StatelessWidget {
  final String text;

  const ClickableText({Key? key, required this.text}) : super(key: key);

  void _launchURL(String url) async {

    final _url = url.startsWith('https://')||url.startsWith('http://')?url:"https://$url";
    if (await canLaunchUrl(Uri.parse(_url))) {
      await launchUrl(Uri.parse(_url));
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pattern = RegExp(
        // r'\b(?:https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|]',
        r'\b((https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*))',
        caseSensitive: false);

    final matches = pattern.allMatches(text);

    List<TextSpan> children = [];

    int lastMatchEnd = 0;

    for (Match match in matches) {
      if (match.start > lastMatchEnd) {
        final nonUrlText = text.substring(lastMatchEnd, match.start);
        children.add(TextSpan(
          text: nonUrlText,
          style: Theme.of(context).textTheme.bodyMedium
        ),
          
        );
      }

      final urlText = text.substring(match.start, match.end);
      children.add(
        TextSpan(
          text: urlText,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _launchURL(urlText);
              print(urlText);
            },
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      final nonUrlText = text.substring(lastMatchEnd);
      children.add(TextSpan(text: nonUrlText, style: Theme.of(context).textTheme.bodyMedium));
    }

    return RichText(
      text: TextSpan(children: children),
    );
  }
}
