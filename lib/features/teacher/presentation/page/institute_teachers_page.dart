import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/institute/data/models/request_institute_id_model.dart';
import '/features/teacher/presentation/bloc/institute_teachers/institute_teachers_bloc.dart';
import '/features/teacher/presentation/widgets/teacher_avatar.dart';
import '/features/teacher/presentation/widgets/teacher_sheet.dart';
import '/widgets/chunky_box.dart';
import '/core/theme/masir_style.dart';
import '/widgets/custom_text.dart';
import '/widgets/masir_page.dart';
import '/widgets/state_view.dart';

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
          loading: (_) => const MasirPage.tab(
            title: 'استادها',
            children: [StateView.loading(variant: SkeletonVariant.grid)],
          ),
          error: (_, message) => MasirPage.tab(
            title: 'استادها',
            body: StateView.error(message: message),
          ),
          success: (_, data) {
            if (data.isEmpty) {
              return const MasirPage.tab(
                title: 'استادها',
                body: StateView.empty(
                  text: 'استادی پیدا نشد',
                  description: 'هنوز استادی به این مؤسسه اضافه نشده.',
                  icon: Icons.school_rounded,
                ),
              );
            }
            return MasirPage.tab(
              title: 'استادها',
              body: GridView.builder(
                padding: const EdgeInsets.only(
                  top: MasirSpace.sm,
                  bottom: MasirSpace.xl,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: MasirSpace.md,
                  crossAxisSpacing: MasirSpace.md,
                  childAspectRatio: 0.8,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final teacher = data[index];
                  final c = context.colors;
                  return ChunkyBox(
                    fill: c.surface,
                    edge: c.lip,
                    borderColor: c.border,
                    padding: const EdgeInsets.all(MasirSpace.card),
                    onTap: () => showInstituteTeacherSheet(
                      context: context,
                      teacher: teacher,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: c.primary, width: 3),
                          ),
                          child: TeacherAvatar(
                            name: teacher.name ?? '',
                            photoUrl: teacher.photoUrl,
                            size: 72,
                          ),
                        ),
                        const SizedBox(height: MasirSpace.md),
                        CustomText.bodyStrong(
                          teacher.name ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                        const SizedBox(height: MasirSpace.xs),
                        CustomText.caption(
                          teacher.headline ?? '',
                          color: c.inkMuted,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
