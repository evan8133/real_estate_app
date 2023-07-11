import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.r),
      child: Column(
        children: [
          _buildSearchField(),
          SizedBox(height: 20.h),
          _buildFilterOptions(context),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return const TextField(
      decoration: InputDecoration(
        labelText: 'Search properties',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget _buildFilterOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filters',
          style: GoogleFonts.notoSans(
              fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w, // space between chips
          children: [
            FilterChip(
              label: const Text('Price Low to High'),
              onSelected: (bool value) {},
            ),
            FilterChip(
              label: const Text('Price High to Low'),
              onSelected: (bool value) {},
            ),
            FilterChip(
              label: const Text('Bedrooms'),
              onSelected: (bool value) {},
            ),
            FilterChip(
              label: const Text('Bathrooms'),
              onSelected: (bool value) {},
            ),
            FilterChip(
              label: const Text('Square Feet'),
              onSelected: (bool value) {},
            ),
            FilterChip(
              label: const Text('Lot Size'),
              onSelected: (bool value) {},
            ),
          ],
        ),
      ],
    );
  }
}
