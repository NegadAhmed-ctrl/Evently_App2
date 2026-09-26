import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  static const String collectionName = "Events";

  String id;
  String eventimage;
  String eventName;
  String eventTitle;
  String eventDescription;
  DateTime dateTime;
  bool isFavorite;
  int eventCategoryIndex;

  Event({
    this.id = "",
    required this.eventName,
    required this.eventimage,
    required this.eventTitle,
    required this.eventDescription,
    required this.dateTime,
    this.isFavorite = false,
    required this.eventCategoryIndex,
  });

  Event.fromjasonFireStore(Map<String, dynamic> data)
    : this(
        id: data["id"] ?? "",
        eventName: data["event_name"],
        eventDescription: data["event_description"],
        eventTitle: data["event_title"],
        eventimage: data["event_image"],
        dateTime: (data["date_time"] as Timestamp).toDate(),
        isFavorite: data["is_favorite"],
        eventCategoryIndex: data["eventCategoryIndex"] ?? 0,
      );

  Map<String, dynamic> tojasonFireStore() {
    return {
      "id": id,
      "event_name": eventName,
      "event_title": eventTitle,
      "event_image": eventimage,
      "event_description": eventDescription,
      "date_time": dateTime,
      "is_favorite": isFavorite,
      "eventCategoryIndex": eventCategoryIndex, // ✅ added
    };
  }
}
