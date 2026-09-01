import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals.dart';

import 'app_router.gr.dart';
import 'assignment_engine.dart';
import 'assignment_store.dart';
import 'domain.dart';
import 'features/speech/application/speech_controller.dart';
import 'features/speech/presentation/speech_mic_button.dart';
import 'signals/embedded_signal.dart';

@RoutePage()
class AssignmentShellPage extends StatefulWidget {
  const AssignmentShellPage({super.key});

  @override
  State<AssignmentShellPage> createState() => _AssignmentShellPageState();
}

class _AssignmentShellPageState extends State<AssignmentShellPage> {
  static const _welcomeIntroSeenKey = 'welcome_intro_seen';
  Function? _embeddedEffectDispose;

  @override
  void initState() {
    super.initState();
    _embeddedEffectDispose = effect(() {
      if (!embeddedSignal.value) {
        _showWelcomeIntro();
      }
    });
  }

  Future<void> _showWelcomeIntro() async {
    if (embeddedSignal.value) {
      return;
    }

    try {
      final preferences = await SharedPreferences.getInstance();
      if (preferences.getBool(_welcomeIntroSeenKey) ?? false) {
        return;
      }

      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Welcome to Ring Assignments'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Set up your tournament in four quick steps:'),
              SizedBox(height: 12),
              Text('1. Add competitors by CSV or individually.'),
              Text('2. Add judges and mark their qualifications.'),
              Text('3. Set the number of rings and rank order.'),
              Text('4. Generate, review, and display assignments.'),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Get started'),
            ),
          ],
        ),
      );
      await preferences.setBool(_welcomeIntroSeenKey, true);
    } catch (_) {
      // Continue without onboarding if local preferences are unavailable.
    }
  }

  @override
  void dispose() {
    _embeddedEffectDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        CompetitorsRoute(),
        JudgesRoute(),
        RingSetupRoute(),
        AssignmentsRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          appBar: AppBar(title: Text(_tabTitle(tabsRouter.activeIndex))),
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: tabsRouter.setActiveIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.badge_outlined),
                selectedIcon: Icon(Icons.badge),
                label: 'Competitors',
              ),
              NavigationDestination(
                icon: Icon(Icons.groups_outlined),
                selectedIcon: Icon(Icons.groups),
                label: 'Judges',
              ),
              NavigationDestination(
                icon: Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view),
                label: 'Rings',
              ),
              NavigationDestination(
                icon: Icon(Icons.assignment_outlined),
                selectedIcon: Icon(Icons.assignment),
                label: 'Assignments',
              ),
            ],
          ),
        );
      },
    );
  }
}

String _tabTitle(int index) {
  switch (index) {
    case 0:
      return 'Competitors';
    case 1:
      return 'Judges';
    case 2:
      return 'Rings';
    case 3:
      return 'Assignments';
    default:
      return '';
  }
}

InputDecoration _dictationDecoration(
  BuildContext context, {
  required TextEditingController controller,
  required String labelText,
  Widget? prefixIcon,
  InputBorder? border,
}) {
  return InputDecoration(
    border: border,
    labelText: labelText,
    prefixIcon: prefixIcon,
    suffixIcon: SpeechMicButton(
      controller: controller,
      speech: speechController,
      appendToExistingText: false,
      autoStopAfterText: true,
      onError: (message) {
        ScaffoldMessenger.maybeOf(
          context,
        )?.showSnackBar(SnackBar(content: Text(message)));
      },
    ),
  );
}

@RoutePage()
class RingSetupPage extends StatefulWidget {
  const RingSetupPage({super.key});

  @override
  State<RingSetupPage> createState() => _RingSetupPageState();
}

class _RingSetupPageState extends State<RingSetupPage> {
  late final TextEditingController _ringCountController;
  late final VoidCallback _disposeRingCountSubscription;
  late final VoidCallback _disposeRankOrderSubscription;

  @override
  void initState() {
    super.initState();
    _ringCountController = TextEditingController(
      text: ringCountSignal.value.toString(),
    );
    _disposeRingCountSubscription = ringCountSignal.subscribe(
      (_) => _refresh(),
    );
    _disposeRankOrderSubscription = rankOrderSignal.subscribe(
      (_) => _refresh(),
    );
  }

  @override
  void dispose() {
    _disposeRankOrderSubscription();
    _disposeRingCountSubscription();
    _ringCountController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (!mounted) {
      return;
    }

    final nextText = ringCountSignal.value.toString();
    if (_ringCountController.text != nextText) {
      _ringCountController.text = nextText;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ranks = rankOrderSignal.value;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Ring Setup', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _ringCountController,
            keyboardType: TextInputType.number,
            decoration: _dictationDecoration(
              context,
              controller: _ringCountController,
              border: OutlineInputBorder(),
              labelText: 'Number of rings',
              prefixIcon: const Icon(Icons.grid_view_outlined),
            ),
            onChanged: _updateRingCount,
            onSubmitted: _submitRingCount,
          ),
          const SizedBox(height: 16),
          Text('Rank Order', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (var index = 0; index < ranks.length; index += 1)
            _RankOrderTile(
              key: ValueKey('rank-order-${ranks[index].name}'),
              rank: ranks[index],
              position: index + 1,
              canMoveUp: index > 0,
              canMoveDown: index < ranks.length - 1,
              onMoveUp: () => _moveRank(ranks[index], -1),
              onMoveDown: () => _moveRank(ranks[index], 1),
            ),
        ],
      ),
    );
  }

  void _moveRank(BeltRank rank, int direction) {
    moveRankOrder(rank, direction);
    if (mounted) {
      setState(() {});
    }
  }

  void _updateRingCount(String value) {
    final count = int.tryParse(value);
    if (count == null) {
      return;
    }

    setRingCount(count);
  }

  void _submitRingCount(String value) {
    final count = int.tryParse(value);
    if (count == null || count < 1) {
      _ringCountController.text = ringCountSignal.value.toString();
      return;
    }

    setRingCount(count);
  }
}

