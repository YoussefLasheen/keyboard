class Settings {
  final double keyWidth;
  final bool sustain;
  final bool hideKeyboardShortcuts;
  final bool hideNoteName;
  Settings({
    this.hideKeyboardShortcuts = false,
    this.hideNoteName = false,
    this.keyWidth = 60,
    this.sustain = false,
  });

  Settings copyWith(
          {double? keyWidth,
          bool? sustain,
          bool? hideKeyboardShortcuts,
          bool? hideNoteName}) =>
      Settings(
        keyWidth: keyWidth ?? this.keyWidth,
        sustain: sustain ?? this.sustain,
        hideKeyboardShortcuts: hideKeyboardShortcuts ?? this.hideKeyboardShortcuts,
        hideNoteName: hideNoteName ?? this.hideNoteName,
      );
}
