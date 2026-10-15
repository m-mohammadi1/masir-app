import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/api/masir_api.dart';
import '/design/design.dart';

/// Data being loaded for a screen or a section. Keeps the last good data
/// while reloading so pull-to-refresh never blanks the screen.
@immutable
class Load<D> {
  final D? data;
  final ApiError? error;
  final bool loading;

  const Load({this.data, this.error, this.loading = false});

  bool get hasData => data != null;
}

/// Loads one value with [fetch]; screens provide it with BlocProvider so it
/// is closed with the page.
class LoadCubit<D> extends Cubit<Load<D>> {
  final Future<Res<D>> Function() fetch;

  LoadCubit(this.fetch) : super(Load<D>(loading: true));

  Future<void> load() async {
    if (isClosed) return;
    emit(Load<D>(data: state.data, loading: true));
    final res = await fetch();
    if (isClosed) return;
    res.fold(
      (e) => emit(Load<D>(data: state.data, error: e)),
      (d) => emit(Load<D>(data: d)),
    );
  }

  void set(D data) {
    if (!isClosed) emit(Load<D>(data: data));
  }
}

/// Renders a [LoadCubit]: skeleton first, inline error with retry, then data.
class LoadView<D> extends StatelessWidget {
  final Widget Function(BuildContext context, D data) builder;
  final Widget? skeleton;
  final String errorTitle;

  const LoadView({super.key, required this.builder, this.skeleton, this.errorTitle = 'بارگذاری نشد'});

  @override
  Widget build(BuildContext context) => BlocBuilder<LoadCubit<D>, Load<D>>(
    builder: (context, s) {
      if (s.data != null) return builder(context, s.data as D);
      if (s.error != null) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: InlineError(
            title: s.error!.offline ? 'به سرور وصل نشدیم' : errorTitle,
            body: s.error!.offline ? 'اینترنتت رو یه نگاه بنداز.' : s.error!.friendly,
            onRetry: () => context.read<LoadCubit<D>>().load(),
          ),
        );
      }
      return skeleton ?? const ListSkeleton();
    },
  );
}

/// Default skeleton: a few card-shaped bones.
class ListSkeleton extends StatelessWidget {
  final int count;
  const ListSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(children: [
      for (var i = 0; i < count; i++) ...[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: cardDecoration(lipHeight: 0),
          child: Row(children: [
            const Bone(width: 52, height: 52, radius: 16),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Bone(width: 160, height: 14),
              SizedBox(height: 10),
              Bone(width: 110, height: 12),
            ])),
          ]),
        ),
        const SizedBox(height: 12),
      ],
    ]),
  );
}
