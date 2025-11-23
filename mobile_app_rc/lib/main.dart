import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:typed_data';

import 'package:rc/src/features/views/car.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Car());
  }
}
/*
class MotorControlPage extends StatefulWidget {
  const MotorControlPage({super.key});

  @override
  State<MotorControlPage> createState() => _MotorControlPageState();
}

class _MotorControlPageState extends State<MotorControlPage> {
  final String baseUrl = "http://192.168.4.1";
  final String camUrl = "http://192.168.4.2/stream";

  bool forwardPressed = false;
  bool backwardPressed = false;
  bool leftPressed = false;
  bool rightPressed = false;

  String statusText = "STATUS: -";
  String streamStatus = "Connecting...";

  Uint8List? _currentFrame;
  StreamSubscription? _streamSubscription;
  http.Client? _httpClient;

  @override
  void initState() {
    super.initState();
    _startStream();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _httpClient?.close();
    super.dispose();
  }

  void _startStream() async {
    try {
      setState(() {
        print(streamStatus);
      });

      _httpClient = http.Client();
      final request = http.Request('GET', Uri.parse(camUrl));

      final response = await _httpClient!
          .send(request)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException('Camera connection timeout');
            },
          );

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      setState(() => streamStatus = "Streaming...");

      final buffer = BytesBuilder(copy: false);
      int lastStartIndex = -1;

      _streamSubscription = response.stream.listen(
        (chunk) {
          buffer.add(chunk);
          final bytes = buffer.toBytes();

          int startIndex = lastStartIndex;
          if (startIndex == -1) {
            for (int i = 0; i < bytes.length - 1; i++) {
              if (bytes[i] == 0xFF && bytes[i + 1] == 0xD8) {
                startIndex = i;
                break;
              }
            }
          }

          if (startIndex != -1) {
            for (int i = startIndex + 2; i < bytes.length - 1; i++) {
              if (bytes[i] == 0xFF && bytes[i + 1] == 0xD9) {
                final frame = Uint8List.view(
                  bytes.buffer,
                  startIndex,
                  i - startIndex + 2,
                );
                if (mounted) {
                  setState(() {
                    _currentFrame = frame;
                    streamStatus = "Live";
                  });
                }
                buffer.clear();
                buffer.add(
                  Uint8List.view(bytes.buffer, i + 2, bytes.length - i - 2),
                );
                lastStartIndex = -1;
                return;
              }
            }
            lastStartIndex = startIndex;
          }

          if (buffer.length > 50000) {
            buffer.clear();
            lastStartIndex = -1;
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() => streamStatus = "Error: $error");
          }
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) _startStream();
          });
        },
        onDone: () {
          if (mounted) {
            setState(() => streamStatus = "Stream ended");
          }
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) _startStream();
          });
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => streamStatus = "Error: $e");
      }
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) _startStream();
      });
    }
  }

  Future<void> sendCommand(String cmd) async {
    try {
      final res = await http
          .get(Uri.parse("$baseUrl/$cmd"))
          .timeout(const Duration(seconds: 1));
      setState(() => statusText = "STATUS: ${res.body}");
    } catch (_) {
      setState(() => statusText = "STATUS: failed");
    }
  }

  Widget buildButton({
    required Color color,
    required bool isPressed,
    required VoidCallback onTapShort,
    required VoidCallback onHoldStart,
    required VoidCallback onHoldEnd,
  }) {
    return GestureDetector(
      onTap: onTapShort,
      onLongPressStart: (_) => onHoldStart(),
      onLongPressEnd: (_) => onHoldEnd(),
      child: AnimatedScale(
        scale: isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonSide({
    required Color color,
    required bool isPressed,
    required VoidCallback onTapShort,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTapShort,
      child: AnimatedScale(
        scale: isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Camera: $streamStatus",
                  style: TextStyle(
                    fontSize: 16,
                    color: streamStatus == "Live"
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(40),
              height: double.infinity,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFEAEBEB),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _currentFrame != null
                    ? Image.memory(
                        width: double.infinity,
                        _currentFrame!,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        cacheWidth: 640,
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 20),
                            Text(
                              streamStatus,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
              ),
            ),

            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildButtonSide(
                      color: const Color(0xFFCACACA),
                      isPressed: leftPressed,
                      text: "<",
                      onTapShort: () {},
                    ),
                    const SizedBox(width: 20),
                    buildButtonSide(
                      color: const Color(0xFFCACACA),
                      isPressed: rightPressed,
                      text: ">",
                      onTapShort: () {},
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildButton(
                    color: const Color(0xFFCACACA),
                    isPressed: backwardPressed,
                    onTapShort: () {
                      setState(() => backwardPressed = true);
                      sendCommand("backward");
                      Future.delayed(const Duration(milliseconds: 200), () {
                        setState(() => backwardPressed = false);
                        sendCommand("stop");
                      });
                    },
                    onHoldStart: () {
                      setState(() => backwardPressed = true);
                      sendCommand("backward");
                    },
                    onHoldEnd: () {
                      setState(() => backwardPressed = false);
                      sendCommand("stop");
                    },
                  ),

                  const SizedBox(width: 20),

                  buildButton(
                    color: const Color(0xFFCACACA),
                    isPressed: forwardPressed,
                    onTapShort: () {
                      setState(() => forwardPressed = true);
                      sendCommand("forward");
                      Future.delayed(const Duration(milliseconds: 200), () {
                        setState(() => forwardPressed = false);
                        sendCommand("stop");
                      });
                    },
                    onHoldStart: () {
                      setState(() => forwardPressed = true);
                      sendCommand("forward");
                    },
                    onHoldEnd: () {
                      setState(() => forwardPressed = false);
                      sendCommand("stop");
                    },
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
*/