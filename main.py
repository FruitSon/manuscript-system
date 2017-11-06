import mysql.connector
from editor import editor
from author import author
from reviewer import reviewer
from generic.generic import login

LOGGED_IN_USER_ID = None
LOGGED_IN_USER_TYPE = None
AUTHOR_TYPE = "AUTHOR"
EDITOR_TYPE = "EDITOR"
REVIEWER_TYPE = "REVIEWER"


def dispatch(command, arguments, mysql_client):
    """
    Dispatches the command and arguments to the appropriate static function

    :param command: command name, i.e. login or register
    :param arguments: arguments to pass to command
    :param mysql_client: MySQL client
    :return: Boolean indicating whether command was successful
    """
    global LOGGED_IN_USER_ID
    global LOGGED_IN_USER_TYPE
    result = None
    temp_cmd = command.split(" ")
    if len(temp_cmd) == 2 and temp_cmd[0].upper() == "REGISTER":
        if temp_cmd[1].upper() == "AUTHOR":
            result = author.register_author(arguments, mysql_client)
        elif temp_cmd[1].upper() == "EDITOR":
            result = editor.register_editor(arguments, mysql_client)
        elif temp_cmd[1].upper() == "REVIEWER":
            result = reviewer.register_reviewer(arguments, mysql_client)
        else:
            print(temp_cmd[0]+","+temp_cmd[1])
            print ("The type of user you want to register is invaild.")
    elif command.upper() == "LOGIN":
        result = login(arguments, mysql_client)
        if result:
            LOGGED_IN_USER_ID = result[0]
            LOGGED_IN_USER_TYPE = result[1]
    elif LOGGED_IN_USER_TYPE == AUTHOR_TYPE:
        if command.upper() == "SUBMIT":
            result = author.submit(LOGGED_IN_USER_ID,arguments, mysql_client)
        elif command.upper() == "STATUS":
            result = author.show_status(LOGGED_IN_USER_ID, mysql_client)
        elif command.upper() == "RETRACT":
            double_check = input("are you sure (yes/no) ?")
            if double_check.upper() == "YES":
                result = author.retract(arguments, mysql_client)
            else:
                print("Never mind")
                result = True
    elif LOGGED_IN_USER_TYPE == EDITOR_TYPE:
        if command.upper() == "STATUS":
            result = editor.status(arguments, mysql_client)
        elif command.upper() == "REGISTER":
            result = editor.register_editor(arguments, mysql_client)
        elif command.upper() == "ASSIGN":
            result = editor.assign_reviewer(arguments, mysql_client)
        elif command.upper() == "REJECT":
            result = editor.reject(arguments, mysql_client)
        elif command.upper() == "ACCEPT":
            result = editor.accept(arguments, mysql_client)
        elif command.upper() == "TYPESET":
            result = editor.typeset(arguments, mysql_client)
        elif command.upper() == "SCHEDULE":
            result = editor.schedule(arguments, mysql_client)
        elif command.upper() == "PUBLISH":
            result = editor.publish(arguments, mysql_client)
    elif LOGGED_IN_USER_TYPE == REVIEWER_TYPE:
        if command.upper() == "RESIGN":
            result = reviewer.resign(LOGGED_IN_USER_ID, mysql_client)
    else:
        print("Please login.")
    if not result:
        print("An error has occurred, please check your formatting")


if __name__ == "__main__":
    server = "127.0.0.1"
    user = "root"
    password = ""
    database = "ruizhen_db"
    mysql_client = mysql.connector.connect(user=user, password=password,
                                           host=server,
                                           database=database)
    done = False
    while not done:
        user_input = input("Please enter a command: ")
        # User input is semicolon delimited
        split = user_input.split(";")
        trimmed_argument_list = list()
        for elem in split:
            trimmed_argument_list.append(elem.strip())
            # trim arguments
        command = trimmed_argument_list[0]
        arguments = trimmed_argument_list[1:]
        dispatch(command, arguments, mysql_client)
