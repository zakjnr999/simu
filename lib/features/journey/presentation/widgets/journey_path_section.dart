import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/features/journey/domain/entities/journey_milestone.dart';
import 'package:simu/features/journey/presentation/widgets/journey_milestone_tile.dart';

/// Preview of the user's personalized journey path.
class JourneyPathSection extends StatelessWidget {
  const JourneyPathSection({
    super.key,
    required this.milestones,
    this.onMilestoneTap,
  });

  final List<JourneyMilestone> milestones;
  final void Function(JourneyMilestone milestone)? onMilestoneTap;

  static const double _pathHeight = 236;
  static const List<double> _verticalOffsets = [0, 12, 0, 12];

  static const double _columnGap = 6;

  @override
  Widget build(BuildContext context) {
    final preview = milestones.take(4).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
      child: Column(
        children: [
          Text(
            '✦  Your Simu Journey  ✦',
            textAlign: TextAlign.center,
            style: AppTypography.heading3.copyWith(
              color: const Color(0xFF7551FF),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Complete challenges, earn XP, and become unstoppable.',
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(
              color: const Color(0xFF5A627D),
              fontSize: 12,
              height: 1.3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final count = preview.length;
              final columnWidth = count > 0
                  ? (width - _columnGap * (count - 1)) / count
                  : width;
              final islandCenters = _islandCenters(width, count, columnWidth);

              return SizedBox(
                height: _pathHeight,
                width: width,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomPaint(
                      size: Size(width, _pathHeight),
                      painter: _JourneyPathPainter(
                        islandCenters: islandCenters,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < preview.length; i++) ...[
                          if (i > 0) const SizedBox(width: _columnGap),
                          SizedBox(
                            width: columnWidth,
                            child: JourneyMilestoneTile(
                              index: i + 1,
                              milestone: preview[i],
                              verticalOffset: _verticalOffsets[i],
                              onTap: preview[i].isLocked
                                  ? null
                                  : () => onMilestoneTap?.call(preview[i]),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Offset> _islandCenters(
    double width,
    int count,
    double columnWidth,
  ) {
    if (count == 0) {
      return const [];
    }

    final centers = <Offset>[];

    for (var i = 0; i < count; i++) {
      final x = i * (columnWidth + _columnGap) + columnWidth / 2;
      final y = 42 + _verticalOffsets[i];
      centers.add(Offset(x, y));
    }

    return centers;
  }
}

class _JourneyPathPainter extends CustomPainter {
  const _JourneyPathPainter({required this.islandCenters});

  final List<Offset> islandCenters;

  @override
  void paint(Canvas canvas, Size size) {
    if (islandCenters.length < 2) {
      return;
    }

    final paint = Paint()
      ..color = const Color(0xFF7551FF).withValues(alpha: 0.55)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const dashWidth = 7.0;
    const dashSpace = 5.0;

    for (var i = 0; i < islandCenters.length - 1; i++) {
      _drawDashedLine(
        canvas,
        islandCenters[i],
        islandCenters[i + 1],
        paint,
        dashWidth,
        dashSpace,
      );
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    double dashWidth,
    double dashSpace,
  ) {
    final total = (end - start).distance;
    if (total == 0) {
      return;
    }

    final direction = (end - start) / total;
    var distance = 0.0;

    while (distance < total) {
      final dashEnd = distance + dashWidth;
      final p1 = start + direction * distance;
      final p2 = start + direction * (dashEnd > total ? total : dashEnd);
      canvas.drawLine(p1, p2, paint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _JourneyPathPainter oldDelegate) =>
      oldDelegate.islandCenters != islandCenters;
}
