import 'package:app/bloc/bloc.dart';
import 'package:app/bloc/states.dart';
import 'package:app/components/component.dart';
import 'package:app/functions/chapter_view/chapter_view_screen.dart';
import 'package:app/styles/color_styles.dart';
import 'package:app/styles/font_styles.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenLayout extends StatelessWidget {
  const HomeScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getAllSurah(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              elevation: 2,
              backgroundColor: secondaryColor,
              title: Text(
                'محفظ القران الكريم',
                style: GoogleFonts.reemKufi(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            backgroundColor: secondaryColor,
            body: ConditionalBuilder(
              condition: state is! AppUserGetAllSurahLoadingState,
              fallback: (context) => LinearProgressIndicator(
                color: primaryColor,
              ),
              builder: (c) => Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: cubit.surahs!.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          navigateTo(
                              context,
                              ChapterViewScreen(
                                id: cubit.surahs![index].pages!.first.toInt(),
                                text: cubit.surahs![index].nameArabic,
                                chapter_number: cubit.surahs![index].id,
                              ));
                        },
                        child: SurahItemBuilder(
                          text: cubit.surahs![index].nameArabic,
                          id: cubit.surahs![index].id,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SurahItemBuilder extends StatelessWidget {
  SurahItemBuilder({
    Key? key,
    required this.text,
    required this.id,
  });

  String? text;
  int? id;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        // color: primaryColor,
        border: Border.all(
          width: 2,
          color: primaryColor.withOpacity(.2),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                      'https://cdn.pixabay.com/photo/2012/04/18/01/19/separator-36415_1280.png'),
                  Text(
                    id.toString(),
                    // "id",
                    style: A20500,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 4,
              child: Text(
                'سورة $text',
                style: A22500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
