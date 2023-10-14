
get /products/reviews/{siteid}

    Fetches product reviews.

Implementation Notes

This route will pull in all product reviews matching the provided parameters. By default it will pull 100 reviews at a time.
Parameters
Parameter 	Value 	Description 	Parameter Type 	Data Type
siteid 		

The site ID you are requesting product reviews for.
	path 	integer
token 		

Your API token
	query 	string
asArray 	

If true, this will return the response as a JSON arry as opposed to the standard JSON object. (Enclosed in [] as opposed to {}.)
	query 	boolean
limit 		

How many reviews you want returned in the response. Larger numbers may cause a timeout.
	query 	integer
page 		

Which page you would like to request. The offset will be calculated by limit * page
	query 	integer
from 		

The date you would like to start the query with. Should be given in YYYY-MM-DD format. Defaults to 30 days prior to the current day.
	query 	string
to 		

The date you would like to end the query with. Should be given in YYYY-MM-DD format. Defaults to the current date.
	query 	string
sort 	

How you would like to sort the reviews.
	query 	string
removed 	

Include removed reviews? If set to 1 then reviews will include a 'removed' value equal to 1 if the review was removed and 0 if the review is active.
	query 	integer
xml 	

If true, this will return an XML tree instead of a JSON response.
	query 	boolean
Response Messages
HTTP Status Code 	Reason 	Response Model 	Headers
200 	

Success - a JSON object with your product reviews will be returned.
	
	
403 	

Not Authorized - Either your site ID/token combination is incorrect or your site does not have product reviews.
	
	
422 	

Bad Request - One of your parameters was probably malformed.
	
	
500 	

Error - Something else went wrong. A bug report is automatically submitted.
	
	
Hide Response
Curl

curl -X GET --header 'Accept: application/json' 'https://api.shopperapproved.com/products/reviews/14431?token=KhQxb0dP&limit=100&xml=false'

Request URL

https://api.shopperapproved.com/products/reviews/14431?token=KhQxb0dP&limit=100&xml=false

Response Body

{
  "84339225": {
    "product_review_id": 84339225,
    "display_name": "KAREN WALTS",
    "email_address": "KARENWALTSR357@YAHOO.COM",
    "order_id": "749523",
    "review_date": "Mon, 11 Sep 2023 13:07:48 GMT",
    "last_modified": "Mon, 11 Sep 2023 17:05:16 GMT",
    "product_id": "474521",
    "product": "Ginger Wine® Ninebark - #3 Container",
    "rating": 4.8,
    "comments": "THANK YOU SO MUCH FOR THE BEAUTIFUL NINE BARKER IT WAS PACKED GREAT AND PLANTED IT THE DAY I GOT IT THANK YOU",
    "date": "Mon, 11 Sep 2023 13:07:48 GMT",
    "visible_to_public": 1,
    "heading": "",
    "verified": 1,
    "response": null,
    "location": "INDIANA,united states",
    "custcareopen": 0
  },
  ...
}

Response Code

200

Response Headers

{
  "access-control-allow-origin": "*",
  "alt-svc": "h3=\":443\"; ma=86400",
  "cf-cache-status": "DYNAMIC",
  "cf-ray": "813fcb61dd3a4cf5-BOS",
  "content-encoding": "br",
  "content-type": "application/json",
  "date": "Tue, 10 Oct 2023 15:11:12 GMT",
  "server": "cloudflare",
  "x-firefox-http3": "h3"
}


