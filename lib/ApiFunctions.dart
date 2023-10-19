// import 'package:http/http.dart' as http;

class ApiFunctions {
  static var apiKey = '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';
}

// curl \
//     -F 'text=YOUR_TEXT_HERE' \
//     -H 'api-key:0e93c88e-f479-4ca8-bc8e-c8e963a90a82' \
//     https://api.deepai.org/api/text2img

// r = requests.post(
//     "https://api.deepai.org/api/text2img",
//     data={
//         'text': 'YOUR_TEXT_HERE',
//     },
//     headers={'api-key': '0e93c88e-f479-4ca8-bc8e-c8e963a90a82'}
// )
// print(r.json())
// void main() async {
//   var url = Uri.parse('https://api.deepai.org/api/text2img');
//   var req = new http.MultipartRequest('POST', url)
//     ..fields['text'] = 'YOUR_TEXT_HERE';
//   req.headers['api-key'] = '0e93c88e-f479-4ca8-bc8e-c8e963a90a82';
//   var res = await req.send();
//   if (res.statusCode != 200)
//     throw Exception('http.send error: statusCode= ${res.statusCode}');
//   print(res.contentLength);
// }
