class AddUidToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :uid, :string
  end
end
