# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'slyncy'

task :default => 'spec:run'

PROJ.name = 'slyncy'
PROJ.authors = 'Max Aller'
PROJ.email = 'nanodeath@gmail.com'
PROJ.url = 'FIXME (project homepage)'
PROJ.version = Slyncy::VERSION
PROJ.rubyforge.name = 'slyncy'

PROJ.spec.opts << '--color'

# EOF
