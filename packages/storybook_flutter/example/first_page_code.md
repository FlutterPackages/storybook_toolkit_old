class FirstPage extends StatelessWidget {
    const FirstPage({super.key});
    
    @override
    Widget build(BuildContext context) {
        final title = context.knobs.text(
            label: 'First page title',
            initial: 'First page title',
            description: 'The title of the app bar.',
        );

        final elevation = context.knobs.nullable.slider(
            label: 'First page app bar elevation',
            initial: 4,
            min: 0,
            max: 10,
            description: 'Elevation of the app bar.',
        );
    
        return Scaffold(
            appBar: AppBar(
                elevation: elevation,
                title: Text(title),
            ),
            body: Center(
                child: ElevatedButton(
                    onPressed: () {
                        context.go(secondRoute);
                        Storybook.storyRouterNotifier.currentStoryRoute = secondRoute;
                    },
                    child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Icon(
                                Icons.access_time,
                                size: 16,
                            ),
                            SizedBox(width: 4),
                            Text('Go to Second page'),
                        ],
                    ),
                ),
            ),
        );
    }
}