import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopSnackBarManager {
  static OverlayEntry? _currentEntry;

  static void showWithAnimation(BuildContext context, String message) {
    _currentEntry?.remove();
    _currentEntry = null;

    _currentEntry = OverlayEntry(
      builder:
          (context) => _AnimatedTopSnackBar(
            message: message,
            onDismiss: () {
              _currentEntry?.remove();
              _currentEntry = null;
            },
          ),
    );

    Overlay.of(context, rootOverlay: true).insert(_currentEntry!);
  }

  static void showWithoutAnimation(BuildContext context, String message) {
    _currentEntry?.remove();
    _currentEntry = null;

    _currentEntry = OverlayEntry(
      builder:
          (context) => _StaticTopSnackBar(
            message: message,
            onDismiss: () {
              _currentEntry?.remove();
              _currentEntry = null;
            },
          ),
    );

    Overlay.of(context, rootOverlay: true).insert(_currentEntry!);
  }
}

class _AnimatedTopSnackBar extends HookWidget {
  final String message;
  final VoidCallback onDismiss;

  const _AnimatedTopSnackBar({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final slideAnimation = useMemoized(
      () => Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.ease)),
      [controller],
    );

    final opacityAnimation = useMemoized(
      () => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn)),
      [controller],
    );

    useAnimation(slideAnimation);
    useAnimation(opacityAnimation);

    useEffect(() {
      controller.forward();

      final timer = Timer(const Duration(seconds: 3), () async {
        await controller.reverse();
        onDismiss();
      });

      return () => timer.cancel();
    }, []);

    final dismiss = useCallback(() async {
      // await controller.reverse();
      onDismiss();
    }, [controller, onDismiss]);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: opacityAnimation,
          child: Material(
            elevation: 6.0,
            borderRadius: BorderRadius.circular(8),
            child: GestureDetector(
              onTap: dismiss,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StaticTopSnackBar extends HookWidget {
  final String message;
  final VoidCallback onDismiss;

  const _StaticTopSnackBar({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final timer = Timer(const Duration(seconds: 3), onDismiss);
      return () => timer.cancel();
    }, []);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Material(
        elevation: 6.0,
        borderRadius: BorderRadius.circular(8),
        child: GestureDetector(
          onTap: onDismiss,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
