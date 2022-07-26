class Post < ApplicationRecord
    mount_uploader :image, ImageUploader
    belongs_to :user
    #postsテーブルから中間テーブルに対する関連付け
    has_many :post_tag_relations, dependent: :destroy
    #postsテーブルから中間テーブルを介してTagsテーブルへの関連付け
    has_many :tags, through: :post_tag_relations, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :liked_users, through: :likes, source: :user

    # postsテーブルと
    scope :search, -> (search_params) do      #scopeでsearchメソッドを定義。(search_params)は引数
        return if search_params.blank?      #検索フォームに値がなければ以下の手順は行わない
    
        family_like(search_params[:family])
          .size_like(search_params[:size])
          .price_like(search_params[:price])
          .cost_like(search_params[:m_cost])   #下記で定義しているscopeメソッドの呼び出し。「.」で繋げている
          .time_like(search_params[:m_time])
    end

    scope :family_like, -> (var_family) { where('family LIKE ?', "%#{var_family}%") if var_family.present? }  #scopeを定義。
    scope :size_like, -> (var_size) { where('size LIKE ?', "%#{var_size}%") if var_size.present? }
    scope :price_like, -> (var_price) { where('price LIKE ?', "%#{var_price}%") if var_price.present? }
    #日付の範囲検索をするため、fromとtoをつけている
    scope :cost_like, -> (var_cost) { where('m_cost LIKE ?', "%#{var_cost}%") if var_cost.present? }
    #scope :メソッド名 -> (引数) { SQL文 }
    scope :time_like, -> (var_time) { where('m_time LIKE ?', "%#{var_time}%") if var_time.present? }
end
