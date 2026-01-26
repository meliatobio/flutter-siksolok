import 'package:flutter/material.dart';

Widget buildSearchBar() {
  return Container(
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F6F8),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const Icon(Icons.search, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Cari indikator...',
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    ),
  );
}
