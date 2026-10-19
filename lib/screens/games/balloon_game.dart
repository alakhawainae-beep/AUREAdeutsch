import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/vocab_word.dart';
import '../../services/content_service.dart';
import '../../services/tts_service.dart';
import '../../services/balloon_audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../theme/app_theme.dart';

class BalloonGame extends StatefulWidget {
  const BalloonGame({super.key});

  @override
  State<BalloonGame> createState() => _BalloonGameState();
}

class _BalloonGameState extends State<BalloonGame>
    with TickerProviderStateMixin {
  static const int _roundSeconds = 3;
  static const int _maxLives = 3;
  static const int _balloonCount = 4;

  final _random = Random();
  List<VocabWord> _words = [];
  final BalloonAudioService _audioService = BalloonAudioService();
final AudioPlayer _nativePlayer = AudioPlayer();
  List<_BalloonData> _balloons = [];
  VocabWord? _target;
  int _score = 0;
  int _lives = _maxLives;
  int _round = 0;
  bool _loading = true;
  bool _locked = false;
  bool _gameOver = false;
  double _timeLeft = _roundSeconds.toDouble();
  Timer? _tickTimer;
  Offset? _popPosition;
  String? _popArabic;
  late AnimationController _explosionCtrl;
  late AnimationController _floatCtrl;

  static const _colors = [
    Color(0xFFE85D4C),
    Color(0xFF3D8BDB),
    Color(0xFF45B36B),
    Color(0xFFF0B429),
    Color(0xFF9B59B6),
    Color(0xFFE67E22),
  ];

  @override
  void initState() {
    super.initState();
      _audioService.init(); // زيد هاد السطر

    _explosionCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _bootstrap();
  }
  

  Future<void> _bootstrap() async {
    final words = await ContentService.instance.loadWords();
    if (!mounted) return;
    setState(() {
      _words = List.of(words)..shuffle(_random);
      _loading = false;
    });
    _startRound();
  }

  void _startRound() {
    if (_lives <= 0 || _words.isEmpty) {
      setState(() => _gameOver = true);
      return;
    }

    _tickTimer?.cancel();
    final pool = List<VocabWord>.of(_words)..shuffle(_random);
    final chosen = pool.take(_balloonCount).toList();
    final target = chosen[_random.nextInt(chosen.length)];

    setState(() {
      _round++;
      _target = target;
      _locked = false;
      _timeLeft = _roundSeconds.toDouble();
      _popPosition = null;
      _popArabic = null;
      _balloons = List.generate(chosen.length, (i) {
        return _BalloonData(
          word: chosen[i],
          color: _colors[i % _colors.length],
          x: 0.08 + (i * 0.22) + _random.nextDouble() * 0.04,
          phase: _random.nextDouble() * pi * 2,
          speed: 0.7 + _random.nextDouble() * 0.5,
        );
      });
    });

    TtsService.instance.speakGerman(target.de);

    _tickTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted || _locked) return;
      setState(() => _timeLeft -= 0.05);
      if (_timeLeft <= 0) {
        _onMiss();
      }
    });
  }

  void _onMiss() {
    if (_locked) return;
    _locked = true;
    _tickTimer?.cancel();
    setState(() {
      _lives--;
      _timeLeft = 0;
    });
    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      if (_lives <= 0) {
        setState(() => _gameOver = true);
      } else {
        _startRound();
      }
    });
  }

  void _onPop(_BalloonData balloon, Offset globalPos) {
    if (_locked || _target == null) return;
    _locked = true;
    _tickTimer?.cancel();

    final correct = balloon.word.id == _target!.id;
    final box = context.findRenderObject() as RenderBox?;
    final local = box?.globalToLocal(globalPos) ?? globalPos;

    if (correct) {
    setState(() {
      _score += 10 + (_timeleft * 5).round();
      _popPosition = local;
      _popArabic = balloon.word.ar;
    });
    // 🔊 صوت أصلي من Wikimedia ولا TTS إلا ما لقاهش
    _audioService.playLetter(balloon.word.de);
    _explosionCtrl.forward(from: 0);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) _startRound();
      });
    } else {
      setState(() {
        _lives--;
        _popPosition = local;
        _popArabic = '✗ ${balloon.word.de}';
      });
      _explosionCtrl.forward(from: 0);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        if (_lives <= 0) {
          setState(() => _gameOver = true);
        } else {
          _startRound();
        }
      });
    }
  }

  void _restart() {
    setState(() {
      _score = 0;
      _lives = _maxLives;
      _round = 0;
      _gameOver = false;
      _words.shuffle(_random);
    });
    _startRound();
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _explosionCtrl.dispose();
    _floatCtrl.dispose();
    TtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87CEEB), Color(0xFFE8F6FF), Color(0xFFF7F2E8)],
          ),
        ),
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _gameOver
                  ? _GameOverPanel(
                      score: _score,
                      onRetry: _restart,
                      onHome: () => Navigator.pop(context),
                    )
                  : Column(
                      children: [
                        _Hud(
                          score: _score,
                          lives: _lives,
                          timeLeft: _timeLeft,
                          round: _round,
                          onSpeak: () {
                            if (_target != null) {
                              TtsService.instance.speakGerman(_target!.de);
                            }
                          },
                          onBack: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: AnimatedBuilder(
                            animation: _floatCtrl,
                            builder: (context, _) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ..._balloons.map((b) {
                                    final t = _floatCtrl.value * 2 * pi;
                                    final y = 0.55 -
                                        ((t * b.speed + b.phase) % (2 * pi)) /
                                            (2 * pi) *
                                            0.72;
                                    final x = b.x +
                                        sin(t * b.speed + b.phase) * 0.03;
                                    return Positioned(
                                      left: MediaQuery.sizeOf(context).width *
                                              x -
                                          48,
                                      top: MediaQuery.sizeOf(context).height *
                                              y *
                                              0.72 +
                                          20,
                                      child: _BalloonWidget(
                                        data: b,
                                        highlighted: false,
                                        onPop: (pos) => _onPop(b, pos),
                                      ),
                                    );
                                  }),
                                  if (_popPosition != null &&
                                      _popArabic != null)
                                    Positioned(
                                      left: _popPosition!.dx - 60,
                                      top: _popPosition!.dy - 40,
                                      child: _ExplosionBurst(
                                        controller: _explosionCtrl,
                                        arabic: _popArabic!,
                                      ),
                                    ),
                                  Positioned(
                                    left: 20,
                                    right: 20,
                                    bottom: 18,
                                    child: _ListenBanner(
                                      hint: 'Écoute et touche le bon ballon !',
                                      seconds: _timeLeft.ceil().clamp(0, 3),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _BalloonData {
  _BalloonData({
    required this.word,
    required this.color,
    required this.x,
    required this.phase,
    required this.speed,
  });

  final VocabWord word;
  final Color color;
  final double x;
  final double phase;
  final double speed;
}

class _BalloonWidget extends StatelessWidget {
  const _BalloonWidget({
    required this.data,
    required this.highlighted,
    required this.onPop,
  });

  final _BalloonData data;
  final bool highlighted;
  final ValueChanged<Offset> onPop;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) => onPop(d.globalPosition),
      child: SizedBox(
        width: 96,
        height: 130,
        child: Column(
          children: [
            Container(
              width: 88,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color.lerp(data.color, Colors.white, 0.35)!,
                    data.color,
                    Color.lerp(data.color, Colors.black, 0.2)!,
                  ],
                  center: const Alignment(-0.3, -0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: data.color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: highlighted
                    ? Border.all(color: Colors.white, width: 3)
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  data.word.de,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    height: 1.1,
                    shadows: [
                      Shadow(blurRadius: 4, color: Colors.black26),
                    ],
                  ),
                ),
              ),
            ),
            CustomPaint(
              size: const Size(4, 28),
              painter: _StringPainter(color: data.color.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StringPainter extends CustomPainter {
  _StringPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..quadraticBezierTo(size.width, size.height / 2, size.width / 2, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ExplosionBurst extends StatelessWidget {
  const _ExplosionBurst({
    required this.controller,
    required this.arabic,
  });

  final AnimationController controller;
  final String arabic;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = Curves.easeOut.transform(controller.value);
        return Opacity(
          opacity: (1 - t).clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.6 + t * 1.4,
            child: Column(
              children: [
                Text(
                  '💥',
                  style: TextStyle(fontSize: 28 + t * 20),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.forest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    arabic,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Hud extends StatelessWidget {
  const _Hud({
    required this.score,
    required this.lives,
    required this.timeLeft,
    required this.round,
    required this.onSpeak,
    required this.onBack,
  });

  final int score;
  final int lives;
  final double timeLeft;
  final int round;
  final VoidCallback onSpeak;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
      child: Row(
        children: [
          IconButton(onPressed: onBack, icon: const Icon(Icons.close_rounded)),
          Text('Manche $round', style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          IconButton(
            onPressed: onSpeak,
            icon: const Icon(Icons.volume_up_rounded),
            color: AppTheme.forest,
          ),
          Text(
            '$score',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: AppTheme.forest,
            ),
          ),
          const SizedBox(width: 12),
          ...List.generate(
            3,
            (i) => Icon(
              i < lives ? Icons.favorite : Icons.favorite_border,
              color: const Color(0xFFE85D4C),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListenBanner extends StatelessWidget {
  const _ListenBanner({required this.hint, required this.seconds});

  final String hint;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🎧', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hint,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: seconds <= 1
                  ? const Color(0xFFE85D4C)
                  : AppTheme.goldDeep,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$seconds',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameOverPanel extends StatelessWidget {
  const _GameOverPanel({
    required this.score,
    required this.onRetry,
    required this.onHome,
  });

  final int score;
  final VoidCallback onRetry;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎈', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              'Partie terminée',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Score : $score',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.goldDeep,
                  ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.forest,
                minimumSize: const Size(220, 48),
              ),
              child: const Text('Rejouer'),
            ),
            const SizedBox(height: 10),
            TextButton(onPressed: onHome, child: const Text('Accueil')),
          ],
        ),
      ),
    );
  }
}
