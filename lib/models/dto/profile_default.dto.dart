class StudentLanguageDto {
  BigInt? id;
  String languageName;
  String? level;

  StudentLanguageDto({this.id, required this.languageName, this.level = ''});

  Map<String, dynamic> toJson() {
    return {
      'id': id?.toInt(),
      'languageName': languageName,
      'level': level,
    };
  }
}

class StudentEducationDto {
  BigInt? id;
  String schoolName;
  int startYear;
  int endYear;

  StudentEducationDto(
      {this.id,
      required this.schoolName,
      required this.startYear,
      required this.endYear});

  Map<String, dynamic> toJson() {
    return {
      'id': id?.toInt(),
      'schoolName': schoolName,
      'startYear': startYear,
      'endYear': endYear,
    };
  }
}

class StudentExperienceDto {
  BigInt? id;
  String startMonth;
  String endMonth;
  String title;
  String description;
  List<String> skillSets;

  StudentExperienceDto(
      {this.id,
      required this.startMonth,
      required this.endMonth,
      required this.title,
      required this.description,
      required this.skillSets});

  Map<String, dynamic> toJson() {
    return {
      'id':  id?.toInt(),
      'startMonth': startMonth,
      'endMonth': endMonth,
      'title': title,
      'description': description,
      'skillSets': skillSets,
    };
  }
}
