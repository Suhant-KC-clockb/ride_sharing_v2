import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:ridesharing/routes.dart';
import 'package:ridesharing/utils/mediaquery.dart';
import 'package:ridesharing/widgets/app_on_board.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({Key? key}) : super(key: key);

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  late int selectedPage;
  late final PageController _pageController;

  Timer? _timer;

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);

    // _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
    //   if (selectedPage < 3) {
    //     selectedPage++;
    //   } else {
    //     selectedPage = 0;
    //   }

    //   _pageController.animateToPage(
    //     selectedPage,
    //     duration: const Duration(milliseconds: 350),
    //     curve: Curves.easeIn,
    //   );
    // });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pageCount = 4;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: PageView(
              onPageChanged: (page) {
                setState(() {
                  selectedPage = page;
                });
              },
              controller: _pageController,
              children: [
                appOnBoaringPage(
                  context,
                  imagePath: "assets/images/getting_started.png",
                  title: "Unlock Your City  with Every Ride.",
                ),
                appOnBoaringPage(
                  context,
                  imagePath: "assets/images/getting_started_1.png",
                  title: "Your Ride, Your way, Every Day.",
                ),
                appOnBoaringPage(
                  context,
                  imagePath: "assets/images/getting_started_2.png",
                  title: "Ride Easy, Ride Happy.",
                ),
                appOnBoaringPage(
                  context,
                  imagePath: "assets/images/getting_started_3.png",
                  title: "Ride Easy, Ride Happy.",
                ),
              ],
            ),
          ),
          PageViewDotIndicator(
            currentItem: selectedPage,
            count: pageCount,
            unselectedColor: Colors.black26,
            selectedColor: Colors.black,
            duration: const Duration(milliseconds: 200),
            boxShape: BoxShape.circle,
            onItemClicked: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            },
          ),
          Container(
            width: getWidth(context) * 0.7,
            height: 50,
            margin: const EdgeInsets.only(bottom: 30),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Pathname.otpScreen);


                
              },
              child: const Text("Getting Started"),
            ),
          ),
        ],
      ),
    );
  }
}
