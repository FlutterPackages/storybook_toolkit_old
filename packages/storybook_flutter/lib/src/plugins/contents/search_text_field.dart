import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/story.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchController.text = context.read<StoryNotifier>().searchTerm;
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: _searchController,
        builder: (BuildContext context, TextEditingValue value, Widget? _) {
          final ThemeData theme = Theme.of(context);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16.0),
            child: SizedBox(
              height: 40,
              child: TextFormField(
                controller: _searchController,
                style: theme.textTheme.bodyMedium,
                cursorColor: Colors.black87,
                cursorWidth: 1.2,
                cursorHeight: 17,
                cursorRadius: const Radius.circular(32),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hoverColor: Colors.transparent,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 1.25,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onPressed: () {
                            _searchController.clear();
                            context.read<StoryNotifier>().searchTerm = '';
                          },
                          icon: const Icon(Icons.clear, size: 16),
                        )
                      : null,
                ),
                textInputAction: TextInputAction.search,
                onChanged: (String value) {
                  context.read<StoryNotifier>().searchTerm = value;
                },
              ),
            ),
          );
        },
      );
}
