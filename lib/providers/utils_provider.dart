// ignore: avoid_web_libraries_in_flutter

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:get/get.dart';

class ChapterProvider extends ChangeNotifier {
  final Dio _dio;
  final _helper = FlutterSoundHelper();
  ChapterProvider(this._dio);

  Duration _position;
  Duration get position => this._position;
  set position(Duration value) {
    this._position = value;
    notifyListeners();
  }

  Duration _duration;
  Duration get duration => this._duration;
  set duration(Duration value) {
    this._duration = value;
    notifyListeners();
  }

  FlutterSoundPlayer _player;
  FlutterSoundPlayer get player => this._player;
  set player(FlutterSoundPlayer value) {
    this._player = value;
    notifyListeners();
  }

  PlayerState get playerState => player.playerState;
  bool get isPaused => player.isPaused;
  bool get isPlaying => player.isPlaying;
  bool get isStopped => player.isStopped;

  Future<void> downloadChapter(String url) async {
    final _url = url.split('*').first;
    if (!_url.isURL)
      return await FluttertoastWebPlugin()
          .addHtmlToast(msg: 'no download url found!');
    try {
      await _dio.get(_url);
    } on DioError catch (_) {
      return;
    }
  }

  void init(String url) async {
    player = FlutterSoundPlayer();
    await player.openAudioSession();
    duration = await _helper.duration(url);
  }

  Future<void> start({String url}) async {
    duration = await player.startPlayer(
        fromURI: url,
        whenFinished: () async => await FluttertoastWebPlugin()
            .addHtmlToast(msg: 'playback finish!'));
    player.dispositionStream().listen((event) => position = event.position);
  }

  Future<void> resume() async => await player.resumePlayer();
  Future<void> stop() async => await player.stopPlayer();
  Future<void> pause() async => await player.pausePlayer();

  @override
  void dispose() {
    player.closeAudioSession();
    super.dispose();
  }
}
