JSON Path Pre-prerequisites
===========================

Part I - What is YAML
============

## Array or List
```
Fruits:
   - Apple
   - Orange
   - Banana
Vegetables:
   - Carrot
   - Cauliflower
   - Tomato
```
- `Fruits` and `Vegetables` are lists, each with the given elements

## Dictionary or Map
```
Banana:
   Calories: 105
   Fat: 0.4 g
   Carbs: 27 g

Grapes:
   Calories: 62
   Fat: 0.3 g
   Carbs: 16 g
```

- A list of `Fruits` with elements `Banana` and `Grape`, each of these elements are further Dictionaries
```
Fruits:
   - Banana:
      Calories: 105
      Fat: 4.5 g
      Carbs: 3.7 g
   - Grape:
      Calories: 12
      Fat: 37.7 g
      Carbs: 3.0 g
```
   - I guess it is like this: `Fruits={Banana=[Calories=...], Grape=[Calories=...]}`

## Dicts vs Lists vs List of Dicts
- Dict is **unordered** collection
- List is **ordered** collection


Part II - Introduction to JSON PATH
===================================
## YAML Vs JSON
- The same thing ;)
- Dictionary
   - Curly brackets {} --> JSON
   - Indentation --> YAML
- List Item
   - Dash - --> YAML
   - Square brackets [] --> JSON

## JSON PATH
- Query Language
- Parse data in `json` or `yaml` format
   - Like `sql`
- JSON Document is encapsulated with a pair of curly brackets
   - Anything with {} is a dict
   - **Top Level Dictionary** or **Root Element** of a json document
      - It is denoted by `$`
```
{
   "vehicles": {
      "car": {
         "color": "blue",
         "price": "$20,000"
      },
      "bus": {
         "color": "white",
         "price": "$120,000"
      }
   }
}
```
### Querying in *Dictionaries*
- To query for exmaple for the bus's price `$.vehicles.bus.price`
- Or get bus details `$.vehicles.bus`
- All results of a `json path` query is returned within an array, for example the first query and second query above will return the following results respectively
```
[
"$120,000"
]

# Or the second query:
[
{
   "color": "white",
   "price": "$120,000"
}
]
```

### Querying in *Lists*
- Having the following
```
[
"car",
"bus",
"truck",
"bike"
]
```
- `$[0]` --> Gives you `car`
- `'$[1,3]'` --> Gives you `bus` and `bike`

### Dicts and Lists
```
{
   "car": {
      "clolor": "blue",
      "price": "$20,000",
      "wheels": [
      {
         "model": "X345ERT",
         "location": "front-right"
      },
      {
         "model": "X346GRX",
         "location": "rear-left"
      },
      {
         "model": "X236FRZ",
         "location": "rear-right"
      },
      {
         "model": "X9872ZZZ",
         "location": "front-left"
      }
      ]
   }
}
```
- So it would be `{car{color,price,wheels[{0},{1},{2},{3}]}}` ;)
- Get the model of the second wheel `$.car.wheels[1].model`

### Criteria and Conditions in query
```
[
12,
43,
23,
12,
56,
43,
93,
32,
45,
63,
27,
8,
78
]
```
- Get numbers greater than 40 `$[?(@>40)]`
   - `$` --> Items
   - `?` --> If
   - `@` --> Each Item
- Can use other operands `==`, `!= `
   - `in [x,y,z,...]` --> if equal to any of the items given
   - `nin [x,y,x,...]` --> if not equal to any of the given items
- So following the earlier data set: *get the model of the rear-right wheel
```
$.car.wheels[?(@.location =="rear-right")].model
```

Part III - JSON PATHS Wild Cards
================================
- consider
```
{
   "car": {
      "color": "blue",
      "price": "$20,000"
   },
   "bus": {
      "color": "white",
      "price": "$120,000"
   }
}
```
- How to get the colors of all vehicles `$.*.color`
- or all prices `$.*.price`
- Consider the following list
```
[
   {
      "model": "X345ERT",
      "location": "front-right"
   },
   {
      "model": "X346GRX",
      "location": "rear-left"
   },
   {
      "model": "X236FRZ",
      "location": "rear-right"
   },
   {
      "model": "X9872ZZZ",
      "location": "front-left"
   }   
]
```
- Get the models of all the wheels `'$[*].model'`
- Now **mixed**
```
{
   "car": {
      "color": "blue",
      "price": 20000,
      "wheels": [
      {
         "model": "X2334FX"
      },
      {
         "model": "X3487ZZ"
      }
      ]
   },
   "bus": {
      "color": "white",
      "price": 120000,
      "wheels": [
      {
         "model": "234SSY2"
      },
      {
         "model": "328XZZX"
      }
      ]
   }
}
```
- Get the model of all the wheels of the car `$.car.wheels[*].model`
- To get the models of wheels for cars and buses `$.*.wheels[*].model`

