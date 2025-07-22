import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustemTextFIeld extends StatefulWidget {
  final int? minLine;
  final int? maxline;
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool password;
  final bool readOnly;
  String? Function(String?)? validator;
  VoidCallback? onTap;
  TextInputType? keyboardType;
  CustemTextFIeld({
    super.key,
    this.maxline,
    required this.label,
    required this.hintText,
    required this.controller,
    this.password = false,
    this.readOnly = false,
    this.validator,
    this.minLine,
    this.onTap,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustemTextFIeld> createState() => _CustemTextFIeldState();
}

class _CustemTextFIeldState extends State<CustemTextFIeld> {
  late bool _obscureText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obscureText = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: widget.maxline ?? widget.minLine,
          minLines: widget.minLine,
          validator: widget.validator,
          readOnly: widget.readOnly,
          controller: widget.controller,
          obscureText: _obscureText,
          onTap: widget.onTap,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 253, 253),
            suffixIcon:
                widget.password
                    ? IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 229, 229, 229),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
