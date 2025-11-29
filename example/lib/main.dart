import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/counter_bloc.dart';
import 'bloc/counter_event.dart';
import 'bloc/counter_state.dart';
import 'dependencies.dart';

void main() async {
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (_) => ic<CounterBloc>()..add(Count(initialNumber: -1)),
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:'),

                if (state is CounterLoaded)
                  Text(
                    '${state.count}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                else if (state is CounterLoading)
                  CircularProgressIndicator()
                else
                  Container(),
              ],
            ),
          ),
          floatingActionButton: (state is CounterLoaded)
              ? FloatingActionButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(
                      Count(initialNumber: state.count),
                    );
                  },
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}
