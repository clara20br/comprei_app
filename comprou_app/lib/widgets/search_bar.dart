import 'package:flutter/material.dart';
import '../core/themes/cores.dart';
import '../core/constants/constants.dart';

class SearchBar extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final TextEditingController? controller;

  const SearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedio),
      child: Container(
        decoration: BoxDecoration(
          color: AppCores.cinzaClaro,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(Icons.search, color: AppCores.cinzaEscuro),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}