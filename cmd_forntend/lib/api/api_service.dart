import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

// Package Model
class Package {
  final String? id;
  final String packageName;
  final String packageVersion;
  final String packageDescription;
  final String packageDate;
  final String packageCode;
  final String commandType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Package({
    this.id,
    required this.packageName,
    required this.packageVersion,
    required this.packageDescription,
    required this.packageDate,
    required this.packageCode,
    required this.commandType,
    this.createdAt,
    this.updatedAt,
  });

  // Convert Package to JSON
  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'packageVersion': packageVersion,
      'packageDescription': packageDescription,
      'packageDate': packageDate,
      'packageCode': packageCode,
      'commandType': commandType,
    };
  }

  // Create Package from JSON
  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['_id'] ?? json['id'],
      packageName: json['packageName'] ?? '',
      packageVersion: json['packageVersion'] ?? '',
      packageDescription: json['packageDescription'] ?? '',
      packageDate: json['packageDate'] ?? '',
      packageCode: json['packageCode'] ?? '',
      commandType: json['commandType'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

// API Service Class
class ApiService {
  // Base URL - Change this based on your testing environment
  static const String baseUrl = 'http://localhost:3000'; // For web/desktop
  // static const String baseUrl = 'http://10.0.2.2:3000'; // For Android emulator
  // static const String baseUrl = 'http://192.168.1.xxx:3000'; // For physical device (replace with your IP)

  // Headers for API requests
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Test connection to backend
  static Future<bool> testConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'), headers: headers)
          .timeout(Duration(seconds: 5));

      print('Health check response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Get all packages
  static Future<List<Package>> getAllPackages() async {
    try {
      print('Fetching all packages from: $baseUrl/packages');

      final response = await http
          .get(Uri.parse('$baseUrl/packages'), headers: headers)
          .timeout(Duration(seconds: 15));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        List<Package> packages =
            jsonList.map((json) => Package.fromJson(json)).toList();
        print('Successfully parsed ${packages.length} packages');
        return packages;
      } else {
        throw Exception(
          'Failed to load packages: ${response.statusCode} - ${response.body}',
        );
      }
    } on http.ClientException {
      throw Exception(
        'Network error: Unable to connect to server. Make sure your backend is running on $baseUrl',
      );
    } on FormatException {
      throw Exception('Invalid JSON response from server');
    } on TimeoutException {
      throw Exception('Request timeout. Server might be slow or unreachable');
    } catch (e) {
      print('Error in getAllPackages: $e');
      throw Exception('Error fetching packages: $e');
    }
  }

  // Get packages by command type (for your containers)
  static Future<List<Package>> getPackagesByCommandType(
    String commandType,
  ) async {
    try {
      final allPackages = await getAllPackages();
      final filteredPackages =
          allPackages
              .where(
                (package) =>
                    package.commandType.toLowerCase().trim() ==
                    commandType.toLowerCase().trim(),
              )
              .toList();

      print(
        'Filtered ${filteredPackages.length} packages for command type: $commandType',
      );
      return filteredPackages;
    } catch (e) {
      print('Error filtering packages by command type: $e');
      throw Exception('Error fetching packages by command type: $e');
    }
  }

  // Create new package
  static Future<Package> createPackage(Package package) async {
    try {
      // Test connection first
      bool isConnected = await testConnection();
      if (!isConnected) {
        throw Exception(
          'Cannot connect to backend server. Make sure it\'s running on $baseUrl',
        );
      }

      print('Creating package: ${package.toJson()}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/packages'),
            headers: headers,
            body: json.encode(package.toJson()),
          )
          .timeout(Duration(seconds: 15));

      print('Create response status: ${response.statusCode}');
      print('Create response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Package.fromJson(json.decode(response.body));
      } else {
        // Try to parse error message from response
        String errorMessage =
            'Failed to create package: ${response.statusCode}';
        try {
          final errorData = json.decode(response.body);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          } else if (errorData['error'] != null) {
            errorMessage = errorData['error'];
          }
        } catch (e) {
          errorMessage =
              'Server error: ${response.statusCode} - ${response.body}';
        }
        throw Exception(errorMessage);
      }
    } on http.ClientException {
      throw Exception('Network error: Unable to connect to server');
    } on TimeoutException {
      throw Exception('Request timeout. Server might be slow');
    } catch (e) {
      print('Error creating package: $e');
      if (e.toString().contains('Connection refused') ||
          e.toString().contains('Failed host lookup')) {
        throw Exception(
          'Connection refused: Make sure your backend server is running on $baseUrl',
        );
      }
      throw Exception('Error creating package: $e');
    }
  }

  // Get package by ID
  static Future<Package> getPackageById(String id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/packages/$id'), headers: headers)
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Package.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Package not found');
      } else {
        throw Exception('Failed to load package: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching package: $e');
    }
  }

  // Update package
  static Future<Package> updatePackage(String id, Package package) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/packages/$id'),
            headers: headers,
            body: json.encode(package.toJson()),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Package.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Package not found');
      } else {
        throw Exception('Failed to update package: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating package: $e');
    }
  }

  // Delete package
  static Future<bool> deletePackage(String id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/packages/$id'), headers: headers)
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Package not found');
      } else {
        throw Exception('Failed to delete package: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting package: $e');
    }
  }

  // Get available command types (for your dropdown)
  static Future<List<String>> getCommandTypes() async {
    try {
      final packages = await getAllPackages();
      final commandTypes =
          packages.map((package) => package.commandType).toSet().toList();
      return commandTypes;
    } catch (e) {
      throw Exception('Error fetching command types: $e');
    }
  }
}

// StreamController for real-time updates
class PackageStreamService {
  static final Map<String, StreamController<List<Package>>> _controllers = {};
  static final Map<String, Timer> _timers = {};

  // Get packages stream by command type
  static Stream<List<Package>> getPackagesStreamByCommandType(
    String commandType,
  ) {
    final key = commandType.toLowerCase();

    if (!_controllers.containsKey(key)) {
      _controllers[key] = StreamController<List<Package>>.broadcast();

      // Initial fetch
      _fetchAndEmitPackages(key, commandType);

      // Set up periodic refresh (every 30 seconds)
      _timers[key] = Timer.periodic(Duration(seconds: 30), (timer) {
        _fetchAndEmitPackages(key, commandType);
      });
    }

    return _controllers[key]!.stream;
  }

  static void _fetchAndEmitPackages(String key, String commandType) async {
    try {
      final packages = await ApiService.getPackagesByCommandType(commandType);
      if (_controllers[key] != null && !_controllers[key]!.isClosed) {
        _controllers[key]!.add(packages);
      }
    } catch (e) {
      if (_controllers[key] != null && !_controllers[key]!.isClosed) {
        _controllers[key]!.addError(e);
      }
    }
  }

  // Refresh specific command type stream
  static void refreshCommandTypeStream(String commandType) {
    final key = commandType.toLowerCase();
    if (_controllers.containsKey(key)) {
      _fetchAndEmitPackages(key, commandType);
    }
  }

  // Clean up resources
  static void dispose(String commandType) {
    final key = commandType.toLowerCase();
    _timers[key]?.cancel();
    _controllers[key]?.close();
    _timers.remove(key);
    _controllers.remove(key);
  }

  // Clean up all resources
  static void disposeAll() {
    for (var timer in _timers.values) {
      timer.cancel();
    }
    for (var controller in _controllers.values) {
      controller.close();
    }
    _timers.clear();
    _controllers.clear();
  }
}
