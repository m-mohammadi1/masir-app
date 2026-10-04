import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/request_institutes_model.dart';
import 'package:mohammad/features/main/presentation/bloc/institutes/institutes_bloc.dart';
import 'package:mohammad/features/discovery/presentation/bloc/topics/topics_bloc.dart';
import 'package:mohammad/features/discovery/presentation/widgets/topic_chip_row.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '../../data/models/institutes_model.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/core/theme/institute_presets.dart';
import '/widgets/brand_media.dart';
import '/widgets/chunky_box.dart';
import '/widgets/pill_chip.dart';
import '/widgets/masir_page.dart';
import '/widgets/state_view.dart';

class InstitutesPage extends StatefulWidget {
  static const String routeName = "/institutes";
  const InstitutesPage({super.key});

  @override
  State<InstitutesPage> createState() => _InstitutesPageState();
}

class _InstitutesPageState extends State<InstitutesPage> {
  final bloc = inject<InstitutesBloc>();
  final topicsBloc = inject<TopicsBloc>();
  String? _topic;

  @override
  void initState() {
    super.initState();
    topicsBloc.add(const TopicsEvent.load());
    bloc.add(const InstitutesEvent.institutes());
  }

  void _load() {
    bloc.add(
      InstitutesEvent.institutes(params: RequestInstitutesModel(topic: _topic)),
    );
  }

  void _openInstitute(InstitutesModel institute) {
    final id = institute.id ?? '';
    if (id.isEmpty) return;
    CustomNavigator.pushNamed('/i/$id/home');
  }

  @override
  Widget build(BuildContext context) {
    return MasirPage.detail(
      title: 'مؤسسه‌ها',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.caption(
            'یک مؤسسه انتخاب کن و وارد دنیایش شو',
            color: context.colors.inkMuted,
          ),
          const SizedBox(height: MasirSpace.md),
          TopicChipRow(
            bloc: topicsBloc,
            selectedSlug: _topic,
            onSelected: (slug) {
              setState(() => _topic = slug);
              _load();
            },
          ),
          const SizedBox(height: MasirSpace.md),
          Expanded(
            child: BlocBuilder<InstitutesBloc, InstitutesState>(
              bloc: bloc,
              builder: (context, state) {
                return state.when(
                  loading: (_) => const StateView.loading(),
                  error: (_, message) =>
                      StateView.error(message: message, retry: _load),
                  success: (_, data) {
                    if (data.isEmpty) {
                      return const StateView.empty(
                        text: 'مؤسسه‌ای پیدا نکردیم',
                        description: 'فعلاً مؤسسه‌ای اینجا نیست، به‌زودی پر می‌شه.',
                        icon: Icons.school_rounded,
                      );
                    }
                    return ListView.separated(
                      itemCount: data.length,
                      padding: const EdgeInsets.only(bottom: MasirSpace.xl),
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: MasirSpace.md),
                      itemBuilder: (context, index) {
                        final institute = data[index];
                        final preset = presetFor(institute.themePreset);
                        return ChunkyBox(
                          fill: context.colors.surface,
                          edge: preset.edge,
                          borderColor: preset.primary,
                          padding: const EdgeInsets.all(MasirSpace.card),
                          onTap: () => _openInstitute(institute),
                          child: Row(
                            children: [
                              InstituteLogo(
                                logoUrl: institute.logoUrl,
                                name: institute.name ?? '',
                                preset: preset,
                                size: 56,
                                ring: false,
                              ),
                              const SizedBox(width: MasirSpace.lg),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText.headline(
                                      institute.name ?? '',
                                      maxLines: 1,
                                    ),
                                    if (institute.topic?.name != null) ...[
                                      const SizedBox(height: MasirSpace.sm),
                                      PillChip(
                                        institute.topic!.name!,
                                        color: preset.primary,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_left_rounded,
                                color: context.colors.locked,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
