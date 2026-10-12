class Event {
  String id;
  String title;
  String description;
  int categoryIndex;
  String categoryName;
  DateTime dateTime;
  String location;
  bool isFavorite;
  String userId;

  Event({
    this.id = '',
    required this.title,
    required this.description,
    required this.categoryIndex,
    required this.categoryName,
    required this.dateTime,
    required this.location,
    this.isFavorite = false,
    required this.userId,
  });

  factory Event.fromJsonFireStore(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? json['eventTitle'] as String? ?? '',
      description:
          json['description'] as String? ??
          json['eventDescription'] as String? ??
          '',
      categoryIndex:
          json['categoryIndex'] as int? ??
          json['eventCategoryIndex'] as int? ??
          0,
      categoryName: json['categoryName'] as String? ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        json['dateTime'] as int? ?? 0,
      ),
      location: json['location'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      userId: json['userId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJsonFireStore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryIndex': categoryIndex,
      'categoryName': categoryName,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'location': location,
      'isFavorite': isFavorite,
      'userId': userId,
    };
  }
}
