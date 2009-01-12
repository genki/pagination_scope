require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe PaginationScope do
  before(:each) do
    @conds = ["id < 5"]
    @start = 1
    @limit = 2
    @page  = User.paginate(@start, @limit, :conditions=>@conds)
  end

  describe ".paginate" do
    describe "#count" do
      it "should be equal to top level count" do
        count = User.count(:conditions=>@conds)
        @page.count.should == count
      end
    end

    describe "#size" do
      it "should be equal to per_page" do
        @page.size.should == @limit
      end
    end
  end
end


