import 'package:flutter/material.dart';
import '../models/app_bar_settings.dart';
import 'appbar_settings_schema.dart';

class AutoSliderBuilder extends StatelessWidget {

  final AppBarSettings settings;
  final ValueChanged<AppBarSettings> onChanged;

  const AutoSliderBuilder({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    final items = AppBarSettingsSchema.sliders();

    return ListView.builder(

      itemCount: items.length,

      itemBuilder: (_,i){

        final item = items[i];

        final value = item.getter(settings);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(item.title),

            Slider(
              value: value,
              min: item.min,
              max: item.max,

              onChanged: (v){

                final newSettings =
                  item.setter(settings,v);

                onChanged(newSettings);
              },
            ),
          ],
        );
      },
    );
  }
}