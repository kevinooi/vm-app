import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:merchant_app/app_bloc/order_bloc.dart';
import 'package:merchant_app/app_bloc/order_services.dart';
import 'package:merchant_app/models/graphQLConf.dart';
import 'package:provider/provider.dart';


import 'components/body.dart';

class DetailsScreen extends StatefulWidget {

  final GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  OrderServices get service => GetIt.I<OrderServices>();

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Order Details"),
        ),
        body: Body(context.watch<OrderBloc>().id?? null),
    );
  }
}
