# DO NOT EDIT
# This file was automatically generated using json-schema-to-nickel
let predicates =
{
    allOf
      : Array (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `allOf preds` succeeds if all of the predicates in `preds` succeed
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.1]
      "%
      = fun preds x => std.array.fold_right
          (fun pred acc => let result = pred x in
            if !result.success then result else acc)
          { error = "", success = true, }
          preds,
    always : Dyn -> { success: Bool, error: String }
      = std.function.const { error = "", success = true, },
    anyOf
      : Array (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `anyOf preds` succeeds if at least one of the predicates in `preds` succeeds
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.2]
      "%
      = fun preds x => (fun result => if result.success then
            { error = "", success = true, }
            else
            {
              error = m%"
                  anyOf: none of the options matched%{std.string.join "\n"
                  result.errors}
                  "%,
              success = false,
            })
          (std.array.fold_right
          (fun pred acc => let result = pred x in
            if result.success || acc.success then
            { errors = [  ], success = true, }
            else
            {
              errors = [
                      m%"
                      - %{result.error}
                      "%
                    ] @
                    acc.errors,
              success = false,
            })
          { errors = [  ], success = false, }
          preds),
    arrays = {
          additionalItems
            : (Dyn -> { success: Bool, error: String }) -> Number -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.2]
            "%
            = fun pred start x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let x  | Array Dyn = x in
                let value_length = std.array.length x in
                if start >= value_length then
                { error = "", success = true, }
                else
                (arrayOf pred ((std.array.slice start value_length x) | Dyn))),
          arrayOf
            : (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Apply a predicate to all elements of an array, succeeding if all
            applications succeed. If the value isn't an array, fail.
            "%
            = fun pred x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let x  | Array Dyn = x in
                std.array.fold_right
                (fun x acc => let result = pred x in
                  if !result.success then result else acc)
                { error = "", success = true, }
                x),
          contains
            : (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.6]
            "%
            = fun pred x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let x  | Array Dyn = x in
                (fun result => if result.success then
                  { error = "", success = true, }
                  else
                  {
                    error = m%"
                        contains: no elements matched%{std.string.join "\n"
                        result.errors}
                        "%,
                    success = false,
                  })
                (std.array.fold_right
                (fun x acc => let result = pred x in
                  if result.success || acc.success then
                  { errors = [  ], success = true, }
                  else
                  {
                    errors = [
                            m%"
                            - %{result.error}
                            "%
                          ] @
                          acc.errors,
                    success = false,
                  })
                { errors = [  ], success = false, }
                x)),
          items
            : Array (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.1]
            "%
            = fun preds x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let x  | Array Dyn = x in
                let length_to_check =
                std.number.min (std.array.length preds) (std.array.length x)
                in
                
                std.array.fold_right
                (fun i acc => let result =
                  std.array.at i preds (std.array.at i x)
                  in
                  
                  if !result.success then result else acc)
                { error = "", success = true, }
                (std.array.range 0 length_to_check)),
          maxItems
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            `maxItems n x` fails if `x` is an array of length strictly greater than `n` and succeeds otherwise.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.3]
            "%
            = fun n x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (if (std.array.length (x | Array Dyn)) > n then
                {
                    error = m%"
                        array is longer than %{std.string.from_number n} items
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
          minItems
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            `minItems n x` fails if `x` is an array of length strictly smaller than `n` and succeeds otherwise.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.4]
            "%
            = fun n x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (if (std.array.length (x | Array Dyn)) < n then
                {
                    error = m%"
                        array is shorter than %{std.string.from_number n} items
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
          uniqueItems
            : Dyn -> { success: Bool, error: String }
            | doc m%"
            Succeeds for any array if its elements are pairwise distinct.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.5]
            "%
            = let find_duplicate 
                : Array Dyn -> {
                  has_duplicate: Bool,
                  duplicate: Dyn,
                  seen: { _ : Bool }
                } =
              std.array.fold_right
                (fun elt acc => if acc.has_duplicate then acc else
                  (let index = std.serialize 'Json elt in
                  if std.record.has_field index acc.seen then
                  { duplicate = elt, has_duplicate = true, seen = acc.seen, }
                  else
                  {
                    duplicate = null,
                    has_duplicate = false,
                    seen = std.record.insert index true acc.seen,
                  }))
                { duplicate = null, has_duplicate = false, seen = {  }, }
              in
              
              fun x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let {has_duplicate  | Dyn, duplicate  | Dyn, ..} =
                find_duplicate (x | Array Dyn)
                in
                
                if has_duplicate then
                {
                    error = m%"
                        duplicate found: %{std.serialize 'Json duplicate}
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
        },
    const
      : Dyn -> Dyn -> { success: Bool, error: String }
      | doc m%"
      `const value x` succeeds if and only if `x` is equalt to `value`
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.1.3]
      "%
      = fun value x => if x == value then { error = "", success = true, } else
          {
            error = m%"
                expected %{std.serialize 'Json value}
                "%,
            success = false,
          },
    contract_from_predicate
      : (Dyn -> { success: Bool, error: String }) -> Dyn -> Dyn -> Dyn
      = fun predicate label value => let {success  | Dyn, error  | Dyn} =
          predicate value
          in
          
          if success then value else
          ((std.contract.blame_with_message error label) | Dyn),
    enum
      : Array Dyn -> Dyn -> { success: Bool, error: String }
      | doc m%"
      `enum values x` succeeds if and only if `x` is equal to one of the elements of `values`.
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.1.2]
      "%
      = let checkEqual =
        fun input variant => (input == variant) ||
            ((std.is_enum input) &&
            (((std.string.from_enum input) == variant) | Bool))
        in
        
        fun values x => std.array.fold_right
          (fun value acc => if checkEqual x value then
            { error = "", success = true, }
            else
            acc)
          {
            error = m%"
                expected one of %{std.serialize 'Json (values | Dyn)}
                "%,
            success = false,
          }
          values,
    from_simple_predicate
      : String -> (Dyn -> Bool) -> Dyn -> { success: Bool, error: String }
      | doc m%"
      Convert a simple boolean predicate into a predicate supporting error messages
      "%
      = fun error' pred x => { error = error', success = pred x, },
    ifThenElse
      : (Dyn -> { success: Bool, error: String }) -> (Dyn -> {
        success: Bool,
        error: String
      }) -> (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `ifThenElse i t e` first checks if the predicate `i` succeeds. If it does, it's equivalent to `t`, otherwise it's equivalent to `e`.
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.6]
      "%
      = fun i t e x => let {success  | Dyn, ..} = i x in
          if success then t x else (e x),
    isType
      : [| '"Array", '"Bool", 'Integer, 'Null, '"Number", 'Record, '"String" |]
      -> Dyn -> { success: Bool, error: String }
      = fun t => (match {'Integer => from_simple_predicate "expected an integer"
            (fun x => (std.is_number x) &&
              (std.number.is_integer (x | Number))),
            'Null => from_simple_predicate "expected `null`"
            (fun x => x == null),
            _ => from_simple_predicate
            m%"
            value is not of type %{std.string.from_enum t}
            "%
            (fun x => (std.typeof x) == t)
          })
          t,
    never : Dyn -> { success: Bool, error: String }
      = std.function.const { error = "never", success = false, },
    not
      : (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `not pred` succeeds if and only if `pred` fails
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.4]
      "%
      = fun pred x => let result = pred x in
          if result.success then
          {
              error = "Inverted predicate succeeded unexpectedly",
              success = false,
            }
          else
          { error = "", success = true, },
    numbers = {
          exclusiveMaximum
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.3]
            "%
            = fun limit x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if (x | Number) < limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected an exclusive maximum of %{std.string.from_number
                      limit}
                      "%,
                  success = false,
                }),
          exclusiveMinimum
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.5]
            "%
            = fun limit x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if (x | Number) > limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected an exclusive minimum of %{std.string.from_number
                      limit}
                      "%,
                  success = false,
                }),
          maximum
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.2]
            "%
            = fun limit x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if (x | Number) <= limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a maximum of %{std.string.from_number limit}
                      "%,
                  success = false,
                }),
          minimum
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.4]
            "%
            = fun limit x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if (x | Number) >= limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a minimum of %{std.string.from_number limit}
                      "%,
                  success = false,
                }),
          multipleOf
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.1]
            "%
            = fun mult x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if std.number.is_integer ((x | Number) / mult) then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a multiple of %{std.string.from_number mult}
                      "%,
                  success = false,
                }),
        },
    oneOf
      : Array (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `oneOf preds` succeeds if precisely one of the predicates in `preds` succeeds
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.3]
      "%
      = fun preds x => let count_true 
            : Array { success: Bool, error: String } -> Number =
          fun results => std.array.fold_left
              (fun n b => if b.success then n + 1 else n)
              0
              results
          in
          
          let results = std.array.map (fun pred => pred x) preds in
          let count = count_true results in
          if count == 0 then
          let errors =
            std.array.map
              (fun result => m%"
                - %{result.error}
                "%)
              results
            in
            
            {
              error = m%"
                  oneOf: none of the options matched%{std.string.join "\n"
                  errors}
                  "%,
              success = false,
            }
          else
          (if count > 1 then
          {
              error = "oneOf: more than one of the options matched",
              success = false,
            }
          else
          { error = "", success = true, }),
    records = {
          dependencies
            : { _ : Dyn } -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.7]
            "%
            = let mustHaveFields 
                : Array String -> { _ : Dyn } -> {
                  success: Bool,
                  error: String
                } =
              fun fields x => std.array.fold_right
                  (fun field acc => if !(std.record.has_field field x) then
                    {
                        error = m%"
                            expected field `%{field}`
                            "%,
                        success = false,
                      }
                    else
                    acc)
                  { error = "", success = true, }
                  fields
              in
              
              fun deps x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (let x  | { _ : Dyn } = x in
                std.array.fold_right
                (fun {field  | Dyn, value  | Dyn} => fun acc =>
                  if !(std.record.has_field field x) then acc else
                    (let result =
                    if std.is_array value then
                      mustHaveFields (value | Array String) x
                      else
                      (let pred  | Dyn -> { success: Bool, error: String } =
                      value
                      in
                      
                      pred (x | Dyn))
                    in
                    
                    if !result.success then
                    {
                        error = m%"
                            dependency of `%{field}` failed: %{result.error}
                            "%,
                        success = false,
                      }
                    else
                    acc))
                { error = "", success = true, }
                (std.record.to_array deps)),
          maxProperties
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            `maxProperties n x` fails if `x` is a record containing stricly more than `n` fields.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.1]
            "%
            = fun n x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (if (std.record.length (x | { _ : Dyn })) > n then
                {
                    error = m%"
                        record contains more than %{std.string.from_number
                        n} fields
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
          minProperties
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            `minProperties n x` fails if `x` is a record containing stricly less than `n` fields.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.1]
            "%
            = fun n x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (if (std.record.length (x | { _ : Dyn })) < n then
                {
                    error = m%"
                        record contains fewer than %{std.string.from_number
                        n} fields
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
          propertyNames
            : (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.8]
            "%
            = fun pred x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (std.array.fold_right
                (fun field acc => let result = pred (field | Dyn) in
                  if !result.success then
                  {
                      error = m%"
                          field `%{field}` did not validate against `propertyNames` schema
                          "%,
                      success = false,
                    }
                  else
                  acc)
                { error = "", success = true, }
                (std.record.fields (x | { _ : Dyn }))),
          record
            : { _ : Dyn -> { success: Bool, error: String } } -> { _ : Dyn -> {
              success: Bool,
              error: String
            } } -> Bool -> (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            `record properties patternProperties additionalAllowed
            additionalProperties x` is a combination of the `properties`,
            `patternProperties` and `additionalProperties` validation keywords in
            JSON schema.
            
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5]
            "%
            =
            fun properties patternProperties additionalAllowed additionalProperties x =>
              if !(std.is_record x) then { error = "", success = true, } else
                (let x  | { _ : Dyn } = x in
                let check_properties 
                  : { success: Bool, error: String, checked: { _ : Bool } } =
                std.array.fold_right
                  (fun {field  | Dyn, value  | Dyn} => fun acc =>
                    if !(std.record.has_field field x) then acc else
                      (let result = value x."%{field}" in
                      if !result.success then
                      {
                          checked : { _ : Bool }
                            = {  },
                          error = m%"
                              field `%{field}` didn't validate: %{result.error}
                              "%,
                          success = false,
                        }
                      else
                      {
                        checked = std.record.insert field true acc.checked,
                        error = acc.error,
                        success = acc.success,
                      }))
                  { checked = {  }, error = "", success = true, }
                  (std.record.to_array properties)
                in
                
                let matching_fields  : String -> { _ : Dyn } =
                fun pattern => let matcher = std.string.is_match pattern in
                    std.array.fold_left
                    (fun acc => fun {field  | Dyn, value  | Dyn} => if matcher
                        field then
                        std.record.insert field value acc
                        else
                        acc)
                    {  }
                    (std.record.to_array x)
                in
                
                let check_pattern_properties 
                  : { success: Bool, error: String, checked: { _ : Bool } } =
                std.array.fold_right
                  (fun {field  | Dyn = pattern, value  | Dyn = pred} =>
                  fun acc => let result =
                      std.array.fold_right
                        (fun {field  | Dyn, value  | Dyn} => fun acc =>
                          let result = pred value in
                            if !result.success then
                            {
                                checked : { _ : Bool }
                                  = {  },
                                error = m%"
                                    field `%{field}` didn't validate: %{result.error}
                                    "%,
                                success = false,
                              }
                            else
                            {
                              checked = std.record.insert field true
                                  acc.checked,
                              error = acc.error,
                              success = acc.success,
                            })
                        {
                          checked : { _ : Bool }
                            = {  },
                          error = "",
                          success = true,
                        }
                        (std.record.to_array (matching_fields pattern))
                      in
                      
                      if !result.success then result else
                      {
                        checked = std.array.fold_left
                            (fun r field => if !(std.record.has_field field
                              r) then
                              std.record.insert field true r
                              else
                              r)
                            acc.checked
                            (std.record.fields result.checked),
                        error = acc.error,
                        success = acc.success,
                      })
                  { checked : { _ : Bool } = {  }, error = "", success = true, }
                  (std.record.to_array patternProperties)
                in
                
                let remaining_fields =
                std.array.fold_left
                  (fun acc field => if !(std.record.has_field field acc) then
                    acc
                    else
                    (std.record.remove field acc))
                  x
                  ((std.record.fields check_properties.checked) @
                    (std.record.fields check_pattern_properties.checked))
                in
                
                let check_additional_properties 
                  : { success: Bool, error: String } =
                if (!additionalAllowed) &&
                  (!(std.record.is_empty remaining_fields)) then
                  {
                      error = m%"
                          extra fields %{std.serialize 'Json
                          ((std.record.fields remaining_fields) | Dyn)}
                          "%,
                      success = false,
                    }
                  else
                  (std.array.fold_right
                  (fun {field  | Dyn, value  | Dyn} => fun acc => let result =
                      additionalProperties value
                      in
                      
                      if !result.success then
                      {
                          error = m%"
                              field `%{field}` didn't validate: %{result.error}
                              "%,
                          success = false,
                        }
                      else
                      acc)
                  { error = "", success = true, }
                  (std.record.to_array remaining_fields))
                in
                
                if !check_properties.success then
                { error = check_properties.error, success = false, }
                else
                (if !check_pattern_properties.success then
                { error = check_pattern_properties.error, success = false, }
                else
                check_additional_properties)),
          required
            : Array String -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.3]
            "%
            = fun fields x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (std.array.fold_right
                (fun field acc => if !(std.record.has_field field
                  (x | { _ : Dyn })) then
                  {
                      error = m%"
                          missing required field %{field}
                          "%,
                      success = false,
                    }
                  else
                  acc)
                { error = "", success = true, }
                fields),
        },
    strings = {
          maxLength
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.1]
            "%
            = fun limit x => if !(std.is_string x) then
                { error = "", success = true, }
                else
                (if (std.string.length (x | String)) <= limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a string of length no larger than %{std.string.from_number
                      limit}
                      "%,
                  success = false,
                }),
          minLength
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.2]
            "%
            = fun limit x => if !(std.is_string x) then
                { error = "", success = true, }
                else
                (if (std.string.length (x | String)) >= limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a string of length no smaller than %{std.string.from_number
                      limit}
                      "%,
                  success = false,
                }),
          pattern
            : String -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.3]
            "%
            = fun pattern x => if !(std.is_string x) then
                { error = "", success = true, }
                else
                (if std.string.is_match pattern (x | String) then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a string matching the pattern `%{pattern}`
                      "%,
                  success = false,
                }),
        },
  }
