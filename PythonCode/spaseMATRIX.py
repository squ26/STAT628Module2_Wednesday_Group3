# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import pandas as pd

train=pd.read_csv("traindata.csv",engine="python")
train=pd.DataFrame(train)

key_occur_bi=pd.read_csv("bi_occur_feature.csv")
key_occur_bi=pd.DataFrame(key_occur_bi)
key=list(key_occur_bi["x"])
key_occur_words=pd.read_csv("words_occur_feature_649.csv")
key_occur_words=pd.DataFrame(key_occur_words)
key_occur_words=list(key_occur_words["x"])
key=key+key_occur_words
key.append("$")
key.append("*")
key.append("!")
key.append("?")

"""
testtemp=pd.read_csv("t1.csv",engine="python")
testtemp=pd.DataFrame(testtemp)
"""
def o_matrix(train,key):
    x=[]
    for i in range(len(train)):
        texti=train["newtext"][i]
        wordsi=texti.rsplit(sep=" ")
        wordsi=[wo.lower() for wo in wordsi]
        xi=[]
        for k in key:
            if k not in  ['$', '*', '!', '?']:
                if any(w == k.lower() for w in wordsi):
                    xij=1
                else:
                    xij=0
                xi.append(xij)
            else:
                xij=0
                for w in wordsi:
                    if w==k:
                        xij=xij+1
                xi.append(xij)
        x.append(xi)
    return x

import numpy
x=o_matrix(train,key)
x = numpy.asarray(x)
numpy.savetxt("X_occur.csv", x, delimiter=",")

