import urllib2
import json
def parse_Simple(F):
    urlRoot="http://127.0.0.1:41296/DCECExt.pgf?command=parse&input="
    query= urlRoot+urllib2.quote(F)
    resp= urllib2.urlopen(query).read()
    return json.loads(resp)[0]["trees"]


def linearize_Simple(F):
    urlRoot="http://127.0.0.1:41296/DCECExt.pgf?command=linearize&tree="
    query= urlRoot+urllib2.quote(F)
    resp= urllib2.urlopen(query).read()
    return json.loads(resp)[0]["text"]



def parse_Deep(F):
    urlRoot="http://127.0.0.1:4242/parse?q="
    query= urlRoot+urllib2.quote(F)
    resp= urllib2.urlopen(query).read()
    return resp
