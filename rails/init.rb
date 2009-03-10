require 'pagination_scope'

module ActiveRecord
  class Base
    include PaginationScope
  end
end
