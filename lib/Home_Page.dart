// ignore_for_file: file_names

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/OpenAiServers.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final FlutterTts flutterTts = FlutterTts();
  final speechToText = SpeechToText();
  String lastWords = '';
  String? generatedimage;
  String? generatedtext;


  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  Future<void> initSpeech() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> SystemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    stopListening();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BounceInDown(child: const Text('Rohan', textAlign: TextAlign.center,)),
        leading: const Icon(Icons.menu),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ZoomIn(
              child: Container(
                height: 123,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image:DecorationImage(
                      image : AssetImage('Assets/chatbot.jpeg')
                  ),
                ),),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10
              ),
              margin: const EdgeInsets.symmetric(
                  horizontal: 40
              ).copyWith(
                  top: 30
              ),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.blueGrey
                ),
                borderRadius: BorderRadius.circular(20).copyWith(
                    topLeft: Radius.zero
                ),
                // backgroundBlendMode: BlendMode.colorBurn,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text( generatedtext == null ?'Good Morning, What task can I do for you?' : generatedtext!,
                  style: const TextStyle(
                      color: Colors.teal,
                      fontFamily: 'PTSans',
                      fontSize: 17
                  ),),
              ),

            ),
            if(generatedimage != null) Image.network(generatedimage!),
            const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Here are few Commands which you can give',
                  style: TextStyle(
                      color: Color(0xffFFD700),
                      fontFamily: 'PTSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            const Description_Card(Color(0xffFF7F50), 'ChatGPT', 'A smarter way to stay organized and informed'),
            const Description_Card(Color(0xff50C878), 'Dall-E', "Get inspired and stay creative with you personal image generative assistant powered by Dall E"),
            const Description_Card(Color(0xff40E0D0), 'Smart Voice Assistance', 'Get use of both with our all new AI powered voice assistant'),
          ],
        ),
      ),
      floatingActionButton: SlideInRight(
        child: FloatingActionButton(
          onPressed: () async{
            if(await speechToText.hasPermission && speechToText.isNotListening){
              await startListening();
            }
            else if(speechToText.isListening) {
              final Speech = await OpenAIService().isArtPromptAPI(lastWords);
              if(Speech.contains('http')){
                generatedimage = Speech;
                generatedtext = null;
                setState(() {

                });
              }
              else {
                generatedimage = null;
                generatedtext = Speech;
                setState(() {

                });
                await SystemSpeak(Speech);
              }
              await stopListening();
            }
            else{
              initSpeech();
            }
          },
          backgroundColor: const Color(0xffE0115F),
          child: Icon(speechToText.isListening ? Icons.cancel : Icons.mic),
        ),
      ),
    );
  }
}

class Description_Card extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;


  const Description_Card(this.color, this.headerText, this.descriptionText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0).copyWith(
          left: 15,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerText,
                style: const TextStyle(
                  fontFamily: 'PTSans',
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                descriptionText,
                style: const TextStyle(
                  fontFamily: 'PTSans',
                  color: Colors.black,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}