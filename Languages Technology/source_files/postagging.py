from header import *
from tokenizing import *
import io


def init():
	# retrieve tokenized filenames list
	global tok_filenames
	path = header._GLWSSIKI_PATH + header._TOK_PATH
	tok_filenames = listDirFiles(path)

	# check if tokenized articles list is empty
	if not tok_filenames:
		print 'Articles are not tokenized. Execute vima_1.py to tokenize articles first!'
		return None
	
	# create tagged files directory
	path = header._GLWSSIKI_PATH + header._TAGGED_FILES_PATH
	createPath(path)
	

def main():

	# initialize filenames list and tagger outpath
	init()
	
	#list and tokenize every text file in directory
	for name in tok_filenames :

		# command for tree-tagger
		cmd = "tree-tagger.exe -quiet -token -lemma english.par "

		#opening file
		fd = openFile(name,"r",header._TOK_PATH)
	
		input_fname = header._TOK_PATH + "\\" + name
		output_fname = header._TAGGED_FILES_PATH + "\\" + "Tagged_" + name
	
		# add input/output filenames to tree-tagger command
		cmd += input_fname + " " + output_fname

		# execute tree-tagger for the specified file 
		os.system(cmd)
	
		fd.close()

if __name__ == "__main__":
	main()
