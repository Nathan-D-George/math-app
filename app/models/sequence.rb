class Sequence < ApplicationRecord
  enum type: %i[arithmetic geometric]

  def classify_sequence
    terms = self.start_terms.split(',')
    geometric?(terms) ? self.type = "geometric" : self.type = "arithmetic"
  end

  private
  
  def geometric?(terms)
    diffs = []
    terms.each_with_index{|term, index|
      next if index == 0
      diffs.append(term.to_f/terms[index-1].to_f)
    }
    diffs.delete(diffs.first)
    diffs.empty? ? true : false
  end
end
