import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_utils.dart';
import 'package:flutter_application_1/models/event.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/app_routes.dart';
import 'package:flutter_application_1/utils/size_utils.dart';

class EventDetailsScreen extends StatelessWidget {
  static const String routeName = 'event_details';

  const EventDetailsScreen({super.key});

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
    final Event event = ModalRoute.of(context)!.settings.arguments as Event;
    var height = context.height;
    var width = context.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBgColor,
        title: Text(
          "Event details",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Theme.of(context).cardColor),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.eventEditScreen,
                arguments: event,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () async {
              await FirebaseUtils.deleteEvent(event.id);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height * 0.25,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(event.eventimage),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),

            Text(
              event.eventTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: height * 0.02),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.015,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  SizedBox(width: width * 0.04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${event.dateTime.day} ${_getMonth(event.dateTime.month)} ${event.dateTime.year}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: height * 0.005),
                      Text(
                        "${event.dateTime.hour}:${event.dateTime.minute}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),

            Text(
              "Description",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: height * 1.0 / 100),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(width * 0.04),
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Text(
                event.eventDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
