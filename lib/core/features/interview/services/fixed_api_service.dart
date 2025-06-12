// ignore_for_file: avoid_print, unused_element

import 'dart:convert';
import 'package:http/http.dart' as http;

class FixedApiService {
  // OpenRouter API endpoint
  static const String _baseUrl =
      'https://openrouter.ai/api/v1/chat/completions';

  // API key - in production, use secure storage
  static const String _apiKey =
      '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';

  // Default model to use
  static const String _defaultModel = 'openai/gpt-3.5-turbo';

  // Add a max tokens parameter to limit response size
  static const int _maxTokens = 2048; // Reduced from default 3072

  static const Duration _timeout = Duration(seconds: 30);
  static const int _maxRetries = 3;

  static final Map<String, List<String>> _questionCache = {};
  static final Map<String, Map<String, dynamic>> _evaluationCache = {};

  // Helper method to recursively find questions in a map structure
  static void _findQuestionsInMap(dynamic data, List<String> questions) {
    if (data is Map) {
      data.forEach((key, value) {
        if (value is String && value.contains('?')) {
          questions.add(value);
        } else if (value is Map || value is List) {
          _findQuestionsInMap(value, questions);
        }
      });
    } else if (data is List) {
      for (var item in data) {
        if (item is String && item.contains('?')) {
          questions.add(item);
        } else if (item is Map || item is List) {
          _findQuestionsInMap(item, questions);
        }
      }
    }
  }

