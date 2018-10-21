library(quanteda)
library(readtext)
library(data.table)
# library(caTools)
# library(e1071)

# PERCENTAGE OF LINES FROM TEXT FILES TO SAMPLE
percentage <- .4

set.seed(538)

## SAMPLE % of LINES FROM THE BLOGS FILE

con <- file("./Data/final/en_US/en_US.blogs.txt")

#blogsample <- sample(readLines(con), 100000)
blogsample <- sample(readLines(con), floor(percentage*length(readLines(con))))

close(con)

## SAMPLE % of LINES FROM THE NEWS FILE

set.seed(538) #I'M NOT SURE IF YOU ACTUALLY NEED TO RE-SET THE SEED EVERY TIME BUT IT DOESN'T HURT

con <- file("./Data/final/en_US/en_US.news.txt", "rb")

#newssample <- sample(readLines(con), 110000)
newssample <- sample(readLines(con), floor(percentage*length(readLines(con))))

close(con)

## SAMPLE % of LINES FROM THE TWITTER FILE

set.seed(538)

con <- file("./Data/final/en_US/en_US.twitter.txt")

#twittersample <- sample(readLines(con), 250000)
twittersample <- sample(readLines(con), floor(percentage*length(readLines(con))))

close(con)

rm(percentage)

## SAVE THE RESULTS TO TXT FILES

writeLines(blogsample, "./Cleaned Data/blog.txt")
writeLines(newssample, "./Cleaned Data/news.txt")
writeLines(twittersample, "./Cleaned Data/twitter.txt")

## REMOVE VARIABLES TO ALLOW FOR MORE MEMORY FOR LATER
rm(blogsample)
rm(newssample)
rm(twittersample)
rm(con)


## READS IN TXT FILES FOR CORPUS
corp_texts <- readtext('./Cleaned Data/*.txt', cache=FALSE)

## CREATES THE CORPUS
corpus <- corpus(corp_texts)

## LIST OF SWEAR WORDS TO BE REMOVED
url <- 'http://www.bannedwordlist.com/lists/swearWords.txt'
cuss <- readLines(url, warn=FALSE)

## CREATES TOKENS VECTOR TO FEED INTO DOCUMENT FEATURE MATRIX
mytokens <- tokens(corpus, remove_punct=TRUE,
                   remove_numbers=TRUE,
                   remove_twitter=TRUE,
                   remove_hyphens=TRUE)

## CONVERTS TO LOWER CASE
mytokens <- tokens_tolower(mytokens, keep_acronyms=FALSE)

## REMOVES CUSS WORDS
mytokens <- tokens_remove(mytokens, cuss, padding=TRUE)

## REMOVES CORPUS TO PRESERVE MEMORY
rm(corp_texts)
rm(corpus)
rm(cuss)
rm(url)

## CREATES N-GRAMS FOR N=1:4
mytokens1 <- tokens_ngrams(mytokens, n=1)
mytokens2 <- tokens_ngrams(mytokens, n=2)
mytokens3 <- tokens_ngrams(mytokens, n=3)
mytokens4 <- tokens_ngrams(mytokens, n=4)

## REMOVES TOKENS TO PRESERVE MEMORY
rm(mytokens)


## CREATES DOCUMENT FEATURE MATRICES FOR THE 4 NGRAMS
## REMOVES TOKENS AFTER EACH DFM TO PRESERVE MEMORY BECAUSE EACH ONE IS ENORMOUS
mydfm1 <- dfm(mytokens1)
rm(mytokens1)
mydfm2 <- dfm(mytokens2)
rm(mytokens2)
mydfm3 <- dfm(mytokens3)
rm(mytokens3)
mydfm4 <- dfm(mytokens4)
rm(mytokens4)

## REMOVES ALL TERMS WITH FEWER THAN 2 INSTANCES TO SAVE MEMORY AND REMOVE TERMS IRRELEVANT TO PREDICTION
mydfm1 <- dfm_trim(mydfm1, 2)
mydfm2 <- dfm_trim(mydfm2, 2)
mydfm3 <- dfm_trim(mydfm3, 2)
mydfm4 <- dfm_trim(mydfm4, 2)

## SUMS THE DOCUMENT FEATURE MATRICES AND CREATES A NAMED NUMERIC VECTOR WITH THE NAME BEING THE N-GRAM AND THE VALUE
## BEING THE FREQUENCY IN THE DOCUMENT
sum1 <- colSums(mydfm1)
sum2 <- colSums(mydfm2)
sum3 <- colSums(mydfm3)
sum4 <- colSums(mydfm4)

## REMOVE THE DFMS TO SAVE SOME MEMORY
rm(mydfm1)
rm(mydfm2)
rm(mydfm3)
rm(mydfm4)

## SORTS THESE VECTORS SO THE MOST FREQUENT VALUES ARE ON TOP
sum1 <- sort(sum1, decreasing = TRUE)
sum2 <- sort(sum2, decreasing = TRUE)
sum3 <- sort(sum3, decreasing = TRUE)
sum4 <- sort(sum4, decreasing = TRUE)

## CREATES DATA TABLES FOR EACH OF THE N-GRAMS
dt1 <- data.table(w1 = names(sum1), count=sum1)
dt2 <- data.table(
        w1 = sapply(strsplit(names(sum2),"_",fixed=TRUE),'[',1),
        w2 = sapply(strsplit(names(sum2),"_",fixed=TRUE),'[',2),
        count=sum2)
dt3 <- data.table(
        w1 = paste(sapply(strsplit(names(sum3),"_",fixed=TRUE),'[',1),
        sapply(strsplit(names(sum3),"_",fixed=TRUE),'[',2)),
                w2 = sapply(strsplit(names(sum3),"_",fixed=TRUE),'[',3),
        count=sum3)
dt4 <- data.table(
        w1 = paste(sapply(strsplit(names(sum4),"_",fixed=TRUE),'[',1),
                sapply(strsplit(names(sum4),"_",fixed=TRUE),'[',2),
                sapply(strsplit(names(sum4),"_",fixed=TRUE),'[',3)),
        w2 = sapply(strsplit(names(sum4),"_",fixed=TRUE),'[',4),
                count=sum4)

## REMOVES THE SUM VECTORS
rm(sum1)
rm(sum2)
rm(sum3)
rm(sum4)

# SAVES THE DATA TABLES TO A .RDATA FILE SO THAT I DON'T HAVE TO RUN THIS CODE AGAIN TO SAVE A LOT OF TIME
save.image('./dtables.RData')

## CREATE TRAINING AND TESTING SETS
# set.seed(123)
# 
# sample1 <- sample.split(dt1$w1, SplitRatio = 0.7)
# train1 <- subset(dt1, sample1==TRUE)
# test1 <- subset(dt1, sample1==FALSE)
# 
# sample2 <- sample.split(dt2$w2, SplitRatio = 0.7)
# train2 <- subset(dt2, sample2==TRUE)
# test2 <- subset(dt2, sample2==FALSE)
# 
# sample3 <- sample.split(dt3$w3, SplitRatio = 0.7)
# train3 <- subset(dt3, sample3==TRUE)
# test3 <- subset(dt3, sample3==FALSE)
# 
# sample4 <- sample.split(dt4$w2, SplitRatio = 0.7)
# train4 <- subset(dt4, sample4==TRUE)
# test4 <- subset(dt4, sample4==FALSE)