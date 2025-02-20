import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/data/Category.dart';
import 'package:movie_app/features/getTypeList/GetTypeListRequestData.dart';

class TypeListWidget extends StatefulWidget {
  final InputBoundary useCase;
  final OutputBoundary presenter;

  const TypeListWidget(this.useCase, this.presenter, {super.key});

  @override
  State<TypeListWidget> createState() => _TypeListWidgetState();
}

class _TypeListWidgetState extends State<TypeListWidget> {
  late List<Category> list = [];
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    fetchTypeListData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<Category>(
        hint: const Text("Chọn loại"),
        value: selectedCategory,
        onChanged: (Category? newValue) {
          setState(() {
            selectedCategory = newValue;
          });
        },
        items: list.map<DropdownMenuItem<Category>>((Category category) {
          return DropdownMenuItem<Category>(
            value: category,
            child: Text(category.name), // Hiển thị tên danh mục
          );
        }).toList(),
      ),
    );
  }

  void fetchTypeListData() async {
    var req = GetTypeListRequestData(1);
    await widget.useCase.execute(req);
    setState(() {
      list = widget.presenter.getData();
      if (list.isNotEmpty) {
        selectedCategory = list.first; // Chọn giá trị đầu tiên mặc định
      }
    });
  }
}
