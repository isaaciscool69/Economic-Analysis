%% Name and Stuff ---------------------------------------------------------
%Name: Isaac Medina
%Date:5/3/2024
%Class: ES2
%Assignment: Final Project
%% Initialize -------------------------------------------------------------
clear;
clc;
%% Load Data tables

Nominal_GDP = readtable('USGDP19472023.csv');
Real_GDP = readtable('REALGDP.csv');
Unemployment_Rate = readtable('UnmploymentRate1948Present.csv');
CPI = readtable('cpiai.csv');
Inflation = readtable('inflation.csv');
%% Get yearly averages for GDP, Unemployment, CPI, and Inflation-----------

%% GDP -------------------------------------------------------------------
% For Nominal GDP
Nominal_GDP_values = Nominal_GDP{:, 2}; % abstract as vector for vector and matrix math

% Determine the number of quarters
num_quarters_Nominal_GDP = floor(height(Nominal_GDP_values) / 4);

% Calculate the number of elements to keep
num_elements_Nominal_GDP = height(Nominal_GDP_values);

% Extract only the required element
Nominal_GDP_values = Nominal_GDP_values(1:num_elements_Nominal_GDP, :);

% Reshape GDP_values into a 4-row matrix, with each column representing
% a year and each row being a quarter
Nominal_GDP_quarters = reshape(Nominal_GDP_values, 4, []);

% Calculate the average of each row (which represents a year in the 4 x 77
% matrix)
avg_Nominal_GDP_by_year = transpose(mean(Nominal_GDP_quarters, 1));

% Create a new table with averaged GDP values for each year
years_Nominal_GDP = (1947:2023)'; % Create a column vector of years from 1947 to 2023
new_Nominal_GDP = table(years_Nominal_GDP, avg_Nominal_GDP_by_year, 'VariableNames', {'Year', 'Avg_Nominal_GDP'}); % This is the table I want 

% For Real GDP --- EXACT SAME AS NOMINAL GDP, sourced from the same website
Real_GDP_values = Real_GDP{:, 2};
num_quarters_Real_GDP = floor(height(Real_GDP_values) / 4);
num_elements_Real_GDP = height(Real_GDP_values);
Real_GDP_values = Real_GDP_values(1:num_elements_Real_GDP, :);
Real_GDP_quarters = reshape(Real_GDP_values, 4, []);
avg_Real_GDP_by_year = transpose(mean(Real_GDP_quarters, 1));
years_Real_GDP = (1947:2023)';
new_Real_GDP = table(years_Real_GDP, avg_Real_GDP_by_year, 'VariableNames', {'Year', 'Avg_Real_GDP'});

%% Unemployment -----------------------------------------------------------
% Now for unemployment but by month so just change some numbers around
Unemployment_values = Unemployment_Rate{:, 2}; % abstract as vector for vector and matrix math

% Remove last 3 months from table because 2024 is not complete
rows_to_keep_UNRATE = 1:(height(Unemployment_values) - 3);
Unemployment_values = Unemployment_values(rows_to_keep_UNRATE, :);

% Determine the number of months
num_months_UNRATE = floor(height(Unemployment_values));

% Calculate the number of elements to keep
num_elements_UNRATE = height(Unemployment_values);

% Extract only the required element
Unemployment_values = Unemployment_values(1:num_elements_UNRATE, :);

% Reshape Unemployment_values into a 12-row matrix, with each column
% representing a year
Unemployment_months = reshape(Unemployment_values, 12, []);

% Calculate the average of each row (which represents a year in the 12 x 77
% matrix)
avg_UNRATE_by_year = transpose(mean(Unemployment_months, 1));

% Create a new table with averaged GDP values for each year
years_UNRATE = (1948:2023)'; % Create a column vector of years from 1948 to 2023
new_Unemployment_Rate = table(years_UNRATE, avg_UNRATE_by_year, 'VariableNames', {'Year', 'Avg_UNRATE'}); % This is the table I want 

