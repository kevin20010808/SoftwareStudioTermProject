import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'package:term_project/models/my_record.dart';
import 'package:term_project/services/camera_service.dart';
import 'package:term_project/services/firestore_service.dart';
import 'package:term_project/services/providers/image_provider.dart';
import 'package:term_project/widgets/app_bar.dart';
import 'package:term_project/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> with SingleTickerProviderStateMixin {
  final CameraService _cameraService = CameraService();
  List<MyRecord> records = [];
  String _selectedTab = 'All'; // Track the selected tab

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    records = await FirebaseService.instance.loadAllRecords();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<MyRecord> filteredRecords = _selectedTab == 'All'
        ? records
        : records.where((record) => record.dateTime == DateFormat('yyyy/MM/dd').format(DateTime.now())).toList();

    // Sort records by dateTime in descending order
    filteredRecords.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          title: const Text('List'),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTab = index == 0 ? 'All' : 'Daily';
              });
            },
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Daily'),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 300,
                  child: InkWell(
                    onTap: () async {
                      MyRecord? newRecord = await _cameraService.takePicture(context);
                      if (newRecord != null && mounted) {
                        _loadRecords();  // Reload records to include the new one
                        if (mounted) {
                          Provider.of<ImagesProvider>(context, listen: false).setImageUrl(newRecord.foodImage);
                          context.go('/main/list/${newRecord.id}'); 
                        }
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to take or upload picture')),
                        );
                      }
                    },
                    child: const Card(
                      color: Color.fromARGB(232, 2, 95, 64),
                      child: Center(
                        child: Text(
                          'Add item',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredRecords[index].foodName),
                        onTap: () {
                          context.go('/main/list/${filteredRecords[index].id}');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
