class GraphQLFragment {
  static const String orderFragment = '''
    fragment OrderFragment on Order {
      id
      created_at
      updated_at
      order_number
      total_price
      remarks
      status
      ordered_by{
        id
        created_at
        updated_at
        username
        email
        provider
        confirmed
        blocked
      }
      date_completed
      is_active
      order_products{
        product{
          name
        }
      }
    }
  ''';
}
