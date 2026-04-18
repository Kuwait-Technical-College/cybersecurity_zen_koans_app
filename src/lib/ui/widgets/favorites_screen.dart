import 'package:flutter/material.dart';

import '../../data/favorites_repository.dart';
import '../../data/koan_model.dart';
import '../../data/koans_repository.dart';
import '../theme/colors.dart';

class FavoritesScreen extends StatefulWidget {
  final KoansRepository koansRepository;
  final FavoritesRepository favoritesRepository;

  const FavoritesScreen({
    super.key,
    required this.koansRepository,
    required this.favoritesRepository,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<KoanWithExplanation> _favoriteKoans;

  @override
  void initState() {
    super.initState();
    _favoriteKoans = [];
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final codes = await widget.favoritesRepository.loadFavorites();
    setState(() {
      _favoriteKoans = codes
          .map((code) => widget.koansRepository.getKoanByCode(code))
          .whereType<KoanWithExplanation>()
          .toList();
    });
  }

  Future<void> _removeFavorite(String code) async {
    await widget.favoritesRepository.toggleFavorite(code);
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: _favoriteKoans.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border,
                      size: 64, color: colorScheme.outlineVariant),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet.',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart on any koan to save it here.',
                    style: TextStyle(
                      color: colorScheme.outlineVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _favoriteKoans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final koan = _favoriteKoans[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                koan.koanText,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 15,
                                  height: 1.5,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite,
                                  color: Colors.redAccent),
                              tooltip: 'Remove from favorites',
                              onPressed: () => _removeFavorite(koan.uniqueCode),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(
                          koan.technicalExplanation,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '#${koan.uniqueCode}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: zenGold,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
