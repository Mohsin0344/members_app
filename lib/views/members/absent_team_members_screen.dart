import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:members_app/utils/app_extensions.dart';
import 'package:members_app/views/widgets/loading_indicator.dart';

import '../../models/members/absent_members_model.dart';
import '../../models/pagination_request_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../view_models/absences/absence_types_view_model.dart';
import '../../view_models/absences/absences_ical_view_model.dart';
import '../../view_models/app_states.dart';
import '../../view_models/members/absent_members_view_model.dart';
import '../widgets/absence_types_widget.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/app_toast_widget.dart';
import '../widgets/custom_cached_network_image.dart';
import '../widgets/error_widget.dart';
import '../widgets/no_data_widget.dart';
import '../widgets/views_error_handler.dart';

class AbsentTeamMembersScreen extends StatefulWidget {
  const AbsentTeamMembersScreen({super.key});

  @override
  State<AbsentTeamMembersScreen> createState() =>
      _AbsentTeamMembersScreenState();
}

class _AbsentTeamMembersScreenState extends State<AbsentTeamMembersScreen> {
  late AbsentMembersViewModel absentMembersViewModel;
  late AbsenceTypesViewModel absenceTypesViewModel;
  late AbsencesIcalViewModel absencesIcalViewModel;
  final PagingController<int, AbsentMember> absentMembersPagingController =
  PagingController(
    firstPageKey: 1,
  );
  PaginationRequest paginationRequest = PaginationRequest(
    page: 1,
  );

  @override
  void initState() {
    super.initState();
    initViewModels();
    callViewModels();
  }

  initViewModels() {
    absentMembersViewModel = context.read<AbsentMembersViewModel>();
    absenceTypesViewModel = context.read<AbsenceTypesViewModel>();
    absencesIcalViewModel = context.read<AbsencesIcalViewModel>();
  }

