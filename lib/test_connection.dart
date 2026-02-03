import 'package:flutter/material.dart';
import 'core/config/api_config.dart';
import 'core/services/http_service.dart';

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  String _status = 'Not tested';
  bool _isLoading = false;
  Color _statusColor = Colors.grey;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing connection...';
      _statusColor = Colors.orange;
    });

    try {
      // Test 1: Health check
      final healthUrl = '${ApiConfig.baseUrl}:3001/health';
      ApiConfig.log('Testing: $healthUrl');
      
      final response = await HttpService.get(healthUrl);
      
      setState(() {
        _isLoading = false;
        _status = '✅ Backend Connected!\n\n'
            'Service: ${response['service']}\n'
            'Status: ${response['status']}\n'
            'URL: $healthUrl\n\n'
            'All systems operational!';
        _statusColor = Colors.green;
      });
      
      // Show success snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Backend connection successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = '❌ Connection Failed!\n\n'
            'Error: ${e.toString()}\n\n'
            'Troubleshooting:\n'
            '1. Check if backend is running\n'
            '   Run: .\\start-all-services.ps1\n\n'
            '2. Verify URL: ${ApiConfig.baseUrl}:3001\n\n'
            '3. Check Chrome console (F12) for errors';
        _statusColor = Colors.red;
      });
      
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Connection failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Connection Test'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              elevation: 4,
              color: _statusColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      _isLoading
                          ? Icons.sync
                          : _statusColor == Colors.green
                              ? Icons.check_circle
                              : _statusColor == Colors.red
                                  ? Icons.error
                                  : Icons.help_outline,
                      size: 64,
                      color: _statusColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Connection Status',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Test Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testConnection,
              icon: Icon(_isLoading ? Icons.hourglass_empty : Icons.wifi_find),
              label: Text(_isLoading ? 'Testing...' : 'Test Connection'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Configuration Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuration',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow('Base URL', ApiConfig.baseUrl),
                    _buildInfoRow('Auth Service', '${ApiConfig.baseUrl}:3001'),
                    _buildInfoRow('Environment', ApiConfig.isProduction ? 'Production' : 'Development'),
                    _buildInfoRow('Logging', ApiConfig.enableLogging ? 'Enabled' : 'Disabled'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Instructions
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Quick Tips',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('• Press F12 to open Chrome DevTools'),
                    const Text('• Check Console tab for API logs'),
                    const Text('• Check Network tab for HTTP requests'),
                    const Text('• Logs start with 🌐 [API]'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'monospace',
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
