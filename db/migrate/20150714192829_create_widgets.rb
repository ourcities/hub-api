class CreateWidgets < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :widgets do |t|
      t.integer :block_id
      t.integer :size
      t.text :settings
      t.string :kind

      t.timestamps null: false
    end
  end
end
