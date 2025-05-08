import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? additionalActions;
  final Widget? leading;
  final String? title;
  final bool showLogo;
  final PreferredSizeWidget? bottom;

  const GlobalAppBar({
    super.key,
    this.additionalActions,
    this.leading,
    this.title,
    this.showLogo = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      leading: leading,
      title: showLogo 
        ? const Text(
            'Glint',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
        : title != null 
          ? Text(
              title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      bottom: bottom,
      actions: [
        // Default actions that appear on all pages
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle notifications
          },
        ),
        if (additionalActions != null) ...additionalActions!,
        IconButton(
          icon: const Icon(
            Icons.logout_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle logout
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
} 