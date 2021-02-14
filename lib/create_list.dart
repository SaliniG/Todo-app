import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Job {
  final int id;
  final String title;
  final int user_id;
  final String description;
  final String completed_at;
  final String created_at;
  final String updated_at;

  Job(
      {this.id,
      this.title,
      this.user_id,
      this.description,
      this.completed_at,
      this.created_at,
      this.updated_at});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      description: json['description'],
    );
  }
}

class CreateListView extends StatefulWidget {
  @override
  _CreateListViewState createState() => _CreateListViewState();
}

class _CreateListViewState extends State<CreateListView> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Job> data = snapshot.data;
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Job>> _fetchJobs() async {
    final jobsListAPIUrl =
        'https://tiny-list.herokuapp.com/api/v1/users/134/tasks';
    final response = await http.get(jobsListAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].description);
        });
  }

  ListTile _tile(String description) => ListTile(
        title: Text(description,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
      );

}
