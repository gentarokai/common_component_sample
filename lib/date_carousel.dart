import 'package:flutter/material.dart';

class DateCarousel extends StatefulWidget {
  const DateCarousel({super.key});

  @override
  DateCarouselState createState() => DateCarouselState();
}

class DateCarouselState extends State<DateCarousel> {
  int selectedIndex = 2;
  late CarouselController _carouselController;
  int currentCenterIndex = 2;

  bool get isAtStart => currentCenterIndex <= 1;
  bool get isAtEnd => currentCenterIndex >= dates.length - 2;

  final List<Map<String, dynamic>> dates = [
    {'day': 25, 'weekday': '日'},
    {'day': 26, 'weekday': '月'},
    {'day': 27, 'weekday': '火'},
    {'day': 28, 'weekday': '水'},
    {'day': 29, 'weekday': '木'},
    {'day': 30, 'weekday': '金'},
    {'day': 31, 'weekday': '土'},
    {'day': 1, 'weekday': '日'},
    {'day': 2, 'weekday': '月'},
    {'day': 3, 'weekday': '火'},
    {'day': 4, 'weekday': '水'},
    {'day': 5, 'weekday': '木'},
    {'day': 6, 'weekday': '金'},
    {'day': 7, 'weekday': '土'},
  ];

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController(initialItem: selectedIndex);
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollUpdateNotification) {
                // スクロール位置から現在の中央要素を計算
                final scrollOffset = notification.metrics.pixels;
                final itemExtent = 80.0;
                final newCenterIndex = (scrollOffset / itemExtent).round();
                if (newCenterIndex != currentCenterIndex) {
                  setState(() {
                    currentCenterIndex = newCenterIndex.clamp(
                      0,
                      dates.length - 1,
                    );
                  });
                }
              }
              return true;
            },
            child: CarouselView(
              controller: _carouselController,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              itemExtent: 80,
              shrinkExtent: 80,
              children: List.generate(dates.length, (index) {
                final date = dates[index];
                final isSelected = selectedIndex == index;

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.blue : Colors.white,
                          border: Border.all(color: Colors.blue, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            '${date['day']}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        date['weekday'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          // 左端のグラデーション（端でない場合のみ表示）
          if (!isAtStart)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 40,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withValues(alpha: 0)],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          // 右端のグラデーション（端でない場合のみ表示）
          if (!isAtEnd)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 40,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withValues(alpha: 0), Colors.white],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
