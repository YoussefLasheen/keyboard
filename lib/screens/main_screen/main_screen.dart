import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gtk_window/gtk_window.dart';
import 'package:keyboard/constants.dart';
import 'package:keyboard/screens/main_screen/widgets/settings_drawer.dart';
import 'package:keyboard/settings.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:piano/piano.dart';
import 'package:segment_display/segment_display.dart';
import 'package:wheel_spinner/utils.dart';
import 'package:wheel_spinner/wheel_spinner.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const String _defaultScreenText = "Hi";
  void _loadSounds() {
    FlameAudio.audioCache.loadAll(Constants.audioAssets);
  }

  @override
  void initState() {
    super.initState();
    _loadSounds();
    _setScreenText(text: _defaultScreenText);
  }

  void _setScreenText({required String text, int? repeats}) async {
    int repeatCount = repeats ?? 1;
    if (repeatCount > 1) {
      while (true) {
        String remainingText = text;
        for (int i = 0; i < text.length; i++) {
          setState(() {
            String newText = remainingText.substring(
                0, clamp(remainingText.length, 0, 4).toInt());
            _screenText = newText.padRight(4, " ");
          });
          remainingText = remainingText.substring(1);
          await Future.delayed(const Duration(milliseconds: 250));
        }
        repeatCount--;
      }
    }else{
      setState(() {
        _screenText = text.padRight(4, " ");
      });
    }
  }

  Settings _settings = Settings();
  String _screenText = "";
  @override
  Widget build(BuildContext context) {
    KnobStyle knobStyle = const KnobStyle(
      minorTicksPerInterval: 5,
      pointerStyle: PointerStyle(
        offset: 4,
        color: Colors.black12,
      ),
      tickOffset: 5,
      labelOffset: 5,
      majorTickStyle:
          MajorTickStyle(color: Colors.grey, highlightColor: Colors.black),
      minorTickStyle:
          MinorTickStyle(color: Colors.grey, highlightColor: Colors.black),
    );
    bool isNotLinux = Theme.of(context).platform != TargetPlatform.linux;
    return Scaffold(
      appBar: isNotLinux
          ? AppBar() as PreferredSizeWidget?
          : GTKHeaderBar(
              leading: [
                Builder(builder: (context) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.white12,
                          ),
                          child: const Icon(Icons.menu, size: 20),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
      drawer: SettingsDrawer(
        settings: _settings,
        onSettingsChanged: (Settings value) {
          setState(() {
            _settings = value;
          });
        },
      ),
      body: Stack(
        children: [
          NeumorphicBackground(),
          Positioned.fill(
            child: Opacity(
                opacity: 0.05,
                child: Image.asset(
                  "assets/textures/noise-300x300.png",
                  fit: BoxFit.scaleDown,
                  repeat: ImageRepeat.repeat,
                )),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  const SizedBox(height: 8),
                  if(constraints.maxHeight > 800 && constraints.maxWidth > 800)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Spacer(),
                        Knob(
                          style: knobStyle,
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Center(
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  depth: -25,
                                  intensity: 1,
                                  surfaceIntensity: 1,
                                  boxShape: NeumorphicBoxShape.rect(),
                                ),
                                child: SixteenSegmentDisplay(
                                  value: _screenText,
                                  segmentStyle: DefaultSegmentStyle(
                                      enabledColor: Colors.blue,
                                      disabledColor: Colors.white12),
                                  characterCount: 4,
                                  size: 6.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const NeuomorphicSlider(),
                                _buildSpacer(),
                                const NeuomorphicSlider(),
                                _buildSpacer(),
                                const NeuomorphicSlider(),
                                _buildSpacer(),
                                const NeuomorphicSlider(),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Knob(
                          style: knobStyle,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: InteractivePiano(
                      naturalColor: Colors.white,
                      accidentalColor: Colors.black,
                      keyWidth: _settings.keyWidth,
                      hideScrollbar: true,
                      noteRange: NoteRange.forClefs([
                        Clef.Treble,
                        Clef.Alto,
                        Clef.Bass,
                      ]),
                      hideNoteNames: _settings.hideNoteName,
                      hideNoteKeyboardkey: _settings.hideKeyboardShortcuts || isNotLinux,
                      animateHighlightedNotes: false,
                      onNotePositionTapped: (position) async {
                        String name = '';
                        if (position.startsWith('C') || position.startsWith('F')) {
                          name = position.replaceFirst('♯', '');
                        } else {
                          name = position.replaceFirst('♯', 'b');
                        }
          
                        FlameAudio.play('$name.mp3');
                      },
                    ),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }

  SizedBox _buildSpacer({double space = 24}) => SizedBox(width: space);
}

class NeuomorphicSlider extends StatefulWidget {
  final double step;
  const NeuomorphicSlider({
    super.key,
    this.step = 0.1,
  });

  @override
  State<NeuomorphicSlider> createState() => _NeuomorphicSliderState();
}

class _NeuomorphicSliderState extends State<NeuomorphicSlider> {
  double _value = 0.5;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      width: 25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            child: Neumorphic(
              style: const NeumorphicStyle(
                depth: 5,
                shape: NeumorphicShape.convex,
                surfaceIntensity: 0.5,
                lightSource: LightSource.top,
              ),
              child: WheelSpinner(
                value: _value / widget.step,
                max: 1 / widget.step,
                min: 0,
                onSlideUpdate: (value) =>
                    setState(() => _value = value * widget.step),
                theme: WheelSpinnerThemeData.light().copyWith(
                    color: Colors.transparent,
                    dividerColor: Colors.white54,
                    border: Border.all(color: Colors.transparent)),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 250,
            child: RotatedBox(
              quarterTurns: -1,
              child: NeumorphicProgress(
                percent: _value,
                height: 25,
                style: ProgressStyle(
                  depth: -5,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
