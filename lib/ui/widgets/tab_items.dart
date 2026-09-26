import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/widgets/event_item.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/app_styles.dart';
import 'package:flutter_application_1/utils/size_utils.dart';

class TabItems extends StatelessWidget {
  final bool isSelected;
  final String eventName;
  const TabItems({
    super.key,
    required this.isSelected,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.006,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isSelected
            ? Theme.of(context).cardColor
            : AppColors.transparentColor,
        border: Border.all(
          width: 2,
          color: isSelected
              ? AppColors.transparentColor
              : Theme.of(context).dividerColor,
        ),
      ),
      child: Text(
        eventName,
        style: isSelected
            ? AppStyles.medium16White
            : Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
