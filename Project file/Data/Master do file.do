misstable summarize
summarize protest_week_num regime_cat internet_penet GDP_percapita GDP_growth weekend_num youth_bulge1529 GDP_percapita GDP_growth
histogram protest_week_num
kdensity protest_week_num, title("Kernel Density plot of Protest Length")
corr regime_cat weekend_num internet_penet GDP_percapita GDP_growth youth_bulge1529 Urban_pop
label var std_internet "Standardise values of Internet Penetration"
label var std_gdp "Standardise values of GDP per Capita"
label var std_urban "Standardise values of Population %"
pca std_internet std_gdp std_urban, components(1)
summarize development_index_pca  
label var development_index_pca "Development Index (PCA)"
corr regime_cat weekend_num youth_bulge1529 development_index_pca
label var std_internet "Standardise values of Internet Penetration"
label var std_gdp "Standardise values of GDP per Capita"
label var std_urban "Standardise values of Population %"
pca std_internet std_gdp std_urban, components(1)
summarize development_index_pca  
label var development_index_pca "Development Index (PCA)"
corr regime_cat weekend_num youth_bulge1529 development_index_pca
poisson protest_week_num i.regime_cat development_index_pca youth_bulge1529 weekend_num
estat gof, pearson
nbreg protest_week_num i.regime_cat development_index_pca youth_bulge1529 weekend_num
margins regime_cat
marginsplot
test 3.regime_cat = 4.regime_cat 
lincom 3.regime_cat - 4.regime_cat
regress protest_week_num i.regime_cat development_index_pca youth_bulge1529 weekend_num
estat vif
graph bar (mean) protest_week_num, over(regime_cat)
nbreg protest_week_num i.regime_cat##c.development_index_pca youth_bulge1529 weekend_num
graph box protest_week_num, over(regime_cat) title("With Outliers Visible")