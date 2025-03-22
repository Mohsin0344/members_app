import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:members_app/my_app.dart';
import 'package:members_app/utils/app_extensions.dart';

import '../../models/members/absent_members_model.dart';
import '../../models/pagination_request_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../view_models/app_states.dart';
import '../../view_models/members/absent_members_view_model.dart';
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
  }

  callViewModels() {
    absentMembersViewModel.absentMembersPagingController
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
              absentMembersViewModel.absentMembersPagingController.appendPage(
                members.data ?? [],
                members.pagination?.nextPage,
              );
            } else if (state != const LoadingState()) {
              errorHandler(
                context: context,
                state: state,
              );
            }
          },
        )
      ],
      child: PagedListView.separated(
        pagingController: absentMembersViewModel.absentMembersPagingController,
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 20.w,
        ),
        builderDelegate: PagedChildBuilderDelegate<AbsentMember>(
          noItemsFoundIndicatorBuilder: (context) => const NoDataWidget(),
          firstPageErrorIndicatorBuilder: (context) => const ErrorStateWidget(),
          itemBuilder: (context, absentMember, index) =>
              memberWidget(absentMember: absentMember),
        ),
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          height: 8.h,
        ),
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
    if (absentMember.confirmedAt != null) return Colors.green;
    if (absentMember.rejectedAt != null) return Colors.red;
    return Colors.orange;
  }
}
