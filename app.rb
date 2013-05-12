require 'erb'
require 'yaml'
require 'compass'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/partial'
require 'sinatra/activerecord'

$:.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'chat_log_server'

class ChatLogServerApp < Sinatra::Base

  configure do
    register Sinatra::Partial
    register Sinatra::ActiveRecordExtension
    set :partial_template_engine, :erb
    set :public_folder, Proc.new { File.join(root, "public") }
    set :partial_underscores, true
    set :scss, { :style => :compact, :debug_info => false }
    set :database, "mysql2://#{ChatLogServer.config('username')}:#{ChatLogServer.config('password')}"+
                    "@#{ChatLogServer.config('host')}:#{ChatLogServer.config('port')}/#{ChatLogServer.config('database')}"
  end

  helpers ::Sinatra::Partial::Helpers
  helpers ::Sinatra::JSON
  helpers do
    def partial(page, options={})
      html page, options.merge!(:layout => false)
    end

    def load_if_exists(file)
      if File.exists?(file) && File.file?(file)
        File.read(file)
      end
    end

    def valid_access_token
      ChatLogServer.config('access_tokens').include?(params[:access_token])
    end

    def protected!
      redirect '/api/auth/failure' unless valid_access_token
    end

    def erb_path(path)
      if path.match(/^\/$/)
        "index.erb"
      else
        if !path.match(/\.erb$/)
          "#{path.gsub(File.extname(path), '')}.erb"
        else
          path
        end
      end
    end

    def static_path(path)
      if path =~ /\/$/
        "#{path}/index.html"
      else
        path
      end
    end
  end

  get '/api/auth/failure' do
    halt 403, {'Content-Type' => 'text/plain'}, "Sorry, you're not authorized to do that."
  end

  get(/.+/) do
    if ChatLogServer::Api.can_handle?(request.path)
      protected! unless request.path.include?("api/auth/failure")
      json ChatLogServer::Api.handle(request, params)
    else
      send_sinatra_file(request.path) {404}
    end
  end

  post(/.+/) do
    if ChatLogServer::Api.can_handle?(request.path)
      protected! unless request.path.include?("api/auth/failure")
      json ChatLogServer::Api.handle(request, params)
    else
      json({:foo => 'bar'}, :content_type => :js)
    end
  end

  not_found do
    send_sinatra_file('404.html') {"Sorry, I cannot find #{request.path}"}
  end

  def send_sinatra_file(path, &missing_file_block)
    if File.exist?(File.join(ChatLogServer.root, 'public', static_path(path)))
      send_file path
    elsif File.exist?(File.join(ChatLogServer.root, 'views', erb_path(path)))
      erb erb_path(path).gsub(/\.erb$/, '').to_sym
    else
      missing_file_block.call
    end
  end
end
