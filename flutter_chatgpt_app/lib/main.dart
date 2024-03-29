import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/model/open_ai_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 1번코드
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TextEditingController messageTextController = TextEditingController();
  final List<Messages> _historyList = List.empty(growable: true);

  String apiKey = dotenv.get("OPEN_AI_API");
  String streamText = "";

  static const String _kStrings = "FastCampus Flutter ChatGPT";

  String get _currentString => _kStrings;

  ScrollController scrollController = ScrollController();
  late Animation<int> _characterCount;
  late AnimationController animationController;

  setupAnimations() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500));
    _characterCount = StepTween(begin: 0, end: _currentString.length).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    animationController.addListener(() {
      setState(() {});
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          animationController.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(seconds: 1)).then(
          (value) => animationController.forward(),
        );
      }
    });

    animationController.forward();
  }

  Future requestChat(String text) async {
    ChatCompletionModel openAiModel = ChatCompletionModel(
      model: "gpt-3.5-turbo",
      messages: [
        Messages(role: "system", content: "You are a helpful assistant."),
        ..._historyList,
      ],
      stream: false,
    );

    final url = Uri.https("api.openai.com", "/v1/chat/completions");
    final resp = await http.post(url,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode(openAiModel.toJson()));

    print(resp.body);
  }

  @override
  void initState() {
    super.initState();
    setupAnimations();
  }

  @override
  void dispose() {
    messageTextController.dispose();
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Card(
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          child: ListTile(
                            title: Text('히스토리'),
                          ),
                        ),
                        const PopupMenuItem(
                          child: ListTile(
                            title: Text('설정'),
                          ),
                        ),
                        const PopupMenuItem(
                          child: ListTile(
                            title: Text('새로운 채팅'),
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _characterCount,
                      builder: (BuildContext context, Widget? child) {
                        String text =
                            _currentString.substring(0, _characterCount.value);
                        return Row(
                          children: [
                            Text(
                              text,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.teal,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                // child: Container(
                // // color: Colors.blue,
                // // child: const Center(
                // //   child: Text(_kStrings),
                // // ),
                // child: ListView.builder(
                //   itemCount: 100,
                //   itemBuilder: (context, index) {
                //     if (index % 2 == 0) {
                //       return const Padding(
                //         padding: EdgeInsets.symmetric(vertical: 16),
                //         child: Row(
                //           children: [
                //             CircleAvatar(),
                //             SizedBox(
                //               width: 8,
                //             ),
                //             Expanded(
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text('User'),
                //                   Text('Message'),
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       );
                //     }
                //     return const Row(
                //       children: [
                //         CircleAvatar(
                //           backgroundColor: Colors.teal,
                //         ),
                //         SizedBox(
                //           width: 8,
                //         ),
                //         Expanded(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text('ChatGPT'),
                //               Text('OpenAI'),
                //             ],
                //           ),
                //         ),
                //       ],
                //     );
                //   },
                // ),
                // ),
              ),
              Dismissible(
                key: const Key("chat-bar"),
                direction: DismissDirection.startToEnd,
                onDismissed: (d) {
                  if (d == DismissDirection.startToEnd) {
                    //logic
                  }
                },
                background: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text("New Chat")],
                ),
                confirmDismiss: (d) async {
                  if (d == DismissDirection.startToEnd) {
                    //logic
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(),
                        ),
                        child: TextField(
                          controller: messageTextController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: "Message"),
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 42,
                      onPressed: () async{
                        if(messageTextController.text.isEmpty){
                          return;
                        }
                        try{
                          await requestChat(messageTextController.text.trim());
                          messageTextController.clear();
                          streamText = "";
                        }catch(e){
                          print(e.toString());
                        }
                      },
                      icon: const Icon(Icons.arrow_circle_up),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
