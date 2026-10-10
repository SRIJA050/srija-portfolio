import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const SrijaPortfolio());
}

// DEEP BLUE COLOUR PALETTE
const Color midnight = Color(0xFF061126);
const Color deepBlue = Color(0xFF07152F);
const Color navyBlue = Color(0xFF102A56);
const Color royalBlue = Color(0xFF285A9E);
const Color starBlue = Color(0xFF8ABFFF);
const Color lightBlue = Color(0xFFB7C9E8);
const Color pureWhite = Color(0xFFFFFFFF);

class SrijaPortfolio extends StatelessWidget {
  const SrijaPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Srija Portfolio',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: midnight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: royalBlue,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Arial',
      ),
      home: const LoginPage(),
    );
  }
}

// ANIMATED STAR BACKGROUND

class StarryBackground extends StatefulWidget {
  const StarryBackground({super.key});

  @override
  State<StarryBackground> createState() => _StarryBackgroundState();
}

class _StarryBackgroundState extends State<StarryBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: StarPainter(_controller),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class Star {
  final double x;
  final double y;
  final double radius;
  final double phase;
  final double speed;

  const Star(this.x, this.y, this.radius, this.phase, this.speed);
}

class StarPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Star> stars;

  StarPainter(this.animation)
      : stars = List.generate(130, (index) {
          final random = math.Random(index * 31 + 7);
          return Star(
            random.nextDouble(),
            random.nextDouble(),
            0.6 + random.nextDouble() * 1.8,
            random.nextDouble() * math.pi * 2,
            0.5 + random.nextDouble() * 2,
          );
        }),
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final time = animation.value * 2 * math.pi;

    for (final star in stars) {
      final twinkle = (math.sin(time * star.speed + star.phase) + 1) / 2;
      final opacity = 0.08 + twinkle * 0.85;

      final paint = Paint()
        ..color = Color.lerp(
          const Color(0xFF7FB8FF),
          pureWhite,
          twinkle,
        )!
            .withValues(alpha: opacity);

      final position = Offset(
        star.x * size.width,
        star.y * size.height,
      );

      if (twinkle > 0.78) {
        final glow = Paint()
          ..color = starBlue.withValues(
            alpha: (twinkle - 0.78) * 0.6,
          )
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            5,
          );

        canvas.drawCircle(
          position,
          star.radius * 2.5,
          glow,
        );
      }

      canvas.drawCircle(
        position,
        star.radius * (0.7 + twinkle * 0.6),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant StarPainter oldDelegate) => false;
}

// REUSABLE GLASS-LIKE BLUE PANEL

class BluePanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const BluePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: navyBlue.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: starBlue.withValues(alpha: 0.30),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

// LOGIN PAGE

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _hidePassword = true;
  String? _errorMessage;

  void _login() {
    // Demo credentials: username srija, password srija123.
    if (_usernameController.text.trim() == 'srija' &&
        _passwordController.text == 'srija123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PortfolioHome(),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Incorrect username or password.';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: midnight,
      body: Stack(
        children: [
          const Positioned.fill(child: StarryBackground()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 38,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1B38).withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFF8ABFFF).withValues(alpha: 0.75),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF4D9FFF).withValues(alpha: 0.20),
                          blurRadius: 35,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF102A56),
                            border: Border.all(
                              color: const Color(0xFF8ABFFF),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4D9FFF)
                                    .withValues(alpha: 0.45),
                                blurRadius: 28,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/srija.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Color(0xFFB7C9E8),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'SRIJA',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            color: pureWhite,
                            letterSpacing: 5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'ENGINEERING  •  INNOVATION  •  AMBITION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: lightBlue,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Welcome to my universe',
                            style: TextStyle(
                              color: pureWhite,
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Sign in to explore my journey.',
                            style: TextStyle(
                              color: lightBlue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextField(
                          controller: _usernameController,
                          style: const TextStyle(color: pureWhite),
                          decoration: _inputDecoration(
                            'Username',
                            Icons.person_outline,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: _hidePassword,
                          style: const TextStyle(color: pureWhite),
                          onSubmitted: (_) => _login(),
                          decoration: _inputDecoration(
                            'Password',
                            Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: lightBlue,
                              ),
                            ),
                          ),
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 14),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Color(0xFFFFA5B5),
                            ),
                          ),
                        ],
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: royalBlue,
                              foregroundColor: pureWhite,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                  color: starBlue.withValues(alpha: 0.55),
                                ),
                              ),
                            ),
                            child: const Text(
                              'ENTER MY PORTFOLIO',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'A journey of learning and creating.',
                          style: TextStyle(
                            color: lightBlue,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: lightBlue),
      prefixIcon: Icon(icon, color: starBlue),
      filled: true,
      fillColor: deepBlue.withValues(alpha: 0.85),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: starBlue.withValues(alpha: 0.28),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: starBlue,
          width: 1.5,
        ),
      ),
    );
  }
}

