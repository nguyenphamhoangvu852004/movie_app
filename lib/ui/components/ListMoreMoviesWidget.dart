import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/features/getMovieList/GetMovieListRequestData.dart';
import 'package:movie_app/model/Movies.dart';
import 'package:movie_app/ui/components/DetailMovieWidget.dart';

import '../../constants/DomainUrl.dart';
import '../../constants/interfaces/OutputBoundary.dart';

class ListMoreMoviesWidget extends StatefulWidget {
  final InputBoundary getMoviesUseCase;
  final OutputBoundary getMoviesPresenter;
  final InputBoundary getDetailMoviesUseCase;
  final OutputBoundary getDetailMoviesPresenter;
  final String slug;

  final InputBoundary addMovieFavorite;
  final InputBoundary isMovieFavorite;
  final InputBoundary removeMovieFavorite;
  final OutputBoundary isFavoriteMoviePresenter;

  const ListMoreMoviesWidget(
      this.getMoviesUseCase,
      this.getMoviesPresenter,
      this.getDetailMoviesUseCase,
      this.getDetailMoviesPresenter,
      this.slug,
      this.addMovieFavorite,
      this.isMovieFavorite,
      this.removeMovieFavorite,
      this.isFavoriteMoviePresenter,
      {super.key});

  @override
  State<ListMoreMoviesWidget> createState() => _ListMoreMoviesWidgetState();
}

class _ListMoreMoviesWidgetState extends State<ListMoreMoviesWidget> {
  List<Movies> data = [];
  List<Movies> filteredData = []; // Danh sách sau khi lọc
  int currentPage = 1;
  bool isLoading = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar với tiêu đề và thanh tìm kiếm
          SliverAppBar(
            elevation: 0,
            pinned: true, // Cố định khi scroll
            title: const Text(
              'Danh Sách Phim',
            ),
            ),
          // Danh sách phim
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2 / 3,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  if (index == filteredData.length && isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailMovieWidget(
                              filteredData[index],
                              widget.getDetailMoviesUseCase,
                              widget.getDetailMoviesPresenter,
                              widget.addMovieFavorite,
                              widget.isMovieFavorite,
                              widget.removeMovieFavorite,
                              widget.isFavoriteMoviePresenter
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              filteredData[index].posterUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return CircularProgressIndicator(color: Colors.black);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              filteredData[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: filteredData.length + (isLoading ? 1 : 0),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100 &&
        !isLoading) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    var requestData = GetMovieListRequestData(
        widget.slug, currentPage, APP_DEFAULT_ITEM_PER_PAGE_MORE);
    await widget.getMoviesUseCase.execute(requestData);
    var newData = widget.getMoviesPresenter.getData();

    setState(() {
      data.addAll(newData);
      filteredData = List.from(data); // Cập nhật filteredData ban đầu
      currentPage++;
      isLoading = false;
    });
  }
}
