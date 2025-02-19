import 'package:flutter/material.dart';

class FindMovieWidget extends StatefulWidget {
  const FindMovieWidget({super.key});

  @override
  State<FindMovieWidget> createState() => _FindMovieWidgetState();
}

class _FindMovieWidgetState extends State<FindMovieWidget> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20.0),
      child: DropdownButton<String>(
        value: selectedValue,
        hint: const Text("Select a movie"),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
        items: const [
          DropdownMenuItem<String>(value: "movie1", child: Text("Movie 1")),
          DropdownMenuItem<String>(value: "movie2", child: Text("Movie 2")),
          DropdownMenuItem<String>(value: "movie3", child: Text("Movie 3")),
        ],
    )
    );
  }
}
