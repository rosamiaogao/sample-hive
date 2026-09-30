import 'package:hive_app/person.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'boxes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxPersons = await Hive.openBox<Person>('personBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 31, 57),
      appBar: AppBar(title: const Text('Flutter Hive')),
      body: Column(
        children: [
          const SizedBox(height: 10.0),
          Image.network(
            'https://avatars.githubusercontent.com/u/55202745?s=200&v=4',
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: ageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Age',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          boxPersons.put(
                            'key_${nameController.text}',
                            Person(
                              name: nameController.text,
                              age: int.parse(ageController.text),
                            ),
                          );
                        });
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  // Todo ListView.Builder
                  child: ListView.builder(
                    itemCount: boxPersons.length,
                    itemBuilder: (context, index) {
                      Person person = boxPersons.getAt(index);
                      return ListTile(
                        leading: IconButton(
                          onPressed: () {
                            // Delete person
                            setState(() {
                              boxPersons.deleteAt(index);
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        // Show the details
                        title: Text(person.name),
                        subtitle: const Text('Name'),
                        trailing: Text('age ${person.age.toString()}'),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                boxPersons.clear();
              });
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete All'),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
