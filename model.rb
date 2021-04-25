module Model 

   # Grants access to the database 
   #
    def get_db()
        return SQLite3::Database.new("db/data.db")
    end

    # Outpust all data in a hash-format
    #
    # @return [Hash] containing entire database as a hash 
    def get_db_as_hash()
        db = get_db()
        db.results_as_hash = true 
        return db
    end

    # Outputs all data of a single user
    # 
    # @param [String] mail, The mail of the user 
    #
    # @return [Hash]
    #   * :user_id [Integer] The ID of the user 
    #   * :mail [String] The mail of the user
    #   * :password_digest [String] The password of the user in a crypted format
    #   * :date_joined [Integer] The date of time the user created their account
    #   * :admin [Integer] The value determining wether the user is admin or not
    def select_user_information(mail)
        return get_db_as_hash().execute("SELECT * FROM user WHERE mail = ?", mail).first
    end

    # Outputs all the data from the user table 
    #
    # @return [Hash]
    def select_all_user_info()
        return get_db_as_hash().execute("SELECT * FROM user")
    end 

    # Controls wether the mail exists in the database or not 
    #
    # @param [String] mail, the mail of the user 
    def mail_exists(mail)
        return get_db_as_hash().execute("SELECT * FROM user WHERE mail = ?", mail)
    end

    # Outputs all data of a single user 
    #
    # @param [Integer] user_id, The ID of the user 
    #
    # @return [Hash]
    #   * :user_id [Integer] The ID of the user 
    #   * :mail [String] The mail of the user
    #   * :password_digest [String] The password of the user in a crypted format
    #   * :date_joined [Integer] The date of time the user created their account
    #   * :admin [Integer] The value determining wether the user is admin or not
    def select_all_user_info_id(user_id)
        p "uder id #{user_id}s"
        p "look here#{get_db_as_hash().execute("SELECT * FROM user WHERE user_id = ?", user_id).first}"
        return get_db_as_hash().execute("SELECT * FROM user WHERE user_id = ?", user_id).first
    end

    # Inserts a new user row into the user table in the database 
    #
    # @param [String] mail, The mail of the user 
    # @param [String] password_digest, The encrypted password of the user 
    # @param [Integer] date_joined, The date of time the user created their account
    # @param [Integer] admin, The value determining wether the user is admin or not
    def register_user(mail, password_digest, date_joined, admin)
        return get_db_as_hash().execute("INSERT INTO user(mail, password_digest, date_joined, admin) VALUES (?, ?, ?, ?)", mail, password_digest, date_joined, admin)
    end

    # Updates the users admin value and gives admin 
    #
    # @param [Integer] admin, The value determining wether the user is admin or not
    # @param [Integer] user_id, The ID of the user
    def give_admin(admin, user_id)
        return get_db_as_hash().execute("UPDATE user SET admin = 1  WHERE user_id = ? ", user_id).first
    end 

    # Updates the users admin value and removes admin 
    #
    # @param [Integer] admin, The value determining wether the user is admin or not
    # @param [Integer] user_id, The ID of the user
    def remove_admin(admin, user_id)
        return get_db_as_hash().execute("UPDATE user SET admin = 0 WHERE user_id = ?", user_id).first 
    end

    # Outputs all the data from the article table and tag table
    #
    # @return [Hash]
    #   * :article_id [Integer] The ID of article 
    #   * :title [String] The title of the article
    #   * :content [String] The content of the article
    #   * :price [Integer] The price of the article
    #   * :user_id [Integer] The user ID of the poster of the article 
    #   * :adress [String] The adress of the poster 
    #   * :phone_number [Integer] The phone number of the poster
    #   * :date_created [Integer] The date the article was posted 
    #   * :tag_id [Integer] The ID of the tag attached to the article  
    def select_all_article_info()
        return get_db_as_hash().execute("SELECT * FROM article JOIN tags ON article.tag_id=tags.tag_id")
    end 

    # Outputs all the data from a single article row
    #
    # @param [Integer] article_id, The ID of the article 
    #
    # @return [Hash]
    #   * :article_id [Integer] The ID of article 
    #   * :title [String] The title of the article
    #   * :content [String] The content of the article
    #   * :price [Integer] The price of the article
    #   * :user_id [Integer] The user ID of the poster of the article 
    #   * :adress [String] The adress of the poster 
    #   * :phone_number [Integer] The phone number of the poster
    #   * :date_created [Integer] The date the article was posted 
    #   * :tag_id [Integer] The ID of the tag attached to the article  
    def select_all_article_info_id(article_id)
        return get_db_as_hash().execute("SELECT * FROM article WHERE article_id = ?", article_id).first
    end 

    # Inserts a new article row into the article table  
    #
    # @param [String] title, The title of the article
    # @param [String] content, The content of the article
    # @param [Integer] price, The price of the article
    # @param [Integer] user_id, The user ID of the poster of the article 
    # @param [String] adress, The adress of the poster 
    # @param [Integer] phone_number, The phone number of the poster
    # @param [Integer] date_created, The date the article was posted 
    # @param [Integer] tag_id, The ID of the tag attached to the article  
    def insert_into_article(title, content, price, user_id, adress, phone_number, date_created, tag_id) 
        return get_db().execute("INSERT INTO article (title, content, price, user_id, adress, phone_number, date_created, tag_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", title, content, price, user_id, adress, phone_number, date_created, tag_id)
    end

    # Updates the data of an article row in the article table
    #
    # @param [String] title, The title of the article
    # @param [String] content, The content of the article
    # @param [Integer] price, The price of the article
    # @param [Integer] user_id, The user ID of the poster of the article 
    # @param [String] adress, The adress of the poster 
    # @param [Integer] phone_number, The phone number of the poster
    # @param [Integer] date_created, The date the article was posted 
    # @param [Integer] tag_id, The ID of the tag attached to the article 
    def update_article(title, content, price, adress, phone_number, date_created, article_id) 
        return get_db().execute("UPDATE article SET title = ?, content = ?, price = ?, adress = ?, phone_number = ?, date_created = ? WHERE article_id = ?", title, content, price, adress, phone_number, date_created, article_id)
    end

    # Deletes a row from the article table 
    #
    # @param [Integer] article_id, the ID of the article 
    def delete_article(article_id)
        return get_db().execute("DELETE FROM article WHERE article_id = ?", article_id) 
    end

    # Inserts a tag row into the tags table 
    #
    # @param [String] tag_name, The name of the tag 
    def insert_tag(tag_name)
        return get_db_as_hash().execute("INSERT INTO tags (tag_name) VALUES (?)", tag_name).first
    end 

    # Outputs all the data from the tags table 
    #
    # @return [Hash]
    #   * :tag_id [Integer] The ID of the tag 
    #   * :tag_name [String] The name of the tag  
    def select_tags()
        return get_db_as_hash().execute("SELECT * FROM tags")
    end 

    # Outputs data from one tag row from the tags table
    #
    # @param [Integer] tag_id, The ID of the tag 
    #
    # @return [Hash] 
    #   * :tag_id [Integer] The ID of the tag 
    #   * :tag_name [String] The name of the tag  
    def select_tag_info(tag_id)
        return get_db_as_hash().execute("SELECT tag_name FROM tags WHERE tag_id = ?", tag_id).first
    end 
end