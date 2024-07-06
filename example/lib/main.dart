import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Keyboard Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Virtual Keyboard Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Holds the text that user typed.
  String text = '';

  // CustomLayoutKeys _customLayoutKeys;
  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  late TextEditingController _controllerText;

  @override
  void initState() {
    // _customLayoutKeys = CustomLayoutKeys();
    _controllerText = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              _controllerText.text,
              style: TextStyle(color: Colors.red),
            ),
            SwitchListTile(
              title: Text(
                'Keyboard Type = ' +
                    (isNumericMode
                        ? 'VirtualKeyboardType.Numeric'
                        : 'VirtualKeyboardType.Alphanumeric'),
              ),
              value: isNumericMode,
              onChanged: (val) {
                setState(() {
                  isNumericMode = val;
                });
              },
            ),
            Expanded(
              child: Container(),
            ),
            VirtualKeyboard(
              height: 400,
              //width: 500,
              textColor: Colors.white,
              textController: _controllerText,
              //customLayoutKeys: _customLayoutKeys,
              defaultLayouts: [
                VirtualKeyboardDefaultLayouts.English,
                VirtualKeyboardDefaultLayouts.Arabic,
              ],
              //reverseLayout :true,
              type: isNumericMode
                  ? VirtualKeyboardType.Numeric
                  : VirtualKeyboardType.Alphanumeric,
              onKeyPress: _onKeyPress,
              actionKeyColor: Color.fromARGB(255, 224, 225, 249),
              keyColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 239, 241, 245),
            )
          ],
        ),
      ),
    );
  }

  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + (shiftEnabled ? (key.capsText ?? '') : (key.text ?? ''));
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          text = text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + (key.text ?? '');
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
    // Update the screen
    setState(() {});
  }
}
