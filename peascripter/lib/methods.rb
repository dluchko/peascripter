require 'yaml'
#!/usr/bin/env ruby

#Edit lines or boxes generation
def line_generator
  @list.map! do |order_num|         
    flow do
      case           
      when @r1.checked?
        edit_line text=@lines_content[order_num], :width => EDIT_LINE_WIDTH, :height => EDIT_LINE_HEIGHT_1, :left => EDIT_LINE_L_SHIFT do |e|
          e.change {@lines_content[order_num] =e.text} 
        end
      when @r2.checked?
        edit_box text=@lines_content[order_num], :width => EDIT_LINE_WIDTH, :height => EDIT_LINE_HEIGHT_2, :left => EDIT_LINE_L_SHIFT do |e|
          e.change {@lines_content[order_num] =e.text} 
        end
      when @r3.checked?
        edit_box text=@lines_content[order_num], :width => EDIT_LINE_WIDTH, :height => EDIT_LINE_HEIGHT_3, :left => EDIT_LINE_L_SHIFT do |e|
          e.change {@lines_content[order_num] =e.text} 
        end
      end
      para "         "
      @c = check;
      case
       when @load_checks != nil
        @load_checks.include?(order_num) ? @c.checked =true : false    
      end
    end
    check_name=[@c, order_num]
  end          
end

#Edit lines updating 
def line_updater
  @edit_lines.clear do
    @edit_lines=stack do
      @list = (1..@current_list_value.to_i).to_a  
      line_generator
    end
  end
end 


#Retutns the array of checked rows numbers
def checked_rows
  cr = @list.map { |c, order_num| order_num.to_i if c.checked? }.compact
end



