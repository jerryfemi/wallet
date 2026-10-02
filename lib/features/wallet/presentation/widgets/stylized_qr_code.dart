import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StylizedQrCode extends StatelessWidget {
  final String data;
  final String imageUrl;
  final double size;

  const StylizedQrCode({
    super.key,
    required this.data,
    required this.imageUrl,
    this.size = 280,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return SizedBox(
      width: size + 40,
      height: size + 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The organic/wavy background layers
          _OrganicBlob(
            color: bgColor.withValues(alpha: 0.5),
            size: size + 40,
            rotation: 0.2,
          ),
          _OrganicBlob(
            color: bgColor.withValues(alpha: 0.8),
            size: size + 20,
            rotation: -0.1,
          ),
          _OrganicBlob(
            color: bgColor,
            size: size + 10,
            rotation: 0.05,
          ),
          
          // The actual QR Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: QrImageView(
              data: data,
              version: QrVersions.auto,
              size: size - 32,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.circle,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: Colors.black,
              ),
              // We use a custom painter to draw the network image in the center
              // because qr_flutter embeddedImage is tricky with network images.
              // Instead, we just leave an empty spot and overlay it.
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(48, 48),
              ),
            ),
          ),

          // Center Logo Overlay
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            padding: const EdgeInsets.all(4),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrganicBlob extends StatelessWidget {
  final Color color;
  final double size;
  final double rotation;

  const _OrganicBlob({
    required this.color,
    required this.size,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size * 0.4),
            topRight: Radius.circular(size * 0.3),
            bottomLeft: Radius.circular(size * 0.35),
            bottomRight: Radius.circular(size * 0.45),
          ),
        ),
      ),
    );
  }
}
