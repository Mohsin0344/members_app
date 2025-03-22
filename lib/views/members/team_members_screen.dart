import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../models/members/members_model.dart';
import '../../models/pagination_request_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../view_models/app_states.dart';
import '../../view_models/members/members_view_model.dart';
import '../widgets/custom_cached_network_image.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/no_data_widget.dart';
import '../widgets/views_error_handler.dart';

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({super.key});

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  late MembersViewModel membersViewModel;
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
    membersViewModel = context.read<MembersViewModel>();
  }

  callViewModels() {
    membersViewModel.membersPagingController.addPageRequestListener((pageKey) {
      paginationRequest.page = pageKey;
      membersViewModel.getTeamMembers(
        paginationRequest: paginationRequest,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MembersViewModel, AppState>(
          listener: (context, state) {
            if (state is SuccessState<MembersModel>) {
              MembersModel members = state.data;
              membersViewModel.membersPagingController.appendPage(
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
      child: PagedGridView<int, Member>(
        pagingController: membersViewModel.membersPagingController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 2.w,
          crossAxisSpacing: 2.h,
          childAspectRatio: 200 / 225,
        ),
        builderDelegate: PagedChildBuilderDelegate<Member>(
          firstPageProgressIndicatorBuilder: (context) => const Center(
            child: LoadingIndicator(
              color: AppColors.primaryColor,
            ),
          ),
          noItemsFoundIndicatorBuilder: (context) => const NoDataWidget(),
          firstPageErrorIndicatorBuilder: (context) => const ErrorStateWidget(),
          itemBuilder: (context, member, index) => memberWidget(member: member),
        ),
      ),
    );
  }

  memberWidget({required Member member}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        border: Border.all(
          color: AppColors.hintTextColor,
          width: 1.0,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomCachedNetworkImage(
            imageUrl: member.image ?? '',
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0.00, -1.00),
                  end: const Alignment(0, 1),
                  colors: [
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.37),
                    Colors.black.withOpacity(0.54),
                    Colors.black.withOpacity(0.81),
                    Colors.black.withOpacity(0.90),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 8.w,
            child: Text(
              member.name ?? '',
              style: AppFonts.bodyFont(
                color: AppColors.secondaryColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
