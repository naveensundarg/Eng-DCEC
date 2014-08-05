import time
import os
import re
from bisect import bisect_left


def binary_search(a, x, lo=0, hi=None):   												#can't use a to specify default for hi
    hi = hi if hi is not None else len(a) # hi defaults to len(a)   
    pos = bisect_left(a,x,lo,hi)          # find insertion position
    return (pos if pos != hi and a[pos] == x else -1) # don't walk off the end
def make_GF_corpus() :																	#Does not support colons on same line as GF comments but before comment begins
	f = open("./EngExt_o.gf", "r")

	
	agents = []
	intransitive_verbs = []
	transitive_verbs = [] 
	adjectives = []
	nouns = []
	illegals = ["won't", "will", "weren't", "were", "wasn't", "was", "isn't", "is", "have", "has", "had", "don't", "doesn't", "do", "didn't", "did", "aren't", "are", "am", "that", "then", "for", "to", "the", "yourself", "a", "an", "now", "eventually", "and", "or", "if", "Cogito", "he", "I", "it", "Jack", "N", "Robot", "S", "she", "why", "x", "y", "you", "z", "lin", "abstract", "oper", "open", "fun", "resource", "of"]

	for line in f :
		pattern = r'"([A-Za-z0-9_\./\\-]*)"'											#match all strings WITHOUT spaces between quotes
		m = re.findall(pattern, line)
		if m :
			if line.find("mkPN ") >= 0 :												#match agents
				for i in m :
					agents.append(i)
			elif line.find("(unaryAction (mkV") >= 0 :									#match unaryActions i.e. intransitive verbs
				for i in m :
					if len(m) == 1 :													#if verb is regular, push back past tense too
						if i[len(i)-1] == "e" : 										#if last letter is e
							intransitive_verbs.append(str(i +"d") )
						else :
							intransitive_verbs.append(str(i +"ed") )
					intransitive_verbs.append(i)
			elif line.find("(binaryAction (mkV") >= 0 :									#match binaryActions i.e. transitive verbs
				for i in m :
					if len(m) == 1 :													#if verb is regular push back past tense too
						if i[len(i)-1] == "e" : 										#if last letter is e
							transitive_verbs.append(str(i +"d") )
						else :
							transitive_verbs.append(str(i +"ed") )
					transitive_verbs.append(i)
			elif line.find("(mkAP (mkA ") >= 0 : 										#match unaryFluents i.e. adjectives
				for i in m :
					adjectives.append(i)
			elif line.find("indef = (mkN ") >= 0 :										#match direct objecys i.e nouns
				for i in m :
					nouns.append(i)
			else :
				pass

	intransitive_verbs = list(set(list(intransitive_verbs)))							#remove duplicates from verbs
	transitive_verbs = list(set(list(transitive_verbs)))

	return [agents,intransitive_verbs,transitive_verbs,adjectives,nouns,illegals]
def sort_and_lower_GF_corpus(GF_corpus) :												#Sort corpus alphabetically and lowercase all words
	#sort GF_corpus
	GF_corpus[0] = sorted(GF_corpus[0], key=lambda s: s.lower())
	GF_corpus[1] = sorted(GF_corpus[1], key=lambda s: s.lower())
	GF_corpus[2] = sorted(GF_corpus[2], key=lambda s: s.lower())
	GF_corpus[3] = sorted(GF_corpus[3], key=lambda s: s.lower())
	GF_corpus[4] = sorted(GF_corpus[4], key=lambda s: s.lower())
	GF_corpus[5] = sorted(GF_corpus[5], key=lambda s: s.lower())

	for c in range(0,len(GF_corpus)) :
		temp = [x.lower() for x in GF_corpus[c]]
		GF_corpus[c] = temp
	return GF_corpus
