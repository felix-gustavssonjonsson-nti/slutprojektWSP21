require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'date'


get('/') do 
    slim(:start)
end

get('/user/login') do 
    slim(:"user/login")
end

post('/user/login') do
    mail = params["mail"]
    password_input = params["password"]

    db = SQLite3::Database.new("db/data.db")
    db.results_as_hash = true 
    result = db.execute("SELECT * FROM user  WHERE mail = ?",mail).first 
    password_digest = result["password_digest"]
    id = result["userid"]

    if BCrypt::Password.new(password_digest) == Password
        redirect('/')
    else 
        "FEl"
   
end


    # something is missing here look later

    redirect('/user/profile')
end



post('/user/register') do 
    mail = params[:mail]
    password_input = params[:password]
    password_confirmation = params[:password_confirmation]
    db = SQLite3::Database.new("db/data.db")
    password = password_input 

    result = db.execute("SELECT userID  FROM user WHERE mail=?", mail)

    db.execute("INSERT INTO User (mail, password_digest) VALUES (?, ?)", mail, password)
    # does not count for different mails adresses
    if result.empty?
        if password_input == password_confirmation
            password_digest = BCrypt::Password.create(password)
            db = SQLite3::Database.new("db/data.db")
            db.execute("INSERT INTO user(mail, password_digest) VALUES (?, ?)", mail, password_digest)
            redirect('/') # doest not redirect
        else
            "error"
        end
    else
        "error"
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
    db.execute("INSERT INTO article (title, adress, content, price, phone_number) ")
    redirect('/start')
end