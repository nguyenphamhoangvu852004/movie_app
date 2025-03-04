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

  const ListMoreMoviesWidget(this.getMoviesUseCase, this.getMoviesPresenter,
      this.getDetailMoviesUseCase, this.getDetailMoviesPresenter, this.slug,
      {super.key});

  @override
  State<ListMoreMoviesWidget> createState() => _ListMoreMoviesWidgetState();
}

class _ListMoreMoviesWidgetState extends State<ListMoreMoviesWidget> {
  List<Movies> data = [];
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
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Danh Sách Phim',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF121212),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2 / 3,
          ),
          itemCount: data.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == data.length) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xFFFFD700)),
              );
            }
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailMovieWidget(
                        data[index],
                        widget.getDetailMoviesUseCase,
                        widget.getDetailMoviesPresenter),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFFFFD700),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFD700).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        data[index].posterUrl,
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
                        data[index].name,
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
        ),
      ),
    );
  }

  Widget shimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[500]!,
      period: Duration(milliseconds: 500), // Tăng tốc độ nhấp nháy
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
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

  fetchData() async {
    setState(() => isLoading = true);

    var requestData = GetMovieListRequestData(
        widget.slug, currentPage, APP_DEFAULT_ITEM_PER_PAGE_MORE);
    await widget.getMoviesUseCase.execute(requestData);
    var newData = widget.getMoviesPresenter.getData();

    setState(() {
      data.addAll(newData);
      currentPage++;
      isLoading = false;
    });
  }
}
