import os
import re

#Find index number of where to append in DCECExt.txt
def findDCECExtLoc(string) :	
	f = open("DCECExt_o.gf", "r")
	count = 0
	s_index = 0
	copy = ""
	for line in f :
		copy +=line
		ind = line.find(string)
		if ind >= 0 :
			s_index = count + ind + len(string)
		count+=len(line)
	return (s_index, copy)
def findDCECExtLoc2(string, use_copy) :	
	f = use_copy
	ind = f.find(string)
	return (ind, use_copy)
#find index number of where to append in EngExt.txt
def findEngExtLoc(string) :
	f = open("EngExt_o.gf", "r")
	count = 0
	s_index = 0
	copy = ""
	for line in f :
		copy +=line
		ind = line.find(string)
		if ind >= 0 :
			s_index = count + ind + len(string)
		count+=len(line)
	return (s_index, copy)
def findEngExtLoc2(string, use_copy) :
	f = use_copy
	ind = f.find(string)
	return (ind,use_copy)


def agentAppend(f) :
	agentDCECExtAppend(f)
	agentEngExtAppend(f)
def agentDCECExtAppend(f) :
	tup = findDCECExtLoc("jack, cogito,")
	copy = str(tup[1])
	append_line = ""


	append_line=f

	append_line = append_line.replace(" m,", ",")
	append_line = append_line.replace(" f,", ",")

	new_copy = ""
	for i in range(0,tup[0]) : 
		new_copy+=copy[i]

	new_copy+= " "
	new_copy+=append_line
	new_copy+= " "

	for i in range (tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	f2 = open("DCECExt.gf", "w")
	f2.write(new_copy)
	f2.close()
def agentEngExtAppend(f) :
	tup = findEngExtLoc('name = (mkNP (mkPN "Jack")) ; gender= masculine} ;')
	copy = tup[1]
	append_line = ""

	append_line=f

	new_copy = ""
	for i in range(0,tup[0]) :
		new_copy+=copy[i]


	temp = ""
	pairs = []
	for i in range(0,len(append_line)) :
		if append_line[i] != "," :
			temp+=append_line[i]
		else:
			pairs.append(temp)
			temp = ""

	append_list = []
	for p in pairs :
		p=p.lstrip(" ")
		if p[len(p)-1] == "m" :
			p = p[0:len(p)-2]
			s = "   " + p + '  = {descr = (mkNP (mkN human (mkN "named ' + p + '"))); name = (mkNP (mkPN "' + p + '")) ; gender= masculine} ;'
			append_list.append(s)
		else :
			p = p[0:len(p)-2]
			s = "   " + p + '  = {descr = (mkNP (mkN human (mkN "named ' + p + '"))); name = (mkNP (mkPN "' + p + '")) ; gender= feminine} ;'
			append_list.append(s)


	for i in append_list :
		new_copy+=i

	for i in range(tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	f2 = open("EngExt.gf", "w")
	f2.write(new_copy)
	f2.close()

def unaryActionTypeAppend(f) :
	uActionTypeDCECExtAppend(f)
	uActionTypeEngExtAppend(f)
def uActionTypeDCECExtAppend(f) :
	uActionTypeDCECExtAppend1(f)
def uActionTypeEngExtAppend(f) :
	uActionTypeEngExtAppend1(f)
	#uActionTypeEngExtAppend2(f)
def uActionTypeDCECExtAppend1(f) :
	tup = findDCECExtLoc("laugh, sleep,")
	copy = str(tup[1])
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) : 
		new_copy+=copy[i]

	verb_set = []
	v_temp = ""
	for i in append_line :
		if i == ',' :
			verb_set.append(str(v_temp).lstrip(" "))
			v_temp = ""
		else:
			v_temp+=i

	append_set = []
	for v in verb_set :
		a_temp=""
		for i in v :
			if i == " " :
				append_set.append(a_temp)
				break
			else :
				a_temp+=i

	if len(append_set) > 0 :
		stich = ""
		for a in append_set :
			stich += a
			stich +=", "
		stich =stich[0:len(stich)-1]
	else :
		stich = ""
		for v in verb_set :
			stich += v
			stich +=", "
		stich = stich[0:len(stich)-1]

	new_copy+= " "
	new_copy+=stich
	new_copy+= " "

	for i in range (tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	#f2 = open("DCECExt.gf", "w")
	#f2.write(new_copy)
	#f2.close()

	uActionTypeDCECExtAppend2(f, new_copy)
def uActionTypeDCECExtAppend2(f, use_copy) :
	tup = findDCECExtLoc2(" laugh_f, run_f, sleep_f,",use_copy)
	copy = use_copy
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) : 
		new_copy+=copy[i]

	verb_set = []
	v_temp = ""
	for i in append_line :
		if i == ',' :
			v_temp+="_f"
			verb_set.append(str(v_temp).lstrip(" "))
			v_temp = ""
		else:
			v_temp+=i

	append_set = []		#append set is for irrelgular verbs
	for v in verb_set :
		a_temp=""
		for i in v :
			if i == " " :
				append_set.append(a_temp)
				break
			else :
				a_temp+=i

	if len(append_set) > 0 :
		stich = ""
		for a in append_set :
			stich += (a + "_f")
			stich +=", "
		stich =stich[0:len(stich)-1]
	else :
		stich = ""
		for v in verb_set :
			print "v: "+ v
			stich += v
			stich +=", "
		stich = stich[0:len(stich)-1]

	new_copy+= " "
	new_copy+=stich
	new_copy+= " "

	for i in range (tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	f2 = open("DCECExt.gf", "w")
	f2.write(new_copy)
	f2.close()	
def uActionTypeEngExtAppend1(f) :
	tup = findEngExtLoc('sleep = (unaryAction (mkV "sleep" "slept" "slept"));')
	copy = tup[1]
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) :
		new_copy+=copy[i]

	verb_set = []
	v_temp = ""
	for i in append_line :
		if i == ',' :
			verb_set.append(str(v_temp).lstrip(" "))
			v_temp = ""
		else:
			v_temp+=i

	verb_set_list = []
	for v in verb_set :
		list_v = v.split()
		verb_set_list.append(tuple(list_v))

	append_list = []

	
	if len(verb_set_list[0]) > 1 :
		for i in verb_set_list :
			s = "   " + i[0] + '  = (unaryAction (mkV "' + i[0] +'" "' + i[1] + '" "' + i[2] + '"));'
			append_list.append(s)
	else :
		for i in verb_set :
			s = "   "  + i + ' = (unaryAction (mkV "' + i + '"));'
			append_list.append(s)
	
	for a in append_list :
		new_copy+=a

	for i in range(tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	uActionTypeEngExtAppend2(f, new_copy)
def uActionTypeEngExtAppend2(f, use_copy) :
	tup = findEngExtLoc2(' sleep_f agent= (activityFluent agent (mkV "sleep" "slept" "slept"));', use_copy)
	copy = use_copy
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) :
		new_copy+=copy[i]

	verb_set = []
	v_temp = ""
	for i in append_line :
		if i == ',' :
			verb_set.append(str(v_temp).lstrip(" "))
			v_temp = ""
		else:
			v_temp+=i

	verb_set_list = []
	for v in verb_set :
		list_v = v.split()
		verb_set_list.append(tuple(list_v))

	append_list = []

	
	if len(verb_set_list[0]) > 1 :
		for i in verb_set_list :
			i_tmp = i[0] + "_f"
			s = "   " + i_tmp + ' agent= (activityFluent agent (mkV "' + i[0] +'" "' + i[1] + '" "' + i[2] + '"));'
			append_list.append(s)
	else :
		for i in verb_set :
			i += "_f"
			s = "   "  + i + ' agent= (activityFluent agent (mkV "' + i[0:len(i)-2] + '"));'
			append_list.append(s)
	
	for a in append_list :
		new_copy+=a

	for i in range(tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	f2 = open("EngExt.gf", "w")
	f2.write(new_copy)
	f2.close()

def binaryActionAgentAppend(f) :
	bActionAgentDCECExtAppend(f)
	bActionAgentEngExtAppend(f)
def bActionAgentDCECExtAppend(f) :
	tup = findDCECExtLoc("hurt, guard,")
	copy = str(tup[1])
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) : 
		new_copy+=copy[i]


	verb_set = []
	v_temp = ""
	for i in append_line :
		if i == ',' :
			verb_set.append(str(v_temp).lstrip(" "))
			v_temp = ""
		else:
			v_temp+=i

	append_set = []
	for v in verb_set :
		a_temp=""
		for i in v :
			if i == " " :
				append_set.append(a_temp)
				break
			else :
				a_temp+=i

	if len(append_set) > 0 :
		stich = ""
		for a in append_set :
			stich += a
			stich +=", "
		stich =stich[0:len(stich)-1]
	else :
		stich = ""
		for v in verb_set :
			stich += v
			stich +=", "
		stich = stich[0:len(stich)-1]

	new_copy+= " "
	new_copy+=stich
	new_copy+= " "

	for i in range (tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	f2 = open("DCECExt.gf", "w")
	f2.write(new_copy)
	f2.close()
def bActionAgentEngExtAppend(f) :
	tup = findEngExtLoc('guard a= (binaryAction (mkV "guard") a);')
	copy = tup[1]
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) :
		new_copy+=copy[i]

	verb_set = []
	v_temp = ""
	for i in append_line :
		if i == ',' :
			verb_set.append(str(v_temp).lstrip(" "))
			v_temp = ""
		else:
			v_temp+=i

	verb_set_list = []
	for v in verb_set :
		list_v = v.split()
		verb_set_list.append(tuple(list_v))

	append_list = []

	if len(verb_set_list[0]) > 1 :
		for i in verb_set_list :
			s = "   " + i[0] + ' a= (binaryAction (mkV "' + i[0] +'" "' + i[1] + '" "' + i[2] + '") a);'
			append_list.append(s)
	else :
		for i in verb_set :
			s = "   "  + i + ' a= (binaryAction (mkV "' + i + '") a);'
			append_list.append(s)

	for a in append_list :
		new_copy+=a

	for i in range(tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	f2 = open("EngExt.gf", "w")
	f2.write(new_copy)
	f2.close()

def binaryActionObjectAppend(f) :
	bActionObjectDCECExtAppend(f)
	bActionObjectEngExtAppend(f)
def bActionObjectDCECExtAppend(f) :
	tup = findDCECExtLoc("eat2,")
	copy = str(tup[1])
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) : 
		new_copy+=copy[i]


	verb_set = []
	v_temp = ""
	for i in append_line :
		if i == ',' :
			v_temp+="2"
			verb_set.append(str(v_temp).lstrip(" "))
			v_temp = ""
		else:
			v_temp+=i

	append_set = []
	for v in verb_set :
		a_temp=""
		for i in v :
			if i == " " :
				append_set.append(a_temp)
				break
			else :
				a_temp+=i

	if len(append_set) > 0 :
		stich = ""
		for a in append_set :
			stich += a
			stich +=", "
		stich =stich[0:len(stich)-1]
	else :
		stich = ""
		for v in verb_set :
			stich += v
			stich +=", "
		stich = stich[0:len(stich)-1]

	new_copy+= " "
	new_copy+=stich
	new_copy+= " "

	for i in range (tup[0], len(copy)) :
		new_copy+=copy[i]

	f2 = open("DCECExt.gf", "w")
	f2.write(new_copy)
	f2.close()
def bActionObjectEngExtAppend(f) :
	tup = findEngExtLoc('eat2 obj = (binaryAction (mkV "eat" "ate" "eaten") obj);')
	copy = tup[1]
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) :
		new_copy+=copy[i]

	verb_set = []
	v_temp = ""
	for i in append_line :
		if i == ',' :
			verb_set.append(str(v_temp).lstrip(" "))
			v_temp = ""
		else:
			v_temp+=i

	verb_set_list = []
	for v in verb_set :
		list_v = v.split()
		verb_set_list.append(tuple(list_v))

	append_list = []

	if len(verb_set_list[0]) > 1 :
		for i in verb_set_list :
			s = "   " + i[0] + '2 obj = (binaryAction (mkV "' + i[0] +'" "' + i[1] + '" "' + i[2] + '") obj);'
			append_list.append(s)
	else :
		for i in verb_set :
			s = "   "  + i + '2 obj = (binaryAction (mkV "' + i + '") obj);'
			append_list.append(s)

	for a in append_list :
		new_copy+=a

	for i in range(tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	f2 = open("EngExt.gf", "w")
	f2.write(new_copy)
	f2.close()

def nullaryFluentAppend(f) :
	nFluentDCECExtAppend(f)
	nFluentEngExtAppend(f)
def nFluentDCECExtAppend(f) :
	tup = findDCECExtLoc("raining,")
	copy = str(tup[1])
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) : 
		new_copy+=copy[i]

	new_copy+= " "
	new_copy+=append_line
	new_copy+= " "

	for i in range (tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	f2 = open("DCECExt.gf", "w")
	f2.write(new_copy)
	f2.close()
def nFluentEngExtAppend(f) :
	tup = findEngExtLoc('snowing = (nullaryFluent (mkV "snow"));')
	copy = tup[1]
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) :
		new_copy+=copy[i]

	temp = ""
	words = []
	for i in range(0,len(append_line)) :
		if append_line[i] != "," :
			temp+=append_line[i]
		else:
			words.append(temp)
			temp = ""

	append_list = []
	for w in words :
		w=w.lstrip(" ")
		s = "    " + w + ' = (nullaryFluent (mkV "'+ w[0:len(w)-3] +'"));'
		append_list.append(s)

	for i in append_list :
		new_copy+=i

	for i in range(tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	f2 = open("EngExt.gf", "w")
	f2.write(new_copy)
	f2.close()

def unaryFluentAppend(f) :
	uFluentDCECExtAppend(f)
	uFluentEngExtAppend(f)
def uFluentDCECExtAppend(f) :
	tup = findDCECExtLoc("hungry,tired,")
	copy = str(tup[1])
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) : 
		new_copy+=copy[i]

	new_copy+= " "
	new_copy+=append_line
	new_copy+= " "

	for i in range (tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	f2 = open("DCECExt.gf", "w")
	f2.write(new_copy)
	f2.close()
def uFluentEngExtAppend(f) :
	tup = findEngExtLoc('tired agent = (unaryFluent agent  (mkAP (mkA "tired"))) ;')
	copy = tup[1]
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) :
		new_copy+=copy[i]

	temp = ""
	words = []
	for i in range(0,len(append_line)) :
		if append_line[i] != "," :
			temp+=append_line[i]
		else:
			words.append(temp)
			temp = ""

	append_list = []
	for w in words :
		w=w.lstrip(" ")
		s = "    " + w + ' agent = (unaryFluent agent  (mkAP (mkA "'+ w + '"))) ;' 
		append_list.append(s)

	for i in append_list :
		new_copy+=i

	for i in range(tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	f2 = open("EngExt.gf", "w")
	f2.write(new_copy)
	f2.close()

def directObjAppend(f) :
	directObjDCECExtAppend(f)
	directObjEngExtAppend(f)
def directObjDCECExtAppend(f) :
	tup = findDCECExtLoc("apple,")
	copy = str(tup[1])
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) : 
		new_copy+=copy[i]

	new_copy+= " "
	new_copy+=append_line
	new_copy+= " "

	for i in range (tup[0], len(copy)) :
		new_copy+=copy[i]

	f2 = open("DCECExt.gf", "w")
	f2.write(new_copy)
	f2.close()
