import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteStep {
  final LatLng start;
  final LatLng end;
  final String instructions;
  final String duration;
  final String distance;

  const RouteStep({
    required this.start,
    required this.end,
    required this.instructions,
    required this.duration,
    required this.distance,
  });
}

class OptimizedRoute {
  final List<int> waypointOrder;
  final List<LatLng> polylinePoints;
  final String totalDuration;
  final String totalDistance;

  const OptimizedRoute({
    required this.waypointOrder,
    required this.polylinePoints,
    required this.totalDuration,
    required this.totalDistance,
  });
}

class RouteOptimizerService {
  final String _apiKey;

  RouteOptimizerService({required String apiKey}) : _apiKey = apiKey;

  Future<OptimizedRoute> optimizeRoute({
    required LatLng origin,
    required List<LatLng> waypoints,
  }) async {
    if (waypoints.isEmpty) {
      return const OptimizedRoute(
        waypointOrder: [],
        polylinePoints: [],
        totalDuration: '0 min',
        totalDistance: '0 km',
      );
    }

    final destination = waypoints.last;
    final intermediates = waypoints.length > 1
        ? waypoints.sublist(0, waypoints.length - 1)
        : [];

    final url = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      if (intermediates.isNotEmpty)
        'waypoints':
            'optimize:true|${intermediates.map((w) => '${w.latitude},${w.longitude}').join('|')}',
      'key': _apiKey,
      'mode': 'driving',
    });

    final response =
        await http.get(url).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Directions API failed: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if ((json['status'] as String) != 'OK') {
      throw Exception('Directions API: ${json['status']}');
    }

    final routes = json['routes'] as List;
    if (routes.isEmpty) {
      throw Exception('No routes returned by Directions API');
    }

    final route = routes.first as Map<String, dynamic>;
    final legs = route['legs'] as List;

    final waypointOrder =
        (route['waypoint_order'] as List?)?.map((e) => e as int).toList() ??
        List.generate(waypoints.length, (i) => i);

    final polylinePoints = _decodePolyline(
      route['overview_polyline']['points'] as String,
    );

    int totalDurationSec = 0;
    int totalDistanceM = 0;
    for (final leg in legs) {
      totalDurationSec += (leg['duration']['value'] as int);
      totalDistanceM += (leg['distance']['value'] as int);
    }

    return OptimizedRoute(
      waypointOrder: waypointOrder,
      polylinePoints: polylinePoints,
      totalDuration: _formatDuration(totalDurationSec),
      totalDistance: _formatDistance(totalDistanceM),
    );
  }

  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int result = 0;
      int shift = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      result = 0;
      shift = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '$minutes min';
  }

  String _formatDistance(int meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '$meters m';
  }
}
