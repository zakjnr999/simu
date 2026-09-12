import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_spacing.dart';

/// Base scaffold for Simu screens.
///
/// Ensures consistent light background, safe areas, optional custom app bar,
/// and a pinned bottom action slot.
class SimuScaffold extends StatelessWidget {
  const SimuScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomAction,
    this.bottomActionPadding = AppSpacing.pagePadding,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.backgroundColor = AppColors.background,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomAction;
  final EdgeInsets bottomActionPadding;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final Color backgroundColor;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      body: SafeArea(
        top: safeAreaTop,
        bottom: safeAreaBottom,
        child: Column(
          children: [
            Expanded(child: body),
            if (bottomAction != null)
              Container(
                width: double.infinity,
                padding: bottomActionPadding,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: bottomAction,
              ),
          ],
        ),
      ),
    );
  }
}
