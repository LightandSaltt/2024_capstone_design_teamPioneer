import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class HnuMap extends StatefulWidget {
  const HnuMap({super.key});

  @override
  State<HnuMap> createState() => _HnuMapState();
}

class _HnuMapState extends State<HnuMap> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();
  final List<Marker> _markers = []; // 마커 리스트

  @override
  void initState() {
    super.initState();
    // 마커 초기화
    _markers.addAll([
      Marker(
        markerId: 'Mensa',
        position: LatLng(36.354764, 127.419059),
        captionText: '멘사',
        captionTextSize: 24.0,
        width: 50,
        height: 70,
        onMarkerTab: _onMarkerTap,
        infoWindow: '위치: 대전 대덕구 한남로 70',
      ),
      Marker(
        markerId: 'Somang',
        position: LatLng(36.353190, 127.426393),
        captionText: '생활관',
        captionTextSize: 24.0,
        width: 50,
        height: 70,
        onMarkerTab: _onMarkerTap,
        infoWindow: '위치: 대전 대덕구 한남로18번길 11',
      ),
      Marker(
        markerId: 'Deaduck',
        position: LatLng(36.398973, 127.392172),
        captionText: '대덕밸리',
        captionTextSize: 24.0,
        width: 50,
        height: 70,
        onMarkerTab: _onMarkerTap,
        infoWindow: '위치: 대전광역시 유성구 전민동 유성대로 1646',
      ),
    ]);
  }

  // 마커 클릭 시 동작
  void _onMarkerTap(Marker? marker, Map<String, int?> iconSize) {
    if (marker != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${marker.infoWindow}가 클릭되었습니다.')),
      );
    }
  }

  // 버튼 클릭 시 지도 이동 함수
  void _moveToMarker(String markerId) async {
    final controller = await _controller.future;
    final marker = _markers.firstWhere((m) => m.markerId == markerId);
    if (marker.position != null) { // marker.position이 null인지 확인
      controller.moveCamera(CameraUpdate.scrollTo(marker.position!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('한남대학교 식당 맵'),
          leading: IconButton( // AppBar 왼쪽에 뒤로가기 버튼 추가
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // 뒤로가기 동작
            },
          ),
        ),
        body: Stack(
          children: [
            NaverMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(36.353326, 127.421328),
                zoom: 15.5,
              ),
              onMapCreated: _onMapCreated,
              markers: _markers,
            ),
            Positioned(
              bottom: 80, // 버튼 위치를 위로 조정
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end, // 버튼들을 오른쪽 정렬
                children: [
                  _buildButton('멘사', Icons.restaurant, 'Mensa', context),
                  _buildButton('생활관', Icons.restaurant, 'Somang', context),
                  _buildButton('대덕밸리', Icons.restaurant, 'Deaduck', context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 버튼 위젯 생성 함수
  Widget _buildButton(String label, IconData icon, String markerId, BuildContext context) {
    return Container(
      width: 150, // 화면 너비의 25%로 설정
      margin: EdgeInsets.only(bottom: 8), // 버튼 간 간격 조절
      child: ElevatedButton.icon(
        onPressed: () => _moveToMarker(markerId),
        icon: Icon(icon, size: 32),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // 버튼 색상 변경
        ),
      ),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}
