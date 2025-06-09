class PackageModel {
  final String? id;
  final String packageName;
  final String packageVersion;
  final String packageDescription;
  final String packageDate;
  final String packageCode;
  final String commandType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PackageModel({
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

  // Factory constructor to create PackageModel from JSON
  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['_id'] ?? json['id'],
      packageName: json['packageName'] ?? '',
      packageVersion: json['packageVersion'] ?? '',
      packageDescription: json['packageDescription'] ?? '',
      packageDate: json['packageDate'] ?? '',
      packageCode: json['packageCode'] ?? '',
      commandType: json['commandType'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  // Method to convert PackageModel to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'Package_Name': packageName,
      'Package_Version': packageVersion,
      'Package_Description': packageDescription,
      'Package_Date': packageDate,
      'Package_Code': packageCode,
      'Command_Type': commandType,
    };
  }

  // Method to convert PackageModel to JSON for display
  Map<String, dynamic> toDisplayJson() {
    return {
      'id': id,
      'packageName': packageName,
      'packageVersion': packageVersion,
      'packageDescription': packageDescription,
      'packageDate': packageDate,
      'packageCode': packageCode,
      'commandType': commandType,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method for updates
  PackageModel copyWith({
    String? id,
    String? packageName,
    String? packageVersion,
    String? packageDescription,
    String? packageDate,
    String? packageCode,
    String? commandType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PackageModel(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      packageVersion: packageVersion ?? this.packageVersion,
      packageDescription: packageDescription ?? this.packageDescription,
      packageDate: packageDate ?? this.packageDate,
      packageCode: packageCode ?? this.packageCode,
      commandType: commandType ?? this.commandType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'PackageModel(id: $id, packageName: $packageName, packageVersion: $packageVersion, commandType: $commandType)';
  }
}

// Command Types Constants
class CommandTypes {
  static const String windowCommands = 'Window Commands';
  static const String flutterCommands = "Flutter Commands";
  static const String gitCommands = 'Git Commands';
  static const String mlPackage = "ML Packages";
  static const String firebaseCommands = "Firebase Commands";
  static const String pythonCommands = "Python Commands";
  static const String linuxCommands = "Linux Commands";
  static const String macOScommands = "Mac Commands";

  static List<String> get allTypes => [
    windowCommands,
    flutterCommands,
    gitCommands,
    mlPackage,
    firebaseCommands,
    pythonCommands,
    linuxCommands,
    macOScommands,
  ];
}