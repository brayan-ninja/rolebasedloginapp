import 'package:flutter/material.dart';

void main() => runApp(FrontScreen());

class FrontScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Widget> pages = [
    FitnessScreen(),
    HealthScreen(),
    SkincareScreen(),
  ];

  void _nextPage() {
    if (_currentIndex < pages.length - 1) {
      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      // Navigate to home or next main screen
      print("Onboarding complete");
    }
  }

  void _skipToEnd() {
    _controller.jumpToPage(pages.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: pages,
          ),
          Positioned(
            right: 20,
            top: 50,
            child: TextButton(
              onPressed: _skipToEnd,
              child: Text("Skip", style: TextStyle(color: Colors.grey)),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: ElevatedButton(
              onPressed: _nextPage,
              child: Text(_currentIndex == pages.length - 1 ? "Done" : "Next"),
            ),
          ),
        ],
      ),
    );
  }
}

// Example screen widgets
class FitnessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/fitness.jpg", height: 250),
          SizedBox(height: 20),
          Text("Stay Fit", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("Track your workouts and fitness goals"),
        ],
      ),
    );
  }
}


class HealthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/health.jpg", height: 250),
          SizedBox(height: 20),
          Text("Be Healthy", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("Monitor your health and wellness"),
        ],
      ),
    );
  }
}

class SkincareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/skina.jpg", height: 250),
          SizedBox(height: 20),
          Text("Glow Up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("Discover skincare routines and tips"),
        ],
      ),
    );
  }
}