// PORTFOLIO HOME

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  int _selectedIndex = 0;

  // "Projects" added at index 2.
  final List<String> _sections = [
    'Home',
    'Academic Details',
    'Projects',
    'Certificates',
    'Extracurricular Activities',
    'Achievements',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: midnight,
      body: Stack(
        children: [
          const Positioned.fill(child: StarryBackground()),
          SafeArea(
            child: Column(
              children: [
                _buildNavigation(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 700),
                    reverseDuration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey(_selectedIndex),
                      child: _buildSection(_selectedIndex),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _buildLogoutButton() {
    final isNarrow = MediaQuery.of(context).size.width < 700;

    if (isNarrow) {
      return IconButton(
        tooltip: 'Logout',
        onPressed: _logout,
        icon: const Icon(Icons.logout, color: starBlue),
        style: IconButton.styleFrom(
          side: BorderSide(color: starBlue.withValues(alpha: 0.6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: _logout,
      icon: const Icon(Icons.logout, size: 18),
      label: const Text('Logout'),
      style: OutlinedButton.styleFrom(
        foregroundColor: starBlue,
        side: BorderSide(color: starBlue.withValues(alpha: 0.6)),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: deepBlue.withValues(alpha: 0.88),
        border: Border(
          bottom: BorderSide(
            color: starBlue.withValues(alpha: 0.25),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: starBlue,
                    size: 25,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'SRIJA',
                    style: TextStyle(
                      color: pureWhite,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(width: 28),
                  for (int i = 0; i < _sections.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextButton(
                        onPressed: () {
                          setState(() => _selectedIndex = i);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor:
                              _selectedIndex == i ? pureWhite : lightBlue,
                          backgroundColor: _selectedIndex == i
                              ? royalBlue.withValues(alpha: 0.65)
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(_sections[i]),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildSection(int index) {
    switch (index) {
      case 0:
        return _homeSection();
      case 1:
        return _academicDetailsSection();
      case 2:
        return const ProjectsSection();
      case 3:
        return _certificatesSection();
      case 4:
        return _extracurricularSection();
      case 5:
        return _achievementsSection();
      default:
        return _homeSection();
    }
  }

  Widget _academicDetailsSection() {
    const lightBlue = Color(0xFF8ABFFF);
    const textBlue = Color(0xFFB7C9E8);
    const borderBlue = Color(0xFF285A9E);

    final details = [
      ['10th Class', 'ZPHS Chintalakunta', '2022'],
      ['Intermediate', 'SR Junior College', '2022–2024'],
      [
        'B.Tech CSE',
        'BVRIT Hyderabad College of Engineering for Women',
        '2024–2028',
      ],
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF07152F).withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderBlue, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: lightBlue.withValues(alpha: 0.08),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Academic Details',
                  style: TextStyle(
                    color: lightBlue,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'My educational journey',
                  style: TextStyle(color: textBlue, fontSize: 16),
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      const Color(0xFF102A56),
                    ),
                    border: TableBorder.all(
                      color: borderBlue.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Qualification',
                          style: TextStyle(
                            color: lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Institution',
                          style: TextStyle(
                            color: lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Year',
                          style: TextStyle(
                            color: lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows: details.map((item) {
                      return DataRow(
                        cells: item.map((value) {
                          return DataCell(
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                value,
                                style: const TextStyle(
                                  color: textBlue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _certificatesSection() {
    final certificates = [
      {
        'title': 'CodeChef DSA',
        'logo': 'assets/images/codechef_logo.png',
        'certificate': 'assets/images/codechef_dsa.png',
      },
      {
        'title': 'CodeChef OOPS',
        'logo': 'assets/images/codechef_logo.png',
        'certificate': 'assets/images/codechef_oops.png',
      },
      {
        'title': 'Infosys CSS',
        'logo': 'assets/images/infosys_logo.png',
        'certificate': 'assets/images/infosys_css.png',
      },
      {
        'title': 'Infosys HTML',
        'logo': 'assets/images/html_logo.png',
        'certificate': 'assets/images/infosys_html.png',
      },
      {
        'title': 'Infosys JavaScript',
        'logo': 'assets/images/javascript_logo.png',
        'certificate': 'assets/images/infosys_javascript.png',
      },
      {
        'title': 'Infosys Networking',
        'logo': 'assets/images/network_logo.png',
        'certificate': 'assets/images/infosys_network.png',
      },
      {
        'title': 'Python Excellence',
        'logo': 'assets/images/python_logo.png',
        'certificate': 'assets/images/python_excellence.png',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: const Column(
              children: [
                Text(
                  'My Certificates',
                  style: TextStyle(
                    color: Color(0xFF8ABFFF),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Click a logo to view the certificate',
                  style: TextStyle(color: Color(0xFFB7C9E8)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 850
                  ? 4
                  : constraints.maxWidth > 500
                      ? 3
                      : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: certificates.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  // FIX: taller cards on phones (2 columns) to avoid overflow
                  childAspectRatio: columns == 2 ? 0.75 : 0.9,
                ),
                itemBuilder: (context, index) {
                  final cert = certificates[index];
                  bool isHovered = false;

                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 450 + index * 100),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 25 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: StatefulBuilder(
                      builder: (context, setCardState) {
                        return MouseRegion(
                          onEnter: (_) => setCardState(() => isHovered = true),
                          onExit: (_) => setCardState(() => isHovered = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            transform: Matrix4.translationValues(
                              0,
                              isHovered ? -7 : 0,
                              0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF102044)
                                  .withValues(alpha: 0.88),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isHovered
                                    ? const Color(0xFF8ABFFF)
                                    : const Color(0xFF285A9E),
                                width: isHovered ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF8ABFFF).withValues(
                                    alpha: isHovered ? 0.30 : 0.08,
                                  ),
                                  blurRadius: isHovered ? 24 : 12,
                                  spreadRadius: isHovered ? 2 : 0,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel: 'Close certificate',
                                    barrierColor:
                                        Colors.black.withValues(alpha: 0.75),
                                    transitionDuration:
                                        const Duration(milliseconds: 300),
                                    pageBuilder: (
                                      dialogContext,
                                      animation,
                                      secondaryAnimation,
                                    ) {
                                      return Dialog(
                                        backgroundColor:
                                            const Color(0xFF07152F),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: const BorderSide(
                                            color: Color(0xFF285A9E),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  cert['title']!,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color(0xFF8ABFFF),
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Image.asset(
                                                  cert['certificate']!,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return const Padding(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Text(
                                                        'Certificate image not found. Check the file path.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                const SizedBox(height: 12),
                                                TextButton.icon(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                    dialogContext,
                                                  ),
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Color(0xFF8ABFFF),
                                                  ),
                                                  label: const Text(
                                                    'Close',
                                                    style: TextStyle(
                                                      color: Color(0xFF8ABFFF),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    transitionBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      final curved = CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutBack,
                                      );

                                      return FadeTransition(
                                        opacity: animation,
                                        child: ScaleTransition(
                                          scale: curved,
                                          child: child,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 220),
                                        width: 85,
                                        height: 85,
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFF07152F),
                                          border: Border.all(
                                            color: const Color(0xFF8ABFFF),
                                            width: isHovered ? 3 : 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF8ABFFF)
                                                  .withValues(
                                                alpha: isHovered ? 0.45 : 0.12,
                                              ),
                                              blurRadius: isHovered ? 20 : 8,
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          cert['logo']!,
                                          fit: BoxFit.contain,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Icon(
                                              Icons.workspace_premium,
                                              color: Color(0xFF8ABFFF),
                                              size: 42,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        cert['title']!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Color(0xFFB7C9E8),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Icon(
                                        Icons.open_in_new,
                                        color: Color(0xFF8ABFFF),
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _extracurricularSection() {
    final activities = [
      {
        'title': 'Innovation & Leadership',
        'subtitle': 'Ignite Innovation',
        'description':
            'Coordinating an innovation event and collaborating with participants.',
        'icon': Icons.lightbulb_outline,
      },
      {
        'title': 'Entrepreneurship',
        'subtitle': 'Ideas into Action',
        'description':
            'Exploring entrepreneurial ideas, creativity, and problem-solving.',
        'icon': Icons.rocket_launch_outlined,
      },
      {
        'title': 'Startup Journey',
        'subtitle': 'Srija Green Galaxy',
        'description':
            'Learning through startup development and sustainable innovation.',
        'icon': Icons.eco_outlined,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 25 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: const Column(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF8ABFFF),
                  size: 36,
                ),
                SizedBox(height: 12),
                Text(
                  'Beyond the Classroom',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8ABFFF),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Experiences that inspire me to learn, lead, and create.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFB7C9E8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 850
                  ? 3
                  : constraints.maxWidth > 520
                      ? 2
                      : 1;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  mainAxisExtent: 230,
                ),
                itemBuilder: (context, index) {
                  final activity = activities[index];

                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(
                      milliseconds: 500 + (index * 180),
                    ),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: _activityGlowCard(
                      title: activity['title'] as String,
                      subtitle: activity['subtitle'] as String,
                      description: activity['description'] as String,
                      icon: activity['icon'] as IconData,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 55),
          const MemoryGallery(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _activityGlowCard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
  }) {
    // FIX: isHovered must live OUTSIDE the builder, otherwise it resets
    // to false on every rebuild and the hover effect never shows.
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setCardState) {
        return MouseRegion(
          onEnter: (_) => setCardState(() => isHovered = true),
          onExit: (_) => setCardState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(
              0,
              isHovered ? -7 : 0,
              0,
            ),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF102044).withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isHovered
                    ? const Color(0xFF8ABFFF)
                    : const Color(0xFF285A9E),
                width: isHovered ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8ABFFF).withValues(
                    alpha: isHovered ? 0.28 : 0.07,
                  ),
                  blurRadius: isHovered ? 24 : 12,
                  spreadRadius: isHovered ? 1 : 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF07152F),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF8ABFFF),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8ABFFF).withValues(
                          alpha: isHovered ? 0.35 : 0.08,
                        ),
                        blurRadius: isHovered ? 18 : 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF8ABFFF),
                    size: isHovered ? 31 : 28,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF8ABFFF),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFFB7C9E8),
                      fontSize: 12,
                      height: 1.4,
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

  Widget _homeSection() {
    return SingleChildScrollView(
      key: const ValueKey('home'),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 680;

                  final intro = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'WELCOME TO MY UNIVERSE',
                        style: TextStyle(
                          color: starBlue,
                          letterSpacing: 3,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        "Hi, I'm",
                        style: TextStyle(
                          color: lightBlue,
                          fontSize: 25,
                        ),
                      ),
                      const Text(
                        'A Srija.',
                        style: TextStyle(
                          color: pureWhite,
                          fontSize: 58,
                          fontWeight: FontWeight.bold,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Developer  •  Innovator  •  Entrepreneur',
                        style: TextStyle(
                          color: starBlue,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Computer Science Engineering student passionate '
                        'about coding, problem-solving, technology, and '
                        'creating meaningful digital experiences.',
                        style: TextStyle(
                          color: lightBlue,
                          fontSize: 15,
                          height: 1.9,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // Opens the new Projects page (index 2)
                              setState(() => _selectedIndex = 2);
                            },
                            icon: const Icon(Icons.rocket_launch_outlined),
                            label: const Text('Explore My Work'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: royalBlue,
                              foregroundColor: pureWhite,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final uri = Uri.base.resolve('resume/srija_resume.pdf');
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            },
                            icon: const Icon(Icons.description_outlined),
                            label: const Text('Resume'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: starBlue,
                              side: const BorderSide(color: starBlue),
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              await launchUrl(
                                Uri.parse(
                                  'https://www.linkedin.com/in/a-srija-120b14329/',
                                ),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            icon: const Icon(Icons.work_outline),
                            label: const Text('LinkedIn'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: starBlue,
                              side: const BorderSide(color: starBlue),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 15,
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await launchUrl(
                                Uri.parse('https://github.com/SRIJA050'),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            icon: const Icon(Icons.code),
                            label: const Text('GitHub'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: starBlue,
                              side: const BorderSide(color: starBlue),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );

                  const photo = ProfileSummaryCard();

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 3, child: intro),
                        const SizedBox(width: 35),
                        const Expanded(flex: 2, child: photo),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      photo,
                      const SizedBox(height: 30),
                      intro,
                    ],
                  );
                },
              ),
              const SizedBox(height: 45),
              const SizedBox(height: 35),
              const SizedBox(height: 20),
              const CodingPlatformsSection(),
              const SizedBox(height: 55),
              // NEW: Technical Skills below Coding Platforms
              const TechnicalSkillsSection(),
              const SizedBox(height: 55),
              const Center(
                child: Text(
                  'DREAM  •  LEARN  •  CREATE  •  GROW',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: lightBlue,
                    letterSpacing: 2,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _achievementsSection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 35,
        ),
        child: Column(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  const Text(
                    'THE JOURNEY OF AN INNOVATOR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF8ABFFF),
                      fontSize: 13,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'SRIJA GREEN GALAXY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: const Color(0xFF4D9DFF)
                              .withValues(alpha: 0.9),
                          blurRadius: 25,
                        ),
                        Shadow(
                          color: const Color(0xFF285A9E)
                              .withValues(alpha: 0.8),
                          blurRadius: 45,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'FOUNDER  •  DIRECTOR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB7C9E8),
                      fontSize: 16,
                      letterSpacing: 5,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: 100,
                    height: 2,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8ABFFF),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF285A9E),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 55),
            const Text(
              'MILESTONES & AWARDS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 30),
            const AwardMarquee(),
            const SizedBox(height: 60),
            const Text(
              'IN THE NEWS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Every headline tells a story.',
              style: TextStyle(
                color: Color(0xFFB7C9E8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),
            const NewspaperBook(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CINEMATIC PROJECTS PAGE
// ─────────────────────────────────────────────

class ProjectData {
  final String number;
  final String title;
  final String genre;
  final String description;
  final IconData icon;
  final Color accent;
  final List<String> tech;

  const ProjectData({
    required this.number,
    required this.title,
    required this.genre,
    required this.description,
    required this.icon,
    required this.accent,
    required this.tech,
  });
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const projects = [
    ProjectData(
      number: '01',
      title: 'Word Scramble Game',
      genre: 'EDUCATION  •  GAME',
      description:
          'A Python word game that helps students improve their English '
          'letters and spelling. Scrambled words turn learning into a fun, '
          'challenging puzzle.',
      icon: Icons.spellcheck,
      accent: Color(0xFF8ABFFF),
      tech: ['Python', 'Game Logic', 'Education'],
    ),
    ProjectData(
      number: '02',
      title: 'AI Smart Band for Women',
      genre: 'SAFETY  •  AI  •  IOT',
      description:
          'An AI-driven smart band that protects women in dangerous '
          'situations. It uses live location and sound detection to instantly '
          'alert family members and the police.',
      icon: Icons.shield_outlined,
      accent: Color(0xFFFF8FB1),
      tech: ['AI', 'Live Location', 'Sound Detection', 'Alerts'],
    ),
    ProjectData(
      number: '03',
      title: 'Company Website',
      genre: 'WEB  •  ENTREPRENEURSHIP',
      description:
          'The official website of my own company, designed and developed '
          'by me using HTML. A digital home for my startup journey.',
      icon: Icons.language,
      accent: Color(0xFFE7CA80),
      tech: ['HTML', 'Web Design', 'Branding'],
    ),
  ];

  Widget _filmStrip() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / 22).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(
              width: 10,
              height: 7,
              decoration: BoxDecoration(
                color: starBlue.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              _filmStrip(),
              const SizedBox(height: 40),

              // Title that zooms in like a movie title card
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1600),
                curve: Curves.easeOutCubic,
                builder: (context, v, child) => Opacity(
                  opacity: v,
                  child: Transform.scale(scale: 1.25 - 0.25 * v, child: child),
                ),
                child: Column(
                  children: [
                    const Text(
                      'A SRIJA PRODUCTION',
                      style: TextStyle(
                        color: lightBlue,
                        fontSize: 12,
                        letterSpacing: 6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'PROJECTS',
                      style: TextStyle(
                        color: pureWhite,
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 10,
                        shadows: [
                          Shadow(
                            color: starBlue.withValues(alpha: 0.9),
                            blurRadius: 28,
                          ),
                          Shadow(
                            color: royalBlue.withValues(alpha: 0.8),
                            blurRadius: 55,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: 110,
                      height: 2,
                      decoration: const BoxDecoration(
                        color: starBlue,
                        boxShadow: [
                          BoxShadow(color: royalBlue, blurRadius: 14),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'THREE STORIES  •  THREE MISSIONS',
                      style: TextStyle(
                        color: lightBlue,
                        fontSize: 11,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              for (int i = 0; i < projects.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 900 + i * 350),
                    curve: Curves.easeOutCubic,
                    builder: (context, v, child) => Opacity(
                      opacity: v,
                      child: Transform.translate(
                        // cards slide in alternately from left and right
                        offset: Offset((i.isEven ? -80 : 80) * (1 - v), 0),
                        child: child,
                      ),
                    ),
                    child: ProjectCard(project: projects[i]),
                  ),
                ),

              const SizedBox(height: 10),
              _filmStrip(),
              const SizedBox(height: 22),
              const Text(
                'MORE COMING SOON  ✦',
                style: TextStyle(
                  color: lightBlue,
                  fontSize: 11,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final ProjectData project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweep;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _sweep = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -8 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: p.accent.withValues(alpha: _hovered ? 0.95 : 0.40),
            width: _hovered ? 2 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: p.accent.withValues(alpha: _hovered ? 0.35 : 0.10),
              blurRadius: _hovered ? 40 : 20,
              spreadRadius: _hovered ? 2 : 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Stack(
            children: [
              // Background gradient
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        navyBlue.withValues(alpha: 0.95),
                        deepBlue.withValues(alpha: 0.95),
                        Colors.black.withValues(alpha: 0.90),
                      ],
                    ),
                  ),
                ),
              ),

              // Giant faded scene number
              Positioned(
                right: 18,
                bottom: -18,
                child: Text(
                  p.number,
                  style: TextStyle(
                    fontSize: 130,
                    fontWeight: FontWeight.w900,
                    color: p.accent.withValues(alpha: _hovered ? 0.16 : 0.07),
                  ),
                ),
              ),

              // Moving light sweep along the top edge
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 3,
                child: AnimatedBuilder(
                  animation: _sweep,
                  builder: (context, _) => Align(
                    alignment: Alignment(-1.5 + 3.0 * _sweep.value, 0),
                    child: FractionallySizedBox(
                      widthFactor: 0.3,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              p.accent,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(26),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final wide = c.maxWidth > 560;

                    final iconBox = AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: midnight,
                        border: Border.all(color: p.accent, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: p.accent
                                .withValues(alpha: _hovered ? 0.55 : 0.20),
                            blurRadius: _hovered ? 30 : 12,
                          ),
                        ],
                      ),
                      child: Icon(p.icon, color: p.accent, size: 40),
                    );

                    final details = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SCENE ${p.number}  •  ${p.genre}',
                          style: TextStyle(
                            color: p.accent,
                            fontSize: 11,
                            letterSpacing: 2.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          p.title,
                          style: const TextStyle(
                            color: pureWhite,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.description,
                          style: const TextStyle(
                            color: lightBlue,
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: p.tech
                              .map(
                                (t) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: p.accent.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: p.accent.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Text(
                                    t,
                                    style: TextStyle(
                                      color: p.accent,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    );

                    if (wide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          iconBox,
                          const SizedBox(width: 26),
                          Expanded(child: details),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        iconBox,
                        const SizedBox(height: 20),
                        details,
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

// ─────────────────────────────────────────────
// TECHNICAL SKILLS: ORBIT GALAXY + GLOWING BARS
// ─────────────────────────────────────────────

class SkillData {
  final String name;
  final IconData icon;
  final double level; // 0.0 – 1.0  (edit these to match your real level)

  const SkillData(this.name, this.icon, this.level);
}

class TechnicalSkillsSection extends StatefulWidget {
  const TechnicalSkillsSection({super.key});

  @override
  State<TechnicalSkillsSection> createState() =>
      _TechnicalSkillsSectionState();
}

class _TechnicalSkillsSectionState extends State<TechnicalSkillsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _orbit;

  static const innerSkills = [
    SkillData('Python', Icons.terminal, 0.85),
    SkillData('HTML', Icons.html, 0.90),
    SkillData('CSS', Icons.css, 0.80),
    SkillData('JavaScript', Icons.javascript, 0.70),
  ];

  static const outerSkills = [
    SkillData('Flutter', Icons.phone_android, 0.70),
    SkillData('DSA', Icons.account_tree_outlined, 0.75),
    SkillData('OOPS', Icons.category_outlined, 0.80),
    SkillData('Networking', Icons.lan_outlined, 0.65),
  ];

  @override
  void initState() {
    super.initState();
    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _orbit.dispose();
    super.dispose();
  }

  Widget _chip(SkillData s, double depth) {
    // depth 0..1 : "far" skills are smaller and dimmer (fake 3D)
    return Opacity(
      opacity: 0.45 + 0.55 * depth,
      child: Transform.scale(
        scale: 0.82 + 0.28 * depth,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: navyBlue.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: starBlue.withValues(alpha: 0.8)),
            boxShadow: [
              BoxShadow(
                color: starBlue.withValues(alpha: 0.35 * depth),
                blurRadius: 14,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(s.icon, color: starBlue, size: 15),
              const SizedBox(width: 6),
              Text(
                s.name,
                style: const TextStyle(
                  color: pureWhite,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orbitGalaxy() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        const h = 390.0;
        final cx = w / 2;
        const cy = h / 2;

        final outerRx = math.min(w / 2 - 55, 300.0);
        const outerRy = 160.0;
        final innerRx = outerRx * 0.52;
        const innerRy = 80.0;

        return SizedBox(
          width: w,
          height: h,
          child: AnimatedBuilder(
            animation: _orbit,
            builder: (context, _) {
              final t = _orbit.value * 2 * math.pi;
              final children = <Widget>[
                Positioned.fill(
                  child: CustomPaint(
                    painter: _OrbitRingsPainter(
                      outerRx: outerRx,
                      outerRy: outerRy,
                      innerRx: innerRx,
                      innerRy: innerRy,
                    ),
                  ),
                ),
                // Pulsing core
                Positioned(
                  left: cx - 45,
                  top: cy - 45,
                  child: Container(
                    width: 90,
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [royalBlue, navyBlue, midnight],
                      ),
                      border: Border.all(color: starBlue, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: starBlue.withValues(
                            alpha: 0.35 + 0.25 * math.sin(t * 40),
                          ),
                          blurRadius: 30 + 12 * math.sin(t * 40),
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Text(
                      'TECH\nSTACK',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: pureWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ];

              // Collect orbit items so far ones are drawn first
              final items = <_OrbitItem>[];

              for (int i = 0; i < innerSkills.length; i++) {
                final a = t * 2 + i * 2 * math.pi / innerSkills.length;
                items.add(_OrbitItem(
                  innerSkills[i],
                  cx + innerRx * math.cos(a),
                  cy + innerRy * math.sin(a),
                  (math.sin(a) + 1) / 2,
                ));
              }
              for (int i = 0; i < outerSkills.length; i++) {
                // outer ring spins the opposite way
                final a = -t + i * 2 * math.pi / outerSkills.length;
                items.add(_OrbitItem(
                  outerSkills[i],
                  cx + outerRx * math.cos(a),
                  cy + outerRy * math.sin(a),
                  (math.sin(a) + 1) / 2,
                ));
              }

              items.sort((a, b) => a.depth.compareTo(b.depth));

              for (final item in items) {
                children.add(
                  Positioned(
                    left: item.x - 50,
                    top: item.y - 17,
                    width: 100,
                    child: Center(child: _chip(item.skill, item.depth)),
                  ),
                );
              }

              return Stack(children: children);
            },
          ),
        );
      },
    );
  }

  Widget _skillBar(SkillData s, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: s.level),
      duration: Duration(milliseconds: 1300 + index * 200),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(s.icon, color: starBlue, size: 16),
                const SizedBox(width: 8),
                Text(
                  s.name,
                  style: const TextStyle(
                    color: pureWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(value * 100).round()}%',
                  style: const TextStyle(
                    color: starBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: midnight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: starBlue.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [royalBlue, starBlue, pureWhite],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: starBlue.withValues(alpha: 0.6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const all = [...innerSkills, ...outerSkills];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TECHNICAL SKILLS',
          style: TextStyle(
            color: pureWhite,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'A galaxy of tools I use to build ideas.',
          style: TextStyle(color: lightBlue, fontSize: 14),
        ),
        const SizedBox(height: 10),
        _orbitGalaxy(),
        const SizedBox(height: 10),
        BluePanel(
          child: LayoutBuilder(
            builder: (context, c) {
              final twoCols = c.maxWidth > 560;
              final barWidth =
                  twoCols ? (c.maxWidth - 30) / 2 : c.maxWidth;

              return Wrap(
                spacing: 30,
                runSpacing: 22,
                children: [
                  for (int i = 0; i < all.length; i++)
                    SizedBox(width: barWidth, child: _skillBar(all[i], i)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OrbitItem {
  final SkillData skill;
  final double x;
  final double y;
  final double depth;

  _OrbitItem(this.skill, this.x, this.y, this.depth);
}

class _OrbitRingsPainter extends CustomPainter {
  final double outerRx, outerRy, innerRx, innerRy;

  _OrbitRingsPainter({
    required this.outerRx,
    required this.outerRy,
    required this.innerRx,
    required this.innerRy,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = starBlue.withValues(alpha: 0.22);

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: outerRx * 2,
        height: outerRy * 2,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: innerRx * 2,
        height: innerRy * 2,
      ),
      paint..color = starBlue.withValues(alpha: 0.30),
    );
  }

  @override
  bool shouldRepaint(covariant _OrbitRingsPainter old) => false;
}

// ─────────────────────────────────────────────
// ACHIEVEMENTS: MARQUEE + NEWSPAPER BOOK
// ─────────────────────────────────────────────

class AwardMarquee extends StatefulWidget {
  const AwardMarquee({super.key});

  @override
  State<AwardMarquee> createState() => _AwardMarqueeState();
}

class _AwardMarqueeState extends State<AwardMarquee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<String> awards = List.generate(
    8,
    (index) => 'assets/achievements/award${index + 1}.png',
  );

  static const double cardWidth = 150;
  static const double gap = 16;
  static const double cycleWidth = (cardWidth + gap) * 8;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardWidth + 16,
      width: double.infinity,
      child: ClipRect(
        // FIX: OverflowBox lets the long strip be wider than the screen,
        // which removes the "RenderFlex overflowed" error.
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          minWidth: cycleWidth * 2,
          maxWidth: cycleWidth * 2,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  -_controller.value * cycleWidth,
                  0,
                ),
                child: child,
              );
            },
            child: SizedBox(
              width: cycleWidth * 2,
              height: cardWidth + 16,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  for (int copy = 0; copy < 2; copy++)
                    for (final path in awards)
                      Container(
                        width: cardWidth,
                        height: cardWidth,
                        margin: const EdgeInsets.only(right: gap),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF8ABFFF),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            path,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.emoji_events,
                                  color: Color(0xFF8ABFFF),
                                  size: 45,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewspaperBook extends StatefulWidget {
  const NewspaperBook({super.key});

  @override
  State<NewspaperBook> createState() => _NewspaperBookState();
}

class _NewspaperBookState extends State<NewspaperBook>
    with TickerProviderStateMixin {
  late final AnimationController _flipController;
  late final AnimationController _floatController;
  Timer? _pauseTimer;

  int _spread = 0;

  final List<String> pages = List.generate(
    9,
    (index) => 'assets/achievements/paper${index + 1}.png',
  );

  // 0 = left page, 1 = right page (the one that turns),
  // 2 = back of the turning page, 3 = page revealed underneath.
  String _page(int offset) => pages[(_spread * 2 + offset) % pages.length];

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _spread = (_spread + 1) % pages.length;
        });
        _flipController.value = 0;
        _scheduleFlip();
      }
    });

    _scheduleFlip(1000);
  }

  void _scheduleFlip([int milliseconds = 2200]) {
    _pauseTimer?.cancel();
    _pauseTimer = Timer(Duration(milliseconds: milliseconds), () {
      if (mounted) {
        _flipController.forward(from: 0);
      }
    });
  }

  void _turnNow() {
    if (_flipController.isAnimating) return;
    _pauseTimer?.cancel();
    _flipController.forward(from: 0);
  }

  @override
  void dispose() {
    _pauseTimer?.cancel();
    _flipController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  // One printed page with a soft shadow near the spine.
  Widget _pageFace(String path, {required bool isLeft}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5D9),
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(isLeft ? 8 : 1),
              right: Radius.circular(isLeft ? 1 : 8),
            ),
            border: Border.all(
              color: const Color(0xFFD6B66D),
              width: 1,
            ),
          ),
          child: Image.asset(
            path,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.newspaper,
                  size: 48,
                  color: Color(0xFF8B7548),
                ),
              );
            },
          ),
        ),
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(isLeft ? 8 : 1),
                right: Radius.circular(isLeft ? 1 : 8),
              ),
              gradient: LinearGradient(
                begin: isLeft ? Alignment.centerRight : Alignment.centerLeft,
                end: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.30),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.22],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // The page that lifts from the right side and turns over to the left.
  Widget _turningPage() {
    return AnimatedBuilder(
      animation: _flipController,
      builder: (context, _) {
        final t = Curves.easeInOutCubic.transform(_flipController.value);
        final angle = t * math.pi;
        final showBack = angle > math.pi / 2;
        final shade = math.sin(angle) * 0.38;

        final Widget face = showBack
            ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(math.pi),
                child: _pageFace(_page(2), isLeft: true),
              )
            : _pageFace(_page(1), isLeft: false);

        return Transform(
          alignment: Alignment.centerLeft,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(-angle),
          child: Stack(
            fit: StackFit.expand,
            children: [
              face,
              IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: shade),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _pageEdge(Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _openBook() {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          // Thickness of the page stacks
          Positioned(
            left: -8,
            right: -8,
            top: 9,
            bottom: -11,
            child: _pageEdge(const Color(0xFFD9C791)),
          ),
          Positioned(
            left: -4,
            right: -4,
            top: 5,
            bottom: -6,
            child: _pageEdge(const Color(0xFFEADFB8)),
          ),

          // Left page + page revealed under the turning page
          Row(
            children: [
              Expanded(child: _pageFace(_page(0), isLeft: true)),
              Expanded(child: _pageFace(_page(3), isLeft: false)),
            ],
          ),

          // Turning page
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(child: _turningPage()),
            ],
          ),

          // Golden spine
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: SizedBox(
                  width: 6,
                  height: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF8D6A2F),
                          Color(0xFFFFE5A0),
                          Color(0xFF8D6A2F),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE7CA80).withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hardcover around the pages
  Widget _cover(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B3F73),
            Color(0xFF0B1936),
            Color(0xFF12284A),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFD8B86A),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A91FF).withValues(alpha: 0.35),
            blurRadius: 40,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: const Color(0xFFE2BF68).withValues(alpha: 0.16),
            blurRadius: 50,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final leftNumber = (_spread * 2) % pages.length + 1;
    final rightNumber = (_spread * 2 + 1) % pages.length + 1;

    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              color: Color(0xFFE7CA80),
              size: 17,
            ),
            SizedBox(width: 8),
            Text(
              'THE PRESS ARCHIVE',
              style: TextStyle(
                color: Color(0xFFE7CA80),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.auto_awesome,
              color: Color(0xFFE7CA80),
              size: 17,
            ),
          ],
        ),
        const SizedBox(height: 34),

        // Book tilted at an angle, gently floating
        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final f = Curves.easeInOut.transform(_floatController.value);

            return Transform.translate(
              offset: Offset(0, -10 * f),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0011)
                  ..rotateX(0.40 + 0.04 * f)
                  ..rotateY(-0.20)
                  ..rotateZ(0.025),
                child: child,
              ),
            );
          },
          child: GestureDetector(
            onTap: _turnNow,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: _cover(_openBook()),
            ),
          ),
        ),

        // Soft shadow on the table
        Transform.translate(
          offset: const Offset(0, 4),
          child: Container(
            width: 380,
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_stories,
              color: Color(0xFFE7CA80),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'PAGES $leftNumber – $rightNumber OF ${pages.length}',
              style: const TextStyle(
                color: Color(0xFFE7CA80),
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'A STORY WORTH REMEMBERING',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFB7C9E8),
            fontSize: 11,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// MEMORY GALLERY
// ─────────────────────────────────────────────

class MemoryGallery extends StatefulWidget {
  const MemoryGallery({super.key});

  @override
  State<MemoryGallery> createState() => _MemoryGalleryState();
}

class _MemoryGalleryState extends State<MemoryGallery>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Add new photo filenames to this list when needed.
  final List<String> photos = List.generate(
    15,
    (index) => 'assets/gallery/photo${index + 1}.png',
  );

  // Normalized positions: horizontal position, vertical position.
  final List<Offset> positions = const [
    Offset(0.02, 0.04),
    Offset(0.36, 0.01),
    Offset(0.69, 0.08),
    Offset(0.16, 0.21),
    Offset(0.53, 0.19),
    Offset(0.78, 0.29),
    Offset(0.01, 0.39),
    Offset(0.35, 0.37),
    Offset(0.63, 0.46),
    Offset(0.18, 0.56),
    Offset(0.48, 0.61),
    Offset(0.75, 0.65),
    Offset(0.03, 0.76),
    Offset(0.36, 0.80),
    Offset(0.67, 0.83),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openPhoto(String path) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: deepBlue,
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: starBlue.withValues(alpha: 0.7),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: InteractiveViewer(
                  child: Image.asset(
                    path,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      height: 250,
                      child: Center(
                        child: Text(
                          'Photo not found. Check its filename.',
                          style: TextStyle(color: lightBlue),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  icon: const Icon(
                    Icons.close,
                    color: pureWhite,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.auto_awesome,
          color: starBlue,
          size: 30,
        ),
        const SizedBox(height: 12),
        const Text(
          'Moments in Motion',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: starBlue,
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'A little universe of my memories.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: lightBlue,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isSmall = width < 520;

            final photoWidth = isSmall ? 105.0 : 145.0;
            final photoHeight = isSmall ? 130.0 : 175.0;
            final galleryHeight = isSmall ? 1050.0 : 850.0;

            return SizedBox(
              width: width,
              height: galleryHeight,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: List.generate(photos.length, (index) {
                      final position = positions[index];
                      final phase = index * 2.4;
                      final time = _controller.value * 2 * math.pi;

                      final wave = math.sin(time + phase);
                      final opacity = wave < -0.45
                          ? 0.08
                          : ((wave + 0.45) / 1.45).clamp(0.0, 1.0).toDouble();

                      final floatY = math.sin(time + phase) * 12;
                      final rotation = math.sin(time * 0.7 + phase) * 0.055;
                      final scale = 0.94 + ((wave + 1) / 2) * 0.10;

                      final maxLeft = math.max(0.0, width - photoWidth);
                      final maxTop = math.max(0.0, galleryHeight - photoHeight);

                      return Positioned(
                        left: position.dx * maxLeft,
                        top: position.dy * maxTop,
                        child: Opacity(
                          opacity: opacity,
                          child: Transform.translate(
                            offset: Offset(0, floatY),
                            child: Transform.rotate(
                              angle: rotation,
                              child: Transform.scale(
                                scale: scale,
                                child: GestureDetector(
                                  onTap: () => _openPhoto(photos[index]),
                                  child: Container(
                                    width: photoWidth,
                                    height: photoHeight,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: navyBlue,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: starBlue.withValues(
                                          alpha: 0.75,
                                        ),
                                        width: 1.2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: starBlue.withValues(
                                            alpha: 0.10 + opacity * 0.30,
                                          ),
                                          blurRadius: 22,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        photos[index],
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) {
                                          return Container(
                                            color: deepBlue,
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.image_outlined,
                                              color: starBlue,
                                              size: 30,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 15),
        const Text(
          'Every moment is part of my journey ✦',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: lightBlue,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// CODING PLATFORMS
// ─────────────────────────────────────────────

class CodingPlatformsSection extends StatelessWidget {
  const CodingPlatformsSection({super.key});

  static const platforms = [
    {
      'name': 'LeetCode',
      'username': 'srija-a',
      'url': 'https://leetcode.com/u/srija-a/',
      'icon': 'code',
    },
    {
      'name': 'CodeChef',
      'username': 'bvr24wh1a0592',
      'url': 'https://www.codechef.com/users/bvr24wh1a0592',
      'icon': 'trophy',
    },
    {
      'name': 'Codeforces',
      'username': '24wh1a0592',
      'url': 'https://codeforces.com/profile/24wh1a0592',
      'icon': 'terminal',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CODING PLATFORMS',
          style: TextStyle(
            color: pureWhite,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Explore my coding profiles and problem-solving journey.',
          style: TextStyle(color: lightBlue, fontSize: 14),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 800
                ? 3
                : constraints.maxWidth >= 500
                    ? 2
                    : 1;

            final cardWidth =
                (constraints.maxWidth - (columns - 1) * 14) / columns;

            return Wrap(
              spacing: 14,
              runSpacing: 14,
              children: platforms.map((platform) {
                return SizedBox(
                  width: cardWidth,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: deepBlue.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: starBlue.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          platform['icon'] == 'trophy'
                              ? Icons.emoji_events_outlined
                              : platform['icon'] == 'terminal'
                                  ? Icons.terminal
                                  : Icons.code,
                          color: starBlue,
                          size: 30,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          platform['name']!,
                          style: const TextStyle(
                            color: pureWhite,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '@${platform['username']}',
                          style: const TextStyle(
                            color: lightBlue,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final uri = Uri.parse(platform['url']!);
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          icon: const Icon(Icons.open_in_new, size: 16),
                          label: const Text('View Profile'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: starBlue,
                            side: const BorderSide(color: starBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PROFILE SUMMARY CARD (live problem counts)
// ─────────────────────────────────────────────

class ProfileSummaryCard extends StatefulWidget {
  const ProfileSummaryCard({super.key});

  @override
  State<ProfileSummaryCard> createState() => _ProfileSummaryCardState();
}

class _ProfileSummaryCardState extends State<ProfileSummaryCard> {
  String problemCount = 'Loading...';
  String leetcodeCount = 'Loading...';
  String codechefCount = 'Loading...';
  String codeforcesCount = 'Loading...';

  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    loadProblemCount();

    refreshTimer = Timer.periodic(
      const Duration(minutes: 10),
      (_) => loadProblemCount(),
    );
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  Future<int?> fetchCount(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      return findCount(data);
    } catch (_) {
      return null;
    }
  }

  int? findCount(dynamic data) {
    if (data is Map) {
      final matchedUser = data['data']?['matchedUser'];

      if (matchedUser is Map) {
        final submitStats = matchedUser['submitStats'];

        if (submitStats is Map) {
          final submissions = submitStats['acSubmissionNum'];

          if (submissions is List) {
            for (final item in submissions) {
              if (item is Map && item['difficulty'] == 'All') {
                final count = item['count'];
                if (count is num) return count.toInt();
              }
            }
          }
        }
      }

      final nestedData = data['data'];

      if (nestedData is Map) {
        for (final key in [
          'problems_solved',
          'problemsSolved',
          'totalSolved',
          'total_solved',
          'solvedCount',
        ]) {
          final value = nestedData[key];

          if (value is num) return value.toInt();

          if (value is String) {
            final parsed = int.tryParse(value);
            if (parsed != null) return parsed;
          }
        }
      }

      for (final value in data.values) {
        final result = findCount(value);
        if (result != null) return result;
      }
    } else if (data is List) {
      for (final item in data) {
        final result = findCount(item);
        if (result != null) return result;
      }
    }

    return null;
  }

  Future<int?> fetchCodeforcesCount(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);

      if (data is! Map || data['status'] != 'OK') {
        return null;
      }

      final submissions = data['result'];
      if (submissions is! List) return null;

      final Set<String> solved = {};

      for (final submission in submissions) {
        if (submission is! Map || submission['verdict'] != 'OK') {
          continue;
        }

        final problem = submission['problem'];
        if (problem is! Map) continue;

        final contestId = problem['contestId'];
        final index = problem['index'];

        if (contestId != null && index != null) {
          solved.add('$contestId-$index');
        }
      }

      return solved.length;
    } catch (_) {
      return null;
    }
  }

  Future<void> loadProblemCount() async {
    const leetcodeUrl = 'https://competeapi.vercel.app/user/leetcode/srija-a/';

    const codechefUrl =
        'https://codechef-stats.tashif.codes/bvr24wh1a0592/stats';

    const codeforcesUrl =
        'https://codeforces.com/api/user.status?handle=24wh1a0592&count=1000';

    try {
      final results = await Future.wait<int?>([
        fetchCount(leetcodeUrl),
        fetchCount(codechefUrl),
        fetchCodeforcesCount(codeforcesUrl),
      ]).timeout(
        const Duration(seconds: 20),
        onTimeout: () => <int?>[null, null, null],
      );

      if (!mounted) return;

      setState(() {
        leetcodeCount = results[0]?.toString() ?? 'Unavailable';
        codechefCount = results[1]?.toString() ?? 'Unavailable';
        codeforcesCount = results[2]?.toString() ?? 'Unavailable';

        if (results.every((count) => count != null)) {
          problemCount =
              results.fold<int>(0, (sum, count) => sum + count!).toString();
        } else {
          problemCount = 'Partial';
        }
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        problemCount = 'Unavailable';
        leetcodeCount = 'Unavailable';
        codechefCount = 'Unavailable';
        codeforcesCount = 'Unavailable';
      });
    }
  }

  Widget statBox(String label, String value) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minHeight: 76),
        padding: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: midnight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: starBlue.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: starBlue,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: lightBlue,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: deepBlue.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: starBlue.withValues(alpha: 0.65),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: starBlue.withValues(alpha: 0.12),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'assets/images/srija.jpg',
              width: 145,
              height: 145,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 145,
                  height: 145,
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: lightBlue,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'A Srija',
            style: TextStyle(
              color: pureWhite,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'CSE Student • Innovator',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: lightBlue,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              statBox('CGPA', '8.76'),
              const SizedBox(width: 5),
              statBox('Hackathons', '2'),
              const SizedBox(width: 5),
              statBox('Problems', problemCount),
              const SizedBox(width: 5),
              statBox('Projects', '4'),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'PROBLEM COUNTS REFRESH EVERY 10 MIN',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: lightBlue,
              fontSize: 8,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}