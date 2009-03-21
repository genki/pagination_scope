# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pagination_scope}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Genki Takiuchi"]
  s.date = %q{2009-03-21}
  s.description = %q{}
  s.email = %q{genki@s21g.com}
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["README", "ChangeLog", "Rakefile", "spec/fixtures", "spec/fixtures/groups.csv", "spec/fixtures/users.csv", "spec/migrations", "spec/migrations/1_create_users.rb", "spec/migrations/2_create_groups.rb", "spec/models", "spec/models/group.rb", "spec/models/user.rb", "spec/spec_helper.rb", "spec/unit", "spec/unit/conditional_spec.rb", "spec/unit/helper_spec.rb", "spec/unit/include_spec.rb", "spec/unit/paginate_spec.rb", "lib/pagination_scope.rb", "rails/init.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://asakusarb.rubyforge.org}
  s.rdoc_options = ["--title", "pagination_scope documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{asakusarb}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{}
  s.test_files = ["spec/unit/conditional_spec.rb", "spec/unit/helper_spec.rb", "spec/unit/include_spec.rb", "spec/unit/paginate_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 1.3.1"])
    else
      s.add_dependency(%q<activesupport>, [">= 1.3.1"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 1.3.1"])
  end
end
