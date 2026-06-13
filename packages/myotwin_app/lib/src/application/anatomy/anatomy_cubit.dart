import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/shared_core.dart';

/// The state of the anatomical 3D visualization.
class AnatomyState {
  /// Creates an [AnatomyState].
  const AnatomyState({
    this.activeLayer,
    this.activeNodes = const [],
    this.availableNodes = const {},
  });

  /// The currently isolated anatomical layer.
  final AnatomyLayer? activeLayer;

  /// The list of anatomical nodes currently highlighted.
  final List<String> activeNodes;

  /// A mapping of available node names by layer, loaded from the 3D model.
  final Map<AnatomyLayer, List<String>> availableNodes;

  /// Creates a copy of this state with the given fields replaced.
  AnatomyState copyWith({
    AnatomyLayer? activeLayer,
    bool clearActiveLayer = false,
    List<String>? activeNodes,
    Map<AnatomyLayer, List<String>>? availableNodes,
  }) {
    return AnatomyState(
      activeLayer: clearActiveLayer ? null : (activeLayer ?? this.activeLayer),
      activeNodes: activeNodes ?? this.activeNodes,
      availableNodes: availableNodes ?? this.availableNodes,
    );
  }
}

/// Manages the state of the 3D anatomy visualization, including layer isolation
/// and node highlighting.
class AnatomyCubit extends Cubit<AnatomyState> {
  /// Creates an [AnatomyCubit].
  AnatomyCubit() : super(const AnatomyState());

  /// Updates the currently isolated anatomical layer.
  void setLayer(AnatomyLayer? layer) {
    if (layer == state.activeLayer) return;
    emit(state.copyWith(activeLayer: layer, clearActiveLayer: layer == null));
  }

  /// Sets the list of highlighted anatomical nodes.
  void setHighlights(List<String> nodes) {
    emit(state.copyWith(activeNodes: nodes));
  }

  /// Toggles a specific anatomical node highlight.
  void toggleNode(String node) {
    final nodes = List<String>.from(state.activeNodes);
    if (nodes.contains(node)) {
      nodes.remove(node);
    } else {
      nodes.add(node);
    }
    emit(state.copyWith(activeNodes: nodes));
  }

  /// Clears all node highlights.
  void clearHighlights() {
    emit(state.copyWith(activeNodes: []));
  }

  /// Updates the mapping of available nodes loaded from the model.
  void setAvailableNodes(Map<AnatomyLayer, List<String>> nodes) {
    emit(state.copyWith(availableNodes: nodes));
  }
}
