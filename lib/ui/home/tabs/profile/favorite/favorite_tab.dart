import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_utils.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/models/event.dart';
import 'package:flutter_application_1/ui/widgets/custom_text_field.dart';
import 'package:flutter_application_1/ui/widgets/event_item.dart';
import 'package:flutter_application_1/utils/size_utils.dart';

class FavoriteTab extends StatelessWidget {
  const FavoriteTab({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.02,
          ),
          child: Column(
            spacing: height * 0.02,
            children: [
              CustomTextField(
                borderColor: Theme.of(context).dividerColor,
                hintText: AppLocalizations.of(context)!.search_for_event,
                hintStyle: Theme.of(context).textTheme.bodyLarge,
                style: Theme.of(context).textTheme.bodySmall,
                sufix: Icon(
                  Icons.search,
                  size: 25,
                  color: Theme.of(context).cardColor,
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Event>>(
                  // ✅ بيجيب بس الـ events اللي isFavorite == true
                  stream: FirebaseUtils.getEventsCollection()
                      .where("is_favorite", isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Something went wrong!"));
                    }

                    var favoriteList =
                        snapshot.data?.docs.map((doc) => doc.data()).toList() ??
                        [];

                    if (favoriteList.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.no_events_found,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      );
                    }

                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return EventItem(event: favoriteList[index]);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: height * 0.02);
                      },
                      itemCount: favoriteList.length,
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
