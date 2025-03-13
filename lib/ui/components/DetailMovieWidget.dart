import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMovieRequestData.dart';
import 'package:movie_app/ui/components/VideoPlayerScreen.dart';

import '../../features/favoritesMovie/addFavorite/FavoriteRequest.dart';
import '../../features/favoritesMovie/isFavorite/IsFavoriteRequest.dart';
import '../../model/DetailMovies.dart';
import '../../model/Movies.dart';

class DetailMovieWidget extends StatefulWidget {
  final Movies movie;
  final InputBoundary getDetailMovie;
  final OutputBoundary getDetailMoviePresenter;

  final InputBoundary addMovieFavorite;
  final InputBoundary isMovieFavorite;
  final InputBoundary removeMovieFavorite;
  final OutputBoundary isFavoriteMoviePresenter;

  const DetailMovieWidget(
      this.movie,
      this.getDetailMovie,
      this.getDetailMoviePresenter,
      this.addMovieFavorite,
      this.isMovieFavorite,
      this.removeMovieFavorite,
      this.isFavoriteMoviePresenter,
      {super.key});

  @override
  _DetailMovieWidgetState createState() => _DetailMovieWidgetState();
}

class _DetailMovieWidgetState extends State<DetailMovieWidget> {
  DetailMovies? detailMovie;
  bool isFavorite = false;
  int _selectedServerIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchDetailMovieData();
    _checkIfFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: detailMovie == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE50914)))
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
      backgroundColor: Colors.black,
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          widget.movie.posterUrl,
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
          onPressed: _toggleFavorite,
        ),
      ],
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
            Text(widget.movie.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Year: ${widget.movie.year} | Quality: ${widget.movie.qualiry} | Language: ${widget.movie.lang}", style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            Text("Overview", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(detailMovie!.content, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            _buildInfoSection("Original Title", detailMovie!.movies.originName),
            _buildInfoSection("Status", detailMovie!.status),
            _buildInfoSection("Total Episodes", detailMovie!.episodeTotal),
            if (detailMovie!.showtimes.isNotEmpty) _buildInfoSection("Show Times", detailMovie!.showtimes),
            const SizedBox(height: 16),
            _buildGenresSection(),
            const SizedBox(height: 16),
            if (detailMovie!.episode.isNotEmpty) _buildEpisodesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(color: Colors.grey)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildGenresSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Genres", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: widget.movie.categories.map((genre) {
            return Chip(label: Text(genre.name, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.grey[800]);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEpisodesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<int>(
          value: _selectedServerIndex,
          dropdownColor: Colors.black,
          style: const TextStyle(color: Colors.white),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items: List.generate(detailMovie!.episode.length, (index) {
            return DropdownMenuItem<int>(
              value: index,
              child: Text(detailMovie!.episode[index].serverName),
            );
          }),
          onChanged: (int? newIndex) {
            if (newIndex != null) {
              setState(() {
                _selectedServerIndex = newIndex;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: detailMovie!.episode[_selectedServerIndex].serverData.length,
            itemBuilder: (context, index) {
              final episode = detailMovie!.episode[_selectedServerIndex].serverData[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(videoUrl: episode.linkm3u8.toString()),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(detailMovie!.movies.thumbUrl, width: 100, height: 60, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Text(episode.name, style: const TextStyle(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      const Icon(Icons.play_circle_outline, color: Colors.white),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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

  void _toggleFavorite() async {
    var request = FavoriteRequest(1,widget.movie);
    if (isFavorite) {
      await widget.removeMovieFavorite.execute(request);
    } else {
      await widget.addMovieFavorite.execute(request);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _checkIfFavorite() async {
    var request = IsFavoriteRequest(1,widget.movie.id);
    await widget.isMovieFavorite.execute(request);
    bool result = widget.isFavoriteMoviePresenter.getData();
    setState(() {
      isFavorite = result;
    });
  }
}
