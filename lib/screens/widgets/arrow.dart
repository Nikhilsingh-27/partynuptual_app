import 'package:flutter/material.dart';

class AnimatedErrorArrow extends StatefulWidget {
  final bool show;

  const AnimatedErrorArrow({super.key, required this.show});

  @override
  State<AnimatedErrorArrow> createState() => _AnimatedErrorArrowState();
}

class _AnimatedErrorArrowState extends State<AnimatedErrorArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.4, 0.4), // down-right
      end: const Offset(0, 0), // final position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant AnimatedErrorArrow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.show) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.show
        ? FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.red,
                size: 18,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
