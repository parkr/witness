require 'erb'
require 'yaml'
require 'compass'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/partial'
require 'sinatra/activerecord'

$:.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'witness'

class WitnessApp < Sinatra::Base

  configure do
    Compass.configuration do |config|
      config.project_path  = Witness.root
      config.sass_dir      = File.join('views', 'stylesheets')
      config.line_comments = false
      config.output_style  = :nested
    end
    register Sinatra::Partial
    register Sinatra::ActiveRecordExtension
    Message.enable_query_caching
    set :partial_template_engine, :erb
    set :public_folder, Proc.new { File.join(root, "public") }
    set :partial_underscores, true
    set :scss, Compass.sass_engine_options
    set :logged_rooms,  Witness.config('logged_rooms').to_a
    set :default_room,  Witness.config('default_room').to_s
    set :message_limit, Witness.config('message_print_limit').to_i
    set :database, "mysql2://#{Witness.config('username')}:#{Witness.config('password')}"+
                    "@#{Witness.config('host')}:#{Witness.config('port')}/#{Witness.config('database')}"
  end

  helpers ::Sinatra::Partial::Helpers
  helpers ::Sinatra::JSON
  helpers Witness::Helpers::Auth
  helpers Witness::Helpers::Paths
  helpers Witness::Helpers::Urls
  helpers do
    def partial(page, options={})
      erb page, options.merge!(:layout => false)
    end

    def load_if_exists(file)
      if File.exists?(file) && File.file?(file)
        File.read(file)
      end
    end

    def logged_rooms
      @logged_rooms || settings.logged_rooms
    end

    def current_room
      room_name(@room || settings.default_room)
    end

    def message_limit
      @limit || settings.message_limit
    end
  end

  get '/api/auth/failure' do
    if Witness::Api.can_handle?(request.path)
      halt 403, json(Witness::Api::FORBIDDEN)
    else
      halt 403, {'Content-Type' => 'text/plain'}, "Sorry, you're not authorized to do that."
    end
  end

  get('/messages/:id') do |id|
    begin
      @m = Message.find(id.to_i)
      erb :show
    rescue ActiveRecord::RecordNotFound
      Proc.new { 404 }.call
    end
  end

  get('/messages/by/:author') do |author|
    begin
      @limit  = 20
      @author = author.to_s
      @m      = Message.where(['author LIKE ?', author])
                  .limit(@limit)
                  .order('id DESC')
                  .group_by(&:room)
      erb :by_author
    rescue ActiveRecord::RecordNotFound
      Proc.new { 404 }.call
    end
  end

  get('/room/:name') do |name|
    @room = name
    erb :room
  end

  get('/search') do
    @query = params[:q].to_s
    redirect '/' unless @query.size > 0
    @m = Message.where(['message LIKE ?', "%#{@query}%"])
          .order('id DESC')
          .group_by(&:room)
    erb :search
  end

  get(/.+/) do
    if Witness::Api.can_handle?(request.path)
      protected! unless request.path.include?("api/auth/failure")
      json Witness::Api.handle(request, params)
    else
      send_sinatra_file(request.path) {404}
    end
  end

  post(/.+/) do
    if Witness::Api.can_handle?(request.path)
      protected! unless request.path.include?("api/auth/failure")
      json Witness::Api.handle(request, params)
    else
      json({:error => {
        :message => "Not Found",
        :code    => 404
      }}, :content_type => :js)
    end
  end

  not_found do
    send_sinatra_file('404.html') {"Sorry, I cannot find #{request.path}"}
  end

  def send_sinatra_file(path, &missing_file_block)
    if File.exist?(File.join(Witness.root, 'public', static_path(path)))
      send_file path
    elsif File.exist?(File.join(Witness.root, 'views', erb_path(path)))
      erb erb_path(path).gsub(/\.erb$/, '').to_sym
    elsif File.extname(path) == '.css' && File.exist?(File.join(Witness.root, 'views', 'stylesheets', scss_path(path)))
      content_type 'text/css', :charset => 'utf-8'
      scss :"stylesheets/#{scss_path(path).gsub(/\.scss$/, '')}", Compass.sass_engine_options
    else
      missing_file_block.call
    end
  end
end
