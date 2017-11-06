def register_reviewer(arguments, client):
    cursor = client.cursor()
    if len(arguments) < 3:
        print("invalid format, register author <fname> <lname> <email> <address> <affiliation>")
        return False
    cmd2 = ""
    args2 = list()
    
    cursor.execute("SELECT max(id_reviewer) from Reviewer")
    id_review = cursor.fetchone()[0]+1

    for i in range(2,len(arguments)):
    	print(arguments[i])
    	if int(arguments[i]) < 1 or int(arguments[i]) > 124:
    		print("The interest code you entered is unknown, it must between 1 to 124")
    		return False

    if len(arguments) == 3: 
    	cmd2 = "INSERT INTO Reviewer_Interest (id_reviewer,interest_code_1) VALUES (%s,%s)"
    	args2 = (id_review,arguments[2])
    elif len(arguments) == 4:
    	cmd2 = "INSERT INTO Reviewer_Interest (id_reviewer,interest_code_1,interest_code_2) VALUES (%s,%s,%s)"
    	args2 = (id_review,arguments[2],arguments[3])
    elif len(arguments) == 5:
    	cmd2 = "INSERT INTO Reviewer_Interest (id_reviewer,interest_code_1,interest_code_2,interest_code_3) VALUES (%s,%s,%s,%s)"
    	args2 = (id_review,arguments[2],arguments[3],arguments[4])


    cursor.execute(cmd2,args2)
    client.commit()

    cmd1 = "INSERT INTO Reviewer (first_name, last_name, enabled) VALUES (%s, %s, %s)"
    args1 = (arguments[0], arguments[1], 1)

    cursor.execute(cmd1, args1)
    client.commit()

    print ("The reviewer "+arguments[0]+" "+arguments[1]+" has been registered.")
    print ("The reviewers registered in system are:")

    cursor.execute("SELECT * FROM Reviewer")
    for row in cursor:
    	print(row)
    return True

def resign(LOGGED_IN_USER_ID, client):
	print("Thank you for your service.")
	cursor = client.cursor()
	cursor.execute("DELETE FROM Review_Decision WHERE id_reviewer = %s" % (LOGGED_IN_USER_ID))
	client.commit()
	cursor.execute("DELETE FROM Reviewer WHERE id_reviewer = %s" % (LOGGED_IN_USER_ID))
	client.commit()
	return True