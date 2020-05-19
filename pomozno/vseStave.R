multiplier_ame <- list("Color" = 1, "Odd or even" = 1, "Low or high" = 1, "Dozen" = 2, "Row" = 2, "6 number combination" = 5,
               "5 number combination" = 6, "4 number combination" = 8, "3 number combination" = 11, "2 number combination" = 17, "Number" = 35)

multiplier_eu <- list("Color" = 1, "Odd or even" = 1, "Low or high" = 1, "Dozen" = 2, "Row" = 2, "6 number combination" = 5,
                  "4 number combination" = 8, "3 number combination" = 11, "2 number combination" = 17, "Number" = 35)

numbers_ame <- c("Green 00", "Green 0", "Red 1", "Black 2", "Red 3", "Black 4", "Red 5", "Black 6",
             "Red 7", "Black 8", "Red 9", "Black 10", "Black 11", "Red 12", "Black 13", "Red 14", 
             "Black 15", "Red 16", "Black 17", "Red 18", "Red 19", "Black 20", "Red 21",
             "Black 22", "Red 23", "Black 24", "Red 25", "Black 26", "Red 27", "Black 28", "Black29",
             "Red 30", "Black 31", "Red 32", "Black 33", "Red 34", "Black 35", "Red 36")

numbers_eu <- c("Green 0", "Red 1", "Black 2", "Red 3", "Black 4", "Red 5", "Black 6",
                 "Red 7", "Black 8", "Red 9", "Black 10", "Black 11", "Red 12", "Black 13", "Red 14", 
                 "Black 15", "Red 16", "Black 17", "Red 18", "Red 19", "Black 20", "Red 21",
                 "Black 22", "Red 23", "Black 24", "Red 25", "Black 26", "Red 27", "Black 28", "Black29",
                 "Red 30", "Black 31", "Red 32", "Black 33", "Red 34", "Black 35", "Red 36")

five_num <- c("Green 00", "Green 0", "Red 1", "Black 2", "Red 3")

dozen <- list("1-12" = c("Red 1", "Black 2", "Red 3", "Black 4", "Red 5", "Black 6",
                         "Red 7", "Black 8", "Red 9", "Black 10", "Black 11", "Red 12"),
              "13-24" = c("Black 13", "Red 14", "Black 15", "Red 16", "Black 17", "Red 18", 
                          "Red 19", "Black 20", "Red 21", "Black 22", "Red 23", "Black 24"),
              "25-36" = c("Red 25", "Black 26", "Red 27", "Black 28", "Black29", "Red 30",
                          "Black 31", "Red 32", "Black 33", "Red 34", "Black 35", "Red 36"))

row <- list("top row" = c("Red 3", "Black 6", "Red 9", "Red 12", "Black 15", "Red 18", "Red 21",
                          "Black 24", "Red 27", "Red 30", "Black 33", "Red 36"),
            "middle row" = c("Black 2", "Red 5", "Black 8", "Black 11", "Red 14", "Black 17", "Black 20",
                             "Red 23", "Black 26", "Black29", "Red 32", "Black 35"),
            "bottom row" = c("Red 1", "Black 4", "Red 7", "Black 10", "Black 13", "Red 16", "Red 19",
                             "Black 22", "Red 25", "Black 28", "Black 31", "Red 34"))

six_num <- list("1-6" = c("Red 1", "Black 2", "Red 3", "Black 4", "Red 5", "Black 6"),
                "7-12" = c("Red 7", "Black 8", "Red 9", "Black 10", "Black 11", "Red 12"),
                "13-18" = c("Black 13", "Red 14", "Black 15", "Red 16", "Black 17", "Red 18"),
                "19-24" = c("Red 19", "Black 20", "Red 21", "Black 22", "Red 23", "Black 24"),
                "25-30" = c("Red 25", "Black 26", "Red 27", "Black 28", "Black29", "Red 30"),
                "31-36" = c("Black 31", "Red 32", "Black 33", "Red 34", "Black 35", "Red 36"))

four_num <- list("0, 1, 2, 3" = c("Green 0", "Red 1", "Black 2", "Red 3"),
                 "1, 2, 4, 5" = c("Red 1", "Black 2", "Black 4", "Red 5"),
                 "2, 3, 5, 6" = c("Black 2", "Red 3", "Red 5", "Black 6"),
                 "4, 5, 7, 8" = c("Black 4", "Red 5", "Red 7", "Black 8"),
                 "5, 6, 8, 9" = c("Red 5", "Black 6", "Black 8", "Red 9"),
                 "7, 8, 10, 11" = c("Red 7", "Black 8", "Black 10", "Black 11"),
                 "8, 9, 11, 12" = c("Black 8", "Red 9", "Black 11", "Red 12"),
                 "10, 11, 13, 14" = c("Black 10", "Black 11", "Black 13", "Red 14"),
                 "11, 12, 14, 15" = c("Black 11", "Red 12", "Red 14", "Black 15"))

