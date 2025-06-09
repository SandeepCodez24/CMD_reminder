import 'package:cmd_forntend/api/api_service.dart';
import 'package:cmd_forntend/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PackageDialog extends StatefulWidget {
  const PackageDialog({super.key});

  @override
  State<PackageDialog> createState() => _PackageDialogState();
}

class _PackageDialogState extends State<PackageDialog> {
  final _formKey = GlobalKey<FormState>();
  final _packageNameController = TextEditingController();
  final _packageVersionController = TextEditingController();
  final _packageDescriptionController = TextEditingController();
  final _packageCodeController = TextEditingController();
  final _packageDateController = TextEditingController();
  String? selectedPAckagedomain;

  @override
  void dispose() {
    _packageNameController.dispose();
    _packageVersionController.dispose();
    _packageDescriptionController.dispose();
    _packageCodeController.dispose();
    _packageDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: screenWidth * 0.6,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // form Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add New Package',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: screenWidth * 0.015,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: Colors.black),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Package Name Field
                _customDropDownField(
                  context: context,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
                _customTextFormField(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  maxlines: 1,
                  controller: _packageNameController,
                  label: 'Package Name',
                  hint: 'Enter package name',
                  icon: Icons.inventory_2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Package name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Package Version Field
                _customTextFormField(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  controller: _packageVersionController,
                  label: 'Package Version',
                  hint: 'e.g., 1.0.0',
                  maxlines: 1,
                  icon: Icons.tag,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Package version is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Package Description Field
                _customTextFormField(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  controller: _packageDescriptionController,
                  label: 'Package Description',
                  hint: 'Enter package description',
                  icon: Icons.description,
                  maxlines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Package description is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Package Code Field
                _customTextFormField(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  controller: _packageCodeController,
                  label: 'Package Code',
                  hint: 'Enter package code',
                  maxlines: 4,
                  icon: Icons.code,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Package code is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Package Date Field
                _customDateField(
                  context: context,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  controller: _packageDateController,
                ),
                SizedBox(height: 32),
                _customSubimtButton(
                  context: context,
                  formKey: _formKey,
                  packageCodeController: _packageCodeController,
                  packageNameController: _packageNameController,
                  packageVersionController: _packageVersionController,
                  packageDescriptionController: _packageDescriptionController,
                  packageDateController: _packageDateController,
                  selectedPackage: selectedPAckagedomain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customDropDownField({
    required BuildContext context,
    required double screenWidth,
    required double screenHeight,
  }) {
    final List<String> boxName = [
      AppStrings.ML_Package,
      AppStrings.firebaseCommands,
      AppStrings.flutterCommands,
      AppStrings.gitCommands,
      AppStrings.linuxCommands,
      AppStrings.macOScommands,
      AppStrings.python_Commands,
      AppStrings.windowComands,
    ];

    // Initialize selectedPAckagedomain if it's null
    selectedPAckagedomain ??= boxName[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Domain',
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedPAckagedomain,
          decoration: InputDecoration(
            hintText: 'Select domain',
            hintStyle: GoogleFonts.openSans(color: Colors.black),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFe0e1dd)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2a9d8f)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a domain';
            }
            return null;
          },
          items:
              boxName.map((String package) {
                return DropdownMenuItem<String>(
                  value: package,
                  child: Text(
                    package,
                    style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
          onChanged: (String? package) {
            setState(() {
              selectedPAckagedomain = package;
            });
          },
        ),
      ],
    );
  }

  Widget _customTextFormField({
    required double screenHeight,
    required double screenWidth,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required int maxlines,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: screenWidth * 0.011,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxlines,
          validator: validator,
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.white70,
              fontWeight: FontWeight.w300,
            ),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _customDateField({
    required BuildContext context,
    required double screenWidth,
    required double screenHeight,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Package Date',
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Package date is required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Select date',
            hintStyle: TextStyle(color: Colors.white54),
            prefixIcon: Icon(Icons.calendar_today, color: Colors.white70),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              firstDate: DateTime(2006),
              lastDate: DateTime(2026),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      surface: Colors.grey[800]!,
                      onSurface: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              controller.text =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
            }
          },
        ),
      ],
    );
  }

  Widget _customSubimtButton({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController packageNameController,
    required TextEditingController packageVersionController,
    required TextEditingController packageDescriptionController,
    required TextEditingController packageCodeController,
    required TextEditingController packageDateController,
    required String? selectedPackage,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isLoading = false;

        return ElevatedButton(
          onPressed:
              isLoading
                  ? null
                  : () async {
                    if (formKey.currentState!.validate()) {
                      // Validate that a package domain is selected
                      if (selectedPackage == null || selectedPackage.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select a package domain'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      try {
                        // Create Package object with correct field names matching your backend schema
                        final package = Package(
                          packageName: packageNameController.text.trim(),
                          packageVersion: packageVersionController.text.trim(),
                          packageDescription:
                              packageDescriptionController.text.trim(),
                          packageDate: packageDateController.text.trim(),
                          packageCode: packageCodeController.text.trim(),
                          commandType:
                              selectedPackage, // This matches your backend 'commandType' field
                        );

                        // Call API service to create package
                        await ApiService.createPackage(package);

                        // Close the dialog first
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }

                        // Show success message after a small delay
                        await Future.delayed(Duration(milliseconds: 100));

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Package "${packageNameController.text}" added successfully!',
                              ),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });

                        // Show error message
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error adding package: ${e.toString()}',
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      }
                    }
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: isLoading ? Colors.grey : Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          child:
              isLoading
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Adding...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                  : Text(
                    'Add Package',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
        );
      },
    );
  }
}
