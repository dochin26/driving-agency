# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# 初期管理者ユーザーを作成
unless Driver.exists?(email: "admin@example.com")
  Driver.create!(
    name: "管理者",
    email: "admin@example.com",
    password: "password123",
    password_confirmation: "password123",
    role: :admin
  )
  puts "初期管理者ユーザーを作成しました"
  puts "Email: admin@example.com"
  puts "Password: password123"
end

# 日報範囲設定を作成
unless DailyReportSetting.exists?
  DailyReportSetting.create!(
    start_hour: 19,
    end_hour: 28
  )
  puts "日報範囲設定を作成しました（19:00 - 翌4:00）"
end
