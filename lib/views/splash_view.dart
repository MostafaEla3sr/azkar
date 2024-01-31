import 'package:flutter/material.dart';
import 'package:notifications/views/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);
  static const String id = 'SplashView';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin{

  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();
    initSlidingAnimation();
    navigateToHome();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
             'assets/images/sebha.png',
              width: MediaQuery.sizeOf(context).width * 0.6,
            ),
            const SizedBox(
              height: 4,
            ),
          AnimatedBuilder(
              animation: slidingAnimation,
              builder: (context, child) {
                return SlideTransition(
                  position: slidingAnimation,
                  child: const Text(
                    'وَذَكِّرْ فَإِنَّ الذِّكْرَىٰ تَنفَعُ الْمُؤْمِنِينَ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff4C230D),
                      // fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    slidingAnimation = Tween<Offset>(
      begin: const Offset(0, 10),
      end: Offset.zero,
    ).animate(animationController);
    animationController.forward();
  }

  void navigateToHome() {
    Future.delayed(
      const Duration(seconds: 2),
          () {
       Navigator.pushNamed(context, HomeView.id);
      },
    );
  }
}
