class Group < ActiveRecord::Base
  has_many :users
  include PaginationScope
end
