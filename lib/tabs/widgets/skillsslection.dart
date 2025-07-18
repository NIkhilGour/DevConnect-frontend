import 'package:devconnect/core/jwtservice.dart';
import 'package:devconnect/tabs/apiServices/getskills.dart';
import 'package:devconnect/tabs/model/skill.dart';

import 'package:flutter/material.dart';

class Skillsselection extends StatefulWidget {
  const Skillsselection(
      {super.key, required this.selectedSkills, required this.onselect});

  final List<Skill> selectedSkills;
  final Function(List<Skill>) onselect;
  @override
  State<Skillsselection> createState() => _SkillsselectionState();
}

class _SkillsselectionState extends State<Skillsselection> {
  List<Skill> allSkills = [];
  void fetchSkills() async {
    final token = await JWTService.gettoken();
    final List<Skill>? result = await getAllSkills(token!);
    if (result == null) return;
    setState(() {
      allSkills = result;
    });
  }

  @override
  void initState() {
    fetchSkills();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Skill> tempSelected = List.from(widget.selectedSkills);
    return AlertDialog(
      title: const Text('Select Skills'),
      content: SizedBox(
        width: double.maxFinite,
        child: StatefulBuilder(
          builder: (context, setStateDialog) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: allSkills.length,
              itemBuilder: (context, index) {
                final skill = allSkills[index];
                return CheckboxListTile(
                  title: Text(skill.skill!),
                  value: tempSelected.contains(skill),
                  onChanged: (bool? value) {
                    setStateDialog(() {
                      if (value == true) {
                        tempSelected.add(skill);
                      } else {
                        tempSelected.remove(skill);
                      }
                    });
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onselect(tempSelected);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
