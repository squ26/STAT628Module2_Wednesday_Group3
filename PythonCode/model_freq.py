import numpy as np
from  sklearn.svm import SVC
import pandas as pd
#import pip
#pip.main(['install','scipy'])
from numpy import genfromtxt
xmat = np.genfromtxt('trmat.csv', delimiter=',', names=True)



y = []
with open("trmat.csv", 'r') as f:
    print(f[0])
    for line in f[1]:
        xmat.append([line.split()[:-1])
        y.append(line.split()[:-1]
        
        
clf = SVC()
clf.fit(X, y)