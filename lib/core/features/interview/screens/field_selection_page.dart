import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import '../models/field_data.dart';
import '../utils/background_decorations.dart';
import '../widgets/gradient_button.dart';
import 'interview_screen.dart';
import 'history_screen.dart';

class FieldSelectionPage extends StatefulWidget {
  const FieldSelectionPage({super.key});

  @override
  State<FieldSelectionPage> createState() => _FieldSelectionPageState();
}

class _FieldSelectionPageState extends State<FieldSelectionPage> {
  String? selectedField;
  List<String> selectedTechnologies = [];
  String? selectedDifficulty;

  bool get isMultiSelect =>
      selectedField != null &&
      FieldData.multiSelectTracks.contains(selectedField);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          const BackgroundDecorations(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 70),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage("assets/images/home4.png"),
                    ),
                    IconButton(
                      icon: const Icon(Icons.history, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryScreen(),
                          ),
                        );
                      },
                      tooltip: 'View Interview History',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Field selection label
              const Text(
                'Select Track',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.lightText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    FieldData.fieldTechnologies.keys.map((field) {
                      return ChoiceChip(
                        label: Text(field),
                        selected: selectedField == field,
                        onSelected: (selected) {
                          setState(() {
                            selectedField = selected ? field : null;
                            selectedTechnologies.clear();
                            selectedDifficulty = null;
                          });
                        },
                        backgroundColor: AppColors.darkPurple,
                        selectedColor: Colors.purple[400],
                        labelStyle: TextStyle(
                          color:
                              selectedField == field
                                  ? Colors.white
                                  : Colors.white70,
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 32),

              if (selectedField != null) ...[
                Text(
                  'Select Technology${isMultiSelect ? ' (Multiple allowed)' : ''}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      FieldData.fieldTechnologies[selectedField]!.map((tech) {
                        return ChoiceChip(
                          label: Text(tech),
                          selected: selectedTechnologies.contains(tech),
                          onSelected: (selected) {
                            setState(() {
                              if (isMultiSelect) {
                                if (selected) {
                                  selectedTechnologies.add(tech);
                                } else {
                                  selectedTechnologies.remove(tech);
                                }
                              } else {
                                selectedTechnologies = selected ? [tech] : [];
                              }
                              if (selectedTechnologies.isEmpty) {
                                selectedDifficulty = null;
                              }
                            });
                          },
                          backgroundColor: AppColors.darkPurple,
                          selectedColor: Colors.purple[400],
                          labelStyle: TextStyle(
                            color:
                                selectedTechnologies.contains(tech)
                                    ? Colors.white
                                    : Colors.white70,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 40),
              ],

              if (selectedTechnologies.isNotEmpty) ...[
                const Text(
                  'Select Difficulty',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      FieldData.difficulties.map((difficulty) {
                        return ChoiceChip(
                          label: Text(difficulty),
                          selected: selectedDifficulty == difficulty,
                          onSelected: (selected) {
                            setState(() {
                              selectedDifficulty = selected ? difficulty : null;
                            });
                          },
                          backgroundColor: AppColors.darkPurple,
                          selectedColor: Colors.purple[400],
                          labelStyle: TextStyle(
                            color:
                                selectedDifficulty == difficulty
                                    ? Colors.white
                                    : Colors.white70,
                          ),
                        );
                      }).toList(),
                ),
              ],
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GradientButton(
                  text: "Start",
                  height: 75,
                  onPressed:
                      selectedField != null &&
                              selectedTechnologies.isNotEmpty &&
                              selectedDifficulty != null
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => InterviewScreen(
                                      field: selectedField!,
                                      technologies: selectedTechnologies,
                                      difficulty: selectedDifficulty!,
                                    ),
                              ),
                            );
                          }
                          : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
