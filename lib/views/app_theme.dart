import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

ThemeData customTheme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.secondaryColor,
    primaryColor: AppColors.primaryColor,
    // Optional: primary color for the app
    /** BUTTON THEME */
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        // Button background color
        foregroundColor: AppColors.secondaryColor,
        // Button text color
        textStyle: AppFonts.bodyFont(
          color: AppColors.secondaryColor,
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondaryColor,
        // Button text color
        backgroundColor: AppColors.primaryColor,
        // Button background color
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        textStyle: AppFonts.bodyFont(
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.black,
        // Button text color
        backgroundColor: AppColors.secondaryColor,
        // Button background color
        side: const BorderSide(color: AppColors.black),
        // Outline color
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        textStyle: AppFonts.bodyFont(
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    ),
    /** BUTTON THEME END*/
    /** TEXT FIELD THEME */
    inputDecorationTheme: InputDecorationTheme(
      errorMaxLines: 3,
      // Default border settings (without focus)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none, // No border by default
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none, // No border when enabled but not focused
      ),

      // Border when the TextField is focused
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.primaryColor, // Border color when focused
          width: 1.0.w,
        ),
      ),

      // Padding
      contentPadding: const EdgeInsets.only(
        left: 18,
      ),

      // Background color changes for focused/unfocused
      filled: true,
      fillColor: AppColors.textFieldBackgroundColor,
      // Default background color when not focused

      // Text style for hint and input text
      hintStyle: AppFonts.hintFont(
        color: AppColors.hintTextColor, // Hint text color
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: AppFonts.bodyFont(
        color: AppColors.black,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: AppColors.primaryColor,
      selectionHandleColor: AppColors.primaryColor,
    ),
    /** TEXT FIELD THEME END*/
    /** APP BAR THEME */
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondaryColor,
      // Set the background color
      elevation: 0,
      // Set to 0 for flat AppBar or any value for shadow
      centerTitle: true,
      // Center the title if needed
      scrolledUnderElevation: 0.0,
      titleTextStyle: AppFonts.bodyFont(
        color: AppColors.primaryColor,
        // Set the color of the title text to white
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.appBarLeadingIconColor,
      ),
    ),
    /** APP BAR THEME END*/
    /** BOTTOM SHEET THEME START*/
    bottomSheetTheme: const BottomSheetThemeData(
      modalBackgroundColor: AppColors.secondaryColor,
      // Change the handle color globally
      dragHandleColor: AppColors.primaryColor,
    ),
    /** BOTTOM SHEET THEME END*/
    /** FAB SHEET THEME START*/
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondaryColor,
    ),
    /** FAB SHEET THEME END*/
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryColor, // Progress color
      linearTrackColor: Colors.grey[300], // Remaining part color
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(AppColors.primaryColor),
      overlayColor: WidgetStateProperty.all(
        AppColors.primaryColor.withOpacity(
          0.2,
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    unselectedWidgetColor: AppColors.black,
    checkboxTheme: CheckboxThemeData(
      fillColor:
      WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor; // Checkbox color when selected
        }
        return Colors.transparent; // No fill color when not selected
      }),
      checkColor: WidgetStateProperty.all(AppColors.secondaryColor),
      // Tick color when selected
      side: WidgetStateBorderSide.resolveWith(
            (Set<WidgetState> states) {
          if (!states.contains(WidgetState.selected)) {
            return const BorderSide(
                color: AppColors.black); // Border color when not selected
          }
          return const BorderSide(
            color: AppColors.primaryColor,
          ); // Border color when selected
        },
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      dayPeriodColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        }
        return Colors.transparent;
      }),
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.secondaryColor;
        }
        return AppColors.black;
      }),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.secondaryColor),
        surfaceTintColor: WidgetStateProperty.all(AppColors.secondaryColor),
      ),
    ),
  );
}