Part IV - JSON PATH Lists
=========================
- Advanced options with lists
```
[
"apple",
"google",
"microsoft",
"amazon",
"facebook",
"coca-cola",
"sasmsung",
"disney",
"toyota",
"macDonalds"
]
```
- To get 1 to 4 `'$[0:3]'`
- **STEP** Option, how much the counter should be incremented before fetching the next element
- `'$[0:8:2]'` --> `apple, microsoft, facebook, samsung`
- `'$[-1]'` --> last item, 'macDonalds'
   - Does not work in all json path implementations
   - Should specify start and end
   ```
   $[-1:0] # From -1 to 0
   $[-1:]  # This will also have the same effect
   ```
      - With the above ones usually the later is preferred when you don't have a non-default stop point
   - Get last 3 elements
   ```
   $[-3:] # or
   $[-3:0]
   ```

Part V - JSON PATH in *K8S*
===========================
### How `kubectl` works?
- `kubectl` to `kube-apiserver` speaks in `json` language
   - Even the `-o wide` does not print the complete output from `kube-apiserver`
- With Json Path queries we can perform complex queries
- **How to JSON PATH in `k8s`**
   1. know the command
   2. add the option `-o json`
   3. Form the JSON PATH query
   4. Use the query with the  `kubectl` command
   ```
   k get pods -o=jsontpath='{ .items[0].spec.containers[0].image}'      # Returns the image of a pod
   k get nodes -o=jsontpath='{.items[*].metadata.name}'                 # Returns the names of all nodes
   k get nodes -o=jsontpath='{.items[*].status.nodeInfo.archeticture}'  # Returns the cpu arch of all nodes
   ```
   - Queries could be merged
   ```
   k get nodes -o=jsonpath='{.items[*].metadata.name}{.items[*].status.capacity.cpu}'
   ```
- **Prettyfying** and **formatting** options
   - '\n' --> new line
   - '\t\' --> tab
   - Consider the last example:
   ```
   k get nodes -o=jsonpath='{.items[*].metadata.name}{.items[*].status.capacity.cpu}'
   ```
   - can be formatted:
   ```
   k get nodes -o=jsonpath='{.items[*].metadata.name}{"\n"}{.items[*].status.capacity.cpu}'
   ```
### Loops - Ranges
```
   '{range .items[*]}   # For each item
      {.metadata.name} {"\t"}{.status.capacity.cpu} {"\n"}
   {end}' # End the loop
```
   - merge all the above into a single liner

### Custom Columns
- Can be used instead of loops `-o=custom-columns`
```
k get nodes -o=custom-columns=<columnName>:<jsonPath>
```
- Take the example in Loops - Ranges
   ```
   k get nodes -o=custom-columns=NODE:.metadata.name
   ```
   - Note that the `items` section of the query is **excluded**
      - Cause the custom-columns assumes the query is for each item in the list
- **Additional** columns can be added using commas
- An **Example** would be
```
k get pv -o custom-columns=NAME:'{.metadata.name }',CAPACITY:'{.spec.capacity.storage}'
```
- The same command can also be sorted
```
k get pv -o custom-columns=NAME:'{.metadata.name }',CAPACITY:'{.spec.capacity.storage}' --sort-by .spec.capacity.storage
```
   - The first level dict (`.items[]`) is removed

### Sorting
- `--sort-by`
- Specify the json-path query
- For example to sort `pvs` `k get pv --sort-by=.spec.capacity.storage`
   - The first level dict (`.items[]`) is removed

### Useful commands
- To view `kubeconfig` at json output `k config view --kubeconfig=</path/To/File> -o=json`

