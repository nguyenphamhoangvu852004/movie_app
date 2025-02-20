import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/data/Country.dart';
import 'package:movie_app/features/getCountryList/GetCountryListRequestData.dart';

class GetCountryListWidget extends StatefulWidget {
  final InputBoundary useCase;
  final OutputBoundary presenter;

  const GetCountryListWidget(this.useCase, this.presenter,{super.key});

  @override
  State<GetCountryListWidget> createState() => _GetCountryListWidgetState();
}

class _GetCountryListWidgetState extends State<GetCountryListWidget> {
  late List<Country> list = [];
  Country? selectedCountry;

  @override
  void initState() {
    super.initState();
    fetchTypeListData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<Country>(
        hint: const Text("Chọn loại"),
        value: selectedCountry,
        onChanged: (Country? newValue) {
          setState(() {
            selectedCountry = newValue;
          });
        },
        items: list.map<DropdownMenuItem<Country>>((Country category) {
          return DropdownMenuItem<Country>(
            value: category,
            child: Text(category.name), // Hiển thị tên danh mục
          );
        }).toList(),
      ),
    );
  }

  void fetchTypeListData() async {
    var req = GetCountryListRequestData();
    await widget.useCase.execute(req);
    setState(() {
      list = widget.presenter.getData();
      if (list.isNotEmpty) {
        selectedCountry = list.first; // Chọn giá trị đầu tiên mặc định
      }
    });
  }
}
