import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/github_service.dart';

class ContributorsScreen extends StatefulWidget {
  const ContributorsScreen({super.key});

  @override
  State<ContributorsScreen> createState() => _ContributorsScreenState();
}

class _ContributorsScreenState extends State<ContributorsScreen> {
  final GitHubService _gitHubService = GitHubService();
  late Future<List<Contributor>> _contributorsFuture;

  @override
  void initState() {
    super.initState();
    _contributorsFuture = _gitHubService.fetchContributors();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contributors'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: FutureBuilder<List<Contributor>>(
        future: _contributorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off, size: 48, color: colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      'Could not load contributors.\nPlease check your internet connection.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _contributorsFuture =
                              _gitHubService.fetchContributors();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final contributors = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: contributors.length,
            itemBuilder: (context, index) {
              final contributor = contributors[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(contributor.avatarUrl),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                ),
                title: Text(
                  contributor.login,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  '${contributor.contributions} contribution${contributor.contributions == 1 ? '' : 's'}',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                trailing: Icon(
                  Icons.open_in_new,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  launchUrl(
                    Uri.parse(contributor.profileUrl),
                    mode: LaunchMode.externalApplication,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
