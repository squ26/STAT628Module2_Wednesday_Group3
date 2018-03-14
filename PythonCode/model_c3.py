import numpy as np
from  sklearn.svm import SVC
import pandas as pd

#### freq
xmat = pd.DataFrame(pd.read_csv('trmat_640.csv', engine='python'))
xmat = xmat.drop(xmat.columns[[0]], axis=1)

y = xmat['rate']
xmat = xmat.drop(['rate'], axis=1)



xmate = pd.DataFrame(pd.read_csv('temat_640.csv', engine='python'))
xmate = xmate.drop(xmate.columns[[0]], axis=1)
ye = xmate['rate']
xmate = xmate.drop(['rate'], axis=1)



xnp = np.array(xmat)
ynp = np.array(y)

xenp = np.array(xmate)
yenp = np.array(ye)

# SVM
clf = SVC()
clf.fit(xnp, ynp)
y_pe_svm = clf.predict(xenp)

rmse_svm = 0
for i in range(len(y_pe_svm)):
    rmse_svm += (yenp[i] - y_pe_svm[i])**2
rmse_svm = (rmse_svm / len(y_pe_svm)) ** (0.5)


# xgboost
xgb = XGBClassifier()
xgb.fit(xnp, ynp)
y_pe_xgb = xgb.predict(xenp)

rmse_xgb = 0
for i in range(len(y_pe_xgb)):
    rmse_xgb += (yenp[i] - y_pe_xgb[i])**2
rmse_xgb = (rmse_xgb / len(y_pe_xgb)) ** (0.5)