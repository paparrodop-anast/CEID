from time import time
import header
from operator import itemgetter
from sys import stderr, argv, exit
from xml.etree.ElementTree import ElementTree as ET

INDEX_FILE = 'index.xml'
uniq_lemmas_out = 'unique_lemmas.txt'
time_results = 'time_result.txt'

def main(xml_file, queries):
	""" searches for queries in the xml_file inverted index """

	print 'Parsing xml file..'
	tree = xml_tree_parse(xml_file)

	print 'Creating dictionary..'
	my_dict = xmlTOdictionary(tree)

	print 'Start searching queries'
	
	# final results
	results = []
	
	# start timing
	timer_start = time()
	
	for qry in queries:
	
		#we have multiple queries
		if (len(qry.split())>1):
		
			# list of queries items
			items = qry.split()
			
			# list with each query item's result list
			concat_list = [ [] for i in range(len(items)) ]
			
			for i in range(len(items)):
				# result list for each query lemma
				sub_lst = single_qry_handle(items[i],my_dict)
				# add it to concat_list
				concat_list[i] = sub_lst
			
			# proccess concat_list
			new_list = find_common(concat_list,len(items))
			
		else:
			# we have single query
			new_list = single_qry_handle(qry,my_dict)
			

		# select the first 10 items
		new_list = new_list[:10]
		results.append((qry,new_list))
	
	# end timing
	time_elapsed = time() - timer_start
	
	
	fd = open(time_results,"w")
	res = 'Total Search Time: '+str(time_elapsed)+' seconds.\n'
	res += 'Average Search time: '+str(time_elapsed/float(len(queries)))+' seconds.\n'
	fd.write(res)
	fd.close()
	

	# send results to 'results.txt'
	show_results(results)
	print 'See \'final_results.txt\' for search results.'
	

def find_common(extd_list,len):
	""" find common items between the sublists of extd_list """
	
	# hold extd_list first sublist
	result = extd_list[0]
	
	# find commons 
	for i in range(1,len):
		#print 'i is:',i
		result = common(result, extd_list[i])
		
	result = sorted(result, key=itemgetter(1), reverse=True)
	return result

	
	
def common(l,z):

	new_list = list()
	
	for i in range(0,len(l)):
		for j in range(0,len(z)):
			if l[i][0] == z[j][0]:
				new_list.append((l[i][0],l[i][1]+z[j][1]))

	return new_list
	
	

def show_results(rslt):
	""" send results to 'results.txt' """
	
	out_results = 'final_results.txt'
	
	try:
		# open file stream
		file = open(out_results,'w')
	except IOError:
		# open file exception
		print >> stderr, 'error writing to file: %s' % (out_results)
		sys.exit()
		
	for entry in rslt:
		
		file.write(entry[0]+':'+'\n')
		
		for item in entry[1]:
			file.write('\t doc_id: '+str(item[0])+'\t'+' weight: '+str(item[1])+'\n')
	
		file.write('\n')

	file.close()
	
def single_qry_handle(query,index):
	""" handle a single query """
	
	# list for query results
	ql = list()
	ql_sorted = list()
	
	# if query exists in index
	if query in index:
		dict = index[query]
		# find its records
		for i in dict:
			ql.append((i,dict[i]))
		# and sort them according to weight
		ql_sorted = sorted(ql, key=itemgetter(1), reverse=True)
	
	# return query's sorted result list
	return ql_sorted

	

def xmlTOdictionary(tree):
	""" create a dictionary from xml """
	
	dict = {}
	# find all lemma tags
	lemmas = tree.findall('lemma')
	
	fd = open(uniq_lemmas_out,"w")
	fd.write('Number of unique lemmas is: ' + str(len(lemmas)))
	fd.close()
	
	
	for l in lemmas:
		# hold its lemma name
		dict[l.get('name')] = {}
		childs = l.getchildren()
		# populate its lemma with its corresponding pair {doc_id, weight}
		for ch in childs:
			dict[l.get('name')][ch.get('id')] = float(ch.get('weight'))
	
	return dict 

	
	
def xml_tree_parse(xml_file):
	""" load xml index in memory """
	
	# load and parse xml using ElementTree
	try:
		tree = ET()
		tree.parse(xml_file)
	except Exception, inst:
		print >> stderr, 'error opening file: %s' % (xml_file)
		return

	return tree
	
	
def show_dict(dict):
	""" utility function to print the dictionary """
	
	for entry in dict:
		print entry, dict[entry]
	
	
	
if __name__ == "__main__":
	queries = list()
	
	if len(argv) >= 3 and argv[1] == '-f':
		try:
			f = open(argv[2], 'r')
		except IOError, e:
			print >> stderr, 'can\'t open queries file:',e
			exit(1)

		for line in f:
			queries.append(line.rstrip('\n').rstrip('\r'))
		f.close()
	else:
		print >> stderr, 'provide a file with -f flag'
		exit(1)

	exit(not main(INDEX_FILE, queries))
