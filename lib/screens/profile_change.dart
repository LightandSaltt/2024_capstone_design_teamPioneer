import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileChangeScreen extends StatefulWidget {
  @override
  _ProfileChangeScreenState createState() => _ProfileChangeScreenState();
}

class _ProfileChangeScreenState extends State<ProfileChangeScreen> {
  File? _profileImage;
  String _name = ''; // 사용자 이름 저장 변수

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Hansik',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF32810D),
              ),
            ),
            SizedBox(width: 8),
            Image.asset(
              'assets/hansik_logo.png',
              height: 20,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _pickProfileImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : AssetImage('assets/default_profile.png') as ImageProvider,
                ),
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: _pickProfileImage,
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFF2F4F8),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '프로필 사진 변경하기',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  decoration: InputDecoration(labelText: '이름'),
                ),
              ),
              SizedBox(height: 48), // 저장하기 버튼 위에 48 픽셀 (약 2cm) 간격 추가
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextButton(
                  onPressed: () {
                    // TODO: 사용자 이름 저장 로직 구현
                    print('저장된 이름: $_name');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF32810D),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '저장하기',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
