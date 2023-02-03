class Settings {
  final double keyWidth;
  final bool sustain;
  Settings({
    this.keyWidth = 60,
    this.sustain = false,
  });

  Settings copyWith({double? keyWidth, bool? sustain}) => Settings(
        keyWidth: keyWidth ?? this.keyWidth,
        sustain: sustain ?? this.sustain,
      );
}
