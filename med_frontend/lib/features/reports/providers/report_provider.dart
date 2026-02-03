import 'package:flutter/foundation.dart';
import '../models/report_model.dart';
import '../../../core/services/health_analysis_service.dart';

class ReportProvider extends ChangeNotifier {
  List<MedicalReport> _reports = [];
  List<TestResult> _testResults = [];
  List<String> _healthConditions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MedicalReport> get reports => _reports;
  List<TestResult> get testResults => _testResults;
  List<String> get healthConditions => _healthConditions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all reports
  Future<void> fetchReports() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Call backend API
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      _reports = _generateMockReports();
      _testResults = _generateMockTestResults();

      // Analyze health conditions from reports
      _analyzeHealthConditions();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch reports: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Upload new report
  Future<bool> uploadReport({
    required String testType,
    required String testName,
    required DateTime reportDate,
    String? imagePath,
    String? extractedText,
    Map<String, dynamic>? testResults,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Call backend API to upload image and data
      await Future.delayed(const Duration(seconds: 2));

      // Create new report
      final newReport = MedicalReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: '1',
        testType: testType,
        testName: testName,
        reportDate: reportDate,
        imageUrl: imagePath,
        extractedText: extractedText,
        testResults: testResults,
        uploadedAt: DateTime.now(),
      );

      _reports.insert(0, newReport);

      // Re-analyze health conditions
      _analyzeHealthConditions();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to upload report: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get reports by test type
  List<MedicalReport> getReportsByTestType(String testType) {
    return _reports.where((report) => report.testType == testType).toList();
  }

  // Get recent reports
  List<MedicalReport> getRecentReports({int limit = 5}) {
    return _reports.take(limit).toList();
  }

  // Get test results for a specific test
  List<TestResult> getTestResultsByName(String testName) {
    return _testResults.where((result) => result.testName == testName).toList();
  }

  // Get test results by parameter
  List<TestResult> getTestResultsByParameter(String parameterName) {
    return _testResults
        .where((result) => result.parameterName == parameterName)
        .toList()
      ..sort((a, b) => a.testDate.compareTo(b.testDate));
  }

  // Analyze health conditions from all reports
  void _analyzeHealthConditions() {
    final extractedTexts = _reports
        .where((report) => report.extractedText != null)
        .map((report) => report.extractedText!)
        .toList();

    _healthConditions = HealthAnalysisService.analyzeReports(extractedTexts);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Mock data generation
  List<MedicalReport> _generateMockReports() {
    return [
      MedicalReport(
        id: '1',
        userId: '1',
        testType: 'cbc',
        testName: 'Complete Blood Count',
        reportDate: DateTime.now().subtract(const Duration(days: 7)),
        uploadedAt: DateTime.now().subtract(const Duration(days: 7)),
        labName: 'City Lab',
        doctorName: 'Dr. Sarah Johnson',
        extractedText:
            'Complete Blood Count Report\nHemoglobin: 11.5 g/dL (Low)\nNormal Range: 12-16 g/dL\nDiagnosis: Anemia - Iron deficiency suspected\nRecommendation: Iron supplementation advised',
      ),
      MedicalReport(
        id: '2',
        userId: '1',
        testType: 'lipid',
        testName: 'Lipid Profile',
        reportDate: DateTime.now().subtract(const Duration(days: 30)),
        uploadedAt: DateTime.now().subtract(const Duration(days: 30)),
        labName: 'HealthCare Labs',
        doctorName: 'Dr. Michael Chen',
        extractedText:
            'Lipid Profile Analysis\nTotal Cholesterol: 245 mg/dL (High)\nLDL Cholesterol: 165 mg/dL (Elevated)\nHDL Cholesterol: 38 mg/dL (Low)\nDiagnosis: Hyperlipidemia - High Cholesterol\nRecommendation: Dietary modifications and statin therapy',
      ),
      MedicalReport(
        id: '3',
        userId: '1',
        testType: 'glucose',
        testName: 'Blood Glucose',
        reportDate: DateTime.now().subtract(const Duration(days: 60)),
        uploadedAt: DateTime.now().subtract(const Duration(days: 60)),
        labName: 'City Lab',
        extractedText:
            'Fasting Blood Glucose Test\nGlucose Level: 145 mg/dL (High)\nHbA1c: 7.2% (Elevated)\nDiagnosis: Diabetes Mellitus Type 2\nBlood Pressure: 145/95 mmHg (Hypertension)\nRecommendation: Diabetes management and BP control required',
      ),
    ];
  }

  List<TestResult> _generateMockTestResults() {
    final now = DateTime.now();
    return [
      // Hemoglobin results over time
      TestResult(
        id: '1',
        reportId: '1',
        testName: 'Complete Blood Count',
        parameterName: 'Hemoglobin',
        value: 14.5,
        unit: 'g/dL',
        normalMin: 13.0,
        normalMax: 17.0,
        status: TestStatus.normal,
        testDate: now.subtract(const Duration(days: 7)),
      ),
      TestResult(
        id: '2',
        reportId: '2',
        testName: 'Complete Blood Count',
        parameterName: 'Hemoglobin',
        value: 13.8,
        unit: 'g/dL',
        normalMin: 13.0,
        normalMax: 17.0,
        status: TestStatus.normal,
        testDate: now.subtract(const Duration(days: 37)),
      ),
      TestResult(
        id: '3',
        reportId: '3',
        testName: 'Complete Blood Count',
        parameterName: 'Hemoglobin',
        value: 14.2,
        unit: 'g/dL',
        normalMin: 13.0,
        normalMax: 17.0,
        status: TestStatus.normal,
        testDate: now.subtract(const Duration(days: 67)),
      ),
      // Cholesterol results
      TestResult(
        id: '4',
        reportId: '1',
        testName: 'Lipid Profile',
        parameterName: 'Total Cholesterol',
        value: 195,
        unit: 'mg/dL',
        normalMin: 0,
        normalMax: 200,
        status: TestStatus.normal,
        testDate: now.subtract(const Duration(days: 30)),
      ),
      TestResult(
        id: '5',
        reportId: '2',
        testName: 'Lipid Profile',
        parameterName: 'Total Cholesterol',
        value: 215,
        unit: 'mg/dL',
        normalMin: 0,
        normalMax: 200,
        status: TestStatus.high,
        testDate: now.subtract(const Duration(days: 120)),
      ),
      // Glucose results
      TestResult(
        id: '6',
        reportId: '1',
        testName: 'Blood Glucose',
        parameterName: 'Fasting',
        value: 98,
        unit: 'mg/dL',
        normalMin: 70,
        normalMax: 100,
        status: TestStatus.normal,
        testDate: now.subtract(const Duration(days: 60)),
      ),
      TestResult(
        id: '7',
        reportId: '2',
        testName: 'Blood Glucose',
        parameterName: 'Fasting',
        value: 105,
        unit: 'mg/dL',
        normalMin: 70,
        normalMax: 100,
        status: TestStatus.high,
        testDate: now.subtract(const Duration(days: 150)),
      ),
    ];
  }
}
