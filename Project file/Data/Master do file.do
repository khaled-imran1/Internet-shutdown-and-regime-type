**Import Master data file.dta**

**Variable labels done**
**Converted string data to numerics**

**checking for missing value **
misstable summarize 

**Summary stats**
summarize protest_week_num regime_cat internet_penet GDP_percapita GDP_growth weekend_num youth_bulge1529 GDP_percapita GDP_growth

** Visualize dependent variable (count distribution)**
histogram protest_week_num
kdensity protest_week_num, title("Kernel Density plot of Protest Length")

**Correlation Matrix**
corr regime_cat weekend_num internet_penet GDP_percapita GDP_growth youth_bulge1529 Urban_pop

**To address multicollinearity among internet_penet, GDP_percapita, and Urban_pop (the "development triad" with high correlations >0.7), creating a composite index using Principal Component Analysis (PCA). Generated standardised internet penetration, gdp per capita and urban population variables and created a new index variable: development_index_pca**

label var std_internet "Standardise values of Internet Penetration"
label var std_gdp "Standardise values of GDP per Capita"
label var std_urban "Standardise values of Population %"
pca std_internet std_gdp std_urban, components(1)
summarize development_index_pca  
label var development_index_pca "Development Index (PCA)"

**Correlation Matrix (doing again!!)**
corr regime_cat weekend_num youth_bulge1529 development_index_pca

**Testing Poisson compatibility**
poisson protest_week_num i.regime_cat development_index_pca youth_bulge1529 weekend_num

**Goodness-of-fit test for overdispersion**
estat gof, pearson

**Model 1: Overdispersion sighted; going for Negative Binomial Regression (NBRM)**
nbreg protest_week_num i.regime_cat development_index_pca youth_bulge1529 weekend_num
margins regime_cat
marginsplot

**Wald Test for Electoral vs. Closed Autocracies**
test 3.regime_cat = 4.regime_cat 
lincom 3.regime_cat - 4.regime_cat

**Robustness Checks**

**Multicoliniarity check**
regress protest_week_num i.regime_cat development_index_pca youth_bulge1529 weekend_num
estat vif

**Visualization**
graph bar (mean) protest_week_num, over(regime_cat)

**Model 2: Negative Binomial Regression (NBRM) with regime type * development index**
nbreg protest_week_num i.regime_cat##c.development_index_pca youth_bulge1529 weekend_num

**Checking for outliers**
graph box protest_week_num, over(regime_cat) title("With Outliers Visible")