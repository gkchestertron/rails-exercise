Sequel.migration do 
  change do

    create_table :stats do |t|
      primary_key :id
      String :url
      String :referrer, default: nil
      Datetime :created_at, null: false
      String :hash

      index :url
      index :referrer
      index :created_at
      index :hash
    end

  end
end
