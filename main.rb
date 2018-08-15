require_relative 'lib/gateway/file'
require_relative 'lib/use_case/count_views'

require_relative 'lib/strategy/standard_count'
require_relative 'lib/strategy/unique_count'
require_relative 'lib/strategy/descending_order'

require_relative 'lib/presenter/printable_list'

file_gateway = Gateway::File.new(path: ARGV[0])

all_descending = UseCase::CountViews.new(
  file_gateway: file_gateway,
  count_strategy: Strategy::StandardCount,
  order_strategy: Strategy::DescendingOrder
)

unique_descending = UseCase::CountViews.new(
  file_gateway: file_gateway,
  count_strategy: Strategy::UniqueCount,
  order_strategy: Strategy::DescendingOrder
)

puts "=" * 20
puts "ALL VISITS"
puts "=" * 20
puts all_descending.execute(
  presenter: Presenter::PrintableList.new(title: 'visits')
)

puts "=" * 20
puts "UNIQUE VIEWS"
puts "=" * 20
puts unique_descending.execute(
  presenter: Presenter::PrintableList.new(title: 'unique views')
)