@RoutePage()
class RingEditorPage extends StatefulWidget {
  const RingEditorPage({super.key, this.setupId, this.initialRingNumber});

  final String? setupId;
  final int? initialRingNumber;

  @override
  State<RingEditorPage> createState() => _RingEditorPageState();
}

class _RingEditorPageState extends State<RingEditorPage> {
  late final TextEditingController _ringNumberController;
  AgeGroup? _ageGroup;

  @override
  void initState() {
    super.initState();
    final setup = widget.setupId == null
        ? null
        : manualRingSetupById(widget.setupId!);
    _ringNumberController = TextEditingController(
      text: (setup?.ringNumber ?? widget.initialRingNumber ?? 1).toString(),
    );
    _ageGroup = setup?.ageGroup;
  }

  @override
  void dispose() {
    _ringNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Ring')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _ringNumberController,
            keyboardType: TextInputType.number,
            decoration: _dictationDecoration(
              context,
              controller: _ringNumberController,
              border: OutlineInputBorder(),
              labelText: 'Ring number',
              prefixIcon: const Icon(Icons.grid_view_outlined),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<AgeGroup>(
            initialValue: _ageGroup,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Age group',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: [
              for (final ageGroup in AgeGroup.values)
                DropdownMenuItem(
                  value: ageGroup,
                  child: Text(ageGroup.displayName),
                ),
            ],
            onChanged: (value) {
              setState(() {
                _ageGroup = value;
              });
            },
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _save() {
    final ringNumber = int.tryParse(_ringNumberController.text);
    if (ringNumber == null || ringNumber < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a ring number greater than zero.')),
      );
      return;
    }

    saveManualRingSetup(
      ManualRingSetup(
        id: widget.setupId ?? 'ring-$ringNumber',
        ringNumber: ringNumber,
        ageGroup: _ageGroup,
      ),
    );
    context.router.maybePop();
  }
}

class _RankOrderTile extends StatelessWidget {
  const _RankOrderTile({
    super.key,
    required this.rank,
    required this.position,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onMoveUp,
    required this.onMoveDown,
  });

  final BeltRank rank;
  final int position;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('$position')),
        title: Text(rank.displayName),
        subtitle: Text('Rank $position'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: canMoveUp ? onMoveUp : null,
              tooltip: 'Move up',
              icon: const Icon(Icons.arrow_upward),
            ),
            IconButton(
              onPressed: canMoveDown ? onMoveDown : null,
              tooltip: 'Move down',
              icon: const Icon(Icons.arrow_downward),
            ),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class JudgesPage extends StatefulWidget {
  const JudgesPage({super.key});

  @override
  State<JudgesPage> createState() => _JudgesPageState();
}

class _JudgesPageState extends State<JudgesPage> {
  late final VoidCallback _disposeJudgesSubscription;

  @override
  void initState() {
    super.initState();
    _disposeJudgesSubscription = judgesSignal.subscribe((_) => _refresh());
  }

  @override
  void dispose() {
    _disposeJudgesSubscription();
    super.dispose();
  }

  void _refresh() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final judges = judgesSignal.value;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Judges',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              OutlinedButton.icon(
                onPressed: _importCsv,
                icon: const Icon(Icons.upload_file_outlined),
                label: const Text('Import CSV'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: judges.isEmpty ? null : _clearAllJudges,
                icon: const Icon(Icons.delete_sweep_outlined),
                label: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (judges.isEmpty)
            const ListTile(title: Text('No judges yet'))
          else
            for (final judge in judges)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(judge.name),
                  subtitle: Text(
                    '${judge.ataNumber.isEmpty ? '' : 'ATA ${judge.ataNumber} - '}'
                    '${judge.rank.displayName} - '
                    '${judge.qualification.displayName} - '
                    'School: ${judge.schoolId}',
                  ),
                  trailing: judge.isAvailable
                      ? const Icon(Icons.check_circle_outline)
                      : const Icon(Icons.block),
                  onTap: () {
                    context.router.root.push(
                      JudgeEditorRoute(judgeId: judge.id),
                    );
                  },
                ),
              ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'judge-add-fab',
        onPressed: () {
          context.router.root.push(JudgeEditorRoute());
        },
        tooltip: 'Add judge',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _importCsv() async {
    try {
      const csvTypeGroup = XTypeGroup(
        label: 'CSV files',
        extensions: ['csv'],
        mimeTypes: ['text/csv'],
        uniformTypeIdentifiers: ['public.comma-separated-values-text'],
      );
      final file = await openFile(acceptedTypeGroups: const [csvTypeGroup]);
      if (file == null) {
        return;
      }

      final judges = parseJudgesCsv(await file.readAsString());
      if (judges.isEmpty) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No valid judges found in CSV.')),
        );
        return;
      }

