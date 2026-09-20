import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../code_assistant/application/code_assistant_providers.dart';
import '../../code_assistant/domain/assistant_prompt_builder.dart';
import '../../profile/application/profile_controller.dart';
import '../domain/project.dart';
import '../domain/project_feedback_prompt.dart';

/// The pre-publish AI review (US42): a single request/response, not a
/// conversation, so it's simpler than EP06's assistant chat and doesn't
/// need its own persisted history — reuses the same
/// `codeAssistantClientFactoryProvider` (Gemini via Firebase AI Logic).
class ProjectFeedbackState {
  const ProjectFeedbackState({this.isLoading = false, this.feedback, this.hasError = false});

  final bool isLoading;
  final String? feedback;
  final bool hasError;
}

class ProjectFeedbackController extends Notifier<ProjectFeedbackState> {
  @override
  ProjectFeedbackState build() => const ProjectFeedbackState();

  Future<void> analyze(Project project) async {
    state = const ProjectFeedbackState(isLoading: true);
    try {
      final client = ref.read(codeAssistantClientFactoryProvider)(
        systemInstruction: buildSystemInstruction(
          codingLevel: ref.read(currentProfileProvider).valueOrNull?.codingLevel,
        ),
      );
      final feedback = await client.sendMessage(
        buildProjectFeedbackPrompt(language: project.language, code: project.code),
      );
      state = ProjectFeedbackState(feedback: feedback);
    } catch (_) {
      state = const ProjectFeedbackState(hasError: true);
    }
  }

  void reset() => state = const ProjectFeedbackState();
}

final projectFeedbackControllerProvider =
    NotifierProvider<ProjectFeedbackController, ProjectFeedbackState>(ProjectFeedbackController.new);
