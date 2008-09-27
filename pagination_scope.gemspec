# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pagination_scope}
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Genki Takiuchi"]
  s.date = %q{2008-09-28}
  s.description = %q{}
  s.email = %q{genki@s21g.com}
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["README", "ChangeLog", "Rakefile", "test/pagination_scope_test.rb", "test/test_helper.rb", "lib/pagination_scope.rb", "rails/init.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://pagination_scope.rubyforge.org}
  s.rdoc_options = ["--title", "pagination_scope documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{pagination_scope}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{}
  s.test_files = ["test/pagination_scope_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
