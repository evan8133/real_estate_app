import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/services/firestore_properties_methods.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          children: [
            _buildSearchField(),
            SizedBox(height: 20.h),
            _buildFilterOptions(context),
          ],
        ),
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
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
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
        FutureBuilder(
          future: context.read<PropertyService>().queryProperties(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            }
            if (snapshot.data == null) {
              return const Center(child: Text('No properties found!'));
            }
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].title),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
