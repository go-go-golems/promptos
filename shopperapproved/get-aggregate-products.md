
get /aggregates/products/{siteid}

    Fetch aggregate product statistics for your site

Implementation Notes

This endpoint will return aggregated product feedback statistics for the lifetime of your Shopper Approved account as well as aggregates for all of your products.
Parameters
Parameter 	Value 	Description 	Parameter Type 	Data Type
siteid 		

The SiteId you are requesting statistics for
	path 	integer
token 		

Your API token.
	query 	string
by_match_key 	

If true, this will display your product aggregate information by a matching key such as SKU or MPN. Results vary by site, only use this if you're confident it is what you need
	query 	boolean
asArray 	

If true, this will return the response as a JSON arry as opposed to the standard JSON object. (Enclosed in [] as opposed to {}.)
	query 	boolean
siteOnly 	

If true, this will return only the site_totals object and leave out specifics about each product.
	query 	boolean
xml 	

If true, this will return an XML tree instead of a JSON response.
	query 	boolean
fastmode 	

If true, use a highly optimized query. However, by_match and as_array will always be ignored in this mode.
	query 	boolean
Response Messages
HTTP Status Code 	Reason 	Response Model 	Headers
200 	

Success - A JSON object with statistics will be returned
	
	
403 	

Not Authorized - Your token is probably incorrect.
	
	
Hide Response
Curl

curl -X GET --header 'Accept: application/json' 'https://api.shopperapproved.com/aggregates/products/14431?token=KhQxb0dP&xml=false&fastmode=false'

Request URL

https://api.shopperapproved.com/aggregates/products/14431?token=KhQxb0dP&xml=false&fastmode=false

Response Body

{
  "site_totals": {
    "total_reviews": 4870,
    "average_rating": 4.005156,
    "total_with_comments": 4870
  },
  "product_totals": {
    "3699": {
      "total_reviews": 234,
      "average_rating": 4.15,
      "total_with_comments": 234
    },
    "3701": {
      "total_reviews": 103,
      "average_rating": 4.44,
      "total_with_comments": 103
    },
    ...
  }
}

Response Code

200

Response Headers

{
  "access-control-allow-origin": "*",
  "alt-svc": "h3=\":443\"; ma=86400",
  "cache-control": "max-age=14400",
  "cf-cache-status": "MISS",
  "cf-ray": "813ff4f67e1d3bab-BOS",
  "content-encoding": "br",
  "content-type": "application/json",
  "date": "Tue, 10 Oct 2023 15:39:35 GMT",
  "last-modified": "Tue, 10 Oct 2023 15:39:35 GMT",
  "server": "cloudflare",
  "vary": "Accept-Encoding",
  "x-firefox-http3": "h3"
}