      importJudges(judges);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${judges.length} judges added.')));
    } on Exception catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not import CSV: $error')));
    }
  }

  Future<void> _clearAllJudges() async {
    final shouldClear = await _confirmClearAll(
      context: context,
      title: 'Clear all judges?',
      content: 'This removes every judge and clears generated assignments.',
    );
    if (!shouldClear) {
      return;
    }

    clearJudges();
  }
}

@RoutePage()
class JudgeEditorPage extends StatefulWidget {
  const JudgeEditorPage({super.key, this.judgeId});

  final String? judgeId;

  @override
  State<JudgeEditorPage> createState() => _JudgeEditorPageState();
}

class _JudgeEditorPageState extends State<JudgeEditorPage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _ataNumberController;
  late final TextEditingController _schoolController;
  BeltRank _rank = BeltRank.white;
  JudgeQualification _qualification = JudgeQualification.corner;
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    final judge = widget.judgeId == null ? null : judgeById(widget.judgeId!);
    final names = _splitJudgeName(judge?.name ?? '');
    _firstNameController = TextEditingController(text: names.$1);
    _lastNameController = TextEditingController(text: names.$2);
    _ataNumberController = TextEditingController(text: judge?.ataNumber ?? '');
    _schoolController = TextEditingController(text: judge?.schoolId ?? '');
    _rank = judge?.rank ?? BeltRank.white;
    _qualification = judge?.qualification ?? JudgeQualification.corner;
    _isAvailable = judge?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _ataNumberController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.judgeId == null ? 'Add Judge' : 'Edit Judge'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _firstNameController,
            textCapitalization: TextCapitalization.words,
            decoration: _dictationDecoration(
              context,
              controller: _firstNameController,
              border: OutlineInputBorder(),
              labelText: 'First name',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _lastNameController,
            textCapitalization: TextCapitalization.words,
            decoration: _dictationDecoration(
              context,
              controller: _lastNameController,
              border: OutlineInputBorder(),
              labelText: 'Last name',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ataNumberController,
            keyboardType: TextInputType.number,
            decoration: _dictationDecoration(
              context,
              controller: _ataNumberController,
              border: OutlineInputBorder(),
              labelText: 'ATA number',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<BeltRank>(
            initialValue: _rank,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Rank',
            ),
            items: [
              for (final rank in BeltRank.values)
                DropdownMenuItem(value: rank, child: Text(rank.displayName)),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _rank = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<JudgeQualification>(
            initialValue: _qualification,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Qualification',
            ),
            items: [
              for (final qualification in JudgeQualification.values)
                DropdownMenuItem(
                  value: qualification,
                  child: Text(qualification.displayName),
                ),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _qualification = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _schoolController,
            textCapitalization: TextCapitalization.words,
            decoration: _dictationDecoration(
              context,
              controller: _schoolController,
              border: OutlineInputBorder(),
              labelText: 'School',
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Available'),
            value: _isAvailable,
            onChanged: (value) {
              setState(() {
                _isAvailable = value;
              });
            },
          ),
          const SizedBox(height: 24),
          if (widget.judgeId != null) ...[
            OutlinedButton.icon(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
            ),
            const SizedBox(height: 12),
          ],
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _save() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final ataNumber = _ataNumberController.text.trim();
    final school = _schoolController.text.trim();
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        ataNumber.isEmpty ||
        school.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter first name, last name, ATA number, and school.'),
        ),
      );
      return;
    }

    saveJudge(
      Judge(
        id: widget.judgeId ?? 'judge-$ataNumber',
        name: '$firstName $lastName',
        ataNumber: ataNumber,
        rank: _rank,
        schoolId: school,
        qualification: _qualification,
        isAvailable: _isAvailable,
      ),
    );
    context.router.maybePop();
  }

  void _delete() {
    final judgeId = widget.judgeId;
    if (judgeId == null) {
      return;
    }

    deleteJudge(judgeId);
    context.router.maybePop();
  }
}

(String, String) _splitJudgeName(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) {
    return ('', '');
  }
  if (parts.length == 1) {
    return (parts.first, '');
  }

  return (parts.first, parts.skip(1).join(' '));
}

@RoutePage()
class CompetitorsPage extends StatefulWidget {
  const CompetitorsPage({super.key});

  @override
  State<CompetitorsPage> createState() => _CompetitorsPageState();
}

class _CompetitorsPageState extends State<CompetitorsPage> {
  late final VoidCallback _disposeCompetitorsSubscription;

  @override
  void initState() {
    super.initState();
    _disposeCompetitorsSubscription = competitorsSignal.subscribe(
      (_) => _refresh(),
    );
  }

  @override
  void dispose() {
    _disposeCompetitorsSubscription();
    super.dispose();
  }

