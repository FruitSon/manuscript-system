import time

from generic import paper_status


def register_editor(arguments, client):
    """
    Register a new editor

    :param arguments:
    :param cursor:
    :return:
    """
    cursor = client.cursor()
    if len(arguments) != 3:
        print("invalid format, register editor <fname> <lname>")
        return False
    statement = "INSERT INTO Editors (first_name, last_name) VALUES (%s, %s)"
    args = (arguments[1], arguments[2])
    cursor.execute(statement, args)
    client.commit()
    statement = "SELECT id_editor FROM editors WHERE first_name = %s AND last_name = %s LIMIT 1"
    cursor.execute(statement, args)
    for row in cursor:
        print("Editor userid created and is " + str(row[0]) + "e")
    cursor.close()
    return True


def status(arguments, client):
    """
    Editor status command

    :param arguments:
    :param cursor:
    :return:
    """
    # arguments should be empty
    if not len(arguments):
        cursor = client.cursor()
        statement = "SELECT man.title, decis.decision FROM REVIEW_DECISION decis \
                    INNER JOIN MANUSCRIPT man ON man.id_manuscript = decis.id_manuscript \
                    ORDER BY decision, decis.id_manuscript"
        cursor.execute(statement)
        for row in cursor:
            print(row)
        cursor.close()
        return True
    print("invalid format, status")
    return False


def assign_reviewer(arguments, client):
    """
    assign <manu#> <reviewer id>

    :param arguments:
    :return:
    """
    if len(arguments) != 2:
        print("invalid format, assign <manu#> <reviewer id>")
        return False
    cursor = client.cursor()
    try:
        manuscript_id = arguments[0]
        statement = "SELECT id_reviewer FROM REVIEW_DECISION WHERE id_manuscript = " + manuscript_id
        cursor.execute(statement, manuscript_id)
        for row in cursor:
            cursor.close()
            print("Paper has already been assigned a reviewer!")
            return False
        reviewer_id = arguments[1]
        statement = "INSERT INTO REVIEW_DECISION (id_manuscript, id_reviewer, date_assigned) VALUES (%s, %s, %s)"
        args = (manuscript_id, reviewer_id, time.strftime('%Y-%m-%d %H:%M:%S'))
        cursor.execute(statement, args)
        statement = "UPDATE MANUSCRIPT SET status = %s WHERE id_manuscript = %s"
        args = (paper_status.IN_REVIEW, manuscript_id)
        cursor.execute(statement, args)
        client.commit()
        cursor.close()
        return True
    except:
        cursor.close()
        return False


def reject(arguments, client):
    """
    reject <manu#>
    Rejects a mnuscript

    :param arguments:
    :param client:
    :return:
    """
    if not len(arguments) == 1:
        print("invalid format, reject <manuscript #>")
        return False
    cursor = client.cursor()
    manuscript_id = arguments[0]
    statement = "UPDATE MANUSCRIPT SET status = %s, date_last_status_changed = %s WHERE id_manuscript = %s"
    args = (paper_status.REJECTED, time.strftime('%Y-%m-%d %H:%M:%S'), manuscript_id)
    try:
        cursor.execute(statement, args)
        client.commit()
        cursor.close()
    except:
        cursor.close()
        return False
    cursor.close()
    print("Rejected Manuscript ID: " + manuscript_id)
    return True


def accept(arguments, client):
    """
    accept <manu#>
    Accepts a mnuscript

    :param arguments:
    :param client:
    :return:
    """
    if not len(arguments) == 1:
        print("invalid format, reject <manuscript #>")
        return False
    cursor = client.cursor()
    manuscript_id = arguments[0]
    statement = "UPDATE MANUSCRIPT SET status = %s, date_last_status_changed = %s WHERE id_manuscript = %s"
    args = (paper_status.ACCEPTED, time.strftime('%Y-%m-%d %H:%M:%S'), manuscript_id)
    try:
        cursor.execute(statement, args)
        client.commit()
        cursor.close()
    except:
        cursor.close()
        return False
    cursor.close()
    print("Accepted Manuscript ID: " + manuscript_id)
    return True


