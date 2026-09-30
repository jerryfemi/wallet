import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MempoolService {
  final Dio _dio;
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  // Load from environment variables
  String get _appId => dotenv.env['PUSHER_APP_ID'] ?? '';
  String get _key => dotenv.env['PUSHER_KEY'] ?? '';
  String get _secret => dotenv.env['PUSHER_SECRET'] ?? '';
  String get _cluster => dotenv.env['PUSHER_CLUSTER'] ?? '';

  MempoolService(this._dio);

  /// Initializes the Pusher connection and subscribes to your wallet address.
  /// When someone broadcasts a transfer to your address, [onTransferReceived] will fire.
  Future<void> connectAndListen({
    required String myWalletAddress,
    required Function(Map<String, dynamic> payload) onTransferReceived,
  }) async {
    try {
      await _pusher.init(
        apiKey: _key,
        cluster: _cluster,
        onEvent: (PusherEvent event) {
          if (event.eventName == 'transfer-received') {
            final payload = jsonDecode(event.data.toString()) as Map<String, dynamic>;
            onTransferReceived(payload);
          }
        },
      );
      
      // We subscribe to a specific channel just for our wallet address
      await _pusher.subscribe(channelName: 'transfers-$myWalletAddress');
      await _pusher.connect();
      print('Connected to Mempool for address: $myWalletAddress');
    } catch (e) {
      print("Mempool connection error: $e");
    }
  }

  /// Broadcasts a transaction to the network without needing a backend server.
  /// It uses the Pusher REST API directly by calculating the cryptographic signature.
  Future<bool> broadcastTransfer({
    required String senderAddress,
    required String receiverAddress,
    required String asset,
    required double amount,
    required String idempotencyKey,
  }) async {
    try {
      final String endpoint = '/apps/$_appId/events';
      final String url = 'https://api-$_cluster.pusher.com$endpoint';
      
      // 1. Prepare the payload data (what the receiver will see)
      final String eventData = jsonEncode({
        "senderAddress": senderAddress,
        "receiverAddress": receiverAddress,
        "asset": asset,
        "amount": amount,
        "idempotencyKey": idempotencyKey,
        "timestamp": DateTime.now().toIso8601String(),
      });

      // 2. Prepare the HTTP POST body
      final Map<String, dynamic> body = {
        "name": "transfer-received",
        "channel": "transfers-$receiverAddress",
        "data": eventData,
      };
      
      final String bodyJson = jsonEncode(body);
      
      // 3. Calculate MD5 of the body
      final bodyMd5 = md5.convert(utf8.encode(bodyJson)).toString();
      
      // 4. Create the auth query parameters
      final int timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
      
      // 5. Generate HMAC SHA256 Signature
      // The parameters must be alphabetically sorted in the string to sign
      final String authString = "auth_key=$_key&auth_timestamp=$timestamp&auth_version=1.0&body_md5=$bodyMd5";
      final String stringToSign = "POST\n$endpoint\n$authString";
      
      final Hmac hmac = Hmac(sha256, utf8.encode(_secret));
      final Digest signature = hmac.convert(utf8.encode(stringToSign));
      
      // 6. Append signature to the query string
      final String finalQueryString = "$authString&auth_signature=$signature";

      // 7. Fire the POST request to the network!
      final response = await _dio.post(
        "$url?$finalQueryString",
        data: bodyJson,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return response.statusCode == 200 || response.statusCode == 202;
    } catch (e) {
      print("Failed to broadcast transaction: $e");
      return false;
    }
  }

  Future<void> disconnect() async {
    await _pusher.disconnect();
  }
}