  void _refresh() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final competitors = competitorsSignal.value;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Competitors',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _importCsv,
                      icon: const Icon(Icons.upload_file_outlined),
                      label: const Text('Import CSV'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: competitors.isEmpty
                          ? null
                          : _clearAllCompetitors,
                      icon: const Icon(Icons.delete_sweep_outlined),
                      label: const Text('Clear All'),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _showCompetitorEditor,
                      tooltip: 'Add competitor',
                      icon: const Icon(Icons.person_add_alt_1_outlined),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: Text('${competitors.length} competitors'),
            subtitle: const Text(
              'Import CSV files or enter competitors manually.',
            ),
          ),
        ),
        if (competitors.isEmpty)
          const ListTile(title: Text('No competitors yet'))
        else
          for (final competitor in competitors)
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(competitor.name),
                subtitle: Text(
                  'ATA ${competitor.ataNumber} - '
                  '${competitor.ageGroup.displayName} - '
                  '${competitor.rank.displayName}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCompetitorEditor(competitor: competitor),
              ),
            ),
      ],
    );
  }

  Future<void> _importCsv() async {
    try {
      const csvTypeGroup = XTypeGroup(
        label: 'CSV files',
        extensions: ['csv'],
        mimeTypes: ['text/csv'],
        uniformTypeIdentifiers: ['public.comma-separated-values-text'],
      );
      final file = await openFile(acceptedTypeGroups: const [csvTypeGroup]);
      if (file == null) {
        return;
      }

      final competitors = parseCompetitorsCsv(await file.readAsString());
      if (competitors.isEmpty) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No valid competitors found in CSV.')),
        );
        return;
      }

      importCompetitors(competitors);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${competitors.length} competitors added.')),
      );
    } on Exception catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not import CSV: $error')));
    }
  }

  Future<void> _showCompetitorEditor({Competitor? competitor}) async {
    final result = await showDialog<_CompetitorEditorResult>(
      context: context,
      builder: (context) => _CompetitorEditorDialog(competitor: competitor),
    );
    if (result == null) {
      return;
    }

    if (result.deleteCompetitorId != null) {
      deleteCompetitor(result.deleteCompetitorId!);
      return;
    }

    final savedCompetitor = result.competitor;
    if (savedCompetitor == null) {
      return;
    }

    saveCompetitor(savedCompetitor);
  }

  Future<void> _clearAllCompetitors() async {
    final shouldClear = await _confirmClearAll(
      context: context,
      title: 'Clear all competitors?',
      content:
          'This removes every competitor and clears generated assignments.',
    );
    if (!shouldClear) {
      return;
    }

    clearCompetitors();
  }
}

Future<bool> _confirmClearAll({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Clear All'),
            ),
          ],
        ),
      ) ??
      false;
}

class _CompetitorEditorDialog extends StatefulWidget {
  const _CompetitorEditorDialog({this.competitor});

  final Competitor? competitor;

  @override
  State<_CompetitorEditorDialog> createState() =>
      _CompetitorEditorDialogState();
}

