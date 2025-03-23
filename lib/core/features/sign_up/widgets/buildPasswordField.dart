Widget _buildPasswordField(String hint, TextEditingController controller, bool isVisible, VoidCallback toggleVisibility, [String? Function(String?)? validator]) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator ?? (value) => value!.isEmpty ? "Password is required" : null,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(Icons.lock, color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: Color(0xFF3E2C5B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }
