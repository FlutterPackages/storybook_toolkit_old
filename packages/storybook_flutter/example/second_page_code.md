import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class SecondPage extends StatelessWidget {
	  const SecondPage({super.key});
	  
	  @override
	  Widget build(BuildContext context) {
		    return Scaffold(
		        appBar: AppBar(
		            elevation: 4,
		            title: Text('Second page title'),
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