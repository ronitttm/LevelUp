import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/task_utils.dart';
import '../../../models/task_difficulty.dart';
import '../providers/admin_provider.dart';
import '../widgets/member_tile.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminScreen> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  final Set<String> selectedMembers = {};

  TaskDifficulty difficulty = TaskDifficulty.moderate;
  DateTime selectedDate = DateTime.now();

  bool loading = false;

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && mounted) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    taskController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> assignTask() async {
    if (loading) return;
    if (selectedMembers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Select a member first.")));
      return;
    }

    if (taskController.text.trim().isEmpty) {
      return;
    }

    final members = selectedMembers.toList();
    final title = taskController.text.trim();
    final taskDifficulty = TaskUtils.toStringValue(difficulty);
    final taskDate = selectedDate;
    final assigned = <String>[];
    final repository = ref.read(adminRepositoryProvider);
    setState(() {
      loading = true;
    });

    try {
      for (final memberId in members) {
        await repository.assignTask(
          memberId: memberId,
          title: title,
          difficulty: taskDifficulty,
          taskDate: taskDate,
        );
        assigned.add(memberId);
        if (!mounted) return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Task assigned to ${assigned.length} members 🚀"),
        ),
      );

      taskController.clear();

      setState(() {
        selectedMembers.clear();
        difficulty = TaskDifficulty.moderate;
        selectedDate = DateTime.now();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => selectedMembers.removeAll(assigned));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${assigned.length} assigned. The remaining assignments could not be confirmed; check before retrying.',
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: taskController,
              enabled: !loading,
              decoration: const InputDecoration(labelText: "Task Title"),
            ),

            const SizedBox(height: 20),

            DropdownButton<TaskDifficulty>(
              value: difficulty,
              isExpanded: true,
              items: TaskDifficulty.values.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(TaskUtils.getLabel(e)),
                );
              }).toList(),
              onChanged: loading
                  ? null
                  : (value) {
                      setState(() {
                        difficulty = value!;
                      });
                    },
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: loading ? null : pickDate,

              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),

                    const SizedBox(width: 12),

                    Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const Spacer(),

                    const Icon(Icons.edit_calendar),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: searchController,

              decoration: InputDecoration(
                hintText: "Search members...",
                prefixIcon: const Icon(Icons.search),

                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            searchQuery = "";
                          });
                        },
                      )
                    : null,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),

            const SizedBox(height: 15),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Members",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: membersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),

                error: (e, _) => Center(child: Text(e.toString())),

                data: (members) {
                  final filteredMembers = members.where((member) {
                    return member.displayName.toLowerCase().contains(
                      searchQuery,
                    );
                  }).toList();

                  final allSelected =
                      filteredMembers.isNotEmpty &&
                      filteredMembers.every(
                        (m) => selectedMembers.contains(m.id),
                      );

                  return Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: allSelected,

                            onChanged: loading
                                ? null
                                : (_) {
                                    setState(() {
                                      if (allSelected) {
                                        for (final member in filteredMembers) {
                                          selectedMembers.remove(member.id);
                                        }
                                      } else {
                                        for (final member in filteredMembers) {
                                          selectedMembers.add(member.id);
                                        }
                                      }
                                    });
                                  },
                          ),

                          const Text(
                            "Select All",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const Spacer(),

                          Text("${selectedMembers.length} selected"),
                        ],
                      ),

                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredMembers.length,

                          itemBuilder: (_, index) {
                            final member = filteredMembers[index];

                            return MemberTile(
                              member: member,

                              selected: selectedMembers.contains(member.id),

                              onTap: () {
                                if (loading) return;
                                setState(() {
                                  if (selectedMembers.contains(member.id)) {
                                    selectedMembers.remove(member.id);
                                  } else {
                                    selectedMembers.add(member.id);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : assignTask,

                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Assign Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
