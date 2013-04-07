require 'yaml'
require 'lib/methods'
#!/usr/bin/env ruby

WIN_WIDTH = 700
WIN_HEIGHT  = 415

EDIT_LINE_WIDTH = 470
EDIT_LINE_HEIGHT_1 = 30
EDIT_LINE_HEIGHT_2 = 65
EDIT_LINE_HEIGHT_3 = 420
EDIT_LINE_L_SHIFT = 25


HIST_LIST_WIDTH = 135

IND_LEFT = 70
IND_TOP = 560

GRAY_PANEL_WIDTH = 145
GRAY_PANEL_HEIGHT =460

LOGO_SHIFT_X = -200
LOGO_SHIFT_Y = 200

ROWS_STACK_SHIFT_X = 130
ROWS_STACK_SHIFT_Y = 0
ROWS_STACK_WIDTH = 568


CONTROLS_SHIFT_Y = 15

LIST_BOX_SHIFT_X = 80
LIST_BOX_SHIFT_Y = -53
LIST_BOX_WIDTH = 52

BUTTONS_SET_SHIFT_Y = 20

BUTTON_SHIFT_Y = -25
BUTTON_WIDTH = 143


Shoes.app :width => WIN_WIDTH, 
:height => WIN_HEIGHT, 
:resizable => false, 
:title => "peascriptor" do
  
  #BACKGROUND 
  background white

  image "static/logo.png", :left => LOGO_SHIFT_X, :top => LOGO_SHIFT_Y


  #GRAY PANEL
  image GRAY_PANEL_WIDTH, GRAY_PANEL_HEIGHT, :top => 0 do 

    fill rgb(0, 0, 0, 0.6) 
    strokewidth(0)
    rect 0, 0, GRAY_PANEL_WIDTH, GRAY_PANEL_HEIGHT
  end


  #DEFAULT ROWS
  @default_content = File.open("./etc/opt/default_content", "r") { |f| YAML.load(f.read) }

  @lines_content = @default_content["rows"]

  @current_list_value = @default_content["amount"]

  @value_set = (0..20).to_a << 30 << 40<< 50
  
  #generation of default rows with loaded content
  @edit_lines = stack :displace_left => ROWS_STACK_SHIFT_X, 
  :displace_top => ROWS_STACK_SHIFT_Y,
  :width => ROWS_STACK_WIDTH, 
  :height => WIN_HEIGHT, 
  :scroll => true do
    
    @list = (1..@current_list_value.to_i).to_a  
    
    @list.map! do |order_num| 

      flow do   

        edit_line text=@lines_content[order_num], 
        :width => EDIT_LINE_WIDTH, 
        :height => EDIT_LINE_HEIGHT_1, 
        :left => EDIT_LINE_L_SHIFT do |e| 
          e.change { @lines_content[order_num] = e.text } 
        end

        para "         "
        @c = check;
      end
      [@c, order_num]
    end        
  end


  #RADIOBUTTONS
  inscription " \n"
  para " "; @r1 = radio :edit, :checked => true; inscription "lines\n", :stroke => '#FFFFFF'
  para " "; @r2 = radio :edit; inscription "boxes\n", :stroke => '#FFFFFF'
  para " "; @r3 = radio :edit; inscription "fields\n", :stroke => '#FFFFFF'

  radio_buttons = [@r1, @r2, @r3].each do |rad|

    rad.click { line_updater }
  end
    

  #CONTROLS  
  stack :displace_top => CONTROLS_SHIFT_Y do


    #LIST BOX
    stack :displace_left => LIST_BOX_SHIFT_X, 
    :displace_top => LIST_BOX_SHIFT_Y do   

      @current_list_value = @current_list_value

      @listbox = list_box :items => @value_set, 
      :choose => @current_list_value, 
      :width => LIST_BOX_WIDTH do |content|

        #edit line updating after changing the list value
        @current_list_value = content.text

        line_updater
      end
    end


    #BUTTONS
    stack :displace_top => BUTTONS_SET_SHIFT_Y do
       

      #SAVE BUTTON
      button "SAVE PRESET", 
      :width => BUTTON_WIDTH, 
      :displace_top => BUTTON_SHIFT_Y do 
        
        filename = ask_save_file

        #retutns the array of checked rows numbers
        checked_rows
        
        data = { "amount" => @current_list_value, "rows" => @lines_content, "checked" => checked_rows }

        File.open("#{filename}", "w") { |f| YAML.dump(data, f) } 
      end


      #LOAD BUTTON
      button "LOAD PRESET", 
      :width => BUTTON_WIDTH, 
      :displace_top => BUTTON_SHIFT_Y do

        filename = ask_open_file 

        @loaded_content = File.open("#{filename}", "r") { |f| YAML.load(f.read) }

        @lines_content = @loaded_content["rows"]

        @current_list_value = @loaded_content["amount"] 

        @load_checks = @loaded_content["checked"] 

        @listbox.choose(@current_list_value)

        line_updater
      end


      #RUN BUTTON
      button "RUN", 
      :width => BUTTON_WIDTH do
      
        checked_rows
        
        #joining all checked rows to one common command
        result = checked_rows.sort.keep_if { |a| a <= @current_list_value }

        @scenario = result.map{ |x| @lines_content[x] }.join(" ") 
        
        #opening Terminal under Peas window with tabs and
        #sending command set to terminal 
       %x{ osascript<<APPLESCRIPT
          tell application "Terminal"
            activate
            tell application "System Events"
              tell process "Terminal"
                keystroke "t" using command down
              end tell
            end tell
            do script "#{ @scenario }" in window 1
            set bounds of window 1 to { 350, 570, 1050, 890 }
        end tell
        APPLESCRIPT }
      end
        

      #STOP BUTTON
      button "STOP", 
      :width => BUTTON_WIDTH do  

        %x{ osascript<<APPLESCRIPT 
          tell application "Terminal"
            activate
          end tell
          tell application "System Events"
           tell process "Terminal"
              keystroke "z" using control down
            end tell
          end tell
        APPLESCRIPT } 
      end 
    end
  end
end




