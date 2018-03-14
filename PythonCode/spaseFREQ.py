# -*- coding: utf-8 -*-
"""
Created on Sat Mar 10 16:39:11 2018

@author: shuyi
"""

train=pd.read_csv("traindata.csv",engine="python")
train=pd.DataFrame(train)


key_freq_bi=pd.read_csv("bi_freq_feature.csv",engine="python")
key_freq_bi=pd.DataFrame(key_freq_bi)
key=list(key_freq_bi["x"])
key_freq_words=pd.read_csv("words_freq_feature_640.csv",engine="python")
key_freq_words=pd.DataFrame(key_freq_words)
key_freq_words=list(key_freq_words["x"])
key=key+key_freq_words
key.append("$")
key.append("*")
key.append("!")
key.append("?")

"""
testtemp=pd.read_csv("t1.csv",engine="python")
testtemp=pd.DataFrame(testtemp)
"""

def f_matrix(train,key):
    x=[]
    for i in range(len(train)):
        texti=train["newtext"][i]
        wordsi=texti.rsplit(sep=" ")
        wordsi=[wo.lower() for wo in wordsi]
        xi=[]
        for k in key:
            xij=0
            for w in wordsi:
                if w==k.lower():
                    xij=xij+1
            xi.append(xij)
        x.append(xi)
    return x       

import numpy
x=f_matrix(train,key)
x = numpy.asarray(x)
numpy.savetxt("X_freq.csv", x, delimiter=",")