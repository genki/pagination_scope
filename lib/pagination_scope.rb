require 'activesupport'

module PaginationScope
  VERSION = '0.1.1'

  class << self
    def included(base)
      base.class_eval do
        named_scope :paginate, (proc do |*args|
          options  = args.last.is_a?(Hash) ? args.pop : {}
          page     = [(args.shift || options.delete(:page) || 1).to_i - 1, 0].max
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
    def size
      proxy_found.size
    end

    def count
      @count ||= with_scope :find => proxy_options.except(:offset, :limit) do
        proxy_scope.count(:distinct => true, :select => "#{table_name}.#{primary_key}")
      end
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

  Pagination = Struct.new(:context, :model, :options, :linker)
  class Pagination
    delegate :page, :num_pages, :count, :to=>"model"
    delegate :link_to, :url_for, :content_tag, :to=>"context"

    def current
      page
    end

    def first_item
      offset + 1
    end

    def last_item
      [offset + limit, count].min
    end

    def first
      1
    end

    def last
      num_pages
    end

    def first?
      page == 1
    end

    def last?
      page == num_pages
    end

    def offset
      model.proxy_options[:offset]
    end

    def limit
      model.proxy_options[:limit]
    end

    def window
      options[:window] || 5
    end

    def left
      options[:left] || 2
    end

    def right
      options[:right] || 2
    end

    def prev_label
      options[:prev] || '&laquo; Prev'
    end

    def next_label
      options[:next] || 'Next &raquo;'
    end

    def truncate
      options[:truncate] || '...'
    end

    def pages
      @pages ||= model.pages(window, left, right)
    end

    def span
      proc do |*args|
        content_tag(:span, args[0].to_s, :class => (args[1]||"disabled"))
      end
    end

    def prev_link
      if page > 1
        link_to prev_label, url_for(:page => page - 1), :class => :prev, :rel => "prev"
      else
        span.call(prev_label)
      end
    end

    def next_link
      if page < num_pages
        link_to next_label, url_for(:page => page + 1), :class => :older, :rel => "next"
      else
        span.call(next_label)
      end
    end

    def page_link
      pages.map{|i| page_link_for(i)}
    end

    def link(i, *args)
      if linker
        linker.call(i, *args)
      else
        link_to i, url_for(:page => i)
      end
    end

    def page_link_for(i)
      if i.nil?
        span.call(truncate, options[:style])
      elsif i == page
        span.call(i, "#{options[:style]} current")
      else
        span.call(link(i), options[:style])
      end
    end

    def to_s(*args)
      args = [:prev, :page, :next] if args.blank?
      items = args.map{|i| respond_to?("#{i}_link") ? send("#{i}_link") : []}.flatten
      content_tag(:div, items.join("\n"), :class => "pagination")
    end

    def inspect
      keys = %w( page count offset limit first last first_item last_item )
      "#<Pagination %s>" % keys.map{|key| "#{key}: #{send(key)}"}.join(', ')
    end
  end

  module ::ApplicationHelper
    def paginate(model, options = nil, &block)
      Pagination.new(self, model, options||{}, block)
    end
  end
end
