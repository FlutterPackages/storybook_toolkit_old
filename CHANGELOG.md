## 1.0.2
- **FIX**: remove debug label from storybook
- **FIX**: update golden tests in example
 
## 1.0.1
- **FIX**: add loadDuration into Story for fix golden tests
- **FIX**: move tester into separated storybook_toolkit_tester package

## 1.0.0

> Note: This release has breaking changes.

- **FEAT**: add CodeViewPlugin.
- **FEAT**: add DirectionalityPlugin.
- **FEAT**: add TimeDilationPlugin.
- **FEAT**: add LocalizationPlugin.
- **BREAKING** **FEAT**: rewrite golden tests generator.
- **REFACTOR**: move tests functions into storybook_flutter.
- **BREAKING** **FEAT**: update navigation tree.
- **FEAT**: add pages.
- **FEAT**: add branding logo.
- **FIX**: update device frames.

## 0.14.0

> Note: This release has breaking changes.

 - **DOCS**: update README.md (#115).
 - **BREAKING** **FEAT**: add LayoutPlugin (#116).

## 0.13.0

> Note: This release has breaking changes.

 - **FIX**: reset knobs panel on story change.
 - **FIX**: reset focus on tap (#104).
 - **DOCS**: update readme.
 - **BREAKING** **REFACTOR**: migrate to Dart 3 (#111).

## 0.12.0

> Note: This release has breaking changes.

 - **FEAT**: add search field to contents (#101).
 - **FEAT**: close contents panel when story is selected.
 - **BREAKING** **FEAT**: migrate to Flutter 3.7. styles.

## 0.11.4

 - **FEAT**: add initialTheme/onThemeChanged (#99).

## 0.11.3

 - **FEAT**: add Story.wrapperBuilder.
 - **DOCS**: add router aware stories to example.

## 0.11.2+2

 - **REFACTOR**: upgrade to mews_pedantic 0.9.0+2 (#90).
 - **FIX**: wrap plugin panel into PointerInterceptor (#92).

## 0.11.2+1

 - **FIX**: no initial value in slider fallbacks to min (#87).

## 0.11.2

 - **FEAT**: Allow configuration of device info (#84).

## 0.11.1

 - **FEAT**: Add multiple levels of nesting (#80).

## 0.11.0+1

 - **FIX**: Add generated files.

## 0.11.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: Bump freezed dependency (#81).

## 0.10.1

 - **FEAT**: knobs with nullable values (#74).
 - **DOCS**: Update readme.

## 0.10.0+1

 - **FIX**: Select knob dropdown in overlay (#70).
 - **FIX**: Panel dialog layout (#67).

## 0.10.0

> Note: This release has breaking changes.

 - **BREAKING** **FIX**: Hot reload for stories (#66).

## 0.9.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 0.9.0-dev.3

> Note: This release has breaking changes.

 - **REFACTOR**: Extract _sectionSeparator const.
 - **BREAKING** **FEAT**: Move sections into story name.

## 0.9.0-dev.2

> Note: This release has breaking changes.

 - **REFACTOR**: Fix imports.
 - **FIX**: Add repaint boundaries.
 - **FIX**: Fix knobs rendering.
 - **DOCS**: Update example.
 - **BREAKING** **FEAT**: Add story and knob description fields (#61).

## 0.9.0-dev.1

 - **FEAT**: Update plugins.
 - **FEAT**: Update plugins.
 - **DOCS**: Update example.
 - **CHORE**: Update pubignore.

## 0.9.0-dev.0

> Note: This release has breaking changes.

 - **CHORE**: Add .pubignore.
 - **CHORE**: Update .gitignore.
 - **BREAKING** **FEAT**: Reorganize (#59).

## 0.8.0

> Note: This release has breaking changes.

 - **TEST**: Update golden test images.
 - **FIX**: Remove deprecated accentColor.
 - **FEAT**: Add scaffoldMessengerKey to Storybook (#46).
 - **CHORE**: Update license (#49).
 - **BREAKING** **CHORE**: Update dependencies.

## 0.7.0+1

 - **FIX**: Fix list views in macOS.

## 0.7.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: Bump provider to 6.0.0 (#41).

## 0.6.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: Add sliderInt (#40).

## 0.5.1

 - **FEAT**: Expose builder and navigatorObservers.

## 0.5.0+1

 - **REFACTOR**: Remove dfunc dependency.
 - **REFACTOR**: Update dependencies.

## 0.5.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 0.5.0-dev.1

 - **FIX**: Fix responsive layout.
 - **DOCS**: Update docs link.
 - **DOCS**: Update docs.
 - **DOCS**: Update demo.
 - **DOCS**: Add demo page.

## 0.5.0-dev.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: Add plugins.

## 0.4.1+2

 - **FIX**: Fix knobs reload for CustomStorybook.

## 0.4.1+1

 - **STYLE**: Fix formatting.
 - **DOCS**: Update README.md.

## 0.4.1

 - **FEAT**: Add storybook_device_preview.
 - **CHORE**: Update dependencies.
 - **CHORE**: Restructure.

## 0.4.0

 - Bump "storybook_flutter" to `0.4.0`.

## 0.3.0

> Note: This release has breaking changes.

 - **CI**: Add CI job (#20).
 - **BREAKING** **FEAT**: Major theme upgrade.

## 0.2.1

- **FEAT**: Add StoryWrapperBuilder.
- **CI**: Add melos.

## 0.2.0

- :cop: Update dependencies
- :zap: Add full page view
- Migrate to null-safety.

## 0.1.5

- Added a button to the app bar to switch between light and dark mode.
- Removed the default value for the background color of a story.

## 0.1.4

- Added Story::background property
- Added Story::padding property

## 0.1.3

- Added localizationDelegates parameter to Storybook.

## 0.1.2

- Added sections.

## 0.1.1

- Added slider knob.

## 0.1.0

- Fixed routing to support hot reloading for stories.
- Reduced dependencies constraints for recase.
- Added support for theme overriding.

## 0.0.6

- Exported KnobsBuilder, updated documentation.

## 0.0.5

- Added knobs.

## 0.0.4

- Fixed docs.
- Fixed exported components.

## 0.0.3

- Fixed docs.
- Removed stub classes.

## 0.0.2

- Updated README.

## 0.0.1

- First version.
