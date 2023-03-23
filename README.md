# ML--IMDB_review_NLP
Project Summary:
This project presents a application of sentiment analysis of user reviews on movie platform IMDb. The purpose of this study is to utilize  NLP to classify sentiment of movie reviews.

The project consisted overall of 3 parts:
1. Get the data:IMDB movie Reviews. 
https://www.kaggle.com/datasets/lakshmi25npathi/imdb-dataset-of-50k-movie-reviews?resource=download

2. Data Cleaning - 
Replace redundant white spaces and line jumps, non ASCII characters, contractions, elongations.
Replace emoji by plain text,
slang by standard words.
Normalize spaces.
Replace all amounts of money ,names, times and dates by a word.
Replace ordinals.

3. create corpus- Create content transformers,
remove number,
Remove punctuation marks from a text,
stop word removal,
stemming,

4. Descriptive and Exploratory Analysis of the data - Building Word Frequency and Creating the Bag of Words for the model
<img src="https://user-images.githubusercontent.com/60346583/227260902-f1eb2a6b-a04c-482b-bf82-e273c3dd02e9.png" width="300"> <img src="https://user-images.githubusercontent.com/60346583/227261076-d033b79c-0b87-40a4-a311-92c3de5cd56f.png" width="300">

5. Data Analysis & Model Building- Findings

create random forest model that yielding an accuracy of 98.47 %.  In naive base algoritm that yielding an accuracy of 97.16 %. 

<img src="https://user-images.githubusercontent.com/60346583/227263821-08cf0111-0cc7-4323-8ce8-d0a2acb4c299.png" width="300"><img src="https://user-images.githubusercontent.com/60346583/227264469-2b915f64-1d70-46ec-958b-ada9af066a2c.png" width="255">




