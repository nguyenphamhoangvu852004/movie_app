import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/features/getMovieList/GetMovieListRequestData.dart';
import 'package:movie_app/model/Movies.dart';
import 'package:movie_app/ui/components/DetailMovieWidget.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/DomainUrl.dart';
import '../../constants/interfaces/OutputBoundary.dart';

class ListMoreMoviesWidget extends StatefulWidget {
  final InputBoundary getMoviesUseCase;
  final OutputBoundary getMoviesPresenter;
  final InputBoundary getDetailMoviesUseCase;
  final OutputBoundary getDetailMoviesPresenter;
  final String slug;

  // final InputBoundary addMovieFavorite;
  // final InputBoundary isMovieFavorite;
  // final InputBoundary removeMovieFavorite;
  // final OutputBoundary isFavoriteMoviePresenter;

  const ListMoreMoviesWidget(
      this.getMoviesUseCase,
      this.getMoviesPresenter,
      this.getDetailMoviesUseCase,
      this.getDetailMoviesPresenter,
      this.slug,
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
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    fetchData();
    _searchController.addListener(_filterMovies); // Lắng nghe thay đổi trong search
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar với tiêu đề và thanh tìm kiếm
          SliverAppBar(
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            pinned: true, // Cố định khi scroll
            title: const Text(
              'Danh Sách Phim',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60), // Chiều cao của thanh tìm kiếm
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm phim...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFFD700)),
                    ),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFFFD700)),
                  ),
                ),
              ),
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
                      child: CircularProgressIndicator(color: Color(0xFFFFD700)),
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
                              widget.getDetailMoviesPresenter),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFD700),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
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
                                return shimmerLoadingEffect();
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
                                color: Color(0xFFFFD700),
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

  Widget shimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[500]!,
      period: const Duration(milliseconds: 500),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
        ),
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

  void _filterMovies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredData = List.from(data); // Nếu không tìm kiếm, hiển thị toàn bộ data
      } else {
        filteredData = data
            .where((movie) => movie.name.toLowerCase().contains(query))
            .toList(); // Lọc theo tên phim
      }
    });
  }
}
