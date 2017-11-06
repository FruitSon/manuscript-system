
AUTHOR_TYPE = "AUTHOR"
EDITOR_TYPE = "EDITOR"
REVIEWER_TYPE = "REVIEWER"


def login(arguments, client):
    cursor = client.cursor()
    if arguments:
        unparsed_userid = arguments[0]
        try:
            user_id = unparsed_userid[:-1]
            type = unparsed_userid[-1:]
            if type.upper() == "A":
                pending_type = AUTHOR_TYPE
                statement = "SELECT * FROM Author WHERE id_author = " + user_id
            elif type.upper() == "R":
                pending_type = REVIEWER_TYPE
                statement = "SELECT * FROM Reviewer WHERE id_reviewer = " + user_id
            elif type.upper() == "E":
                pending_type = EDITOR_TYPE
                statement = "SELECT * FROM Editors WHERE id_editor = " + user_id
            # invalid user type specified as part of login
            else:
                return False
            # execute query
            cursor.execute(statement)
            count = 0
            for row in cursor:
                count += 1
                print("Hello " + row[1] + " " + row[2])
            cursor.close()
            if count:
                # set user id
                logged_in_user = user_id
                # set user type
                logged_in_type = pending_type
                return (logged_in_user, logged_in_type)
            else:
                print("Invalid account specified")
                return False
        # an error occurred while parsing the input
        except:
                return False