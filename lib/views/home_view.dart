import 'package:flutter/material.dart';
import 'package:notifications/colors.dart';
import 'package:notifications/views/evening_azkar_view.dart';
import 'package:notifications/views/morning_azkar_view.dart';
import 'package:notifications/views/salah_view.dart';
import 'package:notifications/views/sebha_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String id = 'HomeView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'وذَكِّر',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Center(
          child: Column(
            children: [
              AzkarItem(
                color: MyColors.darkTextColor,
                text: 'أذكار الصباح',
                image: 'assets/images/morning.jpg',
                onTap: () {
                  Navigator.pushNamed(context, MorningAzkarView.id);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              AzkarItem(
                  onTap: () {
                    Navigator.pushNamed(context, EveningAzkarView.id);
                  },
                  image: 'assets/images/evening.jpg',
                  color: MyColors.lightTextColor,
                  text: 'أذكار المساء'),
              const SizedBox(
                height: 10,
              ),
              AzkarItem(
                  onTap: () {
                    Navigator.pushNamed(context, SalahView.id);
                  },
                  image: 'assets/images/morning.jpg',
                  color: MyColors.darkTextColor,
                  text: 'مواقيت الصلاة'),
              const SizedBox(
                height: 10,
              ),
              AzkarItem(
                  onTap: () {
                    Navigator.pushNamed(context, SebhaView.id);
                  },
                  image: 'assets/images/evening.jpg',
                  color: MyColors.lightTextColor,
                  text: 'سبحة'),
            ],
          ),
        ),
      ),
    );
  }
}

class AzkarItem extends StatelessWidget {
  const AzkarItem({
    super.key,
    required this.image,
    required this.color,
    required this.text,
    required this.onTap,
  });

  final String image;
  final Color color;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Image.asset(
              image,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color, //Color(0xffAE8359)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
