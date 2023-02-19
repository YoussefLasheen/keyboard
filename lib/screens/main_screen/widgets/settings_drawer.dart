import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:keyboard/settings.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class SettingsDrawer extends StatelessWidget {
  final Settings settings;
  final ValueChanged<Settings> onSettingsChanged;
  const SettingsDrawer(
      {super.key, required this.settings, required this.onSettingsChanged});

  @override
  Widget build(BuildContext context) {
    bool isNotLinux = Theme.of(context).platform != TargetPlatform.linux;
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          children: [
            SizedBox(height: 35),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Keyboard',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            SizedBox(height: 35),
            YaruSection(
              headline: Text('Settings'),
              child: Column(
                children: [
                  YaruTile(
                    title: const Text('Key Width'),
                    trailing: SizedBox(
                      width: 150,
                      child: SpinBox(
                        min: 50,
                        max: 150,
                        step: 10,
                        value: settings.keyWidth,
                        onChanged: (value) {
                          onSettingsChanged(settings.copyWith(keyWidth: value));
                        },
                      ),
                    ),
                  ),
                  YaruSwitchListTile(
                    title: const Text('Sustain'),
                    value: settings.sustain,
                    onChanged: (value) {
                      onSettingsChanged(settings.copyWith(sustain: value));
                    },
                  ),
                  if(!isNotLinux)
                  YaruSwitchListTile(
                    title: const Text('Hide Keyboard shortcuts'),
                    value: settings.hideKeyboardShortcuts,
                    onChanged: (value) {
                      onSettingsChanged(settings.copyWith(hideKeyboardShortcuts: value));
                    },
                  ),
                  YaruSwitchListTile(
                    title: const Text('Hide Note name'),
                    value: settings.hideNoteName,
                    onChanged: (value) {
                      onSettingsChanged(settings.copyWith(hideNoteName: value));
                    },
                  ),
                ],
              ),
            ),
            Spacer(), 
            SizedBox(
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Made with ❤️ by '),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/lasheenlogo.png',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
