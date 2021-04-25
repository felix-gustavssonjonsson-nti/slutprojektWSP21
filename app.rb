require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'date'
require './model.rb'

enable :sessions

include Model 

# Display Landing Page
#
# @see Model#select_all_article_info
get('/') do
    article = select_all_article_info() 
    slim(:"start", locals:{article:article})
end

# Display a login form 
#
get('/user/login') do 
    slim(:"user/login")
end

# Attemps login and updates the session redicrecting to ('/') in case of successful login
#
# @param [String] mail, The mail adress
# @param [String] password, The password
#
# @see Model#select_user_information
# @see Model#mail_exist
post('/user/login') do
    mail = params[:mail]
    password = params[:password]  
    mail_check = mail_exists(mail)
      
    if mail_check == []
        "Incorrect input"
    else
        user_information = select_user_information(mail)
        password_digest = user_information["password_digest"]
        user_id = user_information["user_id"]
        admin = user_information["admin"].to_i 
        if BCrypt::Password.new(password_digest) == password
            session[:user_id] = user_id
            session[:mail] = mail
            session[:admin] = admin
            redirect('/')
        else 
            "Fel Lösenord"
        end
    end 
end

# Attempts registration and redirects to ('/') in case of successful registration
#
# @param [String] mail, The mail adress  
# @param [String] password, The password
# @param [String] password_confirmation, The repeated password
#
# @see Model#register_user
post('/user/register') do 
    mail = params[:mail]
    password_input = params[:password]
    password_confirmation = params[:password_confirmation]
    date_joined = Time.now.getutc.to_s
    admin = 0 
    db = SQLite3::Database.new("db/data.db")
    password = password_input 

    result = db.execute("SELECT user_id  FROM user WHERE mail=?", mail)

    # does not count for different mails adresses
    if result.empty?
        if password_input == password_confirmation
            password_digest = BCrypt::Password.create(password)
            register_user(mail, password_digest, date_joined, admin)
            redirect('/') 
        else
            "Please put in right password in both field" # no error msg also adds empty account. make a slim side for error 
        end
    else
        "something is wrong"
    end
end

# Displays currently logged in user profile 
#
# @param [Integer] :id, The ID of the user 
# @param [Integer] user_id, The ID of the current user
# @param [Integer] article_id, The id of an article
#
# @see Model#select_all_user_info_id
# @see Mode#select_all_article_info_id
get('/user/profile/:id') do 
    user_id = session[:user_id]
    article_id = params[:id].to_i
    all_user_data = select_all_user_info_id(user_id)
    all_data = select_all_article_info_id(article_id)
    slim(:"user/profile", locals:{all_data:all_data, all_user_data:all_user_data})
end 

# Attempts logout and destroys the session and redirects to ('/') 
#
get("/logout") do 
        session.destroy
    redirect("/")
end

# Displays an admin page 
#
# @see Model#select_all_user_info
# @see Model#select_tags
get("/admin") do 
    user_list = select_all_user_info()
    tag_list = select_tags()
    slim(:"admin", locals:{user_list:user_list, tag_list:tag_list})
end

# Updates a users admin privileges and redirects to ('/admin')
#
# @param [Integer] user_id, The ID of the user being given admin   
# @param [Integer] admin_id, The ID of the current user 
#
# @see Model#select_all_user_info_id
# @see Model#give_admin
post("/admin/give") do 
    user_id = params[:admin_user_id].to_i
    admin_id = session[:user_id]
    admin_information = select_all_user_info_id(admin_id)
    is_admin = admin_information["admin"].to_i
    if is_admin == 1
        user_information = select_all_user_info_id(user_id)
        is_admin = user_information["admin"].to_i
        if is_admin == 0 
            is_admin = 1
            give_admin(is_admin, user_id) 
            redirect("/admin")
        end
    end 
end 

# Updates a users admin privileges and redirects to ('/admin')
#
# @param [Integer] user_id, The ID of the user having admin removed  
# @param [Integer] admin_id, The ID of the current user 
#
# @see Model#select_all_user_info_id
# @see Model#remove_adminl
post("/admin/remove") do 
    user_id = params[:admin_user_id].to_i
    admin_id = session[:user_id]
    admin_information = select_all_user_info_id(admin_id)
    logged_in_user_is_admin = admin_information["admin"].to_i
    if logged_in_user_is_admin == 1
        user_information = select_all_user_info_id(user_id)
        is_admin = user_information["admin"].to_i
        if is_admin == 1
            is_admin = 0
            remove_admin(is_admin, user_id) 
            redirect("/admin")
        end 
    end 
end 

# Inserts a tag written by the admin into the db and redirects to '/admin'
#
# @param [String] tag_name, The name of the added tag  
#
# @see Model#insert_tag
post("/admin/tags") do 
    tag_name = params[:tag_name]
    insert_tag(tag_name)
    redirect('/admin')
end 

# Displays Publish Page
#
# @see Model#select_tags
get('/publish') do 
    tag_list = select_tags()
    slim(:publish, locals:{tag_list:tag_list})
end

# Creates a new article and redirects to ('/')
#
# @param [String] title, The title of the article
# @param [Integer] user_id, The logged in users ID
# @param [String] adress, The adress of the user
# @param [Integer] phone_number, The phone number of the user 
# @param [String] content, The content of the Article 
# @param [Integer] price, The set price of the Article 
# @param [Integer] tag_id, The ID of the selected tag of the Article
#
# @see Model#insert_into_article
post('/publish/new') do 
    title = params[:title]
    user_id = session[:user_id]
    adress = params[:adress]
    phone_number = params[:phone_number]
    content = params[:content]
    price = params[:price]
    date_created = Time.now.getutc.to_s
    tag_id = params[:tag].to_i
    
    if title != "" && adress != "" && phone_number != "" && content != "" && price != "" && tag_id != ""   
        insert_into_article(title, content, price, user_id, adress, phone_number, date_created, tag_id)
        redirect("/")
    else 
        "Fill in all" # better msg needed
    end 
end

# Displays a single Article 
#
# @param [Integer] :id, The ID of the article 
# @param [Integer] article_id, The ID of the article
#
# @see Model#select_all_article_info_id
get('/articles/:id') do 
    article_id = params[:id].to_i
    all_data = select_all_article_info_id(article_id)
    slim(:"articles/content", locals:{all_data:all_data})
end 

# Displays the article edit page 
#
# @param [Integer] :id, The ID of the article 
# @param [Integer] article_id, The ID of the article
#
# @see Model#select_all_article_info_id
get('/articles/:id/edit') do 
    article_id = params[:id].to_i
    all_data = select_all_article_info_id(article_id)
    slim(:"articles/edit", locals:{all_data:all_data})
end

# Updates an existing article and redirects to ('/')
#
# @param [Integer] :id, The ID of the article 
# @param [Integer] article_id, The ID of the article
# @param [String] title, The title of the article
# @param [String] adress, The adress of the user
# @param [Integer] phone_number, The phone number of the user 
# @param [String] content, The content of the Article 
# @param [Integer] price, The set price of the Article 
#
# @see Model#update_article
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

# Deletes and existing article and redirects to '/'
#
# @param [Integer] :id, The ID of the article 
# @param [Integer] article_id, The ID of the article
#
# @see Model#delete_article
get("/articles/:id/delete") do 
    article_id = params[:id].to_i
    delete_article(article_id)
    redirect('/')
end 


