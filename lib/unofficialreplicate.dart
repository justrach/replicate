library unofficialreplicate;

/// A Calculator.
import 'dart:convert';
import 'dart:io';
class Replicate {
  final String baseUrl;
  final String apiToken;

  Replicate(this.apiToken, {this.baseUrl = "https://api.replicate.com/v1"});

  Future<Map<String, dynamic>> makePrediction(
      String version, Map<String, dynamic> input) async {
    final uri = Uri.parse('$baseUrl/predictions');
    final client = HttpClient();

    final request = await client.postUrl(uri);
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Token $apiToken');
    request.write(json.encode({
      "version": version,
      "input": input,
    }));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(responseBody);
    } else {
      throw Exception('Error: ${response.statusCode} | $responseBody');
    }
  }
}

void main() async {
  const REPLICATE_API_TOKEN = 'r8_1FrNfwyt7As8bJnDYcG3M1Im4WFz1xn1k9EML'; // Replace this with your actual token
  final replicate = Replicate(REPLICATE_API_TOKEN);

  try {
    final input = {
      "prompt": "www.google.com", // your actual image data or any other parameters
    };
    final result = await replicate.makePrediction(
        "e8818682e72a8b25895c7d90e889b712b6edfc5151f145e3606f21c1e85c65bf", input);
    print(result); 
  } catch (e) {
    print('Error making prediction: $e');
  }
}
