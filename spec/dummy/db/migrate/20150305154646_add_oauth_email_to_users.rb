class AddOauthEmailToUsers < ActiveRecord::Migration
  def up
    add_column :users, :oauth_email, :string

    User.find_each do |user|
      if user.provider
        user.update_columns oauth_email: user.email, email: ''
      end
    end
  end

  def down
    User.find_each do |user|
      if user.provider
        user.update_columns email: user.oauth_email
      end
    end

    remove_column :users, :oauth_email
  end
end
