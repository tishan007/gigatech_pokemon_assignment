import 'package:flutter/material.dart';
import 'package:gigatech_pokemon/model/abilities.dart';
import 'package:gigatech_pokemon/model/pokemon.dart';
import 'package:gigatech_pokemon/utils/api.dart';
import 'package:gigatech_pokemon/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String? email;
  Api api = Api();
  int count = 1;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLoginValue();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHomeBody(),
    );
  }

  _buildHomeBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Align(
                  alignment: Alignment.center,
                  child: Text("Logged as : $email", style: const TextStyle(fontSize: 16, color: Color(0xFF808080), fontFamily: 'Inter'),)
              ),
              const SizedBox(height: 20,),
              const Text("List of Pokemon", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              const SizedBox(height: 20,),
              _listOfPokemon(),
            ],
          ),
        )
      ],
    );
  }

  _getLoginValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email");
    });
  }

  _listOfPokemon() {
    return FutureBuilder<Pokemon>(
      future: api.getListOfPokemon(),
      builder: (context, snapshot) {
        var data = snapshot.data ?? 0;
        switch (snapshot.connectionState) {
          case ConnectionState.active:

          case ConnectionState.waiting:
            return const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  )),
            );

          case ConnectionState.none:
            return const Center(
                child: Text("Unable to connect right now"));

          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: snapshot.data?.results.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: Image.asset('assets/Icon.png', width: 18, height: 17,),
                      title: Text("${snapshot.data?.results[index].name}"),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          Abilities abilitiesResponse = await api.getAbilities(index+1);
                          count = 1;
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Abilities", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                        InkWell(
                                          child: Image.asset('assets/cancel.png'),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    const Divider(color: Colors.grey, height: 1),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: abilitiesResponse.abilities
                                      .map((e) => Row(
                                        children: [
                                          Text("${count++}. ", style: const TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Inter') ),
                                          Text(e.ability.name, style: const TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Inter')),
                                        ],
                                      ) ).toList(),
                                ),
                              ));
                        },
                        child: Text("Abilities", style: TextStyle(color: Colors.blueAccent, fontFamily: 'Inter'),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.blueAccent)
                          ),
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey, height: 1),
                  ],
                );
              },
            );
        }
      },
    );
  }
}
