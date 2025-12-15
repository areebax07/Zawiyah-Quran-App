import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zawiyah/providers/settings_provider.dart';
import 'package:zawiyah/services/api_service.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({Key? key}) : super(key: key);

  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _prayerData;
  bool _isLoading = true;
  String? _errorMessage;
  String _currentCity = 'Islamabad'; 
  late Timer _timer;
  DateTime _now = DateTime.now();
  String _nextPrayer = '-';
  String _timeUntilNextPrayer = '-';

  final List<Map<String, String>> _allCities = [
    {'city': 'Mecca', 'country': 'Saudi Arabia'},
    {'city': 'Medina', 'country': 'Saudi Arabia'},
    {'city': 'Riyadh', 'country': 'Saudi Arabia'},
    {'city': 'Jeddah', 'country': 'Saudi Arabia'},
    {'city': 'Cairo', 'country': 'Egypt'},
    {'city': 'Alexandria', 'country': 'Egypt'},
    {'city': 'Istanbul', 'country': 'Turkey'},
    {'city': 'Ankara', 'country': 'Turkey'},
    {'city': 'Dubai', 'country': 'UAE'},
    {'city': 'Abu Dhabi', 'country': 'UAE'},
    {'city': 'Karachi', 'country': 'Pakistan'},
    {'city': 'Lahore', 'country': 'Pakistan'},
    {'city': 'Islamabad', 'country': 'Pakistan'},
    {'city': 'Dhaka', 'country': 'Bangladesh'},
    {'city': 'Kuala Lumpur', 'country': 'Malaysia'},
    {'city': 'Jakarta', 'country': 'Indonesia'},
    {'city': 'London', 'country': 'UK'},
    {'city': 'New York', 'country': 'USA'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes(_currentCity, "Pakistan");
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _now = DateTime.now();
        if (_prayerData != null) {
          _updateNextPrayerInfo();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchPrayerTimes(String city, [String? country]) async {
    if (city.isEmpty) return;
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _apiService.getPrayerTimes(city, country);
      if (!mounted) return;
      setState(() {
        _prayerData = data;
        _currentCity = city[0].toUpperCase() + city.substring(1).toLowerCase();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Could not fetch prayer times for '$city'.\nPlease check your connection or try another location.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _updateNextPrayerInfo() {
    if (_prayerData == null || _prayerData!['timings'] == null) return;

    final timings = _prayerData!['timings'] as Map<String, dynamic>;
    final now = DateTime.now();
    DateTime? nextPrayerTime;
    String nextPrayerName = 'Fajr';

    final prayerOrder = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    Map<String, DateTime> todayPrayerTimes = {};

    for (var prayer in prayerOrder) {
      final timeStr = timings[prayer];
      if (timeStr is String) {
        final timeParts = timeStr.split(':');
        if(timeParts.length == 2){
          try {
            final prayerDateTime = DateTime(now.year, now.month, now.day, int.parse(timeParts[0]), int.parse(timeParts[1]));
            todayPrayerTimes[prayer] = prayerDateTime;
          } catch (e) { /* Ignore invalid time formats */ }
        }
      }
    }

    for (var prayer in prayerOrder) {
      if (todayPrayerTimes[prayer]?.isAfter(now) ?? false) {
        nextPrayerTime = todayPrayerTimes[prayer]!;
        nextPrayerName = prayer;
        break;
      }
    }

    if (nextPrayerTime == null) {
      final fajrTimeStr = timings['Fajr'];
      if (fajrTimeStr is String) {
        final fajrTimeParts = fajrTimeStr.split(':');
        if(fajrTimeParts.length == 2){
          try {
            nextPrayerTime = DateTime(now.year, now.month, now.day + 1, int.parse(fajrTimeParts[0]), int.parse(fajrTimeParts[1]));
            nextPrayerName = 'Fajr';
          } catch (e) { /* Ignore invalid time formats */ }
        }
      }
    }

    if (nextPrayerTime != null) {
      final difference = nextPrayerTime.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      _nextPrayer = nextPrayerName;
      _timeUntilNextPrayer = "less than ${hours}h ${minutes}m";
    } else {
      _nextPrayer = '-';
      _timeUntilNextPrayer = '-';
    }
  }

  void _showSearchDialog() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDarkMode = settings.isDarkMode;
    final dialogBgColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (context) {
        List<Map<String, String>> filteredCities = _allCities;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: dialogBgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text('Search Location', style: TextStyle(color: textColor)),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Enter city name...',
                        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                        prefixIcon: Icon(Icons.location_city, color: textColor.withOpacity(0.7)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredCities = _allCities
                              .where((c) => c['city']!.toLowerCase().contains(value.toLowerCase()) || c['country']!.toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredCities.length,
                        itemBuilder: (context, index) {
                          final city = filteredCities[index];
                          return ListTile(
                            title: Text("${city['city']}, ${city['country']}", style: TextStyle(color: textColor)),
                            onTap: () {
                              _fetchPrayerTimes(city['city']!, city['country']!);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
               actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('CANCEL', style: TextStyle(color: Colors.grey)))],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        final isDarkMode = settings.isDarkMode;
        final bgColor = isDarkMode ? const Color(0xFF0D0216) : Colors.grey[100];
        
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            actions: [IconButton(icon: const Icon(Icons.search), onPressed: _showSearchDialog)],
          ),
          body: RefreshIndicator(
            onRefresh: () => _fetchPrayerTimes(_currentCity, _prayerData?['meta']?['timezone']?.split('/').last ?? 'Pakistan'),
            color: const Color(0xFF863ED5),
            backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white, 
            child: CustomScrollView(
              slivers: [
                 SliverToBoxAdapter(
                   child: _buildHeader(),
                 ),
                if (_isLoading && _prayerData == null)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator(color: Color(0xFF863ED5))),
                  )
                else 
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -30),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 10),
                        child: _buildMainContent(),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 70, bottom: 30, left: 20, right: 20),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA060E2), Color(0xFF863ED5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/prayermosque.png',
              fit: BoxFit.contain,
              width: 2000,
              height: 1000,
              color: Colors.white.withOpacity(0.3),
              alignment: Alignment.bottomCenter,
              errorBuilder: (c, o, s) => const SizedBox(),
            ),
          ),
          Column(
            children: [
              Text(_currentCity, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400)),
              const SizedBox(height: 8),
              Text(DateFormat('HH:mm').format(_now), style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.bold, height: 1.2)),
              const SizedBox(height: 8),
              if (!_isLoading && _prayerData != null) Text('$_nextPrayer ${_timeUntilNextPrayer}', style: const TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 20), //newww change
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    final settings = context.watch<SettingsProvider>();
    final isDarkMode = settings.isDarkMode;
    final cardColor = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Column(
      children: [
        if (_errorMessage != null)
          Card(
            elevation: 4.0,
            color: isDarkMode ? Colors.red.withOpacity(0.3) : Colors.red.shade100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(padding: const EdgeInsets.all(16.0), child: Text(_errorMessage!, textAlign: TextAlign.center, style: TextStyle(color: isDarkMode ? Colors.white : Colors.red.shade900, fontSize: 16)))
          )
        else if (_prayerData != null) ...[
          _buildDateCard(cardColor, textColor),
          const SizedBox(height: 20),
          _buildPrayerTimesList(cardColor, textColor),
        ] else const SizedBox.shrink(), 
      ],
    );
  }

  Widget _buildDateCard(Color cardColor, Color textColor) {
    String gregorianDate = "-";
    String hijriDate = "-";

    if (_prayerData!['date'] != null) {
      try {
        final dateInfo = _prayerData!['date']['gregorian'];
        final hijriInfo = _prayerData!['date']['hijri'];
        if (dateInfo != null && hijriInfo != null) {
          gregorianDate = "${dateInfo['day']} ${dateInfo['month']['en']} ${dateInfo['year']}";
          hijriDate = "${hijriInfo['day']} ${hijriInfo['month']['en']} ${hijriInfo['year']} H";
        } else {
           gregorianDate = "Date not available";
        }
      } catch (e) {
        gregorianDate = "Date not available";
        hijriDate = "Error fetching date";
      }
    }

    return Card(
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.2),
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child:
           // IconButton(icon: const Icon(Icons.arrow_back_ios, size: 16), onPressed: () {}, color: textColor.withOpacity(0.6)),
            Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
              children: [
                Text(gregorianDate,textAlign: TextAlign.center,  style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(hijriDate, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14)),
              ],
            ),
            ), //IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 16), onPressed: () {}, color: textColor.withOpacity(0.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList(Color cardColor, Color textColor) {
    if (_prayerData!['timings'] == null) return const SizedBox.shrink();

    final prayerOrder = ['Imsak', 'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    final prayerIcons = {
      'Imsak': Icons.cloud_outlined,
      'Fajr': Icons.wb_twilight_outlined,
      'Dhuhr': Icons.wb_sunny_outlined,
      'Asr': Icons.brightness_6_outlined,
      'Maghrib': Icons.dark_mode_outlined,
      'Isha': Icons.nightlight_round_outlined,
    };

    return Card(
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.2),
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: prayerOrder.map((prayer) {
            final time = _prayerData!['timings'][prayer] ?? '--:--';
            final isLast = prayer == prayerOrder.last;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(prayerIcons[prayer], color: const Color(0xFF863ED5), size: 24),
                          const SizedBox(width: 16),
                          Text(prayer, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text(time.toString(), style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                if(!isLast) Divider(height: 1, color: textColor.withOpacity(0.1))
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
