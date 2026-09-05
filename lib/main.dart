import 'package:flutter/material.dart';

void main() {
  runApp(const AirportManagementApp());
}

// ============================================================
// APP
// ============================================================

class AirportManagementApp extends StatefulWidget {
  const AirportManagementApp({super.key});

  @override
  State<AirportManagementApp> createState() =>
      _AirportManagementAppState();
}

class _AirportManagementAppState extends State<AirportManagementApp> {
  ThemeMode themeMode = ThemeMode.light;

  void changeTheme(bool dark) {
    setState(() {
      themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Airport Management System',
      themeMode: themeMode,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1769E0),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101827),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4D91FF),
          brightness: Brightness.dark,
        ),
      ),

      home: AirportDashboard(
        isDark: themeMode == ThemeMode.dark,
        onThemeChanged: changeTheme,
      ),
    );
  }
}

// ============================================================
// MODELS
// ============================================================

class Flight {
  String number;
  String destination;
  String time;
  String gate;
  String status;

  Flight({
    required this.number,
    required this.destination,
    required this.time,
    required this.gate,
    required this.status,
  });
}

class Gate {
  String name;
  String status;

  Gate({
    required this.name,
    required this.status,
  });
}

class Passenger {
  String name;
  String flight;
  String seat;

  Passenger({
    required this.name,
    required this.flight,
    required this.seat,
  });
}

class Baggage {
  String tag;
  String passenger;
  String status;

  Baggage({
    required this.tag,
    required this.passenger,
    required this.status,
  });
}

class Aircraft {
  String registration;
  String model;
  String airline;

  Aircraft({
    required this.registration,
    required this.model,
    required this.airline,
  });
}

// ============================================================
// DASHBOARD
// ============================================================

