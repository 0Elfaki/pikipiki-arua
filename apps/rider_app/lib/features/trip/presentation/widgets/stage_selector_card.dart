import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../data/trip_model.dart';

class StageSelectorCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final BodaStage? selectedStage;
  final List<BodaStage> availableStages;
  final ValueChanged<BodaStage> onStageChanged;

  const StageSelectorCard({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.selectedStage,
    required this.availableStages,
    required this.onStageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<BodaStage>(
                    value: selectedStage,
                    isExpanded: true,
                    dropdownColor: AppTheme.surfaceDark,
                    icon: const Icon(Icons.arrow_drop_down, color: AppTheme.textMuted),
                    items: availableStages.map((stage) {
                      return DropdownMenuItem<BodaStage>(
                        value: stage,
                        child: Text(
                          stage.name,
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (stage) {
                      if (stage != null) onStageChanged(stage);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
