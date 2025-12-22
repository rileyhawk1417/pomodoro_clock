import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_clock/bloc/labels/labels_bloc.dart';
import 'package:pomodoro_clock/bloc/settings/settings_bloc.dart';
import 'package:pomodoro_clock/drift/db.dart';
import 'package:pomodoro_clock/hive/settings_model.dart';

Color hexToColor(String hexString) {
  final hexColor = hexString.replaceAll('#', '');
  final a = hexColor.length == 8
      ? int.parse(hexColor.substring(0, 2), radix: 16)
      : 0xFF;
  final r = int.parse(
      hexColor.substring(hexColor.length - 6, hexColor.length - 4),
      radix: 16);
  final g = int.parse(
      hexColor.substring(hexColor.length - 4, hexColor.length - 2),
      radix: 16);
  final b = int.parse(hexColor.substring(hexColor.length - 2, hexColor.length),
      radix: 16);
  return Color.fromARGB(a, r, g, b);
}

String colorToHex(Color color) {
  return '#${color.a.toStringAsPrecision(16).padLeft(2, '0')}${color.r.toStringAsPrecision(16).padLeft(2, '0')}${color.g.toStringAsPrecision(16).padLeft(2, '0')}${color.b.toStringAsPrecision(16).padLeft(2, '0')}';
}

class LabelEditScreen extends StatefulWidget {
  const LabelEditScreen({Key? key}) : super(key: key);
  @override
  State<LabelEditScreen> createState() => _LabelEditScreen();
}

class _LabelEditScreen extends State<LabelEditScreen> {
  @override
  Widget build(BuildContext context) {
    Color pickerColor = Color(0xff443a49);
    Color currentColor = Color(0xff443a49);
    void onColorChanged(Color color) {
      setState(() => pickerColor = color);
    }

    final _textFieldController = TextEditingController();

    return BlocBuilder<LabelsBloc, LabelsState>(
        builder: (labelsContext, state) {
      if (state.labels.isEmpty) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => context.go('/'),
                  icon: Icon(Icons.arrow_left)),
            ),
            body: SafeArea(
              child: Center(
                child: Text('No Labels Found'),
              ),
            ),
            floatingActionButton: IconButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: SimpleDialog(
                          title: const Text('Set Color'),
                          children: [
                            ColorPicker(
                                labelTypes: [],
                                portraitOnly: true,
                                pickerAreaHeightPercent: 0.3,
                                pickerColor: pickerColor,
                                onColorChanged: onColorChanged),
                            TextField(
                              decoration:
                                  InputDecoration(hintText: 'Enter a label'),
                              controller: _textFieldController,
                            ),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () async {
                                      context.read<SettingsBloc>().add(
                                          SetDefaultLabel(
                                              label: LabelsModel(
                                                  label:
                                                      _textFieldController.text,
                                                  color: colorToHex(
                                                      currentColor))));

                                      labelsContext.read<LabelsBloc>().add(
                                          AddLabels(_textFieldController.text,
                                              colorToHex(currentColor)));
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Make Default')),
                                TextButton(
                                    onPressed: () async {
                                      labelsContext.read<LabelsBloc>().add(
                                          AddLabels(_textFieldController.text,
                                              colorToHex(currentColor)));
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ok'))
                              ],
                            )
                          ],
                        ),
                      );
                    });
              },
              icon: Icon(Icons.add),
            ));
      }
      if (state is LabelsLoaded) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => context.go('/'),
                  icon: Icon(Icons.arrow_left)),
            ),
            body: SafeArea(
              child: ListView.builder(
                  itemCount: state.labels.length,
                  itemBuilder: (listBuilder, index) {
                    final Label label = state.labels[index];
                    return ListTile(
                      title: Text(label.labelName),
                      trailing: PopupMenuButton(
                          itemBuilder: (BuildContext menuContext) =>
                              <PopupMenuEntry>[
                                PopupMenuItem(
                                    child: const Text('Make Default'),
                                    onTap: () async {
                                      {
                                        context.read<SettingsBloc>().add(
                                              SetDefaultLabel(
                                                label: LabelsModel(
                                                  label: label.labelName,
                                                  color: label.labelColor
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                      }
                                    }),
                                PopupMenuItem(
                                  child: const Text('Edit'),
                                  onTap: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          _textFieldController.text =
                                              label.labelName;
                                          return SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.5,
                                            child: SimpleDialog(
                                              title: const Text('Set Color'),
                                              children: [
                                                ColorPicker(
                                                    labelTypes: [],
                                                    portraitOnly: true,
                                                    pickerAreaHeightPercent:
                                                        0.3,
                                                    pickerColor: hexToColor(
                                                        label.labelColor),
                                                    onColorChanged:
                                                        onColorChanged),
                                                TextField(
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Enter a label'),
                                                  controller:
                                                      _textFieldController,
                                                ),
                                                Row(
                                                  children: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Cancel')),
                                                    TextButton(
                                                        onPressed: () async {
                                                          context
                                                              .read<
                                                                  SettingsBloc>()
                                                              .add(
                                                                SetDefaultLabel(
                                                                  label:
                                                                      LabelsModel(
                                                                    label:
                                                                        _textFieldController
                                                                            .text,
                                                                    color: currentColor
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                              );
                                                          context
                                                              .read<
                                                                  LabelsBloc>()
                                                              .add(AddLabels(
                                                                  _textFieldController
                                                                      .text,
                                                                  currentColor
                                                                      .toString()));
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Make Default')),
                                                    TextButton(
                                                        onPressed: () async {
                                                          labelsContext
                                                              .read<
                                                                  LabelsBloc>()
                                                              .add(AddLabels(
                                                                  _textFieldController
                                                                      .text,
                                                                  currentColor
                                                                      .toString()));
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('Ok'))
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Text('Delete'),
                                  onTap: () async {
                                    labelsContext
                                        .read<LabelsBloc>()
                                        .add(DeleteLabels(label.id));
                                  },
                                )
                              ]),
                    );
                  }),
            ),
            floatingActionButton: IconButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: SimpleDialog(
                          title: const Text('Set Color'),
                          children: [
                            ColorPicker(
                                labelTypes: [],
                                portraitOnly: true,
                                pickerAreaHeightPercent: 0.3,
                                pickerColor: pickerColor,
                                onColorChanged: onColorChanged),
                            TextField(
                              decoration:
                                  InputDecoration(hintText: 'Enter a label'),
                              controller: _textFieldController,
                            ),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () async {
                                      context.read<SettingsBloc>().add(
                                          SetDefaultLabel(
                                              label: LabelsModel(
                                                  label:
                                                      _textFieldController.text,
                                                  color: colorToHex(
                                                      currentColor))));

                                      labelsContext.read<LabelsBloc>().add(
                                          AddLabels(_textFieldController.text,
                                              colorToHex(currentColor)));
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Make Default')),
                                TextButton(
                                    onPressed: () async {
                                      labelsContext.read<LabelsBloc>().add(
                                          AddLabels(_textFieldController.text,
                                              colorToHex(currentColor)));
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ok'))
                              ],
                            )
                          ],
                        ),
                      );
                    });
              },
              icon: Icon(Icons.add),
            ));
      }
      return Container();
    });
  }
}
