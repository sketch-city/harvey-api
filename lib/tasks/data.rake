namespace :data do
  desc "Calculate Shelter and Needs values"
  task :calculate_values => :environment do

    Shelter.find_each do |shelter|
      shelter.calculate_values
      shelter.save
    end

    Need.find_each do |need|
      need.calculate_values
      need.save
    end
  end
end
