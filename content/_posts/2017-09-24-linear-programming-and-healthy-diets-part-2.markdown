---
author: jeremykun
date: 2017-09-24 15:00:46+00:00
draft: false
title: Linear Programming and Healthy Diets — Part 2
type: post
url: /2017/09/24/linear-programming-and-healthy-diets-part-2/
categories:
- General
---

Previously in this series:



	  * [Linear programming and healthy diets — Part 1](https://jeremykun.com/2014/06/02/linear-programming-and-the-most-affordable-healthy-diet-part-1/)
	  * [Linear programing and the simplex algorithm](https://jeremykun.com/2014/12/01/linear-programming-and-the-simplex-algorithm/)



## Foods of the Father


My dad's an interesting guy.

Every so often he picks up a health trend and/or weight loss goal that would make many people's jaw drop. For example, we once went on a 5-day, 50-mile backpacking trip in the Grand Tetons, and my dad brought [one of these](http://www.liptonkitchens.com/product/detail/1059435/noodle-soup) per day for dinner, and had vitamin tablets for the rest of his sustenance. The rest of us planned for around 3,000 calories per day. He's tried the "high fat" and "no fat" diets, and quite a few others. He's concerned with losing weight, but also living longer, so he's into caloric restriction among other things.

Recently he asked me to help him optimize his diet. He described a scheme he was performing by hand to minimize the number of calories he consumed per day while maintaining the minimum nutrients required by the FDA's [recommendations](https://en.wikipedia.org/wiki/Reference_Daily_Intake). He had a spreadsheet with the nutrients for each food, and a spreadsheet with the constraints on each nutrient. He wanted to come up with a collection of meals (or just throw all the food into a blender) that taste within reason but meet these criteria.

He was essentially solving a linear program by hand, roughly as best as one can, with a few hundred variables! After asking me whether there was "any kind of math" that could help him automate his laborious efforts, I decided to lend a hand. After all, it's been over [three years since I promised](https://jeremykun.com/2014/06/02/linear-programming-and-the-most-affordable-healthy-diet-part-1/) my readers I'd apply linear programming to optimize a diet (though it was optimizing for cost rather than calories).

Though it never went beyond what linear programming can handle, pretty quickly my dad's requests specialized beyond what would interest a general reader. Perhaps this is the nature of math consulting, but it seems when you give someone what they want, they realize that's not what they wanted.

But the basic ideas are still relevant enough. My solution is a hundred-ish lines of python to set up the input, using Google's open source [operations research tools](https://developers.google.com/optimization/) as the core solver. Disclaimer: I work for Google but I don't work on the team that wrote this tool. Also nothing in this post represents the views of my employer. It's just me, and the scale of this problem is laughable for Google to care about anyway.

So this post is half tutorial showing how to use the or-tools python wrapper (it's only somewhat documented), and half showing a realistic use case for linear programming.

However, don't let this post dissuade you from the belief that linear programming is useful beyond dieting. People use linear programming to solve _all kinds_ of interesting problems. Here are a few I came across in just the last few weeks:



	  * [Factoring big matrices](http://arxiv.org/abs/1206.1270)
	  * [Solving zero sum games](http://www.slideshare.net/leingang/lesson-35-game-theory-and-linear-programming)
	  * [Optimally seating guests at a wedding](http://punkrockor.wordpress.com/2013/04/04/how-to-use-or-to-plan-your-wedding/) (Technically they use integer programming, which or-tools can do)

And that's not even to mention the ubiquitous applications in operations research (network flow, production optimization, economics) that every large company relies on. The applications seem endless!

As usual, all of the code and data we use in the making of this post is available at [this blog's Github page](https://github.com/j2kun/lp-diet).

**Update 2018-01-01: **With this code my dad had tried a few inadvisable cooking techniques: take all the ingredients and throw them in an omelet, or blend them all together in a smoothie. Something about cooking the food alters the nutritional content, so he claims he needed to eat them more or less raw. The resulting "meals" were so unpalatable that he appears to have given up on the optimization techniques in this post. It seems the extreme end of the taste/health tradeoff is not where he wants to be. This suggests an open problem: find a good way to model (or lean from data) what foods taste good together, and in what quantities. One might be able to learn from a corpus of recipes, though I imagine that can only go so far for lightly-cooked ingredients. But with hypothetical constraints like, "penalize/prefer these foods being in the same meal", one might be able to quantify the taste/health tradeoff in a way that makes my dad happy. Having an easy way to slide along the scale (rather than just naively optimize) would also potentially be useful.


## Refresher


If you remember how linear programs work, you can safely skip this section.

As a refresher, let's outline how to model the nutrition problem as a linear program and recall the basic notation. The variables are food in 100 gram increments. So $x_1$ might be the amount of canned peas consumed, $x_2$ lobster meat, etc. All variables would have to be nonnegative, of course. The objective is to minimize the total number of calories consumed. If $c_1 \geq 0$ is the amount of calories in 100g of canned peas, then one would pay $c_1x_1$ in calories contributed by peas. If we have $n$ different variables, then the objective function is the linear combination


$\textup{cost}(\mathbf{x}) = \sum_{j=1}^n c_j x_j$




We're using boldface $\mathbf{x}$ to represent the vector $(x_1, \dots, x_n)$. Likewise, $\mathbf{c}$ will represent the cost vector of foods $(c_1, \dots, c_n)$. As we've seen many times, we can compactly write the sum above as an inner product $\langle \mathbf{c}, \mathbf{x} \rangle$.




Finally, we require that the amount of each nutrient combined in the stuff we buy meets some threshold. So for each nutrient we have a constraint. The easiest one is calories; we require the total number of calories consumed is at least (say) 2,000. So if $a_j$ represents the number of calories in food $j$, we require $\sum_{j=1}^n a_j x_j \geq 2000$. We might also want to restrict a maximum number of calories, but in general having a diet with more calories implies higher cost, and so when the linear program minimizes cost we should expect it not to produce a diet with significantly more than 2,000 calories.




Since we have one set of nutrient information for each pair of (nutrient, food), we need to get fancier with the indexing. I'll call $a_{i,j}$ the amount of nutrient $i$ in food $j$. Note that $A = (a_{i,j})$ will be a big matrix, so I'm saying that nutrients $i$ represent the rows of the matrix and foods $j$ represent the columns. That is, each row of the matrix represents the amount of one specific nutrient in all the foods, and each column represents the nutritional content of a single food. We'll always use $n$ to denote the number of foods, and $m$ to denote the number of nutrients.




Finally, we have a lower and upper bound for each nutrient, which behind the scenes are converted into lower bounds (possibly negating the variables). This isn't required to write the program, as we'll see. In notation, we require that for every $1 \leq i \leq m$, the nutrient constraint $\sum_{j=1}^n a_{i,j} x_j \geq b_i$ is satisfied. If we again use vector notation for the constraints $\mathbf{b}$, we can write the entire set of constraints as a "matrix equation"




$A \mathbf{x} \geq \mathbf{b}$


And this means each entry of the vector you get from multiplying the left-hand-side is greater than the corresponding entry on the right-hand-side. So the entire linear program is summarized as follows


$\displaystyle \begin{aligned} \textup{min } & \langle \mathbf{c} , \mathbf{x} \rangle  \\
\textup{such that } & A \mathbf{x}  \geq \mathbf{b} \\ & \mathbf{x}  \geq \mathbf{0} \end{aligned}$




That's the syntactical form of our linear program. Now all (!) we need to do is pick a set of foods and nutrients, and fill in the constants for $A, \mathbf{c}, \mathbf{b}$.





## Nutrients and Foods


The easier of the two pieces of data is the nutrient constraints. The system used in the United States is called the [Dietary Reference Intake](http://en.wikipedia.org/wiki/Dietary_Reference_Intake) system. It consists of five parts, which I've paraphrased from Wikipedia.



	  * **Estimated Average Requirements** (EAR), expected to satisfy the needs of 50% of the people in an age group.
	  * **Recommended Dietary Allowances** (RDA), the daily intake level considered sufficient to meet the requirements of 97.5% of healthy individuals (two standard deviations).
	  * **Adequate Intake** (AI), where no RDA has been established. Meant to complement the RDA, but has less solid evidence.
	  * **Tolerable upper intake levels** (UL), the highest level of daily consumption that have not shown harmful side effects.

While my dad come up with his own custom set of constraints, the ones I've posted on the github repository are essentially copy/paste from the [current RDA/AI](https://en.wikipedia.org/wiki/Dietary_Reference_Intake#Current_recommendations) as a lower bound, with the UL as an upper bound. The [values I selected are in a csv](https://github.com/j2kun/lp-diet/blob/master/constraints.csv). Missing values in the upper bound column mean there is no upper bound. And sorry ladies, since it's for my dad I chose the male values. Women have slightly different values due to different average size/weight.

Nutrient values for food are a little bit harder, because nutrient data isn't easy to come by. There are a few databases out there, all of which are incomplete, and some of which charge for use. My dad spent a long time hunting down the nutrients (he wanted some additional special nutrients) for his top 200-odd foods.

Instead, in this post we'll use the USDA's free-to-use database of 8,000+ foods. It comes in a single, abbreviated, [oddly-formatted text file](https://www.ars.usda.gov/northeast-area/beltsville-md/beltsville-human-nutrition-research-center/nutrient-data-laboratory/docs/sr28-download-files/) which I've parsed into a [csv](https://github.com/j2kun/lp-diet/blob/master/sr28.csv) and chosen an arbitrary subset of 800-ish [foods to play around with](https://github.com/j2kun/lp-diet/blob/master/nutrients.csv).


## Python OR Tools


Google's ortools [docs](https://developers.google.com/optimization/introduction/installing) ask you to download a tarball to install their package, but I found that was unnecessary (perhaps it's required to attach a third-party solver to their interface?). Instead, one can just pip install it.

{{< highlight python >}}
pip3 install py3-ortools
{{< /highlight >}}

Then in a python script, you can import the ortools library and create a simple linear program:

{{< highlight python >}}
from ortools.linear_solver import pywraplp

solver = pywraplp.Solver('my_LP', pywraplp.Solver.GLOP_LINEAR_PROGRAMMING)

x = solver.NumVar(0, 10, 'my first variable')
y = solver.NumVar(0, 10, 'my second variable')

solver.Add(x + y <= 7) solver.Add(x - 2 * y >= -2)

objective = solver.Objective()
objective.SetCoefficient(x, 3)
objective.SetCoefficient(y, 1)
objective.SetMaximization()

status = solver.Solve()

if status not in [solver.OPTIMAL, solver.FEASIBLE]:
    raise Exception('Unable to find feasible solution')

print(x.solution_value())
print(y.solution_value())
{{< /highlight >}}

This provides the basic idea of the library. You can use python's operator overloading (to an extent) to make the constraints look nice in the source code.


## Setting up the food LP


The main file `diet_optimizer.py` contains a definition for a class, which, in addition to loading the data, encapsulates all the variables and constraints.

{{< highlight python >}}
class DietOptimizer(object):
    def __init__(self, nutrient_data_filename='nutrients.csv',
                 nutrient_constraints_filename='constraints.csv'):

        self.food_table = # load data into a list of dicts
        self.constraints_data = # load data into a list of dicts

        self.solver = pywraplp.Solver('diet_optimizer', pywraplp.Solver.GLOP_LINEAR_PROGRAMMING)
        self.create_variable_dict()
        self.create_constraints()

        self.objective = self.solver.Objective()
        for row in self.food_table:
            name = row['description']
            var = self.variable_dict[name]
            calories_in_food = row[calories_name]
            self.objective.SetCoefficient(var, calories_in_food)
        self.objective.SetMinimization()
{{< /highlight >}}

We'll get into the variables and constraints momentarily, but before that we can see the solve method

{{< highlight python >}}
    def solve(self):
        '''
            Return a dictionary with 'foods' and 'nutrients' keys representing
            the solution and the nutrient amounts for the chosen diet
        '''
        status = self.solver.Solve()
        if status not in [self.solver.OPTIMAL, self.solver.FEASIBLE]:
            raise Exception('Unable to find feasible solution')

        chosen_foods = {
            food_name: var.solution_value()
            for food_name, var in self.variable_dict.items() if var.solution_value() > 1e-10
        }

        self.chosen_foods = chosen_foods

        nutrients = {
            row['nutrient']: self.nutrients_in_diet(chosen_foods, row['nutrient'])
            for row in self.constraints_table
        }

        return {
            'foods': chosen_foods,
            'nutrients': nutrients,
        }
{{< /highlight >}}

Here `nutrients_in_diet` is a helper function which, given a dictionary of foods and a nutrient, outputs the nutrient contents for that food. This can be used independently of the solver to evaluate the nutrient contents of a proposed diet.

Next we have the method to create the variables.

{{< highlight python >}}
    def create_variable_dict(self):
        '''
            The variables are the amount of each food to include, denominated in units of 100g
        '''
        self.variable_dict = dict(
            (row['description'], self.solver.NumVar(0, 10, row['description']))
            for row in self.food_table
        )
{{< /highlight >}}

Each food must be present in a nonnegative amount, and I've imposed a cap of 10 (1kg) for any individual food. The reason for this is that I originally had a "water" constraint, and the linear program decided to optimize for that by asking one to drink 2L of red wine per day. I neglected to put in an alcohol nutrient (because it was not already there and I'm lazy), so instead I limited the amount of any individual food. It still seems like a reasonable constraint to impose that nobody would want to eat more than 1kg of any single food on one day.

Finally, we can construct the constraints. The core method takes a nutrient and a lower and upper bound:

{{< highlight python >}}
    def create_constraint(self, nutrient_name, lower, upper):
        '''
            Each constraint is a lower and upper bound on the
            sum of all food variables, scaled by how much of the
            relevant nutrient is in that food.
        '''
        if not lower:
            print('Warning! Nutrient %s has no lower bound!'.format(nutrient_name))
            return

        sum_of_foods = self.foods_for_nutrient(nutrient_name)
        constraint_lb = lower <= sum_of_foods
        self.solver.Add(constraint_lb)
        self.constraint_dict[nutrient_name + ' (lower bound)'] = constraint_lb

        if not upper:
            return  # no upper bound in the data

        constraint_ub = sum_of_foods <= upper
        self.solver.Add(constraint_ub)
        self.constraint_dict[nutrient_name + ' (upper bound)'] = constraint_ub
{{< /highlight >}}

This method is mostly bookkeeping, while `foods_for_nutrient` does the individual nutrient lookup. Note that one is not allowed to do a double-ended inequality like `self.solver.Add(lower <= sum_of_foods <= upper)`. If you try, ortools will ignore one end of the bound.

{{< highlight python >}}
    def foods_for_nutrient(self, nutrient_name, scale_by=1.0):
        # a helper function that computes the scaled sum of all food variables
        # for a given nutrient
        relevant_foods = []
        for row in self.food_table:
            var = self.variable_dict[row['description']]
            nutrient_amount = row[nutrient_name]
            if nutrient_amount > 0:
                relevant_foods.append(scale_by * nutrient_amount * var)

        if len(relevant_foods) == 0:
            print('Warning! Nutrient %s has no relevant foods!'.format(nutrient_name))
            return

        return SumArray(relevant_foods)
{{< /highlight >}}

Here we are a bit inefficient by iterating through the entire table, instead of just those foods containing the nutrient in question. But there are only a few hundred foods in our sample database (8,000 if you use the entire [SR28](https://github.com/j2kun/lp-diet/blob/master/sr28.csv) database), and so the optimization isn't necessary.

Also note that while ortools allows one to use the `sum` method, it does so in a naive way, because `sum([a, b, c])` becomes `((a + b) + c)`, which is a problem because if the list is too long their library exceeds Python's default recursion limit. Instead we construct a `SumArray` by hand.

Finally, though we omitted it here for simplicity, throughout the code in the [Github repository](https://github.com/j2kun/lp-diet) you'll see references to `percent_constraints`. This exists because some nutrients, like fat, are recommended to be restricted to a percentage of calories, not an absolute amount. So we define a mechanism to specify a nutrient should be handled with percents, and a mapping from grams to calories. This ends up using the `scale_by` parameter above, both to scale fat by 9 calories per gram, and to scale calories to be a percentage. Cf. [the special function](https://github.com/j2kun/lp-diet/blob/master/diet_optimizer.py#L168) for creating percent constraints.

Finally, we have methods just for pretty-printing the optimization problem and the solution, called `[summarize_optimization_problem](https://github.com/j2kun/lp-diet/blob/master/diet_optimizer.py#L184)` and `[summarize_solution](https://github.com/j2kun/lp-diet/blob/master/diet_optimizer.py#L192)`, respectively.


## Running the solver


Invoking the solver is trivial.

{{< highlight python >}}
if __name__ == "__main__":
    solver = DietOptimizer()
    # solver.summarize_optimization_problem()
    solution = solver.solve()
    solver.summarize_solution(solution)
{{< /highlight >}}

With the example foods and constraints in the [github repo](https://github.com/j2kun/lp-diet), the result is:

{{< highlight python >}}
Diet:
--------------------------------------------------

  298.9g: ALCOHOLIC BEV,WINE,TABLE,WHITE,MUSCAT
 1000.0g: ALFALFA SEEDS,SPROUTED,RAW
   38.5g: CURRY POWDER
    2.1g: CUTTLEFISH,MXD SP,CKD,MOIST HEAT
   31.3g: EGG,WHL,CKD,HARD-BOILED
   24.0g: LOTUS ROOT,CKD,BLD,DRND,WO/SALT
  296.5g: MACKEREL,JACK,CND,DRND SOL
  161.0g: POMPANO,FLORIDA,CKD,DRY HEAT
   87.5g: ROSEMARY,FRESH
  239.1g: SWEET POTATO,CKD,BKD IN SKN,FLESH,WO/ SALT

Nutrient totals
--------------------------------------------------

    1700.0 mg   calcium                   [1700.0, 2100.0]
     130.0 g    carbohydrate              [130.0, ]
     550.0 mg   choline                   [550.0, 3500.0]
       3.3 mg   copper                    [0.9, 10.0]
      60.5 g    dietary fiber             [38.0, ]
     549.7 μg   dietary folate            [400.0, 1000.0]
    1800.0 kcal energy                    [1800.0, 2100.0]
      32.4 mg   iron                      [18.0, 45.0]
     681.7 mg   magnesium                 [420.0, ]
       7.3 mg   manganese                 [2.3, 11.0]
      35.0 mg   niacin                    [16.0, 35.0]
      11.7 mg   pantothenic acid          [5.0, ]
    2554.3 mg   phosphorus                [1250.0, 4000.0]
      14.0 g    polyunsaturated fatty acids  [1.6, 16.0]
    4700.0 mg   potassium                 [4700.0, ]
     165.2 g    protein                   [56.0, ]
       2.8 mg   riboflavin                [1.3, ]
     220.8 μg   selenium                  [55.0, 400.0]
    1500.0 mg   sodium                    [1500.0, 2300.0]
       2.4 mg   thiamin                   [1.2, ]
      59.4 g    total fat                 [20.0, 35.0]        (29.7% of calories)
    3000.0 μg   vitamin a                 [900.0, 3000.0]
      23.0 μg   vitamin b12               [2.4, ]
       2.4 mg   vitamin b6                [1.7, 100.0]
     157.6 mg   vitamin c                 [90.0, 2000.0]
     893.0 iu   vitamin d                 [400.0, 4000.0]
      15.0 mg   vitamin e                 [15.0, 1000.0]
     349.4 μg   vitamin k                 [120.0, ]
      17.2 mg   zinc                      [11.0, 40.0]
{{< /highlight >}}

Unfortunately, this asks for a kilo of raw alfalfa sprouts, which I definitely would not eat. The problem is that alfalfa is ridiculously nutritious. Summarizing the diet with the `print_details` flag set, we see they contribute a significant amount of nearly every important nutrient.

{{< highlight python >}}
1000.0g: ALFALFA SEEDS,SPROUTED,RAW
	18.8% of calcium (mg)
	16.2% of carbohydrate (g)
	26.2% of choline (mg)
	47.3% of copper (mg)
	31.4% of dietary fiber (g)
	65.5% of dietary folate (μg)
	12.8% of energy (kcal)
	29.7% of iron (mg)
	39.6% of magnesium (mg)
	25.6% of manganese (mg)
	13.7% of niacin (mg)
	48.2% of pantothenic acid (mg)
	27.4% of phosphorus (mg)
	29.3% of polyunsaturated fatty acids (g)
	16.8% of potassium (mg)
	24.2% of protein (g)
	45.1% of riboflavin (mg)
	2.7% of selenium (μg)
	4.0% of sodium (mg)
	31.9% of thiamin (mg)
	11.6% of total fat (g)
	2.7% of vitamin a (μg)
	13.9% of vitamin b6 (mg)
	52.0% of vitamin c (mg)
	1.3% of vitamin e (mg)
	87.3% of vitamin k (μg)
	53.5% of zinc (mg)
{{< /highlight >}}

But ignoring that, we have some reasonable sounding foods: fish, sweet potato, rosemary (okay that's a ton of rosemary), egg and wine. I bet someone could make a tasty meal from those rough ingredients.


## Extensions and Exercises


No tutorial would be complete without exercises. All of these are related to the actual linear program modeling problem.

**Food groups: **Suppose you had an additional column for each food called "food group." You want to create a balanced meal, so you add additional constraint for each food group requiring some food, but not too much, from each group. Furthermore, for certain foods like spices, one could add a special constraint for each spice requiring not more than, say, 20g of any given spice. Or else, as one can see, the linear program can produce diets involving obscenely large amounts of spices.

**Starting from a given set of foods: **Supposing you have an idea for a recipe (or couple of recipes for a day's meals), but you want to add whatever else is needed to make it meet the nutritional standards. Modify the LP to allow for this.

**Integer variations: **The ortools package [supports integer programming](https://developers.google.com/optimization/mip/integer_opt) as well. All you need to do to enable this is change the solver type to `CBC_MIXED_INTEGER_PROGRAMMING`. The solver will run as normal, and now you can create integer-valued variables using `solver.IntVar` instead of `NumVar`. Using binary variables, one can define logical OR constraints (figure out how this must work). Define a new binary variable for each food, and define a constraint that makes this variable 0 when the food is not used, and 1 when the food is used. Then add a term to the optimization problem that penalizes having too many different foods in a daily diet.

**(Harder) Sampling: **Part of the motivation for this project is to come up with a number of different dishes that are all "good" with respect to this optimization problem. Perhaps there is more than one optimal solution, or perhaps there are qualitatively different diets that are close enough to optimal. However, this implementation produces a deterministic output. Find a way to introduce randomness into the program, so that you can get more than one solution.

Feel free to suggest other ideas, and extend or rewrite the model to do something completely different. The sky's the limit!
