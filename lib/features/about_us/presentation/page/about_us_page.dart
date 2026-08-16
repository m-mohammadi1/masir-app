import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/about_us/presentation/bloc/about_us_bloc.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import '/widgets/custom_error.dart';

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
    return BaseScreen(
      body: Column(
        children: [
          CustomAppBar(title: "درباره ما"),
          20.h,
          Expanded(
            child: BlocBuilder<AboutUsBloc, AboutUsState>(
              bloc: bloc,
              builder: (context, state) {
                return state.when(
                  loading: (_) => CustomLoading(),
                  error: (_, message) => CustomError(message: message),
                  success: (isLoading, data) {
                    return Html(data: data.id);
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