class AirportDashboard extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const AirportDashboard({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<AirportDashboard> createState() => _AirportDashboardState();
}

class _AirportDashboardState extends State<AirportDashboard> {
  int selectedPage = 0;

  final List<Flight> flights = [];
  final List<Gate> gates = [];
  final List<Passenger> passengers = [];
  final List<Baggage> baggage = [];
  final List<Aircraft> aircraft = [];

  final TextEditingController searchController = TextEditingController();

  String searchText = '';

  Color get primary => const Color(0xFF1769E0);

  Color get cardColor =>
      widget.isDark ? const Color(0xFF182235) : Colors.white;

  Color get textColor =>
      widget.isDark ? Colors.white : const Color(0xFF0A1E42);

  int get delayedFlights {
    return flights.where((f) => f.status == 'Delayed').length;
  }

  int get availableGates {
    return gates.where((g) => g.status == 'Available').length;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 900) {
            return _mobileLayout();
          }

          return Row(
            children: [
              _sideBar(),
              Expanded(
                child: _desktopContent(),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================
  // DESKTOP SIDEBAR
  // ==========================================================

  Widget _sideBar() {
    return Container(
      width: 245,
      color: const Color(0xFF071A3A),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.flight_takeoff_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Airport',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              const Text(
                'Management System',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),

              const SizedBox(height: 30),

              _navItem(Icons.dashboard_rounded, 'Dashboard', 0),
              _navItem(Icons.flight_rounded, 'Flights', 1),
              _navItem(Icons.meeting_room_rounded, 'Gates', 2),
              _navItem(Icons.people_alt_rounded, 'Passengers', 3),
              _navItem(Icons.luggage_rounded, 'Baggage', 4),
              _navItem(
                Icons.airplanemode_active_rounded,
                'Aircraft',
                5,
              ),
              _navItem(Icons.bar_chart_rounded, 'Reports', 6),

              const SizedBox(height: 8),

              _navItem(Icons.settings_rounded, 'Settings', 7),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 18),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.07),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.airplanemode_active,
                        color: Color(0xFF66A7FF),
                        size: 27,
                      ),
                      SizedBox(height: 9),
                      Text(
                        'Airport Operations',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage airport activities from one place.',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
      IconData icon,
      String title,
      int index,
      ) {
    final selected = selectedPage == index;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 3,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () {
          setState(() {
            selectedPage = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: selected ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : Colors.white70,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.white70,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DESKTOP CONTENT
  // ==========================================================

  Widget _desktopContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topBar(),
            const SizedBox(height: 22),
            _hero(),
            const SizedBox(height: 22),
            _pageContent(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _pageTitle(),
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),

        SizedBox(
          width: 290,
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchText = value.toLowerCase().trim();
              });
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
          ),
        ),

        const SizedBox(width: 10),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: const Color(0xFFDCE9FF),
                child: Icon(
                  Icons.person,
                  color: primary,
                  size: 19,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Airport Manager',
                    style: TextStyle(
                      color: textColor.withOpacity(.55),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _pageTitle() {
    switch (selectedPage) {
      case 1:
        return 'Flight Management';
      case 2:
        return 'Gate Management';
      case 3:
        return 'Passenger Management';
      case 4:
        return 'Baggage Management';
      case 5:
        return 'Aircraft Management';
      case 6:
        return 'Airport Reports';
      case 7:
        return 'Settings';
      default:
        return 'Airport Overview';
    }
  }

  // ==========================================================
  // HERO
  // ==========================================================

  Widget _hero() {
    return Container(
      height: 235,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF071A3A),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1540962351504-03099e0a754b?auto=format&fit=max&w=1600&q=90',
              fit: BoxFit.contain,
              alignment: Alignment.centerRight,
              errorBuilder: (_, __, ___) {
                return const Center(
                  child: Icon(
                    Icons.flight,
                    color: Colors.white54,
                    size: 75,
                  ),
                );
              },
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF061B3D).withOpacity(.96),
                    const Color(0xFF061B3D).withOpacity(.72),
                    const Color(0xFF061B3D).withOpacity(.12),
                    Colors.transparent,
                  ],
                  stops: const [
                    0.0,
                    0.38,
                    0.65,
                    1.0,
                  ],
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 520,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Airport Management System',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage flights, gates, passengers, baggage and aircraft efficiently.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PAGE CONTENT
  // ==========================================================

  Widget _pageContent() {
    switch (selectedPage) {
      case 1:
        return _flightsPage();
      case 2:
        return _gatesPage();
      case 3:
        return _passengersPage();
      case 4:
        return _baggagePage();
      case 5:
        return _aircraftPage();
      case 6:
        return _reportsPage();
      case 7:
        return _settingsPage();
      default:
        return _dashboardPage();
    }
  }

  // ==========================================================
  // DASHBOARD
  // ==========================================================

  Widget _dashboardPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth < 700 ? 2 : 4;

            return GridView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: columns == 2 ? 1.55 : 1.65,
              ),
              itemBuilder: (_, index) {
                final cards = [
                  _statCard(
                    'Total Flights',
                    flights.length.toString(),
                    Icons.flight_takeoff_rounded,
                    const Color(0xFF1769E0),
                  ),
                  _statCard(
                    'Passengers',
                    passengers.length.toString(),
                    Icons.people_alt_rounded,
                    const Color(0xFF18A878),
                  ),
                  _statCard(
                    'Available Gates',
                    availableGates.toString(),
                    Icons.meeting_room_rounded,
                    const Color(0xFF7956D8),
                  ),
                  _statCard(
                    'Delayed Flights',
                    delayedFlights.toString(),
                    Icons.schedule_rounded,
                    const Color(0xFFE78B16),
                  ),
                ];

                return cards[index];
              },
            );
          },
        ),

        const SizedBox(height: 20),

        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 750) {
              return Column(
                children: [
                  _flightOverview(),
                  const SizedBox(height: 16),
                  _gateOverview(),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _flightOverview(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _gateOverview(),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 20),

        _quickActions(),
      ],
    );
  }

  Widget _statCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: color.withOpacity(.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor.withOpacity(.55),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // FLIGHT OVERVIEW
  // ==========================================================

  Widget _flightOverview() {
    final filtered = flights.where((f) {
      return searchText.isEmpty ||
          f.number.toLowerCase().contains(searchText) ||
          f.destination.toLowerCase().contains(searchText);
    }).toList();

    return _panel(
      title: 'Flight Schedule',
      action: 'Add Flight',
      onAction: _addFlight,
      child: filtered.isEmpty
          ? _emptyState(
        Icons.flight_takeoff_rounded,
        'No flights added yet',
        'Add your first flight to see the schedule here.',
      )
          : Column(
        children: filtered.map(_flightRow).toList(),
      ),
    );
  }

  Widget _flightRow(Flight flight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: widget.isDark
            ? const Color(0xFF202C40)
            : const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(
            Icons.flight_takeoff,
            color: primary,
            size: 20,
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Text(
              flight.number,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              flight.destination,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(
            child: Text(
              flight.time,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          _statusBadge(flight.status),

          IconButton(
            onPressed: () {
              setState(() {
                flights.remove(flight);
              });
            },
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // GATE OVERVIEW
  // ==========================================================

  Widget _gateOverview() {
    final filtered = gates.where((g) {
      return searchText.isEmpty ||
          g.name.toLowerCase().contains(searchText);
    }).toList();

    return _panel(
      title: 'Gate Status',
      action: 'Add Gate',
      onAction: _addGate,
      child: filtered.isEmpty
          ? _emptyState(
        Icons.meeting_room_outlined,
        'No gates added yet',
        'Create gates to monitor availability.',
      )
          : Column(
        children: filtered.map((gate) {
          return Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? const Color(0xFF202C40)
                  : const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.door_front_door_outlined,
                  color: primary,
                ),
                const SizedBox(width: 9),

                Expanded(
                  child: Text(
                    gate.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                _statusBadge(gate.status),

                IconButton(
                  onPressed: () {
                    setState(() {
                      gates.remove(gate);
                    });
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================
  // QUICK ACTIONS
  // ==========================================================

  Widget _quickActions() {
    return _panel(
      title: 'Quick Management',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _quickButton(
            'Add Flight',
            Icons.flight_takeoff,
            _addFlight,
          ),
          _quickButton(
            'Add Gate',
            Icons.meeting_room,
            _addGate,
          ),
          _quickButton(
            'Add Passenger',
            Icons.person_add_alt_1,
            _addPassenger,
          ),
          _quickButton(
            'Add Baggage',
            Icons.luggage,
            _addBaggage,
          ),
          _quickButton(
            'Add Aircraft',
            Icons.airplanemode_active,
            _addAircraft,
          ),
        ],
      ),
    );
  }

  Widget _quickButton(
      String title,
      IconData icon,
      VoidCallback action,
      ) {
    return InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: widget.isDark
              ? const Color(0xFF202C40)
              : const Color(0xFFF1F5FC),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: primary,
              size: 19,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // COMMON PANEL
  // ==========================================================

  Widget _panel({
    required String title,
    String? action,
    VoidCallback? onAction,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 13,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (action != null)
                TextButton(
                  onPressed: onAction,
                  child: Text(action),
                ),
            ],
          ),

          const SizedBox(height: 13),

          child,
        ],
      ),
    );
  }

  Widget _emptyState(
      IconData icon,
      String title,
      String subtitle,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: Column(
          children: [
            Icon(
              icon,
              size: 42,
              color: widget.isDark
                  ? Colors.white24
                  : const Color(0xFFB7C5D9),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor.withOpacity(.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case 'available':
      case 'on time':
      case 'completed':
      case 'delivered':
        color = const Color(0xFF159A68);
        break;

      case 'delayed':
      case 'occupied':
      case 'boarding':
      case 'in transit':
        color = const Color(0xFFE88B16);
        break;

      case 'cancelled':
      case 'maintenance':
        color = const Color(0xFFE84B5A);
        break;

      default:
        color = primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ==========================================================
  // FLIGHTS PAGE
  // ==========================================================

  Widget _flightsPage() {
    final filtered = flights.where((f) {
      return searchText.isEmpty ||
          f.number.toLowerCase().contains(searchText) ||
          f.destination.toLowerCase().contains(searchText);
    }).toList();

    return _panel(
      title: 'All Flights',
      action: 'Add Flight',
      onAction: _addFlight,
      child: filtered.isEmpty
          ? _emptyState(
        Icons.flight_outlined,
        'No flights available',
        'Use Add Flight to create a flight record.',
      )
          : Column(
        children: filtered.map(_flightRow).toList(),
      ),
    );
  }

  // ==========================================================
  // GATES PAGE
  // ==========================================================

  Widget _gatesPage() {
    return _panel(
      title: 'Airport Gates',
      action: 'Add Gate',
      onAction: _addGate,
      child: gates.isEmpty
          ? _emptyState(
        Icons.meeting_room_outlined,
        'No gates available',
        'Add gates to start managing gate operations.',
      )
          : Column(
        children: gates.map((gate) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: primary.withOpacity(.10),
              child: Icon(
                Icons.meeting_room,
                color: primary,
              ),
            ),
            title: Text(gate.name),
            trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _statusBadge(gate.status),
                IconButton(
                  onPressed: () {
                    setState(() {
                      gates.remove(gate);
                    });
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================
  // PASSENGERS PAGE
  // ==========================================================

  Widget _passengersPage() {
    final filtered = passengers.where((p) {
      return searchText.isEmpty ||
          p.name.toLowerCase().contains(searchText) ||
          p.flight.toLowerCase().contains(searchText);
    }).toList();

    return _panel(
      title: 'Passengers',
      action: 'Add Passenger',
      onAction: _addPassenger,
      child: filtered.isEmpty
          ? _emptyState(
        Icons.people_outline,
        'No passengers added',
        'Passenger records will appear here.',
      )
          : Column(
        children: filtered.map((p) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: primary.withOpacity(.10),
              child: Icon(
                Icons.person,
                color: primary,
              ),
            ),
            title: Text(p.name),
            subtitle: Text(
              'Flight: ${p.flight.isEmpty ? '--' : p.flight}  •  Seat: ${p.seat.isEmpty ? '--' : p.seat}',
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  passengers.remove(p);
                });
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================
  // BAGGAGE PAGE
  // ==========================================================

  Widget _baggagePage() {
    final filtered = baggage.where((b) {
      return searchText.isEmpty ||
          b.tag.toLowerCase().contains(searchText) ||
          b.passenger.toLowerCase().contains(searchText);
    }).toList();

    return _panel(
      title: 'Baggage Tracking',
      action: 'Add Baggage',
      onAction: _addBaggage,
      child: filtered.isEmpty
          ? _emptyState(
        Icons.luggage_outlined,
        'No baggage records',
        'Add baggage to start tracking luggage.',
      )
          : Column(
        children: filtered.map((b) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFEAF8F3),
              child: Icon(
                Icons.luggage,
                color: Color(0xFF159A68),
              ),
            ),
            title: Text(
              'Tag: ${b.tag}',
            ),
            subtitle: Text(
              b.passenger.isEmpty
                  ? 'Passenger not specified'
                  : b.passenger,
            ),
            trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _statusBadge(b.status),
                IconButton(
                  onPressed: () {
                    setState(() {
                      baggage.remove(b);
                    });
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================
  // AIRCRAFT PAGE
  // ==========================================================

  Widget _aircraftPage() {
    final filtered = aircraft.where((a) {
      return searchText.isEmpty ||
          a.registration.toLowerCase().contains(searchText) ||
          a.model.toLowerCase().contains(searchText) ||
          a.airline.toLowerCase().contains(searchText);
    }).toList();

    return _panel(
      title: 'Aircraft Fleet',
      action: 'Add Aircraft',
      onAction: _addAircraft,
      child: filtered.isEmpty
          ? _emptyState(
        Icons.airplanemode_active_outlined,
        'No aircraft added',
        'Add aircraft information to manage the fleet.',
      )
          : Column(
        children: filtered.map((a) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFF0ECFF),
              child: Icon(
                Icons.airplanemode_active,
                color: Color(0xFF7956D8),
              ),
            ),
            title: Text(a.registration),
            subtitle: Text(
              '${a.model.isEmpty ? '--' : a.model} • ${a.airline.isEmpty ? '--' : a.airline}',
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  aircraft.remove(a);
                });
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================
  // REPORTS
  // ==========================================================

  Widget _reportsPage() {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth < 650 ? 2 : 3;

            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: columns == 2 ? 1.5 : 1.8,
              children: [
                _statCard(
                  'Flights',
                  flights.length.toString(),
                  Icons.flight,
                  primary,
                ),
                _statCard(
                  'Passengers',
                  passengers.length.toString(),
                  Icons.people,
                  const Color(0xFF18A878),
                ),
                _statCard(
                  'Baggage',
                  baggage.length.toString(),
                  Icons.luggage,
                  const Color(0xFFE78B16),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 18),

        _panel(
          title: 'Operations Summary',
          child: Column(
            children: [
              _reportRow('Total Flights', flights.length),
              _reportRow('Delayed Flights', delayedFlights),
              _reportRow('Passengers', passengers.length),
              _reportRow('Baggage Records', baggage.length),
              _reportRow('Aircraft', aircraft.length),
              _reportRow('Gates', gates.length),
              _reportRow('Available Gates', availableGates),
            ],
          ),
        ),
      ],
    );
  }

  Widget _reportRow(
      String title,
      int value,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 13,
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: widget.isDark
                ? Colors.white12
                : const Color(0xFFE9EDF3),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SETTINGS
  // ==========================================================

  Widget _settingsPage() {
    return _panel(
      title: 'Settings',
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: widget.isDark,
            onChanged: widget.onThemeChanged,
            secondary: Icon(
              widget.isDark
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              color: primary,
            ),
            title: const Text(
              'Dark Theme',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              widget.isDark
                  ? 'Dark theme is currently enabled.'
                  : 'Light theme is currently enabled.',
            ),
          ),

          const Divider(),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.flight_takeoff_rounded,
              color: primary,
            ),
            title: const Text(
              'Airport Management System',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              'Airport operations dashboard',
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // MOBILE
  // ==========================================================

  Widget _mobileLayout() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF071A3A),
        foregroundColor: Colors.white,
        title: const Text(
          'Airport Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),

      drawer: Drawer(
        backgroundColor: const Color(0xFF071A3A),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 25),

                const Icon(
                  Icons.flight_takeoff_rounded,
                  color: Colors.white,
                  size: 43,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Airport Management System',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                _mobileNav(
                  'Dashboard',
                  0,
                  Icons.dashboard,
                ),
                _mobileNav(
                  'Flights',
                  1,
                  Icons.flight,
                ),
                _mobileNav(
                  'Gates',
                  2,
                  Icons.meeting_room,
                ),
                _mobileNav(
                  'Passengers',
                  3,
                  Icons.people,
                ),
                _mobileNav(
                  'Baggage',
                  4,
                  Icons.luggage,
                ),
                _mobileNav(
                  'Aircraft',
                  5,
                  Icons.airplanemode_active,
                ),
                _mobileNav(
                  'Reports',
                  6,
                  Icons.bar_chart,
                ),
                _mobileNav(
                  'Settings',
                  7,
                  Icons.settings,
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              _mobileHero(),
              const SizedBox(height: 16),
              _pageContent(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // MOBILE HERO
  // ==========================================================

  Widget _mobileHero() {
    return Container(
      width: double.infinity,
      height: 250,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: const Color(0xFF071A3A),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=max&w=1400&q=95',
              fit: BoxFit.contain,
              alignment: Alignment.centerRight,
              errorBuilder: (_, __, ___) {
                return const Center(
                  child: Icon(
                    Icons.flight,
                    color: Colors.white54,
                    size: 65,
                  ),
                );
              },
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    const Color(0xFF061B3D).withOpacity(.94),
                    const Color(0xFF061B3D).withOpacity(.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          const Positioned(
            left: 20,
            right: 20,
            bottom: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Airport Management System',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  'Manage airport operations efficiently.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileNav(
      String title,
      int index,
      IconData icon,
      ) {
    final selected = selectedPage == index;

    return ListTile(
      onTap: () {
        setState(() {
          selectedPage = index;
        });

        Navigator.pop(context);
      },

      leading: Icon(
        icon,
        color: selected ? Colors.white : Colors.white70,
      ),

      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight:
          selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),

      tileColor:
      selected ? primary.withOpacity(.35) : Colors.transparent,
    );
  }

  // ==========================================================
  // ADD FUNCTIONS
  // ==========================================================

  Future<void> _addFlight() async {
    final result = await _flightDialog();

    if (result != null) {
      setState(() {
        flights.add(result);
      });
    }
  }

  Future<void> _addGate() async {
    final result = await _gateDialog();

    if (result != null) {
      setState(() {
        gates.add(result);
      });
    }
  }

  Future<void> _addPassenger() async {
    final result = await _passengerDialog();

    if (result != null) {
      setState(() {
        passengers.add(result);
      });
    }
  }

  Future<void> _addBaggage() async {
    final result = await _baggageDialog();

    if (result != null) {
      setState(() {
        baggage.add(result);
      });
    }
  }

  Future<void> _addAircraft() async {
    final result = await _aircraftDialog();

    if (result != null) {
      setState(() {
        aircraft.add(result);
      });
    }
  }

  // ==========================================================
  // INPUT
  // ==========================================================

  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: widget.isDark
          ? const Color(0xFF202C40)
          : const Color(0xFFF6F8FC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  // ==========================================================
  // FLIGHT DIALOG
  // ==========================================================

  Future<Flight?> _flightDialog() async {
    final number = TextEditingController();
    final destination = TextEditingController();
    final time = TextEditingController();
    final gate = TextEditingController();

    String status = 'On Time';

    return showDialog<Flight>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Flight'),

              content: SingleChildScrollView(
                child: SizedBox(
                  width: 430,
                  child: Column(
                    children: [
                      TextField(
                        controller: number,
                        decoration: _input('Flight Number'),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: destination,
                        decoration: _input('Destination'),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: time,
                        decoration: _input('Departure Time'),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: gate,
                        decoration: _input('Gate'),
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: status,
                        decoration: _input('Status'),
                        items: const [
                          DropdownMenuItem(
                            value: 'On Time',
                            child: Text('On Time'),
                          ),
                          DropdownMenuItem(
                            value: 'Delayed',
                            child: Text('Delayed'),
                          ),
                          DropdownMenuItem(
                            value: 'Cancelled',
                            child: Text('Cancelled'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          setDialogState(() {
                            status = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (number.text.trim().isEmpty ||
                        destination.text.trim().isEmpty) {
                      return;
                    }

                    Navigator.pop(
                      context,
                      Flight(
                        number: number.text.trim(),
                        destination: destination.text.trim(),
                        time: time.text.trim().isEmpty
                            ? '--'
                            : time.text.trim(),
                        gate: gate.text.trim().isEmpty
                            ? '--'
                            : gate.text.trim(),
                        status: status,
                      ),
                    );
                  },
                  child: const Text('Add Flight'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // GATE DIALOG
  // ==========================================================

  Future<Gate?> _gateDialog() async {
    final name = TextEditingController();

    String status = 'Available';

    return showDialog<Gate>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Gate'),

              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: name,
                      decoration: _input('Gate Name'),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: _input('Gate Status'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Available',
                          child: Text('Available'),
                        ),
                        DropdownMenuItem(
                          value: 'Occupied',
                          child: Text('Occupied'),
                        ),
                        DropdownMenuItem(
                          value: 'Boarding',
                          child: Text('Boarding'),
                        ),
                        DropdownMenuItem(
                          value: 'Maintenance',
                          child: Text('Maintenance'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setDialogState(() {
                          status = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (name.text.trim().isEmpty) {
                      return;
                    }

                    Navigator.pop(
                      context,
                      Gate(
                        name: name.text.trim(),
                        status: status,
                      ),
                    );
                  },
                  child: const Text('Add Gate'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // PASSENGER DIALOG
  // ==========================================================

  Future<Passenger?> _passengerDialog() async {
    final name = TextEditingController();
    final flight = TextEditingController();
    final seat = TextEditingController();

    return showDialog<Passenger>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Passenger'),

          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: _input('Passenger Name'),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: flight,
                  decoration: _input('Flight Number'),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: seat,
                  decoration: _input('Seat Number'),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                if (name.text.trim().isEmpty) {
                  return;
                }

                Navigator.pop(
                  context,
                  Passenger(
                    name: name.text.trim(),
                    flight: flight.text.trim(),
                    seat: seat.text.trim(),
                  ),
                );
              },
              child: const Text('Add Passenger'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // BAGGAGE DIALOG
  // ==========================================================

  Future<Baggage?> _baggageDialog() async {
    final tag = TextEditingController();
    final passenger = TextEditingController();

    String status = 'Checked In';

    return showDialog<Baggage>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Baggage'),

              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: tag,
                      decoration: _input('Baggage Tag'),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: passenger,
                      decoration: _input('Passenger Name'),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: _input('Baggage Status'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Checked In',
                          child: Text('Checked In'),
                        ),
                        DropdownMenuItem(
                          value: 'In Transit',
                          child: Text('In Transit'),
                        ),
                        DropdownMenuItem(
                          value: 'Delivered',
                          child: Text('Delivered'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setDialogState(() {
                          status = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (tag.text.trim().isEmpty) {
                      return;
                    }

                    Navigator.pop(
                      context,
                      Baggage(
                        tag: tag.text.trim(),
                        passenger: passenger.text.trim(),
                        status: status,
                      ),
                    );
                  },
                  child: const Text('Add Baggage'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // AIRCRAFT DIALOG
  // ==========================================================

  Future<Aircraft?> _aircraftDialog() async {
    final registration = TextEditingController();
    final model = TextEditingController();
    final airline = TextEditingController();

    return showDialog<Aircraft>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Aircraft'),

          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: registration,
                  decoration: _input('Registration Number'),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: model,
                  decoration: _input('Aircraft Model'),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: airline,
                  decoration: _input('Airline'),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                if (registration.text.trim().isEmpty) {
                  return;
                }

                Navigator.pop(
                  context,
                  Aircraft(
                    registration: registration.text.trim(),
                    model: model.text.trim(),
                    airline: airline.text.trim(),
                  ),
                );
              },
              child: const Text('Add Aircraft'),
            ),
          ],
        );
      },
    );
  }
}