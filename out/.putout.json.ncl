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
          rule = predicates.contract_from_predicate definitions.predicate.rule,
          rules
            | doc m%"
            🐊Putout comes with a large number of rules. You can modify which rules your project uses.
            "%
            = {
                add-return-await | definitions.contract.rule | optional,
                apply-at | definitions.contract.rule | optional,
                apply-await-import | definitions.contract.rule | optional,
                apply-destructuring | definitions.contract.rule | optional,
                apply-early-return | definitions.contract.rule | optional,
                apply-montag | definitions.contract.rule | optional,
                apply-nullish-coalescing | definitions.contract.rule | optional,
                apply-numeric-separators | definitions.contract.rule | optional,
                apply-optional-chaining | definitions.contract.rule | optional,
                apply-shorthand-properties
                  | definitions.contract.rule
                  | optional,
                apply-try-catch | definitions.contract.rule | optional,
                apply-utility-types | definitions.contract.rule | optional,
                browserlist | definitions.contract.rule | optional,
                cloudcmd | definitions.contract.rule | optional,
                conditions | definitions.contract.rule | optional,
                "conditions/apply-comparison-order"
                  | definitions.contract.rule
                  | optional,
                "conditions/apply-if" | definitions.contract.rule | optional,
                "conditions/convert-comparison-to-boolean"
                  | definitions.contract.rule
                  | optional,
                "conditions/convert-equal-to-strict-equal"
                  | definitions.contract.rule
                  | optional,
                "conditions/evaluate" | definitions.contract.rule | optional,
                "conditions/merge-if-statements"
                  | definitions.contract.rule
                  | optional,
                "conditions/remove-boolean"
                  | definitions.contract.rule
                  | optional,
                "conditions/remove-constant"
                  | definitions.contract.rule
                  | optional,
                "conditions/remove-useless-else"
                  | definitions.contract.rule
                  | optional,
                "conditions/simplify" | definitions.contract.rule | optional,
                convert-apply-to-spread | definitions.contract.rule | optional,
                convert-arguments-to-rest
                  | definitions.contract.rule
                  | optional,
                convert-array-copy-to-slice
                  | definitions.contract.rule
                  | optional,
                convert-assignment-to-arrow-function
                  | definitions.contract.rule
                  | optional,
                convert-assignment-to-comparison
                  | definitions.contract.rule
                  | optional,
                convert-bitwise-to-logical
                  | definitions.contract.rule
                  | optional,
                convert-commonjs-to-esm | definitions.contract.rule | optional,
                convert-concat-to-flat | definitions.contract.rule | optional,
                convert-esm-to-commonjs | definitions.contract.rule | optional,
                convert-index-of-to-includes
                  | definitions.contract.rule
                  | optional,
                convert-is-nan-to-number-is-nan
                  | definitions.contract.rule
                  | optional,
                convert-math-pow | definitions.contract.rule | optional,
                convert-mock-require-to-mock-import
                  | definitions.contract.rule
                  | optional,
                convert-object-assign-to-merge-spread
                  | definitions.contract.rule
                  | optional,
                convert-quotes-to-backticks
                  | definitions.contract.rule
                  | optional,
                convert-spread-to-array-from
                  | definitions.contract.rule
                  | optional,
                convert-template-to-string
                  | definitions.contract.rule
                  | optional,
                convert-throw | definitions.contract.rule | optional,
                convert-to-arrow-function
                  | definitions.contract.rule
                  | optional,
                declare | definitions.contract.rule | optional,
                eslint | definitions.contract.rule | optional,
                extract-object-properties
                  | definitions.contract.rule
                  | optional,
                extract-sequence-expressions
                  | definitions.contract.rule
                  | optional,
                "for-of/for" | definitions.contract.rule | optional,
                "for-of/for-each" | definitions.contract.rule | optional,
                "for-of/for-in" | definitions.contract.rule | optional,
                "for-of/map" | definitions.contract.rule | optional,
                "for-of/remove-unused-variables"
                  | definitions.contract.rule
                  | optional,
                "for-of/remove-useless" | definitions.contract.rule | optional,
                "for-of/remove-useless-array-from"
                  | definitions.contract.rule
                  | optional,
                github | definitions.contract.rule | optional,
                gitignore | definitions.contract.rule | optional,
                jest | definitions.contract.rule | optional,
                madrun | definitions.contract.rule | optional,
                maybe | definitions.contract.rule | optional,
                merge-destructuring-properties
                  | definitions.contract.rule
                  | optional,
                merge-duplicate-imports | definitions.contract.rule | optional,
                nodejs | definitions.contract.rule | optional,
                "nodejs/convert-dirname-to-url"
                  | definitions.contract.rule
                  | optional,
                "nodejs/convert-fs-promises"
                  | definitions.contract.rule
                  | optional,
                "nodejs/convert-promisify-to-fs-promises"
                  | definitions.contract.rule
                  | optional,
                "nodejs/convert-top-level-return"
                  | definitions.contract.rule
                  | optional,
                "nodejs/remove-process-exit"
                  | definitions.contract.rule
                  | optional,
                npmignore | definitions.contract.rule | optional,
                package-json | definitions.contract.rule | optional,
                postcss | definitions.contract.rule | optional,
                promises | definitions.contract.rule | optional,
                "promises/add-missing-await"
                  | definitions.contract.rule
                  | optional,
                "promises/apply-top-level-await"
                  | definitions.contract.rule
                  | optional,
                "promises/convert-new-promise-to-async"
                  | definitions.contract.rule
                  | optional,
                "promises/convert-reject-to-throw"
                  | definitions.contract.rule
                  | optional,
                "promises/remove-useless-async"
                  | definitions.contract.rule
                  | optional,
                "promises/remove-useless-await"
                  | definitions.contract.rule
                  | optional,
                "promises/remove-useless-resolve"
                  | definitions.contract.rule
                  | optional,
                putout | definitions.contract.rule | optional,
                putout-config | definitions.contract.rule | optional,
                "putout/add-args" | definitions.contract.rule | optional,
                "putout/add-index-to-import"
                  | definitions.contract.rule
                  | optional,
                "putout/add-push" | definitions.contract.rule | optional,
                "putout/apply-async-formatter"
                  | definitions.contract.rule
                  | optional,
                "putout/apply-create-test"
                  | definitions.contract.rule
                  | optional,
                "putout/apply-declare" | definitions.contract.rule | optional,
                "putout/apply-insert-after"
                  | definitions.contract.rule
                  | optional,
                "putout/apply-insert-before"
                  | definitions.contract.rule
                  | optional,
                "putout/apply-namaspace-specifier"
                  | definitions.contract.rule
                  | optional,
                "putout/apply-processors-destructuring"
                  | definitions.contract.rule
                  | optional,
                "putout/apply-remove" | definitions.contract.rule | optional,
                "putout/check-match" | definitions.contract.rule | optional,
                "putout/check-replace-code"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-add-argument-to-add-args"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-babel-types"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-destructuring-to-identifier"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-dirname-to-url"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-find-to-traverse"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-get-rule-to-require"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-match-to-function"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-method-to-property"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-node-to-path-in-get-template-values"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-number-to-numeric"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-process-to-find"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-putout-test-to-create-test"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-replace-to-function"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-replace-with"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-replace-with-multiple"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-report-to-function"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-to-no-transform-code"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-traverse-to-include"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-traverse-to-replace"
                  | definitions.contract.rule
                  | optional,
                "putout/convert-url-to-dirname"
                  | definitions.contract.rule
                  | optional,
                "putout/create-test" | definitions.contract.rule | optional,
                "putout/declare" | definitions.contract.rule | optional,
                "putout/includer" | definitions.contract.rule | optional,
                "putout/insert-rust" | definitions.contract.rule | optional,
                "putout/move-require-on-top-level"
                  | definitions.contract.rule
                  | optional,
                "putout/rename-operate-to-operator"
                  | definitions.contract.rule
                  | optional,
                "putout/replace-operate-with-operator"
                  | definitions.contract.rule
                  | optional,
                "putout/replace-test-message"
                  | definitions.contract.rule
                  | optional,
                "putout/shorten-imports" | definitions.contract.rule | optional,
                react-hooks | definitions.contract.rule | optional,
                regexp | definitions.contract.rule | optional,
                remove-boolean-from-assertions
                  | definitions.contract.rule
                  | optional,
                remove-boolean-from-logical-expressions
                  | definitions.contract.rule
                  | optional,
                remove-console | definitions.contract.rule | optional,
                remove-debugger | definitions.contract.rule | optional,
                remove-duplicate-case | definitions.contract.rule | optional,
                remove-duplicate-interface-keys
                  | definitions.contract.rule
                  | optional,
                remove-duplicate-keys | definitions.contract.rule | optional,
                remove-duplicates-from-logical-expressions
                  | definitions.contract.rule
                  | optional,
                remove-duplicates-from-union
                  | definitions.contract.rule
                  | optional,
                remove-empty | definitions.contract.rule | optional,
                "remove-empty/argument" | definitions.contract.rule | optional,
                "remove-empty/block" | definitions.contract.rule | optional,
                "remove-empty/export" | definitions.contract.rule | optional,
                "remove-empty/import" | definitions.contract.rule | optional,
                "remove-empty/pattern" | definitions.contract.rule | optional,
                remove-iife | definitions.contract.rule | optional,
                remove-nested-blocks | definitions.contract.rule | optional,
                remove-unreachable-code | definitions.contract.rule | optional,
                remove-unreferenced-variables
                  | definitions.contract.rule
                  | optional,
                remove-unused-expressions
                  | definitions.contract.rule
                  | optional,
                remove-unused-private-fields
                  | definitions.contract.rule
                  | optional,
                remove-unused-types | definitions.contract.rule | optional,
                remove-unused-variables | definitions.contract.rule | optional,
                remove-useless-arguments | definitions.contract.rule | optional,
                remove-useless-array-constructor
                  | definitions.contract.rule
                  | optional,
                remove-useless-array-entries
                  | definitions.contract.rule
                  | optional,
                remove-useless-constructor
                  | definitions.contract.rule
                  | optional,
                remove-useless-continue | definitions.contract.rule | optional,
                remove-useless-escape | definitions.contract.rule | optional,
                remove-useless-functions | definitions.contract.rule | optional,
                remove-useless-map | definitions.contract.rule | optional,
                remove-useless-new | definitions.contract.rule | optional,
                remove-useless-operand | definitions.contract.rule | optional,
                remove-useless-return | definitions.contract.rule | optional,
                remove-useless-spread | definitions.contract.rule | optional,
                remove-useless-template-expressions
                  | definitions.contract.rule
                  | optional,
                remove-useless-templates | definitions.contract.rule | optional,
                remove-useless-type-conversion
                  | definitions.contract.rule
                  | optional,
                remove-useless-types-from-constants
                  | definitions.contract.rule
                  | optional,
                remove-useless-variables | definitions.contract.rule | optional,
                reuse-duplicate-init | definitions.contract.rule | optional,
                simplify-assignment | definitions.contract.rule | optional,
                simplify-logical-expressions
                  | definitions.contract.rule
                  | optional,
                simplify-ternary | definitions.contract.rule | optional,
                split-nested-destructuring
                  | definitions.contract.rule
                  | optional,
                split-variable-declarations
                  | definitions.contract.rule
                  | optional,
                strict-mode | definitions.contract.rule | optional,
                tape | definitions.contract.rule | optional,
                "tape/remove-only" | definitions.contract.rule | optional,
                "tape/remove-skip" | definitions.contract.rule | optional,
                travis | definitions.contract.rule | optional,
                types | definitions.contract.rule | optional,
                "types/apply-is-array" | definitions.contract.rule | optional,
                "types/convert-typeof-to-is-type"
                  | definitions.contract.rule
                  | optional,
                "types/remove-double-negations"
                  | definitions.contract.rule
                  | optional,
                "types/remove-useless-conversion"
                  | definitions.contract.rule
                  | optional,
                "types/remove-useless-typeof"
                  | definitions.contract.rule
                  | optional,
                typescript | definitions.contract.rule | optional,
                "typescript/apply-as-type-assertion"
                  | definitions.contract.rule
                  | optional,
                "typescript/apply-utility-types"
                  | definitions.contract.rule
                  | optional,
                "typescript/convert-generic-to-shorthand"
                  | definitions.contract.rule
                  | optional,
                "typescript/remove-duplicate-interface-keys"
                  | definitions.contract.rule
                  | optional,
                "typescript/remove-duplicates-from-union"
                  | definitions.contract.rule
                  | optional,
                "typescript/remove-unused-types"
                  | definitions.contract.rule
                  | optional,
                "typescript/remove-useless-mapped-types"
                  | definitions.contract.rule
                  | optional,
                "typescript/remove-useless-mapping-modifiers"
                  | definitions.contract.rule
                  | optional,
                "typescript/remove-useless-types"
                  | definitions.contract.rule
                  | optional,
                "typescript/remove-useless-types-from-constants"
                  | definitions.contract.rule
                  | optional,
                webpack | definitions.contract.rule | optional,
                ..
              },
        },
    predicate = {
          rule = predicates.oneOf
              [
                predicates.enum [ "on", "off" ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.items
                  [
                    predicates.enum [ "on", "off" ],
                    predicates.isType 'Record
                  ],
                  predicates.arrays.additionalItems predicates.never 2,
                  predicates.arrays.minItems 2
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.items
                  [
                    predicates.enum [ "on", "off" ],
                    predicates.isType '"String",
                    predicates.isType 'Record
                  ],
                  predicates.arrays.additionalItems predicates.never 3,
                  predicates.arrays.minItems 3
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.items
                  [
                    predicates.enum [ "on", "off" ],
                    predicates.isType '"String"
                  ],
                  predicates.arrays.additionalItems predicates.never 2,
                  predicates.arrays.minItems 2
                ]
              ],
          rules
            | doc m%"
            🐊Putout comes with a large number of rules. You can modify which rules your project uses.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  add-return-await = definitions.predicate.rule,
                  apply-at = definitions.predicate.rule,
                  apply-await-import = definitions.predicate.rule,
                  apply-destructuring = definitions.predicate.rule,
                  apply-early-return = definitions.predicate.rule,
                  apply-montag = definitions.predicate.rule,
                  apply-nullish-coalescing = definitions.predicate.rule,
                  apply-numeric-separators = definitions.predicate.rule,
                  apply-optional-chaining = definitions.predicate.rule,
                  apply-shorthand-properties = definitions.predicate.rule,
                  apply-try-catch = definitions.predicate.rule,
                  apply-utility-types = definitions.predicate.rule,
                  browserlist = definitions.predicate.rule,
                  cloudcmd = definitions.predicate.rule,
                  conditions = definitions.predicate.rule,
                  "conditions/apply-comparison-order" =
                    definitions.predicate.rule,
                  "conditions/apply-if" = definitions.predicate.rule,
                  "conditions/convert-comparison-to-boolean" =
                    definitions.predicate.rule,
                  "conditions/convert-equal-to-strict-equal" =
                    definitions.predicate.rule,
                  "conditions/evaluate" = definitions.predicate.rule,
                  "conditions/merge-if-statements" = definitions.predicate.rule,
                  "conditions/remove-boolean" = definitions.predicate.rule,
                  "conditions/remove-constant" = definitions.predicate.rule,
                  "conditions/remove-useless-else" = definitions.predicate.rule,
                  "conditions/simplify" = definitions.predicate.rule,
                  convert-apply-to-spread = definitions.predicate.rule,
                  convert-arguments-to-rest = definitions.predicate.rule,
                  convert-array-copy-to-slice = definitions.predicate.rule,
                  convert-assignment-to-arrow-function =
                    definitions.predicate.rule,
                  convert-assignment-to-comparison = definitions.predicate.rule,
                  convert-bitwise-to-logical = definitions.predicate.rule,
                  convert-commonjs-to-esm = definitions.predicate.rule,
                  convert-concat-to-flat = definitions.predicate.rule,
                  convert-esm-to-commonjs = definitions.predicate.rule,
                  convert-index-of-to-includes = definitions.predicate.rule,
                  convert-is-nan-to-number-is-nan = definitions.predicate.rule,
                  convert-math-pow = definitions.predicate.rule,
                  convert-mock-require-to-mock-import =
                    definitions.predicate.rule,
                  convert-object-assign-to-merge-spread =
                    definitions.predicate.rule,
                  convert-quotes-to-backticks = definitions.predicate.rule,
                  convert-spread-to-array-from = definitions.predicate.rule,
                  convert-template-to-string = definitions.predicate.rule,
                  convert-throw = definitions.predicate.rule,
                  convert-to-arrow-function = definitions.predicate.rule,
                  declare = definitions.predicate.rule,
                  eslint = definitions.predicate.rule,
                  extract-object-properties = definitions.predicate.rule,
                  extract-sequence-expressions = definitions.predicate.rule,
                  "for-of/for" = definitions.predicate.rule,
                  "for-of/for-each" = definitions.predicate.rule,
                  "for-of/for-in" = definitions.predicate.rule,
                  "for-of/map" = definitions.predicate.rule,
                  "for-of/remove-unused-variables" = definitions.predicate.rule,
                  "for-of/remove-useless" = definitions.predicate.rule,
                  "for-of/remove-useless-array-from" =
                    definitions.predicate.rule,
                  github = definitions.predicate.rule,
                  gitignore = definitions.predicate.rule,
                  jest = definitions.predicate.rule,
                  madrun = definitions.predicate.rule,
                  maybe = definitions.predicate.rule,
                  merge-destructuring-properties = definitions.predicate.rule,
                  merge-duplicate-imports = definitions.predicate.rule,
                  nodejs = definitions.predicate.rule,
                  "nodejs/convert-dirname-to-url" = definitions.predicate.rule,
                  "nodejs/convert-fs-promises" = definitions.predicate.rule,
                  "nodejs/convert-promisify-to-fs-promises" =
                    definitions.predicate.rule,
                  "nodejs/convert-top-level-return" =
                    definitions.predicate.rule,
                  "nodejs/remove-process-exit" = definitions.predicate.rule,
                  npmignore = definitions.predicate.rule,
                  package-json = definitions.predicate.rule,
                  postcss = definitions.predicate.rule,
                  promises = definitions.predicate.rule,
                  "promises/add-missing-await" = definitions.predicate.rule,
                  "promises/apply-top-level-await" = definitions.predicate.rule,
                  "promises/convert-new-promise-to-async" =
                    definitions.predicate.rule,
                  "promises/convert-reject-to-throw" =
                    definitions.predicate.rule,
                  "promises/remove-useless-async" = definitions.predicate.rule,
                  "promises/remove-useless-await" = definitions.predicate.rule,
                  "promises/remove-useless-resolve" =
                    definitions.predicate.rule,
                  putout = definitions.predicate.rule,
                  putout-config = definitions.predicate.rule,
                  "putout/add-args" = definitions.predicate.rule,
                  "putout/add-index-to-import" = definitions.predicate.rule,
                  "putout/add-push" = definitions.predicate.rule,
                  "putout/apply-async-formatter" = definitions.predicate.rule,
                  "putout/apply-create-test" = definitions.predicate.rule,
                  "putout/apply-declare" = definitions.predicate.rule,
                  "putout/apply-insert-after" = definitions.predicate.rule,
                  "putout/apply-insert-before" = definitions.predicate.rule,
                  "putout/apply-namaspace-specifier" =
                    definitions.predicate.rule,
                  "putout/apply-processors-destructuring" =
                    definitions.predicate.rule,
                  "putout/apply-remove" = definitions.predicate.rule,
                  "putout/check-match" = definitions.predicate.rule,
                  "putout/check-replace-code" = definitions.predicate.rule,
                  "putout/convert-add-argument-to-add-args" =
                    definitions.predicate.rule,
                  "putout/convert-babel-types" = definitions.predicate.rule,
                  "putout/convert-destructuring-to-identifier" =
                    definitions.predicate.rule,
                  "putout/convert-dirname-to-url" = definitions.predicate.rule,
                  "putout/convert-find-to-traverse" =
                    definitions.predicate.rule,
                  "putout/convert-get-rule-to-require" =
                    definitions.predicate.rule,
                  "putout/convert-match-to-function" =
                    definitions.predicate.rule,
                  "putout/convert-method-to-property" =
                    definitions.predicate.rule,
                  "putout/convert-node-to-path-in-get-template-values" =
                    definitions.predicate.rule,
                  "putout/convert-number-to-numeric" =
                    definitions.predicate.rule,
                  "putout/convert-process-to-find" = definitions.predicate.rule,
                  "putout/convert-putout-test-to-create-test" =
                    definitions.predicate.rule,
                  "putout/convert-replace-to-function" =
                    definitions.predicate.rule,
                  "putout/convert-replace-with" = definitions.predicate.rule,
                  "putout/convert-replace-with-multiple" =
                    definitions.predicate.rule,
                  "putout/convert-report-to-function" =
                    definitions.predicate.rule,
                  "putout/convert-to-no-transform-code" =
                    definitions.predicate.rule,
                  "putout/convert-traverse-to-include" =
                    definitions.predicate.rule,
                  "putout/convert-traverse-to-replace" =
                    definitions.predicate.rule,
                  "putout/convert-url-to-dirname" = definitions.predicate.rule,
                  "putout/create-test" = definitions.predicate.rule,
                  "putout/declare" = definitions.predicate.rule,
                  "putout/includer" = definitions.predicate.rule,
                  "putout/insert-rust" = definitions.predicate.rule,
                  "putout/move-require-on-top-level" =
                    definitions.predicate.rule,
                  "putout/rename-operate-to-operator" =
                    definitions.predicate.rule,
                  "putout/replace-operate-with-operator" =
                    definitions.predicate.rule,
                  "putout/replace-test-message" = definitions.predicate.rule,
                  "putout/shorten-imports" = definitions.predicate.rule,
                  react-hooks = definitions.predicate.rule,
                  regexp = definitions.predicate.rule,
                  remove-boolean-from-assertions = definitions.predicate.rule,
                  remove-boolean-from-logical-expressions =
                    definitions.predicate.rule,
                  remove-console = definitions.predicate.rule,
                  remove-debugger = definitions.predicate.rule,
                  remove-duplicate-case = definitions.predicate.rule,
                  remove-duplicate-interface-keys = definitions.predicate.rule,
                  remove-duplicate-keys = definitions.predicate.rule,
                  remove-duplicates-from-logical-expressions =
                    definitions.predicate.rule,
                  remove-duplicates-from-union = definitions.predicate.rule,
                  remove-empty = definitions.predicate.rule,
                  "remove-empty/argument" = definitions.predicate.rule,
                  "remove-empty/block" = definitions.predicate.rule,
                  "remove-empty/export" = definitions.predicate.rule,
                  "remove-empty/import" = definitions.predicate.rule,
                  "remove-empty/pattern" = definitions.predicate.rule,
                  remove-iife = definitions.predicate.rule,
                  remove-nested-blocks = definitions.predicate.rule,
                  remove-unreachable-code = definitions.predicate.rule,
                  remove-unreferenced-variables = definitions.predicate.rule,
                  remove-unused-expressions = definitions.predicate.rule,
                  remove-unused-private-fields = definitions.predicate.rule,
                  remove-unused-types = definitions.predicate.rule,
                  remove-unused-variables = definitions.predicate.rule,
                  remove-useless-arguments = definitions.predicate.rule,
                  remove-useless-array-constructor = definitions.predicate.rule,
                  remove-useless-array-entries = definitions.predicate.rule,
                  remove-useless-constructor = definitions.predicate.rule,
                  remove-useless-continue = definitions.predicate.rule,
                  remove-useless-escape = definitions.predicate.rule,
                  remove-useless-functions = definitions.predicate.rule,
                  remove-useless-map = definitions.predicate.rule,
                  remove-useless-new = definitions.predicate.rule,
                  remove-useless-operand = definitions.predicate.rule,
                  remove-useless-return = definitions.predicate.rule,
                  remove-useless-spread = definitions.predicate.rule,
                  remove-useless-template-expressions =
                    definitions.predicate.rule,
                  remove-useless-templates = definitions.predicate.rule,
                  remove-useless-type-conversion = definitions.predicate.rule,
                  remove-useless-types-from-constants =
                    definitions.predicate.rule,
                  remove-useless-variables = definitions.predicate.rule,
                  reuse-duplicate-init = definitions.predicate.rule,
                  simplify-assignment = definitions.predicate.rule,
                  simplify-logical-expressions = definitions.predicate.rule,
                  simplify-ternary = definitions.predicate.rule,
                  split-nested-destructuring = definitions.predicate.rule,
                  split-variable-declarations = definitions.predicate.rule,
                  strict-mode = definitions.predicate.rule,
                  tape = definitions.predicate.rule,
                  "tape/remove-only" = definitions.predicate.rule,
                  "tape/remove-skip" = definitions.predicate.rule,
                  travis = definitions.predicate.rule,
                  types = definitions.predicate.rule,
                  "types/apply-is-array" = definitions.predicate.rule,
                  "types/convert-typeof-to-is-type" =
                    definitions.predicate.rule,
                  "types/remove-double-negations" = definitions.predicate.rule,
                  "types/remove-useless-conversion" =
                    definitions.predicate.rule,
                  "types/remove-useless-typeof" = definitions.predicate.rule,
                  typescript = definitions.predicate.rule,
                  "typescript/apply-as-type-assertion" =
                    definitions.predicate.rule,
                  "typescript/apply-utility-types" = definitions.predicate.rule,
                  "typescript/convert-generic-to-shorthand" =
                    definitions.predicate.rule,
                  "typescript/remove-duplicate-interface-keys" =
                    definitions.predicate.rule,
                  "typescript/remove-duplicates-from-union" =
                    definitions.predicate.rule,
                  "typescript/remove-unused-types" = definitions.predicate.rule,
                  "typescript/remove-useless-mapped-types" =
                    definitions.predicate.rule,
                  "typescript/remove-useless-mapping-modifiers" =
                    definitions.predicate.rule,
                  "typescript/remove-useless-types" =
                    definitions.predicate.rule,
                  "typescript/remove-useless-types-from-constants" =
                    definitions.predicate.rule,
                  webpack = definitions.predicate.rule,
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  formatter
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ predicates.isType '"String", predicates.isType '"Array" ])
    | doc m%"
    Choose the way to show information about errors found
    "%
    | optional,
  ignore
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String"),
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    Tell 🐊Putout to ignore specific files and directories.
    "%
    | optional,
  "match"
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "^.*$" = definitions.predicate.rules,
        additionalProperties = predicates.never,
      }
      true
      predicates.always
    ])
    | doc m%"
    Allows to match rules for files and folders, specified by glob patterns.
    "%
    | optional,
  parser
    | String
    | doc m%"
    Tell 🐊Putout which parser to use
    "%
    | optional,
  plugins
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"Array", predicates.arrays.uniqueItems ])
    | doc m%"
    Tell 🐊Putout which plugins to load
    "%
    | optional,
  printer
    | predicates.contract_from_predicate
    (predicates.oneOf
    [
      predicates.isType '"String",
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.items
        [ predicates.isType '"String", predicates.isType 'Record ],
        predicates.arrays.maxItems 2,
        predicates.arrays.minItems 2
      ]
    ])
    | doc m%"
    Tell 🐊Putout which printer to use
    "%
    | optional,
  processors
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String"),
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    Tell 🐊Putout which processors to use to support file types other then JavaScript
    "%
    | optional,
  rules | definitions.contract.rules | optional,
}