def search_GF_corpus(GF_corpus, search_label) :											#if search_labelis in GF_corpus
	illegals = binary_search(GF_corpus[5], search_label)
	if illegals >= 0 :
		return True
	agents = binary_search(GF_corpus[0], search_label)
	if agents >= 0 :
		return True
	intransitive_verbs = binary_search(GF_corpus[1], search_label)
	if intransitive_verbs >= 0 :
		return True
	transitive_verbs = binary_search(GF_corpus[2], search_label)
	if transitive_verbs >= 0 :
		return True
	adjectives = binary_search(GF_corpus[3], search_label)
	if adjectives >= 0 :
		return True
	nouns = binary_search(GF_corpus[4], search_label)
	if nouns >= 0 :
		return True
	return False

def input_generator(f, newline) :														#Generator for grabbing input from input.txt
	buf = ""
	while True:
		while newline in buf :
			pos = buf.index(newline)
			yield buf[:pos]
			buf = buf[pos + len(newline):]
		chunk = f.read(4096)
		if not chunk:
			yield buf
			break
		buf += chunk

def make_lexicon() :																	#Make lexicon from raw POS text files
	lexicon = []
	for file_name in file_names :
		word_list = []
		f = open(file_name, "r")
		word_list.append(file_name)
		for line in f :
			word_list.append(line[0:len(line)-2])
		lexicon.append(word_list)
		f.close()
	return lexicon
def search_lexicon(lexicon, search_label) :												#Search and return all POS text files search_label was found in

	sl = [search_label]																	#create list to hold label and it's found locations
	
	intransitive_verbs = binary_search(lexicon[1], search_label)
	if intransitive_verbs >= 0 :
		sl.append("intransitive_verbs.txt")
	transitive_verbs = binary_search(lexicon[2], search_label)
	if transitive_verbs >= 0 :
		sl.append("transitive_verbs.txt")
	adjectives = binary_search(lexicon[3], search_label)
	if adjectives >= 0 :
		sl.append("adjectives.txt")
	nouns = binary_search(lexicon[4], search_label)
	if nouns >= 0 :
		sl.append("nouns.txt")

	if search_label[len(search_label)-2:len(search_label)] == "ed" :					#try verbs again without past participle if search label ends in ed
		search_label = search_label[0:len(search_label)-2]
		sl[0] = search_label 															#change verb to root in sl

		intransitive_verbs = binary_search(lexicon[1], search_label)
		if intransitive_verbs >= 0 :
			sl.append("intransitive_verbs.txt")
		transitive_verbs = binary_search(lexicon[2], search_label)
		if transitive_verbs >= 0 :
			sl.append("transitive_verbs.txt")

	if search_label[len(search_label)-3:len(search_label)] == "ing" :					#try verbs again without present participle if search label ends in ing
		search_label = search_label[0:len(search_label)-3]
		sl[0] = search_label 															#change verb to root in sl

		intransitive_verbs = binary_search(lexicon[1], search_label)
		if intransitive_verbs >= 0 :
			sl.append("intransitive_verbs.txt")
		transitive_verbs = binary_search(lexicon[2], search_label)
		if transitive_verbs >= 0 :
			sl.append("transitive_verbs.txt")

	search_label = search_label[0].upper() + search_label[1:len(search_label)] + " m"	#try again as a masculine agent 
	agents = binary_search(lexicon[0], search_label)
	if agents >= 0 :
		sl[0] = search_label
		sl.append("agents.txt")

	search_label = search_label[0:len(search_label)-1] + "f"							#try again as a feminine agent
	agents = binary_search(lexicon[0], search_label)
	if agents >= 0 :
		sl[0] = search_label
		sl.append("agents.txt")
	return sl

