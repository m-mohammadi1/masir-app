import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/services/service_locator.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/data/models/request_teacher_id_model.dart';
import '/features/teacher/presentation/bloc/teacher_detail/teacher_detail_bloc.dart';
import '/features/teacher/presentation/widgets/teacher_avatar.dart';
import '/widgets/base_screen.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_app_bar.dart';
import '/widgets/custom_error.dart';
import '/widgets/custom_text.dart';
import '/widgets/skeleton.dart';

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
    return BaseScreen(
      body: BlocBuilder<TeacherDetailBloc, TeacherDetailState>(
        bloc: bloc,
        builder: (context, state) {
          return state.when(
            loading: (_) => const SkeletonList(),
            error: (_, message) => Column(
              children: [
                const CustomAppBar(title: 'استاد'),
                Expanded(child: CustomError(message: message)),
              ],
            ),
            success: (_, data) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                children: [
                  const CustomAppBar(title: 'استاد'),
                  16.h,
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.colors.primary,
                          width: 4,
                        ),
                      ),
                      child: TeacherAvatar(
                        name: data.name ?? '',
                        photoUrl: data.photoUrl,
                        size: 96,
                      ),
                    ),
                  ),
                  16.h,
                  Center(
                    child: CustomText(
                      data.name ?? '',
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                  if (data.headline?.isNotEmpty == true) ...[
                    6.h,
                    Center(
                      child: CustomText(
                        data.headline!,
                        color: context.colors.inkMuted,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  if (data.bio?.isNotEmpty == true) ...[
                    20.h,
                    Html(
                      data: data.bio!,
                      style: {
                        'body': Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                          fontSize: FontSize(16),
                          color: context.colors.ink,
                          textAlign: TextAlign.right,
                          direction: TextDirection.rtl,
                        ),
                      },
                    ),
                  ],
                  if (data.links.isNotEmpty) ...[
                    16.h,
                    for (final link in data.links)
                      if (link.url != null && link.url!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: OnClick(
                            onTap: () => launchUrl(Uri.parse(link.url!)),
                            child: CustomText(
                              link.url!,
                              color: context.colors.primary,
                            ),
                          ),
                        ),
                  ],
                  if (data.institutes.isNotEmpty) ...[
                    20.h,
                    const CustomText(
                      'مؤسسات',
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                    12.h,
                    for (final institute in data.institutes)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ChunkyBox(
                          fill: context.colors.surface,
                          edge: context.colors.lip,
                          borderColor: context.colors.border,
                          padding: const EdgeInsets.all(12),
                          onTap: institute.id == null
                              ? null
                              : () => context.go('/i/${institute.id}/home'),
                          child: Row(
                            children: [
                              institute.logoUrl?.isNotEmpty == true
                                  ? ClipOval(
                                      child: Image.network(
                                        institute.logoUrl!,
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 22,
                                      backgroundColor:
                                          context.colors.primarySoft,
                                      child: CustomText(
                                        (institute.name ?? '?')
                                            .characters
                                            .first,
                                        fontWeight: FontWeight.w800,
                                        color: context.colors.primary,
                                      ),
                                    ),
                              12.w,
                              Expanded(
                                child: CustomText(
                                  institute.name ?? '',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                              Icon(
                                Icons.chevron_left_rounded,
                                color: context.colors.locked,
                              ),
                            ],
                          ),
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
