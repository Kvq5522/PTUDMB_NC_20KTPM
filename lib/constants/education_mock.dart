// education_mock.dart

class EducationInfo {
  final String title;
  final String period;

  EducationInfo({required this.title, required this.period});
}

List<EducationInfo> educationData = [
  EducationInfo(
    title: 'Le Hong Phong High School',
    period: '2008 - 2010',
  ),
  EducationInfo(
    title: 'Ho Chi Minh University of Science',
    period: '2010 - 2014',
  ),
  // Add more education details as needed
];