  // Generate interview questions based on field, technologies, and difficulty
  static Future<List<String>> generateInterviewQuestions({
    required String field,
    required List<String> technologies,
    required String difficulty,
    int numberOfQuestions = 5,
  }) async {
    final cacheKey =
        '$field-${technologies.join('-')}-$difficulty-$numberOfQuestions';

    // Check cache first
    if (_questionCache.containsKey(cacheKey)) {
      return _questionCache[cacheKey]!;
    }

    int retryCount = 0;
    while (retryCount < _maxRetries) {
      try {
        final String techString = technologies.join(', ');
        final prompt = """
          Generate $numberOfQuestions technical interview questions for a $difficulty-level $field developer skilled in $techString. Return only a JSON array of questions, no explanations or extra text.
        """;

        final response = await http
            .post(
              Uri.parse(_baseUrl),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $_apiKey',
                'HTTP-Referer': 'https://interview-service.app',
              },
              body: jsonEncode({
                'model': _defaultModel,
                'messages': [
                  {
                    'role': 'system',
                    'content':
                        'You are a helpful assistant. Only output a JSON array of questions.',
                  },
                  {'role': 'user', 'content': prompt},
                ],
                'response_format': {'type': 'json_object'},
                'max_tokens': _maxTokens,
              }),
            )
            .timeout(_timeout);

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final questions = _extractQuestions(jsonResponse);

          // Cache the successful response
          _questionCache[cacheKey] = questions;
          return questions;
        } else if (response.statusCode == 402) {
          print('Credit limit exceeded: ${response.body}');
          return _getDefaultQuestions(
            field,
            technologies,
            isApiLimitError: true,
          );
        } else {
          retryCount++;
          if (retryCount == _maxRetries) {
            return _getDefaultQuestions(field, technologies);
          }
          await Future.delayed(Duration(seconds: 1 * retryCount));
        }
      } catch (e) {
        retryCount++;
        if (retryCount == _maxRetries) {
          print('Error generating questions after $retryCount retries: $e');
          return _getDefaultQuestions(field, technologies);
        }
        await Future.delayed(Duration(seconds: 1 * retryCount));
      }
    }
    return _getDefaultQuestions(field, technologies);
  }

  static List<String> _extractQuestions(dynamic jsonResponse) {
    if (jsonResponse.containsKey('choices') &&
        jsonResponse['choices'] is List &&
        jsonResponse['choices'].isNotEmpty &&
        jsonResponse['choices'][0].containsKey('message') &&
        jsonResponse['choices'][0]['message'].containsKey('content')) {
      final content = jsonResponse['choices'][0]['message']['content'];
      try {
        final parsedContent = jsonDecode(content);
        if (parsedContent is List) {
          return parsedContent.map((q) => q.toString()).toList();
        } else if (parsedContent is Map &&
            parsedContent.containsKey('questions')) {
          final questionsList = parsedContent['questions'];
          if (questionsList is List) {
            return questionsList.map((q) => q.toString()).toList();
          }
        }
      } catch (e) {
        print('Error parsing questions: $e');
      }
    }
    return _getDefaultQuestions('', []);
  }

  // Helper method to provide default questions
  static List<String> _getDefaultQuestions(
    String field,
    List<String> technologies, {
    bool isApiLimitError = false,
  }) {
    final String techString = technologies.join(', ');
    final prefix = isApiLimitError ? '[API LIMIT REACHED] ' : '';
    return [
      '$prefix What are your primary strengths in $field development?',
      '$prefix Describe a challenging project you worked on with $techString.',
      '$prefix How do you approach debugging issues in your code?',
      '$prefix What development methodologies are you familiar with?',
      '$prefix How do you stay updated with the latest technologies in your field?',
    ];
  }

  // Evaluate interview answer with reduced token usage
  static Future<Map<String, dynamic>> evaluateAnswer({
    required String question,
    required String answer,
    required String field,
    required List<String> technologies,
    required String difficulty,
  }) async {
    final cacheKey =
        '$question-$answer-$field-${technologies.join('-')}-$difficulty';

    // Check cache first
    if (_evaluationCache.containsKey(cacheKey)) {
      return _evaluationCache[cacheKey]!;
    }

    int retryCount = 0;
    while (retryCount < _maxRetries) {
      try {
        final response = await http
            .post(
              Uri.parse(_baseUrl),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $_apiKey',
                'HTTP-Referer': 'https://interview-service.app',
              },
              body: jsonEncode({
                'model': _defaultModel,
                'messages': [
                  {
                    'role': 'system',
                    'content':
                        'You are an expert technical interviewer. Evaluate the answer and provide a score (0-100) and feedback.',
                  },
                  {
                    'role': 'user',
                    'content':
                        'Question: $question\nAnswer: $answer\nField: $field\nTechnologies: ${technologies.join(", ")}\nDifficulty: $difficulty\nEvaluate the answer and provide a JSON response with "score" (0-100) and "feedback" fields.',
                  },
                ],
                'response_format': {'type': 'json_object'},
                'max_tokens': _maxTokens,
              }),
            )
            .timeout(_timeout);

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final evaluation = _extractEvaluation(jsonResponse);

          // Cache the successful response
          _evaluationCache[cacheKey] = evaluation;
          return evaluation;
        } else {
          retryCount++;
          if (retryCount == _maxRetries) {
            return _getDefaultEvaluation();
          }
          await Future.delayed(Duration(seconds: 1 * retryCount));
        }
      } catch (e) {
        retryCount++;
        if (retryCount == _maxRetries) {
          print('Error evaluating answer after $retryCount retries: $e');
          return _getDefaultEvaluation();
        }
        await Future.delayed(Duration(seconds: 1 * retryCount));
      }
    }
    return _getDefaultEvaluation();
  }

  static Map<String, dynamic> _extractEvaluation(dynamic jsonResponse) {
    try {
      if (jsonResponse.containsKey('choices') &&
          jsonResponse['choices'] is List &&
          jsonResponse['choices'].isNotEmpty &&
          jsonResponse['choices'][0].containsKey('message') &&
          jsonResponse['choices'][0]['message'].containsKey('content')) {
        final content = jsonResponse['choices'][0]['message']['content'];
        final parsedContent = jsonDecode(content);

        if (parsedContent is Map &&
            parsedContent.containsKey('score') &&
            parsedContent.containsKey('feedback')) {
          return {
            'score': parsedContent['score'],
            'feedback': parsedContent['feedback'],
          };
        }
      }
    } catch (e) {
      print('Error parsing evaluation: $e');
    }
    return _getDefaultEvaluation();
  }

  // Helper method to provide default evaluation
  static Map<String, dynamic> _getDefaultEvaluation() {
    return {
      'score': 50,
      'feedback':
          'Unable to evaluate the answer at this time. Please try again.',
    };
  }

  // Clear caches when needed
  static void clearCaches() {
    _questionCache.clear();
    _evaluationCache.clear();
  }
}
