import 'dart:async';

import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesTab extends ConsumerStatefulWidget {
  const NotesTab({super.key});

  @override
  ConsumerState<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends ConsumerState<NotesTab> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(sessionControllerProvider).notes,
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(sessionControllerProvider.notifier).setNotes(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionControllerProvider.select((s) => s.notes), (prev, next) {
      if (next != _controller.text) {
        final selection = _controller.selection;
        _controller.value = TextEditingValue(
          text: next,
          selection: selection.baseOffset > next.length
              ? TextSelection.collapsed(offset: next.length)
              : selection,
        );
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          color: AppColors.parchment,
          fontSize: 16,
          height: 1.5,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding: EdgeInsets.zero,
          hintText: 'Anota lo que el investigador descubre…',
          hintStyle: TextStyle(color: AppColors.parchmentDim, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
