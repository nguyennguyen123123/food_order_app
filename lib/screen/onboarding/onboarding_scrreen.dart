import 'package:flutter/material.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/widgets/dot_indicators.dart';
import 'package:get/get.dart';
import 'components/onboard_content.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 14,
              child: PageView.builder(
                itemCount: demoData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemBuilder: (context, index) => OnboardContent(
                  illustration: demoData[index]["illustration"],
                  title: demoData[index]["title"],
                  text: demoData[index]["text"],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                demoData.length,
                (index) => DotIndicator(isActive: index == currentPage),
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(Routes.SIGNIN);
                },
                child: Text("Get Started".toUpperCase()),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> demoData = [
  {
    "illustration": "assets/icons/Illustrations_1.svg",
    "title": "All your favorites",
    "text": "Order from the best local restaurants \nwith easy, on-demand delivery.",
  },
  {
    "illustration": "assets/icons/Illustrations_2.svg",
    "title": "Free delivery offers",
    "text": "Free delivery for new customers via Apple Pay\nand others payment methods.",
  },
  {
    "illustration": "assets/icons/Illustrations_3.svg",
    "title": "Choose your food",
    "text": "Easily find your type of food craving and\nyou’ll get delivery in wide range.",
  },
];
