
get /aggregates/products/{siteid}/{productid}

    Fetch aggregate product statistics for a single product.

Implementation Notes

This endpoint will return aggregated product feedback statistics for a single product.
Parameters
Parameter 	Value 	Description 	Parameter Type 	Data Type
siteid 		

The SiteId you are requesting statistics for
	path 	integer
productid 		

The product or you are requesting statistics for
	path 	integer
token 		

Your API token.
	query 	string
xml 	

If true, this will return an XML tree instead of a JSON response.
	query 	boolean
Response Messages
HTTP Status Code 	Reason 	Response Model 	Headers
200 	

Success - A JSON object with statistics will be returned
	
	
403 	

Not Authorized - Your token is probably incorrect.
	
	
404 	

Not Found - We could not find that product or parent ID.
	
	
Hide Response
Curl

curl -X GET --header 'Accept: application/json' 'https://api.shopperapproved.com/aggregates/products/14431/3699?token=KhQxb0dP&xml=false'

Request URL

https://api.shopperapproved.com/aggregates/products/14431/3699?token=KhQxb0dP&xml=false

Response Body

{
  "certificate_url": "https://www.shopperapproved.com/reviews/product/thetreecenter.com/Thuja+Green+Giant/3699",
  "product_totals": {
    "total_reviews": 234,
    "average_rating": 4.15,
    "total_with_comments": 234
  }
}

Response Code

200
