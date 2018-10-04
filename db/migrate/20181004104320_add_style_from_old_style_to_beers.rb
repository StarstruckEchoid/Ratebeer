class AddStyleFromOldStyleToBeers < ActiveRecord::Migration[5.2]
  def up
    Beer.all.each { |b| b.update(style: Style.find_by(name: b.old_style)) }
  end

  def down
    Beer.all.each { |b| b.update(old_style: b.style.name) if b.style }
  end
end
