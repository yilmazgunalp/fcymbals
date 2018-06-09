namespace :solr do 

    desc "downloads all makers from production and indexes them to solr"

     task :index, [:file]  do |task,args|

     
    file_name = "#{Rails.root}/tmp/#{args.file}.csv"
    puts "Importing records from production to local csv file"
    system "psql #{ENV["AWS"]} -c \"\\copy (select id,brand,series,model,kind,size,description from makers) to \'#{file_name}\' with delimiter as \'|\' csv header ; \""			
    puts "Sending the file to solr for indexing"
system  "curl \'#{ENV['SOLR']}/solr/cymbals/update?commit=true&separator=%7C\' --data-binary @tmp/#{args.file}.csv -H 'Content-type:application/csv'"
     puts "file sent check the result @ #{ENV['SOLR']}"
    end #index 

end


