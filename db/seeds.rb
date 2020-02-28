Transaction.delete_all
Statement.delete_all
User.delete_all

User.create(
    first_name: "Daniel",
    last_name: "Kim",
    email: "dltcm0827@gmail.com",
    password: "1234",
    balance: 1000.00
)

User.create(
    first_name: "Dohee",
    last_name: "Lee",
    email: "dohee0817@gmail.com",
    password: "1234",
    balance: 2117.95
)

puts "=================================================="
puts "Successfully generated #{User.count} users"
puts "email : dltcm0827@gmail.com || dohee0817@gmail.com"
puts "password: 1234"
puts "=================================================="
puts "Generating statement and transactions please wait..."

users = User.all

100.times do
    user = users.sample
    statement = Statement.new(
        period: DateTime.new(rand(2018..2020), rand(1..12), 1),
        user_id: user.id,
        memo: "Need to be careful with spending on drinks"
    )
    statement.title = statement.period.strftime("%B") + ", " + statement.period.strftime("%Y")
    
    if statement.save
        income_1 = Transaction.new(
            description: "Salary",
            trans_date: DateTime.new(statement.period.strftime("%Y").to_i, statement.period.strftime("%m").to_i, rand(1..28)),
            trans_type: "INCOME",
            amount: 3000.00,
            user_id: statement.user_id,
            statement_id: statement.id
        )
        income_1.save

        le_1 = Transaction.new(
            description: "Rent",
            trans_date: DateTime.new(statement.period.strftime("%Y").to_i, statement.period.strftime("%m").to_i, rand(1..28)),
            trans_type: "LE",
            amount: 1200.00,
            user_id: statement.user_id,
            statement_id: statement.id
        )
        le_1.save
        le_2 = Transaction.new(
            description: "Phone",
            trans_date: DateTime.new(statement.period.strftime("%Y").to_i, statement.period.strftime("%m").to_i, rand(1..28)),
            trans_type: "LE",
            amount: 80.23,
            user_id: statement.user_id,
            statement_id: statement.id
        )
        le_2.save
        le_3 = Transaction.new(
            description: "Hydro Bill",
            trans_date: DateTime.new(statement.period.strftime("%Y").to_i, statement.period.strftime("%m").to_i, rand(1..28)),
            trans_type: "LE",
            amount: 98.27,
            user_id: statement.user_id,
            statement_id: statement.id
        )
        le_3.save
        10.times do
            drink_option = ["Starbucks", "TimHortons", "BlenzCoffee", "BubbleWorld"].sample
            Transaction.create(
                description: drink_option,
                trans_date: DateTime.new(statement.period.strftime("%Y").to_i, statement.period.strftime("%m").to_i, rand(1..28)),
                trans_type: "NLE",
                category: "DRINK",
                amount: rand(3.97..5.88),
                user_id: statement.user_id,
                statement_id: statement.id,
                created_at: DateTime.now,
                updated_at: DateTime.now
            )
        end

        10.times do
            food_option = ["BurgerKing", "PizzaPizza", "KFC", "WonTon", "Kimchi Fried Rice"].sample
            Transaction.create(
                description: food_option,
                trans_date: DateTime.new(statement.period.strftime("%Y").to_i, statement.period.strftime("%m").to_i, rand(1..28)),
                trans_type: "NLE",
                category: "FOOD",
                amount: rand(10.99..15.99),
                user_id: statement.user_id,
                statement_id: statement.id,
                created_at: DateTime.now,
                updated_at: DateTime.now
            )
        end

        5.times do
            want_option = ["Game Item", "Nintendo", "Iphone", "Samsung Galaxy S10", "X-Box"].sample
            Transaction.create(
                description: want_option,
                trans_date: DateTime.new(statement.period.strftime("%Y").to_i, statement.period.strftime("%m").to_i, rand(1..28)),
                trans_type: "NLE",
                category: "WANT",
                amount: rand(50.98..70.00),
                user_id: statement.user_id,
                statement_id: statement.id,
                created_at: DateTime.now,
                updated_at: DateTime.now
            )
        end

        5.times do
            others_option = ["Hangout with friends", "Harrison HotSpring", "Whistler Trip", "Evo Carshare"].sample
            Transaction.create(
                description: others_option,
                trans_date: DateTime.new(statement.period.strftime("%Y").to_i, statement.period.strftime("%m").to_i, rand(1..28)),
                trans_type: "NLE",
                category: "OTHERS",
                amount: rand(50.98..70.00),
                user_id: statement.user_id,
                statement_id: statement.id,
                created_at: DateTime.now,
                updated_at: DateTime.now
            )
        end

    end
end

puts "Sucessfully generated #{Statement.count} statements"
puts "Sucessfully generated #{Transaction.count} transactions"
puts ""
puts "Seeding is successfully done. Thank you!"
puts "=================================================="