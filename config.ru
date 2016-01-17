require 'roda'
require 'sass'
require 'tilt/haml'
require 'tilt/kramdown'

class App < Roda
  plugin :render, 
    engine: "haml",
    layout: true
    
  plugin :assets,
    #:group_subdirs => false,
    :css => [ "font-awesome.min.css", "bootstrap.min.css", "main.sass" ],
    :js => "bootstrap.min.js",
    :precompiled => "#{:public}/assets/app_metadata"

    plugin :precompile_templates
      precompile_templates "views/\*\*/*.haml"
    
    unless ENV["RACK_ENV"] =~ /^production$/i
      plugin :static,
        [ "/images", "/assets" ]
        
      compile_assets
    end

  route do |r|
    @site_title = "dakota.nu"
    r.assets unless ENV["RACK_ENV"] =~ /^production$/i
      
    r.root do
      random_titles = ["Hi", "Bonjour", "&#x1f643;"]      
      @title = random_titles.sample
      @breadcrumb = ""
      view "root"
    end
    
    r.get "code" do
      @title = "Code &amp; Stuff"
      @breadcrumb = "Code"
      view "code"
    end
  end

# Run this app.
run App
