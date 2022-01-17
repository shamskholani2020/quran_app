import 'package:app/network/dio_helper.dart';
import 'package:app/screen/home_screen_layout.dart';
import 'package:app/styles/color_styles.dart';
import 'package:flutter/material.dart';

void main() async {
  await DioHelper.init();
  runApp(
    MaterialApp(
      // locale: Locale.fromSubtags(languageCode: 'ar'),
      home: HomeScreenLayout(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: primaryColor,
          elevation: 2,
        ),
        scaffoldBackgroundColor: primaryColor,
      ),
    ),
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AppCubit(),
//       child: BlocConsumer<AppCubit, AppStates>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           var cubit = AppCubit.get(context);
//           return Scaffold(
//             appBar: AppBar(
//               title: Text(
//                 "holy quran",
//                 style: GoogleFonts.pacifico(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             body: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Center(
//                     child: TextButton(
//                       onPressed: () {
//                         cubit.getAllSurah();
//                       },
//                       child: Text(
//                         'Get Date',
//                         style: N18500,
//                       ),
//                     ),
//                   ),
//                   ConditionalBuilder(
//                     condition: cubit.surahs!.isNotEmpty,
//                     fallback: (c) => const Text('Empty'),
//                     builder: (c) => ListView.separated(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: cubit.surahs!.length,
//                       separatorBuilder: (BuildContext context, int index) {
//                         return const SizedBox(
//                           height: 20,
//                         );
//                       },
//                       itemBuilder: (BuildContext context, int index) {
//                         return Text(
//                             cubit.surahs![index].nameArabic!.toString());
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class TestPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//     );
//   }
// }
