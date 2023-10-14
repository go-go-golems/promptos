
get /reviews/{siteid}/{reviewid}

    Fetch a single review.

Implementation Notes

This endpoiont allows you to fetch a single review either by review_id (found from the /reviews/{siteid} path) or from an order ID that was passed from your system to ours. If you have not sent us order ID information, looking up by order ID will not work.
Parameters
Parameter 	Value 	Description 	Parameter Type 	Data Type
siteid 		

The Site ID you are requesting the review for.
	path 	integer
reviewid 		

The review_id or order ID of the review you are requesting.
	path 	string
token 		

Your API token.
	query 	string
removed 	

Include removed reviews? If set to 1 then reviews will include a 'removed' value equal to 1 if the review was removed and 0 if the review is active.
	query 	integer
full_name 	

Include customer full name or abbreviate last name.
	query 	integer
xml 	

If true, this will return an XML tree instead of a JSON response.
	query 	boolean
Response Messages
HTTP Status Code 	Reason 	Response Model 	Headers
200 	

Success - a JSON entry for your review will be returned.
	
	
403 	

Not authorized - your token is properly incorrect.
	
	
404 	

Not found - we couldn't find the review for your site based on the information given.
	
	
500 	

Error - Something else went wrong. A bug report is automatically sent if this ever occurs.
	
	

