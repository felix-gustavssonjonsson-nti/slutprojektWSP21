def connect_to_db()
end

def get_db()
    return SQLite3::Database.new("db/data.db")
end

def get_db_as_hash()
    db = get_db()
    db.results_as_hash = true 
    return db
end

def select_user_information(mail)
    return get_db_as_hash().execute("SELECT * FROM user WHERE mail = ?", mail).first
end

def select_all_user_info_id(user_id)
    return get_db_as_hash().execute("SELECT * FROM user WHERE user_id = ?", user_id).first
end

def select_user_admin_points(user_id)
    return get_db_as_hash().execute("SELECT admin FROM admin WHERE user_id = ?", user_id).first
end

def register_put_in_admin(user_id)
    db = SQLite3::Database.new("db/data.db")
    db.execute("INSERT INTO admin(user_id) VALUES (?)", user_id)
end

def register_user(mail, password_digest, date_joined)
    db = SQLite3::Database.new("db/data.db")
    db.execute("INSERT INTO user(mail, password_digest, date_joined) VALUES (?, ?, ?)", mail, password_digest, date_joined)
end

def new_post()
end 


def select_all_article_info()
    return get_db_as_hash().execute("SELECT * FROM article")
end 

def select_all_article_info_id(article_id)
    return get_db_as_hash().execute("SELECT * FROM article WHERE article_id = ?", article_id).first
end 

def insert_into_article(title, content, price, user_id, adress, phone_number, date_created) 
    return get_db().execute("INSERT INTO article (title, content, price, user_id, adress, phone_number, date_created) VALUES (?, ?, ?, ?, ?, ?, ?)", title, content, price, user_id, adress, phone_number, date_created)
end

def update_article(title, content, price, adress, phone_number, date_created, article_id) 
    return get_db().execute("UPDATE article SET title = ?, content = ?, price = ?, adress = ?, phone_number = ?, date_created = ? WHERE article_id = ?", title, content, price, adress, phone_number, date_created, article_id)
end

def delete_article(article_id)
    return get_db().execute("DELETE FROM article WHERE article_id = ?", article_id) 
end
