require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe PaginationScope do
  before(:all) do
    User.destroy_all
    require 'fastercsv'
    users_csv = FasterCSV.open(
      File.join(File.dirname(__FILE__), %w(../fixtures/users.csv))).to_a
    cols, values = users_csv[0], users_csv[1..-1]
    values.each do |vals|
      hash = Hash[cols.zip(vals)]
      hash.delete("id")
      User.create!(hash.except("id"))
    end
  end

  before(:each) do
    @conds = ["id < 4"]
    @start = 1
    @limit = 2
    @page  = User.paginate(@start, @limit, :conditions=>@conds)
  end

  describe ".paginate" do
    describe "#size" do
      it "should be tested on valid fixtures" do
        User.count.should > 0 
      end

      it "should be equal to per_page" do
        # TODO: ensure count >= limit
        @page.size.should == @limit
      end
    end

    describe "#count" do
      it "should be equal to top level count" do
        count = User.count(:conditions=>@conds)
        @page.count.should == count
      end

      it "should ignore :offset option" do
        count = User.count(:conditions=>@conds)
        @page = User.paginate(2, @limit, :conditions=>@conds) # :offset 2*@limit
        @page.count.should == count
      end

      it "should ignore :limit option" do
        count = User.count(:conditions=>@conds)
        @page = User.paginate(1, 0, :conditions=>@conds) # :limit 0
        @page.count.should == count
      end
    end
  end
end


