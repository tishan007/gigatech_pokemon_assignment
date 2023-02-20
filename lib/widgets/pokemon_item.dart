import 'package:flutter/material.dart';
import 'package:gigatech_pokemon/model/pokemon.dart';

class PokemonItem extends StatefulWidget {

  Pokemon? item;

  PokemonItem({required this.item});

  @override
  _PokemonItemState createState() => _PokemonItemState();
}

class _PokemonItemState extends State<PokemonItem> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
