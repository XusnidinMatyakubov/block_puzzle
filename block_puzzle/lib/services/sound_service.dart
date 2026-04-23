class SoundService {
  const SoundService();

  void playPlaceSound({required bool enabled}) {
    if (!enabled) {
      return;
    }
  }

  void playClearSound({required bool enabled}) {
    if (!enabled) {
      return;
    }
  }

  void playGameOverSound({required bool enabled}) {
    if (!enabled) {
      return;
    }
  }
}
