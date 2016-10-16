import header
from tokenizing import * 

def main():
	# retrieve filename list
	filenames = listDirFiles(header._ART_PATH)

	# create tokenized files directory
	createPath(header._TOK_PATH)

	# list and tokenize every text file in directory
	for name in filenames :
		# opening file
		fd = openFile(name,"r",header._ART_PATH)
		# tokenize text file by reading each line from the file
		# f_tok_list holds each file's tockens
		f_tok_list = readFile(fd)
		# after tokenizing close file
		fd.close()
		

		# write file's token list to corresponding output file
		# first create output file name
		out_name = "out_" + name
		writeToFile(header._TOK_PATH + '\\' + out_name,"w",f_tok_list)

	print 'Successfully Tokenized ' + str(len(filenames)) + ' files'

if __name__ == "__main__":
	main()