import header 
import os
import os.path
import sys
import StringIO


closed_class = ('CD', 'CC', 'DT', 'EX', 'IN', 'LS', 'MD', 'PDT', 'POS', 'PRP',\
					'PRP$', 'RP', 'TO', 'UH', 'WDT', 'WP', 'WP$', 'WRB', 'SYM', '\'\'', '``')

ingored_lemmas = ('%', '$', '%', '<unknown>', '—','.')

delimiters = ('.', '\'', '`', '<', '>', '{', '}', '[', ']', '(', ')', '\\',\
              '?',  ';', ':', '~', '"', '!', '%', '#', '@', '$', '^', '&', \
              '-',  '*', '+', '|', ',', '...', '/')

whitespace = (' ', "\t", "\r", "\n")

def listDirFiles(pathname):
	"""	function which returns the filenames of a directory specified by variable pathname	"""
	

	f_list = os.listdir(pathname)

	f_name = []

	for fname in f_list :
		f_name.append(fname)

	return f_name	
	
	
	
def createPath(path):
	""" create a directory in the path specified by path """
	
	if not os.path.isdir(path):
		os.mkdir(path)
	
	

def openFile(_filename,mode,path):
	""" opens file named by _filename for the specified mode """
	
	# create full file path
	_filename = path + "\\" + _filename

	try:
		# open file stream
		file = open(_filename,mode)
	except IOError:
		# open file exception
		print "Error opening file", _filename
		sys.exit()
	
	# returns open file's descriptor
	return file


def tokenize_line(string):
	"""
	splits string to tokens according to delimiters
	returns token list
	"""
	
	#print string
	tokens = list()
	token = ''
	for char in string:
		
		if char in delimiters:
			
			if token:	# an to mexri twra token DEN einai to keno ''
				tokens.append(token)
			tokens.append(char)
			token = ''
		elif char in whitespace:
			#print 'brika keno'
			
			if token:
				tokens.append(token)
				token = ''
		else:
			token = token + char
			#print ' token = '+token
		
	
	#tokens.append(token) !!!!! edw itan to gamolathos!!!!!!!!!!!!!!!!!!!!!!
	#print 'tokens:',len(tokens)
	return tokens
	
def readFile(_file_obj) :
	""" read lines from the file and split them to tokens
		The function returns the text's list of tokens """
	
	# list for text's tokens
	f_list = []
			  
	while 1:
		# read text line by line
		line = _file_obj.readline();
		if not line: break
		# tokenize each line
		f_list += tokenize_line(line);

		
	return f_list
	
def writeToFile(name,mode,tok_list):
	""" Write file's token list to output file named name """
	
	# open and create output file
	logfile = open(name,mode)
	
	# write every token to ouput file each token to a new line
	for tok in tok_list:
		logfile.write(str(tok) + '\n')
	
	# close file
	logfile.close()
	
	
	
def remove_stopWords(fd) :
	"""  remove stop words,unknown lemmas and puncuation points from file specified by fd """
	
	f_NonTerm = []
	
	for line in fd:
		
		# etsi xwrizw mia tab-separated line
		list = line.rstrip('\n').split('\t')
		
		if not (list[1] in closed_class + delimiters) and not list[2] in ingored_lemmas:
			f_NonTerm.append(list)
		
			
	
	return f_NonTerm
