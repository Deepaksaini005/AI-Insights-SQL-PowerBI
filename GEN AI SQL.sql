CREATE DATABASE analytics_db;
USE analytics_db;

-- Data table for Users data set --
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50),
    signup_date DATE
);

-- Table for Ai models data set --
CREATE TABLE AI_Models(
    model_id INT PRIMARY KEY,
    model_name VARCHAR(100),
    provider VARCHAR(100),
    cost_per_1k_tokens DECIMAL(10,4)
);

-- Table for the prompts from dataset--
CREATE TABLE Prompts (
    prompt_id INT PRIMARY KEY,
    user_id INT,
    model_id INT,
    prompt_text TEXT,
    prompt_category VARCHAR(100),
    created_at DATETIME
);

-- Table for  the Responses  dataset-- 
CREATE TABLE Responses (
    response_id INT PRIMARY KEY,
    prompt_id INT,
    response_text TEXT,
    response_time_seconds DECIMAL(5,2),
    created_at DATETIME
);

-- Tables for the Tokens dataset --
CREATE TABLE Tokens (
    token_id INT PRIMARY KEY,
    prompt_id INT,
    input_tokens INT,
    output_tokens INT,
    total_tokens INT,
    estimated_cost DECIMAL(10,4)
);

-- Tables for the Ratings dataset --
CREATE TABLE Ratings (
    rating_id INT PRIMARY KEY,
    response_id INT,
    rating INT,
    feedback TEXT
);

-- Tables  for the User Behavior dataset
CREATE TABLE User_Behavior_Analytics (
    analytics_id INT PRIMARY KEY,
    user_id INT,
    session_duration_minutes DECIMAL(5,2),
    prompts_used INT,
    active_days INT
);

select * from users;
select * from  AI_Models;
select * from Prompts;
select * from Responses;
select * from Tokens;
select * from Ratings;
select * from  User_Behavior_Analytics;


-- users table --

select count(user_id) from users;  -- Total Users 
select count(distinct(country)) from users; -- unique countries
select distinct(industry) from users;   -- Unique industry
select sum(daily_active_minutes) from users; -- Total active minutes 
select distinct(year(signup_date)) from users; -- Total years 

-- Find the maximum daily_active_minutes for users having subscription_plan = 'pro'
SELECT subscription_plan , MAX(daily_active_minutes) AS max_active_minutes FROM users  WHERE subscription_plan = 'pro' GROUP BY subscription_plan;

-- Average active time
select subscription_plan , avg(daily_active_minutes) as avg_active_minutes from users group by subscription_plan;

-- Top active users 
select  full_name , daily_active_minutes from users order by daily_active_minutes desc limit 5;

-- Users by Country 
select country , count(user_id) as total_user from users group by country order by total_user DESC;

-- count user by month and year
select year(signup_date) as YEAR , month(signup_date) as MONTH , count(user_id)  from users group by YEAR , MONTH order by YEAR , MONTH;



-- Ai_Models  table
select * from Ai_Models;
select  count(model_name) from Ai_models;  -- Total models
select sum(cost_per_1k_tokens) as total_cost from Ai_models; -- Total cost of 5 models per 1k tokens
select model_name , provider from Ai_Models ;


-- Prompt Table 

select * from  Prompts;
select count(distinct user_id) as unique_users from Prompts;   -- user id (distinct)
select count(distinct model_id) as unique_model_id from prompts;   -- Unique model id 
select  distinct category from Prompts;  -- Categories 
select category , count(user_id) as total_users from  prompts group by category order by total_users DESC ; -- USER by Category
select max(prompt_length) from Prompts;   -- max length of the prompt

-- Category by model_ID and Success_Flag
select category , count(model_id) as model_ID , AVG(success_flag)* 100  as success_Rate  from prompts 
group by category order by model_ID , success_Rate DESC ;

-- top prompt text by prompt_length by created  at
select prompt_text , MAX(prompt_length) as prompt_Length ,  year(created_at) AS YEAR , Month(created_at) as MONTH from prompts 
group by prompt_text , year , MONTH order by prompt_length desc limit 10;	

-- Average prompt length by category 
select  category , AVG(prompt_length) as AVG_PROMPT_LENGTH from prompts group by category order by AVG_PROMPT_LENGTH DESC;

