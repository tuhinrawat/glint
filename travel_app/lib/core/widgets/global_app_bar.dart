import 'package:flutter/material.dart';
import '../../features/gang_hangout/gang_hangout_page.dart';
import '../../models/itinerary.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? additionalActions;
  final Widget? leading;
  final String? title;
  final bool showLogo;
  final PreferredSizeWidget? bottom;
  final Itinerary? activeTrip;
  final VoidCallback? onLogout;

  const GlobalAppBar({
    super.key,
    this.additionalActions,
    this.leading,
    this.title,
    this.showLogo = true,
    this.bottom,
    this.activeTrip,
    this.onLogout,
  });

  void _openGangHangout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GangHangoutPage(activeTrip: activeTrip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      leading: leading,
      title: showLogo 
        ? Text(
            'Glint',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          )
        : title != null 
          ? Text(
              title!,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            )
          : null,
      bottom: bottom,
      actions: [
        // Gang Hangout
        IconButton(
          icon: Icon(
            Icons.groups_outlined,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => _openGangHangout(context),
          tooltip: 'Gang Hangout',
        ),
        // Notifications
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () {
            // TODO: Show notifications panel
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Notifications coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          tooltip: 'Notifications',
        ),
        if (additionalActions != null) ...additionalActions!,
        // Logout
        IconButton(
          icon: Icon(
            Icons.logout_rounded,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: onLogout ?? () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Logout'),
                content: Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement actual logout
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logout functionality coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text('Logout'),
                  ),
                ],
              ),
            );
          },
          tooltip: 'Logout',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
} 