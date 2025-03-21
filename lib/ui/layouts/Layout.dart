import 'package:flutter/material.dart';
import 'package:movie_app/model/Movies.dart';

class Layout extends StatefulWidget {
  final Widget homeScreen;
  final Widget widgetTree;
  final Widget favorite;
  final Widget findMovieScreen;
  const Layout(this.homeScreen,this.widgetTree, this.favorite, this.findMovieScreen, {super.key});
  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _currentIndex = 0;
  int currentSingleMoviesPage = 1;
  List<Movies> data = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      widget.homeScreen,
      widget.findMovieScreen,
      widget.favorite,
      widget.widgetTree
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "Favorite"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ],
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.black,
          currentIndex: _currentIndex,
          onTap: (value) => setState(() => _currentIndex = value),
        ),
      ),
    );
  }
}