class _CompetitorEditorDialogState extends State<_CompetitorEditorDialog> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ataNumberController = TextEditingController();
  AgeGroup _ageGroup = AgeGroup.youthNineTen;
  BeltRank _rank = BeltRank.white;

  @override
  void initState() {
    super.initState();
    final competitor = widget.competitor;
    if (competitor == null) {
      return;
    }

    _firstNameController.text = competitor.firstName;
    _lastNameController.text = competitor.lastName;
    _ataNumberController.text = competitor.ataNumber;
    _ageGroup = competitor.ageGroup;
    _rank = competitor.rank;
  }

  @override
  void dispose() {
    _ataNumberController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.competitor == null ? 'Add Competitor' : 'Edit Competitor',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _firstNameController,
              textCapitalization: TextCapitalization.words,
              decoration: _dictationDecoration(
                context,
                controller: _firstNameController,
                labelText: 'First name',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              decoration: _dictationDecoration(
                context,
                controller: _lastNameController,
                labelText: 'Last name',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ataNumberController,
              keyboardType: TextInputType.number,
              decoration: _dictationDecoration(
                context,
                controller: _ataNumberController,
                labelText: 'ATA number',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<AgeGroup>(
              initialValue: _ageGroup,
              decoration: const InputDecoration(labelText: 'Age group'),
              items: [
                for (final ageGroup in AgeGroup.values)
                  DropdownMenuItem(
                    value: ageGroup,
                    child: Text(ageGroup.displayName),
                  ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _ageGroup = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<BeltRank>(
              initialValue: _rank,
              decoration: const InputDecoration(labelText: 'Rank'),
              items: [
                for (final rank in BeltRank.values)
                  DropdownMenuItem(value: rank, child: Text(rank.displayName)),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _rank = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        if (widget.competitor != null)
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pop(_CompetitorEditorResult.delete(widget.competitor!.id));
            },
            child: const Text('Delete'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }

  void _save() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final ataNumber = _ataNumberController.text.trim();
    if (firstName.isEmpty || lastName.isEmpty || ataNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter first name, last name, and ATA number.'),
        ),
      );
      return;
    }

    Navigator.of(context).pop(
      _CompetitorEditorResult.save(
        Competitor(
          id: widget.competitor?.id ?? 'competitor-$ataNumber',
          firstName: firstName,
          lastName: lastName,
          ataNumber: ataNumber,
          ageGroup: _ageGroup,
          rank: _rank,
        ),
      ),
    );
  }
}

class _CompetitorEditorResult {
  const _CompetitorEditorResult.save(this.competitor)
    : deleteCompetitorId = null;

  const _CompetitorEditorResult.delete(this.deleteCompetitorId)
    : competitor = null;

  final Competitor? competitor;
  final String? deleteCompetitorId;
}

@RoutePage()
class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  late final VoidCallback _disposeAssignmentsSubscription;
  late final VoidCallback _disposeCompetitorsSubscription;
  late final VoidCallback _disposeJudgesSubscription;
  int _currentRoundNumber = 1;

  @override
  void initState() {
    super.initState();
    _disposeAssignmentsSubscription = generatedManualAssignmentsSignal
        .subscribe((_) => _refresh());
    _disposeCompetitorsSubscription = competitorsSignal.subscribe(
      (_) => _refresh(),
    );
    _disposeJudgesSubscription = judgesSignal.subscribe((_) => _refresh());
  }

  @override
  void dispose() {
    _disposeJudgesSubscription();
    _disposeCompetitorsSubscription();
    _disposeAssignmentsSubscription();
    super.dispose();
  }

  void _refresh() {
    if (!mounted) {
      return;
    }

    setState(() {
      _currentRoundNumber = _clampedRoundNumber(
        generatedManualAssignmentsSignal.value,
        _currentRoundNumber,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final assignments = generatedManualAssignmentsSignal.value;
    final competitors = competitorsSignal.value;
    final centerJudgeCount = judgesSignal.value
        .where((judge) => judge.isAvailable && canCenterJudge(judge))
        .length;
    final cornerJudgeCount = judgesSignal.value
        .where((judge) => judge.isAvailable && canJudgeAtAll(judge))
        .length;
    final staffedRingsPerRound = effectiveManualRingsPerRound();
    final roundNumbers = _assignmentRoundNumbers(assignments);
    final currentRoundNumber = _clampedRoundNumber(
      assignments,
      _currentRoundNumber,
    );
    final currentRoundAssignments = assignments
        .where((assignment) => assignment.roundNumber == currentRoundNumber)
        .toList();
    final currentRoundIndex = roundNumbers.indexOf(currentRoundNumber);
    final canGoBack = currentRoundIndex > 0;
    final canGoForward =
        currentRoundIndex >= 0 && currentRoundIndex < roundNumbers.length - 1;

    return ColoredBox(
      color: const Color(0xFFE8F4FF),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.insights_outlined),
                    title: Text(
                      '${competitors.length} competitors',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      'Staffed rings per round: $staffedRingsPerRound of ${ringCountSignal.value}\n'
                      'Center judges: $centerJudgeCount - '
                      'Corner judges: $cornerJudgeCount',
                    ),
                    isThreeLine: true,
                  ),
                ),
                if (centerJudgeCount == 0)
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.warning_amber_outlined),
                      title: Text('No center judges available'),
                      subtitle: Text(
                        'Import or edit judges with Center qualification.',
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _generateAssignments,
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: const Text('Generate Assignments'),
                ),
              ],
            ),
          ),
          if (assignments.isEmpty)
            const Expanded(
              child: Center(child: Text('No assignments generated yet')),
            )
          else ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Round $currentRoundNumber',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Text(
                    '${currentRoundAssignments.length} rings',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: currentRoundAssignments.isEmpty
                        ? null
                        : () => _showAssignmentDisplay(assignments),
                    tooltip: 'Display round',
                    icon: const Icon(Icons.fullscreen),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                children: [
                  for (final assignment in currentRoundAssignments)
                    _GeneratedAssignmentCard(
                      assignment: assignment,
                      onTap: () => _showAssignmentEditor(assignment),
                    ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: canGoBack
                          ? () =>
                                _showRound(roundNumbers[currentRoundIndex - 1])
                          : null,
                      tooltip: 'Previous round',
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Round $currentRoundNumber of ${roundNumbers.length}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: canGoForward
                          ? () =>
                                _showRound(roundNumbers[currentRoundIndex + 1])
                          : null,
                      tooltip: 'Next round',
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _generateAssignments() {
    generateManualAssignments();
    setState(() {
      _currentRoundNumber = _clampedRoundNumber(
        generatedManualAssignmentsSignal.value,
        _currentRoundNumber,
      );
    });
    final centerJudgeCount = judgesSignal.value
        .where((judge) => judge.isAvailable && canCenterJudge(judge))
        .length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          centerJudgeCount == 0
              ? 'Generated ${generatedManualAssignmentsSignal.value.length} assignments, but no center judges are available.'
              : 'Generated ${generatedManualAssignmentsSignal.value.length} assignments.',
        ),
      ),
    );
  }

  Future<void> _showAssignmentEditor(GeneratedRingAssignment assignment) async {
    final updatedAssignment = await showDialog<GeneratedRingAssignment>(
      context: context,
      builder: (context) => _AssignmentEditorDialog(assignment: assignment),
    );
    if (updatedAssignment == null) {
      return;
    }

    saveGeneratedManualAssignment(updatedAssignment);
  }

  void _showAssignmentDisplay(List<GeneratedRingAssignment> assignments) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => _AssignmentDisplayPage(
          roundNumber: _assignmentRoundNumbers(assignments).first,
          assignments: assignments,
        ),
      ),
    );
  }

  void _showRound(int roundNumber) {
    setState(() {
      _currentRoundNumber = roundNumber;
    });
  }
}

class _AssignmentDisplayPage extends StatefulWidget {
  const _AssignmentDisplayPage({
    required this.roundNumber,
    required this.assignments,
  });

