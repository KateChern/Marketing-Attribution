#the number of distinct campaigns CoolTShirts uses
select count(distinct utm_campaign)
from page_visits;

# the number of distinct campaigns CoolTShirts uses
select count(distinct utm_source)
from page_visits;

# how they are related
select distinct utm_campaign, utm_source
from page_visits;

# The pages are on the CoolTShirts website
select distinct page_name
from page_visits;

# The number of users on each page
SELECT page_name, count(user_id) 
from page_visits
group by 1;

# How many first touches is each campaign responsible for
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
    
    ft_attr AS (
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign
FROM first_touch  as ft
JOIN page_visits  as pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)
    
    select ft_attr.utm_source,
    ft_attr.utm_campaign,
    count (*)
    from ft_attr
    group by 1, 2
    order by 3 desc;

 # How many last touches is each campaign responsible for   
    WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
      where page_name = '4 - purchase'
    GROUP BY user_id),
    
    last_attr AS (
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign
FROM last_touch  as lt
JOIN page_visits  as pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)

    select last_attr.utm_source,
    last_attr.utm_campaign,
    count (*)
    from last_attr
    group by 2
    order by 3 desc;