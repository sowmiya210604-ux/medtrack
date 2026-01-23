enum TestStatus { normal, high, low }

class MedicalReport {
  final String id;
  final String userId;
  final String testType;
  final String testName;
  final DateTime reportDate;
  final String? imageUrl;
  final String? pdfUrl;
  final String? extractedText;
  final Map<String, dynamic>? testResults;
  final DateTime uploadedAt;
  final String? doctorName;
  final String? labName;

  MedicalReport({
    required this.id,
    required this.userId,
    required this.testType,
    required this.testName,
    required this.reportDate,
    this.imageUrl,
    this.pdfUrl,
    this.extractedText,
    this.testResults,
    required this.uploadedAt,
    this.doctorName,
    this.labName,
  });

  factory MedicalReport.fromJson(Map<String, dynamic> json) {
    return MedicalReport(
      id: json['id'],
      userId: json['userId'],
      testType: json['testType'],
      testName: json['testName'],
      reportDate: DateTime.parse(json['reportDate']),
      imageUrl: json['imageUrl'],
      pdfUrl: json['pdfUrl'],
      extractedText: json['extractedText'],
      testResults: json['testResults'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      doctorName: json['doctorName'],
      labName: json['labName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'testType': testType,
      'testName': testName,
      'reportDate': reportDate.toIso8601String(),
      'imageUrl': imageUrl,
      'pdfUrl': pdfUrl,
      'extractedText': extractedText,
      'testResults': testResults,
      'uploadedAt': uploadedAt.toIso8601String(),
      'doctorName': doctorName,
      'labName': labName,
    };
  }
}

class TestResult {
  final String id;
  final String reportId;
  final String testName;
  final String parameterName;
  final double value;
  final String unit;
  final double? normalMin;
  final double? normalMax;
  final TestStatus status;
  final DateTime testDate;

  TestResult({
    required this.id,
    required this.reportId,
    required this.testName,
    required this.parameterName,
    required this.value,
    required this.unit,
    this.normalMin,
    this.normalMax,
    required this.status,
    required this.testDate,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json['id'],
      reportId: json['reportId'],
      testName: json['testName'],
      parameterName: json['parameterName'],
      value: json['value'].toDouble(),
      unit: json['unit'],
      normalMin: json['normalMin']?.toDouble(),
      normalMax: json['normalMax']?.toDouble(),
      status: TestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TestStatus.normal,
      ),
      testDate: DateTime.parse(json['testDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportId': reportId,
      'testName': testName,
      'parameterName': parameterName,
      'value': value,
      'unit': unit,
      'normalMin': normalMin,
      'normalMax': normalMax,
      'status': status.name,
      'testDate': testDate.toIso8601String(),
    };
  }
}
