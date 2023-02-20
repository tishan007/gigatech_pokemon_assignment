import 'dart:convert';

import 'package:gigatech_pokemon/model/abilities.dart';
import 'package:http/http.dart' as http;
import 'package:gigatech_pokemon/model/pokemon.dart';

class Api {

  String base_url = "https://pokeapi.co/api/v2/pokemon";

  Future<Pokemon> getListOfPokemon() async {

    var response = await http.get(
      Uri.parse(base_url),
    );

    if (response.statusCode == 200) {
      print("=======Pokemon response======= : " + response.body);
      return Pokemon.fromJson(json.decode(response.body));
    } else {
      print("Pokemon error : " + response.body);
      throw Exception('Failed to load top sell courses data');
    }
  }

  Future<Abilities> getAbilities(int id) async {

    var response = await http.get(
      Uri.parse(base_url + "/$id"),
    );

    if (response.statusCode == 200) {
      print("=======Abilities response======= : " + response.body);
      return Abilities.fromJson(json.decode(response.body));
    } else {
      print("Abilities error : " + response.body);
      throw Exception('Failed to load top sell courses data');
    }
  }

}