import 'package:flutter/material.dart';
import '../settings_engine/settings_controller.dart';
import '../settings_engine/setting_types.dart';
import 'settings_slider_page.dart';
import 'settings_photoshop_color_page.dart';

class GridSettingsPage extends StatelessWidget {

  const GridSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = SettingsController.I;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        elevation: 20,
        child: Container(
          width: 320,
          color: Colors.white,

          child: Column(
            children: [

              /// HEADER

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal:12,vertical:14),
                color: Colors.black,

                child: Row(
                  children: [

                    const Expanded(
                      child: Text(
                        "Grid Settings",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.close,color:Colors.white),
                      onPressed: (){
                        controller.popPanel();
                      },
                    )
                  ],
                ),
              ),

              /// BODY

              Expanded(
                child: ListView(
                  children: [

                    /// GRID COLUMNS

                    Wrap(
                      spacing:8,
                      runSpacing:8,
                      children: List.generate(9,(i){

                        final value = i+1;

                        return InkWell(

                          onTap:(){

                            controller.updateValue(
                              group: SettingGroup.grid,
                              option: SettingOption.columns,
                              value: value,
                            );

                          },

                          child: Container(

                            width:40,
                            height:40,

                            alignment:Alignment.center,

                            decoration:BoxDecoration(
                              color: controller.gridColumns == value
                                  ? Colors.black
                                  : Colors.grey.shade200,
                              borderRadius:
                              BorderRadius.circular(8),
                            ),

                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                color: controller.gridColumns == value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );

                      }),
                    ),

                    /// BOX HEIGHT

                    _slider("Box Height",
                        SettingOption.height),

                    /// TEXT SIZE

                    _slider("Text Size",
                        SettingOption.fontSize),

                    /// TEXT COLOR

                    _color("Text Color",
                        SettingOption.textColor),

                    /// SELECTED COLOR

                    _color("Selected Color",
                        SettingOption.selectedColor),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _slider(String title, SettingOption option){

    return ListTile(
      title: Text(title),

      onTap:(){

        SettingsController.I.pushPanel(

          SettingsSliderPage(
            group: SettingGroup.grid,
            setting: title,
            option: option,
          ),
        );
      },
    );
  }

  Widget _color(String title, SettingOption option){

    return ListTile(
      title: Text(title),

      onTap:(){

        SettingsController.I.pushPanel(

          ProColorPicker(
            initial: Colors.blue,
            onChanged:(c){

              SettingsController.I.updateValue(
                group: SettingGroup.grid,
                option: option,
                value: c,
              );

            },
          ),
        );
      },
    );
  }
}