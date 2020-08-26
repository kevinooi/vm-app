class GraphQLMutation{
  static const updateOrderStatus = '''
    mutation updateOrderStatus(\$input : updateOrderInput){
  updateOrder(input: \$input){
    order{
      status
    }
    order{
      status
    }
  }
}
  ''';
}