%% CPI and Inflation Rate-------------------------------------------------
%CPI is the same as Unemployment rate
CPI_values = CPI{:, 2};
num_months_cpi = floor(height(CPI_values));
num_elements_cpi = height(CPI_values);
CPI_values = CPI_values(1:num_elements_cpi, :);
CPI_months = reshape(CPI_values, 12, []);
avg_CPI_by_year = mean(CPI_months, 1);
years_CPI = (1913:2013);
new_CPI = table(years_CPI, avg_CPI_by_year, 'VariableNames', {'Year', 'Avg_CPI'});


%Inflation
%Clean data table so it only the year and the Avg Inflation Rate
columns_to_remove_inflation = [1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];
Inflation = removevars(Inflation, columns_to_remove_inflation); %And that is it for the inflation table!

%% Calculate GDP Deflator -------------------------------------------------

% Obtain Nominal and Real GDP values for calculation
y_Real_GDP = new_Real_GDP{:, 2};
y_Nominal_GDP = new_Nominal_GDP{:, 2};

GDP_Deflator = (y_Nominal_GDP./y_Real_GDP)*100;

%% Plot Data --------------------------------------------------------------

% Abstract all plotting vectors
x_Nominal_GDP = new_Nominal_GDP{:, 1};
x_Real_GDP = new_Real_GDP{:, 1};
x_UNRATE = new_Unemployment_Rate{:, 1};
y_UNRATE = new_Unemployment_Rate{:, 2};
x_CPI = new_CPI{:, 1};
y_CPI = new_CPI{:, 2};
x_Inflation = Inflation{:, 1};
y_Inflation = Inflation{:, 2};

figure;
subplot(2,1,1);
plot(x_Nominal_GDP, y_Nominal_GDP, 'r-', LineWidth=2);
xlabel('Year');
ylabel('Nominal GDP (US Billions of $)');
title('US Nominal GDP 1947-2023')

subplot(2,1,2);
plot(x_Real_GDP, y_Real_GDP, 'b-', LineWidth=2);
xlabel('Year');
ylabel('Real GDP (US Billions of $)');
title('US Real GDP 1947-2023 - 2017 Base Year');


% Unemployment Rate
figure;
plot(x_UNRATE, y_UNRATE, 'b-', LineWidth=2);
xlabel('Year');
ylabel('Unemployment Rate');
title('US Unemployment Rate 1948-2023');

%CPI
figure;
plot(x_CPI, y_CPI, 'g-', LineWidth=2);
xlabel('Year');
ylabel('CPI');
title('US CPI 1913-2013');

%Inflation Rate
figure;
plot(x_Inflation, y_Inflation, 'k-', LineWidth=2);
xlabel('Year');
ylabel('Inflation Rate(%)');
title('US Inflation Rate 1913-2021');


% GDP Delfator vs CPI vs Inflation rate data set


figure;
subplot(3,1,1);
plot(transpose(x_Real_GDP(end-76:end-10)), y_CPI(end-66:end), 'g-', LineWidth=2);
xlabel('Year');
ylabel('CPI');
title('US CPI vs GDP Deflator vs Inflation rate');

subplot(3,1,2);
plot(x_Real_GDP, GDP_Deflator, 'r-', LineWidth=2);
xlabel('Year');
ylabel('GDP Deflator');

subplot(3,1,3);
plot(x_Real_GDP, y_Inflation(end-76:end), 'k-', LineWidth=2);
xlabel('Year');
ylabel('Inflation Rate');

% Unemployment rate to Nominal GDP around 2008

figure;
subplot(2,1,1);
plot(x_Nominal_GDP(end-20:end-10), y_Nominal_GDP(end-20:end-10), 'r-', LineWidth=2);
xlabel('Year');
ylabel('Nominal GDP (US Billions of $)');
title('Nominal GDP vs Unemployment Rate from 2003 to 2013');


subplot(2,1,2);
plot(x_UNRATE(end-20:end-10), y_UNRATE(end-20:end-10), 'b-', LineWidth=2);
xlabel('Year');
ylabel('Unemployment Rate');