Loops is tool for visualizing data maintained in a Google document. None of the data rendered is stored in any way. Data is retrieved using Google credentials, but never stored in any way. In the future we may log the user ids of people who use the app, but for now nothing at all is tracked.

Data format is as follows:

Worksheet 1:
* Name the worksheet the name of the hierarchical company
* Top row is labels: 
** Name
** Title
** View (Positive, Negative, Neutral)
** Reports To
** Notes

Only the name is required.

Worksheet 2:
* Name the worksheet the name of the consulting company
* Top row is labels:
** Name
** Title
** Project (not currently used)

Worksheet 3:
* Name of worksheet doesn't matter.
* Columns A and B are two things that are connected, including:
** People from worksheet 1
** People from worksheet 2
** The projects listed on worksheet 2 (forthcoming)
** The name of worksheet 1 (hierarchical company name)
** The name of worksheet 2 (company name)
* Relationship Type (any value, "Reports To" is a special value to add a hierarchical relationship)

Heroku: young-eyrie-4632