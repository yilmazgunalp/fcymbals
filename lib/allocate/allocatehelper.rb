module Allocatehelper  
  def amend_text(text,mtch,suffix)
    text.sub!(mtch,"token_#{suffix}")
  end #amend_text 
	
  def expand(ary,prefix)
      ary.inject([]) { |m,e| m << prefix +" "+e }
  end #expand

  def expanse(ary1,ary2)
    results = []
    ary1.each do |e|
      results += expand(ary2,e)
    end
    results
  end  #expanse

  def explode(ary_of_arrays)
    return ary_of_arrays[0] if ary_of_arrays.length == 1
    enum = ary_of_arrays.each 
    results = expanse(enum.next,enum.next) 
    while true 
    results = expanse(results,enum.next)
    end  
    rescue StopIteration
    results
  end  #explode

end  