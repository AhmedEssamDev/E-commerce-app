// sliders_state.dart
import 'package:flutter/material.dart';
import 'package:shop/features/home/data/models/sliders_model.dart';

abstract class SlidersState {}

class SlidersInitial extends SlidersState {}

class SlidersLoading extends SlidersState {}

class SlidersSuccess extends SlidersState {
  final List<SliderModel> sliders;
  SlidersSuccess({required this.sliders});
}

class SlidersError extends SlidersState {
  final String error;
  SlidersError({required this.error});
}