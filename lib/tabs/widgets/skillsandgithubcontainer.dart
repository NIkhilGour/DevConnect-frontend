import 'package:devconnect/tabs/model/post.dart';
import 'package:devconnect/tabs/model/skill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkillsAndGithubContainer extends StatelessWidget {
  const SkillsAndGithubContainer(
      {super.key, required this.skills, required this.github});
  final List<TechSkills> skills;
  final String github;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skills',
              style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: List.generate(skills.length, (index) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: const Color(0xFF876FE8).withOpacity(0.1),
                    ),
                    child: Text(
                      skills[index].skill!,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.sp),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.w),
              child: Text(
                'Github',
                style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.w),
              child: Text(
                github,
                style: TextStyle(fontSize: 19.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
