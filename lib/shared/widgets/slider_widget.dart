import 'dart:async';

import 'package:flutter/material.dart';
import 'package:midical_laboratory/cubit/advertisment_cubit/advertisment_cubit.dart';
import 'package:midical_laboratory/models/advertisment_model/advertisment_modle.dart';

import 'package:midical_laboratory/shared/widgets/advert_card.dart';
import 'package:midical_laboratory/shared/widgets/indicator_widget.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key, required this.dataSlider});

  final List<AdvertismentModel> dataSlider;

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late Timer _timer;
  int _currentPage = 0;
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
    super.initState();
  }

  void _init() {
    _timer = Timer.periodic(Duration(seconds: 3), (_) {
      _currentPage++;
      _currentPage %= widget.dataSlider.length;
      setState(() {});
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.dataSlider.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              // final slider = widget.dataSlider[index].;
              // return ImageCard(image_url: slider);
            },
          ),
        ),
        IndicatorWidget(
          selectedIndex: _currentPage,
          length: widget.dataSlider.length,
        ),
      ],
    );
  }
}






  // @override
  // void initState() {
  //   super.initState();
  //   _pageController = PageController();

  //   _timer = Timer.periodic(const Duration(seconds: 3), (_) {
  //     _currentPage++;
  //     _currentPage %= widget.dataSlider.length;
  //     print(_currentPage);
  //     _pageController.animateToPage(
  //       _currentPage,
  //       curve: Curves.easeIn,
  //       duration: const Duration(milliseconds: 300),
  //     );
  //   });
  

 
