import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'video_list.dart';
import 'card.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.grey,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ngtv Experience',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        appBarTheme: AppBarTheme(
          color: Colors.grey,
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 20.0,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
      ),
      home: MyHomePage(title: 'Ngtv Experience'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  var _idController = TextEditingController();
  var _seekToController = TextEditingController();
  double _volume = 100;
  bool _muted = false;
  String _playerStatus = '';

  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'Ga9Qz86cFaY',
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        forceHideAnnotation: true,
        disableDragSeek: false,
        loop: true,
        start: Duration(seconds: 20),
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady) {
      if (_controller.value.playerState == PlayerState.ended) {
        _showSnackBar('Video Ended!');
      }
      if (mounted && !_controller.value.isFullScreen) {
        setState(() {
          _playerStatus = _controller.value.playerState.toString();
        });
      }
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Image.asset(
            'assets/ngtv.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => MyCard(),
              ),
            ),
          ),
            IconButton(
            icon: Icon(Icons.video_library),
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => VideoList(),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _space,
          Text(
  'Bienvenue chez Ngtv Experience!',
  textAlign: TextAlign.center,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(fontWeight: FontWeight.bold),
),
                _space,
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            topActions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20.0,
                ),
                onPressed: () {
                  _controller.toggleFullScreenMode();
                },
              ),
              Expanded(
                child: Text(
                  'Youtube Player Title Demo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 25.0,
                ),
                onPressed: () {
                  _showSnackBar('Settings Tapped!');
                },
              ),
            ],
            onReady: () {
              _isPlayerReady = true;
            },
          ),
          _space,
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: _isPlayerReady
                          ? () {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                              setState(() {});
                            }
                          : null,
                    ),
                    IconButton(
                      icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                      onPressed: _isPlayerReady
                          ? () {
                              _muted
                                  ? _controller.unMute()
                                  : _controller.mute();
                              setState(() {
                                _muted = !_muted;
                              });
                            }
                          : null,
                    ),
                    FullScreenButton(
                      controller: _controller,
                      color: Colors.grey,
                    ),
                  ],
                ),
                _space,
                TextField(
                  enabled: _isPlayerReady,
                  controller: _seekToController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Go to seconds",
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: OutlineButton(
                        child: Text("Go"),
                        onPressed: () {
                          _controller.seekTo(
                            Duration(
                              seconds: int.parse(_seekToController.text),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                _space,
                Row(
                  children: <Widget>[
                    Text(
                      "Volume",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Expanded(
                      child: Slider(
                        inactiveColor: Colors.transparent,
                        value: _volume,
                        min: 0.0,
                        max: 100.0,
                        divisions: 10,
                        label: '${(_volume).round()}',
                        onChanged: _isPlayerReady
                            ? (value) {
                                setState(() {
                                  _volume = value;
                                });
                                _controller.setVolume(_volume.round());
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
                Chip(
                  backgroundColor: Colors.grey,
                  padding: EdgeInsets.all(8.0),
                  avatar: Icon(
                    Icons.settings_input_antenna,
                    color: Colors.greenAccent,
                    size: 15.0,
                  ),
                  label: Text(
                    _playerStatus,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.greenAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _space => SizedBox(height: 10);

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.grey,
        onPressed: _isPlayerReady
            ? () {
                if (_idController.text.isNotEmpty) {
                  String id = YoutubePlayer.convertUrlToId(
                    _idController.text,
                  );
                  if (action == 'LOAD') _controller.load(id);
                  if (action == 'CUE') _controller.cue(id);
                  FocusScope.of(context).requestFocus(FocusNode());
                } else {
                  _showSnackBar('Source can\'t be empty!');
                }
              }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
