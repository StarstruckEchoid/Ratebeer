class AddConfirmedToMembership < ActiveRecord::Migration[5.2]
  def up
    add_column :memberships, :confirmed, :boolean, :default => false
    Membership.reset_column_information
    Membership.update_all(confirmed: true)
  end

  def down
    remove_column :memberships, :confirmed
  end
end
