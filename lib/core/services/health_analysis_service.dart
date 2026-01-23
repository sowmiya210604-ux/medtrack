class HealthAnalysisService {
  /// Extracts health conditions from report text
  static List<String> extractHealthConditions(String? text) {
    if (text == null || text.isEmpty) {
      return [];
    }

    final conditions = <String>{};
    final lowerText = text.toLowerCase();

    // Diabetes-related keywords
    if (lowerText.contains('diabetes') ||
        lowerText.contains('diabetic') ||
        lowerText.contains('glucose') && lowerText.contains('high') ||
        lowerText.contains('hba1c') && lowerText.contains('elevated')) {
      conditions.add('Diabetes');
    }

    // Hypertension-related keywords
    if (lowerText.contains('hypertension') ||
        lowerText.contains('high blood pressure') ||
        lowerText.contains('elevated bp') ||
        lowerText.contains('bp') && lowerText.contains('high')) {
      conditions.add('Hypertension');
    }

    // Cholesterol-related keywords
    if (lowerText.contains('hyperlipidemia') ||
        lowerText.contains('high cholesterol') ||
        lowerText.contains('ldl') && lowerText.contains('high') ||
        lowerText.contains('cholesterol') && lowerText.contains('elevated')) {
      conditions.add('High Cholesterol');
    }

    // Thyroid-related keywords
    if (lowerText.contains('hypothyroid') ||
        lowerText.contains('hyperthyroid') ||
        lowerText.contains('thyroid') &&
            (lowerText.contains('disorder') || lowerText.contains('disease'))) {
      conditions.add('Thyroid Disorder');
    }

    // Anemia-related keywords
    if (lowerText.contains('anemia') ||
        lowerText.contains('anaemia') ||
        lowerText.contains('hemoglobin') && lowerText.contains('low') ||
        lowerText.contains('iron deficiency')) {
      conditions.add('Anemia');
    }

    // Kidney-related keywords
    if (lowerText.contains('kidney disease') ||
        lowerText.contains('renal') &&
            (lowerText.contains('failure') || lowerText.contains('disease')) ||
        lowerText.contains('nephropathy')) {
      conditions.add('Kidney Disease');
    }

    // Liver-related keywords
    if (lowerText.contains('liver disease') ||
        lowerText.contains('hepatitis') ||
        lowerText.contains('cirrhosis') ||
        lowerText.contains('fatty liver')) {
      conditions.add('Liver Disease');
    }

    // Heart-related keywords
    if (lowerText.contains('heart disease') ||
        lowerText.contains('cardiac') ||
        lowerText.contains('coronary') ||
        lowerText.contains('myocardial')) {
      conditions.add('Heart Disease');
    }

    // Vitamin deficiencies
    if (lowerText.contains('vitamin d') && lowerText.contains('deficien') ||
        lowerText.contains('vitamin b12') && lowerText.contains('low')) {
      conditions.add('Vitamin Deficiency');
    }

    // Asthma/Respiratory
    if (lowerText.contains('asthma') ||
        lowerText.contains('copd') ||
        lowerText.contains('respiratory disorder')) {
      conditions.add('Respiratory Disorder');
    }

    return conditions.toList();
  }

  /// Analyzes all reports and returns unique health conditions
  static List<String> analyzeReports(List<String> reportTexts) {
    final allConditions = <String>{};

    for (final text in reportTexts) {
      final conditions = extractHealthConditions(text);
      allConditions.addAll(conditions);
    }

    return allConditions.toList();
  }

  /// Extracts key health indicators from test results
  static Map<String, String> extractHealthIndicators(String? text) {
    if (text == null || text.isEmpty) {
      return {};
    }

    final indicators = <String, String>{};
    final lines = text.split('\n');

    for (final line in lines) {
      final lowerLine = line.toLowerCase();

      // Blood glucose
      if (lowerLine.contains('glucose') || lowerLine.contains('sugar')) {
        indicators['Blood Glucose'] = line.trim();
      }

      // Blood pressure
      if (lowerLine.contains('blood pressure') ||
          lowerLine.contains('bp') ||
          lowerLine.contains('systolic') ||
          lowerLine.contains('diastolic')) {
        indicators['Blood Pressure'] = line.trim();
      }

      // Cholesterol
      if (lowerLine.contains('cholesterol') ||
          lowerLine.contains('ldl') ||
          lowerLine.contains('hdl')) {
        indicators['Cholesterol'] = line.trim();
      }

      // Hemoglobin
      if (lowerLine.contains('hemoglobin') || lowerLine.contains('hb')) {
        indicators['Hemoglobin'] = line.trim();
      }
    }

    return indicators;
  }
}
