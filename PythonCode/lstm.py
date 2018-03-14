import re
import nltk

import pandas as pd
import numpy as np
import pip

pip.main(["install","sklearn"])
pip.main(["install","keras"])
pip.main(["install","bs4"])
pip.main(["install","scipy"])
pip.main(["install","nltk"])

from bs4 import BeautifulSoup
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
english_stemmer=nltk.stem.SnowballStemmer('english')

from sklearn.feature_selection.univariate_selection import SelectKBest, chi2, f_classif
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import SGDClassifier, SGDRegressor
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
import random
import itertools

import sys
import os
import argparse
from sklearn.pipeline import Pipeline
from scipy.sparse import csr_matrix
from sklearn.feature_extraction.text import CountVectorizer
import six
from abc import ABCMeta
from scipy import sparse
from scipy.sparse import issparse
from sklearn.base import BaseEstimator, ClassifierMixin
from sklearn.utils import check_X_y, check_array
from sklearn.utils.extmath import safe_sparse_dot
from sklearn.preprocessing import normalize, binarize, LabelBinarizer
from sklearn.svm import LinearSVC

from keras.preprocessing import sequence
from keras.utils import np_utils
from keras.models import Sequential
from keras.layers.core import Dense, Dropout, Activation, Lambda
from keras.layers.embeddings import Embedding
from keras.layers.recurrent import LSTM, SimpleRNN, GRU
from keras.preprocessing.text import Tokenizer
from collections import defaultdict
from keras.layers.convolutional import Convolution1D
from keras import backend as K
# fix random seed for reproducibility
numpy.random.seed(7)

max_features = 2000
EMBEDDING_DIM = 100
VALIDATION_SPLIT = 0.2
maxlen = 100
batch_size = 32
nb_classes = 6

data=pd.read_csv("train_100.csv",engine="python")
data=pd.DataFrame(data)
data=data.loc()
testdata=pd.read_csv("testdata.csv",engine="python")
testdata=pd.DataFrame(testdata)

train, test = train_test_split(data, test_size = 0.3)

tokenizer = Tokenizer(num_words=max_features)
tokenizer.fit_on_texts(train['newtext'])

sequences_train = tokenizer.texts_to_sequences(train['newtext'])
sequences_test = tokenizer.texts_to_sequences(test['newtext'])
seq_testx = tokenizer.texts_to_sequences(testdata['newtext'])

X_train = sequence.pad_sequences(sequences_train, maxlen)
X_test = sequence.pad_sequences(sequences_test, maxlen)

y_train = train['stars']
y_test = test['stars']


testx=sequence.pad_sequences(seq_testx, maxlen)

Y_train = np_utils.to_categorical(y_train, nb_classes)
Y_test = np_utils.to_categorical(y_test, nb_classes)

#creat the model
max_features = 2000
EMBEDDING_DIM = 100
VALIDATION_SPLIT = 0.2
maxlen = 100
batch_size = 16
nb_classes = 6

model = Sequential()
model.add(Embedding(max_features,16))
model.add(LSTM(16, dropout=0.2, recurrent_dropout=0.2))
model.add(Dense(6, activation="softmax"))


model.compile(loss='categorical_crossentropy',
              optimizer='adam',
              metrics=['mse'])
              
print(model.summary())

model.fit(X_train, Y_train, validation_data=(X_test, Y_test), epochs=5, batch_size=16)