module Findmatch

class << self
def setup(model,search_tree)
Dir.chdir(__dir__)	
Dir.mkdir(model)
Dir.chdir(__dir__)
file = File.open("#{Dir.getwd}/#{model}/#{model}_search_tree.yml","w")
search_tree.inject(file) {|f,e| f.write(e.to_yaml)}
file.flush
end #initialize() 

	class Record


	end #class Record	















end #class self

end #module findmatch	