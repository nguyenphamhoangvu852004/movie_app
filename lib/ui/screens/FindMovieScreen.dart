import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movie_app/constants/DomainUrl.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/features/findListMovie/FindMovieListRequestData.dart';
import 'package:movie_app/features/getTypeList/GetTypeListRequestData.dart';
import 'package:movie_app/model/Category.dart';
import 'package:movie_app/model/Country.dart';
import 'package:movie_app/model/Movies.dart';
import 'package:movie_app/ui/components/DetailMovieWidget.dart';

class FindMovieScreen extends StatefulWidget {
  final InputBoundary getTypeListUseCase;
  final OutputBoundary getTypeListPresenter;
  final InputBoundary getCountryListUseCase;
  final OutputBoundary getCountryListPresenter;
  final InputBoundary findListMovieUseCase;
  final OutputBoundary findListMoviePresenter;
  final InputBoundary detailMovieUseCase;
  final OutputBoundary detailMoviePresenter;

  final InputBoundary addMovieFavorite;
  final InputBoundary isMovieFavorite;
  final InputBoundary removeMovieFavorite;
  final OutputBoundary isFavoriteMoviePresenter;

  const FindMovieScreen(
      this.getTypeListUseCase,
      this.getTypeListPresenter,
      this.getCountryListUseCase,
      this.getCountryListPresenter,
      this.findListMovieUseCase,
      this.findListMoviePresenter,
      this.detailMovieUseCase,
      this.detailMoviePresenter,
      this.addMovieFavorite,
      this.isMovieFavorite,
      this.removeMovieFavorite,
      this.isFavoriteMoviePresenter,
      {super.key});

  @override
  State<FindMovieScreen> createState() => _FindMovieScreenState();
}

class _FindMovieScreenState extends State<FindMovieScreen> {
  List<Category> listType = [];
  List<Country> listCountry = [];
  List<Movies> listFindMovies = [];
  Category? selectedType;
  Country? selectedCountry;
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTypeList();
    fetchCountryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find Movie")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 16),
            _buildDropdowns(),
            const SizedBox(height: 20),
            _buildSearchButton(),
            const SizedBox(height: 20),
            _buildMovieList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        labelText: "Nhập tên phim",
        suffixIcon: searchController.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear, color: Colors.red),
          onPressed: () => setState(() => searchController.clear()),
        )
            : null,
      ),
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildDropdowns() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTypeDropdown()),
            if (selectedType != null) _buildClearButton(() => setState(() => selectedType = null)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildCountryDropdown()),
            if (selectedCountry != null) _buildClearButton(() => setState(() => selectedCountry = null)),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<Category>(
      value: selectedType,
      decoration: const InputDecoration(labelText: "Chọn thể loại"),
      items: listType.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedType = value;
        });
      },
    );
  }

  Widget _buildCountryDropdown() {
    return DropdownButtonFormField<Country>(
      value: selectedCountry,
      decoration: const InputDecoration(labelText: "Chọn quốc gia"),
      items: listCountry.map((country) {
        return DropdownMenuItem(
          value: country,
          child: Text(country.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCountry = value;
        });
      },
    );
  }

  Widget _buildClearButton(VoidCallback onPressed) {
    return IconButton(icon: const Icon(Icons.clear, color: Colors.red), onPressed: onPressed);
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: fetchListFindMovie,
      child: const Text("Search"),
    );
  }

  Widget _buildMovieList() {
    return Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : listFindMovies.isEmpty
          ? const Center(child: Text("Không tìm thấy phim nào"))
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: listFindMovies.length,
        itemBuilder: (context, index) {
          final movie = listFindMovies[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailMovieWidget(
                  movie,
                  widget.detailMovieUseCase,
                  widget.detailMoviePresenter,
                  widget.addMovieFavorite,
                  widget.isMovieFavorite,
                  widget.removeMovieFavorite,
                  widget.isFavoriteMoviePresenter,
                ),
              ),
            ),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      child: Image.network(
                        movie.posterUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      movie.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void fetchTypeList() async {
    var reqData = GetTypeListRequestData();
    await widget.getTypeListUseCase.execute(reqData);
    var result = await widget.getTypeListPresenter.getData();
    setState(() => listType = result);
  }

  void fetchCountryList() async {
    var reqData = GetTypeListRequestData();
    await widget.getCountryListUseCase.execute(reqData);
    var result = await widget.getCountryListPresenter.getData();
    setState(() => listCountry = result);
  }

  void fetchListFindMovie() async {
    setState(() => isLoading = true);
    try {
      var reqData = FindMovieListRequestData(
        APP_DOMAIN_API_DS_FIND_MOVIE,
        searchController.text.trim(),
        selectedType?.slug ?? "",
        selectedCountry?.slug ?? "",
      );
      await widget.findListMovieUseCase.execute(reqData);
      var result = await widget.findListMoviePresenter.getData();
      setState(() => listFindMovies = result);
    } catch (e) {
      print("Error fetching movies: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }
}
