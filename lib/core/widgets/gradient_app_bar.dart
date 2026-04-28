import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom AppBar with gradient effect matching LinkNest logo colors
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    // Gradient Colors matching the logo
    const Color gradientStart = Color(0xFF00D9FF); // Cyan
    const Color gradientEnd = Color(0xFF9D50FF);   // Purple
    const Color backgroundColor = Color(0xFF12183D); // Dark navy background

    // Set status bar colors for iOS and Android
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Container(
      decoration: const BoxDecoration(
        color: backgroundColor,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientStart,
            gradientEnd,
          ],
        ),
      ),
      child: AppBar(
        title: Text(title),
        automaticallyImplyLeading: automaticallyImplyLeading,
        actions: actions,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}