require 'pagination_scope'

ActiveRecord::Base.send :include, PaginationScope