  final int roundNumber;
  final List<GeneratedRingAssignment> assignments;

  @override
  State<_AssignmentDisplayPage> createState() => _AssignmentDisplayPageState();
}

class _AssignmentDisplayPageState extends State<_AssignmentDisplayPage> {
  static const _slideDuration = Duration(seconds: 6);
  static const _fadeDuration = Duration(milliseconds: 1400);

  Timer? _timer;
  late int _roundNumber;
  int _assignmentIndex = 0;

  @override
  void initState() {
    super.initState();
    _roundNumber = _clampedRoundNumber(widget.assignments, widget.roundNumber);
    if (widget.assignments.length > 1) {
      _timer = Timer.periodic(_slideDuration, (_) => _showNextAssignment());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roundNumbers = _assignmentRoundNumbers(widget.assignments);
    final assignments = _assignmentsForRound(widget.assignments, _roundNumber);
    final assignment = assignments[_assignmentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF061626),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: AnimatedSwitcher(
                duration: _fadeDuration,
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: _AssignmentDisplaySlide(
                  key: ValueKey(assignment.id),
                  assignment: assignment,
                  roundNumber: _roundNumber,
                  assignmentCount: assignments.length,
                  assignmentPosition: _assignmentIndex + 1,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton.filledTonal(
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close display',
                icon: const Icon(Icons.close),
              ),
            ),
            if (roundNumbers.length > 1) ...[
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton.filledTonal(
                    onPressed: () => _showPreviousRound(roundNumbers),
                    tooltip: 'Previous round',
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton.filledTonal(
                    onPressed: () => _showNextRound(roundNumbers),
                    tooltip: 'Next round',
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPreviousRound(List<int> roundNumbers) {
    final currentRoundIndex = roundNumbers.indexOf(_roundNumber);
    final previousRoundIndex =
        (currentRoundIndex - 1 + roundNumbers.length) % roundNumbers.length;

    setState(() {
      _roundNumber = roundNumbers[previousRoundIndex];
      _assignmentIndex = 0;
    });
  }

  void _showNextRound(List<int> roundNumbers) {
    final currentRoundIndex = roundNumbers.indexOf(_roundNumber);
    final nextRoundIndex = (currentRoundIndex + 1) % roundNumbers.length;

    setState(() {
      _roundNumber = roundNumbers[nextRoundIndex];
      _assignmentIndex = 0;
    });
  }

  void _showNextAssignment() {
    final assignments = _assignmentsForRound(widget.assignments, _roundNumber);
    if (assignments.length <= 1) {
      return;
    }

    setState(() {
      _assignmentIndex = (_assignmentIndex + 1) % assignments.length;
    });
  }
}

class _AssignmentDisplaySlide extends StatelessWidget {
  const _AssignmentDisplaySlide({
    super.key,
    required this.assignment,
    required this.roundNumber,
    required this.assignmentCount,
    required this.assignmentPosition,
  });

  final GeneratedRingAssignment assignment;
  final int roundNumber;
  final int assignmentCount;
  final int assignmentPosition;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 620;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Round $roundNumber',
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF9DECF9),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Ring ${assignment.ringNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 92,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              assignment.rank.displayName,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                color: const Color(0xFFFFD166),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _DisplaySection(
                            title: 'Competitors',
                            child: _DisplayCompetitors(
                              competitors: assignment.competitors,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 2,
                          child: _DisplaySection(
                            title: 'Judges',
                            child: _DisplayJudges(assignment: assignment),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: _DisplaySection(
                            title: 'Competitors',
                            child: _DisplayCompetitors(
                              competitors: assignment.competitors,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _DisplaySection(
                            title: 'Judges',
                            child: _DisplayJudges(assignment: assignment),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              '$assignmentPosition of $assignmentCount',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFB7D7F5),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DisplaySection extends StatelessWidget {
  const _DisplaySection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0D2A44),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2DD4BF), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF9DECF9),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: SingleChildScrollView(child: child)),
          ],
        ),
      ),
    );
  }
}

class _DisplayCompetitors extends StatelessWidget {
  const _DisplayCompetitors({required this.competitors});

  final List<Competitor> competitors;

  @override
  Widget build(BuildContext context) {
    if (competitors.isEmpty) {
      return const Text(
        'No competitors',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return _DisplayCompetitorList(competitors: competitors);
  }
}

class _DisplayCompetitorList extends StatelessWidget {
  const _DisplayCompetitorList({required this.competitors});

  final List<Competitor> competitors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final competitor in competitors)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              competitor.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}

class _DisplayJudges extends StatelessWidget {
  const _DisplayJudges({required this.assignment});

  final GeneratedRingAssignment assignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DisplayJudge(role: 'Center', judge: assignment.centerJudge),
        const SizedBox(height: 16),
        _DisplayJudge(role: 'Corner', judge: assignment.cornerJudgeOne),
        const SizedBox(height: 16),
        _DisplayJudge(role: 'Corner', judge: assignment.cornerJudgeTwo),
      ],
    );
  }
}

class _DisplayJudge extends StatelessWidget {
  const _DisplayJudge({required this.role, required this.judge});

