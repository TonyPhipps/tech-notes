Determine if SQL is possible at all
- Use a single quote ```'``` or ```"``` in a single field. Be sure to provide any characters in other required fields to avoid an error that is checked before passing your single character.

Attempt to Remove Password Check
Adding a SQL comment via ```--``` comments the remaining portion of the backend SQL query. However, for this to work on most databases, a space must be included both before and after the double hyphen. MariaDB and MySQL can also use a # character for comments. This approach doesn't require spaces, but ``` -- ``` is part of the SQL standard for all relational databases. 
- Name: ```' or 1=1; -- ```
  - The desire here is to have the system log you in as the first available user in the database, which could very well be admin.
- Name: ```admin'; -- ```
  - The desire here is to find a user but comment-out checking for the password match.

Consider using sqlmap (Linux) on apps confirmed to be vulnerable to sql injection.