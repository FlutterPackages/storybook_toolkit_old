class SecondPage extends StatelessWidget {
    const SecondPage({super.key});
    
    @override
    Widget build(BuildContext context) {
        final title = context.knobs.text(
            label: 'Second page title',
            initial: 'Second page title',
            description: 'The title of the app bar.',
        );
    
        final elevation = context.knobs.nullable.slider(
            label: 'Second page app bar elevation',
            initial: 4,
            min: 0,
            max: 10,
            description: 'Second Elevation of the app bar.',
        );
    
        return Scaffold(
            appBar: AppBar(
                elevation: elevation,
                title: Text(title),
            ),
            body: Center(
                child: ElevatedButton(
                    onPressed: () {
                        context.go(firstRoute);
                        Storybook.storyRouterNotifier.currentStoryRoute = firstRoute;
                    },
                    child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Icon(
                                Icons.access_time,
                                size: 16,
                            ),
                            SizedBox(width: 4),
                            Text('Go to First page'),
                        ],
                    ),
                ),
            ),
        );
    }
}