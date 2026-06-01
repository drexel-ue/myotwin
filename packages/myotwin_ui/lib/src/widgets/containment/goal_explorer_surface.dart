import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:shared_core/shared_core.dart';

/// A full-HUD surface for exploring, filtering, and switching between goals.
class GoalExplorerSurface extends StatefulWidget {
  /// Creates a [GoalExplorerSurface].
  const GoalExplorerSurface({
    super.key,
    required this.goals,
    required this.onGoalSelected,
  });

  /// The list of goals to explore.
  final List<Goal> goals;

  /// Called when a goal is selected from the list.
  final ValueChanged<Goal> onGoalSelected;

  @override
  State<GoalExplorerSurface> createState() => _GoalExplorerSurfaceState();
}

class _GoalExplorerSurfaceState extends State<GoalExplorerSurface> {
  GoalStatus _selectedStatus = GoalStatus.active;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    // Filter and sort the goals
    final filteredGoals = widget.goals.where((goal) {
      final matchesStatus = goal.status == _selectedStatus;
      final matchesSearch = goal.label.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList()..sort((a, b) => (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt));

    return FrostedHUD(
      impactPoint: .zero,
      title: 'GOAL_EXPLORER',
      child: Padding(
        padding: allPadding24,
        child: Column(
          children: [
            // 1. Filter Toggles
            MyoSegmentedButton<GoalStatus>(
              value: _selectedStatus,
              onSelectionChanged: (value) => setState(() => _selectedStatus = value),
              segments: const [
                MyoSegment(value: GoalStatus.active, label: 'ACTIVE'),
                MyoSegment(value: GoalStatus.paused, label: 'PAUSED'),
                MyoSegment(value: GoalStatus.achieved, label: 'ACHIEVED'),
              ],
            ),
            verticalMargin24,

            // 2. Search Field
            MyoTextField(
              hint: 'SEARCH_KNOWLEDGE_GRAPH...',
              autofocus: true,
              prefixIcon: const MyoIcon(intent: 'search', size: 18),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            verticalMargin24,

            // 3. Goal List
            Expanded(
              child: filteredGoals.isEmpty
                  ? Center(
                      child: Text(
                        'NO_MATCHING_NODES',
                        style: theme.caption.copyWith(color: theme.onSurfaceDim),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredGoals.length,
                      separatorBuilder: (_, _) => const MyoDivider(),
                      itemBuilder: (context, index) {
                        final goal = filteredGoals[index];
                        return MyoListTile(
                          title: goal.label,
                          subtitle: 'LAST_MODIFIED: ${goal.updatedAt ?? goal.createdAt}',
                          trailing: const MyoIcon(intent: 'chevron-right', size: 16),
                          onTap: () => widget.onGoalSelected(goal),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
