require 'sinatra'
require 'slim'
require 'sqlite3'


get('/') do 
    slim(:start)
end

get('/user/login') do 
    slim(:"user/login")
end

post('/user/login') do
    mail = params["mail"]
    password = params["password"]
    password_confirmation = params["confirm_password"]

    db = SQLite3::Database.new("db/data.db")
    result = db.execute("SELECT userid FROM user WHERE mail=?", mail)
    # something is missing here look later

    redirect('/user/profile')
end
end


post('/user/register') do 
    mail = params[:mail]
    password = params[:password]
    db = SQLite3::Database.new("db/data.db")
    db.execute("INSERT INTO User (mail, password_digest) VALUES (?, ?)", mail, password)
    # this doesnt work atm
    if result.empty?
        if password == password_confirmation
            password_digest = Bcrypt::Password.create(password)
            p password_digest
            db.execute("INSERT INTO user(mail, password_digest) VALUES (?, ?)", mail, password)
        end
end

get('/publish') do 
    slim(:publish)
end

post('/publish/new') do 
    title = params[:title]
    adress = params[:adress]
    phone_number = params[:phone_number]
    content = params[:content]
    price = params[:price]
    db = SQLite3::Database.new("db/data.db")
    db.execute("INSERT INTO Article (title, adress, content, price, phone_number) ")
    redirect('/start')
end