-- Monthly  Prompt trends 
select year(created_at) as YER , MONTH(created_at) as MNTH , count(prompt_id) as ID from prompts group by YER , MNTH order by YER, MNTH ;



-- Response Table 

select * from Responses ;
select  min(response_time_seconds) as MINIMUM_TIME from Responses;
select  MAX(response_time_seconds) as MAXIMUM_TIME from Responses;

-- Analyze responses by response text, response time, and quality score
SELECT prompt_id, response_text, AVG(response_time_seconds) AS avg_response_time, AVG(quality_score) AS avg_quality_score
FROM responses GROUP BY prompt_id, response_text ORDER BY avg_response_time DESC, avg_quality_score DESC limit 5; 

-- response_created by response_text 
select response_text , Year(response_created_at) as YER , MONTH(response_created_at) as MNTH from Responses
 Group by response_text , YER , MNTH order by YER , MNTH DESC limit 10; 
 
 -- resonse_status
 select distinct response_status as stats from Responses;
 
 -- Average response time  by response text 
 select response_text , AVG(response_time_seconds) as avg_time from Responses group by Response_text  order by avg_time DESC limit 15;
 
 -- Highest Quality Responses
 select  prompt_id , response_text , quality_score from Responses order by quality_score desc limit 10;
 
 
 -- Tokens table 
 select * from Tokens;
 select sum(input_tokens) as total_input_tokens  from Tokens;  -- Total input tokens
select sum(output_tokens) as total_output_tokens  from Tokens;  -- Total output tokens  
select MIN(input_tokens) as MIN_Token , MAX(input_tokens) as MAX_TOKEN from tokens ; -- MIN AND MAX input token 
select MIN(output_tokens) as MIN_Token , MAX(output_tokens) as MAX_TOKEN from tokens ; -- MIN AND MAX output tokens 
select sum(total_tokens) as total_tokens from tokens;

-- Average Token Usage
SELECT AVG(input_tokens) AS avg_input_tokens, AVG(output_tokens) AS avg_output_tokens, AVG(total_tokens) AS avg_total_tokens
FROM Tokens;

-- Cost Analysis
SELECT SUM(estimated_cost_usd) AS total_ai_cost, AVG(estimated_cost_usd) AS avg_ai_cost FROM Tokens;

-- input tokens / output tokens
select sum(input_tokens) / sum(output_tokens) as token_ratio from tokens;


-- Ratings table 

select * from Ratings;
select distinct feedback_comment from ratings;    -- Unique comments

select distinct feedback_comment , count(rating_score) as score  from ratings group by feedback_comment order by score DESC ;

-- Analyze ratings by response ID with year and month
select response_id , Year(rated_at) as YER ,  Month(rated_at) as MNTH from ratings group by response_id  , YER , MNTH order by YER , MNTH DESC ;

--  Average Rating score 
SELECT AVG(rating_score) AS avg_rating_score FROM Ratings;

-- Highest Rated Responses
SELECT response_id, rating_score FROM Ratings ORDER BY rating_score DESC LIMIT 10;


-- User Behaviour Table 

select * from  User_Behavior_Analytics;
select distinct  churn_risk from  user_Behavior_Analytics; -- Unique churn risk 
select distinct preferred_model from  user_Behavior_Analytics; -- unique preferred model 
select sum(avg_session_duration_min) as total_session  from  user_Behavior_Analytics;   -- total avg session duration min
select count(user_id) as ID from user_Behavior_Analytics; -- Total users through id
select MIN(login_count) as lowest_login , MAX(login_count) as Highest_login from user_Behavior_Analytics; -- min and max login count
select  avg(avg_session_duration_min) as avg_session_min from  user_Behavior_Analytics;

select  distinct most_used_category as category , sum(login_count) as login , sum(avg_session_duration_min) as session_duration 
from user_Behavior_Analytics  group by category order by  login DESC, session_duration DESC ;

-- Top Categories by Engagement
SELECT most_used_category , AVG(avg_session_duration_min) AS avg_engagement FROM User_Behavior_Analytics
GROUP BY most_used_category ORDER BY avg_engagement DESC;


-- user id & prompts 

select * from users;
select * from prompts;

