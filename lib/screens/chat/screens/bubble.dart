import 'package:devotionals/utils/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the Chat class from your file

class CustomChatBubble extends StatefulWidget {
  final Chat chat;
  final String curUser;

  const CustomChatBubble({
    Key? key,
    required this.chat,
    required this.curUser,
  }) : super(key: key);

  @override
  _CustomChatBubbleState createState() => _CustomChatBubbleState();
}

class _CustomChatBubbleState extends State<CustomChatBubble> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration();
  Duration _position = Duration();
  var _positionSubscription;
  var _durationSubscription;

  String getFormattedDate() {
    DateTime now = DateTime.now();
    DateTime commentDate = widget.chat.timestamp!;

    if (now.difference(commentDate).inSeconds < 60) {
      return 'just now';
    } else if (now.difference(commentDate).inMinutes < 60) {
      return '${now.difference(commentDate).inMinutes}m';
    } else if (commentDate.day == now.day) {
      return DateFormat('h:mm').format(commentDate);
    } else if (commentDate.isAfter(now.subtract(const Duration(days: 1)))) {
      return 'yesterday';
    } else {
      return now.year != commentDate.year?DateFormat('d, MMM y').format(commentDate):DateFormat('d, MMM').format(commentDate);
    }
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _positionSubscription = _audioPlayer.positionStream.listen(
      (position) => setState(() => _position = position),
    );
    _durationSubscription = _audioPlayer.durationStream.listen(
      (duration) => setState(() => _duration = duration!),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (showDateHeader()) _buildDateHeader(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
          child: Row(
            children: [
              
              if (widget.chat.senderId == widget.curUser)...[SizedBox(width: 50,)],
              Expanded(
                child: Column(
                  crossAxisAlignment:widget.chat.senderId == widget.curUser? CrossAxisAlignment.end:CrossAxisAlignment.start,
                  children: [
                    if (widget.chat.isReply != null)
                      _buildReplyMessage(widget.chat.isReply!),
                    if (widget.chat.audio != null &&widget.chat.audio!.isNotEmpty)
                      _buildAudioPlayer(widget.chat.audio!),
                    if (widget.chat.text.isNotEmpty &&
                        widget.chat.audio!.isEmpty)
                      _buildText(widget.chat.text),
                    // Add other attributes here if needed
                  ],
                ),
              ),

              if (widget.chat.senderId != widget.curUser)...[SizedBox(width: 50,)],
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Text(
            //   getFormattedDate()
            // ),
            if (widget.chat.isSent)
              Icon(
                Icons.done,
                size: 16,
                color: widget.chat.isDelivered ? Colors.blue : Colors.grey,
              ),
            if (widget.chat.isDelivered)
              Icon(
                Icons.done_all,
                size: 16,
                color: widget.chat.isSeen ? Colors.blue : Colors.grey,
              ),
          ],
        ),
      ],
    );
  }

  bool showDateHeader() {
    return true;
  }

  Widget _buildDateHeader() {
    return Center(
      child: Text(
        _formatDate(widget.chat.timestamp ?? DateTime.now()),
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12.0,
        ),
      ),
    );
  }

  Widget _buildReplyMessage(Chat reply) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Replied Message',
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
          ),
          SizedBox(height: 4.0),
          Text(
            reply.text, // Replace with actual replied message text
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer(String audioUrl) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: _isPlaying ? null : () => _play(audioUrl),
              icon: Icon(Icons.play_arrow),
            ),
            IconButton(
              onPressed: _isPlaying ? () => _pause() : null,
              icon: Icon(Icons.pause),
            ),
            Expanded(
              child: Slider(
                value: _position.inMilliseconds.toDouble(),
                max: _duration.inMilliseconds.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _seek(Duration(milliseconds: value.toInt()));
                  });
                },
              ),
            ),
            Text('${_position.inSeconds}/${_duration.inSeconds}'),
          ],
        ),
      ],
    );
  }

  Widget _buildText(String text) {
    return Container(
      
      child: Text(
        text,
    
        style: TextStyle(
          fontSize: 15
        ),
      ),
    );
  }

  void _play(String audioUrl) async {
    _audioPlayer.stop();
    await _audioPlayer.play();
    setState(() {
      _isPlaying = true;
    });
  }

  void _pause() {
    _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _seek(Duration position) {
    _audioPlayer.seek(position);
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
