require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe PaginationScope::Pagination do
  before(:each) do
    @conds = ["id < 4"]
    @limit = 3

    # static values
    @count = User.count
    @max_pages = (@count.to_f / @limit).ceil
  end

  def page_at(page_no)
    pagenate = User.paginate(page_no, @limit, :conditions=>@conds)
    context  = :dummy_for_view
    PaginationScope::Pagination.new(context, pagenate)
  end

  it "provide #current"
  it "provide #first_item"
  it "provide #last_item"
  it "provide #first"
  it "provide #last"
  it "provide #first?"
  it "provide #last?"
  it "provide #offset"
  it "provide #limit"
  it "provide #window"
  it "provide #left"
  it "provide #right"
  it "provide #prev_label"
  it "provide #next_label"
  it "provide #truncate"
  it "provide #pages"
  it "provide #span"
  it "provide #prev_link"
  it "provide #next_link"
  it "provide #page_link"
  it "provide #link(i, *args)"
  it "provide #page_link_for(i)"
  it "provide #to_s(*args)"
  it "provide #inspect"
  it "provide #paginate(model, options = nil, &block)"
end


