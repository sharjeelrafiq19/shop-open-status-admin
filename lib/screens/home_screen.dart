import 'package:flutter/material.dart';
import 'package:super_store/api/apis.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  bool isShopOpen = false;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = result;
    });
    if (_connectivityResult != ConnectivityResult.none) {
      getShopStatus();
    }
  }

  Future<void> getShopStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      var status = await APIs.getShopStatus();
      setState(() {
        isShopOpen = status;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching shop status: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateButton() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        isShopOpen = !isShopOpen;
      });
      await APIs.setShopStatus(isShopOpen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection available'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff2c462b),
        title: const Text("Makki Karyana Store"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_connectivityResult == ConnectivityResult.none) {
      return const Center(
        child: Text(
          'No Internet Connection',
          style: TextStyle(fontSize: 18),
        ),
      );
    } else {
      return Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : MaterialButton(
                onPressed: _updateButton,
                color: isShopOpen ? Colors.green : Colors.red,
                minWidth: 150,
                height: 150,
                shape: const CircleBorder(),
                child: Text(
                  isShopOpen ? 'Open' : 'Closed',
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
      );
    }
  }
}
