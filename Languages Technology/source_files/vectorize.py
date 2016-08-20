import header
import string
from tokenizing import * 

total_lemmas_out = "total_lemmas.txt"

def init():
	# retrieve filename list
	global tagged_names
	tagged_names = listDirFiles(header._TAGGED_FILES_PATH)

	# create tagged files directory
	global path
	path = header._GLWSSIKI_PATH + header._VECTORED_FILES_PATH
	createPath(path)
	
	
def main():

	init()
	total_lemmas = 0;

	for name in tagged_names:
	
		vec_str = ''
		
		fd = openFile(name,"r",header._TAGGED_FILES_PATH)
		
		vector = list()
		vector = vectorize(fd,name)
		outname = 'vecored_'+name
	
		# write vectorized output file
		# open and create output file
		logfile = open(path+ '\\' + outname,"w")
		
		for i in vector:
			total_lemmas += i['freq']
			vec_str += '%s\t%s\t%d\n' % (i['lemma'], i['pos_tag'], i['freq'])
			
		logfile.write(vec_str)
		logfile.close()
		
		fd.close()
	
	print 'Vectorization of texts has been completed'
	# save number for total lemmas
	fd = open(total_lemmas_out,"w")
	fd.write('Number of total lemmas is: ' + str(total_lemmas))
	fd.close()

	

def vectorize(tagged_file,name):

	# remove stop words,unknown lemmas and punctuation points
	open_lemma_list = remove_stopWords(tagged_file)
	
	# metatropi twn lemmas se peza
	for tok_lemma in open_lemma_list:
		tok_lemma[-1] = tok_lemma[-1].lower()
	
	# the lemmas vector list
	vec_list = list()
	
	# kanoume sort tin lista to tokens me vasi to lemma
	open_lemma_list.sort(lambda x, y: cmp(x[2],y[2]))

	#for i in open_lemma_list:
	#	print i
	
	# ypologismos syxntothtwn emfanisis kai dhmiourgia dictionary
	# prev gia elegxo me prohgumena 
	prev = [None, None, None]
	# apo ena dictionary gia kathe token
	for l in open_lemma_list:
	
		# 0: token, 1: PoS tag, 2: lemma
		if l[2] == prev[2]:
			vec_list[-1]['freq'] += 1
		else:
			d = dict()
			d['lemma'] = l[2]
			d['pos_tag'] = l[1]
			d['freq'] = 1    	
			vec_list.append(d)
		prev = l
		
	#print 'Found '+ str(len(vec_list)) +' lemmas for file ' +name
	
	return vec_list

	
	
if __name__ == "__main__":
	main()
