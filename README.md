# cleaningData

The source code is divided in five parts:
- we import the data using read.table and then join training and test
- we keep only columns containing mean() or std() in the name (reading the names from a table and using grepl)
- we put the names we just read as headers for columns
- we add activities and subject, clearly labeling the activities
- we take the mean of every column grouped for activity and subject using aggregate

The code is commented with more details. Enjoy.
