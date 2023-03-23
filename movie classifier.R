##### clear ##### 
rm(list = ls())   
cat(014)

##### install pacakges ##### 
packages - c(ggplot2, dplyr, tidytext, reshape2,
              stringr, tidyr, wordcloud,hunspell,
              SnowballC,xtable, knitr,kableExtra,
              textdata,tm,SnowballC,textshape, lexicon, 
              textclean, hunspell,
              qdapRegex)
install.packages(setdiff(packages, rownames(installed.packages()))) 
##### import pacakges ##### 
library(dplyr)
library(ggplot2)
library(tidytext)
library(stringr) 
library(tidyr)   
library(wordcloud)
library(reshape2)
library(hunspell)
library(SnowballC)
library(xtable)
library(knitr)
library(kableExtra)
library(textdata)
library(tm)
library(SnowballC)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)
library(randomForest)
library(e1071)
library(caret)
library(textshape)
library(lexicon)
library(textclean)
library(hunspell)
library(qdapRegex)

###---- PART A Get the dataIMDB movie Reviews ----###
#httpswww.kaggle.comdatasetslakshmi25npathiimdb-dataset-of-50k-movie-reviewsresource=download
setwd(UsersmayyaDocumentsלימודים קרית אונושנה בסמסטר גניתוח נתוני עתקתרגיל 2archive)
data_text - read.csv(IMDB Dataset.csv, header = TRUE,nrows=2000)
data_text-data_text %% mutate(id_review=row_number())
colnames(data_text)
colnames(data_text) - c(text_review,sentiment,id_review)
colnames(data_text)

data_text$sentiment - factor(data_text$sentiment)
prop.table(table(data_text$sentiment))

###--- PART B Data Cleaning ---####
clean_corpus = function(x){
  # Replace redundant white spaces and line jumps such as n
  x = replace_white(x)
  # Replace or remove non ASCII characters
  x = replace_non_ascii(x)
  # Replace contractions such as you're by expanded such as you are
  x = replace_contraction(x)
  # Replace elongations. Ex heyyyyy is replaced by Hey
  x = replace_word_elongation(x)
  # Replace emoji by plain text
  x = replace_emoji(x)
  # Same for emoticons
  x = replace_emoticon(x)
  # Get ride of HTML remaining in the text if any
  x = replace_html(x)
  # Normalize incomplete sentence replacement
  x = replace_incomplete(x, '.')
  # Replace internet slang by standard words
  x = replace_internet_slang(x)
  # Normalize spaces
  x = replace_kern(x)
  # Replace all amounts of money by a word
  x = replace_money(x, replacement = 'money')
  # Replace all names by a word
  x = replace_names(x, replacement = '')
  # Replace dates by a word
  x = replace_date(x, replacement = 'date')
  # Replace all times with a word
  x = replace_time(x, replacement = 'time')
  # Replace ordinals. For example 1st is transformed to first
  x = replace_ordinal(x)
  # Replace ratings such as five stars by more common adjectives
  x = replace_rating(x)
  # Replace symbols used as abbreviations such as @ by at
  x = replace_symbol(x)
  # ok, done...
  return(x)
}

#run clean_corpus function on the data frame's text column
data_text$text_review = clean_corpus(data_text$text_review)
# Clean NA values
data_text= drop_na(data_text)
#create corpus
corpus = VCorpus(VectorSource(data_text$text_review))

as.character(corpus[[1]])
#Create content transformers
corpus = tm_map(corpus, content_transformer(tolower))
#remove number
corpus = tm_map(corpus, removeNumbers)
#Remove punctuation marks from a text
corpus = tm_map(corpus, removePunctuation)
#stop word removal
corpus = tm_map(corpus, removeWords, stopwords(english))
#stemming
corpus = tm_map(corpus, stemDocument)

#corpus = tm_map(corpus, stripWhitespace)
as.character(corpus[[1]])



###---- PART C Creating the Bag of Words for the model ----####
dtm = DocumentTermMatrix(corpus)
dtm
dim(dtm)
dtm = removeSparseTerms(dtm, 0.999)
dim(dtm)
inspect(dtm[4050, 1015])

# Converting the word frequencies to Yes and No Labels####
convert_count - function(x) {
  y - ifelse(x  0, 1,0)
  y - factor(y, levels=c(0,1), labels=c(No, Yes))
  y
}

# Apply the convert_count function to get final training and testing DTMs
datasetNB - apply(dtm, 2, convert_count)
dataset = as.data.frame(as.matrix(datasetNB))

###---- Part D Descriptive and Exploratory Analysis of the data -----###
#Building Word Frequency
freq- sort(colSums(as.matrix(dtm)), decreasing=TRUE)
tail(freq, 10)
findFreqTerms(dtm, lowfreq=60) #identifying terms that appears frequently


#Plotting Word Frequency
wf- data.frame(word=names(freq), freq=freq)
head(wf)

pp - ggplot(subset(wf, freq800), aes(x=reorder(word, -freq), y =freq)) +
  geom_bar(stat = identity) +
  theme(axis.text.x=element_text(angle=45, hjust=1))
pp


#Building Word Cloud
set.seed(1234)
wordcloud(words = wf$word, freq = wf$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, Dark2))

#adding the sentiment variable to the Dataset
dataset$sentiment = data_text$sentiment
str(dataset$sentiment)

###---- Part E Data Analysis & Model Building ----####

#plitting the dataset into the Training set and Test set
set.seed(222)
split = sample(2,nrow(dataset),prob = c(0.75,0.25),replace = TRUE)
train_set = dataset[split == 1,]
test_set = dataset[split == 2,] 

prop.table(table(train_set$sentiment))


#Model Fitting

#Random Forest Classifier

rf_classifier = randomForest(x = train_set[-7595],
                             y = train_set$sentiment,
                             ntree = 200)

rf_classifier

# Predicting the Test set results
rf_pred = predict(rf_classifier,
                  newdata = test_set[-7595])

confusionMatrix(table(rf_pred,test_set$sentiment))



####Naive Bayes Classifier####

control - trainControl(method=repeatedcv, number=10, repeats=3)
system.time( classifier_nb - naiveBayes(train_set, train_set$sentiment, laplace = 1,
                                         trControl = control,tuneLength = 7) )
##Making Predictions and evaluating 
#the Naive Bayes Classifier##
nb_pred = predict(classifier_nb, type = 'class', newdata = test_set)

confusionMatrix(nb_pred,test_set$sentiment)