select  u.user_id , u.full_name , u.email , u.country , u.subscription_plan , 
count(p.prompt_id) as total_prompts from users u join prompts p on u.user_id = p.user_id  group by  u.user_id, u.full_name , u.email ,
u.country , u.subscription_plan order by total_prompts desc  ;

-- Subscription Plan vs Prompt Usage
select u.subscription_plan , count(p.prompt_id) as total_prompts from users u join prompts p on u.user_id = p.user_id
group by  u.subscription_plan order by total_prompts DESC;

-- Country-wise Prompt Usage
select u.country  , count(p.prompt_id) as total_prompts  from users u join prompts p on u.user_id = p.user_id 
group by u.country order by total_prompts DESC;

-- Most Active Industries
select u.industry , count(p.prompt_id) as  total_prompts  from users u join prompts p on  u.user_id = p.user_id
group by u.industry order by  total_prompts DESC ;

-- Average Prompt Length by Subscription Plan
select u.subscription_plan , avg(p.prompt_length) as AVG_PROMPT_LENGTH  from users u join prompts p on u.user_id = p.user_id 
group by u.subscription_plan order by AVG_PROMPT_LENGTH DESC;



-- Ai_  models and prompts 
select * from  AI_Models;
select * from Prompts;

-- Success Rate by AI Model
select  a.model_name , avg(p.success_flag)*100 as Success_rate from AI_models a  join prompts p on a.model_id = p.model_id
group by  a.model_name  order by Success_rate desc ;

-- Average Prompt Length by AI Model
select a.model_name , avg(p.prompt_length) as PROMPT_LENGTH from AI_models a join prompts p on a.model_id = p.model_id 
group by a.model_name order by PROMPT_LENGTH DESC ;

-- Prompt Categories by AI Model
select a.model_name, p.category , count(p.prompt_id) as  total_prompts from Ai_models a join prompts p on a.model_id = p.model_id
group by a.model_name, p.category  order by  total_prompts DESC;



-- Prompts and Responses 
select * from Prompts;
select * from Responses;

-- Basic JOIN Query
select p.prompt_id , p.prompt_text , r.response_text from prompts p join responses r on p.prompt_id = r.prompt_id;

-- Prompt vs Response Quality
select p.prompt_text ,  r.quality_score from prompts p join responses r on p.prompt_id = r.prompt_id order by r.quality_score DESC;

-- Average Response Time by Category
select p.category , avg( r.response_time_seconds ) as avg_time from prompts p join responses r  on p.prompt_id = r.prompt_id group by p.category
order by avg_time DESC;

-- Average quality score by category 
select p.category , avg(r.quality_score) as AVG_SCORE from prompts p join responses r  on p.prompt_id = r.prompt_id group by p.category
order by AVG_SCORE DESC;

-- Fastest AI Categories
select p.category   ,MIN(r.response_time_seconds ) as fastest_response from prompts p join responses r  on p.prompt_id = r.prompt_id group by p.category
order by fastest_response DESC;

-- Response Count by Category
select p.category   , count(response_id) as total_responses from prompts p join responses r  on p.prompt_id = r.prompt_id group by p.category
order by total_responses DESC;


-- prompts / responses / Tokens 
select * from Prompts;
select * from Responses;
select * from Tokens;

-- Prompt with Response and Tokens
select p.prompt_text , r.response_text , t.total_tokens from prompts p join responses r on p.prompt_id = r.prompt_id 
join Tokens t on p.prompt_id = t.prompt_id ;

-- Most Expensive Prompts
select p.prompt_text , t.total_tokens , t.estimated_cost_usd  from prompts p join Tokens t on p.prompt_id = t.prompt_id 
order by  t.estimated_cost_usd DESC  LIMIT 10;

-- Best Performing Prompt Categories
SELECT p.category,
       COUNT(p.prompt_id) AS total_prompts,
       AVG(r.quality_score) AS avg_quality,
       AVG(r.response_time_seconds) AS avg_response_time,
       SUM(t.total_tokens) AS total_tokens_used
FROM Prompts p
JOIN Responses r
ON p.prompt_id = r.prompt_id
JOIN Tokens t
ON p.prompt_id = t.prompt_id
GROUP BY p.category
ORDER BY avg_quality DESC;