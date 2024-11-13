import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SecureStorageService {
  final String baseUrl = '${dotenv.env['LOCALHOST']}'; // Địa chỉ server của bạn
  final _secureStorage = FlutterSecureStorage();
  // Lưu token vào Secure Storage
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'access_token', value: token);
  }

  // // Lấy token từ Secure Storage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  // Xóa token khỏi Secure Storage
  Future<void> removeAccessToken() async {
    await _secureStorage.delete(key: 'access_token');
  }

  Future<void> removeRefreshToken() async {
    await _secureStorage.delete(key: 'refresh_token');
  }

  // Xác thực và lấy access token mới
  Future<String?> refreshAccessToken() async {
    String? refreshToken = await getRefreshToken();

    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      String newAccessToken = data['access_token'];

      // Lưu trữ lại access token mới (nếu cần)
      // await storage.write(key: 'access_token', value: newAccessToken);

      return newAccessToken;
    } else {
      return null;
    }
  }

  bool _isAccessTokenExpired(String token) {
    // Giải mã token để lấy thông tin
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    // Lấy thời gian hết hạn (exp) từ payload của token
    int expiryTime = decodedToken['exp']; // Thời gian hết hạn tính bằng giây

    // Chuyển đổi thời gian hết hạn sang thời gian hiện tại
    DateTime expiryDate =
        DateTime.fromMillisecondsSinceEpoch(expiryTime * 1000);

    // So sánh thời gian hiện tại với thời gian hết hạn
    return DateTime.now().isAfter(
        expiryDate); // Nếu hiện tại lớn hơn thời gian hết hạn, token đã hết hạn
  }

  Future<String?> getValidAccessToken() async {
    // Lấy access token từ lưu trữ
    String? accessToken = await getAccessToken();
    print("accessToken sau khi lay: " + accessToken.toString());
    // Kiểm tra xem access token có tồn tại hoặc đã hết hạn không
    if (accessToken == null || _isAccessTokenExpired(accessToken)) {
      // Nếu không hợp lệ, thử refresh access token
      accessToken = await refreshAccessToken();

      // Nếu lấy được token mới, lưu lại vào storage
      if (accessToken != null) {
        await saveToken(accessToken);
      } else {
        print('Không thể refresh access token');
      }
    }

    return accessToken;
  }
}
