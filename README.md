# Sample-LISP-codes
Some examples of common LISP codes
This short snippet dictates how you can load .lsp files into AutoCAD for use and the instructions on how to use the sample attached LISP files.

In order to load the attached files into AutoCAD, you can do one of two things:

1.	Simply drag and drop the attached .lsp files into an active AutoCAD drawing, and you will be able to start using the commands, or;
2.	Initiate the APPLOAD command, and load the .lsp files from there (recommended)

You may be prompted with a dialog of whether you’d like to load this LISP file. If this does show up, click on “Load Once” (or you can click “Always Load” so that the same dialog doesn’t show up the next time you load this program).

They may be .lsp files, but you can open them using notepad to view the step-by-step instructions that I’ve included in the .lsp files. Feel free to have a read there too. Otherwise, the instructions starting next page will do just as good.
 
PrefixSuffixText.lsp
This LISP program allows the user to add a common prefix and suffix to a selected group of texts and mtexts. The user can start the command after loading this LISP code with the steps above by typing PRESUF into the command line.

1.	Select a group of texts by doing a window or crossing selection.
a.	Even if you do cloud other objects such as block, lines, etc., this LISP program will only filter in texts and mtexts.
2.	Enter some text that you’d like to add as prefix.
3.	Enter some text that you’d like to add as suffix.
4.	Upon pressing Enter, the selected texts will now have the same prefix and suffix.

TotalMLine.lsp
This command gives a takeoff length of multilines drawn at different multiline scales. The length of each multiline will be summed up together and segregated based on multiline size. The user can start the command (again, after loading the program) by typing TML into the command line.

1.	Select a group of multilines by doing a window or crossing selection just like the PrefixSuffixText.lsp program.
2.	Click a point somewhere and then an mtext will reveal the details of the total lengths for the multilines for each size.