def typeset(arguments, client):
    """
    typeset <manu#> <pp>

    :param arguments:
    :param client:
    :return:
    """
    if not len(arguments) == 2:
        print("invalid format, typeset <manu#> <pp>")
        return False
    cursor = client.cursor()
    manuscript_id = arguments[0]
    number_of_pages = arguments[1]
    statement = "UPDATE MANUSCRIPT SET status = %s WHERE id_manuscript = %s"
    args = (paper_status.TYPESET, manuscript_id)
    try:
        cursor.execute(statement, args)
        client.commit()
    except:
        cursor.close()
        return False
    # Insert new typesetting record
    statement = "INSERT INTO MANUSCRIPT_PUBLICATION (id_manuscript, typeset, number_of_pages, issue_num) VALUES (%s, %s, %s, %s)"
    args = (manuscript_id, 1, number_of_pages, paper_status.UNASSIGNED_ISSUE_NUM)
    try:
        cursor.execute(statement, args)
        client.commit()
    except Exception as err:
        print(err)
        cursor.close()
        return False
    cursor.close()
    print("Successfully typeset " + manuscript_id)
    return True


def schedule(arguments, client):
    """
    schedule <manu#> <issue>
    Schedules a manuscript to appear in an upcoming issue

    :param arguments:
    :param client:
    :return:
    """
    if not len(arguments) == 2:
        print("invalid format, schedule <manu#> <issue>")
        return False
    cursor = client.cursor()
    manuscript_id = arguments[0]
    issue = arguments[1]
    # check that ID is valid
    statement = "SELECT id_issue FROM ISSUES WHERE id_issue = " + issue
    try:
        cursor.execute(statement)
        id = None
        for row in cursor:
            id = str(row[0])
        # issue does not exist
        if not id:
            print("Issue ID does not exist, creating new issue")
            # create new issue
            statement = "INSERT INTO ISSUES (id_issue) VALUES (" + issue + ")"
            cursor.execute(statement)
            client.commit()
        # count current pages
        statement = "SELECT SUM(number_of_pages) FROM MANUSCRIPT_PUBLICATION WHERE issue_num = " + issue
        cursor.execute(statement)
        issue_page_count = 0
        for row in cursor:
            # check that row value isn't NULL
            if not row[0]:
                break
            issue_page_count = int(row[0])
        statement = "SELECT SUM(number_of_pages) FROM MANUSCRIPT_PUBLICATION WHERE id_manuscript = " + manuscript_id +" AND issue_num = " + str(paper_status.UNASSIGNED_ISSUE_NUM)
        cursor.execute(statement)
        new_total_page_count = 0
        for row in cursor:
            # check that row value isn't NULL
            if not row[0]:
                break
            new_total_page_count = int(row[0])
        new_total_page_count += issue_page_count
        # only publish if issue + new article does not exceed 100 pages
        if new_total_page_count <= 100:
            statement = "UPDATE MANUSCRIPT_PUBLICATION SET issue_num = " + issue + " WHERE id_manuscript = " + manuscript_id
            cursor.execute(statement)
            client.commit()
            # Update Manuscript Status
            statement = "UPDATE MANUSCRIPT SET status = " + str(paper_status.SCHEDULED) + " WHERE id_manuscript = " + manuscript_id
            cursor.execute(statement)
            client.commit()
            cursor.close()
            print("Successfully schedule " + manuscript_id + " for publication in issue " + issue)
            return True
        else:
            print("Issue is too large to add requested manuscript")
            cursor.close()
            return False
    except Exception as err:
        print(err)
        cursor.close()
        return False

def publish(arguments, client):
    """
    publish <issue>
    Publishes a specific issue

    :param arguments:
    :param client:
    :return:
    """
    if not len(arguments) == 1:
        print("invalid format, publish <issue>")
        return False
    cursor = client.cursor()
    issue = arguments[0]
    statement = "SELECT COUNT(*) FROM MANUSCRIPT_PUBLICATION WHERE issue_num = " + issue
    cursor.execute(statement)
    manuscripts_assigned = 0
    for row in cursor:
        if row[0]:
            manuscripts_assigned = int(row[0])
    # if manuscripts have been assigned to the issue, set manuscripts in the issue to published status
    if manuscripts_assigned:
        statement = "UPDATE MANUSCRIPT man INNER JOIN MANUSCRIPT_PUBLICATION mp ON man.id_manuscript = mp.id_manuscript SET status = " + str(paper_status.PUBLISHED) + " WHERE mp.issue_num = " + issue
        cursor.execute(statement)
        client.commit()
        statement = "UPDATE ISSUES SET publication_date = %s WHERE id_issue = " + issue
        args = (time.strftime('%Y-%m-%d %H:%M:%S'),)
        cursor.execute(statement, args)
        client.commit()
        print("Published " + issue)
        return True
    else:
        print("No manuscripts assigned to " + issue)
        cursor.close()
        return False