class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.integer :register_no
      t.integer :maths
      t.integer :science

      t.timestamps
    end
  end
end
