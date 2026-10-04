import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/masir_html.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/data/models/request_teacher_id_model.dart';
import '/features/teacher/presentation/bloc/teacher_detail/teacher_detail_bloc.dart';
import '/features/teacher/presentation/widgets/teacher_avatar.dart';
import '/core/theme/institute_presets.dart';
import '/widgets/brand_media.dart';
import '/widgets/custom_text.dart';
import '/widgets/list_row.dart';
import '/widgets/masir_page.dart';
import '/widgets/section_header.dart';
import '/widgets/state_view.dart';
import '/core/theme/masir_style.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  final bloc = inject<TeacherDetailBloc>();
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final userId = GoRouterState.of(context).pathParameters['userId'] ?? '';
    bloc.add(
      TeacherDetailEvent.load(params: RequestTeacherIdModel(userId: userId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasirPage.detail(
      title: 'استاد',
      body: BlocBuilder<TeacherDetailBloc, TeacherDetailState>(
        bloc: bloc,
        builder: (context, state) {
          return state.when(
            loading: (_) =>
                const StateView.loading(variant: SkeletonVariant.detail),
            error: (_, message) => StateView.error(message: message),
            success: (_, data) {
              final c = context.colors;
              return ListView(
                padding: const EdgeInsets.only(
                  top: MasirSpace.lg,
                  bottom: MasirSpace.xxl,
                ),
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: c.primary, width: 4),
                      ),
                      child: TeacherAvatar(
                        name: data.name ?? '',
                        photoUrl: data.photoUrl,
                        size: 96,
                      ),
                    ),
                  ),
                  const SizedBox(height: MasirSpace.lg),
                  Center(child: CustomText.title(data.name ?? '')),
                  if (data.headline?.isNotEmpty == true) ...[
                    const SizedBox(height: MasirSpace.sm),
                    Center(
                      child: CustomText.body(
                        data.headline!,
                        color: c.inkMuted,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  if (data.bio?.isNotEmpty == true) ...[
                    const SizedBox(height: MasirSpace.section),
                    MasirHtml(data.bio!),
                  ],
                  if (data.links.isNotEmpty) ...[
                    const SizedBox(height: MasirSpace.lg),
                    for (final link in data.links)
                      if (link.url != null && link.url!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: MasirSpace.sm),
                          child: OnClick(
                            onTap: () => launchUrl(Uri.parse(link.url!)),
                            child: CustomText.body(link.url!, color: c.primary),
                          ),
                        ),
                  ],
                  if (data.institutes.isNotEmpty) ...[
                    const SizedBox(height: MasirSpace.section),
                    const SectionHeader('مؤسسه‌ها'),
                    for (final institute in data.institutes)
                      Padding(
                        padding: const EdgeInsets.only(bottom: MasirSpace.md),
                        child: ListRow(
                          leading: InstituteLogo(
                            logoUrl: institute.logoUrl,
                            name: institute.name ?? '',
                            preset: presetFor(null),
                            size: 40,
                            ring: false,
                          ),
                          title: institute.name ?? '',
                          onTap: institute.id == null
                              ? null
                              : () => context.go('/i/${institute.id}/home'),
                        ),
                      ),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}
