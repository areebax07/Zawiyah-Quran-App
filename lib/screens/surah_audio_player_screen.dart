import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class SurahAudioPlayerScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahAudioPlayerScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  State<SurahAudioPlayerScreen> createState() =>
      _SurahAudioPlayerScreenState();
}

class _SurahAudioPlayerScreenState extends State<SurahAudioPlayerScreen> {
  late AudioPlayer _player;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      final url =
          'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/${widget.surahNumber}.mp3';

      debugPrint('LOADING AUDIO: $url');

      await _player.setUrl(url);

      setState(() => _loading = false);
    } catch (e) {
      debugPrint('AUDIO ERROR: $e');
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Audio failed to load'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
        backgroundColor: const Color(0xFF863ED5),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 24),

          // Big Card with Image and Surah Name
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Replace with your Sheikh Alafasy image
                    Image.asset(
                      'assets/images/alafasy.png',
                      fit: BoxFit.cover,
                    ),
                    // Gradient overlay for readability
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    // Surah Name Text
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // so it doesn't take full vertical space
                          children: [
                            Text(
                              widget.surahName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 8,
                                    color: Colors.black,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4), // small spacing between texts
                            const Text(
                              'Rashid Mishary',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                shadows: [
                                  Shadow(
                                    blurRadius: 6,
                                    color: Colors.black,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Play / Pause Button
          Expanded(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Left line
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Play button
                  StreamBuilder<PlayerState>(
                    stream: _player.playerStateStream,
                    builder: (context, snapshot) {
                      final playing = snapshot.data?.playing ?? false;
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF863ED5),
                        child: IconButton(
                          iconSize: 60,
                          icon: Icon(
                            playing ? Icons.pause_circle : Icons.play_circle,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            playing ? _player.pause() : _player.play();
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  // Right line
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),


          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
