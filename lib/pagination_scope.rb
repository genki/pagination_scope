module PaginationScope
  VERSION = '0.0.1'

  class << self
    def included(base)
      base.class_eval do
        named_scope :paginate, (proc do |page, per_page|
          options = {:extend => PaginationScope::Extention}
          page = (page || 1).to_i - 1
          if per_page < 0
            per_page = -per_page
            options[:order] ||= "#{table_name}.id ASC"
            options[:order].gsub!(/\b(DESC|ASC)\b/i){
              case $1.upcase
              when 'DESC'; 'ASC'
              when 'ASC'; 'DESC'
              end
            }
          end
          options.merge :offset => per_page*(page), :limit => per_page
        end)
      end
    end
  end

  module Extention
    def count; proxy_scope.count(:group => "#{table_name}.id").size end
    def num_pages; (count.to_f/proxy_options[:limit]).ceil end
    def page; proxy_options[:offset]/proxy_options[:limit] + 1 end

    def pages(window, left, right)
      return [] if num_pages <= 1
      (1..num_pages).inject([]) do |result, i|
        i <= left || (num_pages - i) < right || (i-page).abs < window ?
        result << i : (result.last.nil? ? result : result << nil)
      end
    end
  end

  module ::ApplicationHelper
    def paginate(model, options = {})
      window = options[:window] || 5
      left = options[:left] || 2
      right = options[:right] || 2
      newer = options[:newer] || '&laquo; Newer'
      older = options[:older] || '&raquo; Older'
      page = model.page
      num_pages = model.num_pages
      pages = model.pages(window, left, right)
      return if pages.empty?

      ([(page > 1 ? link_to(newer, url_for(:page => page - 1)) : newer)] +
      pages.map{|i|
        if i.nil?
          '...'
        elsif i == page
          i
        else
          link_to i, url_for(:page => i)
        end
      } + [
        page < num_pages ? link_to(older, url_for(:page => page + 1)) : older
      ]).join("\n")
    end
  end
end
