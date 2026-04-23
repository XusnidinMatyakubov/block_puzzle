import 'package:flutter/material.dart';

import '../app.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.storageService,
    super.key,
  });

  final StorageService storageService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool _soundEnabled;

  @override
  void initState() {
    super.initState();
    _soundEnabled = widget.storageService.getSoundEnabled();
  }

  Future<void> _setSoundEnabled(bool value) async {
    await widget.storageService.setSoundEnabled(value);
    if (!mounted) {
      return;
    }
    setState(() {
      _soundEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bestScore = widget.storageService.getBestScore();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.apps_rounded,
                color: colorScheme.primary,
                size: 84,
              ),
              const SizedBox(height: 20),
              Text(
                'Block Puzzle',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Best score ${AppHelpers.formatScore(bestScore)}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const Spacer(),
              _SettingsTile(
                soundEnabled: _soundEnabled,
                onChanged: _setSoundEnabled,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  await Navigator.of(context).pushNamed(BlockPuzzleApp.gameRoute);
                  if (!mounted) {
                    return;
                  }
                  setState(() {});
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Play'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.soundEnabled,
    required this.onChanged,
  });

  final bool soundEnabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        value: soundEnabled,
        onChanged: onChanged,
        secondary: const Icon(Icons.volume_up_rounded),
        title: const Text('Sound'),
        subtitle: const Text('Local preference'),
      ),
    );
  }
}
