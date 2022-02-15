import 'package:app/bloc/states.dart';
import 'package:app/model/aya_model.dart';
import 'package:app/model/surahs_model.dart';
import 'package:app/model/verse_sound.dart';
import 'package:app/network/dio_helper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  List<SurahModel>? surahs = [];
  void getAllSurah() {
    emit(AppUserGetAllSurahLoadingState());

    DioHelper.getData(
      url: '/chapters',
      query: {"language": "ar"},
    ).then((value) {
      print(value.data['chapters'][0]);
      for (var i = 0; i < value.data['chapters'].length; i++) {
        surahs!.add(SurahModel.fromJson(value.data['chapters'][i]));
      }
      emit(AppUserGetAllSurahSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AppUserGetAllSurahErrorState());
    });
  }

  VersesModel? versesModel;

  void getChapter(Map<String, dynamic> query) {
    emit(AppUserGetChapterSuccessState());
    DioHelper.getData(
            url: 'https://api.quran.com/api/v4/quran/verses/uthmani',
            query: query)
        .then((value) {
      versesModel = VersesModel.fromJson(value.data!);

      emit(AppUserGetChapterSuccessState());
    }).catchError((error) {
      emit(AppUserGetChapterErrorState());
      print(error.toString());
    });
  }

  AudioFiles? verseAudioModel;
  String? verseUrl;
  getVerseAudio({
    required String recitor,
    required String verseKey,
  }) {
    emit(AppUserGetVerseSoundLoadingState());
    DioHelper.getData(
      url: '/recitations/$recitor/by_ayah/$verseKey',
    ).then((value) {
      verseAudioModel = AudioFiles.fromJson(value.data);
      verseUrl = value.data['audio_files'][0]['url'];
      print(value.data);
    }).catchError((error) {
      print(error.toString());
      emit(AppUserGetVerseSoundErrorState());
    });
  }

  String? ayaIndex;
  void getIndex(index) {
    ayaIndex = index;
    emit(AppUserGetIndex());
  }

  String? recitor = '1';
  void changeRecitor(id) {
    recitor = id;
    emit(AppUserRandomState());
  }

  AudioPlayer player = AudioPlayer();
  void playVerse(key, String recitor) {
    getVerseAudio(recitor: recitor, verseKey: key);
    emit(AppUserPlayVersesLoadingState());
    player.stop();
    player.setUrl("https://verses.quran.com/${verseUrl}").then((value) {
      print(verseUrl);
      player.play();

      // player.stop();
      emit(AppUserPlayVersesSuccessState());
    });
  }

  var names = [];
  void getNames() {
    emit(AppUserGetShikhsLoadingState());
    DioHelper.getData(url: '/resources/recitations', query: {
      "language": "ar",
    }).then((value) {
      names = [];
      names = value.data['recitations'];
      print('Hello ${value.data['recitations'][0]['translated_name']['name']}');
      emit(AppUserGetShikhsSuccessState());
    });
  }

  Map? tafseer;
  void getTafseer(key) {
    emit(AppUserGetTafseerLoadingState());
    DioHelper.getData(url: '/quran/tafsirs/90', query: {
      "verse_key": key.toString(),
    }).then((value) {
      tafseer = value.data;
      print(tafseer!['tafsirs'][0]['text']);

      emit(AppUserGetTafseerSuccessState());
    });
  }

  void random() {
    emit(AppUserRandomState());
  }

  bool? isAuto = false;
  void autoPlay() {
    isAuto = !isAuto!;
    random();
  }

  void continuosPlay({
    required String recitorKey,
    required String verseKey,
    required bool isAuto,
    required PageController pageController,
  }) {
    player.setUrl("https://verses.quran.com/${verseUrl}");
    player.play().then((value) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }
}
