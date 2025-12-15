import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zawiyah/providers/settings_provider.dart';
import 'package:zawiyah/services/api_service.dart';

class RamadanCalendarScreen extends StatefulWidget {
  const RamadanCalendarScreen({Key? key}) : super(key: key);

  @override
  _RamadanCalendarScreenState createState() => _RamadanCalendarScreenState();
}

class _RamadanCalendarScreenState extends State<RamadanCalendarScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic>? _calendarData;
  bool _isLoading = true;
  String? _errorMessage;
  String _city = 'Islamabad';
  String _country = 'Pakistan';

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
    _fetchRamadanCalendar();
  }

  Future<void> _fetchRamadanCalendar() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _apiService.getRamadanCalendar(_city, _country);
      if (mounted) {
        setState(() {
          _calendarData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Could not fetch Ramadan calendar for '$_city'.\nPlease check your connection or try again.";
          _isLoading = false;
        });
      }
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
                              this.setState(() {
                                _city = city['city']!;
                                _country = city['country']!;
                              });
                              _fetchRamadanCalendar();
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
    final settings = context.watch<SettingsProvider>();
    final isDarkMode = settings.isDarkMode;
    final bgColor = isDarkMode ? const Color(0xFF0D0216) : Colors.grey[100];

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Ramadan Calendar"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
         actions: [IconButton(icon: const Icon(Icons.search), onPressed: _showSearchDialog)],
      ),
      body: _buildBody(isDarkMode),
    );
  }

  Widget _buildBody(bool isDarkMode) {
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final purpleColor = const Color(0xFF863ED5);

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: purpleColor))
              : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: isDarkMode ? Colors.red.shade300 : Colors.red.shade700, fontSize: 16),
                        ),
                      ),
                    )
                  : _calendarData == null || _calendarData!.isEmpty
                      ? Center(
                          child: Text(
                            "No calendar data available.",
                            style: TextStyle(color: textColor, fontSize: 16),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: _calendarData!.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final dayData = _calendarData![index];
                            final date = dayData?['date']?['readable'] ?? 'N/A';
                            final timings = dayData?['timings'] as Map<String, dynamic>?;
                            final hijriDay = dayData?['date']?['hijri']?['day'] ?? '';
                            final suhoorTime = timings?['Imsak']?.split(' ')[0] ?? '--:--';
                            final iftaarTime = timings?['Maghrib']?.split(' ')[0] ?? '--:--';

                            return _buildCalendarRow(
                              day: hijriDay,
                              date: date,
                              suhoor: suhoorTime,
                              iftaar: iftaarTime,
                              cardColor: cardColor,
                              textColor: textColor,
                              isDarkMode: isDarkMode
                            );
                          },
                        ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
      String hijriYear = "";
      if (_calendarData != null && _calendarData!.isNotEmpty) {
        hijriYear = _calendarData![0]?['date']?['hijri']?['year'] ?? "";
      }

    return Container(
        padding: const EdgeInsets.only(top: 120, bottom: 30, left: 20, right: 20),
        decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA060E2), Color(0xFF863ED5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Column(
               crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                    Text('Ramadan $hijriYear', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(_city, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
            ),

            Image.asset('assets/images/ramdancal.png', height: 90,width: 200, errorBuilder: (c, o, s) => const SizedBox(height: 60)),
        ],
      )
    );
  }
  
  Widget _buildCalendarRow({required String day, required String date, required String suhoor, required String iftaar, required Color cardColor, required Color textColor, required bool isDarkMode}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF863ED5).withOpacity(0.1),
            ),
            child: Text(day, style: const TextStyle(color: Color(0xFF863ED5), fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(date, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 16),
          _buildTimingColumn("Suhoor", suhoor, textColor),
          const SizedBox(width: 20),
          _buildTimingColumn("Iftaar", iftaar, textColor),
        ],
      ),
    );
  }

  Widget _buildTimingColumn(String title, String time, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12)),
        const SizedBox(height: 4),
        Text(time, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
