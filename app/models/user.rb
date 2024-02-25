class User < ApplicationRecord
  # gem 'bcrypt'
  has_secure_password
  # validates
  validates :name, presence: true, # 入力必須
                   length: { # 文字数
                     maximum: 30, # 最大文字数
                     allow_blank: true, # Null, 空白文字の場合スキップ
                   }

  validates :password, presence: true, # 入力必須
                       length: { minimum: 8, allow_blank: true }, # 最小文字数
                       format: {
                         with: /\A[\w\-]+\z/, # 正規表現チェック
                         message: :invalid_password,
                         allow_blank: true,
                       },
                       allow_nil: true # 空パスワードのアップデートを許容(ユーザ新規登録時はhas_secure_passwordが検証する)
end
