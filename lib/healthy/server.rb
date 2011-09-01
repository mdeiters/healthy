module Healthy
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/views"
    set :public, "#{dir}/public"
    set :static, true
    
    get '/', :provides => 'html' do
      @checks   = Diagnostic.checks
      @tools    = Diagnostic.tools
      erb :show
    end

    get '/up.txt' do
      content_type 'text/plain'
      if Healthy::Diagnostic.all_good?
        return halt(200, 'PASS')
      else
        return halt(500, 'FAIL')
      end
    end
    
    get '/:info' do
      Healthy::Diagnostic.info_for(params[:info])
    end

    helpers do
      def url_for(path)
        "#{request.env['SCRIPT_NAME']}/#{path}"
      end
      
      def display_name(check)
        klass = check.class
        klass.respond_to?(:display_name) ? klass.display_name : klass.name
      end
      
    end
  end
end