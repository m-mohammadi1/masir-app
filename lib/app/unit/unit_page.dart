import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/common/stub.dart';

Page<void> unitPage(GoRouterState state, String id) => MaterialPage(key: state.pageKey, child: const StubPage('Unit'));
