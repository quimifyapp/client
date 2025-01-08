import 'package:flutter/material.dart';
import 'dart:math';

class ParticleEffect extends StatefulWidget {
  final int numberOfParticles;
  final Color particleColor;
  final Color lineColor;
  final double particleSpeed; // New parameter for speed control

  const ParticleEffect({
    Key? key,
    this.numberOfParticles = 80,
    this.particleColor = const Color(0xFF47d7b0),
    this.lineColor = const Color(0xFF53e0d5),
    this.particleSpeed = 0.0008, // Default speed value
  }) : super(key: key);

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with SingleTickerProviderStateMixin {
  final List<Particle> particles = [];
  final Random random = Random();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {
          _updateParticles();
        });
      });

    _animationController.repeat();

    for (int i = 0; i < widget.numberOfParticles; i++) {
      particles.add(Particle(random, widget.particleSpeed));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(
        particles: particles,
        particleColor: widget.particleColor,
        lineColor: widget.lineColor,
      ),
      child: Container(),
    );
  }

  void _updateParticles() {
    for (var particle in particles) {
      particle.update();
    }
  }
}

class Particle {
  late double x;
  late double y;
  final double speed;
  late double theta;
  final Random random;
  late double dx;
  late double dy;

  Particle(this.random, this.speed) {
    reset();
  }

  void reset() {
    x = random.nextDouble();
    y = random.nextDouble();
    theta = random.nextDouble() * 2 * pi;
    // Use the fixed speed parameter
    dx = cos(theta) * speed;
    dy = sin(theta) * speed;
  }

  void update() {
    // Add small random variations to direction
    dx += (random.nextDouble() - 0.5) * 0.0001;
    dy += (random.nextDouble() - 0.5) * 0.0001;

    // Normalize the velocity to maintain constant speed
    double newSpeed = sqrt(dx * dx + dy * dy);
    dx = (dx / newSpeed) * speed;
    dy = (dy / newSpeed) * speed;

    x += dx;
    y += dy;

    // Bounce off edges
    if (x < 0 || x > 1) {
      dx = -dx;
      x = x < 0 ? 0 : 1;
    }
    if (y < 0 || y > 1) {
      dy = -dy;
      y = y < 0 ? 0 : 1;
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color particleColor;
  final Color lineColor;
  final double connectionDistance = 0.15;

  ParticlePainter({
    required this.particles,
    required this.particleColor,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = particleColor
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = lineColor.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw particles
    for (var particle in particles) {
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        3,
        paint,
      );
    }

    // Draw connections
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < connectionDistance) {
          canvas.drawLine(
            Offset(particles[i].x * size.width, particles[i].y * size.height),
            Offset(particles[j].x * size.width, particles[j].y * size.height),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
