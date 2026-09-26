import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_utils.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/l10n/provider/app_language_provider.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/models/event.dart';
import 'package:flutter_application_1/ui/widgets/event_item.dart';
import 'package:flutter_application_1/ui/widgets/tab_items.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/app_styles.dart';
import 'package:flutter_application_1/utils/size_utils.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    var themeProvider = Provider.of<AppThemeProvider>(context);
    var languageProvider = Provider.of<AppLanguageProvider>(context);

    List<String> eventNamesList = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.sport,
      AppLocalizations.of(context)!.birthday,
      AppLocalizations.of(context)!.meeting,
      AppLocalizations.of(context)!.book_club,
      AppLocalizations.of(context)!.exhibition,
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.02,
          horizontal: width * 0.04,
        ),
        child: DefaultTabController(
          length: eventNamesList.length,
          child: Column(
            spacing: height * 0.02,
            children: [
              Row(
                spacing: width * 0.02,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.welcome_back} ✨",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "Negad Ahmed",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    themeProvider.isDark
                        ? Icons.dark_mode_outlined
                        : Icons.wb_sunny_outlined,
                    size: 25,
                    color: Theme.of(context).cardColor,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.006,
                      horizontal: width * 0.02,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Text(
                      languageProvider.applanguage.toUpperCase(),
                      style: AppStyles.semi14White,
                    ),
                  ),
                ],
              ),
              TabBar(
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                tabAlignment: TabAlignment.start,
                labelPadding: EdgeInsets.symmetric(horizontal: width * 0.02),
                isScrollable: true,
                indicatorColor: AppColors.transparentColor,
                dividerColor: AppColors.transparentColor,
                tabs: eventNamesList.map((eventName) {
                  return TabItems(
                    isSelected:
                        selectedIndex == eventNamesList.indexOf(eventName),
                    eventName: eventName,
                  );
                }).toList(),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Event>>(
                  stream: FirebaseUtils.getEventsCollection().snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Something went wrong!"));
                    }

                    var eventlist =
                        snapshot.data?.docs.map((doc) => doc.data()).toList() ??
                        [];

                    // ✅ filter
                    var filterEventsList = selectedIndex == 0
                        ? eventlist
                        : eventlist
                              .where(
                                (event) =>
                                    event.eventCategoryIndex == selectedIndex,
                              )
                              .toList();

                    // ✅ sort by date
                    filterEventsList.sort(
                      (a, b) => a.dateTime.compareTo(b.dateTime),
                    );

                    if (filterEventsList.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.no_events_found,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      );
                    }

                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return EventItem(event: filterEventsList[index]);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: height * 0.02);
                      },
                      itemCount: filterEventsList.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
