class CreateAdverts < ActiveRecord::Migration[5.0]
  def change
    create_table :adverts do |t|
      t.text  :title
      t.text  :image_url
      t.text  :advert_body
      
      t.timestamps null: false
    end
  end
end
