require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe PaginationScope do
  it 'should grant paginate class method to model' do
    User.should respond_to(:paginate)
  end

  describe ".paginate" do
    it "should accept at most three args" do
      lambda {
        User.paginate
        User.paginate 1
        User.paginate 1, 10, {}
      }.should_not raise_error
    end

    describe "should raise ArgumentError" do
      it "when four args are given"
      it "when 1st arg is not Integer or Hash"
      it "when 2nd arg is not Integer or Hash"
      it "when 3rd arg is not Hash"
    end

    it "should return an ActiveRecord::NamedScope::Scope" do
      User.paginate.class.should == ActiveRecord::NamedScope::Scope
    end

    it "should provide #count" do
      User.paginate.should respond_to(:count)
    end

    describe "#count" do
      it "should be equal to top level count" do
        count = User.count
        User.paginate.count.should == count
      end
    end

    it "provide #num_pages"
    it "provide #page"
    it "provide #pages(window, left, right)"
  end

  it "should provide #proxy_options" do
    User.paginate.class.should == ActiveRecord::NamedScope::Scope
    pending
    User.paginate.should be_respond_to(:proxy_options)
  end

  describe "#proxy_options" do
    it "should return an Hash" do
      User.paginate.proxy_options.class.should == Hash
    end

    describe "should set default value" do
      it "0 to offset"
      it "10 to limit"
    end
  end
end


