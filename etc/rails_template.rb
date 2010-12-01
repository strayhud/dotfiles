# SRH - Modified from original version at: http://gist.github.com/75038

# rails application template for generating customized rails apps
#
# == requires ==
#
# * rails 2.3+, rspec, cucumber, culerity (langalex-culerity gem), machinist
#
# == a newly generated app using this template comes with ==
#
# * working user registration/login via authlogic, cucumber features to verify that it works
# * rspec/cucumber/culerity for testing
# * thinking_sphinx configuration
# * german localization
# * capistrano deployment script
# * jquery and blueprint css set up
# * a blueprints.rb for machinist
#
# == how to use ==
#
# * install the required gems (and jruby for culerity)
# * generate a new app: rails my_new_app -m http://gist.github.com/raw/75038/a14ddd8be39b3d7705550b7fbd3a9b39cda63d58/upstream_rails_application_template.rb
# * run the features to verify everything is working: rake features
#
# == TODO ==
# * add forgot password method
# * make registration/login use resource_controller

app_name = `pwd`.split('/').last.strip.capitalize

run "rm README"
run "rm -rf test"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm public/images/rails.png"
#run "rm -f public/javascripts/*"
  
# get jquery and plugins
run "curl -L http://code.jquery.com/jquery-1.4.2.min.js > public/javascripts/jquery.js"
run "curl -L http://github.com/rails/jquery-ujs/raw/master/src/rails.js > public/javascripts/rails.js"
#run "curl -L http://jqueryjs.googlecode.com/svn/trunk/plugins/form/jquery.form.js > public/javascripts/jquery.form.js"
#run "curl -L http://jqueryjs.googlecode.com/svn/trunk/plugins/methods/date.js > public/javascripts/date.js"
#run "curl -L http://www.kelvinluck.com/assets/jquery/datePicker/v2/demo/scripts/jquery.datePicker.js > public/javascripts/jquery.datePicker.js"
#run "curl -L http://www.kelvinluck.com/assets/jquery/datePicker/v2/demo/styles/datePicker.css > public/stylesheets/datePicker.css"

# blueprint/css
#run "curl -L http://github.com/joshuaclayton/blueprint-css/tarball/master > public/stylesheets/blueprint.tar && tar xf public/stylesheets/blueprint.tar"
#run 'rm public/stylesheets/blueprint.tar'
#blueprint_dir = Dir.entries('.').grep(/blueprint/).first
#run "mv #{blueprint_dir}/blueprint public/stylesheets"
#run "rm -rf #{blueprint_dir}"


# Gemfile
run "rm Gemfile"
file 'Gemfile', <<-FILE
source 'http://rubygems.org'

gem 'rails'
gem 'mysql'

group :development do
  gem 'rspec-rails'
end

group :test do
  gem 'rspec'
  gem 'webrat'
end

group :cucumber do
  gem 'cucumber-rails'
  gem 'capybara'
end

FILE
run "bundle install"
run "rails generate cucumber:install"
run "rails generate rspec:install"

# Copy database.yml for distribution use
run "rm config/database.yml"
file "config/database.yml", <<-FILE
development:
  adapter: mysql
  database: #{app_name}_development
  encoding: utf8
  username: root
  password:
  pool: 5
  socket: /tmp/mysql.sock

test:
  adapter: mysql
  database: #{app_name}_test
  encoding: utf8
  username: root
  password:
  pool: 5
  socket: /tmp/mysql.sock

production:
  adapter: mysql
  database: #{app_name}_production
  encoding: utf8
  username: root
  password:
  pool: 5
  socket: /tmp/mysql.sock


FILE
run "cp config/database.yml config/database.yml.example"
rake 'db:create'


# routes
run "rm config/routes.rb"
file 'config/routes.rb', <<-FILE
#{app_name}::Application.routes.draw do

end
FILE

# jquery_setup.rb
file 'config/initializers/jquery_setup.rb', <<-FILE
#{app_name}::Application.config.action_view.javascript_expansions[:defaults] = ['jquery', 'rails']
FILE


