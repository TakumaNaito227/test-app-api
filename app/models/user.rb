require "validators/email_validator"

class User < ApplicationRecord
  before_validation :downcase_email

  # gem 'bcrypt'
  has_secure_password
  # validates
  validates :name, presence: true, # 入力必須
                   length: { # 文字数
                     maximum: 30, # 最大文字数
                     allow_blank: true, # Null, 空白文字の場合スキップ
                   }

  validates :email, presence: true,
                    email: { allow_blank: true }

  validates :password, presence: true, # 入力必須
                       length: { minimum: 8, allow_blank: true }, # 最小文字数
                       format: {
                         with: /\A[\w\-]+\z/, # 正規表現チェック
                         message: :invalid_password,
                         allow_blank: true,
                       },
                       allow_nil: true # 空パスワードのアップデートを許容(ユーザ新規登録時はhas_secure_passwordが検証する)
  ## methods
  class << self
    # emailからアクティブなユーザーを返す
    def find_by_activated(email)
      find_by(email: email, activated: true)
    end
  end

  # 自分以外の同じemailのアクティブなユーザーがいる場合にtrueを返す
  def email_activated?
    users = User.where.not(id: id)
    users.find_by_activated(email).present?
  end

  private

    # email小文字化
    def downcase_email
      self.email.downcase! if email
    end
end
