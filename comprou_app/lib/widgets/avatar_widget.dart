// lib/widgets/avatar_widget.dart
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../core/themes/cores.dart';

class AvatarWidget extends StatelessWidget {
  final String? fotoPath;
  final String nome;
  final double radius;
  final VoidCallback? onTap;
  final bool editavel;

  const AvatarWidget({
    super.key,
    required this.fotoPath,
    required this.nome,
    this.radius = 40,
    this.onTap,
    this.editavel = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: AppCores.verdePastel,
            backgroundImage: _getImageProvider(),
            child: fotoPath == null || fotoPath!.isEmpty
                ? Text(
                    _getIniciais(),
                    style: TextStyle(
                      fontSize: radius * 0.6,
                      fontWeight: FontWeight.bold,
                      color: AppCores.verdePrincipal,
                    ),
                  )
                : null,
          ),
          if (editavel)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppCores.verdePrincipal,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  ImageProvider? _getImageProvider() {
    if (fotoPath == null || fotoPath!.isEmpty) return null;
    
    // Verificar se é base64
    if (fotoPath!.startsWith('data:image')) {
      final base64String = fotoPath!.split(',').last;
      return MemoryImage(base64Decode(base64String));
    }
    
    // Para mobile (arquivo local)
    return FileImage(File(fotoPath!));
  }

  String _getIniciais() {
    final partes = nome.trim().split(' ');
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes[0][0].toUpperCase();
    return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
  }
}