import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_utils.dart';
import 'package:flutter_application_1/models/event.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/size_utils.dart';

class EditEventScreen extends StatefulWidget {
  static const String routeName = 'edit_event';

  const EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late String selectedImage;
  late String selectedCategory;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final Event event = ModalRoute.of(context)!.settings.arguments as Event;
      titleController = TextEditingController(text: event.eventTitle);
      descriptionController = TextEditingController(
        text: event.eventDescription,
      );
      selectedImage = event.eventimage;
      selectedCategory = event.eventName;
      selectedDate = event.dateTime;
      selectedTime = TimeOfDay.fromDateTime(event.dateTime);
      isInit = false;
    }
  }

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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
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
          "Edit event",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
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
                  image: AssetImage(selectedImage),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),

            Text("Title", style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: height * 0.01),
            TextField(
              controller: titleController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: "Enter event title",
                filled: true,
                fillColor: Theme.of(context).highlightColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),

            Text(
              "Description",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: height * 0.01),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: "Enter event description",
                filled: true,
                fillColor: Theme.of(context).highlightColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),

            InkWell(
              onTap: _selectDate,
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: Theme.of(context).cardColor,
                  ),
                  SizedBox(width: width * 0.03),
                  Text(
                    "Event Date",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  Text(
                    "${_getMonth(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}",
                    style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            InkWell(
              onTap: _selectTime,
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    color: Theme.of(context).cardColor,
                  ),
                  SizedBox(width: width * 0.03),
                  Text(
                    "Event Time",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  Text(
                    selectedTime.format(context),
                    style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.10),

            SizedBox(
              width: double.infinity,
              height: height * 0.06,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  event.eventTitle = titleController.text;
                  event.eventDescription = descriptionController.text;
                  event.dateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  await FirebaseUtils.updateEvent(event);

                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: const Text(
                  "Update event",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