def directObjEngExtAppend(f) :
	tup = findEngExtLoc('apple = {name = (mkN "apple"); indef = (mkN "an apple")};')
	copy = tup[1]
	append_line=f
	new_copy = ""

	for i in range(0,tup[0]) :
		new_copy+=copy[i]

	temp = ""
	words = []
	for i in range(0,len(append_line)) :
		if append_line[i] != "," :
			temp+=append_line[i]
		else:
			words.append(temp)
			temp = ""

	append_list = []
	for w in words :
		w=w.lstrip(" ")
		s = "    " + w + ' = {name = (mkN "'+ w +'"); indef = (mkN "a '+ w +'")};' 
		append_list.append(s)

	for i in append_list :
		new_copy+=i

	for i in range(tup[0]+1, len(copy)) :
		new_copy+=copy[i]

	print new_copy

	f2 = open("EngExt.gf", "w")
	f2.write(new_copy)
	f2.close()

#Stub function to append correct type of word
def stubAppend(choice,f):
	temp =""
	for line in f:
		temp = line

	if choice == 1:
		agentAppend(line)
	elif choice == 2:
		unaryActionTypeAppend(line)
	elif choice == 3:
		binaryActionAgentAppend(line)
	elif choice == 4:
		binaryActionObjectAppend(line)
	elif choice == 5:
		nullaryFluentAppend(line)
	elif choice == 6:
		unaryFluentAppend(line)
	else :
		directObjAppend(line)


if not os.path.isfile("./DCECExt_o.gf") :
	print "DCECExt_o.gf not found, terminating"
	exit(1)

if not os.path.isfile("./EngExt_o.gf") :
	print "EngExt_o.gf not found, terminating"
	exit(1)

if os.path.isfile("./input.txt") :

	f = open("input.txt", "r")

	print "Enter"
	print "1 for agent"
	print "2 for unary actiontype"
	print "3 for binary actiontype for agents (transitive verbs where direct object is another agent)"
	print "4 for binary actiontype for objects (any transitive verb)"
	print "5 for nullary fluent"
	print "6 for unary fluent"
	print "7 for direct objects"

	choice = int(input())
	stubAppend(choice, f)
	f.close()
else:
	print "No input, terminating"
