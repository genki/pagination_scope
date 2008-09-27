module PaginationScope
  VERSION = '0.0.7'

  class << self
    def included(base)
      base.class_eval do
        named_scope :paginate, (proc do |*args|
          options  = args.last.is_a?(Hash) ? args.pop : {}
          page     = (args.shift || options.delete(:page) || 1).to_i - 1
          per_page = args.shift || options.delete(:per_page) || 10
          options[:extend] = PaginationScope::Extention
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
    def count
      @count ||= proxy_scope.count
    end

    def count_ids
      @count ||= proxy_scope.count(
        :group => "#{table_name}.#{primary_key}").size
    end

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
      window     = options[:window] || 5
      left       = options[:left] || 2
      right      = options[:right] || 2
      prev_label = options[:prev] || '&laquo; Prev'
      next_label = options[:next] || 'Next &raquo;'
      truncate   = options[:truncate] || '...'
      page       = model.page
      num_pages  = model.num_pages
      pages      = model.pages(window, left, right)
      return if pages.empty?

      span = proc do |*args|
        content_tag(:span, args[0].to_s, :class => (args[1]||"disabled"))
      end
      items = []
      items << ((page > 1) ? link_to(prev_label,
        url_for(:page => page - 1), :class => :prev, :rel => "prev") :
        span.call(prev_label))
      items += pages.map{|i|
        if i.nil?
          truncate
        elsif i == page
          span.call(i, "current")
        else
          link_to i, url_for(:page => i)
        end
      }
      items << ((page < num_pages) ? link_to(next_label,
        url_for(:page => page + 1), :class => :older, :rel => "next") :
        span.call(next_label))

      content_tag(:div, items.join("\n"), :class => "pagination")
    end
  end
end
