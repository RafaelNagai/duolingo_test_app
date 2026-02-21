import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:duolingo_test_app/features/image_description/domain/entities/evaluation_result.dart';
import 'package:duolingo_test_app/features/image_description/presentation/image_exam_page.dart';
import 'package:duolingo_test_app/features/image_description/presentation/pages/results_page.dart';

final appRouterProvider = Provider<GoRouter>((_) {
  return GoRouter(
    initialLocation: '/exam',
    routes: [
      GoRoute(
        path: '/exam',
        builder: (context, state) => const ImageExamPage(),
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) {
          final result = state.extra as EvaluationResult;
          return ResultsPage(result: result);
        },
      ),
    ],
  );
});
