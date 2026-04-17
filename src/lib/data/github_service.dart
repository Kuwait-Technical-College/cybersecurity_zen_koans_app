import 'dart:convert';
import 'package:http/http.dart' as http;

class Contributor {
  final String login;
  final String avatarUrl;
  final String profileUrl;
  final int contributions;

  Contributor({
    required this.login,
    required this.avatarUrl,
    required this.profileUrl,
    required this.contributions,
  });

  factory Contributor.fromJson(Map<String, dynamic> json) {
    return Contributor(
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
      profileUrl: json['html_url'] as String,
      contributions: json['contributions'] as int,
    );
  }
}

class GitHubService {
  static const String _repoOwner = 'kuwaitdevs';
  static const String _repoName = 'cybersecurity_zen_koans_app';

  Future<List<Contributor>> fetchContributors() async {
    final url = Uri.parse(
      'https://api.github.com/repos/$_repoOwner/$_repoName/contributors',
    );

    final response = await http.get(url, headers: {
      'Accept': 'application/vnd.github.v3+json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .where((c) => c['type'] == 'User')
          .map((c) => Contributor.fromJson(c as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load contributors: ${response.statusCode}');
    }
  }
}
