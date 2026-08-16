import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/request_institute_id_model.dart';
import '/features/teacher/presentation/bloc/institute_teachers/institute_teachers_bloc.dart';
import '/features/teacher/presentation/widgets/teacher_avatar.dart';
import '/features/teacher/presentation/widgets/teacher_sheet.dart';
import '/widgets/custom_error.dart';
import '/widgets/custom_text.dart';
import '/widgets/empty_widget.dart';
import '/widgets/skeleton.dart';

class InstituteTeachersPage extends StatefulWidget {
  const InstituteTeachersPage({super.key});

  @override
  State<InstituteTeachersPage> createState() => _InstituteTeachersPageState();
}

class _InstituteTeachersPageState extends State<InstituteTeachersPage> {
  final bloc = inject<InstituteTeachersBloc>();
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final id = GoRouterState.of(context).pathParameters['instituteId'] ?? '';
    bloc.add(
      InstituteTeachersEvent.load(params: RequestInstituteIdModel(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstituteTeachersBloc, InstituteTeachersState>(
      bloc: bloc,
      builder: (context, state) {
        return state.when(
          loading: (_) => const SkeletonList(),
          error: (_, message) => CustomError(message: message),
          success: (_, data) {
            if (data.isEmpty) {
              return const EmptyWidget(
                text: 'استادی یافت نشد',
                description: 'هنوز استادی به این مؤسسه اضافه نشده است.',
                icon: Icons.school_outlined,
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.86,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final teacher = data[index];
                return OnClick(
                  onTap: () => showInstituteTeacherSheet(
                    context: context,
                    teacher: teacher,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TeacherAvatar(
                          name: teacher.name ?? '',
                          photoUrl: teacher.photoUrl,
                          size: 72,
                        ),
                        12.h,
                        CustomText(
                          teacher.name ?? '',
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                        6.h,
                        CustomText(
                          teacher.headline ?? '',
                          fontSize: 12,
                          color: context.colors.inkMuted,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
