require 'csv'
class Student < ActiveRecord::Base
    
  def self.to_csv(fields = column_names, options={})
    CSV.generate(options) do |csv|
      csv << fields
      all.each do |student|
        csv << student.attributes.values_at(*fields)
      end
    end
  end
end
