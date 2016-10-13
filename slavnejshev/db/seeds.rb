Private::User.create!(name: "admin", email: "admin@mail.ru",
        password: "password", password_confirmation: "password",
        admin: true)

Private::User.create!(name: "other", email: "other@mail.ru",
        password: "password", password_confirmation: "password")
