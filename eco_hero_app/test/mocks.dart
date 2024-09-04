// mocks.dart
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:eco_hero_app/storage_service.dart';

@GenerateMocks([http.Client, StorageService])
void main() {}
