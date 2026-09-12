import 'package:flutter/material.dart';

/// Reusable tactile 3D card surface with bottom depth and warm lighting.
class SimuTactileCard extends StatelessWidget {
  const SimuTactileCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    this.margin = EdgeInsets.zero,
    this.showOuterShadow = true,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool showOuterShadow;
  final VoidCallback? onTap;

  static const double _cardDepthHeight = 5.0;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: _cardDepthHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE2D0B6),
                borderRadius: BorderRadius.circular(20),
                boxShadow: showOuterShadow
                    ? const [
                        BoxShadow(
                          color: Color(0x353E2004),
                          blurRadius: 28,
                          offset: Offset(0, 14),
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: _cardDepthHeight),
            padding: padding,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFBF8F4),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFAF6EE),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    return card;
  }
}
