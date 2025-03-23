import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:members_app/views/widgets/views_error_handler.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/absences/absence_types-model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../view_models/absences/absence_types_view_model.dart';
import '../../view_models/app_states.dart';

class AbsenceTypesWidget extends StatefulWidget {
  final ValueChanged<String?> onTypeChange;

  const AbsenceTypesWidget({
    super.key,
    required this.onTypeChange,
  });

  @override
  State<AbsenceTypesWidget> createState() => _AbsenceTypesWidgetState();
}

class _AbsenceTypesWidgetState extends State<AbsenceTypesWidget> {
  late AbsenceTypesViewModel absenceTypesViewModel;

  @override
  void initState() {
    super.initState();
    initViewModels();
    callViewModels();
  }

  initViewModels() {
    absenceTypesViewModel = context.read<AbsenceTypesViewModel>();
  }

  callViewModels() {
    absenceTypesViewModel.selectedType = 'All';
    absenceTypesViewModel.getAbsenceTypes();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 20.h,
        ),
        child: BlocConsumer<AbsenceTypesViewModel, AppState>(
          listener: (context, state) {
            errorHandler(
              context: context,
              state: state,
            );
          },
          builder: (context, state) {
            if (state is SuccessState<AbsenceTypesModel>) {
              AbsenceTypesModel types = state.data;
              return Wrap(
                direction: Axis.horizontal,
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  pillWidget('All'),
                  ...List.generate(types.data?.length ?? 0, (index) {
                    String? type = types.data?[index];
                    return pillWidget(type);
                  })
                ],
              );
            }
            return loadingWidget();
          },
        ),
      ),
    );
  }

  pillWidget(String? type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          absenceTypesViewModel.selectedType = type ?? '';
          widget.onTypeChange(
            absenceTypesViewModel.selectedType == 'All' ? null : absenceTypesViewModel.selectedType,
          );
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            8.r,
          ),
          border: Border.all(
            color: type == absenceTypesViewModel.selectedType
                ? AppColors.primaryColor
                : AppColors.hintTextColor,
          ),
          color: type == absenceTypesViewModel.selectedType
              ? AppColors.primaryColor
              : Colors.transparent,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            top: 4.h,
            bottom: 4.h,
          ),
          child: Text(
            type ?? '',
            style: AppFonts.bodyFont(
              color: type == absenceTypesViewModel.selectedType
                  ? AppColors.secondaryColor
                  : AppColors.hintTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  loadingWidget() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 8.w,
        runSpacing: 8.h,
        children: [
          ...List.generate(4, (index) {
            return pillWidget('');
          })
        ],
      ),
    );
  }
}
