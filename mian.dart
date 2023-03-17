import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

final String uploadURL = '<your_upload_URL>';

void main() async {
  // Replace this with your video file
  final File videoFile = File('<path_to_your_video_file>');

  // Compress video using flutter_ffmpeg
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  final String compressedVideoPath = '<path_to_compressed_video>';
  await _flutterFFmpeg.execute('-i ${videoFile.path} -c:v libx264 -preset slow -crf 22 $compressedVideoPath');

  // Create a multipart request for the file upload
  final http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(uploadURL));
  request.files.add(await http.MultipartFile.fromPath('video', compressedVideoPath));

  // Send the request and track upload progress
  final http.StreamedResponse response = await request.send();
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
    // Update your UI with upload progress here
  });
}
