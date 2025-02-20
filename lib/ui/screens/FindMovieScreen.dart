import 'package:flutter/material.dart';


class FindMovieScreen extends StatefulWidget {
  final Widget getTypeListWidget;
  final Widget getCountryListWidget;

  const FindMovieScreen(this.getTypeListWidget, this.getCountryListWidget, {super.key});

  @override
  State<FindMovieScreen> createState() => _FindMovieScreenState();
}

class _FindMovieScreenState extends State<FindMovieScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tìm kiếm phim"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      "Chọn thể loại",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),

                    ),
                  ),
                  const SizedBox(height: 8),
                  widget.getTypeListWidget,
                ],
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      "Chọn quốc gia",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  widget.getCountryListWidget,
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
