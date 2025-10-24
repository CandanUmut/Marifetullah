import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/resource_link.dart';

class ResourceService {
  Future<List<ResourceLink>> loadResources() async {
    final data = await rootBundle.loadString('assets/resources.json');
    final List<dynamic> decoded = json.decode(data) as List<dynamic>;
    return decoded.map((e) => ResourceLink.fromJson(e as Map<String, dynamic>)).toList();
  }
}
