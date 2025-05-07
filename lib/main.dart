import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'models/task_item.dart';
import 'services/firebase_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Analytics and enable collection
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
      ),
      home: const TaskManagerHomePage(),
    );
  }
}

class TaskManagerHomePage extends StatefulWidget {
  const TaskManagerHomePage({super.key});

  @override
  State<TaskManagerHomePage> createState() => _TaskManagerHomePageState();
}

class _TaskManagerHomePageState extends State<TaskManagerHomePage> {
  // Global key for the scaffold to access the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Initialize task loading from Firebase
  @override
  void initState() {
    super.initState();
    _loadTasksFromFirebase();
  }
  
  // Load tasks from Firebase
  Future<void> _loadTasksFromFirebase() async {
    setState(() {
      _isLoadingTasks = true;
    });
    
    try {
      // Check if user is logged in
      final currentUser = _firebaseService.getCurrentUser();
      
      if (currentUser != null) {
        // User is logged in, load their tasks
        final tasks = await _firebaseService.getUserTasks();
        
        if (tasks.isNotEmpty) {
          setState(() {
            _taskItems = tasks;
            _isLoadingTasks = false;
          });
        } else {
          // If no tasks, keep sample data
          setState(() {
            _isLoadingTasks = false;
          });
        }
      } else {
        // User is not logged in, keep sample data
        setState(() {
          _isLoadingTasks = false;
        });
      }
    } catch (e) {
      print('Error loading tasks: $e');
      setState(() {
        _isLoadingTasks = false;
      });
    }
  }
  // Firebase service for database operations
  final FirebaseService _firebaseService = FirebaseService();
  
  // Flag to track if tasks are loaded from Firebase
  bool _isLoadingTasks = false;
  
  // List of tasks that will be populated from Firebase
  List<TaskItem> _taskItems = [
    // Sample data - will be replaced with Firebase data
    TaskItem(
      title: 'Item title',
      startDate: DateTime(2024, 1, 16),
      endDate: DateTime(2024, 1, 20),
      unfinishedTasks: 4,
      date: 'Jan 16 - Jan 20, 2024',
      circle: 2,
    ),
    TaskItem(
      date: '5 Nights (Jan 16 - Jan 20, 2024) ',
      circle: 1,
      title: 'Long item title highlighted with ellipsis',
      startDate: DateTime(2024, 1, 16),
      endDate: DateTime(2024, 1, 25),
      unfinishedTasks: 4,
    ),
    TaskItem(
      date: '5 Nights (Jan 16 - Jan 20, 2024) ',
      circle: 2,
      title: 'Item title',
      startDate: DateTime(2024, 1, 16),
      endDate: DateTime(2024, 1, 20),
      unfinishedTasks: 4,
    ),
    TaskItem(
      date: '5 Nights (Jan 16 - Jan 20, 2024) ',
      circle: 2,
      title: 'Item title',
      startDate: DateTime(2024, 1, 16),
      endDate: DateTime(2024, 1, 20),
      unfinishedTasks: 4,
    ),
    TaskItem(
      date: '5 Nights (Jan 16 - Jan 20, 2024) ',
      circle: 2,
      title: 'Item title',
      startDate: DateTime(2024, 1, 16),
      endDate: DateTime(2024, 1, 20),
      unfinishedTasks: 4,
    ),
    TaskItem(
      date: '5 Nights (Jan 16 - Jan 20, 2024) ',
      circle: 2,
      title: 'Item title',
      startDate: DateTime(2024, 1, 16),
      endDate: DateTime(2024, 1, 20),
      unfinishedTasks: 4,
    ),
    TaskItem(
      date: '5 Nights (Jan 16 - Jan 20, 2024) ',
      circle: 2,
      title: 'Item title',
      startDate: DateTime(2024, 1, 16),
      endDate: DateTime(2024, 1, 20),
      unfinishedTasks: 4,
    ),
    TaskItem(
      date: '5 Nights (Jan 16 - Jan 20, 2024) ',
      circle: 2,
      title: 'Item title',
      startDate: DateTime(2024, 1, 16),
      endDate: DateTime(2024, 1, 20),
      unfinishedTasks: 4,
    ),
  ];

  int _selectedNavIndex = 0;
  final List<String> _navItems = [
    'Items',
    'Pricing',
    'Info',
    'Tasks',
    'Analytics'
  ];

