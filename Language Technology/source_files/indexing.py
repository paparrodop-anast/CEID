from header import *
import string
from tokenizing import * 
from math import log
from math import sqrt

theIndex = {}

tot_lemmas_out = "total_lemmas.txt";

def main():
	
	path = header._GLWSSIKI_PATH + header._VECTORED_FILES_PATH
	vectorized = listDirFiles(path)
	total = 0;
	docs_cnt = len(vectorized)
	
	
	# ypologismos sum of frequencies of each text TODO synartisi
	for entry in vectorized:
		# hold doc id
		docid = entry.split('_')[-1].split('.')[0]
		fd = openFile(entry,"r",path)
		
		
		sum = 0;
		for line in fd:
			# lemma \t PosTag \t Freq
			l = line.rstrip('\n').split('\t')
			sum += int(l[2])
		theIndex[docid] = float(sum)
	
	
	
	# create inverted index with documen id's and frequencies
	inv_index = inverted_index(vectorized, path)
	
	# calculate weights for each lemma
	w_inv_index = tf_idf_metric(inv_index,docs_cnt)
	
	# make xml file
	make_index_xml(w_inv_index,index_file)
	
	
	
def inverted_index(vector_texts, path):
	""" Make inverted index with the above format
		<lemma, {<docid1,freq1><docid2,freq2>...}>
	"""
	
	# store index in a dictionary
	index = dict()
	
	# for every vectorized text
	for vec_file in vector_texts:
	
		# to id tu kathe arxeiou
		docid = vec_file.split('_')[-1].split('.')[0]
		# anoigma tu arxeiou
		fd = openFile(vec_file,"r",path)
	
		# read each line in the vectorized file
		for line in fd:
			# lemma \t PosTag \t Freq
			list = line.rstrip('\n').split('\t')
			key = list[0]
			# pair holding document id and frequency
			# the third value is lemma's weight, initially 0.0
			pair = [docid, list[2],0.0]
			
			# if key already in index
			if key in index:
				# append the pair into key's list
				index[key].append(pair)
			else:
				# otherwise add a new key and its pair
				index[key] = [pair]
	
	return index

	
def tf_idf_metric(index,docs_cnt):
	
	""" Calculate TF-IDF """
	
	# diatrexume to index mas gia kathe lemma
	for lemma in index:
	
		# lemma_count: arithmos keimenwn pou periexun to lemma
		l_c = len(index[lemma])
		
		for l in index[lemma]:
			#l[0] holds doc id
			#l[1] holds lemma freq in document id
			#l[2] holds lemma weight in text
			
			# sum of lemmas of a text
			sum = theIndex[l[0]]
			
			# syxnotita emfanisis limatos sto keimeno tou
			tf = float(l[1])/sum
			l[2] = tf * log(float(docs_cnt)/l_c, 10)

	# find sum of weights and normalize all
	w_sum = 0;
	for lemma in index:
		for i in index[lemma]:
			w_sum+=i[2]**2
			
	# normalization with the square root of w_sum
	for lemma in index:
		for doc in index[lemma]:
			doc[2] = float(doc[2]) / float(sqrt(w_sum))
	
	return index


def make_index_xml(index, index_file):
	""" write index to XML file """

	try:
		f = open(index_file, 'w')
	except IOError, e:
		print >> stderr, 'write xml', e
		return False

	# make XML string and write to file every 1000 characters
	xml = '<inverted_index>\n'
	for lemma in index:
		xml += '\t<lemma name="' + lemma + '">\n'
		for doc in index[lemma]:
			xml += '\t\t<document id="' + doc[0] + '" weight="' + str(doc[2]) +'"/>\n'
		xml = xml + '\t</lemma>\n'
		# den grafume olokliro to arxeio mono mias logw megethus
		# xrisi kati san buffer
		if len(xml) > 10000:
			f.write(xml)
			xml = ''
			
	xml = xml + '</inverted_index>'
	f.write(xml)
	f.close()

	return True


def show_inv_index(index):
	""" utility function to print inverted index """
	
	for i in index:
		print i,index[i]
		
		

if __name__ == "__main__":
	main()
