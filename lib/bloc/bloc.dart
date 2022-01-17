import 'package:app/bloc/states.dart';
import 'package:app/model/aya_model.dart';
import 'package:app/model/surahs_model.dart';
import 'package:app/model/verse_sound.dart';
import 'package:app/network/dio_helper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

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
  void getVerseAudio({
    required String recitor,
    required String verseKey,
  }) {
    emit(AppUserGetVerseSoundLoadingState());
    DioHelper.getData(
      url: '/recitations/$recitor/by_ayah/$verseKey',
    ).then((value) {
      // verseAudioModel = AudioFiles.fromJson(value.data['audio_files']);
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
}
