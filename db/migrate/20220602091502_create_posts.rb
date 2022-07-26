class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :family
      t.string :name
      t.string :size
      t.string :price
      t.string :m_time
      t.string :m_cost
      t.text :detail
      t.string :address

      t.timestamps
    end
  end
end
