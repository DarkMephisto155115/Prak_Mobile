import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terra_brain/presentation/controllers/register_controller.dart';

class RegistrationPage extends GetView<RegistrationController> {
  const RegistrationPage({super.key});

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Colors.grey,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      controller.birthDateController.text =
          "${pickedDate.toLocal()}".split(' ')[0];
      controller.birthDate.value = controller.birthDateController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tell us about yourself',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
            // Profile image selection
              // GestureDetector(
              // onTap: () {
              //   controller.pickImage();
              // },
              // child: Obx(() {
              //   return CircleAvatar(
              //     radius: 50,
              //     backgroundImage: controller.profileImagePath.value.isEmpty
              //         ? AssetImage('assets/images/default_profile.jpeg')
              //         : FileImage(File(controller.profileImagePath.value))
              //             as ImageProvider,
              //   );
              // }),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'name',
                onChanged: (value) => controller.name.value = value,
              ),
              _buildTextField(
                label: 'Email',
                onChanged: (value) => controller.email.value = value,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'password',
                onChanged: (value) => controller.password.value = value,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Username',
                onChanged: (value) => controller.username.value = value,
                hint: 'Choose a name to protect your privacy.',
              ),
              const SizedBox(height: 20),
              const Text(
                'When\'s your birthday?',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.birthDateController,
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Select Date',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
              _buildDropdown(
                label: 'Pronouns (optional)',
                items: ['He/Him', 'She/Her', 'They/Them'],
                onChanged: (value) => controller.pronouns.value = value!,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await controller.register();
                      Get.snackbar(
                        'Success',
                        'Registration successful',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                      Get.offAllNamed('/home');
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        e.toString(),
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      required Function(String) onChanged,
      String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        TextField(
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
      {required String label,
      required List<String> items,
      required Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        DropdownButtonFormField<String>(
          value: items.first,
          dropdownColor: Colors.black,
          style: const TextStyle(color: Colors.white),
          onChanged: onChanged,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          decoration: const InputDecoration(
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
