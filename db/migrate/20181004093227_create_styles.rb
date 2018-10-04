class CreateStyles < ActiveRecord::Migration[5.2]
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    Beer.all.map(&:style).uniq.each{ |s| Style.create(name: s) }
  end
end
