import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/data/DetailMovies.dart';
import 'package:movie_app/data/Movies.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMovieRequestData.dart';
import 'package:movie_app/ui/components/VideoPlayerScreen.dart';

// Main Detail Widget
class DetailMovieWidget extends StatefulWidget {
  final Movies movie;
  final InputBoundary getDetailMovie;
  final OutputBoundary getDetailMoviePresenter;

  DetailMovieWidget(
      this.movie, this.getDetailMovie, this.getDetailMoviePresenter);

  @override
  _DetailMovieWidgetState createState() => _DetailMovieWidgetState();
}

class _DetailMovieWidgetState extends State<DetailMovieWidget> {
  DetailMovies? detailMovie;

  @override
  void initState() {
    super.initState();
    fetchDetailMovieData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: detailMovie == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE50914),
                strokeWidth: 3,
              ),
            )
          : CustomScrollView(
              slivers: [
                _buildHeader(),
                _buildDetails(),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: 450.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Poster Image with Gradient Overlay
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Hero(
                tag: widget.movie.id,
                child: Image.network(
                  "https://phimimg.com/${widget.movie.posterUrl}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Movie Info Overlay
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(widget.movie.year.toString()),
                      const SizedBox(width: 8),
                      _buildInfoChip(widget.movie.qualiry),
                      const SizedBox(width: 8),
                      _buildInfoChip(widget.movie.lang),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDetails() {
    if (detailMovie == null) return SliverToBoxAdapter(child: Container());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Section
            _buildSection(
              title: "Overview",
              child: Text(
                detailMovie!.content,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Movie Info Section
            _buildSection(
              title: "Movie Info",
              child: Column(
                children: [
                  _buildInfoRow(
                      "Original Title", detailMovie!.movies.originName),
                  _buildInfoRow("Status", detailMovie!.status),
                  _buildInfoRow("Total Episodes", detailMovie!.episodeTotal),
                  if (detailMovie!.showtimes.isNotEmpty)
                    _buildInfoRow("Show Times", detailMovie!.showtimes),
                  _buildInfoRow("Total Episodes", detailMovie!.episodeTotal),


                  _buildSection(
                    title: "Genres",
                    child: Wrap(
                      spacing: 8, // Khoảng cách giữa các thẻ
                      runSpacing: 8, // Khoảng cách giữa các hàng
                      children: widget.movie.categories.map((genre) {
                        return Chip(
                          label: Text(
                            genre.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.black.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.white.withOpacity(0.3)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),



                ],
              ),
            ),
            const SizedBox(height: 24),

            // Episodes Section
            if (detailMovie!.episode.isNotEmpty) ...[
              _buildSection(
                title: "Episodes",
                child: _buildEpisodesList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodesList() {
    return DefaultTabController(
      length: detailMovie!.episode.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TabBar hiển thị danh sách server
          TabBar(
            isScrollable: true,
            indicatorColor: Colors.red,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: detailMovie!.episode.map((server) {
              return Tab(text: server.serverName);
            }).toList(),
          ),
          const SizedBox(height: 16),

          // TabBarView hiển thị danh sách tập phim của từng server
          SizedBox(
            height: 250, // Đặt chiều cao cho danh sách tập phim
            child: TabBarView(
              children: detailMovie!.episode.map((server) {
                return ListView.builder(
                  itemCount: server.serverData.length,
                  itemBuilder: (context, index) {
                    final episode = server.serverData[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              videoUrl: episode.linkm3u8.toString(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Ảnh thumbnail
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "https://phimimg.com/${detailMovie!.movies.thumbUrl}",
                                width: 100,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Thông tin tập phim
                            Expanded(
                              child: Text(
                                episode.name, // Tên tập phim
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Icon play
                            const Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  void fetchDetailMovieData() async {
    var requestData = GetDetailMovieRequestData(widget.movie);
    await widget.getDetailMovie.execute(requestData);
    DetailMovies data = await widget.getDetailMoviePresenter.getData();
    setState(() {
      detailMovie = data;
    });
  }
}
