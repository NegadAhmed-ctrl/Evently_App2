import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_utils.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/models/event.dart';
import 'package:flutter_application_1/ui/widgets/custom_text_field.dart';
import 'package:flutter_application_1/ui/widgets/event_item.dart';
import 'package:flutter_application_1/utils/size_utils.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
            children: [
              CustomTextField(
                controller: searchController, // ✅ ضفنا الكنترولر المطلوب
                hintText: AppLocalizations.of(context)!.search_for_event,
                prefixIcon: Icon(
                  Icons.search,
                  size: 25,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Event>>(
                  // ✅ بيجيب بس الـ events اللي isFavorite == true وتخص اليوزر الحالي بس
                  stream: FirebaseUtils.getEventsCollection()
                      .where(
                        'userId',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '',
                      )
                      .where('isFavorite', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong!"));
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
