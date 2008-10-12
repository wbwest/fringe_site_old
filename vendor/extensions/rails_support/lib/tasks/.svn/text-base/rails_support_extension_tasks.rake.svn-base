# ---------------------------------------------------------------------------------
# Copyright 2007 Hiram Chirino
# 
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
# ---------------------------------------------------------------------------------
# Author: <a href="http://hiramchirino.com">Hiram Chirino</a>
namespace :radiant do
  namespace :extensions do
    namespace :rails_support do
      
      desc "Runs the migration of the Rails Support extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          RailsSupportExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          RailsSupportExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Rails Support to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[RailsSupportExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(RailsSupportExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
