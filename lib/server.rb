module HealthStatus
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
      if Diagnostic.all_good?
        return halt(200, 'PASS')
      else
        return halt(500, 'FAIL')
      end
    end
    
    get '/:info' do
      dom_name = Diagnostic.normalize_name(params[:info])
      check    = Diagnostic.find(dom_name) 
      check.htmlized_info.to_json
    end

    helpers do
      def url_for(path)
        "#{request.env['SCRIPT_NAME']}/#{path}"
      end      
    end
  end
end