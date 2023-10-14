
post /reviews/{siteid}

    Create a new review entry.

Implementation Notes

This API endpoint is used to ingest a Order, Email, and Follow-up Date so that the Shopper Approved system will send a survey request using that data. You cannot submit reviews to this endpoint. Abuse of this endpoint could result in removal of the ability to use the Shopper Approved API. Only send a single review per call.
Parameters
Parameter 	Value 	Description 	Parameter Type 	Data Type
siteid 		

The SiteID for which you are creating an entry.
	path 	integer
token 		

Your API token.
	formData 	string
name 		

The customer's name. If not provided, will be saved as "Anonymous Customer"
	formData 	string
orderid 		

The unique Order ID. If not unique and not test, a 419 erorr will be returned.
	formData 	string
products 		

A comma separated list of product ids (no spaces after the commas) to be attached to the review.
	formData 	string
email 		

The customer's email. Must be provided so that the follow up email may be sent.
	formData 	string
followup 		

The date in YYYY-MM-DD format that the customer should receive the follow-up email.
	formData 	string
test 	

Whether or not this review entry should be considered a test. Allows for duplicate order IDs, review will never be public.
	formData 	boolean
custom_questions 		

A JSON encoded object of custom question headers and their responses.
	formData 	string
xml 	

If true, this will return an XML tree instead of a JSON response.
	query 	boolean
Response Messages
HTTP Status Code 	Reason 	Response Model 	Headers
201 	

The review was successfully created.
	
	
403 	

Not Authorized - Your siteID was not found or your token was incorrect.
	
	
419 	

Conflict - A non-test order already exists with the provided orderID.
	
	
422 	

Bad Request - You were either missing a parameter or one of them was malformed.
	
	
500 	

Error - Something else went wrong. A bug report is automatically sent if this ever occurs.
	
	

