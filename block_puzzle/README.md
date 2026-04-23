# Block Puzzle

A Flutter Android-first scaffold for a classic block placement puzzle game.

This project includes the Flutter Android structure, Material 3 theme,
navigation, local persistence, core models, game services, and complete
offline block placement gameplay.

## Structure

- `lib/models`: immutable data models for board cells, pieces, positions, and game state.
- `lib/game`: board manager, piece generator, controller, and shape definitions.
- `lib/screens`: splash, home, and game screens.
- `lib/widgets`: reusable game board, piece preview, score, controls, and dialog widgets.
- `lib/services`: local persistence through `shared_preferences`.
- `lib/theme`: Material 3 theme setup.
- `lib/utils`: app constants and small helpers.

## Run

Open the `block_puzzle` folder in Android Studio, let Flutter fetch packages,
then run on an Android emulator or device.

```bash
flutter pub get
flutter run
```

## Gameplay

- Drag pieces from the hand to the 8x8 board.
- Pieces can be placed only inside the board and on empty cells.
- Full rows and columns clear together.
- Multiple simultaneous line clears award a combo bonus.
- Best score and sound preference are saved locally.