def make_injection(unmatched_words) :													#Make EngExt and DCECExt strings to inject
	#First search already existing words in the GF files
	for word in range(0,len(unmatched_words)) :
		tup = search_lexicon(lexicon, unmatched_words[word].lower())
		unmatched_words[word] = tup

	ag = []
	iv = []
	tv =[]
	adj = []
	n = []

	#Append matches to part of speech list 
	for word in unmatched_words :
		for i in range(1,len(word)) :
			if word[i] == "agents.txt" :
				ag.append(word[0])
			if word[i] == "intransitive_verbs.txt" :
				iv.append(word[0])
			if word[i] == "transitive_verbs.txt" :
				tv.append(word[0])
			if word[i] == "adjectives.txt" :
				adj.append(word[0])
			if word[i] == "nouns.txt" :
				n.append(word[0])

	#remove last two characters from any matches with space in them
	for i in range(0,len(iv)) :
		if iv[i].find(" ") > 0 :
			iv[i] = iv[i][0:len(iv[i])-2]
	for i in range(0,len(tv)) :
		if tv[i].find(" ") > 0 :
			tv[i] = tv[i][0:len(tv[i])-2]
	for i in range(0,len(adj)) :
		if adj[i].find(" ") > 0 :
			adj[i] = adj[i][0:len(adj[i])-2]
	for i in range(0,len(n)) :
		if n[i].find(" ") > 0 :
			n[i] = n[i][0:len(n[i])-2]
	return [ag,iv,tv,adj,n]
def make_EngExt_linearizations(injections) :											#Make linearizations for EngExt.gf
	EngExt_injection = ""

	for i in range(0,len(injections[0])) :												#AGENTS
		lin = ""
		if injections[0][i][len(injections[0][i])-1] == "m" :
			injections[0][i] = injections[0][i][0:len(injections[0][i])-2]
			lin = "   " + injections[0][i] + '_0  = {descr = (mkNP (mkN human (mkN "named ' + injections[0][i] + '"))); name = (mkNP (mkPN "' + injections[0][i] + '")) ; gender= masculine} ;'
		else :
			injections[0][i] = injections[0][i][0:len(injections[0][i])-2]
			lin = "   " + injections[0][i] + '_0  = {descr = (mkNP (mkN human (mkN "named ' + injections[0][i] + '"))); name = (mkNP (mkPN "' + injections[0][i] + '")) ; gender= feminine} ;'
		EngExt_injection += lin
	for i in range(0,len(injections[1])) :												#INTRANSITIVE VERBS
		lin = "   "  + injections[1][i] + '_1 = (unaryAction (mkV "' + injections[1][i] + '"));'
		lin2 = "   "  + injections[1][i] + '_1f agent= (activityFluent agent (mkV "' + injections[1][i][0:len(injections[1][i])] + '"));'
		EngExt_injection+=lin
		EngExt_injection+=lin2
	for i in range(0,len(injections[2])) :												#TRANSITIVE VERBS
		lin = "   "  + injections[2][i] + '_2 a= (binaryAction (mkV "' + injections[2][i] + '") a);'
		lin2 = "   "  + injections[2][i] + '_2o obj= (binaryAction (mkV "' + injections[2][i] + '") obj);'
		EngExt_injection+=lin
		EngExt_injection+=lin2
	for i in range(0,len(injections[3])) :												#ADJECTIVES
		lin = "    " + injections[3][i] + '_3 agent = (unaryFluent agent  (mkAP (mkA "'+ injections[3][i] + '"))) ;' 
		EngExt_injection+=lin
	for i in range(0,len(injections[4])) :												#NOUNS
		lin = "    " + injections[4][i] + '_4 = {name = (mkN "'+ injections[4][i] +'"); indef = (mkN "a '+ injections[4][i] +'")};' 
		EngExt_injection+=lin
	return EngExt_injection
def inject_linearizations(lin_string) :													#Inject linearizations into EngExt.gf
	f = open("EngExt_o.gf", "r")
	f2 = open("EngExt.gf", "w")
	flag = False
	for line in f :
		f2.write(line)
		if flag == True :
			f2.write(lin_string)
			lin_string=""
			flag = False
		if line.find("lin") >= 0 :
			flag = True
	f.close()
	f2.close()	

