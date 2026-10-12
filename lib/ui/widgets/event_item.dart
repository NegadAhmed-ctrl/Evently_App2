import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_utils.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/models/event.dart';
import 'package:flutter_application_1/ui/home/event_details/event_details_screen.dart';
import 'package:flutter_application_1/utils/size_utils.dart';
import 'package:provider/provider.dart';

class EventItem extends StatelessWidget {
  final Event event;
  const EventItem({super.key, required this.event});

  String _getMonth(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  // ✅ الدالة اتعدلت عشان تاخد isDark وترجع الصورة الصح
  String _getImageForCategory(int index, bool isDark) {
    List<String> lightImages = [
      'assets/images/sport_light.png',
      'assets/images/Birthday_light.png',
      'assets/images/meeting_light.png',
      'assets/images/Exhibition_light.png',
      'assets/images/book club_light.png',
    ];
    List<String> darkImages = [
      'assets/images/sport_black.png',
      'assets/images/Birthday_Dark.png',
      'assets/images/meeting_dark.png',
      'assets/images/Exhibition_dark.png',
      'assets/images/BookClub_dark.png',
    ];

    int safeIndex = (index > 0) ? index - 1 : 0;
    if (safeIndex >= 0 && safeIndex < lightImages.length) {
      return isDark ? darkImages[safeIndex] : lightImages[safeIndex];
    }
    return isDark
        ? 'assets/images/sport_black.png'
        : 'assets/images/sport_light.png';
  }

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    var themeProvider = Provider.of<AppThemeProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          EventDetailsScreen.routeName,
          arguments: event,
        );
      },
      child: Container(
        height: height * 0.25,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: height * 0.01,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: Theme.of(context).dividerColor),
          image: DecorationImage(
            fit: BoxFit.fill,
            // ✅ بنبعت هنا الـ theme الحالي
            image: AssetImage(
              _getImageForCategory(event.categoryIndex, themeProvider.isDark),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.02,
                vertical: height * 0.005,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Text(
                "${event.dateTime.day} ${_getMonth(event.dateTime.month)}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  IconButton(
                    onPressed: () {
                      event.isFavorite = !event.isFavorite;
                      FirebaseUtils.updateEvent(event);
                    },
                    icon: Icon(
                      event.isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 25,
                      color: event.isFavorite
                          ? Colors.red
                          : Theme.of(context).cardColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
