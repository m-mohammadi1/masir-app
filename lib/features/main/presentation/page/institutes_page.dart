import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/request_institutes_model.dart';
import 'package:mohammad/features/main/presentation/bloc/institutes/institutes_bloc.dart';
import 'package:mohammad/features/discovery/presentation/bloc/topics/topics_bloc.dart';
import 'package:mohammad/features/discovery/presentation/widgets/topic_chip_row.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '../../data/models/institutes_model.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_error.dart';
import '/widgets/empty_widget.dart';
import '/widgets/skeleton.dart';

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
    bloc.add(InstitutesEvent.institutes(
      params: RequestInstitutesModel(topic: _topic),
    ));
  }

  void _openInstitute(InstitutesModel institute) {
    final id = institute.id ?? '';
    if (id.isEmpty) return;
    CustomNavigator.pushNamed('/i/$id/home');
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(title: "مؤسسه‌ها"),
          8.h,
          const CustomText("مؤسسه‌ای را انتخاب کنید و وارد دنیای آن شوید"),
          12.h,
          TopicChipRow(
            bloc: topicsBloc,
            selectedSlug: _topic,
            onSelected: (slug) {
              setState(() => _topic = slug);
              _load();
            },
          ),
          12.h,
          Expanded(
            child: BlocBuilder<InstitutesBloc, InstitutesState>(
              bloc: bloc,
              builder: (context, state) {
                return state.when(
                  loading: (_) => const SkeletonList(),
                  error: (_, message) => CustomError(
                    message: message,
                    retry: () => _load(),
                  ),
                  success: (_, data) {
                    if (data.isEmpty) {
                      return const EmptyWidget(
                        text: 'مؤسسه‌ای یافت نشد',
                        description: 'در حال حاضر مؤسسه‌ای برای نمایش نیست.',
                        icon: Icons.school_outlined,
                      );
                    }
                    return ListView.separated(
                      itemCount: data.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      separatorBuilder: (_, _) => 12.h,
                      itemBuilder: (context, index) {
                        final institute = data[index];
                        return OnClick(
                          onTap: () => _openInstitute(institute),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.colors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: context.colors.border),
                            ),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    color: context.colors.borderF9,
                                    child:
                                        institute.logoUrl != null &&
                                            institute.logoUrl!.isNotEmpty
                                        ? Image.network(
                                            institute.logoUrl!,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.school,
                                            color: context.colors.inkMuted,
                                          ),
                                  ),
                                ),
                                12.w,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        institute.name ?? '',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      if (institute.topic?.name != null)
                                        CustomText(
                                          institute.topic!.name!,
                                          fontSize: 12,
                                          color: context.colors.inkMuted,
                                        ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_left),
                              ],
                            ),
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
