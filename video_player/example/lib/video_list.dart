import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  List<YoutubePlayerController> _controllers = [
    'DzWcOdYahrw',
    'p-fdpA-9E6U',
    'BS3aesN_Fyc',
    'kKcKUY-n-yc',
  ]
      .map<YoutubePlayerController>(
        (videoId) => YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(
            autoPlay: false,
          ),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nos videos'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return YoutubePlayer(
            key: ValueKey(_controllers[index].hashCode),
            controller: _controllers[index],
            actionsPadding: EdgeInsets.only(left: 16.0),
            bottomActions: [
              CurrentPosition(),
              SizedBox(width: 10.0),
              ProgressBar(isExpanded: true),
              SizedBox(width: 10.0),
              RemainingDuration(),
              FullScreenButton(),
            ],
          );
        },
        itemCount: _controllers.length,
        separatorBuilder: (context, _) => SizedBox(height: 10.0),
      ),
    );
  }
}
