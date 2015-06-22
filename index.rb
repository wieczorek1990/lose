require 'sinatra'
require 'sinatra/json'
require 'data_mapper'
require 'dm-migrations'
require 'json'
require_relative 'note'

# Based on http://www.codeproject.com/Tips/668655/Rest-service-with-Ruby-plus-Sinatra-plus-Datamappe

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/index.db")
DataMapper.finalize
DataMapper.auto_migrate!

Note.create(
  text: 'Hello world'
)

set :public_folder, 'public'

get '/' do
  redirect('/index.html')
end

get '/api/' do
  json(Note.all)
end

get '/api/:id' do
  note = Note.get(params[:id])
  halt(404) if note.nil?
  json(note)
end

post '/api/' do
  body = JSON.parse(request.body.read)
  note = Note.create(
    text: body['text']
  )
  status(201)
  json(note)
end

put '/api/:id' do
  body = JSON.parse request.body.read
  note = Note.get(params[:id])
  halt(404) if note.nil?
  halt(500) unless note.update(
    text: body['text']
  )
  status(200)
end

delete '/api/:id' do
  note = Note.get(params[:id])
  halt(404) if note.nil?
  halt(500) unless note.destroy
  status(200)
end

