
import header
from tokenizing import *
from operator import itemgetter

def containment():
	""" find containment of the 5 larger texts """
	
	containments = []

	# tokens directories
	tokenized_path = header._GLWSSIKI_PATH + header._TOK_PATH
	# list of tokenized files
	token_list = listDirFiles(tokenized_path)
	
	
	# full path for shinglez directory
	shinglez_path = header._GLWSSIKI_PATH + 'shingles'
	# create shinglez directory
	createPath(shinglez_path)
	
	# lista me ton arithmo twn tokens kathe keimenu
	docs_words = list()
	
	for tokenized in token_list:
		
		# open token file for read
		f_in = open(tokenized_path+'\\'+tokenized,'r')
		# ouput file
		f_out = open(shinglez_path+'\\'+'shinglezed_'+tokenized,'w')
		
		lines = f_in.readlines()
		tokz = fix_lines(lines)	

		# create 2-shingles for each tokenized file
		two_shingler(tokz,f_in,f_out)

		# find file's number of words
		cnt = len(tokz)
		docs_words.append((tokenized,cnt))
	print 'shingler done'
	
	
	# find five larger texts
	docs_words = sorted(docs_words, key=itemgetter(1), reverse=True)
	L = docs_words[:5]
	
	# gia kathe ena apo ta 5 megalitera arxeia
	for i in range(len(L)):
		
		# 2-shingles list of current text
		A = []
		# 2-shignles list for the rest of 4 texts
		A_coll = []
		
		# anoigma tu shingle arxeiou
		shin_fname = shinglez_path +'\\'+'shinglezed_'+L[i][0]
		sf = open(shin_fname,'r');
		# lista me ta shingles tu arxeiou
		A = sf.readlines()
		
		for j in range(len(L)):
			if i!=j:
				other_shingle = shinglez_path +'\\'+'shinglezed_'+L[j][0]
				f = open(other_shingle,'r');	
				f_lines = f.readlines()
				# append sto sinolo twn shingles tis ypolipis sillogis
				for l in f_lines:
					A_coll.append(l)
				f.close()
		
		# arithmos koinwn shingles sto A, A_coll
		commons = list(set(A) & set(A_coll))
		# print 'commons with: ',shin_fname,':'
		# for i in commons:
			# print i
		
	
		
		cont = len(commons)/(float)(len(A))
		containments.append((L[i][0],cont))
	
	# emfanisi twn containments tu kathe arxeious
	print_containments_results(containments)
	

def print_containments_results(conts):
	""" output containments results """
	
	fout = open("containments.txt",'w')
	s = ''
	for i in conts:
		docid = i[0].split('_')[-1].split('.')[0]
		s += 'id: '+docid+'\t\t'+'containment: '+str((i[1])*100)+'%\n'
	fout.write(s)
	fout.close()
		
def two_shingler(tokz,f_in,f_out):
	""" make the 2-shignles file for input file from tokens """
	
	for i in range(len(tokz)):
			
		shingles_str = tokz[i]
		if ((i+1)<len(tokz)):
			shingles_str = shingles_str+'\t'+tokz[i+1]
		
			
		f_out.write(shingles_str.lower())
		f_out.write('\n')
		
	f_in.close()
	f_out.close()

	
	
def fix_lines(lines):
	""" remove \n and make lower each token """
	
	tokz = []
	for line in lines:
		line = line.rstrip('\n').rstrip('\r').lower()
		tokz.append(line)	
	return tokz
	

if __name__ == "__main__":
    containment()
