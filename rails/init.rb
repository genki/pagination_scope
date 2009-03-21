require File.join(File.dirname(__FILE__), %w(.. lib pagination_scope))

ActiveRecord::Base.class_eval do
  include PaginationScope
end
