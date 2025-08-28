// import 'package:flutter/material.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const CustomBottomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       shape: const CircularNotchedRectangle(), // notch for FAB
//       notchMargin: 8,
//       elevation: 8,
//       color: Colors.white,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(Icons.home, "Home", 0),
//           _buildNavItem(Icons.list, "Tasks", 1),
//           const SizedBox(width: 48), // space for FAB
//           _buildNavItem(Icons.person, "Profile", 2),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, String label, int index) {
//     final isSelected = index == currentIndex;
//     return Expanded(
//       // <-- ensures equal spacing and prevents overflow
//       child: InkWell(
//         onTap: () => onTap(index),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 6), // reduced padding
//           child: Column(
//             mainAxisSize: MainAxisSize.min, // <-- prevents extra height
//             children: [
//               Icon(
//                 icon,
//                 size: 24, // fix icon size
//                 color: isSelected ? Colors.blue : Colors.grey,
//               ),
//               const SizedBox(height: 2), // reduce spacing
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 11, // smaller font
//                   color: isSelected ? Colors.blue : Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//----------------

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      elevation: 8,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // _buildNavItem(Icons.home, "Home", 0),
                _buildNavItem(Symbols.home, "Home", 0),

                _buildNavItem(Symbols.list, "Tasks", 1),
              ],
            ),
          ),

          Row(children: [_buildNavItem(Symbols.report, "Report", 2)]),

          Row(children: [_buildNavItem(Symbols.person, "Profile", 3)]),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = index == currentIndex;
    return InkWell(
      onTap: () => onTap(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.black87 : Colors.grey,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.black87 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
