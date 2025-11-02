import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import 'package:image_picker/image_picker.dart';

Future<void> initializeDotenv() async {
  await dotenv.load(fileName: ".env");
}

Future<String?> uploadToCloudinary(XFile? xFile) async {
  await initializeDotenv();
  
  if (xFile == null) {
    print("Không có file được chọn!");
    return null;
  }

  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  String uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  if (cloudName.isEmpty || uploadPreset.isEmpty) {
    print("❌ Lỗi: Chưa thiết lập biến môi trường đúng!");
    return null;
  }

  // URI Cloudinary API
  var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

  // Tạo MultipartRequest
  var request = http.MultipartRequest("POST", uri);

  // Đọc nội dung file thành bytes
  var fileBytes = await xFile.readAsBytes();
  var multipartFile = http.MultipartFile.fromBytes(
    'file',
    fileBytes,
    filename: xFile.name,
  );

  // Thêm file vào request
  request.files.add(multipartFile);

  // Thêm các trường form cần thiết
  request.fields['upload_preset'] = uploadPreset;
  request.fields['folder'] = "images"; // 🔥 Chỉ định folder lưu ảnh

  // Gửi request
  var response = await request.send();
  var responseBody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(responseBody);
    print("✅ Upload thành công: ${jsonResponse["secure_url"]}");
    return jsonResponse["secure_url"];
  } else {
    print("❌ Upload thất bại! Mã lỗi: ${response.statusCode}");
    return null;
  }
}

