from random import randrange
def banner(x):
    print("[*]----------------------------[*]")
    print(x)
    print("[*]----------------------------[*]")

def picker():
    #this is a dic, examp: {1:"choice",2:"choice2"}
    choices = {1:"Robertos",2:"Hyderabad",3:"Spring Food Park",4:"Olive Oil",5:"Freebirds",6:"Torchys",7:"Chick-fil-a"}
    #makes the choice based on randrange adding 1 (to avoid a 0 result)
    banner(choices[randrange(len(choices))+1])
