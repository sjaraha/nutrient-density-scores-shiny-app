source("C:/Users/Owner/repos/nutrition_dashboard/analysis/import.r")
source("C:/Users/Owner/repos/nutrition_dashboard/analysis/functions.r")

## select necessary columns

food <- food %>%
  select(fdc_id,
         data_type,
         description)

fndds_survey <- fndds_survey %>% 
  select(fdc_id,
         food_code)

food_nutrient <- food_nutrient %>%
  select(id,
         fdc_id,
         nutrient_id,
         amount)

nutrient <- nutrient %>% 
  select(id,
         name,
         unit_name)

# pivot food_equivalent and filter food groups
food_group_equivalent <- food_equivalent %>%
  rename("food_code" = FOODCODE,
         "description" = DESCRIPTION,
         "fruits" = F_TOTAL,
         "vegetables" = V_TOTAL,
         "whole_grains" = G_WHOLE,
         "grains" = G_TOTAL,
         "protein_foods" = PF_TOTAL,
         "nuts_and_seeds" = PF_NUTSDS,
         "dairy" = D_TOTAL) %>%
  pivot_longer(cols = !c("food_code", "description"),
               names_to = "food_group",
               values_to = "food_group_per_100g") %>%
  mutate("unit" = case_when(food_group == "whole_grains" ~"oz equivalent",
                                       food_group == "vegetables" ~"cup equivalent",
                                       food_group =="fruits" ~"cup equivalent",
                                       food_group == "dairy" ~"cup equivalent",
                                       food_group == "nuts_and_seeds" ~"oz equivalent",
                                       food_group == "protein_foods" ~"oz equivalent",
                                       food_group == "grains" ~"oz equivalent"),
         food_group = str_replace_all(food_group, "_", " "),
         description = tolower(description)) %>%
  filter(food_group %in% c("whole grains", 
                           "vegetables", 
                           "fruits", 
                           "dairy", 
                           "nuts and seeds", 
                           "protein foods",
                           "grains"))

## check for nulls and empty spaces
# print("checking for nulls and empty spaces")

# check_empty_glimpse(food)
# check_empty_glimpse(fndds_survey)
# check_empty_glimpse(food_nutrient)
# check_empty_glimpse(nutrient)
# check_empty_glimpse(daily_value_nutrient)
# check_empty_glimpse(daily_value_food_group)
# check_empty_glimpse(food_group_equivalent)

## handle  nulls

food <- food %>%
  mutate(description = na_if(description,""))

# check_empty_glimpse(food)