  callViewModels() {
      absentMembersPagingController
          .addPageRequestListener((pageKey) {
        paginationRequest.page = pageKey;
        absentMembersViewModel.getAbsentMembers(
          paginationRequest: paginationRequest,
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AbsentMembersViewModel, AppState>(
          listener: (context, state) {
            if (state is SuccessState<AbsentMembersModel>) {
              AbsentMembersModel members = state.data;
              absentMembersPagingController.appendPage(
                members.data ?? [],
                members.pagination?.nextPage,
              );
            } else if (state != const LoadingState()) {
              absentMembersPagingController.error = '';
              errorHandler(
                context: context,
                state: state,
              );
            }
          },
        ),
        BlocListener<AbsencesIcalViewModel, AppState>(
          listener: (context, state) {
            if(state is UnknownErrorState) {
              showCustomSnackBar(
                context, state.error.toString(),
              );
            } else if(state is SuccessState) {
              CustomToasts.showSuccessToast(
                message: state.data,
                toastGravity: ToastGravity.BOTTOM,
              );
            }
          },
        )
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 20.w,
        ),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                absenceSummaryCard(),
                AbsenceTypesWidget(
                  onTypeChange: (type) {
                    paginationRequest.type = type;
                    absentMembersPagingController.itemList =
                        [];
                    absentMembersPagingController.refresh();
                  },
                ),
                PagedSliverList.separated(
                  pagingController:
                      absentMembersPagingController,
                  builderDelegate: PagedChildBuilderDelegate<AbsentMember>(
                    firstPageProgressIndicatorBuilder: (context) => const Center(
                      child: LoadingIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => const NoDataWidget(),
                    firstPageErrorIndicatorBuilder: (context) =>
                        const ErrorStateWidget(),
                    itemBuilder: (context, absentMember, index) =>
                        memberWidget(absentMember: absentMember),
                  ),
                  separatorBuilder: (BuildContext context, int index) => SizedBox(
                    height: 8.h,
                  ),
                )
              ],
            ),
            exportIcalWidget(),
          ],
        ),
      ),
    );
  }

  exportIcalWidget() {
    return BlocBuilder<AbsentMembersViewModel, AppState>(
      builder: (context, state) {
        if(state is SuccessState<AbsentMembersModel>) {
          if((state.data.data?.isNotEmpty ?? false)) {
            return Positioned(
              bottom: 10.h,
              right: 0,
              child: FloatingActionButton(
                onPressed: () {
                  if (absencesIcalViewModel.state == const LoadingState()) {
                    return;
                  }
                  absencesIcalViewModel.generateIcalFile(
                    absences: absentMembersPagingController.itemList ??
                        [],
                  );
                },
                child: BlocBuilder<AbsencesIcalViewModel, AppState>(
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return const Center(
                        child: LoadingIndicator(
                          color: AppColors.secondaryColor,
                        ),
                      );
                    }
                    return const Icon(
                      Icons.save_alt,
                      color: AppColors.secondaryColor,
                    );
                  },
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget absenceSummaryCard() {
    return SliverToBoxAdapter(
      child: BlocBuilder<AbsentMembersViewModel, AppState>(
        builder: (context, state) {
          if (state is SuccessState<AbsentMembersModel>) {
            return Container(
              height: 100.h,
              // width: 150.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              margin: EdgeInsets.only(
                bottom: 10.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person,
                              color: AppColors.secondaryColor,
                            ),
                            4.horizontalSpace,
                            Text(
                              '${state.data.pagination!.totalItems ?? 0}',
                              style: AppFonts.bodyFont(
                                color: AppColors.secondaryColor,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        4.verticalSpace,
                        Flexible(
                          child: Text(
                            'Absent Members (${absenceTypesViewModel.selectedType})',
                            style: AppFonts.bodyFont(
                              color: AppColors.secondaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setState(() {
                            paginationRequest.date = picked.toString();
                          });
                          absentMembersPagingController
                              .refresh();
                        }
                      },
                      child: DecoratedBox(
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: AppColors.secondaryColor,
                            ),
                            8.verticalSpace,
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  text: paginationRequest.date
                                          ?.toReadableDate() ??
                                      'Select Date',
                                  style: AppFonts.bodyFont(
                                    color: AppColors.secondaryColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    if (paginationRequest.date != null)WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            paginationRequest.date = null;
                                          });
                                          absentMembersPagingController
                                              .refresh();

                                        },
                                        child: const DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: AppColors.secondaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (state is LoadingState) {
            return Container(
              height: 100.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              margin: EdgeInsets.only(
                bottom: 10.h,
              ),
              child: const Center(
                child: LoadingIndicator(color: AppColors.secondaryColor),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget memberWidget({required AbsentMember absentMember}) {
    return IntrinsicHeight(
      child: Card(
        color: AppColors.secondaryColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Member Image & Name
              Row(
                children: [
                  SizedBox(
                    height: 50.h,
                    width: 50.w,
                    child: ClipOval(
                      child: CustomCachedNetworkImage(
                        imageUrl: absentMember.member?.image ?? '',
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      absentMember.member?.name ?? 'Unknown',
                      style: AppFonts.bodyFont(
                        color: AppColors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              10.verticalSpace,

              // Absence Type
              Row(
                children: [
                  const Icon(Icons.work_off, size: 18),
                  8.horizontalSpace,
                  Text(
                    absentMember.type ?? '',
                    style: AppFonts.bodyFont(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Period (Start Date - End Date)
              if (absentMember.confirmedAt != null) ...[
                8.verticalSpace,
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    8.horizontalSpace,
                    Flexible(
                      child: Text(
                        '${absentMember.startDate.toString().toReadableDate()} - ${absentMember.endDate.toString().toReadableDate()}',
                        style: AppFonts.bodyFont(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                )
              ],
              8.verticalSpace,

              // Status
              Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 18),
                  8.horizontalSpace,
                  Text(
                    _getStatus(absentMember),
                    style: AppFonts.bodyFont(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(absentMember),
                    ),
                  ),
                ],
              ),
              8.verticalSpace,

              // Member Note (if available)
              if (absentMember.memberNote?.isNotEmpty ?? false) ...[
                Flexible(
                  child: Row(
                    children: [
                      const Icon(Icons.note, size: 18),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          absentMember.memberNote!,
                          style: AppFonts.bodyFont(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                8.verticalSpace,
              ],

              // Admitter Note (if available)
              if (absentMember.admitterNote?.isNotEmpty ?? false) ...[
                Flexible(
                  child: Row(
                    children: [
                      const Icon(Icons.feedback, size: 18),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          'Admitter Note: ${absentMember.admitterNote!}',
                          style: AppFonts.bodyFont(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getStatus(AbsentMember absentMember) {
    if (absentMember.confirmedAt != null) return 'Confirmed';
    if (absentMember.rejectedAt != null) return 'Rejected';
    return 'Requested';
  }

  Color _getStatusColor(AbsentMember absentMember) {
    if (absentMember.confirmedAt != null) return AppColors.greenColor;
    if (absentMember.rejectedAt != null) return AppColors.redColor;
    return AppColors.orangeColor;
  }
}
