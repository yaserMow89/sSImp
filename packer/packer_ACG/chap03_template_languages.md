# Template Languages

## Json

- Two different structures:
   1. JSON **Object**
      - name/value pair
      - dictionary
      - associative array
      - key list
      ```json
      {
         "name": "value",
         "name": "value"
      }
      ```
   2. JSON **Array**
      - Ordered list
      - Vector
      - List
      - Sequence
      ```json
      [
         "item",
         "item"
      ]
      ```

## HCL2

- Used predominantly with HashiCorps' tools
- Also comprised of **Objects** and **Arrays** like JSON
- Objects would look like:
```hcl2
objectname {
   name = "value"
   name = "value"
}
```
- Arrays would look like
```hcl2
["item", "item"]
```
- **Attribute** is a single component that configures single thing in our template
- **Block** is a collection of attributes with a an annotated block type
- **Body** is a collection of associated blocks
- **Comments**
   - Inline --> `#` or `//`
   - Multiline --> `/* comment */`
