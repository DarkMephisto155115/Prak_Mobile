import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  var email = ''.obs;
  var username = ''.obs;
  var month = ''.obs;
  var day = ''.obs;
  var year = ''.obs;
  var pronouns = ''.obs;
}

class RegistrationPage extends GetView<RegistrationController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about yourself',
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Email',
              onChanged: (value) => controller.email.value = value,
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Username',
              onChanged: (value) => controller.username.value = value,
              hint: 'You don\'t have to use your real name. You can choose another name to protect your privacy.',
            ),
            SizedBox(height: 20),
            Text(
              'When\'s your birthday?',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                _buildDateField(
                  hint: 'MM',
                  onChanged: (value) => controller.month.value = value,
                ),
                SizedBox(width: 10),
                _buildDateField(
                  hint: 'DD',
                  onChanged: (value) => controller.day.value = value,
                ),
                SizedBox(width: 10),
                _buildDateField(
                  hint: 'YYYY',
                  onChanged: (value) => controller.year.value = value,
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildDropdown(
              label: 'Pronouns (optional)',
              items: ['He/Him', 'She/Her', 'They/Them'],
              onChanged: (value) => controller.pronouns.value = value!,
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle continue action
                },
                style: ElevatedButton.styleFrom(
                  // primary: Colors.white,
                  // onPrimary: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required Function(String) onChanged, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        TextField(
          onChanged: onChanged,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({required String hint, required Function(String) onChanged}) {
    return Expanded(
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({required String label, required List<String> items, required Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        DropdownButtonFormField<String>(
          value: items.first,
          dropdownColor: Colors.black,
          style: TextStyle(color: Colors.white),
          onChanged: onChanged,
          items: items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ))
              .toList(),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    home: RegistrationPage(),
  ));
}
