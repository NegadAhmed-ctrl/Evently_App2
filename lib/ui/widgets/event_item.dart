import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_utils.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/models/event.dart';
import 'package:flutter_application_1/ui/home/event_details/event_details_screen.dart'; // تأكد من عمل استيراد لشاشة التفاصيل
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

  @override
  Widget build(BuildContext context) {
    var hieght = context.height;
    var width = context.width;
    var themeProvider = Provider.of<AppThemeProvider>(context);

    // ✅ غلفنا الـ Container بـ GestureDetector عشان يستجيب للضغط
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          EventDetailsScreen.routeName,
          arguments: event, // بنبعت بيانات الإيفنت للتفاصيل
        );
      },
      child: Container(
        height: hieght * 0.25,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: hieght * 0.01,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: Theme.of(context).dividerColor),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(event.eventimage),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.02,
                vertical: hieght * 0.005,
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
                    event.eventTitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  IconButton(
                    onPressed: () {
                      // ✅ toggle favorite
                      event.isFavorite = !event.isFavorite;
                      FirebaseUtils.updateFavorite(event);
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
