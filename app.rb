# -*- coding: utf-8 -*-
require 'sinatra'
require 'active_record'
require 'sqlite3'
require 'socket'

ActiveRecord::Base.configurations = YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/database.yml')
ActiveRecord::Base.establish_connection('production')

after do
  ActiveRecord::Base.connection.close
end

class Mac < ActiveRecord::Base
end

private
def wakeup(mac)
  magic = ['FF'].pack('H2') * 6 + mac.split(':').pack('H2H2H2H2H2H2') * 16
  s = UDPSocket.new
  s.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
  s.send(magic, 0, '255.255.255.255', 7)
end

# ------------------


get '/' do
  @macs = Mac.order('pos ASC')
  erb :"index"
end


get '/wakeup/:id' do
  @mac = Mac.find(params[:id])
  wakeup(@mac.addr)
  redirect "/"
end


post '/mac' do
  @macs = Mac.new(params[:post])
  @macs.pos = (Time.now.to_i * 1000 + Time.now.usec / 1000).round
  @macs.save
  redirect "/"
end


get '/mac/:id/edit' do
  @mac = Mac.find(params[:id])
  erb :"edit"
end


put '/mac/:id' do
  @mac = Mac.find(params[:id])
  @mac.update_attributes(params[:post])
  redirect "/"
end


delete '/mac/:id' do
  @mac = Mac.find(params[:id])
  @mac.destroy
  redirect "/"
end


get '/mac/:id/move' do
  @macs = Mac.order('pos ASC')
  @arrindex = @macs.index {|v| v.id == params[:id].to_i}

  if params[:direction] == 'up'
    if @arrindex > 0
      @tmp_macs_1 = Mac.find(@macs[@arrindex].id)
      @tmp_macs_2 = Mac.find(@macs[@arrindex - 1].id)
    else
      redirect "/"
    end
  elsif params[:direction] == 'down'
    if @arrindex < @macs.size - 1
      @tmp_macs_1 = Mac.find(@macs[@arrindex].id)
      @tmp_macs_2 = Mac.find(@macs[@arrindex + 1].id)
    else
      redirect "/"
    end
  else
    redirect "/"
  end

  @tmppos = @tmp_macs_1.pos
  @tmp_macs_1.pos = @tmp_macs_2.pos
  @tmp_macs_2.pos = @tmppos

  ActiveRecord::Base::transaction do
    @tmp_macs_1.save
    @tmp_macs_2.save
  end

  redirect "/"
end

