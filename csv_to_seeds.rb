csv_file = File.open('Actualize.Social Models Tables - User.csv', 'r')

data_array = []

csv_file.each do |row|
  data_array << row.split(",")
end

@header_row = []
@header_index = nil
@write = false

def find_header(array)
  array.each_index do |index|
    if array[index][0] == "integer"
      @header_row = array[index - 1]
      @header_index = index - 1
      @write = true
    end
  end
end

###

find_header(data_array)

# p @header_row
# p data_array[@header_index + 2]

data_hash = []

index = 0
data_array.each do |row|
  temp_hash = {}
  row.each_index do |col|
    temp_hash[@header_row[col]] = row[col]    
  end
  data_hash << temp_hash
  index += 1
end
# data_hash[@header_row[0]] = data_array[@header_index + 2][0]

data_hash.shift(@header_index + 2)

seeds = "User.create(["

data_hash.each_index do |hash|
  seeds += "
    {
      first_name: \"#{data_hash[hash]["First Name"]}\"
      last_name: \"#{data_hash[hash]["Last Name"]}\"
      email: \"#{data_hash[hash]["Email"]}\"
      password: \"password\"
      post_cohort_employer: \"#{data_hash[hash]["Post-Cohort Employer"]}\"
      cohort_id: \"#{data_hash[hash]["cohort_id"]}\"
    }
  "
end

seeds += "])"

seeds_file = File.new('seeds.rb', 'w+')

seeds_file.write(seeds)