three_num_ame <- list("0, 00, 2" = c("Green 00", "Green 0", "Black 2"), "0, 1, 2" = c("Green 0", "Red 1", "Black 2"),
                      "00, 2, 3" = c("Green 00", "Black 2", "Red 3"), "1, 2, 3" = c("Red 1", "Black 2", "Red 3"),
                      "4, 5, 6" = c("Black 4", "Red 5", "Black 6"), "7, 8, 9" = c("Red 7", "Black 8", "Red 9"),
                      "10, 11, 12" = c("Black 10", "Black 11", "Red 12"), "13, 14, 15" = c("Black 13", "Red 14", "Black 15"),
                      "16, 17, 18" = c("Red 16", "Black 17", "Red 18"), "19, 20, 21" = c("Red 19", "Black 20", "Red 21"),
                      "22, 23, 24" = c("Black 22", "Red 23", "Black 24"), "25, 26, 27" = c("Red 25", "Black 26", "Red 27"),
                      "28, 29, 30" = c("Black 28", "Black29", "Red 30"), "31, 32, 33" = c("Black 31", "Red 32", "Black 33"),
                      "34, 35, 36" = c("Red 34", "Black 35", "Red 36"))

three_num_eu <- list("0, 1, 2" = c("Green 0", "Red 1", "Black 2"), "0, 2, 3" = c("Green 0", "Black 2", "Red 3"), 
                     "1, 2, 3" = c("Red 1", "Black 2", "Red 3"), "4, 5, 6" = c("Black 4", "Red 5", "Black 6"), 
                     "7, 8, 9" = c("Red 7", "Black 8", "Red 9"), "10, 11, 12" = c("Black 10", "Black 11", "Red 12"), 
                     "13, 14, 15" = c("Black 13", "Red 14", "Black 15"), "16, 17, 18" = c("Red 16", "Black 17", "Red 18"), 
                     "19, 20, 21" = c("Red 19", "Black 20", "Red 21"), "22, 23, 24" = c("Black 22", "Red 23", "Black 24"), 
                     "25, 26, 27" = c("Red 25", "Black 26", "Red 27"), "28, 29, 30" = c("Black 28", "Black29", "Red 30"), 
                     "31, 32, 33" = c("Black 31", "Red 32", "Black 33"), "34, 35, 36" = c("Red 34", "Black 35", "Red 36"))

two_num_ame <- list("0, 1" = c("Green 0", "Red 1"), "0, 2" = c("Green 0", "Black 2"), "00, 2" = c("Green 00", "Black 2"),
                    "00, 3" = c("Green 00", "Red 3"), "1, 2" = c("Red 1", "Black 2"), "1, 4"= c("Red 1", "Black 4"),
                    "2, 3" = c("Black 2", "Red 3"), "2, 5" = c("Black 2", "Red 5"), "3, 6" = c("Black 6", "Red 3"),
                    "4, 5" = c("Black 4", "Red 5"), "4, 7" = c("Black 4", "Red 7"), "5, 6" = c("Black 6", "Red 5"),
                    "5, 8" = c("Black 8", "Red 5"), "6, 9" = c("Black 6", "Red 9"), ...)

two_num_eu <- list()

barve <- list("Red" = c("Red 1", "Red 3", "Red 5", "Red 7", "Red 9", "Red 12", "Red 14", 
                        "Red 16", "Red 18", "Red 19", "Red 21", "Red 23", "Red 25", "Red 27", 
                        "Red 30", "Red 32", "Red 34", "Red 36"), 
              "Black" = c("Black 2", "Black 4", "Black 6", "Black 8", "Black 10", "Black 11", "Black 13", 
                          "Black 15", "Black 17", "Black 20", "Black 22", "Black 24", "Black 26", 
                          "Black 28", "Black29", "Black 31", "Black 33", "Black 35"))

even_odd <- list("Even" = c("Black 2", "Black 4", "Black 6", "Black 8", "Black 10", "Red 12", "Red 14", 
                            "Red 16", "Red 18", "Black 20", "Black 22", "Black 24", "Black 26", "Black 28", 
                            "Red 30", "Red 32", "Red 34", "Red 36"),
                 "Odd" = c("Red 1", "Red 3", "Red 5", "Red 7", "Red 9", "Black 11", "Black 13", "Black 15", 
                           "Black 17", "Red 19", "Red 21", "Red 23", "Red 25", "Red 27", "Black29", "Black 31", 
                           "Black 33", "Black 35"))

low_high <- list("low" = c("Red 1", "Black 2", "Red 3", "Black 4", "Red 5", "Black 6",
                           "Red 7", "Black 8", "Red 9", "Black 10", "Black 11", "Red 12", "Black 13", "Red 14", 
                           "Black 15", "Red 16", "Black 17", "Red 18"),
                 "high" = c("Red 19", "Black 20", "Red 21",
                            "Black 22", "Red 23", "Black 24", "Red 25", "Black 26", "Red 27", "Black 28", "Black29",
                            "Red 30", "Black 31", "Red 32", "Black 33", "Red 34", "Black 35", "Red 36"))


