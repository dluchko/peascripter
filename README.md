Welcome to peascripter 
======================

*Peascripter* is a command manager that allows you run any command strings in defined order, enable and disable strings, create presets and watch running processes in Terminal.

*Peascripter* is a free open source project written in Ruby language using 'Shoes' user interface tool kit. 

*Peascriptor* runs under MacOS. 
*Will be developed for another OS’s in future as well.*

Installation
------------

You can download packaged peascripter.app file from outer source. 

*Another way:

1. You need to have Shoes installed. 
2.	Download ZIP project file. Unarchive.
3.	Open peascripter.rb file via Shoes, or just drag it on Shoes icon. 

Getting started
--------------- 

- Load existed example scenario pressing LOAD button.
- Press RUN button to execute only checked command. 
- Each command can run any process you need.
- You can change any string. Just type inside what you need.
- Save preset pressing SAVE button.
- You can adjust view selecting lines, boxes or fields.
- You can display up to 50 rows. Just click left top counter. 


Writing commands in peascriptor
-------------------------------

Commands running by *peascripter* are *bash* style mostly.
There are some recommendations to compose convenient command sets:

- You can put "#SCRIPT NAME" in first row.
- Type any commands in next rows.
- Put ';' in the end of string to divide separate commands.
- One command can be splitted by rows, but it still will be processed as one command.
- Use ‘#’ to write comments.
- You can check/uncheck each string. Only checked commands will be run.
- Commands will be run in order they are displayed. 


Tips and Tricks
---------------

- It possible to write presets manually in any text redactor just using *YAML* syntax.  Use following array types: “amount” - amount of visible strings in current session, “rows”- rows content, “checked” – checked rows number. First “rows” element is not visible in application. It can be used for scenario author name.
 
- If terminal window doesn’t appear after RUN button was pressed - try RUN one more time to invoke terminal.

