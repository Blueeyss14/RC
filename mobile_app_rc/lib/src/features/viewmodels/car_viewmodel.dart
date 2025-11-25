import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:rc/src/core/config/config.dart';

class CarViewmodel extends GetxController {
  var isThrottleClicked = false.obs;
  var isBrakeClicked = false.obs;

  var isLeftClicked = false.obs;
  var isRightClicked = false.obs;
  var isGearClicked = true.obs;

  var statusText = "STATUS: -".obs;
  var streamStatus = "Connecting...".obs;

  Uint8List? currentFrame;
  StreamSubscription? streamSubscription;
  http.Client? _httpClient;

  Future<void> startStream() async {
    try {
      if (kDebugMode) {
        print(streamStatus);
      }

      _httpClient = http.Client();
      final request = http.Request('GET', Uri.parse(Config.camUrl));

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

      streamStatus.value = "Streaming...";

      final buffer = BytesBuilder(copy: false);
      int lastStartIndex = -1;

      streamSubscription = response.stream.listen(
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
                currentFrame = frame;
                streamStatus.value = "Live";
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
          streamStatus.value = "Error: $error";
          Future.delayed(const Duration(seconds: 3), () {
            startStream();
          });
        },
        onDone: () {
          streamStatus.value = "Stream ended";
          Future.delayed(const Duration(seconds: 3), () {
            startStream();
          });
        },
      );
    } catch (e) {
      streamStatus.value = "Error: $e";
      Future.delayed(const Duration(seconds: 3), () {
        startStream();
      });
    }
  }

  Future<void> sendCommand(String cmd) async {
    try {
      final res = await http
          .get(Uri.parse("${Config.baseUrl}/$cmd"))
          .timeout(const Duration(seconds: 1));
      statusText.value = "STATUS: ${res.body}";
    } catch (_) {
      statusText.value = "STATUS: failed";
    }
  }
}
