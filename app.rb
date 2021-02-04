require 'sinatra'
require 'slim'
require 'sqlite3'


get('/user/login') do 
    slim(:"user/login")
end

post('/user/login') do 
    mail = params[:mail]
    password = params[:password]
