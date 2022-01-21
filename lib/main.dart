import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var themeBrightness = Brightness.dark;
  var themeIcon = Icons.light_mode;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: themeBrightness),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("NATGRA"),
          actions: <Widget>[
            IconButton(
              icon: Icon(themeIcon),
              onPressed: () => setState(() {
                if (themeBrightness == Brightness.dark) {
                  themeBrightness = Brightness.light;
                  themeIcon = Icons.dark_mode;
                } else {
                  themeBrightness = Brightness.dark;
                  themeIcon = Icons.light_mode;
                }
              }),
            )
          ],
        ),
        body: Center(child: ChatArea()),
      ),
    );
  }
}

class ChatArea extends StatefulWidget {
  const ChatArea({Key? key}) : super(key: key);
  @override
  _ChatAreaState createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  var messages = <Container>[];
  final myController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  static const MESSAGEPADDING = 10.0,
      MESSAGEBORDERRADIUS = 6.0,
      MESSAGEMAXWIDTH = 200.0;
  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    //initMessages();
    return Container(
        child: Column(children: [
          Expanded(
              child: ListView(
            children: messages,
            controller: _scrollController,
          )),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Message',
                    ),
                    controller: myController,
                  ),
                  width: 323.0,
                ),
                IconButton(
                    icon: Icon(Icons.send, size: 30.0),
                    onPressed: () {
                      var msg = myController.text;
                      addMessage(msg, true);
                      myController.text = "";
                      _scrollToBottom();
                      var res = http.get(
                          Uri.parse(
                              'https://pbkdev.pythonanywhere.com/natgra/apirep/' +
                                  msg),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          });
                      res.then((val) {
                        var js = jsonDecode(val.body);
                        addMessage(js["message"], false);
                      });
                      _scrollToBottom();
                    })
              ],
            ),
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.bottomCenter,
          )
        ]),
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0));
  }

  void initMessages() {
    if (messages.isEmpty) {
      setState(() {
        messages = [
          Container(
            child: Container(
                child: Text("Hello"),
                padding: EdgeInsets.all(MESSAGEPADDING),
                decoration: BoxDecoration(
                    color: (Theme.of(context).brightness == Brightness.dark)
                        ? Colors.green
                        : Colors.lightGreen,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(MESSAGEBORDERRADIUS))),
                constraints: const BoxConstraints(maxWidth: MESSAGEMAXWIDTH)),
            alignment: Alignment.bottomRight,
          ),
          Container(
            child: Container(
                child: Text("Hi"),
                padding: EdgeInsets.all(MESSAGEPADDING),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(MESSAGEBORDERRADIUS))),
                constraints: const BoxConstraints(maxWidth: MESSAGEMAXWIDTH)),
            alignment: Alignment.bottomLeft,
          ),
          Container(
            child: Container(
                child: Text("Wassup"),
                padding: EdgeInsets.all(MESSAGEPADDING),
                decoration: BoxDecoration(
                    color: (Theme.of(context).brightness == Brightness.dark)
                        ? Colors.green
                        : Colors.lightGreen,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(MESSAGEBORDERRADIUS))),
                constraints: const BoxConstraints(maxWidth: MESSAGEMAXWIDTH)),
            alignment: Alignment.bottomRight,
          )
        ];
      });
    }
  }

  void addMessage(String msg, bool sender) {
    setState(() {
      messages.add(Container(
        child: Container(
            child: Text(msg),
            padding: EdgeInsets.all(MESSAGEPADDING),
            decoration: BoxDecoration(
                color: (sender)
                    ? ((Theme.of(context).brightness == Brightness.dark)
                        ? Colors.green
                        : Colors.lightGreen)
                    : Colors.grey,
                borderRadius: const BorderRadius.all(
                    Radius.circular(MESSAGEBORDERRADIUS))),
            constraints: const BoxConstraints(maxWidth: MESSAGEMAXWIDTH)),
        alignment: (sender) ? Alignment.bottomRight : Alignment.bottomLeft,
        padding: EdgeInsets.all(MESSAGEPADDING),
      ));
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
}
