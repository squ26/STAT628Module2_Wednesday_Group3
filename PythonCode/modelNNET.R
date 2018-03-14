setwd("/shuyi/Desktop/628module2/data")
library(ggplot2)
library(RTextTools)
library(readr)
library(SnowballC)
library(stringr)
library(tm)
library(wordcloud)
library(e1071)

model_container=readRDS("modelcontainer.rds")
memory.limit(size=100000)
y=readRDS("train.rds")$stars
train_range=readRDS("trindex.rds")
test_range=readRDS("teindex.rds")
#######################################################
maxent_model <- train_model(model_container, algorithm = "MAXENT")
maxent_results <- classify_model(model_container, maxent_model)
maxent_df <- data.frame(
  true_rating = as.numeric(y[test_range]),
  maxent_rating = as.numeric(maxent_results$MAXENTROPY_LABEL)
)
maxent_mse <- sum((maxent_df[,2]-maxent_df[,1])^2)/length(maxent_df[,1]); maxent_rmse <- sqrt(maxent_mse)
maxent_mse;maxent_rmse

SVM_model <- train_model(model_container,algorithm = "SVM")
SVM_results <- classify_model(model_container, SVM_model)
SVM_df <- data.frame(
  true_rating = as.numeric(y[test_range]),
  SVM_rating = as.numeric(SVM_results$SVM_LABEL)
)
SVM_mse <- sum((SVM_df[,2]-SVM_df[,1])^2)/length(SVM_df[,1]); SVM_rmse <- sqrt(SVM_mse)
SVM_mse;SVM_rmse

GLMNET_model <- train_model(model_container,algorithm = "GLMNET")
GLMNET_results <- classify_model(model_container, GLMNET_model)
GLMNET_df <- data.frame(
 true_rating = as.numeric(y[test_range]),
 GLMNET_rating = as.numeric(GLMNET_results$GLMNET_LABEL)
)
GLMNET_mse <- sum((GLMNET_df[,2]-GLMNET_df[,1])^2)/length(GLMNET_df[,1]); GLMNET_rmse <- sqrt(GLMNET_mse)
GLMNET_mse;GLMNET_rmse

SLDA_model <- train_model(model_container,algorithm = "SLDA")
SLDA_results <- classify_model(model_container, SLDA_model)
SLDA_df <- data.frame(
  true_rating = as.numeric(y[test_range]),
  SLDA_rating = as.numeric(SLDA_results$SLDA_LABEL)
)
SLDA_mse <- sum((SLDA_df[,2]-SLDA_df[,1])^2)/length(SLDA_df[,1]); SLDA_rmse <- sqrt(SLDA_mse)
SLDA_mse;SLDA_rmse

BOOSTING_model <- train_model(model_container,algorithm = "BOOSTING")
BOOSTING_results <- classify_model(model_container, BOOSTING_model)
BOOSTING_df <- data.frame(
  true_rating = as.numeric(y[test_range]),
  BOOSTING_rating = as.numeric(BOOSTING_results$LOGITBOOST_LABEL)
)
BOOSTING_mse <- sum((BOOSTING_df[,2]-BOOSTING_df[,1])^2)/length(BOOSTING_df[,1]); BOOSTING_rmse <- sqrt(BOOSTING_mse)
BOOSTING_mse;BOOSTING_rmse


BAGGING_model<- train_model(model_container,algorithm = "BAGGING")
BAGGING_results <- classify_model(model_container, BAGGING_model)
BAGGING_df <- data.frame(
  true_rating = as.numeric(y[test_range]),
  BAGGING_rating = as.numeric(BAGGING_results$BAGGING_LABEL)
)
BAGGING_mse <- sum((BAGGING_df[,2]-BAGGING_df[,1])^2)/length(BAGGING_df[,1]); BAGGING_rmse <- sqrt(BAGGING_mse)
BAGGING_mse;BAGGING_rmse

RF_model <- train_model(model_container,algorithm = "RF")
RF_results <- classify_model(model_container, RF_model)
RF_df <- data.frame(
  true_rating = as.numeric(y[test_range]),
  RF_rating = as.numeric(RF_results$FORESTS_LABEL)
)
RF_mse <- sum((RF_df[,2]-RF_df[,1])^2)/length(RF_df[,1]); RF_rmse <- sqrt(RF_mse)
RF_mse;RF_rmse

NNET_model<- train_model(model_container,algorithm ="NNET")
NNET_results <- classify_model(model_container, NNET_model)
NNET_df <- data.frame(
  true_rating = as.numeric(y[test_range]),
  NNET_rating = as.numeric(NNET_results$NNETWORK_LABEL)
)
NNET_mse <- sum((NNET_df[,2]-NNET_df[,1])^2)/length(NNET_df[,1]); NNET_rmse <- sqrt(NNET_mse)
NNET_mse;NNET_rmse

TREE_model <- train_model(model_container,algorithm = "TREE")
TREE_results <- classify_model(model_container, TREE_model)
TREE_df <- data.frame(
  true_rating = as.numeric(y[test_range]),
  TREE_rating = as.numeric(TREE_results$TREE_LABEL)
)
TREE_mse <- sum((TREE_df[,2]-TREE_df[,1])^2)/length(TREE_df[,1]); TREE_rmse <- sqrt(TREE_mse)
TREE_mse;TREE_rmse

maxent_results <- classify_model(model_container, maxent_model)
maxent_df <- data.frame(
  true_rating = as.numeric(y[test_range]),
  maxent_rating = as.numeric(maxent_results$MAXENTROPY_LABEL)
)
mse <- sum((maxent_df[,2]-maxent_df[,1])^2)/length(maxent_df[,1]); rmse <- sqrt(mse)
mse;rmse


plt <- ggplot(result_df, aes(x = maxent_rating)) + geom_histogram(fill = "white", color = "black",
                                                                  breaks = seq(0.5, 5.5, 1)) + facet_grid(true_rating ~ .)
plt <- plt + theme(strip.text.y = element_text(size = rel(1.5),
                                               face = "bold"))
plt <- plt + theme(axis.text.x = element_text(size = rel(1.5)))
plt <- plt + xlab("Estimated Rating") + theme(axis.title.x = element_text(size = rel(1.5), face = "bold"))
plt <- plt + ggtitle("Distribution of Estimated Ratings") + theme(plot.title = element_text(size = rel(2.0), face = "bold"))
plt
print("Mean values for estimated ratings:")
for (actual_value in 1:5) {
  mean_val <- mean(result_df$maxent_rating[result_df$true_rating ==
                                             actual_value])
  print(str_c("Actual = ", actual_value,
              ": Mean of Estimate = ", round(mean_val, 2)))
}

incrrct1_index = test_range[result_df$true_rating == 1 & result_df$maxent_rating != 1]# index returned are index in "reviews"
incrrct2_index = test_range[result_df$true_rating == 2 & result_df$maxent_rating != 2]
incrrct3_index = test_range[result_df$true_rating == 3 & result_df$maxent_rating != 3]
incrrct4_index = test_range[result_df$true_rating == 4 & result_df$maxent_rating != 4]
incrrct5_index = test_range[result_df$true_rating == 5 & result_df$maxent_rating != 5]

