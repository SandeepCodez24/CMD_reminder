import 'package:cmd_forntend/api/api_service.dart';
import 'package:cmd_forntend/widgets/PackageDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Example usage in your container widgets
class PackageListWidget extends StatefulWidget {
  final String commandType;
  final String title;

  const PackageListWidget({
    super.key,
    required this.commandType,
    required this.title,
  });

  @override
  State<PackageListWidget> createState() => _PackageListWidgetState();
}

class _PackageListWidgetState extends State<PackageListWidget> {
  @override
  void dispose() {
    // Clean up the stream when widget is disposed
    PackageStreamService.dispose(widget.commandType);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.grey[850],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddPackageDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              PackageStreamService.refreshCommandTypeStream(widget.commandType);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Refreshing packages...')),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[900],
        child: StreamBuilder<List<Package>>(
          stream: PackageStreamService.getPackagesStreamByCommandType(widget.commandType),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'Loading ${widget.title} packages...',
                      style: GoogleFonts.openSans(color: Colors.white),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Error loading packages',
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: GoogleFonts.openSans(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        PackageStreamService.refreshCommandTypeStream(widget.commandType);
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final packages = snapshot.data ?? [];

            if (packages.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'No ${widget.title} packages found',
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add your first package using the + button',
                      style: GoogleFonts.openSans(color: Colors.white70),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showAddPackageDialog(context),
                      icon: Icon(Icons.add),
                      label: Text('Add Package'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                PackageStreamService.refreshCommandTypeStream(widget.commandType);
                await Future.delayed(Duration(seconds: 1));
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  final package = packages[index];
                  return _buildPackageCard(context, package);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, Package package) {
    return Card(
      color: Colors.grey[800],
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    package.packageName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    package.packageVersion,
                    style: GoogleFonts.openSans(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              package.packageDescription,
              style: GoogleFonts.openSans(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                package.packageCode,
                style: GoogleFonts.firaCode(
                  color: Colors.green[300],
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${package.packageDate}',
                  style: GoogleFonts.openSans(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _editPackage(context, package),
                      icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                    ),
                    IconButton(
                      onPressed: () => _deletePackage(context, package),
                      icon: Icon(Icons.delete, color: Colors.red, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPackageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PackageDialog();
      },
    ).then((_) {
      // Refresh the stream after dialog closes
      PackageStreamService.refreshCommandTypeStream(widget.commandType);
    });
  }

  void _editPackage(BuildContext context, Package package) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit functionality coming soon!')),
    );
  }

  void _deletePackage(BuildContext context, Package package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text('Delete Package', style: TextStyle(color: Colors.white)),
          content: Text(
            'Are you sure you want to delete "${package.packageName}"?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ApiService.deletePackage(package.id!);
                  Navigator.of(context).pop();
                  PackageStreamService.refreshCommandTypeStream(widget.commandType);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Package deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting package: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
