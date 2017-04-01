class AddContactInfoOnAdvert < ActiveRecord::Migration[5.0]
  def change
    change_table(:adverts) do |t|
      t.text :phone
      t.text  :email
      t.text  :address
    end
  end
end