# Set up .gitignore files
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
run "rm .gitignore"
file '.gitignore', <<-END
.bundle
db/*.sqlite3*
log/*.log
log/*.pid
*.pid
*.log
*.out
*.lock
tmp/**/*
tmp/*
doc/**/*
doc/*
.gitignore
.DS_Store
db/schema.rb
config/*sphinx.conf
db/sphinx
END

## gems
#gem 'mislav-will_paginate', :version => '~> 2.2.3', :lib => 'will_paginate', :source #=> 'http://gems.github.com'
#gem 'authlogic'
#gem 'giraffesoft-resource_controller', :lib => 'resource_controller', :source => #'http://gems.github.com'
#
#rake 'gems:install', :sudo => true

## plugins
## plugin 'jrails', :git => 'git://github.com/aaronchi/jrails.git'
## plugin 'exceptional', :git => 'git://github.com/contrast/exceptional.git'
## run 'cp vendor/plugins/exceptional/exceptional.yml config/exceptional.yml'
## plugin 'thinking-sphinx', :git => #'git://github.com/freelancing-god/thinking-sphinx.git'
#
## generators
#generate("rspec")
#generate("rspec-rails")
#run "rm -rf stories"
#generate("cucumber")
#run "rm features/step_definitions/webrat_steps.rb"
#generate("culerity")
#
## enable culerity, disable webrat
#
#file 'features/support/env.rb', <<-FILE
#ENV["RAILS_ENV"] = "test"
#require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
#require 'cucumber/rails/world'
#require 'cucumber/formatters/unicode'
#require 'cucumber/rails/rspec'
#
#require 'culerity'
#
#require 'machinist'
#require RAILS_ROOT + '/spec/blueprints'
#
#FILE
#
## machinist
#
#file 'spec/blueprints.rb', <<-FILE
#User.blueprint do
#login "joe"
#password "testtest"
#password_confirmation "testtest"
#end
#FILE
#
## skip cucumber/rspec load errors on production server
#
#[:cucumber, :rspec].each do |service|
#  file "lib/tasks/#{service}.rake", <<-FILE
#begin
##{File.read("lib/tasks/#{service}.rake")}
#rescue LoadError => e
#STDERR.puts "could not load #{service}."
#end
#FILE
#end
#

## application layout
#
#file 'app/views/layouts/application.html.erb', <<-FILE
#<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
#"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
#<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
#<head>
#<meta http-equiv="Content-type" content="text/html; charset=utf-8" />
#<title>#{app_name}</title>
#<%= stylesheet_link_tag 'screen', 'datePicker', :media => 'screen, projection' %>
#<%= stylesheet_link_tag 'print', :media => 'print' %>
#<!--[if IE]>
#<%= stylesheet_link_tag 'ie', :media => 'all' %>
#<![endif]-->
#<%= javascript_include_tag 'jquery', 'jquery.form.js', 'date', 'jquery.datePicker.js', #:cache => true %>
#<%= yield(:head) %>
#<script type="text/javascript">
#$(function() {
#<%= yield(:jquery) %>
#});
#</script>
#</head>
#<body>
#<div id="navigation">
#<ul>
#<%- if current_user -%>
#<li><%= link_to 'Home', account_path %></li>
#<li><%= link_to 'Log out', user_session_path, :method => :delete %></li>
#<%- else -%>
#<li><%= link_to 'Home', root_path %></li>
#<li><%= link_to 'Sign up', new_user_path %></li>
#<li><%= link_to 'Log in', new_user_session_path %></li>
#<%- end -%>
#</ul>
#</div>
#<div id="content">
#<%- if flash[:notice] -%>
#<div id="flash"><%= flash[:notice] %></div>
#<%- end -%>
#<%= yield %>
#</div>
#</body>
#</html>
#FILE

#
## authlogic login/signup
#
#generate("session user_session")
#generate 'rspec_model user login:string crypted_password:string password_salt:string #persistence_token:string login_count:integer last_request_at:datetime #last_login_at:datetime current_login_at:datetime last_login_ip:string #current_login_ip:string'
#
#
#route "map.root :controller => 'users', :action => 'new'"
#route 'map.resource :user_session'
#route "map.resource :account, :controller => 'users'"
#route 'map.resources :users'
#
#
#file "app/controllers/user_sessions_controller.rb", <<-FILE
#class UserSessionsController < ApplicationController
#require_user :only => :destroy
#resource_controller
#actions :new, :create
#create do
#flash "Login successful!"
#success.wants.html do
#redirect_back_or_default account_url
#end
#end
#def destroy
#current_user_session.destroy
#flash[:notice] = "Logout successful!"
#redirect_back_or_default new_user_session_url
#end
#end
#FILE
#
#file 'app/controllers/users_controller.rb', <<-FILE
#class UsersController < ApplicationController
#require_user :only => [:show, :edit, :update]
#resource_controller
#actions :new, :create, :show, :edit, :update
#create do
#flash "Account registered!"
#success.wants.html do
#redirect_back_or_default account_url
#end
#end
#update.flash "Account updated!"
#def object
#@object ||= current_user
#end
#end
#FILE
#
#file 'app/models/user.rb', <<-FILE
#class User < ActiveRecord::Base
#acts_as_authentic
#end
#FILE
#
#file 'app/controllers/application_controller.rb', <<-FILE
#class ApplicationController < ActionController::Base
#helper :all
#protect_from_forgery
#prepend_before_filter :activate_authlogic
#filter_parameter_logging :password, :password_confirmation
#helper_method :current_user_session, :current_user
#
#private
#def current_user_session
#return @current_user_session if defined?(@current_user_session)
#@current_user_session = UserSession.find
#end
#def current_user
#return @current_user if defined?(@current_user)
#@current_user = current_user_session && current_user_session.user
#end
#def require_user
#unless current_user
#store_location
#flash[:notice] = "You must be logged in to access this page"
#redirect_to new_user_session_url
#return false
#end
#end
#def self.require_user(options = {})
#before_filter :require_user, options
#end
#def store_location
#session[:return_to] = request.request_uri
#end
#def redirect_back_or_default(default)
#redirect_to(session[:return_to] || default)
#session[:return_to] = nil
#end
#end
#FILE
#
#file 'app/views/users/new.html.erb', <<-FILE
#<h1>Register</h1>
#<% form_for @user, :url => account_path do |f| %>
#<%= f.error_messages %>
#<%= render :partial => "form", :object => f %>
#<%= f.submit "Register" %>
#<% end %>
#FILE
#
#file 'app/views/users/_form.html.erb', <<-FILE
#<%= form.label :login %><br />
#<%= form.text_field :login %><br />
#<br />
#<%= form.label :password, form.object.new_record? ? nil : "Change password" %><br />
#<%= form.password_field :password %><br />
#<br />
#<%= form.label :password_confirmation %><br />
#<%= form.password_field :password_confirmation %><br />
#<br />
#FILE
#
#file 'app/views/users/edit.html.erb', <<-FILE
#<h1>Edit My Account</h1>
#<% form_for @user, :url => account_path do |f| %>
#<%= f.error_messages %>
#<%= render :partial => "form", :object => f %>
#<%= f.submit "Update" %>
#<% end %>
#<br /><%= link_to "My Profile", account_path %>
#FILE
#
#file 'app/views/users/show.html.erb', <<-FILE
#<p>Welcome <%=h @user.login %></p>
#<%= link_to 'Edit Account', edit_account_path %>
#FILE
#
#file 'app/views/user_sessions/new.html.erb', <<-FILE
#<h1>Login</h1>
#<% form_for @user_session, :url => user_session_path do |f| %>
#<%= f.error_messages %>
#<%= f.label :login %><br />
#<%= f.text_field :login %><br />
#<br />
#<%= f.label :password %><br />
#<%= f.password_field :password %><br />
#<br />
#<%= f.check_box :remember_me %><%= f.label :remember_me %><br />
#<br />
#<%= f.submit "Login" %>
#<% end %>
#FILE
#
#
## login/signup features
#
#file 'features/log_in.feature', <<-FILE
#Feature: log in
#In order to use the system
#As a user
#I want to log in
#Scenario: log in
#Given a user "alex" with the password "testtest"
#When I go to the start page
#And I follow "Log in"
#And I fill in "alex" for "Login"
#And I fill in "testtest" for "Password"
#And I press "Login"
#Then I should see "Welcome alex"
#And I should see "Login successful!"
#
#Scenario: log out
#Given a user "alex" with the password "testtest"
#And "alex" is logged in
#When I go to the account page
#And I follow "Log out"
#Then I should see "Log in"
#And I should see "Logout successful!"
#Scenario: edit account
#Given a user "alex" with the password "testtest"
#And "alex" is logged in
#When I go to the account page
#And I follow "Edit Account"
#And I fill in "joe" for "Login"
#And I press "Update"
#Then I should see "Account updated!"
#FILE
#
#file 'features/sign_up.feature', <<-FILE
#Feature: sign up
#In order to use all the platform's features
#As a user
#I want to sign up
#Scenario: sign up successfully
#When I go to the start page
#And I follow "Sign up"
#And I fill in "alex" for "Login"
#And I fill in "testtest" for "Password"
#And I fill in "testtest" for "Password confirmation"
#And I press "Register"
#Then I should see "Welcome alex"
#
#Scenario: signing up fails because login is taken
#Given a user "alex"
#When I go to the start page
#And I follow "Sign up"
#And I fill in "alex" for "Login"
#And I fill in "testtest" for "Password"
#And I fill in "testtest" for "Password confirmation"
#And I press "Register"
#Then I should not see "Welcome alex"
#And I should see "Login ist bereits vergeben"
#FILE
#
#file 'features/step_definitions/user_steps.rb', <<-FILE
#Before do
#User.delete_all
#end
#
#Given /^a user "(.+)" with the password "(.+)"$/ do |login, password|
#User.make :login => login, :password => password, :password_confirmation => password
#end
#
#Given /a user "([^"]+)"$/ do |login|
#User.make :login => login
#end
#
#Given /^"([^"]+)" is logged in$/ do |login|
#When 'I go to the start page'
#When 'I follow "Log in"'
#When "I fill in \\\"\#{login}\\\" for \\\"Login\\\""
#When 'I fill in "testtest" for "Password"'
#When 'I press "Login"'
#end
#FILE
#
#file 'features/support/paths.rb', <<-FILE
#def path_to(page_name)
#case page_name
#when /the start page/i
#root_path
#when /the account page/i
#account_path
#else
#raise "Can't find mapping from \"\#{page_name}\" to a path."
#end
#end
#FILE
#
## migrations
#rake "db:migrate"
#
#

#
## thinking sphinx
#
#file 'config/sphinx.yml', <<-FILE
#development:
#enable_star: true
#charset_table: "0..9, a..z, _, A..Z->a..z, U+00C0->a, U+00C1->a, U+00C2->a, U+00C3->a, #U+00C4->a, U+00C5->a, U+00C7->c, U+00C8->e, U+00C9->e, U+00CA->e, U+00CB->e, #U+00CC->i, U+00CD->i, U+00CE->i, U+00CF->i, U+00D1->n, U+00D2->o, U+00D3->o, #U+00D4->o, U+00D5->o, U+00D6->o, U+00D9->u, U+00DA->u, U+00DB->u, U+00DC->u, #U+00DD->y, U+00E0->a, U+00E1->a, U+00E2->a, U+00E3->a, U+00E4->a, U+00E5->a, #U+00E7->c, U+00E8->e, U+00E9->e, U+00EA->e, U+00EB->e, U+00EC->i, U+00ED->i, #U+00EE->i, U+00EF->i, U+00F1->n, U+00F2->o, U+00F3->o, U+00F4->o, U+00F5->o, #U+00F6->o, U+00F9->u, U+00FA->u, U+00FB->u, U+00FC->u, U+00FD->y, U+00FF->y, #U+0100->a, U+0101->a, U+0102->a, U+0103->a, U+0104->a, U+0105->a, U+0106->c, #U+0107->c, U+0108->c, U+0109->c, U+010A->c, U+010B->c, U+010C->c, U+010D->c, #U+010E->d, U+010F->d, U+0112->e, U+0113->e, U+0114->e, U+0115->e, U+0116->e, #U+0117->e, U+0118->e, U+0119->e, U+011A->e, U+011B->e, U+011C->g, U+011D->g, #U+011E->g, U+011F->g, U+0120->g, U+0121->g, U+0122->g, U+0123->g, U+0124->h, #U+0125->h, U+0128->i, U+0129->i, U+012A->i, U+012B->i, U+012C->i, U+012D->i, #U+012E->i, U+012F->i, U+0130->i, U+0134->j, U+0135->j, U+0136->k, U+0137->k, #U+0139->l, U+013A->l, U+013B->l, U+013C->l, U+013D->l, U+013E->l, U+0143->n, #U+0144->n, U+0145->n, U+0146->n, U+0147->n, U+0148->n, U+014C->o, U+014D->o, #U+014E->o, U+014F->o, U+0150->o, U+0151->o, U+0154->r, U+0155->r, U+0156->r, #U+0157->r, U+0158->r, U+0159->r, U+015A->s, U+015B->s, U+015C->s, U+015D->s, #U+015E->s, U+015F->s, U+0160->s, U+0161->s, U+0162->t, U+0163->t, U+0164->t, #U+0165->t, U+0168->u, U+0169->u, U+016A->u, U+016B->u, U+016C->u, U+016D->u, #U+016E->u, U+016F->u, U+0170->u, U+0171->u, U+0172->u, U+0173->u, U+0174->w, #U+0175->w, U+0176->y, U+0177->y, U+0178->y, U+0179->z, U+017A->z, U+017B->z, #U+017C->z, U+017D->z, U+017E->z, U+01A0->o, U+01A1->o, U+01AF->u, U+01B0->u, #U+01CD->a, U+01CE->a, U+01CF->i, U+01D0->i, U+01D1->o, U+01D2->o, U+01D3->u, #U+01D4->u, U+01D5->u, U+01D6->u, U+01D7->u, U+01D8->u, U+01D9->u, U+01DA->u, #U+01DB->u, U+01DC->u, U+01DE->a, U+01DF->a, U+01E0->a, U+01E1->a, U+01E6->g, #U+01E7->g, U+01E8->k, U+01E9->k, U+01EA->o, U+01EB->o, U+01EC->o, U+01ED->o, #U+01F0->j, U+01F4->g, U+01F5->g, U+01F8->n, U+01F9->n, U+01FA->a, U+01FB->a, #U+0200->a, U+0201->a, U+0202->a, U+0203->a, U+0204->e, U+0205->e, U+0206->e, #U+0207->e, U+0208->i, U+0209->i, U+020A->i, U+020B->i, U+020C->o, U+020D->o, #U+020E->o, U+020F->o, U+0210->r, U+0211->r, U+0212->r, U+0213->r, U+0214->u, #U+0215->u, U+0216->u, U+0217->u, U+0218->s, U+0219->s, U+021A->t, U+021B->t, #U+021E->h, U+021F->h, U+0226->a, U+0227->a, U+0228->e, U+0229->e, U+022A->o, #U+022B->o, U+022C->o, U+022D->o, U+022E->o, U+022F->o, U+0230->o, U+0231->o, #U+0232->y, U+0233->y, U+1E00->a, U+1E01->a, U+1E02->b, U+1E03->b, U+1E04->b, #U+1E05->b, U+1E06->b, U+1E07->b, U+1E08->c, U+1E09->c, U+1E0A->d, U+1E0B->d, #U+1E0C->d, U+1E0D->d, U+1E0E->d, U+1E0F->d, U+1E10->d, U+1E11->d, U+1E12->d, #U+1E13->d, U+1E14->e, U+1E15->e, U+1E16->e, U+1E17->e, U+1E18->e, U+1E19->e, #U+1E1A->e, U+1E1B->e, U+1E1C->e, U+1E1D->e, U+1E1E->f, U+1E1F->f, U+1E20->g, #U+1E21->g, U+1E22->h, U+1E23->h, U+1E24->h, U+1E25->h, U+1E26->h, U+1E27->h, #U+1E28->h, U+1E29->h, U+1E2A->h, U+1E2B->h, U+1E2C->i, U+1E2D->i, U+1E2E->i, #U+1E2F->i, U+1E30->k, U+1E31->k, U+1E32->k, U+1E33->k, U+1E34->k, U+1E35->k, #U+1E36->l, U+1E37->l, U+1E38->l, U+1E39->l, U+1E3A->l, U+1E3B->l, U+1E3C->l, #U+1E3D->l, U+1E3E->m, U+1E3F->m, U+1E40->m, U+1E41->m, U+1E42->m, U+1E43->m, #U+1E44->n, U+1E45->n, U+1E46->n, U+1E47->n, U+1E48->n, U+1E49->n, U+1E4A->n, #U+1E4B->n, U+1E4C->o, U+1E4D->o, U+1E4E->o, U+1E4F->o, U+1E50->o, U+1E51->o, #U+1E52->o, U+1E53->o, U+1E54->p, U+1E55->p, U+1E56->p, U+1E57->p, U+1E58->r, #U+1E59->r, U+1E5A->r, U+1E5B->r, U+1E5C->r, U+1E5D->r, U+1E5E->r, U+1E5F->r, #U+1E60->s, U+1E61->s, U+1E62->s, U+1E63->s, U+1E64->s, U+1E65->s, U+1E66->s, #U+1E67->s, U+1E68->s, U+1E69->s, U+1E6A->t, U+1E6B->t, U+1E6C->t, U+1E6D->t, #U+1E6E->t, U+1E6F->t, U+1E70->t, U+1E71->t, U+1E72->u, U+1E73->u, U+1E74->u, #U+1E75->u, U+1E76->u, U+1E77->u, U+1E78->u, U+1E79->u, U+1E7A->u, U+1E7B->u, #U+1E7C->v, U+1E7D->v, U+1E7E->v, U+1E7F->v, U+1E80->w, U+1E81->w, U+1E82->w, #U+1E83->w, U+1E84->w, U+1E85->w, U+1E86->w, U+1E87->w, U+1E88->w, U+1E89->w, #U+1E8A->x, U+1E8B->x, U+1E8C->x, U+1E8D->x, U+1E8E->y, U+1E8F->y, U+1E96->h, #U+1E97->t, U+1E98->w, U+1E99->y, U+1EA0->a, U+1EA1->a, U+1EA2->a, U+1EA3->a, #U+1EA4->a, U+1EA5->a, U+1EA6->a, U+1EA7->a, U+1EA8->a, U+1EA9->a, U+1EAA->a, #U+1EAB->a, U+1EAC->a, U+1EAD->a, U+1EAE->a, U+1EAF->a, U+1EB0->a, U+1EB1->a, #U+1EB2->a, U+1EB3->a, U+1EB4->a, U+1EB5->a, U+1EB6->a, U+1EB7->a, U+1EB8->e, #U+1EB9->e, U+1EBA->e, U+1EBB->e, U+1EBC->e, U+1EBD->e, U+1EBE->e, U+1EBF->e, #U+1EC0->e, U+1EC1->e, U+1EC2->e, U+1EC3->e, U+1EC4->e, U+1EC5->e, U+1EC6->e, #U+1EC7->e, U+1EC8->i, U+1EC9->i, U+1ECA->i, U+1ECB->i, U+1ECC->o, U+1ECD->o, #U+1ECE->o, U+1ECF->o, U+1ED0->o, U+1ED1->o, U+1ED2->o, U+1ED3->o, U+1ED4->o, #U+1ED5->o, U+1ED6->o, U+1ED7->o, U+1ED8->o, U+1ED9->o, U+1EDA->o, U+1EDB->o, #U+1EDC->o, U+1EDD->o, U+1EDE->o, U+1EDF->o, U+1EE0->o, U+1EE1->o, U+1EE2->o, #U+1EE3->o, U+1EE4->u, U+1EE5->u, U+1EE6->u, U+1EE7->u, U+1EE8->u, U+1EE9->u, #U+1EEA->u, U+1EEB->u, U+1EEC->u, U+1EED->u, U+1EEE->u, U+1EEF->u, U+1EF0->u, #U+1EF1->u, U+1EF2->y, U+1EF3->y, U+1EF4->y, U+1EF5->y, U+1EF6->y, U+1EF7->y, #U+1EF8->y, U+1EF9->y"
#
#test:
#enable_star: true
#charset_table: "0..9, a..z, _, A..Z->a..z, U+00C0->a, U+00C1->a, U+00C2->a, U+00C3->a, #U+00C4->a, U+00C5->a, U+00C7->c, U+00C8->e, U+00C9->e, U+00CA->e, U+00CB->e, #U+00CC->i, U+00CD->i, U+00CE->i, U+00CF->i, U+00D1->n, U+00D2->o, U+00D3->o, #U+00D4->o, U+00D5->o, U+00D6->o, U+00D9->u, U+00DA->u, U+00DB->u, U+00DC->u, #U+00DD->y, U+00E0->a, U+00E1->a, U+00E2->a, U+00E3->a, U+00E4->a, U+00E5->a, #U+00E7->c, U+00E8->e, U+00E9->e, U+00EA->e, U+00EB->e, U+00EC->i, U+00ED->i, #U+00EE->i, U+00EF->i, U+00F1->n, U+00F2->o, U+00F3->o, U+00F4->o, U+00F5->o, #U+00F6->o, U+00F9->u, U+00FA->u, U+00FB->u, U+00FC->u, U+00FD->y, U+00FF->y, #U+0100->a, U+0101->a, U+0102->a, U+0103->a, U+0104->a, U+0105->a, U+0106->c, #U+0107->c, U+0108->c, U+0109->c, U+010A->c, U+010B->c, U+010C->c, U+010D->c, #U+010E->d, U+010F->d, U+0112->e, U+0113->e, U+0114->e, U+0115->e, U+0116->e, #U+0117->e, U+0118->e, U+0119->e, U+011A->e, U+011B->e, U+011C->g, U+011D->g, #U+011E->g, U+011F->g, U+0120->g, U+0121->g, U+0122->g, U+0123->g, U+0124->h, #U+0125->h, U+0128->i, U+0129->i, U+012A->i, U+012B->i, U+012C->i, U+012D->i, #U+012E->i, U+012F->i, U+0130->i, U+0134->j, U+0135->j, U+0136->k, U+0137->k, #U+0139->l, U+013A->l, U+013B->l, U+013C->l, U+013D->l, U+013E->l, U+0143->n, #U+0144->n, U+0145->n, U+0146->n, U+0147->n, U+0148->n, U+014C->o, U+014D->o, #U+014E->o, U+014F->o, U+0150->o, U+0151->o, U+0154->r, U+0155->r, U+0156->r, #U+0157->r, U+0158->r, U+0159->r, U+015A->s, U+015B->s, U+015C->s, U+015D->s, #U+015E->s, U+015F->s, U+0160->s, U+0161->s, U+0162->t, U+0163->t, U+0164->t, #U+0165->t, U+0168->u, U+0169->u, U+016A->u, U+016B->u, U+016C->u, U+016D->u, #U+016E->u, U+016F->u, U+0170->u, U+0171->u, U+0172->u, U+0173->u, U+0174->w, #U+0175->w, U+0176->y, U+0177->y, U+0178->y, U+0179->z, U+017A->z, U+017B->z, #U+017C->z, U+017D->z, U+017E->z, U+01A0->o, U+01A1->o, U+01AF->u, U+01B0->u, #U+01CD->a, U+01CE->a, U+01CF->i, U+01D0->i, U+01D1->o, U+01D2->o, U+01D3->u, #U+01D4->u, U+01D5->u, U+01D6->u, U+01D7->u, U+01D8->u, U+01D9->u, U+01DA->u, #U+01DB->u, U+01DC->u, U+01DE->a, U+01DF->a, U+01E0->a, U+01E1->a, U+01E6->g, #U+01E7->g, U+01E8->k, U+01E9->k, U+01EA->o, U+01EB->o, U+01EC->o, U+01ED->o, #U+01F0->j, U+01F4->g, U+01F5->g, U+01F8->n, U+01F9->n, U+01FA->a, U+01FB->a, #U+0200->a, U+0201->a, U+0202->a, U+0203->a, U+0204->e, U+0205->e, U+0206->e, #U+0207->e, U+0208->i, U+0209->i, U+020A->i, U+020B->i, U+020C->o, U+020D->o, #U+020E->o, U+020F->o, U+0210->r, U+0211->r, U+0212->r, U+0213->r, U+0214->u, #U+0215->u, U+0216->u, U+0217->u, U+0218->s, U+0219->s, U+021A->t, U+021B->t, #U+021E->h, U+021F->h, U+0226->a, U+0227->a, U+0228->e, U+0229->e, U+022A->o, #U+022B->o, U+022C->o, U+022D->o, U+022E->o, U+022F->o, U+0230->o, U+0231->o, #U+0232->y, U+0233->y, U+1E00->a, U+1E01->a, U+1E02->b, U+1E03->b, U+1E04->b, #U+1E05->b, U+1E06->b, U+1E07->b, U+1E08->c, U+1E09->c, U+1E0A->d, U+1E0B->d, #U+1E0C->d, U+1E0D->d, U+1E0E->d, U+1E0F->d, U+1E10->d, U+1E11->d, U+1E12->d, #U+1E13->d, U+1E14->e, U+1E15->e, U+1E16->e, U+1E17->e, U+1E18->e, U+1E19->e, #U+1E1A->e, U+1E1B->e, U+1E1C->e, U+1E1D->e, U+1E1E->f, U+1E1F->f, U+1E20->g, #U+1E21->g, U+1E22->h, U+1E23->h, U+1E24->h, U+1E25->h, U+1E26->h, U+1E27->h, #U+1E28->h, U+1E29->h, U+1E2A->h, U+1E2B->h, U+1E2C->i, U+1E2D->i, U+1E2E->i, #U+1E2F->i, U+1E30->k, U+1E31->k, U+1E32->k, U+1E33->k, U+1E34->k, U+1E35->k, #U+1E36->l, U+1E37->l, U+1E38->l, U+1E39->l, U+1E3A->l, U+1E3B->l, U+1E3C->l, #U+1E3D->l, U+1E3E->m, U+1E3F->m, U+1E40->m, U+1E41->m, U+1E42->m, U+1E43->m, #U+1E44->n, U+1E45->n, U+1E46->n, U+1E47->n, U+1E48->n, U+1E49->n, U+1E4A->n, #U+1E4B->n, U+1E4C->o, U+1E4D->o, U+1E4E->o, U+1E4F->o, U+1E50->o, U+1E51->o, #U+1E52->o, U+1E53->o, U+1E54->p, U+1E55->p, U+1E56->p, U+1E57->p, U+1E58->r, #U+1E59->r, U+1E5A->r, U+1E5B->r, U+1E5C->r, U+1E5D->r, U+1E5E->r, U+1E5F->r, #U+1E60->s, U+1E61->s, U+1E62->s, U+1E63->s, U+1E64->s, U+1E65->s, U+1E66->s, #U+1E67->s, U+1E68->s, U+1E69->s, U+1E6A->t, U+1E6B->t, U+1E6C->t, U+1E6D->t, #U+1E6E->t, U+1E6F->t, U+1E70->t, U+1E71->t, U+1E72->u, U+1E73->u, U+1E74->u, #U+1E75->u, U+1E76->u, U+1E77->u, U+1E78->u, U+1E79->u, U+1E7A->u, U+1E7B->u, #U+1E7C->v, U+1E7D->v, U+1E7E->v, U+1E7F->v, U+1E80->w, U+1E81->w, U+1E82->w, #U+1E83->w, U+1E84->w, U+1E85->w, U+1E86->w, U+1E87->w, U+1E88->w, U+1E89->w, #U+1E8A->x, U+1E8B->x, U+1E8C->x, U+1E8D->x, U+1E8E->y, U+1E8F->y, U+1E96->h, #U+1E97->t, U+1E98->w, U+1E99->y, U+1EA0->a, U+1EA1->a, U+1EA2->a, U+1EA3->a, #U+1EA4->a, U+1EA5->a, U+1EA6->a, U+1EA7->a, U+1EA8->a, U+1EA9->a, U+1EAA->a, #U+1EAB->a, U+1EAC->a, U+1EAD->a, U+1EAE->a, U+1EAF->a, U+1EB0->a, U+1EB1->a, #U+1EB2->a, U+1EB3->a, U+1EB4->a, U+1EB5->a, U+1EB6->a, U+1EB7->a, U+1EB8->e, #U+1EB9->e, U+1EBA->e, U+1EBB->e, U+1EBC->e, U+1EBD->e, U+1EBE->e, U+1EBF->e, #U+1EC0->e, U+1EC1->e, U+1EC2->e, U+1EC3->e, U+1EC4->e, U+1EC5->e, U+1EC6->e, #U+1EC7->e, U+1EC8->i, U+1EC9->i, U+1ECA->i, U+1ECB->i, U+1ECC->o, U+1ECD->o, #U+1ECE->o, U+1ECF->o, U+1ED0->o, U+1ED1->o, U+1ED2->o, U+1ED3->o, U+1ED4->o, #U+1ED5->o, U+1ED6->o, U+1ED7->o, U+1ED8->o, U+1ED9->o, U+1EDA->o, U+1EDB->o, #U+1EDC->o, U+1EDD->o, U+1EDE->o, U+1EDF->o, U+1EE0->o, U+1EE1->o, U+1EE2->o, #U+1EE3->o, U+1EE4->u, U+1EE5->u, U+1EE6->u, U+1EE7->u, U+1EE8->u, U+1EE9->u, #U+1EEA->u, U+1EEB->u, U+1EEC->u, U+1EED->u, U+1EEE->u, U+1EEF->u, U+1EF0->u, #U+1EF1->u, U+1EF2->y, U+1EF3->y, U+1EF4->y, U+1EF5->y, U+1EF6->y, U+1EF7->y, #U+1EF8->y, U+1EF9->y"
#production:
#enable_star: true
#charset_table: "0..9, a..z, _, A..Z->a..z, U+00C0->a, U+00C1->a, U+00C2->a, U+00C3->a, #U+00C4->a, U+00C5->a, U+00C7->c, U+00C8->e, U+00C9->e, U+00CA->e, U+00CB->e, #U+00CC->i, U+00CD->i, U+00CE->i, U+00CF->i, U+00D1->n, U+00D2->o, U+00D3->o, #U+00D4->o, U+00D5->o, U+00D6->o, U+00D9->u, U+00DA->u, U+00DB->u, U+00DC->u, #U+00DD->y, U+00E0->a, U+00E1->a, U+00E2->a, U+00E3->a, U+00E4->a, U+00E5->a, #U+00E7->c, U+00E8->e, U+00E9->e, U+00EA->e, U+00EB->e, U+00EC->i, U+00ED->i, #U+00EE->i, U+00EF->i, U+00F1->n, U+00F2->o, U+00F3->o, U+00F4->o, U+00F5->o, #U+00F6->o, U+00F9->u, U+00FA->u, U+00FB->u, U+00FC->u, U+00FD->y, U+00FF->y, #U+0100->a, U+0101->a, U+0102->a, U+0103->a, U+0104->a, U+0105->a, U+0106->c, #U+0107->c, U+0108->c, U+0109->c, U+010A->c, U+010B->c, U+010C->c, U+010D->c, #U+010E->d, U+010F->d, U+0112->e, U+0113->e, U+0114->e, U+0115->e, U+0116->e, #U+0117->e, U+0118->e, U+0119->e, U+011A->e, U+011B->e, U+011C->g, U+011D->g, #U+011E->g, U+011F->g, U+0120->g, U+0121->g, U+0122->g, U+0123->g, U+0124->h, #U+0125->h, U+0128->i, U+0129->i, U+012A->i, U+012B->i, U+012C->i, U+012D->i, #U+012E->i, U+012F->i, U+0130->i, U+0134->j, U+0135->j, U+0136->k, U+0137->k, #U+0139->l, U+013A->l, U+013B->l, U+013C->l, U+013D->l, U+013E->l, U+0143->n, #U+0144->n, U+0145->n, U+0146->n, U+0147->n, U+0148->n, U+014C->o, U+014D->o, #U+014E->o, U+014F->o, U+0150->o, U+0151->o, U+0154->r, U+0155->r, U+0156->r, #U+0157->r, U+0158->r, U+0159->r, U+015A->s, U+015B->s, U+015C->s, U+015D->s, #U+015E->s, U+015F->s, U+0160->s, U+0161->s, U+0162->t, U+0163->t, U+0164->t, #U+0165->t, U+0168->u, U+0169->u, U+016A->u, U+016B->u, U+016C->u, U+016D->u, #U+016E->u, U+016F->u, U+0170->u, U+0171->u, U+0172->u, U+0173->u, U+0174->w, #U+0175->w, U+0176->y, U+0177->y, U+0178->y, U+0179->z, U+017A->z, U+017B->z, #U+017C->z, U+017D->z, U+017E->z, U+01A0->o, U+01A1->o, U+01AF->u, U+01B0->u, #U+01CD->a, U+01CE->a, U+01CF->i, U+01D0->i, U+01D1->o, U+01D2->o, U+01D3->u, #U+01D4->u, U+01D5->u, U+01D6->u, U+01D7->u, U+01D8->u, U+01D9->u, U+01DA->u, #U+01DB->u, U+01DC->u, U+01DE->a, U+01DF->a, U+01E0->a, U+01E1->a, U+01E6->g, #U+01E7->g, U+01E8->k, U+01E9->k, U+01EA->o, U+01EB->o, U+01EC->o, U+01ED->o, #U+01F0->j, U+01F4->g, U+01F5->g, U+01F8->n, U+01F9->n, U+01FA->a, U+01FB->a, #U+0200->a, U+0201->a, U+0202->a, U+0203->a, U+0204->e, U+0205->e, U+0206->e, #U+0207->e, U+0208->i, U+0209->i, U+020A->i, U+020B->i, U+020C->o, U+020D->o, #U+020E->o, U+020F->o, U+0210->r, U+0211->r, U+0212->r, U+0213->r, U+0214->u, #U+0215->u, U+0216->u, U+0217->u, U+0218->s, U+0219->s, U+021A->t, U+021B->t, #U+021E->h, U+021F->h, U+0226->a, U+0227->a, U+0228->e, U+0229->e, U+022A->o, #U+022B->o, U+022C->o, U+022D->o, U+022E->o, U+022F->o, U+0230->o, U+0231->o, #U+0232->y, U+0233->y, U+1E00->a, U+1E01->a, U+1E02->b, U+1E03->b, U+1E04->b, #U+1E05->b, U+1E06->b, U+1E07->b, U+1E08->c, U+1E09->c, U+1E0A->d, U+1E0B->d, #U+1E0C->d, U+1E0D->d, U+1E0E->d, U+1E0F->d, U+1E10->d, U+1E11->d, U+1E12->d, #U+1E13->d, U+1E14->e, U+1E15->e, U+1E16->e, U+1E17->e, U+1E18->e, U+1E19->e, #U+1E1A->e, U+1E1B->e, U+1E1C->e, U+1E1D->e, U+1E1E->f, U+1E1F->f, U+1E20->g, #U+1E21->g, U+1E22->h, U+1E23->h, U+1E24->h, U+1E25->h, U+1E26->h, U+1E27->h, #U+1E28->h, U+1E29->h, U+1E2A->h, U+1E2B->h, U+1E2C->i, U+1E2D->i, U+1E2E->i, #U+1E2F->i, U+1E30->k, U+1E31->k, U+1E32->k, U+1E33->k, U+1E34->k, U+1E35->k, #U+1E36->l, U+1E37->l, U+1E38->l, U+1E39->l, U+1E3A->l, U+1E3B->l, U+1E3C->l, #U+1E3D->l, U+1E3E->m, U+1E3F->m, U+1E40->m, U+1E41->m, U+1E42->m, U+1E43->m, #U+1E44->n, U+1E45->n, U+1E46->n, U+1E47->n, U+1E48->n, U+1E49->n, U+1E4A->n, #U+1E4B->n, U+1E4C->o, U+1E4D->o, U+1E4E->o, U+1E4F->o, U+1E50->o, U+1E51->o, #U+1E52->o, U+1E53->o, U+1E54->p, U+1E55->p, U+1E56->p, U+1E57->p, U+1E58->r, #U+1E59->r, U+1E5A->r, U+1E5B->r, U+1E5C->r, U+1E5D->r, U+1E5E->r, U+1E5F->r, #U+1E60->s, U+1E61->s, U+1E62->s, U+1E63->s, U+1E64->s, U+1E65->s, U+1E66->s, #U+1E67->s, U+1E68->s, U+1E69->s, U+1E6A->t, U+1E6B->t, U+1E6C->t, U+1E6D->t, #U+1E6E->t, U+1E6F->t, U+1E70->t, U+1E71->t, U+1E72->u, U+1E73->u, U+1E74->u, #U+1E75->u, U+1E76->u, U+1E77->u, U+1E78->u, U+1E79->u, U+1E7A->u, U+1E7B->u, #U+1E7C->v, U+1E7D->v, U+1E7E->v, U+1E7F->v, U+1E80->w, U+1E81->w, U+1E82->w, #U+1E83->w, U+1E84->w, U+1E85->w, U+1E86->w, U+1E87->w, U+1E88->w, U+1E89->w, #U+1E8A->x, U+1E8B->x, U+1E8C->x, U+1E8D->x, U+1E8E->y, U+1E8F->y, U+1E96->h, #U+1E97->t, U+1E98->w, U+1E99->y, U+1EA0->a, U+1EA1->a, U+1EA2->a, U+1EA3->a, #U+1EA4->a, U+1EA5->a, U+1EA6->a, U+1EA7->a, U+1EA8->a, U+1EA9->a, U+1EAA->a, #U+1EAB->a, U+1EAC->a, U+1EAD->a, U+1EAE->a, U+1EAF->a, U+1EB0->a, U+1EB1->a, #U+1EB2->a, U+1EB3->a, U+1EB4->a, U+1EB5->a, U+1EB6->a, U+1EB7->a, U+1EB8->e, #U+1EB9->e, U+1EBA->e, U+1EBB->e, U+1EBC->e, U+1EBD->e, U+1EBE->e, U+1EBF->e, #U+1EC0->e, U+1EC1->e, U+1EC2->e, U+1EC3->e, U+1EC4->e, U+1EC5->e, U+1EC6->e, #U+1EC7->e, U+1EC8->i, U+1EC9->i, U+1ECA->i, U+1ECB->i, U+1ECC->o, U+1ECD->o, #U+1ECE->o, U+1ECF->o, U+1ED0->o, U+1ED1->o, U+1ED2->o, U+1ED3->o, U+1ED4->o, #U+1ED5->o, U+1ED6->o, U+1ED7->o, U+1ED8->o, U+1ED9->o, U+1EDA->o, U+1EDB->o, #U+1EDC->o, U+1EDD->o, U+1EDE->o, U+1EDF->o, U+1EE0->o, U+1EE1->o, U+1EE2->o, #U+1EE3->o, U+1EE4->u, U+1EE5->u, U+1EE6->u, U+1EE7->u, U+1EE8->u, U+1EE9->u, #U+1EEA->u, U+1EEB->u, U+1EEC->u, U+1EED->u, U+1EEE->u, U+1EEF->u, U+1EF0->u, #U+1EF1->u, U+1EF2->y, U+1EF3->y, U+1EF4->y, U+1EF5->y, U+1EF6->y, U+1EF7->y, #U+1EF8->y, U+1EF9->y"
#FILE
#
## capistrano
#capify!
#
#file 'config/deploy.rb', <<-FILE
#default_run_options[:pty] = true
#set :application, "#{app_name}"
#set :repository, "git@github.com:#{ask('GitHub username for the git #repository?')}/#{app_name}.git"
#set :scm, "git"
#set :ssh_options, { :forward_agent => true }
#set :use_sudo, false
#set :domain, "#{ask('What is the servername for deployment?')}"
#set :user, "rails"
#
#set :branch, "master"
#set :deploy_via, :remote_cache
#
#set :deploy_to, "/var/www/\#{application}"
#
#role :app, domain
#role :web, domain
#role :db, domain, :primary => true
#
#desc 'restart'
#deploy.task :restart, :roles => :app do
#run "touch \#{current_path}/tmp/restart.txt"
#end
#
#after 'deploy:finalize_update', :roles => :app do
#run "ln -s \#{shared_path}/config/database.yml \#{release_path}/config/database.yml"
#end
#
#FILE

# Commit all work so far to the repository
git :init
git :add => '.'
git :commit => "-a -m 'Initial commit'"