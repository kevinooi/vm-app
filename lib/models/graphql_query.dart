import 'graphql_fragment.dart';

class GraphQLQuery {
  static String getAllOrders = '''
    query getAllOrders(\$where: JSON, \$start: Int, \$limit: Int, \$sort: String) {
      orders(where: \$where, start: \$start, limit: \$limit, sort: \$sort) {
         ...OrderFragment
      }
     ordersConnection(where: \$where, start: \$start, limit: \$limit, sort: \$sort) {
       aggregate{
         count
       }
       }
    }
    ${GraphQLFragment.orderFragment} 
  ''';

  static String getOrder = '''
    query getOrder(\$id:ID!){
      order(id:\$id){
        id
        order_number
        status
        ordered_by{
          username
        }
        created_at
        order_products{
          id
            product{
          id
          name
          quantity
          price
            }
        }
      }
    }
''';

static const String getMyself = '''
    query getMyself(\$id:ID!) {
      user(id:\$id){
        id
        created_at
        updated_at
        username
        email
        provider
      }
    }
  ''';
}
