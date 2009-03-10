require 'pagination_scope'

ActiveRecord::Base.class_eval do
  include PaginationScope
end
