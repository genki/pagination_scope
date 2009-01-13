class User < ActiveRecord::Base
  include PaginationScope
  belongs_to :group
end