  @override
  Widget build(BuildContext context) {
    // Check if we're in mobile view based on screen width
    final bool isMobileView = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: Column(
        children: [
          _buildAppBar(isMobileView),
          SizedBox(height: isMobileView ? 10 : 20),
          if (!isMobileView) _buildHeader() else _buildMobileHeader(),
          SizedBox(
            height: isMobileView ? 10 : 24,
          ),
          // Show loading indicator when fetching tasks from Firebase
          if (_isLoadingTasks)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Expanded(
              child: _buildTaskGrid(isMobileView),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(bool isMobileView) {
    if (isMobileView) {
      // Mobile app bar design
      return Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            bottom: BorderSide(color: HexColor('484848'), width: 1),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Menu icon with tap functionality
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Icon(Icons.menu, color: Colors.white),
              ),
              SizedBox(width: 16),
              // Logo
              Image.asset(
                'assets/logo.png',
                width: 80,
              ),
              Spacer(),
              // Right side icons
              Row(
                children: [
                  Image.asset(
                    'assets/setting-2.png',
                    color: Colors.white,
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 16),
                  Image.asset(
                    'assets/Icons.png',
                    color: Colors.white,
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 1,
                    height: 22,
                    decoration: BoxDecoration(
                      color: HexColor('484848'),
                    ),
                  ),
                  SizedBox(width: 12),
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage('assets/Frame 77134.png'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      // Desktop app bar design
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            bottom: BorderSide(color: HexColor('484848'), width: 1),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine if we need to show a condensed version based on available width
            final bool isCondensed = constraints.maxWidth < 900;

            return Row(
              children: [
                // Left side - Logo
                Padding(
                  padding: EdgeInsets.only(left: isCondensed ? 20 : 80),
                  child: Image.asset(
                    'assets/logo.png',
                    width: isCondensed ? 70 : 90,
                  ),
                ),
                Spacer(),
                // Navigation - only show if we have enough space
                if (!isCondensed)
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _navItems.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedNavIndex = index;
                                });
                              },
                              child: Container(
                                height: 64,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _selectedNavIndex == index
                                          ? HexColor('FFC268')
                                          : Colors.transparent,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _selectedNavIndex == index
                                        ? Colors.white
                                        : Colors.grey,
                                    fontWeight: _selectedNavIndex == index
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                // Icons section - simplified for smaller screens
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isCondensed) const SizedBox(width: 16),
                    if (!isCondensed)
                      Container(
                        width: 1,
                        height: 22,
                        decoration: BoxDecoration(
                          color: HexColor('484848'),
                        ),
                      ),
                    const SizedBox(width: 16),
                    if (!isCondensed)
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/setting-2.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    if (!isCondensed) const SizedBox(width: 16),
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/Icons.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                    if (!isCondensed)
                      Container(
                        width: 1,
                        height: 22,
                        decoration: BoxDecoration(
                          color: HexColor('484848'),
                        ),
                      ),
                    if (!isCondensed) const SizedBox(width: 12),
                    if (!isCondensed)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: AssetImage('assets/Frame 77134.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    if (!isCondensed) const SizedBox(width: 12),
                    if (!isCondensed)
                      const Text(
                        'John Doe',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    if (!isCondensed) const SizedBox(width: 4),
                    if (!isCondensed)
                      const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white, size: 16),
                    SizedBox(width: isCondensed ? 20 : 80),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }
  }

  Widget _buildHeader() {
    // Calculate total unfinished tasks
    int totalUnfinishedTasks =
        _taskItems.fold(0, (sum, task) => sum + task.unfinishedTasks);

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 80, right: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Items',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: HexColor('1E1E1E'),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/Vector.png',
                        color: Colors.white,
                        width: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Container(
                    width: 1,
                    height: 48,
                    decoration: BoxDecoration(
                      color: HexColor('484848'),
                    ),
                  ),
                  SizedBox(width: 14),
                  Container(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: HexColor('FFC268'),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Add a New Item',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Items',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: HexColor('171717'),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'assets/Vector.png',
                color: Colors.white,
                width: 15,
                height: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskGrid(bool isMobileView) {
    return Padding(
      padding: isMobileView
          ? const EdgeInsets.symmetric(horizontal: 16)
          : const EdgeInsets.only(top: 24, left: 80, right: 80),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Target card dimensions
          const double targetCardWidth = 243.25;
          const double targetCardHeight = 322;
          final double aspectRatio = targetCardWidth / targetCardHeight;

          // Determine the appropriate number of columns based on screen width
          // For mobile view or narrow windows, use a single column
          final bool isNarrowScreen = constraints.maxWidth < 600;
          int crossAxisCount = isNarrowScreen
              ? 1
              : (constraints.maxWidth / (targetCardWidth + 20))
                  .floor()
                  .clamp(1, 5);

          // For mobile view or narrow screens, use a ListView instead of GridView
          if (isMobileView || isNarrowScreen) {
            return ListView.builder(
              itemCount: _taskItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildTaskCard(_taskItems[index], true),
                );
              },
            );
          }

          // For desktop view, use GridView
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: aspectRatio,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: _taskItems.length,
            itemBuilder: (context, index) {
              return _buildTaskCard(_taskItems[index], isMobileView);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(TaskItem task, bool isMobileView) {
    // Use a fixed aspect ratio that matches the Figma design
    return Container(
      decoration: BoxDecoration(
        color: HexColor('1E1E1E'),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 1),
      ),

      height: 600, // Match the height from the screenshot
      child: Padding(
        padding: const EdgeInsets.only(
          right: 15,
          left: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // More menu button (positioned on the right)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.more_horiz,
                        color: Colors.white.withOpacity(0.9),
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: HexColor('#1f1610'),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: HexColor('C25F30'), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pending Approval',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    weight: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Title section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                task.title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),
            // Date with calendar icon
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/calendar.png',
                    width: 22,
                    height: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      task.date,
                      maxLines: 2,
                      style: GoogleFonts.inter(
                        color: HexColor('999999'),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // // Spacer to push the bottom section down
            // Spacer(),
            SizedBox(height: 24),
            // Divider
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.1),
            ),
            SizedBox(height: 20),
            // Avatar stack and task count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAvatarStack(task),
                  SizedBox(
                  
                    child: Text(
                      '${task.unfinishedTasks} unfinished tasks',
                      style: GoogleFonts.inter(
                        color: HexColor('999999'),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2, 
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the navigation drawer with tabs
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: HexColor('1E1E1E'),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer header with logo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 80,
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.1)),
            // Navigation items
            ..._navItems.asMap().entries.map((entry) {
              final int index = entry.key;
              final String item = entry.value;
              return ListTile(
                selected: _selectedNavIndex == index,
                selectedTileColor: HexColor('262626'),
                leading: Icon(
                  _getIconForNavItem(index),
                  color:
                      _selectedNavIndex == index ? Colors.white : Colors.grey,
                ),
                title: Text(
                  item,
                  style: GoogleFonts.inter(
                    color:
                        _selectedNavIndex == index ? Colors.white : Colors.grey,
                    fontWeight: _selectedNavIndex == index
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedNavIndex = index;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
            Divider(color: Colors.white.withOpacity(0.1)),
            // Settings and profile options
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey),
              title: Text(
                'Settings',
                style: GoogleFonts.inter(color: Colors.grey),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to settings
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.grey),
              title: Text(
                'Profile',
                style: GoogleFonts.inter(color: Colors.grey),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to profile
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get icons for navigation items
  IconData _getIconForNavItem(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard_outlined;
      case 1:
        return Icons.attach_money;
      case 2:
        return Icons.info_outline;
      case 3:
        return Icons.task_alt;
      case 4:
        return Icons.analytics_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  Widget _buildAvatarStack(final TaskItem task) {
    // Based on the design image, we need to show exactly:
    // 1. Profile picture
    // 2. Two white circles
    // 3. Dark circle with +6 text
    final List<Widget> avatarWidgets = [];
    
    // Constants for better positioning and appearance
    const double avatarSize = 32.0; // Increased size to match image
    const double overlapOffset = 12.0; // More overlap to match image
    
    // First avatar with image (profile picture)
    avatarWidgets.add(
      Positioned(
        left: 0,
        child: Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
            border: Border.all(color: HexColor('262626'),),
            image: const DecorationImage(
              image: AssetImage('assets/Frame 77134.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );

    // Add exactly 2 white circles as shown in the image
    for (int i = 0; i < 2; i++) {
      avatarWidgets.add(
        Positioned(
          left: overlapOffset * (i + 1),
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: HexColor('262626'), ),
            ),
          ),
        ),
      );
    }

    // Add the +6 indicator as shown in the image
    avatarWidgets.add(
      Positioned(
        left: overlapOffset * 3, // Position after the 2 white circles
        child: Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            color: const Color(0xFF262626), // Dark gray background
            shape: BoxShape.circle,
            border: Border.all(color: HexColor('262626'),),
          ),
          child: const Center(
            child: Text(
              '+6',
              style: TextStyle(
                color: Color(0xFFFFB800), // Golden yellow color for the text
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    // Fixed width for 4 avatars (1 profile + 2 white + 1 with +6)
    final double stackWidth = overlapOffset * 4 + (avatarSize - overlapOffset);
    
    return SizedBox(
      height: avatarSize,
      width: stackWidth, // Dynamic width based on number of avatars
      child: Stack(
        clipBehavior: Clip.none,
        children: avatarWidgets,
      ),
    );
  }
}

// TaskItem class has been moved to models/task_item.dart