APPENDIX
========
- The followings could be used for practice
### Example 1
```
{
    "prizes": [
        {
            "year": "2018",
            "category": "physics",
            "overallMotivation": "\"for groundbreaking inventions in the field of laser physics\"",
            "laureates": [
                {
                    "id": "960",
                    "firstname": "Arthur",
                    "surname": "Ashkin",
                    "motivation": "\"for the optical tweezers and their application to biological systems\"",
                    "share": "2"
                },
                {
                    "id": "961",
                    "firstname": "Gérard",
                    "surname": "Mourou",
                    "motivation": "\"for their method of generating high-intensity, ultra-short optical pulses\"",
                    "share": "4"
                },
                {
                    "id": "962",
                    "firstname": "Donna",
                    "surname": "Strickland",
                    "motivation": "\"for their method of generating high-intensity, ultra-short optical pulses\"",
                    "share": "4"
                }
            ]
        },
        {
            "year": "2018",
            "category": "chemistry",
            "laureates": [
                {
                    "id": "963",
                    "firstname": "Frances H.",
                    "surname": "Arnold",
                    "motivation": "\"for the directed evolution of enzymes\"",
                    "share": "2"
                },
                {
                    "id": "964",
                    "firstname": "George P.",
                    "surname": "Smith",
                    "motivation": "\"for the phage display of peptides and antibodies\"",
                    "share": "4"
                },
                {
                    "id": "965",
                    "firstname": "Sir Gregory P.",
                    "surname": "Winter",
                    "motivation": "\"for the phage display of peptides and antibodies\"",
                    "share": "4"
                }
            ]
        },
        {
            "year": "2018",
            "category": "medicine",
            "laureates": [
                {
                    "id": "958",
                    "firstname": "James P.",
                    "surname": "Allison",
                    "motivation": "\"for their discovery of cancer therapy by inhibition of negative immune regulation\"",
                    "share": "2"
                },
                {
                    "id": "959",
                    "firstname": "Tasuku",
                    "surname": "Honjo",
                    "motivation": "\"for their discovery of cancer therapy by inhibition of negative immune regulation\"",
                    "share": "2"
                }
            ]
        },
        {
            "year": "2018",
            "category": "peace",
            "laureates": [
                {
                    "id": "966",
                    "firstname": "Denis",
                    "surname": "Mukwege",
                    "motivation": "\"for their efforts to end the use of sexual violence as a weapon of war and armed conflict\"",
                    "share": "2"
                },
                {
                    "id": "967",
                    "firstname": "Nadia",
                    "surname": "Murad",
                    "motivation": "\"for their efforts to end the use of sexual violence as a weapon of war and armed conflict\"",
                    "share": "2"
                }
            ]
        },
        {
            "year": "2018",
            "category": "economics",
            "laureates": [
                {
                    "id": "968",
                    "firstname": "William D.",
                    "surname": "Nordhaus",
                    "motivation": "\"for integrating climate change into long-run macroeconomic analysis\"",
                    "share": "2"
                },
                {
                    "id": "969",
                    "firstname": "Paul M.",
                    "surname": "Romer",
                    "motivation": "\"for integrating technological innovations into long-run macroeconomic analysis\"",
                    "share": "2"
                }
            ]
        },
        {
            "year": "2014",
            "category": "peace",
            "laureates": [
                {
                    "id": "913",
                    "firstname": "Kailash",
                    "surname": "Satyarthi",
                    "motivation": "\"for their struggle against the suppression of children and young people and for the right of all children to education\"",
                    "share": "2"
                },
                {
                    "id": "914",
                    "firstname": "Malala",
                    "surname": "Yousafzai",
                    "motivation": "\"for their struggle against the suppression of children and young people and for the$.prizes[?(@.year == 2014)].laureates[*].firstname right of all children to education\"",
                    "share": "2"
                }
            ]
        },
        {
            "year": "2017",
            "category": "physics",
            "laureates": [
                {
                    "id": "941",
                    "firstname": "Rainer",
                    "surname": "Weiss",
                    "motivation": "\"for decisive contributions to the LIGO detector and the observation of gravitational waves\"",
                    "share": "2"
                },
                {
                    "id": "942",
                    "firstname": "Barry C.",
                    "surname": "Barish",
                    "motivation": "\"for decisive contributions to the LIGO detector and the observation of gravitational waves\"",
                    "share": "4"
                },
                {
                    "id": "943",
                    "firstname": "Kip S.",
                    "surname": "Thorne",
                    "motivation": "\"for decisive contributions to the LIGO detector and the observation of gravitational waves\"",
                    "share": "4"
                }
            ]
        },
        {
            "year": "2017",
            "category": "chemistry",
            "laureates": [
                {
                    "id": "944",
                    "firstname": "Jacques",
                    "surname": "Dubochet",
                    "motivation": "\"for developing cryo-electron microscopy for the high-resolution structure determination of biomolecules in solution\"",
                    "share": "3"
                },
                {
                    "id": "945",
                    "firstname": "Joachim",
                    "surname": "Frank",
                    "motivation": "\"for developing cryo-electron microscopy for the high-resolution structure determination of biomolecules in solution\"",
                    "share": "3"
                },
                {
                    "id": "946",
                    "firstname": "Richard",
                    "surname": "Henderson",
                    "motivation": "\"for developing cryo-electron microscopy for the high-resolution structure determination of biomolecules in solution\"",
                    "share": "3"
                }
            ]
        },
        {
            "year": "2017",
            "category": "medicine",
            "laureates": [
                {
                    "id": "938",
                    "firstname": "Jeffrey C.",
                    "surname": "Hall",
                    "motivation": "\"for their discoveries of molecular mechanisms controlling the circadian rhythm\"",
                    "share": "3"
                },
                {
                    "id": "939",
                    "firstname": "Michael",
                    "surname": "Rosbash",
                    "motivation": "\"for their discoveries of molecular mechanisms controlling the circadian rhythm\"",
                    "share": "3"
                },
                {
                    "id": "940",
                    "firstname": "Michael W.",
                    "surname": "Young",
                    "motivation": "\"for their discoveries of molecular mechanisms controlling the circadian rhythm\"",
                    "share": "3"
                }
            ]
        }
    ]
}
```

