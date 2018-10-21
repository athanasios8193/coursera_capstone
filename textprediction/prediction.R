load('./dtables.RData')
library(plyr)
library(data.table)

predictword <- function(input) {
        
        ### This function will take an input then take the final 3 values of that input.
        ### It will then feed the results into a bunch of 'if' statements to try and predict the next word
        ### using an n-gram and a back-off model
        
        # This takes the input and takes the final 3 words of the input string as a character vector with length 3 in lowercase
        string <- tolower(tail(unlist(strsplit(input, split=' ')),3))
        
        # This makes a string of the final 3 words IF the input string has 3 or more words
        if (length(string)==3) {str3 <- paste(string, collapse=' ')}
        
        # This makes a string of the final 2 words of the input string IF the input string has 2 or more words
        if (length(string)>=2) {str2 <- paste(string[length(string)-1], string[length(string)], collapse=' ')}
        
        # This makes a string of the final word of the input string
        str1 <- string[length(string)]
        
        # if (length(string)==3) {return(c(str3, str2, str1))}
        # if (length(string)==2) {(return(c(str2, str1)))}
        # if (length(string)==1) {return(str1)}
        
        
        # If the input is 3 or more words, the function checks the 4-gram table
        # If the 3-gram that is the last 3 words of the input string matches 3-grams in the data table,
        # the top 3 results are returned. If not, you move on to the next step
        if (exists('str3')) {
                if (!empty(dt4[w1==str3,])) {
                return(head(dt4[w1==str3, w2],3))
                }
        }
        
        # If the input is 2 or more words, the function checks the 3-gram table
        # If the 2-gram that is the last 2 words of the input string matches 2-grams in the data table,
        # the top 3 results are returned. If not, you move on to the next step
        if (exists('str2')) {
                if (!empty(dt3[w1==str2,])) {
                return(head(dt3[w1==str2, w2],3))
                }
        }
        
        # If the input is 1 or more words, the function checks the 2-gram table
        # If the 1-gram that is the last word of the input string matches 1-grams in the data table,
        # the top 3 results are returned. If not, you move on to the next step
        if (!empty(dt2[w1==str1,])) {
                return(head(dt2[w1==str1, w2],3))
        }
        
        # If none of the 3-, 2-, or 1-grams representing the last 3, 2, or 1 words in the input string,
        # then the top 3 words in the corpus are returned as the next possible word
        return(head(dt1$w1, 3))
        
}