  final String role;
  final Judge? judge;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF123D5D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 84,
              child: Text(
                role,
                style: const TextStyle(
                  color: Color(0xFFFFD166),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: Text(
                judge?.name ?? 'Unassigned',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneratedAssignmentCard extends StatelessWidget {
  const _GeneratedAssignmentCard({
    required this.assignment,
    required this.onTap,
  });

  final GeneratedRingAssignment assignment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasMissingJudges = _assignmentHasMissingJudges(assignment);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: hasMissingJudges
            ? colorScheme.errorContainer.withValues(alpha: 0.35)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: hasMissingJudges
                ? colorScheme.error.withValues(alpha: 0.45)
                : const Color(0xFF82B9EE),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ring ${assignment.ringNumber}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Round ${assignment.roundNumber} - Ring ${assignment.ringNumber} - ${assignment.rank.displayName}',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      assignment.rank.displayName,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      hasMissingJudges
                          ? Icons.warning_amber_outlined
                          : Icons.chevron_right,
                      color: hasMissingJudges
                          ? colorScheme.error
                          : colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Competitors',
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                _CompetitorColumns(competitors: assignment.competitors),
                const _RingSectionDivider(),
                Text(
                  'Judges',
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: _JudgeAssignmentCell(
                        role: 'Corner',
                        judge: assignment.cornerJudgeOne,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _JudgeAssignmentCell(
                        role: 'Center',
                        judge: assignment.centerJudge,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _JudgeAssignmentCell(
                        role: 'Corner',
                        judge: assignment.cornerJudgeTwo,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RingSectionDivider extends StatelessWidget {
  const _RingSectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFB7D7F5)),
    );
  }
}

class _CompetitorColumns extends StatelessWidget {
  const _CompetitorColumns({required this.competitors});

  final List<Competitor> competitors;

  @override
  Widget build(BuildContext context) {
    if (competitors.isEmpty) {
      return Text(
        'No competitors',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      );
    }

    final splitIndex = (competitors.length / 2).ceil();
    final leftCompetitors = competitors.take(splitIndex).toList();
    final rightCompetitors = competitors.skip(splitIndex).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _CompetitorNameList(competitors: leftCompetitors)),
        const SizedBox(width: 12),
        Expanded(child: _CompetitorNameList(competitors: rightCompetitors)),
      ],
    );
  }
}

class _CompetitorNameList extends StatelessWidget {
  const _CompetitorNameList({required this.competitors});

  final List<Competitor> competitors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final competitor in competitors)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              competitor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}

class _JudgeAssignmentCell extends StatelessWidget {
  const _JudgeAssignmentCell({required this.role, required this.judge});