- An example `$.prizes[?(@.year == 2014)].laureates[*].firstname`

### Example 2
```
{
    "kind": "Config",
    "apiVersion": "v1",
    "preferences": {},
    "clusters": [
        {
            "name": "development",
            "cluster": {
                "server": "KUBE_ADDRESS",
                "certificate-authority": "/etc/kubernetes/pki/ca.crt"
            }
        },
        {
            "name": "kubernetes-on-aws",
            "cluster": {
                "server": "KUBE_ADDRESS",
                "certificate-authority": "/etc/kubernetes/pki/ca.crt"
            }
        },
        {
            "name": "production",
            "cluster": {
                "server": "KUBE_ADDRESS",
                "certificate-authority": "/etc/kubernetes/pki/ca.crt"
            }
        },
        {
            "name": "test-cluster-1",
            "cluster": {
                "server": "KUBE_ADDRESS",
                "certificate-authority": "/etc/kubernetes/pki/ca.crt"
            }
        }
    ],
    "users": [
        {
            "name": "aws-user",
            "user": {
                "client-certificate": "/etc/kubernetes/pki/users/aws-user/aws-user.crt",
                "client-key": "/etc/kubernetes/pki/users/aws-user/aws-user.key"
            }
        },
        {
            "name": "dev-user",
            "user": {
                "client-certificate": "/etc/kubernetes/pki/users/dev-user/developer-user.crt",
                "client-key": "/etc/kubernetes/pki/users/dev-user/dev-user.key"
            }
        },
        {
            "name": "test-user",
            "user": {
                "client-certificate": "/etc/kubernetes/pki/users/test-user/test-user.crt",
                "client-key": "/etc/kubernetes/pki/users/test-user/test-user.key"
            }
        }
    ],
    "contexts": [
        {
            "name": "aws-user@kubernetes-on-aws",
            "context": {
                "cluster": "kubernetes-on-aws",
                "user": "aws-user"
            }
        },
        {
            "name": "research",
            "context": {
                "cluster": "test-cluster-1",
                "user": "dev-user"
            }
        },
        {
            "name": "test-user@development",
            "context": {
                "cluster": "development",
                "user": "test-user"
            }
        },
        {
            "name": "test-user@production",
            "context": {
                "cluster": "production",
                "user": "test-user"
            }
        }
    ],
    "current-context": "test-user@development"
}
```
- A conditional example for finding all the `contexts` with `username=aws-user` is
```
k config view --kubeconfig ./my-kube-config -o jsonpath='{.contexts[?(@.context.user == "aws-user")].name}'
```
