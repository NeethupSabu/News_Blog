import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:one/Widgets/NewsListView.dart';
import 'package:one/Widgets/SeeAllNews.dart';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

class AllNewsTab extends StatefulWidget {
  const AllNewsTab({super.key});

  @override
  _AllNewsTabState createState() => _AllNewsTabState();
}

class _AllNewsTabState extends State<AllNewsTab> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Slider
        SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width, // Use full width of screen
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: false, // Disable auto-play
              viewportFraction: 0.8,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index; // Update current index
                });
              },
            ),
            items: [
              Container(
                padding: const EdgeInsets.only(
                  left: 4.0,
                  top: 8.0,
                ), // Add padding
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0), // Border radius
                  child: Image.asset(
                    'assets/nb_newsImage1.jpg',
                    fit: BoxFit.cover, // Cover the available space
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 4.0, top: 8.0, right: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    'assets/nb_newsImage2.jpg',
                    fit: BoxFit.cover, // Cover the available space
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 4.0, top: 8.0, right: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    'https://assets.iqonic.design/old-themeforest-images/prokit/images/newsBlog/nb_newsImage3.jpg',
                    fit: BoxFit.cover, // Cover the available space
                  ),
                ),
              ),
            ],
          ),
        ),
        // Dot Indicator
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (index) => DotIndicator(isActive: index == _currentIndex),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Row with Latest News and Show More
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'latest_news'.tr(), // Localized "Latest News"
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              TextButton(
                child: Text(
                  'show_more'.tr(), // Localized "Show More"
                  style:
                      const TextStyle(color: Color(0xFFFD5530), fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllNewsPage()),
                  );
                },
              ),
            ],
          ),
        ),
        // List of News
        const Expanded(
          child: NewsListView(category: 'all'),
        ),
      ],
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFFFD5530) : Colors.grey,
      ),
    );
  }
}
