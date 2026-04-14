import 'package:flutter/material.dart';

class KoanFab extends StatelessWidget {
  final VoidCallback onShareClick;
  final VoidCallback onAboutClick;

  const KoanFab({
    super.key,
    required this.onShareClick,
    required this.onAboutClick,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onShareClick();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onAboutClick();
                  },
                ),
              ],
            ),
          ),
        );
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 8,
      child: const Icon(Icons.more_vert),
    );
  }
}
