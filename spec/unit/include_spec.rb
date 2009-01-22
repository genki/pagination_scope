require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe PaginationScope do
  before(:each) do
    @start = 1
    @limit = 2
    @page1 = Group.paginate(@start, @limit)
    @page2 = Group.paginate(@start, @limit, :include=>:users)
  end

  describe ".paginate(:include)" do
    describe " should be equal to non-included one" do
      it "for #count" do
        @page2.count.should == @page1.count
      end
      it "for #size" do
        @page2.size.should == @page1.size
      end
    end
  end
end


