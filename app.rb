require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'date'
require './model.rb'
enable :sessions

get('/') do
    article = select_all_article_info() 
    slim(:"start", locals:{article:article})
end

get('/user/login') do 
    slim(:"user/login")
end

post('/user/login') do
    mail = params[:mail]
    password = params[:password] # från  
    user_information = select_user_information(mail)
    p user_information # something isnt here
    admin = select_user_admin_points(user_id)
    admin_roll = admin["admin"]
    password_digest = user_information["password_digest"]
    user_id = user_information["user_id"]
    if BCrypt::Password.new(password_digest) == password
        session[:user_id] = user_id
        session[:mail] = mail
        session[:admin] = admin_roll
        redirect('/')
    else 
        "Fel Lösenord"
    end 
end

post('/user/register') do 
    mail = params[:mail]
    password_input = params[:password]
    password_confirmation = params[:password_confirmation]
    date_joined = Time.now.getutc.to_s
    db = SQLite3::Database.new("db/data.db")
    password = password_input 

    result = db.execute("SELECT user_id  FROM user WHERE mail=?", mail)

    # does not count for different mails adresses
    if result.empty?
        if password_input == password_confirmation
            password_digest = BCrypt::Password.create(password)
            register_user(mail, password_digest, date_joined)
            register_put_in_admin(user_id)
            redirect('/') 
        else
            "error" # no error msg also adds empty account. make a slim side for error 
        end
    else
        "error"
    end
end

get('/user/profile/:id') do 
    user_id = session[:user_id]
    article_id = params[:id].to_i
    all_user_data = select_all_user_info_id(user_id)
    all_data = select_all_article_info_id(article_id)
    slim(:"user/profile", locals:{all_data:all_data, all_user_data:all_user_data})
end 

post('/profile/edit') do
   
end


get('/publish') do 
    slim(:publish)
end

post('/publish/new') do 
    title = params[:title]
    user_id = session[:user_id]
    adress = params[:adress]
    phone_number = params[:phone_number]
    content = params[:content]
    price = params[:price]
    date_created = Time.now.getutc.to_s

    if title != "" && adress != "" && phone_number != "" && content != "" && price != ""    
        insert_into_article(title, content, price, user_id, adress, phone_number, date_created)
        redirect("/")
    else 
        "Fill in all" # better msg needed
    end 
end

get('/articles/:id') do 
    article_id = params[:id].to_i
    all_data = select_all_article_info_id(article_id)
    slim(:"articles/content", locals:{all_data:all_data})
end 

get ('/articles/:id/edit') do 
    article_id = params[:id].to_i
    all_data = select_all_article_info_id(article_id)
    slim(:"articles/edit", locals:{all_data:all_data})
end

post("/articles/:id/update") do #the form in the update slim file 
    article_id = params[:id].to_i 
    title = params[:title]
    date_uploaded = Time.now.getutc.to_s
    adress = params[:adress]
    phone_number = params[:phone_number]
    content = params[:content]
    price = params[:price]

    if title != "" && adress != "" && phone_number != "" && content != "" && price != ""    
        update_article(title, content, price, adress, phone_number, date_uploaded, article_id)
        redirect("/")
    else 
        "fyll i allt"
    end
end

get("/articles/:id/delete") do 
    article_id = params[:id].to_i
    delete_article(article_id)
    redirect('/')
end 


