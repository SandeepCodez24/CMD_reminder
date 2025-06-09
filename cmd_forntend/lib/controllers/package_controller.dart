import 'package:cmd_forntend/api/api_service.dart';
import 'package:flutter/material.dart';

class PackageController extends ChangeNotifier {
  List<Package> _packages = [];
  List<Package> _filteredPackages = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedCommandType = '';

  // Getters
  List<Package> get packages => _packages;
  List<Package> get filteredPackages => _filteredPackages;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedCommandType => _selectedCommandType;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // CREATE - Add new package
  Future<bool> addPackage({
    required String packageName,
    required String packageVersion,
    required String packageDescription,
    required String packageDate,
    required String packageCode,
    required String commandType,
  }) async {
    _setLoading(true);
    clearError();

    try {
      final package = Package(
        packageName: packageName,
        packageVersion: packageVersion,
        packageDescription: packageDescription,
        packageDate: packageDate,
        packageCode: packageCode,
        commandType: commandType,
      );

      await ApiService.createPackage(package);
      await getAllPackages();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Error adding package: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // READ - Get all packages
  Future<void> getAllPackages() async {
    _setLoading(true);
    clearError();

    try {
      final result = await ApiService.getAllPackages();
      _packages = result;
      _filteredPackages = _packages.toList();
      _selectedCommandType = '';
    } catch (e) {
      _setError('Error getting packages: ${e.toString()}');
      _packages = [];
      _filteredPackages = [];
    }

    _setLoading(false);
  }

  // READ - Get packages by command type
  Future<void> getPackagesByType(String commandType) async {
    _setLoading(true);
    clearError();

    try {
      final result = await ApiService.getPackagesByCommandType(commandType);
      _filteredPackages = result;
      _selectedCommandType = commandType;
    } catch (e) {
      _setError('Error getting packages by type: ${e.toString()}');
      _filteredPackages = [];
    }

    _setLoading(false);
  }

  // READ - Get single package by ID
  Future<Package?> getPackageById(String id) async {
    _setLoading(true);
    try {
      final result = await ApiService.getPackageById(id);
      _setLoading(false);
      return result;
    } catch (e) {
      _setError('Error getting package: ${e.toString()}');
      _setLoading(false);
      return null;
    }
  }

  // UPDATE - Update existing package
  Future<bool> updatePackage({
    required String id,
    required String packageName,
    required String packageVersion,
    required String packageDescription,
    required String packageDate,
    required String packageCode,
    required String commandType,
  }) async {
    _setLoading(true);
    clearError();

    try {
      final package = Package(
        id: id,
        packageName: packageName,
        packageVersion: packageVersion,
        packageDescription: packageDescription,
        packageDate: packageDate,
        packageCode: packageCode,
        commandType: commandType,
      );

      await ApiService.updatePackage(id, package);
      await getAllPackages();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Error updating package: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // DELETE - Delete package
  Future<bool> deletePackage(String id) async {
    _setLoading(true);
    clearError();

    try {
      await ApiService.deletePackage(id);
      _packages.removeWhere((package) => package.id == id);
      _filteredPackages.removeWhere((package) => package.id == id);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error deleting package: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Filter packages locally
  void filterPackages(String query) {
    if (query.isEmpty) {
      _filteredPackages = _packages.toList();
    } else {
      _filteredPackages = _packages.where((package) =>
        package.packageName.toLowerCase().contains(query.toLowerCase()) ||
        package.packageDescription.toLowerCase().contains(query.toLowerCase()) ||
        package.commandType.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }

  // Reset filters
  void resetFilters() {
    _filteredPackages = _packages.toList();
    _selectedCommandType = '';
    notifyListeners();
  }
}