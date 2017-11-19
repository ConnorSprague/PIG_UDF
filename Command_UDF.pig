Lines = LOAD '/home/training/Downloads/Pig/input.txt' Using PigStorage('\t') AS (word: chararray, chapterCounter: int);

AllWords = foreach Lines generate chapterCounter, flatten(TOKENIZE(word)) as word;

FilteredWords = FILTER AllWords BY (LOWER(word) != 'in') AND (LOWER(word) != 'and') AND (LOWER(word) != 'a');

WordsChapGroup = Group FilteredWords By (word, chapterCounter);

WordsChap = Foreach WordsChapGroup Generate FLATTEN(group) As (word,  chapterCounter), COUNT(FilteredWords.chapterCounter) as occurrenceCount;

WordsGroup = Group WordsChap By (word);

Words = Foreach WordsGroup Generate FLATTEN(group) As (word), COUNT(WordsChap.chapterCounter) As chapterSum, SUM(WordsChap.occurrenceCount) As occurrenceSum;

CommonChapWords = Filter Words By (chapterSum == 2);

OrderedWords = Order CommonChapWords By occurrenceSum Desc;

LimitedWords = Limit OrderedWords 10;

Dump LimitedWords;