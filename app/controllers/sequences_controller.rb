class SequencesController < ApplicationController

  def new
    @sequence  = Sequence.new
    @sequences = Sequence.all.order(id: :desc)
  end

  def create
    sequence = Sequence.new(start_terms: params[:sequence][:start_terms])
    terms    = params[:sequence][:start_terms].split(',')
    sequence.classify_sequence
    if sequence.type == "arithmetic"
      sequence.rule     = get_a_sequence_rule(terms)
      # sequence.nth_term = get_a_7th_term(sequence.start_terms)
      sequence.nth_term = get_a_quad_7th_term(sequence.rule[6..-1])
    else
      sequence.rule     = get_g_sequence_rule(sequence.start_terms)
      sequence.nth_term = get_g_7th_term(sequence.start_terms)
    end
    if sequence.save
      flash[:notice] = 'Sequence analysed. See Results below'
    else
      flash[:alert] = 'Something went wrong with sequence processing.'
    end
    redirect_to new_sequence_path
  end
  
  def destroy
    @sequence = Sequence.find(params[:id])
    @sequence.destroy
    flash[:notice] = 'Destroyed Sequence'
    redirect_to new_sequence_path
  end

  private

  def get_a_sequence_rule(sequence)
    diffs  = []
    sequence.each_with_index{|s, index|
      next if index == 0
      diffs.append(s.to_i - sequence[index-1].to_i)
    }
    tempd = []
    diffs.each{|d| tempd.append(d)}
    tempd.delete(tempd.first)

    if !tempd.empty?
      diffs_lower = []
      diffs.each_with_index {|d, index|
        next if index == 0
        diffs_lower.append(d - diffs[index-1])
      }
      a = diffs_lower.first.to_f/2
      b = diffs.first.to_f - (3*a)
      c = sequence.first.to_i - b.to_i - a.to_i
      ans = ["T_n = #{a}*n^2", "#{b}*n", "#{c}" ]
      ans.each{|a| a.prepend('+') if a.first != '-' && a.first != 'T' }
      ans.join('')
    else
      return "T_n = #{diffs.first.to_i}( n - 1 )"
    end
  end

  def get_a_7th_term(start_terms)
    terms = start_terms.split(',')
    forst = terms.first.to_i
    cnt = 1
    until cnt >= 7
      forst += (terms.second.to_i - terms.first.to_i)
      cnt   += 1
    end
    forst
  end

  def get_a_quad_7th_term(sequence)
    sequence["n"] = "7"
    sequence["^"] = "**"
    
    # sequence.sub("n","7")
    return instance_eval sequence
  end

  def get_g_rate(terms)
    diffs = []
    terms.second.to_f/terms.first.to_f
  end

  def get_g_sequence_rule(start_terms)
    rate = get_g_rate(start_terms.split(','))
    t0   = start_terms.split(',').first
    rule = "T_n = T_o x [#{rate}^(n-1)]"
    rule
  end

  def get_g_7th_term(start_terms)
    rate  = get_g_rate(start_terms.split(','))
    forst = start_terms.first
    ans = 1
    cnt = 1
    until cnt >= 7
      ans *= rate
      cnt += 1
    end
    seventh = ans.to_i*forst.to_i
    seventh
  end
end
