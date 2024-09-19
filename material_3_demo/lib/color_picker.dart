import 'package:flutter/material.dart';
import 'package:material_3_demo/extensions.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import 'gradient_slider.dart';
import 'hex_color_textfield.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    required this.color,
    required this.onChanged,
  });

  final Color color;
  final ValueChanged<Color> onChanged;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  double hue = 0;
  double chroma = 0;
  double tone = 0;
  String hex = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hct = Hct.fromInt(widget.color.value);

      if (mounted) {
        setState(() {
          hue = hct.hue;
          chroma = hct.chroma;
          tone = hct.tone;
          hex = StringUtils.hexFromArgb(widget.color.value);
          print("colorpicker on change");
          print(hex);
          print(widget.color.value);
        });
      }
    });
    super.initState();
  }

  static const double minHue = 0;
  static const double maxHue = 360;
  static const double minChroma = 0;
  static const double maxChroma = 150;
  static const double minTone = 0;
  static const double maxTone = 100;

  void onHctChange() {
    final hct = Hct.from(hue, chroma, tone);
    final color = Color(hct.toInt());
    hex = color.toHex().toUpperCase();
    widget.onChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    // HCT Color picker
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HexColorTextField(
          value: hex,
          onChanged: (String value) {
            if (mounted) {
              setState(() {
                hex = value;
                final color =
                    Color(StringUtils.argbFromHex(hex)!).withAlpha(255);
                final hct = Hct.fromInt(color.value);
                hue = hct.hue;
                chroma = hct.chroma;
                tone = hct.tone;
                onHctChange();
              });
            }
          },
        ),
        const SizedBox(height: 8),
        // Hue
        GradientSlider(
          value: hue,
          minValue: minHue,
          maxValue: maxHue,
          divisions: maxHue.round(),
          label: 'Hue',
          onChanged: (value) {
            if (mounted) {
              setState(() {
                hue = value;
                onHctChange();
              });
            }
          },
          stops: List.generate(
            maxHue.round(),
            (index) => hueColor(index.toDouble()),
          ),
        ),
        const SizedBox(height: 8),
        // Chroma
        GradientSlider(
          value: chroma,
          minValue: minChroma,
          maxValue: maxChroma,
          divisions: maxChroma.round(),
          label: 'Chroma',
          onChanged: (value) {
            if (mounted) {
              setState(() {
                chroma = value;
                onHctChange();
              });
            }
          },
          stops: List.generate(
            maxChroma.round(),
            (index) => chromaColor(index.toDouble()),
          ),
        ),
        const SizedBox(height: 8),
        // Tone
        GradientSlider(
          value: tone,
          minValue: minTone,
          maxValue: maxTone,
          divisions: maxTone.round(),
          label: 'Tone',
          onChanged: (value) {
            if (mounted) {
              setState(() {
                tone = value;
                onHctChange();
              });
            }
          },
          stops: List.generate(
            maxTone.round(),
            (index) => toneColor(index.toDouble()),
          ),
        ),
      ],
    );
  }

  Color hueColor(double value) => Color(Hct.from(value, chroma, 50).toInt());
  Color chromaColor(double value) => Color(Hct.from(hue, value, 50).toInt());
  Color toneColor(double value) => Color(Hct.from(hue, chroma, value).toInt());
}
