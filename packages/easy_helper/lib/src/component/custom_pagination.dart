import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'custom_loading.dart';

extension EXCustomPagination on Widget {
  Widget pagination({
    required bool isData,
    required bool loading,
    required RefreshCallback callBack,
    EdgeInsetsGeometry? padding,
  }) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo is ScrollEndNotification) {
          final maxScroll = scrollInfo.metrics.maxScrollExtent;
          final currentScroll = scrollInfo.metrics.pixels;
          if (maxScroll == currentScroll && !loading && isData) {
            callBack();
          }
          return true;
        }
        return false;
      },
      child: Column(
        children: [
          Expanded(child: this),
          Visibility(
            visible: loading,
            child: Padding(
              padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
              child: const CustomLoading(),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPagination extends StatelessWidget {
  final bool pullToRefreshLoading;
  final bool paginationLoading;
  final bool isData;
  final RefreshCallback? pagination;
  final RefreshCallback? pullToRefresh;
  final EdgeInsetsGeometry? paddingUp;
  final EdgeInsetsGeometry? paddingDown;
  final Widget child;
  final bool showUpLoading;
  final bool showDownLoading;

  const CustomPagination({
    super.key,
    required this.child,
    this.isData = false,
    this.pagination,
    this.pullToRefresh,
    this.pullToRefreshLoading = false,
    this.paginationLoading = false,
    this.showUpLoading = true,
    this.showDownLoading = true,
    this.paddingUp,
    this.paddingDown,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo is ScrollEndNotification) {
          final maxScroll = scrollInfo.metrics.maxScrollExtent;
          final minScroll = scrollInfo.metrics.minScrollExtent;
          final currentScroll = scrollInfo.metrics.pixels;
          final scrollDirection = Scrollable.of(scrollInfo.context ?? context)
              .position
              .userScrollDirection;

          if (scrollDirection == ScrollDirection.reverse &&
              maxScroll == currentScroll &&
              !paginationLoading &&
              isData &&
              pagination != null) {
            pagination!();
          } else if (scrollDirection == ScrollDirection.forward &&
              minScroll == currentScroll &&
              !pullToRefreshLoading &&
              isData &&
              pullToRefresh != null) {
            pullToRefresh!();
          }

          return true;
        }
        return false;
      },
      child: Column(
        children: [
          Visibility(
            visible:
                pullToRefreshLoading && showUpLoading && pullToRefresh != null,
            child: Padding(
              padding: paddingUp ?? const EdgeInsets.symmetric(vertical: 12),
              child: const CustomLoading(),
            ),
          ),
          Expanded(child: child),
          Visibility(
            visible: paginationLoading && showDownLoading && pagination != null,
            child: Padding(
              padding: paddingDown ?? const EdgeInsets.symmetric(vertical: 12),
              child: const CustomLoading(),
            ),
          ),
        ],
      ),
    );
  }
}

class SliverPagination extends StatefulWidget {
  final bool isData, loading;
  final RefreshCallback callBack;
  final ScrollController controller;
  final EdgeInsetsGeometry? padding;

  const SliverPagination({
    super.key,
    required this.isData,
    required this.loading,
    required this.callBack,
    required this.controller,
    this.padding,
  });

  @override
  State<SliverPagination> createState() => _SliverPaginationState();
}

class _SliverPaginationState extends State<SliverPagination> {
  @override
  void initState() {
    widget.controller.addListener(() {
      final maxScroll = widget.controller.position.maxScrollExtent;
      final currentScroll = widget.controller.position.pixels;
      if (maxScroll == currentScroll && !widget.loading && widget.isData) {
        widget.callBack();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Visibility(
        visible: widget.loading,
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 12),
          child: const CustomLoading(),
        ),
      ),
    );
  }
}
