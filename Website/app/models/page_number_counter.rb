class PageNumberCounter < ActiveRecord::Base
  
  def PageNumberCounter.count(path)
    counter = PageNumberCounter.where(:path=>path).take
    counter = PageNumberCounter.new(:path=>path,:times=>0) if counter == nil
    counter.increment!(:times)
    PageNumberCounter.update_all(:times=>0) if counter.times > 1e8
  end
  
end
