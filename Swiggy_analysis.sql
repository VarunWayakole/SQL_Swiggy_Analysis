SELECT * FROM swiggy LIMIT 5;

-- Q1. HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?
SELECT COUNT(DISTINCT restaurant_name) AS high_rated_restaurants
FROM swiggy
WHERE rating > 4.5;

-- Q2. WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?
SELECT 
	city,
    COUNT(DISTINCT restaurant_name) AS no_of_restaurants
FROM swiggy
GROUP BY city
ORDER BY no_of_restaurants DESC
LIMIT 1;

-- Q3. HOW MANY RESTAURANTS SELL( HAVE WORD "PIZZA" IN THEIR NAME)?
SELECT 
	COUNT(DISTINCT restaurant_name) AS pizza_restaurants
FROM swiggy
WHERE restaurant_name REGEXP 'pizza';

-- Q4. WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?
SELECT
	cuisine,
	COUNT(*) AS most_common_cuisine
FROM swiggy
GROUP BY cuisine
ORDER BY most_common_cuisine DESC
LIMIT 1;

-- Q5. WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?
SELECT 
	city,
	AVG(rating) AS average_rating
FROM swiggy
GROUP BY city;

-- Q6. WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?
SELECT 
	DISTINCT restaurant_name,
    menu_category,
	MAX(price) AS highest_price
FROM swiggy
WHERE menu_category = 'Recommended'
GROUP BY restaurant_name, menu_category;

-- Q7. FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE. 
SELECT 
	DISTINCT restaurant_name,
    cost_per_person
FROM swiggy
WHERE cuisine <> 'Indian'
ORDER BY cost_per_person DESC
LIMIT 5;

-- Q8. FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL    
--     RESTAURANTS TOGETHER.
SELECT
	DISTINCT restaurant_name,
    cost_per_person
FROM swiggy
WHERE cost_per_person > (
	SELECT 
		AVG(cost_per_person)
	FROM swiggy
);

-- Q9. RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.
SELECT 
	DISTINCT t1.restaurant_name,
    t1.city,
    t2.city
FROM swiggy t1
JOIN swiggy t2
ON t1.restaurant_name = t2.restaurant_name AND t1.city <> t2.city;

-- Q10. WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?
SELECT 
	restaurant_name,
    menu_category,
    COUNT(item) AS no_of_items
FROM swiggy
WHERE menu_category = 'Main Course'
GROUP BY restaurant_name, menu_category
ORDER BY no_of_items DESC
LIMIT 1;

-- Q11. LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME
SELECT 
	restaurant_name,
    COUNT(CASE WHEN veg_or_nonveg = 'Veg' THEN 1 END) * 100 / COUNT(*) AS vegeterian_percentage
FROM swiggy
GROUP BY restaurant_name
HAVING vegeterian_percentage = 100.00
ORDER BY restaurant_name;

-- Q12. WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?
SELECT 
	restaurant_name,
    AVG(price) AS average_price
FROM swiggy
GROUP BY restaurant_name
ORDER BY average_price
LIMIT 1;

-- Q13. WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?
SELECT 
	restaurant_name,
    COUNT(DISTINCT menu_category) AS no_of_categories
FROM swiggy
GROUP BY restaurant_name
ORDER BY no_of_categories DESC
LIMIT 5;

-- Q14. WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?
SELECT 
	restaurant_name,
    COUNT(CASE WHEN veg_or_nonveg = 'Non-veg' THEN 1 END) * 100 / COUNT(*) AS non_veg_percentage
FROM swiggy
GROUP BY restaurant_name
ORDER BY non_veg_percentage DESC
LIMIT 1;

-- Q15. Determine the Most Expensive and Least Expensive Cities for Dining:
WITH city_expense AS (
	SELECT
		city,
        MAX(cost_per_person) AS max_cost,
        MIN(cost_per_person) AS min_cost
	FROM swiggy
    GROUP BY city
)
SELECT 
	city,
    max_cost,
    min_cost
FROM city_expense
ORDER BY max_cost DESC;

-- 16. Calculate the Rating Rank for Each Restaurant Within Its City
WITH rating_rank_by_city AS (
	SELECT 
		DISTINCT restaurant_name,
        city,
        rating,
        DENSE_RANK() OVER(PARTITION BY city ORDER BY rating DESC) rating_rank
	FROM swiggy
)
SELECT 
	restaurant_name,
    city,
    rating,
    rating_rank
FROM rating_rank_by_city;

