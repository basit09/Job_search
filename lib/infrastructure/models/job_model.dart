class JobModel {
  String? jobTitle;
  String? address;
  String? role;
  String? responsibilities;
  int? salary;
  String? employerId;
  String? jobId;

  JobModel(
      {this.jobTitle,
      this.address,
      this.responsibilities,
      this.role,
      this.salary,
      this.employerId,
        this.jobId,
      });

  Map<String, dynamic> toMap() {
    return {
      'jobTitle': jobTitle,
      'address': address,
      'role': role,
      'responsibilities': responsibilities,
      'salary': salary,
      'employerID': employerId,
      'jobId':jobId
    };
  }
   factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      jobTitle: map['jobTitle'],
      address: map['address'],
      role: map['role'],
      responsibilities: map['responsibilities'],
      salary: map['salary'],
      employerId: map['employerID'],
      jobId: map['jobId'],

    );
  }
}
