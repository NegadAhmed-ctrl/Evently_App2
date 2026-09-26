import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_utils.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/models/event.dart';
import 'package:flutter_application_1/ui/widgets/custom_elevated_bottom.dart';
import 'package:flutter_application_1/ui/widgets/custom_text_field.dart';
import 'package:flutter_application_1/ui/widgets/tab_items.dart';
import 'package:flutter_application_1/utils/app_assets.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/size_utils.dart';
import 'package:flutter_application_1/utils/toast_utiles.dart';
import 'package:provider/provider.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final List<String> listImages = [
    "Sport", // index 1 ✅ matches home_tab
    "Birthday", // index 2
    "Meeting", // index 3
    "Book Club", // index 4
    "Exhibition", // index 5
  ];

  final List<String> listLightImages = [
    AppAssets.sportLightImage,
    AppAssets.birthdayLightImage,
    AppAssets.meetingLightImage,
    AppAssets.bookClubLightImage,
    AppAssets.exhibitionLightImage,
  ];

  final List<String> listDarkImages = [
    AppAssets.sportDarkImage,
    AppAssets.birthdayDarkImage,
    AppAssets.meetingDarkImage,
    AppAssets.bookClubDarkImage,
    AppAssets.exhibitionDarkImage,
  ];

  int selectedIndex = 1; // ✅ starts at 1 (Sport) to match home_tab index

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> chooseDate() async {
    var chosenDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (chosenDate != null) {
      setState(() {
        selectedDate = chosenDate;
      });
    }
  }

  Future<void> chooseTime() async {
    var chosenTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (chosenTime != null) {
      setState(() {
        selectedTime = chosenTime;
      });
    }
  }

  void addEvent() {
    if (formKey.currentState?.validate() == true) {
      DateTime eventDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      var themeProvider = Provider.of<AppThemeProvider>(context, listen: false);

      Event event = Event(
        eventCategoryIndex: selectedIndex,
        eventName: listImages[selectedIndex - 1],
        eventimage: themeProvider.isDark
            ? listDarkImages[selectedIndex - 1]
            : listLightImages[selectedIndex - 1],
        eventTitle: titleController.text,
        eventDescription: descriptionController.text,
        dateTime: eventDateTime,
      );

      FirebaseUtils.addEventToFireStore(event)
          .then((value) {
            print("Event added successfully.");
            ToastUtiles.toastMsg(
              msg: "Event added successfully.",
              backgroundColor: AppColors.greenColor,
              textColor: AppColors.whiteColor,
            );
          })
          .catchError((error) {
            print(error.toString());
            ToastUtiles.toastMsg(
              msg: error.toString(),
              backgroundColor: AppColors.redColor,
              textColor: AppColors.whiteColor,
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;

    var themeProvider = Provider.of<AppThemeProvider>(context);
    var localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.add_event,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: themeProvider.isDark
              ? AppColors.whiteColor
              : AppColors.mainLightColor,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.02,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: height * 0.22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).dividerColor,
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                          themeProvider.isDark
                              ? listDarkImages[selectedIndex - 1]
                              : listLightImages[selectedIndex - 1],
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  SizedBox(
                    height: height * 0.05,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = index + 1; // ✅ offset by 1
                            });
                          },
                          child: TabItems(
                            isSelected: selectedIndex == index + 1,
                            eventName: listImages[index],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(width: width * 0.02),
                      itemCount: listImages.length,
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  Text(
                    localizations.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  SizedBox(height: height * 0.01),

                  CustomTextField(
                    controller: titleController,
                    hintText: localizations.event_title_hint,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter event title";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: height * 0.02),

                  Text(
                    localizations.description,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  SizedBox(height: height * 0.01),

                  CustomTextField(
                    controller: descriptionController,
                    hintText: localizations.event_description_hint,
                    maxilines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter event description";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: height * 0.02),

                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: themeProvider.isDark
                            ? AppColors.whiteColor
                            : AppColors.mainLightColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        localizations.event_date,
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(fontSize: 16),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: chooseDate,
                        child: Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: TextStyle(
                            color: themeProvider.isDark
                                ? AppColors.whiteColor
                                : AppColors.mainLightColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.01),

                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: themeProvider.isDark
                            ? AppColors.whiteColor
                            : AppColors.mainLightColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        localizations.event_time,
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(fontSize: 16),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: chooseTime,
                        child: Text(
                          selectedTime.format(context),
                          style: TextStyle(
                            color: themeProvider.isDark
                                ? AppColors.whiteColor
                                : AppColors.mainLightColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.03),

                  CustomElevatedBottom(
                    backgroundcolor: themeProvider.isDark
                        ? AppColors.mainDarkColor
                        : AppColors.mainLightColor,
                    onPressed: addEvent,
                    child: Text(
                      localizations.add_event,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
