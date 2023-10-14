    get /products/reviews/{siteid}

        Fetches product reviews.

    get /products/reviews/{siteid}/{productid}

        Fetch reviews for a given product or parent ID.
    Implementation Notes

    This endpoint will fetch all reviews for a given product or parent ID. Using a parent ID will return reviews for all products with that parent ID. By default it will pull 100 reviews at a time. By defaul removed reviews will not be included in the result.
    Parameters
    Parameter 	Value 	Description 	Parameter Type 	Data Type
    siteid 		

    The Site ID you are requesting the review for.
    	path 	integer
    asArray 	

If true, this will return the response as a JSON arry as opposed to the standard JSON object. (Enclosed in [] as opposed to {}.)
	query 	boolean
productid 		

The product ID or parent ID you would like reviews for.
	path 	string
token 		

Your API token.
	query 	string
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

Success - a JSON object for your reviews will be returned.
	
	
403 	

Not authorized - your token is probably incorrect.
	
	
404 	

Not found - we couldn't find any reviews for the given product/parent ID.
	
	
500 	

Error - Something else went wrong. A bug report is automatically sent if this ever occurs.
	
	
Hide Response
Curl

curl -X GET --header 'Accept: application/json' 'https://api.shopperapproved.com/products/reviews/14431/3699?token=KhQxb0dP&limit=100&xml=false'

Request URL

https://api.shopperapproved.com/products/reviews/14431/3699?token=KhQxb0dP&limit=100&xml=false

Response Body

{
  "84375653": {
    "review_id": 84375653,
    "display_name": "Pam                 ",
    "date": "Tue, 12 Sep 2023 01:25:08 GMT",
    "product_id": "3699",
    "rating": 5,
    "comments": "Beautiful packed, presentation is impressive, plants healthy , one was slightly bent",
    "public": 1,
    "response": null,
    "location": "KY,United States",
    "custcareopen": 0
  },
  "84670124": {
    "review_id": 84670124,
    "display_name": "Michelle L Lamers",
    "date": "Wed, 20 Sep 2023 15:02:47 GMT",
    "product_id": "3699",
    "rating": 5,
    "comments": "Came packaged safe for travel was awesome.  Good an healthy.  Good directions for what to do as soon as you get it up to planting and care.  Great company to work with.",
    "public": 1,
    "response": null,
    "location": "united states",
    "custcareopen": 0
  },
  "85248937": {
    "review_id": 85248937,
    "display_name": "Truitt Armstrong",
    "date": "Wed, 27 Sep 2023 21:01:47 GMT",
    "product_id": "3699",
    "rating": 1,
    "comments": "Not sure what happened with this one I&rsquo;ve gotten some different specimen, that of thrived not sure what happen with this one",
    "public": 1,
    "response": null,
    "location": "united states",
    "custcareopen": 0
  }
}

Response Code

200

Response Headers

{
  "access-control-allow-origin": "*",
  "alt-svc": "h3=\":443\"; ma=86400",
  "cf-cache-status": "DYNAMIC",
  "cf-ray": "813c643419874cde-BOS",
  "content-encoding": "br",
  "content-type": "application/json",
  "date": "Tue, 10 Oct 2023 05:16:28 GMT",
  "server": "cloudflare",
  "x-firefox-http3": "h3"
}
