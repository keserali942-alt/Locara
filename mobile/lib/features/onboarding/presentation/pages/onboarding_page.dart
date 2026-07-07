import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:locora_mobile/features/onboarding/domain/entities/discovery_profile.dart';
import 'package:locora_mobile/features/onboarding/presentation/providers.dart';
import 'package:locora_mobile/features/onboarding/presentation/widgets/question_card.dart';
import 'package:locora_mobile/l10n/app_localizations.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final Set<String> _activities = {};
  String _budgetTier = 'medium';
  final Set<String> _companions = {};
  final Set<String> _priorities = {};
  String _walkingPreference = 'moderate';
  String _tripPace = 'balanced';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controllerState = ref.watch(onboardingControllerProvider);

    ref.listen<AsyncValue<void>>(onboardingControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          context.go('/');
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.onboardingTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            QuestionCard(
              title: l10n.onboardingActivities,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _activityOptions(l10n).map((option) {
                  final selected = _activities.contains(option);
                  return FilterChip(
                    label: Text(option),
                    selected: selected,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _activities.add(option);
                        } else {
                          _activities.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            QuestionCard(
              title: l10n.onboardingBudget,
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'low', label: Text(l10n.budgetLow)),
                  ButtonSegment(value: 'medium', label: Text(l10n.budgetMedium)),
                  ButtonSegment(value: 'high', label: Text(l10n.budgetHigh)),
                ],
                selected: {_budgetTier},
                onSelectionChanged: (value) {
                  setState(() {
                    _budgetTier = value.first;
                  });
                },
              ),
            ),
            QuestionCard(
              title: l10n.onboardingCompanions,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _companionOptions(l10n).map((option) {
                  final selected = _companions.contains(option);
                  return FilterChip(
                    label: Text(option),
                    selected: selected,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _companions.add(option);
                        } else {
                          _companions.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            QuestionCard(
              title: l10n.onboardingPriorities,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _priorityOptions(l10n).map((option) {
                  final selected = _priorities.contains(option);
                  return FilterChip(
                    label: Text(option),
                    selected: selected,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _priorities.add(option);
                        } else {
                          _priorities.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            QuestionCard(
              title: l10n.onboardingWalking,
              child: DropdownButtonFormField<String>(
                initialValue: _walkingPreference,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: [
                  DropdownMenuItem(
                    value: 'short',
                    child: Text(l10n.walkingShort),
                  ),
                  DropdownMenuItem(
                    value: 'moderate',
                    child: Text(l10n.walkingModerate),
                  ),
                  DropdownMenuItem(
                    value: 'long',
                    child: Text(l10n.walkingLong),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _walkingPreference = value;
                  });
                },
              ),
            ),
            QuestionCard(
              title: l10n.onboardingPace,
              child: DropdownButtonFormField<String>(
                initialValue: _tripPace,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: [
                  DropdownMenuItem(value: 'slow', child: Text(l10n.paceSlow)),
                  DropdownMenuItem(
                    value: 'balanced',
                    child: Text(l10n.paceBalanced),
                  ),
                  DropdownMenuItem(value: 'fast', child: Text(l10n.paceFast)),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _tripPace = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: controllerState.isLoading
                  ? null
                  : () async {
                      final profile = DiscoveryProfile(
                        activities: _activities.toList(),
                        budgetTier: _budgetTier,
                        companions: _companions.toList(),
                        priorities: _priorities.toList(),
                        walkingPreference: _walkingPreference,
                        tripPace: _tripPace,
                      );
                      await ref
                          .read(onboardingControllerProvider.notifier)
                          .saveProfile(profile);
                    },
              child: Text(l10n.completeOnboarding),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _activityOptions(AppLocalizations l10n) {
    return [
      l10n.activityFood,
      l10n.activityCulture,
      l10n.activityNature,
      l10n.activityNightlife,
      l10n.activityShopping,
      l10n.activityFamily,
    ];
  }

  List<String> _companionOptions(AppLocalizations l10n) {
    return [
      l10n.companionSolo,
      l10n.companionPartner,
      l10n.companionFriends,
      l10n.companionFamily,
    ];
  }

  List<String> _priorityOptions(AppLocalizations l10n) {
    return [
      l10n.priorityBudget,
      l10n.priorityDistance,
      l10n.priorityPopularity,
      l10n.priorityHiddenGems,
    ];
  }
}
