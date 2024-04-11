Labels and Selectors
====================

- Following content are taken from this [link](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)
## Labels
- key value pairs attached to objects
- kyes must be unique for a given object

## Selectors
- Two types are supported by API as of now
   1. equality-based
      - Three kinds of operators:
         * a) `=`
         * b) `==`
         * c) `!=`
            - `tier!=frontend` --> Select everything with key equal to `tier` and value distinct from `frontend`
   2. set-based
      - Allow fitlering keys according to a set of values
      - Three kinds of operators
         * a) `in`
            - `environment in (production, qa)`
               - All resources with key equal to `environment` and value equal to `production` or `qa`
         * b) `notin`
            - `tier notin (frontend, backend)`
               - All resources with key equal to `tier` and values other than `frontend` and `backend`, and all resources with no labels with `tier` key
         * c) `exists`
      - Some more examples:
         - `partition` --> All resources having a label with key `partition`, values are not checked
         - `!partition` --> All resources without a label with key `partition`, no values are checked
         - `partition, environment notin (qa)`
            - All resources with a label key `partition` no matter what the value, and a label key `environment` having values other than `qa`
- In case of multiple selectors, **comma** acts as logical **AND** (*`&&`*)
- No local **OR** (*`||`*)
