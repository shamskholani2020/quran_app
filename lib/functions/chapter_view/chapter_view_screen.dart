import 'package:app/bloc/bloc.dart';
import 'package:app/bloc/states.dart';
import 'package:app/styles/color_styles.dart';
import 'package:app/styles/font_styles.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

class ChapterViewScreen extends StatelessWidget {
  int? id;
  int? chapter_number;
  String? text;
  PageController pageController = PageController();
  AudioPlayer audioPlayer = AudioPlayer();
  ChapterViewScreen({
    required this.id,
    required this.chapter_number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: Builder(builder: (context) {
        AppCubit.get(context).getChapter({
          // "page_number": id,
          "chapter_number": chapter_number,
        });
        AppCubit.get(context).getVerseAudio(
            recitor: '3', verseKey: AppCubit.get(context).ayaIndex.toString());

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'سورة $text',
                  style: A22500,
                ),
              ),
              body: SafeArea(
                child: ConditionalBuilder(
                  condition: cubit.versesModel != null,
                  fallback: (c) => LinearProgressIndicator(
                    color: primaryColor,
                  ),
                  // builder: (c) => ListView.builder(
                  //   itemCount: cubit.versesModel!.verses!.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return VerseBuilder(
                  //       cubit: cubit,
                  //       index: index,
                  //     );
                  //   },
                  // ),
                  builder: (c) => Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            onPageChanged: (value) {},
                            pageSnapping: true,
                            itemCount: cubit.versesModel!.verses!.length,
                            itemBuilder: (context, index) {
                              // cubit.getVerseAudio(
                              //     recitor: '3',
                              //     verseKey:
                              //         '${cubit.versesModel!.verses![index].verseKey}');
                              cubit.ayaIndex = cubit
                                  .versesModel!.verses![index].verseKey
                                  .toString();
                              print(cubit.ayaIndex);
                              return VerseBuilder(
                                text: cubit
                                    .versesModel!.verses![index].textUthmani,
                                index: index,
                              );
                            }),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          width: double.infinity,
                          height: 90,
                          // color: secondaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (cubit.ayaIndex != null)
                                IconButton(
                                  onPressed: () async {
                                    cubit.getVerseAudio(
                                      recitor: '3',
                                      verseKey: cubit.ayaIndex.toString(),
                                    );

                                    await audioPlayer
                                        .play(
                                            'https://verses.quran.com/${cubit.verseAudioModel!.url}')
                                        .then((value) {
                                      audioPlayer.stop();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: Colors.deepOrange,
                                    size: 36,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class VerseBuilder extends StatelessWidget {
  VerseBuilder({
    Key? key,
    required this.text,
    required this.index,
  }) : super(key: key);

  int? index;
  String? text;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${text}",
      textDirection: TextDirection.rtl,
    
      style: GoogleFonts.cairo(
        fontSize: 50,
        color: whiteColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
