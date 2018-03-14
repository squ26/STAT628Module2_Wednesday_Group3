
import matplotlib.pyplot as plt
import numpy as np
from  sklearn.svm import LinearSVC
import pandas as pd

#import pip
#pip.main(['install','scipy'])


from  sklearn.svm import LinearSVC
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import cross_val_score
from collections import Counter
from datetime import datetime
train = pd.DataFrame(pd.read_csv('train_100.csv', engine='python'))
balanced_texts = []
balanced_labels = []
for i in range(len(train)):
    balanced_texts.append(train['newtext'][i])
    balanced_labels.append(train['stars'][i])

train = pd.DataFrame(pd.read_csv('testdata.csv', engine='python'))
ba_test = []
for i in range(len(train)):
    ba_test.append(train['newtext'][i])
    
balance = [balanced_texts, ba_test]

vectorizer = TfidfVectorizer(ngram_range=(1,2), min_df=10)
X_train = vectorizer.fit_transform(balanced_texts)
X_test = vectorizer.transform(ba_test)

clf = LinearSVC()
clf.fit(X_train, balanced_labels)
predy = clf.predict(X_train)

print(len(vectorizer.vocabulary_))
vectorizer.get_feature_names()

def plot_coefficients(classifier, feature_names, top_features=10):
    for i in range(5):
        coef = classifier.coef_[i].ravel()
        top_positive_coefficients = np.argsort(coef)[-top_features:]
        top_negative_coefficients = np.argsort(coef)[:top_features]
        top_coefficients = np.concatenate((top_negative_coefficients, top_positive_coefficients))
        plt.figure(figsize=(15, 5))
        colors = ['xkcd:lightblue' if c < 0 else 'xkcd:coral' for c in coef[top_coefficients]]
        plt.bar(np.arange(2 * top_features), coef[top_coefficients], color=colors)
        feature_names = np.array(feature_names)
        plt.xticks(np.arange(1, 1 + 2 * top_features), feature_names[top_coefficients], rotation=20, ha='right')
        plt.title("Top Influential Words for Star" + str(i+1))
        plt.show()
        

plot_coefficients(clf, vectorizer.get_feature_names())

i = 10
print("sdfw", str(i))


print(len(balanced_labels))
print(predy[:10])
tplist = pd.DataFrame({'Actual': balanced_labels, 'Predict': predy})












