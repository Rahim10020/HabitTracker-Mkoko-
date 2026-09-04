import 'package:flutter/material.dart';

const _weekdayLabels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

class WeekdaySelector extends StatelessWidget {
  final Set<int> selectedDays;
  final ValueChanged<Set<int>> onChanged;

  const WeekdaySelector({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final weekday = index + 1;
        final selected = selectedDays.contains(weekday);
        return GestureDetector(
          onTap: () {
            final next = Set<int>.from(selectedDays);
            selected ? next.remove(weekday) : next.add(weekday);
            onChanged(next);
          },
          child: AnimatedScale(
            scale: selected ? 1.08 : 1,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutBack,
            child: CircleAvatar(
              radius: 18,
              backgroundColor:
                  selected ? colorScheme.primary : colorScheme.secondary,
              child: Text(
                _weekdayLabels[index],
                style: TextStyle(
                  color: selected ? Colors.white : colorScheme.onSurface,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