def make_DCEC_labels(injections) :														#Make labels to be injected into DCECExt.gf
	agents = ""
	intransitive_verbs = ""
	transitive_verbs = ""
	adjectives = ""
	nouns = ""

	transitive_copy = ""
	intransitive_copy = ""

	#Program adds all matches it finds of word; _flags added to labels to avoid naming collisions
	for label in range(0,len(injections[0])) :		
		agents += injections[0][label]+"_0, "
	for label in range(0,len(injections[1])) :
		intransitive_verbs += injections[1][label]+"_1, "
		intransitive_copy += injections[1][label]+"_1f, "
	for label in range(0,len(injections[2])) :
		transitive_verbs += injections[2][label]+"_2, "
		transitive_copy += injections[2][label]+"_2o, "
	for label in range(0,len(injections[3])) :
		adjectives += injections[3][label]+"_3, "
	for label in range(0,len(injections[4])) :
		nouns += injections[4][label]+"_4, "

	#trim last comma and space
	agents = agents[0:len(agents)-2]
	intransitive_verbs = intransitive_verbs[0:len(intransitive_verbs)-2]
	transitive_verbs = transitive_verbs[0:len(transitive_verbs)-2]
	intransitive_copy = intransitive_copy[0:len(intransitive_copy)-2]
	transitive_copy = transitive_copy[0:len(transitive_copy)-2]
	adjectives = adjectives[0:len(adjectives)-2]
	nouns = nouns[0:len(nouns)-2]

	#Form labels for part of speech
	if len(agents) > 0 :
		agents += " : Agent ;"
	if len(intransitive_verbs) > 0 :
		intransitive_verbs += " : ActionType ; " + intransitive_copy + " : Agent->Fluent ;"
	if len(transitive_verbs) > 0 :
		transitive_verbs += " : Agent-> ActionType ;" + transitive_copy + " : Object-> ActionType ;"
	if len(adjectives) > 0 :
		adjectives += " : Agent->Fluent ;"
	if len(nouns) > 0 :
		nouns += " : Class ;"

	return agents + " " + intransitive_verbs + " " + transitive_verbs + " " + adjectives + " " + nouns
def inject_labels(label_string) :														#Inject labels into DCECExt.gf
	f = open("DCECExt_o.gf", "r")
	f2 = open("DCECExt.gf", "w")
	flag = False
	for line in f :
		f2.write(line)
		if flag == True :
			f2.write(label_string)
			lin_string=""
			flag = False
		if line.find("fun") >= 0 :
			flag = True
	f.close()
	f2.close()	

file_names = ["agents.txt","intransitive_verbs.txt","transitive_verbs.txt","adjectives.txt","nouns.txt"]

if not os.path.isfile("./DCECExt_o.gf") :
	print "DCECExt_o.gf not found, terminating"
	exit(1)
if not os.path.isfile("./EngExt_o.gf") :
	print "EngExt_o.gf not found, terminating"
	exit(1)
if not os.path.isfile("./input.txt") :
	print 'Input file "input.txt" not found, terminating'
	exit(1)


GF_corpus = make_GF_corpus()
GF_corpus = sort_and_lower_GF_corpus(GF_corpus)
input_words = []

#Create list of words from input
with open('input.txt') as f:
  for line in input_generator(f, "."):
    sentence = line.strip()
    word_list = sentence.split()
    for word in word_list :
    	input_words.append(word)

unmatched_words = []

#Remove any words already in GF files
for word in input_words :
	if search_GF_corpus(GF_corpus, word.lower()) :
		pass
	else :
		unmatched_words.append(word)

lexicon = make_lexicon()

injection = make_injection(unmatched_words)


EngExt_linearizations = make_EngExt_linearizations(injection)
inject_linearizations(EngExt_linearizations)

DCEC_labels = make_DCEC_labels(injection)
inject_labels(DCEC_labels)
