import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
final channel = IOWebSocketChannel.connect(
'wss://ws.binaryws.com/websockets/v3?app_id=1089');

channel.stream.listen((message) {
final decodedMessage = jsonDecode(message);
final activeSymbols = decodedMessage['active_symbols'];


print(activeSymbols[8]['symbol']);
getTicksPrice(activeSymbols[8]['symbol']);
getServerTime(activeSymbols[8]['symbol']);

channel.sink.close(status.goingAway);

});

channel.sink.add('{"active_symbols": "brief","product_type": "basic"}');
}

void getTicksPrice(children) {
final channel = IOWebSocketChannel.connect(
'wss://ws.binaryws.com/websockets/v3?app_id=1089');
channel.stream.listen((message) {
final decodedMessage = jsonDecode(message);
final getPrices = decodedMessage['tick']['quote'];

print('Price: $getPrices');

channel.sink.close(status.goingAway);
});

channel.sink.add('{"ticks": "$children","subscribe": 1}');
}

void getServerTime(children) {
final channel = IOWebSocketChannel.connect(
'wss://ws.binaryws.com/websockets/v3?app_id=1089');
channel.stream.listen((message) {
final decodedMessage = jsonDecode(message);
final serverTimeAsEpoch = decodedMessage['time'];
final serverTime =
DateTime.fromMillisecondsSinceEpoch(serverTimeAsEpoch * 1000);

print('Date: $serverTime');

channel.sink.close();
});

channel.sink.add('{"time": 1}');
}

/*void getQuote(children) {
final channel = IOWebSocketChannel.connect(
'wss://ws.binaryws.com/websockets/v3?app_id=1089');
channel.stream.listen((message) {
final decodedMessage = jsonDecode(message);
//final getPrices = decodedMessage['history']['prices'];

print(decodedMessage);
});

channel.sink.add(
'{"ticks_history": "$children","adjust_start_time": 1,"count": 10,"end": "latest","start": 1,"style": "ticks"}');
}*/
