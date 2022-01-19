import 'package:app/bloc/bloc.dart';
import 'package:app/bloc/states.dart';
import 'package:app/components/component.dart';
import 'package:app/styles/color_styles.dart';
import 'package:app/styles/font_styles.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

class ChapterViewScreen extends StatelessWidget {
  int? id;
  int? chapter_number;
  String? text;
  PageController pageController = PageController();
  ChapterViewScreen({
    required this.id,
    required this.chapter_number,
    required this.text,
  });
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getNames(),
      child: Builder(builder: (context) {
        AppCubit.get(context).getChapter({
          // "page_number": id,
          "chapter_number": chapter_number,
        });
        // AppCubit.get(context).getVerseAudio(
        //     recitor: AppCubit.get(context).recitor.toString(),
        //     verseKey: AppCubit.get(context).ayaIndex.toString());

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var blocked = ["6", "8", "9", "10", "11", "12"];
            var cubit = AppCubit.get(context);
            for (var i = 0; i < cubit.names.length; i++) {
              if (blocked.contains(cubit.names[i]['id'].toString())) {
                cubit.names.removeAt(i);
                print('Removeed ');
              } else {
                print('Fuck You Ahain');
                print(cubit.names[i]['id']);
              }
            }

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    navigateBack(context);
                    cubit.player.stop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                ),
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
                        flex: 3,
                        child: PageView.builder(
                            physics: const BouncingScrollPhysics(),
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            onPageChanged: (value) {
                              cubit.getVerseAudio(
                                recitor: cubit.recitor!,
                                verseKey: cubit.ayaIndex.toString(),
                              );
                            },
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
                              return SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: VerseBuilder(
                                  text: cubit
                                      .versesModel!.verses![index].textUthmani,
                                ),
                              );
                            }),
                      ),
                      Expanded(
                        child: TestButton(
                          cubit: cubit,
                          state: state,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
  }) : super(key: key);

  int? index;
  String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${text}",
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              fontSize: 45,
              color: whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class TestButton extends StatelessWidget {
  final AppCubit cubit;
  final AppStates state;

  TestButton({
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return CircularMenu(
      alignment: Alignment.bottomCenter,
      toggleButtonColor: secondaryColor,
      items: [
        CircularMenuItem(
          color: secondaryColor,
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (c) => Container(
                width: double.infinity,
                color: primaryColor,
                padding: const EdgeInsets.all(20),
                child: ListView.separated(
                  itemCount: cubit.names.length,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      color: primaryColor,
                      child: InkWell(
                        onTap: () {
                          cubit.changeRecitor(
                            cubit.names[index]['id'].toString(),
                          );
                          navigateBack(context);
                          cubit.playVerse(
                              cubit.ayaIndex, cubit.recitor.toString());
                          print(cubit.recitor);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            '${cubit.names[index]['translated_name']['name']}',
                            style: A18500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
          icon: Icons.supervised_user_circle_rounded,
        ),
        CircularMenuItem(
          color: secondaryColor,
          onTap: () {
            cubit.playVerse(cubit.ayaIndex, cubit.recitor!);
          },
          icon: Icons.play_arrow,
        ),
        CircularMenuItem(
          color: secondaryColor,
          onTap: () async {
            cubit.getTafseer(cubit.ayaIndex);

            showModalBottomSheet(
              context: context,
              builder: (c) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: primaryColor,
                child: ConditionalBuilder(
                  condition: state is! AppUserGetTafseerLoadingState,
                  builder: (c) => SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      cubit.tafseer!['tafsirs'][0]['text'],
                      style: N18500.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  fallback: (c) => LinearProgressIndicator(
                    color: secondaryColor,
                  ),
                ),
              ),
            );
          },
          icon: Icons.my_library_books,
        ),
      ],
    );
  }
}