in

let rec definitions =
{
    contract = {
          blockKeywords = predicates.contract_from_predicate
              definitions.predicate.blockKeywords,
          braceRules = predicates.contract_from_predicate
              definitions.predicate.braceRules,
          equalityOperators = predicates.contract_from_predicate
              definitions.predicate.equalityOperators,
          esprimaNodeTypes = predicates.contract_from_predicate
              definitions.predicate.esprimaNodeTypes,
          jsDoc
            | doc m%"
            Validate jsdoc comments.
            "%
            = {
                checkAnnotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [
                      predicates.isType '"Bool",
                      predicates.isType 'Null,
                      predicates.isType 'Record,
                      predicates.isType '"String"
                    ],
                    predicates.oneOf
                    [
                      predicates.isType '"Bool",
                      definitions.predicate.nullRule,
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          extra = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  } {  } true
                                (predicates.oneOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.anyOf
                                    [
                                      predicates.isType '"Bool",
                                      predicates.isType '"String"
                                    ],
                                    predicates.enum [ true, false, "some" ]
                                  ]
                                ])
                              ],
                          preset = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.oneOf
                                [
                                  predicates.enum [ "closurecompiler" ],
                                  predicates.enum [ "jsdoc3" ],
                                  predicates.enum [ "jsduck5" ]
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [
                          predicates.enum [ "closurecompiler" ],
                          predicates.enum [ "jsdoc3" ],
                          predicates.enum [ "jsduck5" ]
                        ]
                      ]
                    ]
                  ])
                  | doc m%"
                  Checks whether tag names are valid.
                  "%
                  | optional,
                checkParamExistence
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Checks whether all parameters are documented.
                  "%
                  | optional,
                checkParamNames
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Checks whether param names in jsdoc and in function declaration are equal.
                  "%
                  | optional,
                checkRedundantAccess
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [
                      predicates.isType '"Bool",
                      predicates.isType 'Null,
                      predicates.isType '"String"
                    ],
                    predicates.oneOf
                    [
                      predicates.isType '"Bool",
                      definitions.predicate.nullRule,
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [
                          predicates.enum [ "enforceLeadingUnderscore" ],
                          predicates.enum [ "enforceTrailingUnderscore" ]
                        ]
                      ]
                    ]
                  ])
                  | doc m%"
                  Reports redundant access declarations.
                  "%
                  | optional,
                checkRedundantParams
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Reports redundant params in jsdoc.
                  "%
                  | optional,
                checkRedundantReturns
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Report statements for functions without a return, which are described with an @return tag.
                  "%
                  | optional,
                checkReturnTypes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Checks for differences between the jsdoc and actual return types if both exist.
                  "%
                  | optional,
                checkTypes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [
                      predicates.isType '"Bool",
                      predicates.isType 'Null,
                      predicates.isType '"String"
                    ],
                    predicates.oneOf
                    [
                      predicates.isType '"Bool",
                      definitions.predicate.nullRule,
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [
                          predicates.enum [ "strictNativeCase" ],
                          predicates.enum [ "capitalizedNativeCase" ]
                        ]
                      ]
                    ]
                  ])
                  | doc m%"
                  Reports invalid types for bunch of tags.
                  "%
                  | optional,
                disallowNewlineAfterDescription
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Checks whether a jsdoc comment description has no padding (trailing) newline separator between it and additional @tags.
                  "%
                  | optional,
                enforceExistence
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [
                      predicates.isType '"Bool",
                      predicates.isType 'Null,
                      predicates.isType 'Record,
                      predicates.isType '"String"
                    ],
                    predicates.oneOf
                    [
                      predicates.isType '"Bool",
                      definitions.predicate.nullRule,
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          allExcept = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.oneOf
                                  [
                                    predicates.enum [ "expressions" ],
                                    predicates.enum [ "exports" ],
                                    predicates.enum [ "paramless-procedures" ]
                                  ]
                                ]),
                                predicates.arrays.minItems 0,
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf [ predicates.enum [ "exceptExports" ] ]
                      ]
                    ]
                  ])
                  | doc m%"
                  Checks whether jsdoc block exists.
                  "%
                  | optional,
                leadingUnderscoreAccess
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [
                      predicates.isType '"Bool",
                      predicates.isType 'Null,
                      predicates.isType '"String"
                    ],
                    predicates.oneOf
                    [
                      predicates.isType '"Bool",
                      definitions.predicate.nullRule,
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [
                          predicates.enum [ "private" ],
                          predicates.enum [ "protected" ]
                        ]
                      ]
                    ]
                  ])
                  | doc m%"
                  Checks whether access declaration is set for _underscored function names.  Ignores a bunch of popular identifiers: __filename, __dirname, __proto__, __defineGetter__, super_, __constructor, etc.
                  "%
                  | optional,
                requireDescriptionCompleteSentence
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Checks whether a jsdoc comment description is a complete sentence.  A complete sentence is defined as starting with an upper case letter and ending with a period.
                  "%
                  | optional,
                requireHyphenBeforeDescription
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Checks whether a jsdoc param description has a hyphen before it (checks for -).
                  "%
                  | optional,
                requireNewlineAfterDescription
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Checks whether a jsdoc comment description has a padding (trailing) newline separator between it and additional @tags.
                  "%
                  | optional,
                requireParamDescription
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Checks whether a jsdoc param description exists.
                  "%
                  | optional,
                requireParamTypes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Checks whether params in jsdoc contains type.
                  "%
                  | optional,
                requireReturnDescription
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Checks whether a jsdoc return description exists.
                  "%
                  | optional,
                requireReturnTypes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Checks whether @returns in jsdoc contains type.
                  "%
                  | optional,
                ..
              },
          keywords = predicates.contract_from_predicate
              definitions.predicate.keywords,
          keywords2 = predicates.contract_from_predicate
              definitions.predicate.keywords2,
          nullRule
            | doc m%"
            Removes the rule.
            "%
            = predicates.contract_from_predicate (predicates.isType 'Null),
          operators = predicates.contract_from_predicate
              definitions.predicate.operators,
          unaryOperators = predicates.contract_from_predicate
              definitions.predicate.unaryOperators,
        },
    predicate = {
          blockKeywords = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.enum
                [
                  "catch",
                  "do",
                  "else",
                  "finally",
                  "for",
                  "function",
                  "if",
                  "try",
                  "while"
                ]),
                predicates.arrays.uniqueItems
              ],
          braceRules = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Null, predicates.isType 'Record ],
                predicates.records.record
                {
                  beforeOpeningCurlyBrace = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  beforeOpeningRoundBrace = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                }
                {  }
                true
                predicates.always
              ],
          equalityOperators = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType '"Array",
                  predicates.isType '"Bool",
                  predicates.isType 'Null
                ],
                predicates.arrays.arrayOf
                (predicates.enum [ "==", "===", "!=", "!==", null ]),
                predicates.arrays.uniqueItems
              ],
          esprimaNodeTypes = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.enum
                [
                  "ArrayExpression",
                  "ArrayPattern",
                  "ArrowFunctionExpression",
                  "AssignmentExpression",
                  "AssignmentPattern",
                  "BinaryExpression",
                  "BlockStatement",
                  "BreakStatement",
                  "CallExpression",
                  "CatchClause",
                  "ClassBody",
                  "ClassDeclaration",
                  "ClassExpression",
                  "ConditionalExpression",
                  "ContinueStatement",
                  "DebuggerStatement",
                  "DoWhileStatement",
                  "EmptyStatement",
                  "ExportAllDeclaration",
                  "ExportDefaultDeclaration",
                  "ExportNamedDeclaration",
                  "ExportSpecifier",
                  "ExpressionStatement",
                  "ForInStatement",
                  "ForStatement",
                  "FunctionDeclaration",
                  "FunctionExpression",
                  "Identifier",
                  "IfStatement",
                  "ImportDeclaration",
                  "ImportDefaultSpecifier",
                  "ImportNamespaceSpecifier",
                  "ImportSpecifier",
                  "LabeledStatement",
                  "Literal",
                  "LogicalExpression",
                  "MemberExpression",
                  "MethodDefinition",
                  "NewExpression",
                  "ObjectExpression",
                  "ObjectPattern",
                  "Program",
                  "Property",
                  "RestElement",
                  "ReturnStatement",
                  "SequenceExpression",
                  "SpreadElement",
                  "Super",
                  "SwitchCase",
                  "SwitchStatement",
                  "TaggedTemplateExpression",
                  "TemplateElement",
                  "TemplateLiteral",
                  "ThisExpression",
                  "ThrowStatement",
                  "TryStatement",
                  "UnaryExpression",
                  "UpdateExpression",
                  "VariableDeclaration",
                  "VariableDeclarator",
                  "WhileStatement",
                  "WithStatement"
                ]),
                predicates.arrays.uniqueItems
              ],
          jsDoc
            | doc m%"
            Validate jsdoc comments.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  checkAnnotations = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType 'Null,
                          predicates.isType 'Record,
                          predicates.isType '"String"
                        ],
                        predicates.oneOf
                        [
                          predicates.isType '"Bool",
                          definitions.predicate.nullRule,
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              extra = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record {  } {  } true
                                    (predicates.oneOf
                                    [
                                      predicates.allOf
                                      [
                                        predicates.anyOf
                                        [
                                          predicates.isType '"Bool",
                                          predicates.isType '"String"
                                        ],
                                        predicates.enum [ true, false, "some" ]
                                      ]
                                    ])
                                  ],
                              preset = predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.oneOf
                                    [
                                      predicates.enum [ "closurecompiler" ],
                                      predicates.enum [ "jsdoc3" ],
                                      predicates.enum [ "jsduck5" ]
                                    ]
                                  ],
                            }
                            {  }
                            true
                            predicates.always
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.oneOf
                            [
                              predicates.enum [ "closurecompiler" ],
                              predicates.enum [ "jsdoc3" ],
                              predicates.enum [ "jsduck5" ]
                            ]
                          ]
                        ]
                      ],
                  checkParamExistence = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  checkParamNames = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  checkRedundantAccess = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType 'Null,
                          predicates.isType '"String"
                        ],
                        predicates.oneOf
                        [
                          predicates.isType '"Bool",
                          definitions.predicate.nullRule,
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.oneOf
                            [
                              predicates.enum [ "enforceLeadingUnderscore" ],
                              predicates.enum [ "enforceTrailingUnderscore" ]
                            ]
                          ]
                        ]
                      ],
                  checkRedundantParams = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  checkRedundantReturns = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  checkReturnTypes = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  checkTypes = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType 'Null,
                          predicates.isType '"String"
                        ],
                        predicates.oneOf
                        [
                          predicates.isType '"Bool",
                          definitions.predicate.nullRule,
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.oneOf
                            [
                              predicates.enum [ "strictNativeCase" ],
                              predicates.enum [ "capitalizedNativeCase" ]
                            ]
                          ]
                        ]
                      ],
                  disallowNewlineAfterDescription = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  enforceExistence = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType 'Null,
                          predicates.isType 'Record,
                          predicates.isType '"String"
                        ],
                        predicates.oneOf
                        [
                          predicates.isType '"Bool",
                          definitions.predicate.nullRule,
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              allExcept = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.allOf
                                    [
                                      predicates.isType '"String",
                                      predicates.oneOf
                                      [
                                        predicates.enum [ "expressions" ],
                                        predicates.enum [ "exports" ],
                                        predicates.enum
                                        [ "paramless-procedures" ]
                                      ]
                                    ]),
                                    predicates.arrays.minItems 0,
                                    predicates.arrays.uniqueItems
                                  ],
                            }
                            {  }
                            true
                            predicates.always
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.oneOf
                            [ predicates.enum [ "exceptExports" ] ]
                          ]
                        ]
                      ],
                  leadingUnderscoreAccess = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType 'Null,
                          predicates.isType '"String"
                        ],
                        predicates.oneOf
                        [
                          predicates.isType '"Bool",
                          definitions.predicate.nullRule,
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.oneOf
                            [
                              predicates.enum [ "private" ],
                              predicates.enum [ "protected" ]
                            ]
                          ]
                        ]
                      ],
                  requireDescriptionCompleteSentence = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  requireHyphenBeforeDescription = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  requireNewlineAfterDescription = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  requireParamDescription = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  requireParamTypes = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  requireReturnDescription = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  requireReturnTypes = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                }
                {  }
                true
                predicates.always
              ],
          keywords = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.enum
                [
                  "break",
                  "case",
                  "catch",
                  "continue",
                  "debugger",
                  "default",
                  "delete",
                  "do",
                  "else",
                  "finally",
                  "for",
                  "function",
                  "if",
                  "in",
                  "instanceof",
                  "new",
                  "return",
                  "switch",
                  "this",
                  "throw",
                  "try",
                  "typeof",
                  "var",
                  "void",
                  "while",
                  "with"
                ]),
                predicates.arrays.uniqueItems
              ],
          keywords2 = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType '"Array",
                  predicates.isType '"Bool",
                  predicates.isType 'Null
                ],
                predicates.oneOf
                [ definitions.predicate.keywords, predicates.isType '"Bool" ]
              ],
          nullRule
            | doc m%"
            Removes the rule.
            "%
            = predicates.isType 'Null,
          operators = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType '"Array",
                  predicates.isType '"Bool",
                  predicates.isType 'Null
                ],
                predicates.arrays.arrayOf
                (predicates.enum
                [
                  ",",
                  ":",
                  "?",
                  "^",
                  "^=",
                  "|",
                  "||",
                  "|=",
                  "&",
                  "&&",
                  "&=",
                  "+",
                  "+=",
                  "-",
                  "-=",
                  "%",
                  "%=",
                  "/",
                  "/=",
                  "*",
                  "*=",
                  "=",
                  "==",
                  "===",
                  "!=",
                  "!==",
                  ">",
                  ">>",
                  ">>>",
                  ">=",
                  ">>=",
                  ">>>=",
                  "<",
                  "<<",
                  "<=",
                  "<<=",
                  null
                ]),
                predicates.arrays.uniqueItems
              ],
          unaryOperators = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType '"Array",
                  predicates.isType '"Bool",
                  predicates.isType 'Null
                ],
                predicates.arrays.arrayOf
                (predicates.enum [ "++", "--", "+", "-", "~", "!" ]),
                predicates.arrays.uniqueItems
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.record
  {
    additionalRules = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String"),
          predicates.arrays.uniqueItems
        ],
    disallowAnonymousFunctions = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowArrowFunctions = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowCapitalizedComments = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowCommaBeforeLineBreak = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.enum [ "function" ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowCurlyBraces = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.keywords2 ]
        ],
    disallowDanglingUnderscores = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowEmptyBlocks = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.enum [ "comments" ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowFunctionDeclarations = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowIdenticalDestructuringNames = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowIdentifierNames = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Array", predicates.isType 'Null ],
          predicates.oneOf
          [
            predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String"),
              predicates.arrays.minItems 0,
              predicates.arrays.uniqueItems
            ],
            definitions.predicate.nullRule
          ]
        ],
    disallowImplicitTypeConversion = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Array", predicates.isType 'Null ],
          predicates.arrays.arrayOf
          (predicates.enum [ "numeric", "boolean", "binary", "string" ]),
          predicates.arrays.uniqueItems
        ],
    disallowKeywords = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Array", predicates.isType 'Null ],
          predicates.oneOf [ definitions.predicate.keywords ]
        ],
    disallowKeywordsInComments = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String"),
              predicates.arrays.minItems 0,
              predicates.arrays.uniqueItems
            ],
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.isType '"String"
          ]
        ],
    disallowKeywordsOnNewLine = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Array", predicates.isType 'Null ],
          predicates.oneOf [ definitions.predicate.keywords ]
        ],
    disallowMixedSpacesAndTabs = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType '"String"
          ],
          predicates.enum [ true, false, null, "smart" ]
        ],
    disallowMultiLineTernary = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowMultipleLineBreaks = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowMultipleLineStrings = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowMultipleSpaces = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allowEOLComments = predicates.anyOf
                    [ predicates.isType '"Bool", predicates.isType 'Null ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowMultipleVarDecl = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [
                          predicates.enum [ "require" ],
                          predicates.enum [ "undefined" ]
                        ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                strict = predicates.anyOf
                    [ predicates.isType '"Bool", predicates.isType 'Null ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowNamedUnassignedFunctions = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowNestedTernaries = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                maxLevel = predicates.allOf
                    [
                      predicates.isType 'Integer,
                      predicates.numbers.minimum 1
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowNewlineBeforeBlockStatements = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            definitions.predicate.blockKeywords,
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "multiline" ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                value = predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType '"Bool" ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowNodeTypes = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Array", predicates.isType 'Null ],
          predicates.oneOf [ definitions.predicate.esprimaNodeTypes ]
        ],
    disallowNotOperatorsInConditionals = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowObjectKeysOnNewLine = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowOperatorBeforeLineBreak = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.operators ]
        ],
    disallowPaddingNewLinesAfterBlocks = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowPaddingNewLinesAfterUseStrict = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowPaddingNewLinesBeforeExport = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowPaddingNewLinesBeforeLineComments = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    disallowPaddingNewLinesInObjects = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowPaddingNewlinesBeforeKeywords = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.keywords2 ]
        ],
    disallowPaddingNewlinesInBlocks = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.enum [ "conditionals", "functions" ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                close = predicates.isType '"Bool",
                open = predicates.isType '"Bool",
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowParenthesesAroundArrowParam = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowQuotedKeysInObjects = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "reserved" ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf [ predicates.enum [ "allButReserved" ] ]
            ]
          ]
        ],
    disallowSemicolons = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowShorthandArrowFunctions = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowSpaceAfterBinaryOperators = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.operators ]
        ],
    disallowSpaceAfterComma = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf [ predicates.enum [ "sparseArrays" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowSpaceAfterKeywords = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.keywords2 ]
        ],
    disallowSpaceAfterLineComment = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowSpaceAfterObjectKeys = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [
                          predicates.enum [ "singleline" ],
                          predicates.enum [ "multiline" ],
                          predicates.enum [ "aligned" ],
                          predicates.enum [ "method" ]
                        ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf
              [
                predicates.enum [ "ignoreSingleLine" ],
                predicates.enum [ "ignoreMultiLine" ]
              ]
            ]
          ]
        ],
    disallowSpaceAfterPrefixUnaryOperators = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.unaryOperators ]
        ],
    disallowSpaceBeforeBinaryOperators = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.operators ]
        ],
    disallowSpaceBeforeBlockStatements = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowSpaceBeforeComma = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf [ predicates.enum [ "sparseArrays" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf [ predicates.enum [ "exceptExports" ] ]
            ]
          ]
        ],
    disallowSpaceBeforeKeywords = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.keywords2 ]
        ],
    disallowSpaceBeforeObjectValues = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowSpaceBeforePostfixUnaryOperators = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.unaryOperators ]
        ],
    disallowSpaceBeforeSemicolon = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.anyOf
                        [
                          predicates.enum [ "(" ],
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 1
                          ]
                        ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowSpaceBetweenArguments = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowSpacesInAnonymousFunctionExpression = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf [ definitions.predicate.braceRules ]
        ],
    disallowSpacesInCallExpression = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowSpacesInConditionalExpression = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.anyOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.records.record
            {
              afterConsequent = predicates.isType '"Bool",
              afterTest = predicates.isType '"Bool",
              beforeAlternate = predicates.isType '"Bool",
              beforeConsequent = predicates.isType '"Bool",
            }
            {  }
            true
            predicates.always
          ]
        ],
    disallowSpacesInForStatement = predicates.anyOf
        [ predicates.isType '"Bool", predicates.isType 'Null ],
    disallowSpacesInFunction = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf [ definitions.predicate.braceRules ]
        ],
    disallowSpacesInFunctionDeclaration = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf [ definitions.predicate.braceRules ]
        ],
    disallowSpacesInFunctionExpression = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf [ definitions.predicate.braceRules ]
        ],
    disallowSpacesInGenerator = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf
          [
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                afterStar = predicates.isType '"Bool",
                beforeStar = predicates.isType '"Bool",
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowSpacesInNamedFunctionExpression = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf [ definitions.predicate.braceRules ]
        ],
    disallowSpacesInsideArrayBrackets = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.allOf
            [
              predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
              predicates.enum [ true, false, "all" ]
            ],
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [ predicates.enum [ "(", ")", "{", "}", "[", "]" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf [ predicates.enum [ "nested" ] ]
            ]
          ]
        ],
    disallowSpacesInsideBrackets = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [ predicates.enum [ "(", ")", "{", "}", "[", "]" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowSpacesInsideObjectBrackets = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.allOf
            [
              predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
              predicates.enum [ true, false, "all" ]
            ],
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf [ predicates.enum [ ")", "}", "]" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf [ predicates.enum [ "nested" ] ]
            ]
          ]
        ],
    disallowSpacesInsideParentheses = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType '"String",
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.allOf
            [
              predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
              predicates.enum [ true, false, "all" ]
            ],
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                only = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.anyOf
                        [
                          predicates.enum
                          [ "(", ")", "{", "}", "[", "]", "function" ],
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ]
                        ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowSpacesInsideParenthesizedExpression = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [
                          predicates.enum
                          [ "(", ")", "{", "}", "[", "]", "function" ]
                        ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    disallowSpacesInsideTemplateStringPlaceholders = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    disallowTabs = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    disallowTrailingComma = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    disallowTrailingWhitespace = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.allOf
            [
              predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
              predicates.enum [ true, false, "ignoreEmptyLines" ]
            ],
            definitions.predicate.nullRule
          ]
        ],
    disallowUnusedParams = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    disallowVar = predicates.oneOf
        [ predicates.isType '"Bool", definitions.predicate.nullRule ],
    disallowYodaConditions = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.equalityOperators ]
        ],
    excludeFiles = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String"),
          predicates.arrays.uniqueItems
        ],
    jsDoc = definitions.predicate.jsDoc,
    maximumLineLength = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType 'Integer,
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 1 ],
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.required [ "value" ],
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        predicates.enum [ "comments" ],
                        predicates.enum [ "functionSignature" ],
                        predicates.enum [ "regex" ],
                        predicates.enum [ "require" ],
                        predicates.enum [ "urlComments" ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                tabSize = predicates.allOf
                    [
                      predicates.isType 'Integer,
                      predicates.numbers.minimum 1
                    ],
                value = predicates.allOf
                    [
                      predicates.isType 'Integer,
                      predicates.numbers.minimum 1
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    maximumNumberOfLines = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType 'Integer,
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 1 ],
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.required [ "value" ],
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.enum [ "comments" ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                value = predicates.allOf
                    [
                      predicates.isType 'Integer,
                      predicates.numbers.minimum 1
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    preset = predicates.allOf
        [
          predicates.isType '"String",
          predicates.enum
          [
            "airbnb",
            "crockford",
            "google",
            "grunt",
            "idiomatic",
            "jquery",
            "mdcs",
            "node-style-guide",
            "wikimedia",
            "wordpress",
            "yandex"
          ]
        ],
    requireAlignedMultilineParams = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Integer,
            predicates.isType 'Null,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Integer,
            definitions.predicate.nullRule,
            predicates.allOf
            [ predicates.isType '"String", predicates.enum [ "firstParam" ] ]
          ]
        ],
    requireAlignedObjectValues = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType '"String" ],
          predicates.oneOf
          [
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf
              [
                predicates.enum [ "all" ],
                predicates.enum [ "ignoreFunction" ],
                predicates.enum [ "ignoreLineBreak" ]
              ]
            ]
          ]
        ],
    requireAnonymousFunctions = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.enum [ "declarations" ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireArrayDestructuring = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireArrowFunctions = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireBlocksOnNewline = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Integer,
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Integer,
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                includeComments = predicates.isType '"Bool",
                minLines = predicates.isType 'Integer,
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireCamelCaseOrUpperCaseIdentifiers = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                allowedPrefixes = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                allowedSuffixes = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                ignoreProperties = predicates.isType '"Bool",
                strict = predicates.isType '"Bool",
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf [ predicates.enum [ "ignoreProperties" ] ]
            ]
          ]
        ],
    requireCapitalizedComments = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                inlined = predicates.isType '"Bool",
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireCapitalizedConstructors = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireCapitalizedConstructorsNew = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireCommaBeforeLineBreak = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireCurlyBraces = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            definitions.predicate.keywords2,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                keywords = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireDollarBeforejQueryAssignment = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.allOf
            [
              predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"String" ],
              predicates.enum [ true, false, "ignoreProperties" ]
            ],
            definitions.predicate.nullRule
          ]
        ],
    requireDotNotation = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [
                          predicates.enum [ "keywords" ],
                          predicates.enum [ "snake_case" ]
                        ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf [ predicates.enum [ "except_snake_case" ] ]
            ]
          ]
        ],
    requireEarlyReturn = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireEnhancedObjectLiterals = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireFunctionDeclarations = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireImportAlphabetized = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireKeywordsOnNewLine = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Array", predicates.isType 'Null ],
          predicates.oneOf [ definitions.predicate.keywords ]
        ],
    requireLineBreakAfterVariableAssignment = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireLineFeedAtFileEnd = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireMatchingFunctionName = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              { includeModuleExports = predicates.isType '"Bool", }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireMultiLineTernary = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireMultipleVarDecl = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf [ predicates.enum [ "require" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf [ predicates.enum [ "onevar" ] ]
            ]
          ]
        ],
    requireNamedUnassignedFunctions = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireNewlineBeforeBlockStatements = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.keywords2 ]
        ],
    requireNumericLiterals = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireObjectDestructuring = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireObjectKeysOnNewLine = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf [ predicates.enum [ "sameLine" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireOperatorBeforeLineBreak = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.operators ]
        ],
    requirePaddingNewLineAfterVariableDeclaration = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requirePaddingNewLinesAfterBlocks = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [
                          predicates.enum [ "inCallExpressions" ],
                          predicates.enum [ "inNewExpressions" ],
                          predicates.enum [ "inArrayExpressions" ],
                          predicates.enum [ "inProperties" ]
                        ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requirePaddingNewLinesAfterUseStrict = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf [ predicates.enum [ "require" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requirePaddingNewLinesBeforeExport = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requirePaddingNewLinesBeforeLineComments = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [ predicates.enum [ "firstAfterCurly" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requirePaddingNewLinesInObjects = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requirePaddingNewlinesBeforeKeywords = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.keywords2 ]
        ],
    requirePaddingNewlinesInBlocks = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Integer,
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Integer,
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [
                          predicates.enum [ "conditionals" ],
                          predicates.enum [ "functions" ]
                        ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                close = predicates.isType '"Bool",
                open = predicates.isType '"Bool",
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireParenthesesAroundArrowParam = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireParenthesesAroundIIFE = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireQuotedKeysInObjects = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireSemicolons = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireShorthandArrowFunctions = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireSpaceAfterBinaryOperators = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.operators ]
        ],
    requireSpaceAfterComma = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf [ predicates.enum [ "trailing" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireSpaceAfterKeywords = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.keywords2 ]
        ],
    requireSpaceAfterLineComment = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf [ predicates.enum [ "allowSlash" ] ]
            ]
          ]
        ],
    requireSpaceAfterObjectKeys = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireSpaceAfterPrefixUnaryOperators = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.unaryOperators ]
        ],
    requireSpaceBeforeBinaryOperators = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.operators ]
        ],
    requireSpaceBeforeBlockStatements = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Integer
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 1 ]
          ]
        ],
    requireSpaceBeforeComma = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireSpaceBeforeKeywords = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            definitions.predicate.blockKeywords,
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireSpaceBeforeObjectValues = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireSpaceBeforePostfixUnaryOperators = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf [ definitions.predicate.unaryOperators ]
        ],
    requireSpaceBetweenArguments = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireSpacesInAnonymousFunctionExpression = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf
          [
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType 'Null,
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.nullRule,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.oneOf [ predicates.enum [ "shorthand" ] ]
                          ]),
                          predicates.arrays.minItems 0,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                beforeOpeningCurlyBrace = predicates.anyOf
                    [ predicates.isType '"Bool", predicates.isType 'Null ],
                beforeOpeningRoundBrace = predicates.anyOf
                    [ predicates.isType '"Bool", predicates.isType 'Null ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireSpacesInCallExpression = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireSpacesInConditionalExpression = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                afterConsequent = predicates.isType '"Bool",
                afterTest = predicates.isType '"Bool",
                beforeAlternate = predicates.isType '"Bool",
                beforeConsequent = predicates.isType '"Bool",
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireSpacesInForStatement = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireSpacesInFunction = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf [ definitions.predicate.braceRules ]
        ],
    requireSpacesInFunctionDeclaration = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf [ definitions.predicate.braceRules ]
        ],
    requireSpacesInFunctionExpression = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf [ definitions.predicate.braceRules ]
        ],
    requireSpacesInGenerator = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf
          [
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                afterStar = predicates.isType '"Bool",
                beforeStar = predicates.isType '"Bool",
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireSpacesInNamedFunctionExpression = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf [ definitions.predicate.braceRules ]
        ],
    requireSpacesInsideArrayBrackets = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [ predicates.enum [ "{", "}", "[", "]" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf
              [ predicates.enum [ "all" ], predicates.enum [ "allButNested" ] ]
            ]
          ]
        ],
    requireSpacesInsideBrackets = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [ predicates.enum [ "{", "}", "[", "]" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireSpacesInsideObjectBrackets = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [ predicates.enum [ "(", ")", "{", "}", "[", "]" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf
              [ predicates.enum [ "all" ], predicates.enum [ "allButNested" ] ]
            ]
          ]
        ],
    requireSpacesInsideParentheses = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                all = predicates.isType '"Bool",
                except = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.anyOf
                        [
                          predicates.enum [ "(", ")", "{", "}", "[", "]" ],
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.maxLength 1
                          ]
                        ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                ignoreParenthesizedExpression = predicates.isType '"Bool",
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf
              [ predicates.enum [ "all" ], predicates.enum [ "allButNested" ] ]
            ]
          ]
        ],
    requireSpacesInsideParenthesizedExpression = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [ predicates.enum [ "{", "}", "function" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireSpread = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireTemplateStrings = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [ predicates.enum [ "stringConcatenation" ] ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireTrailingComma = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                ignoreSingleLine = predicates.isType '"Bool",
                ignoreSingleValue = predicates.isType '"Bool",
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    requireVarDeclFirst = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Null ],
          predicates.oneOf
          [ predicates.isType '"Bool", definitions.predicate.nullRule ]
        ],
    requireYodaConditions = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType '"Bool",
            predicates.isType 'Null
          ],
          predicates.oneOf
          [
            definitions.predicate.equalityOperators,
            predicates.isType '"Bool",
            definitions.predicate.nullRule
          ]
        ],
    safeContextKeyword = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Array",
            predicates.isType 'Null,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ]),
              predicates.arrays.minItems 0,
              predicates.arrays.uniqueItems
            ],
            definitions.predicate.nullRule,
            predicates.allOf
            [ predicates.isType '"String", predicates.strings.minLength 1 ]
          ]
        ],
    validateAlignedFunctionParameters = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                lineBreakAfterOpeningBrace = predicates.isType '"Bool",
                lineBreakBeforeClosingBrace = predicates.isType '"Bool",
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    validateCommentPosition = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType 'Record ],
          predicates.oneOf
          [
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                position = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "above", "beside" ]
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    validateIndentation = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType 'Integer,
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 0 ],
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.required [ "value" ],
              predicates.records.record
              {
                allExcept = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.oneOf
                        [
                          predicates.enum [ "comments" ],
                          predicates.enum [ "emptyLines" ]
                        ]
                      ]),
                      predicates.arrays.minItems 0,
                      predicates.arrays.uniqueItems
                    ],
                includeEmptyLines = predicates.isType '"Bool",
                value = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.isType '"String"
                      ],
                      predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 0
                        ],
                        predicates.isType '"String"
                      ]
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    validateLineBreaks = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                character = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "CR", "LF", "CRLF" ]
                    ],
                reportOncePerFile = predicates.isType '"Bool",
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.enum [ "CR", "LF", "CRLF" ]
            ]
          ]
        ],
    validateNewlineAfterArrayElements = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Integer,
            predicates.isType 'Null,
            predicates.isType 'Record
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 0 ],
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                ignoreBrackets = predicates.isType '"Bool",
                maximum = predicates.allOf
                    [
                      predicates.isType 'Integer,
                      predicates.numbers.minimum 0
                    ],
              }
              {  }
              true
              predicates.always
            ]
          ]
        ],
    validateOrderInObjectKeys = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf
              [
                predicates.enum [ "asc" ],
                predicates.enum [ "asc-insensitive" ],
                predicates.enum [ "asc-natural" ],
                predicates.enum [ "desc" ],
                predicates.enum [ "desc-insensitive" ],
                predicates.enum [ "desc-natural" ]
              ]
            ]
          ]
        ],
    validateParameterSeparator = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Null, predicates.isType '"String" ],
          predicates.oneOf
          [
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf
              [
                predicates.enum [ "," ],
                predicates.enum [ ", " ],
                predicates.enum [ " ," ],
                predicates.enum [ " , " ]
              ]
            ]
          ]
        ],
    validateQuoteMarks = predicates.allOf
        [
          predicates.anyOf
          [
            predicates.isType '"Bool",
            predicates.isType 'Null,
            predicates.isType 'Record,
            predicates.isType '"String"
          ],
          predicates.oneOf
          [
            predicates.isType '"Bool",
            definitions.predicate.nullRule,
            predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.required [ "value" ],
              predicates.records.record
              {
                escape = predicates.isType '"Bool",
                ignoreJSX = predicates.isType '"Bool",
                mark = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.oneOf
                      [ predicates.enum [ "" ], predicates.enum [ "" ] ]
                    ],
              }
              {  }
              true
              predicates.always
            ],
            predicates.allOf
            [
              predicates.isType '"String",
              predicates.oneOf
              [ predicates.enum [ "\"" ], predicates.enum [ "'" ] ]
            ]
          ]
        ],
  }
  {  }
  true
  predicates.always
])