  final String role;
  final Judge? judge;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCenter = role == 'Center';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isCenter ? const Color(0xFFCDE7FF) : const Color(0xFFDFF7FF),
        borderRadius: BorderRadius.circular(10),
        border: isCenter
            ? Border.all(color: const Color(0xFF60A5FA))
            : Border.all(color: const Color(0xFF67E8F9)),
      ),
      child: Column(
        children: [
          Text(
            judge?.name ?? 'Unassigned',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            role,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isCenter ? colorScheme.primary : colorScheme.secondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

List<int> _assignmentRoundNumbers(List<GeneratedRingAssignment> assignments) {
  final roundNumbers = assignments
      .map((assignment) => assignment.roundNumber)
      .toSet()
      .toList();
  roundNumbers.sort();
  return roundNumbers;
}

List<GeneratedRingAssignment> _assignmentsForRound(
  List<GeneratedRingAssignment> assignments,
  int roundNumber,
) {
  return assignments
      .where((assignment) => assignment.roundNumber == roundNumber)
      .toList();
}

int _clampedRoundNumber(
  List<GeneratedRingAssignment> assignments,
  int roundNumber,
) {
  final roundNumbers = _assignmentRoundNumbers(assignments);
  if (roundNumbers.isEmpty) {
    return 1;
  }
  if (roundNumbers.contains(roundNumber)) {
    return roundNumber;
  }

  return roundNumbers.first;
}

bool _assignmentHasMissingJudges(GeneratedRingAssignment assignment) {
  return assignment.centerJudge == null ||
      assignment.cornerJudgeOne == null ||
      assignment.cornerJudgeTwo == null;
}

class _AssignmentEditorDialog extends StatefulWidget {
  const _AssignmentEditorDialog({required this.assignment});

  final GeneratedRingAssignment assignment;

  @override
  State<_AssignmentEditorDialog> createState() =>
      _AssignmentEditorDialogState();
}

class _AssignmentEditorDialogState extends State<_AssignmentEditorDialog> {
  late final TextEditingController _roundNumberController;
  late final TextEditingController _ringNumberController;
  late BeltRank _rank;
  String _centerJudgeId = '';
  String _cornerJudgeOneId = '';
  String _cornerJudgeTwoId = '';

  @override
  void initState() {
    super.initState();
    _roundNumberController = TextEditingController(
      text: widget.assignment.roundNumber.toString(),
    );
    _ringNumberController = TextEditingController(
      text: widget.assignment.ringNumber.toString(),
    );
    _rank = widget.assignment.rank;
    _centerJudgeId = widget.assignment.centerJudge?.id ?? '';
    _cornerJudgeOneId = widget.assignment.cornerJudgeOne?.id ?? '';
    _cornerJudgeTwoId = widget.assignment.cornerJudgeTwo?.id ?? '';
  }

  @override
  void dispose() {
    _roundNumberController.dispose();
    _ringNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final judges = judgesSignal.value;
    final assignedJudgeIds = _assignedJudgeIdsForRound(
      widget.assignment.roundNumber,
    );
    final centerJudges = judges
        .where((judge) => judge.isAvailable && canCenterJudge(judge))
        .toList();
    final cornerJudges = judges
        .where((judge) => judge.isAvailable && canJudgeAtAll(judge))
        .toList();

    return AlertDialog(
      title: const Text('Edit Assignment'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _roundNumberController,
              keyboardType: TextInputType.number,
              decoration: _dictationDecoration(
                context,
                controller: _roundNumberController,
                labelText: 'Round number',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ringNumberController,
              keyboardType: TextInputType.number,
              decoration: _dictationDecoration(
                context,
                controller: _ringNumberController,
                labelText: 'Ring number',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<BeltRank>(
              initialValue: _rank,
              decoration: const InputDecoration(labelText: 'Rank'),
              items: [
                for (final rank in BeltRank.values)
                  DropdownMenuItem(value: rank, child: Text(rank.displayName)),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _rank = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _JudgeDropdown(
              labelText: 'Center judge',
              judgeId: _centerJudgeId,
              judges: centerJudges,
              assignedJudgeIds: assignedJudgeIds,
              onChanged: (value) {
                setState(() {
                  _centerJudgeId = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _JudgeDropdown(
              labelText: 'Corner judge',
              judgeId: _cornerJudgeOneId,
              judges: cornerJudges,
              assignedJudgeIds: assignedJudgeIds,
              markCenterJudges: true,
              onChanged: (value) {
                setState(() {
                  _cornerJudgeOneId = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _JudgeDropdown(
              labelText: 'Corner judge',
              judgeId: _cornerJudgeTwoId,
              judges: cornerJudges,
              assignedJudgeIds: assignedJudgeIds,
              markCenterJudges: true,
              onChanged: (value) {
                setState(() {
                  _cornerJudgeTwoId = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }

  void _save() {
    final roundNumber = int.tryParse(_roundNumberController.text);
    if (roundNumber == null || roundNumber < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a round number greater than zero.'),
        ),
      );
      return;
    }

    final ringNumber = int.tryParse(_ringNumberController.text);
    if (ringNumber == null || ringNumber < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a ring number greater than zero.')),
      );
      return;
    }

    Navigator.of(context).pop(
      GeneratedRingAssignment(
        id: widget.assignment.id,
        roundNumber: roundNumber,
        ringNumber: ringNumber,
        rank: _rank,
        competitors: widget.assignment.competitors,
        centerJudge: _judgeForId(_centerJudgeId),
        cornerJudgeOne: _judgeForId(_cornerJudgeOneId),
        cornerJudgeTwo: _judgeForId(_cornerJudgeTwoId),
      ),
    );
  }

  Set<String> _assignedJudgeIdsForRound(int roundNumber) {
    final judgeIds = <String>{};
    for (final assignment in generatedManualAssignmentsSignal.value) {
      if (assignment.roundNumber != roundNumber) {
        continue;
      }

      final centerJudge = assignment.centerJudge;
      if (centerJudge != null) {
        judgeIds.add(centerJudge.id);
      }
      final cornerJudgeOne = assignment.cornerJudgeOne;
      if (cornerJudgeOne != null) {
        judgeIds.add(cornerJudgeOne.id);
      }
      final cornerJudgeTwo = assignment.cornerJudgeTwo;
      if (cornerJudgeTwo != null) {
        judgeIds.add(cornerJudgeTwo.id);
      }
    }

    return judgeIds;
  }
}

class _JudgeDropdown extends StatelessWidget {
  const _JudgeDropdown({
    required this.labelText,
    required this.judgeId,
    required this.judges,
    required this.assignedJudgeIds,
    this.markCenterJudges = false,
    required this.onChanged,
  });

  final String labelText;
  final String judgeId;
  final List<Judge> judges;
  final Set<String> assignedJudgeIds;
  final bool markCenterJudges;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final availableJudgeIds = judges.map((judge) => judge.id).toSet();
    final selectedJudgeId = availableJudgeIds.contains(judgeId) ? judgeId : '';

    return DropdownButtonFormField<String>(
      initialValue: selectedJudgeId,
      decoration: InputDecoration(labelText: labelText),
      items: [
        const DropdownMenuItem(value: '', child: Text('Unassigned')),
        for (final judge in judges)
          DropdownMenuItem(
            value: judge.id,
            child: Text(_judgeDropdownLabel(judge)),
          ),
      ],
      onChanged: (value) {
        if (value == null) {
          return;
        }
        onChanged(value);
      },
    );
  }

  String _judgeDropdownLabel(Judge judge) {
    final statuses = <String>[
      if (markCenterJudges && canCenterJudge(judge)) 'Center',
      assignedJudgeIds.contains(judge.id) ? 'Assigned' : 'Unassigned',
    ];

    return '${judge.name} (${statuses.join(', ')})';
  }
}

Judge? _judgeForId(String judgeId) {
  if (judgeId.isEmpty) {
    return null;
  }

  final judge = judgeById(judgeId);
  if (judge == null || !judge.isAvailable) {
    return null;
  }

  return judge;
}
