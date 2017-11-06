import time

def register_author(arguments, client):
    cursor = client.cursor()
    if len(arguments) != 5:
        print("invalid format, register author <fname> <lname> <email> <address> <affiliation>")
        return False
    #insert affiliation if not existed
    affiliations = "SELECT name FROM Affiliation"
    cursor.execute(affiliations)
    
    if arguments[4] not in cursor:
        cmd1 = "INSERT INTO Affiliation (name) VALUES ('%s')" % (arguments[4])
        cursor.execute(cmd1)
        client.commit()
    
    #insert address if not already existed
    cmd2 = ""
    temp = arguments[3].split(",")

    if len(temp) == 5:
        cmd2 = "INSERT INTO Address (street, city, state, zip_code, country) VALUES (%s, %s, %s, %s, %s)" 
        args2 = (temp[0],temp[1],temp[2],temp[3],temp[4])
        cursor.execute(cmd2,args2)
    elif len(temp)== 6:
        cmd2 = "INSERT INTO Address (street, street_2, city, state, zip_code, country) VALUES (%s, %s, %s, %s, %s, %s)"
        args2 = (temp[0],temp[1],temp[2],temp[3],temp[4],temp[5])
        cursor.execute(cmd2,args2)
    else: 
        print("your input of address is not correct, must include street,city,state,zip_code,country")
    client.commit()


    cursor.execute("SELECT max(id_address) from Address")
    id_add = cursor.fetchone()[0]
    cursor.execute("SELECT max(id_affiliation) from Affiliation")
    id_affi = cursor.fetchone()[0]

    cmd3 = "INSERT INTO Author (first_name, last_name, emai, id_address, id_affiliation) VALUES(%s, %s, %s, %s, %s)"
    args3 = (arguments[0], arguments[1],arguments[2], id_add, id_affi)

    cursor.execute(cmd3,args3)
    client.commit()
    cursor.close()
    return True

def submit(LOGGED_IN_USER_ID,arguments, client):
# <title> <Affiliation> <RICode> <author2> <author3> <author4> <filename>
    if len(arguments) < 4:
        print("invalid format, submit <title> <Affiliation> <RICode> <author2> <author3> <author4> <filename>")
        return False
    cursor = client.cursor()

    #the id of manuscript start from 100
    cursor.execute("SELECT max(id_manuscript) from Manuscript")
    id_manu = cursor.fetchone()[0]+1;
    cur_date = time.strftime("%Y-%m-%d %H:%M:%S") 

    #insert manuscript into Manuscript
    cmd3 = "INSERT INTO Manuscript (title, status, date_received, date_last_status_changed, RI_code, file) VALUES (%s,%s,%s,%s,%s,%s)"
    args3 = (arguments[0],0,cur_date,cur_date,arguments[2],arguments[-1])
    cursor.execute(cmd3, args3)

    # insert himself as primary author into Manuscript_Authors
    cmd1 = "INSERT INTO Manuscript_Authors (id_manuscript, id_author, author_order) VALUES(%s,%s,%s)"
    args1 = (id_manu,LOGGED_IN_USER_ID,1)
    client.commit()

    #insert other author id and author order into Manuscript_Authors
    if(len(arguments)>4):
        for i in range(3,len(arguments)-1):
            name_sep = arguments[i].split(" ")
            if len(name_sep)<2:
                print("The input name format is incorrect, please put the first_name and last_name")
                return False
            statement = "SELECT id_author FROM Author WHERE Author.first_name = %s and Author.last_name = %s"
            args = (name_sep[0],name_sep[1])
            cursor.execute(statement, args)

            id_author = cursor.fetchone()[0]
            cmd2 = "INSERT INTO Manuscript_Authors (id_manuscript, id_author, author_order) VALUES(%s,%s,%s)"
            args2 = (id_manu,id_author,i-1)
            cursor.execute(cmd2, args2)
            client.commit()
    print("Your manuscript is submitted successfully")
    client.commit()
    cursor.close()
    return True
    

def show_status(LOGGED_IN_USER_ID,client):
    cursor = client.cursor()
    print ("Report of all manuscripts with author id %s as primary author " % LOGGED_IN_USER_ID)
    cursor.execute("SELECT Manuscript.id_manuscript,Manuscript.status,Manuscript.title,Manuscript.date_last_status_changed FROM Manuscript INNER JOIN Manuscript_Authors WHERE Manuscript.id_manuscript = Manuscript_Authors.id_manuscript AND Manuscript_Authors.author_order = 1 AND Manuscript_Authors.id_author = %s" % (LOGGED_IN_USER_ID))
    for row in cursor:
        print(row)
    client.commit()
    cursor.close()
    return True


def retract(arguments, client):
    cursor = client.cursor()
    id_man = arguments[0]
    cursor.execute("SELECT id_manuscript FROM Manuscript_Authors WHERE Manuscript_Authors.id_manuscript = %s AND Manuscript_Authors.id_author = %s" %(id_man,id_man))
    temp = list()
    for row in cursor:
        temp.append(int(row[0]))
    print(temp)
    print(id_man)
    if int(id_man) not in temp:
        print("the manuscript id you entered is not in our system or you don't have accessibility to this manuscript")
        return True
    else:
        cursor.execute("SELECT status FROM Manuscript WHERE id_manuscript = %s" % (id_man))
        stat = cursor.fetchone()[0];
        print(stat)
        if stat < 4:
            #retract
            #remove author info from manuscript_author
            cursor.execute("DELETE FROM Manuscript_Authors WHERE id_manuscript = %s" % (id_man))
            cursor.execute("DELETE FROM Review_Decision WHERE id_manuscript = %s" % (id_man))
            client.commit()

            #remove manuscript
            cursor.execute("DELETE FROM Manuscript WHERE id_manuscript = %s" % (id_man))

            print ("Your manuscript was retracted successfully.")
            cursor.execute("SELECT * FROM Manuscript")
            #show the manuscript table after deletion
            print("The manuscript remained in system are:")
            for row in cursor:
                print(row[0],row[1],row[2],row[3])
        else:
            print ("Sorry, the manuscript you want to retract has been sent for typesetting.")
        cursor.close()
        return True

