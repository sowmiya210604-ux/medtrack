class TestType {
  final String id;
  final String name;
  final String category;
  final String description;
  final List<String> parameters;

  TestType({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.parameters,
  });

  factory TestType.fromJson(Map<String, dynamic> json) {
    return TestType(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      parameters: List<String>.from(json['parameters']),
    );
  }
}

// Sample test types for the UI
class TestTypeData {
  static final List<TestType> availableTests = [
    TestType(
      id: 'cbc',
      name: 'Complete Blood Count (CBC)',
      category: 'Blood Tests',
      description: 'Measures different components of blood',
      parameters: ['Hemoglobin', 'WBC', 'RBC', 'Platelets'],
    ),
    TestType(
      id: 'lipid',
      name: 'Lipid Profile',
      category: 'Blood Tests',
      description: 'Measures cholesterol and triglycerides',
      parameters: ['Total Cholesterol', 'HDL', 'LDL', 'Triglycerides'],
    ),
    TestType(
      id: 'glucose',
      name: 'Blood Glucose',
      category: 'Blood Tests',
      description: 'Measures blood sugar levels',
      parameters: ['Fasting', 'Random', 'HbA1c'],
    ),
    TestType(
      id: 'thyroid',
      name: 'Thyroid Function',
      category: 'Hormones',
      description: 'Tests thyroid hormone levels',
      parameters: ['TSH', 'T3', 'T4'],
    ),
    TestType(
      id: 'liver',
      name: 'Liver Function Test (LFT)',
      category: 'Organ Function',
      description: 'Evaluates liver health',
      parameters: ['SGOT', 'SGPT', 'Bilirubin', 'Albumin'],
    ),
    TestType(
      id: 'kidney',
      name: 'Kidney Function Test (KFT)',
      category: 'Organ Function',
      description: 'Evaluates kidney health',
      parameters: ['Creatinine', 'Urea', 'BUN'],
    ),
    TestType(
      id: 'vitamin_d',
      name: 'Vitamin D',
      category: 'Vitamins',
      description: 'Measures vitamin D levels',
      parameters: ['25-OH Vitamin D'],
    ),
    TestType(
      id: 'vitamin_b12',
      name: 'Vitamin B12',
      category: 'Vitamins',
      description: 'Measures vitamin B12 levels',
      parameters: ['Vitamin B12'],
    ),
    TestType(
      id: 'urine',
      name: 'Urine Analysis',
      category: 'Urine Tests',
      description: 'Comprehensive urine examination',
      parameters: ['pH', 'Protein', 'Glucose', 'Blood'],
    ),
    TestType(
      id: 'iron',
      name: 'Iron Studies',
      category: 'Blood Tests',
      description: 'Measures iron levels and storage',
      parameters: ['Serum Iron', 'Ferritin', 'TIBC'],
    ),
  ];
}
