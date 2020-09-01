import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:merchant_app/models/graphql_mutation.dart';
import 'package:merchant_app/models/graphql_query.dart';
import 'package:merchant_app/models/order.dart';

import '../main.dart';


class OrderServices extends ChangeNotifier {
  Map<String, dynamic> variables;

  Future<Map<int, List<Order>>> getAllOrders({int start: 0}) async {
    try {
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      // final orderlist = await futureOrderList;
      QueryResult result = await client.query(QueryOptions(
        documentNode: gql(GraphQLQuery.getAllOrders),
        variables: {"sort": "created_at:desc", "limit": 6, "start": start},
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        log(
          'getAllOrders',
          name: "OrderServices",
          error: result.exception,
        );
        throw "error";
      }
      final list = result.data["orders"] as List<dynamic>;
      final count =
          result.data["ordersConnection"]['aggregate']['count'] as int;
      final item = {
        count:
            list.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList()
      };
      return item;
    } catch (error) {
      log(
        'getAllOrders',
        name: "OrderServices",
        error: error,
      );
    }
    return null;
  }

  Future<Order> getOrder(String id) async {
    try {
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      QueryResult result = await client.query(QueryOptions(
        documentNode: gql(GraphQLQuery.getOrder),
        variables: {
          "id": id,
        },
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        log(
          'getOrder',
          name: "OrderServices",
          error: result.exception,
        );
        throw "error";
      }

      final jsonorder = result.data["order"] as Map<String, dynamic>;
      return Order.fromJson(jsonorder);
    } catch (error) {
      log(
        'getOrder',
        name: "OrderServices",
        error: error,
      );
    }
    return null;
  }

  Future<Order> updateOrderStatus(String id) async {
    try {
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      QueryResult result = await client.mutate(MutationOptions(
        documentNode: gql(GraphQLMutation.updateOrderStatus),
        variables: {
          "input": {
            "where": {"id": id},
            "data": {"status": "paid"}
          }
        },
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        log(
          'updateOrderStatus',
          name: "OrderServices",
          error: result.exception,
        );
        throw "error";
      }
      
    } catch (error) {
      log(
        'updateOrderStatus',
        name: "OrderServices",
        error: error,
      );
    }
    return null;
  }

  Future<Order> rejectOrder(String id) async {
    try {
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      QueryResult result = await client.mutate(MutationOptions(
        documentNode: gql(GraphQLMutation.updateOrderStatus),
        variables: {
          "input": {
            "where": {"id": id},
            "data": {"status": "rejected"}
          }
        },
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        log(
          'rejectOrder',
          name: "OrderServices",
          error: result.exception,
        );
        throw "error";
      }
      
    } catch (error) {
      log(
        'rejectOrder',
        name: "OrderServices",
        error: error,
      );
    }
    return null;
  }
}
