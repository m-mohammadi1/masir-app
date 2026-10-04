import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/about_us/presentation/bloc/about_us_bloc.dart';
import '/core/theme/masir_style.dart';
import '/widgets/masir_html.dart';
import '/widgets/masir_page.dart';
import '/widgets/state_view.dart';

class AboutUsPage extends StatefulWidget {
  static const String routeName = "/about-us";

  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final bloc = inject<AboutUsBloc>();

  @override
  void initState() {
    super.initState();
    bloc.add(AboutUsEvent.aboutUs());
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MasirPage.detail(
      title: 'درباره‌ی ما',
      body: BlocBuilder<AboutUsBloc, AboutUsState>(
        bloc: bloc,
        builder: (context, state) {
          return state.when(
            loading: (_) => const StateView.loading(count: 4),
            error: (_, message) => StateView.error(message: message),
            success: (isLoading, data) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: MasirSpace.lg,
                  bottom: MasirSpace.xl,
                ),
                child: MasirHtml(data.id ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
