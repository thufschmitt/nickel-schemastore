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
          allRules = predicates.contract_from_predicate
              definitions.predicate.allRules,
          alwaysMultiLineRule = predicates.contract_from_predicate
              definitions.predicate.alwaysMultiLineRule,
          alwaysNeverRule = predicates.contract_from_predicate
              definitions.predicate.alwaysNeverRule,
          arrayStringRule = predicates.contract_from_predicate
              definitions.predicate.arrayStringRule,
          atRule = predicates.contract_from_predicate
              definitions.predicate.atRule,
          block = predicates.contract_from_predicate
              definitions.predicate.block,
          booleanRule = predicates.contract_from_predicate
              definitions.predicate.booleanRule,
          color = predicates.contract_from_predicate
              definitions.predicate.color,
          comment = predicates.contract_from_predicate
              definitions.predicate.comment,
          coreRule = predicates.contract_from_predicate
              definitions.predicate.coreRule,
          customMedia = predicates.contract_from_predicate
              definitions.predicate.customMedia,
          customProperty = predicates.contract_from_predicate
              definitions.predicate.customProperty,
          declaration = predicates.contract_from_predicate
              definitions.predicate.declaration,
          declarationBlock = predicates.contract_from_predicate
              definitions.predicate.declarationBlock,
          font = predicates.contract_from_predicate definitions.predicate.font,
          function = predicates.contract_from_predicate
              definitions.predicate.function,
          generalSheet = predicates.contract_from_predicate
              definitions.predicate.generalSheet,
          integerRule = predicates.contract_from_predicate
              definitions.predicate.integerRule,
          keyframeDeclaration = predicates.contract_from_predicate
              definitions.predicate.keyframeDeclaration,
          length = predicates.contract_from_predicate
              definitions.predicate.length,
          lowerUpperRule = predicates.contract_from_predicate
              definitions.predicate.lowerUpperRule,
          mediaFeature = predicates.contract_from_predicate
              definitions.predicate.mediaFeature,
          mediaQueryList = predicates.contract_from_predicate
              definitions.predicate.mediaQueryList,
          newlineRule = predicates.contract_from_predicate
              definitions.predicate.newlineRule,
          newlineSpaceRule = predicates.contract_from_predicate
              definitions.predicate.newlineSpaceRule,
          newlineSpaceWithIgnoreRule = predicates.contract_from_predicate
              definitions.predicate.newlineSpaceWithIgnoreRule,
          number = predicates.contract_from_predicate
              definitions.predicate.number,
          objectRule = predicates.contract_from_predicate
              definitions.predicate.objectRule,
          property = predicates.contract_from_predicate
              definitions.predicate.property,
          rootRule = predicates.contract_from_predicate
              definitions.predicate.rootRule,
          rule = predicates.contract_from_predicate definitions.predicate.rule,
          selector = predicates.contract_from_predicate
              definitions.predicate.selector,
          selectorList = predicates.contract_from_predicate
              definitions.predicate.selectorList,
          shorthandProperty = predicates.contract_from_predicate
              definitions.predicate.shorthandProperty,
          simpleArrayStringRule = predicates.contract_from_predicate
              definitions.predicate.simpleArrayStringRule,
          simpleStringOrArrayStringRule = predicates.contract_from_predicate
              definitions.predicate.simpleStringOrArrayStringRule,
          singleDoubleRule = predicates.contract_from_predicate
              definitions.predicate.singleDoubleRule,
          spaceRule = predicates.contract_from_predicate
              definitions.predicate.spaceRule,
          string = predicates.contract_from_predicate
              definitions.predicate.string,
          stringRule = predicates.contract_from_predicate
              definitions.predicate.stringRule,
          stylelintDisableComment = predicates.contract_from_predicate
              definitions.predicate.stylelintDisableComment,
          time = predicates.contract_from_predicate definitions.predicate.time,
          unit = predicates.contract_from_predicate definitions.predicate.unit,
          unitRule = predicates.contract_from_predicate
              definitions.predicate.unitRule,
          value = predicates.contract_from_predicate
              definitions.predicate.value,
          valueList = predicates.contract_from_predicate
              definitions.predicate.valueList,
        },
    predicate = {
          allRules = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.atRule,
                  definitions.predicate.block,
                  definitions.predicate.color,
                  definitions.predicate.comment,
                  definitions.predicate.customMedia,
                  definitions.predicate.customProperty,
                  definitions.predicate.declaration,
                  definitions.predicate.declarationBlock,
                  definitions.predicate.font,
                  definitions.predicate.function,
                  definitions.predicate.generalSheet,
                  definitions.predicate.keyframeDeclaration,
                  definitions.predicate.length,
                  definitions.predicate.mediaFeature,
                  definitions.predicate.mediaQueryList,
                  definitions.predicate.number,
                  definitions.predicate.property,
                  definitions.predicate.rootRule,
                  definitions.predicate.rule,
                  definitions.predicate.selector,
                  definitions.predicate.selectorList,
                  definitions.predicate.shorthandProperty,
                  definitions.predicate.string,
                  definitions.predicate.stylelintDisableComment,
                  definitions.predicate.time,
                  definitions.predicate.unit,
                  definitions.predicate.value,
                  definitions.predicate.valueList
                ]
              ],
          alwaysMultiLineRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType '"String",
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "always", "always-multi-line", [  ] ]
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "always", "always-multi-line", {  } ]
                        ],
                        definitions.predicate.coreRule
                      ]
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          alwaysNeverRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType '"String",
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "always", "never", [  ] ]
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "always", "never", {  } ]
                        ],
                        definitions.predicate.coreRule
                      ]
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          arrayStringRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType '"String",
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Array",
                        predicates.isType 'Record
                      ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ [  ], {  } ]
                        ],
                        definitions.predicate.simpleArrayStringRule,
                        definitions.predicate.coreRule
                      ]
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          atRule = predicates.records.record
              {
                at-rule-blacklist = definitions.predicate.arrayStringRule,
                at-rule-empty-line-before = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "always", "never", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "always", "never", {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  except = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "after-same-name",
                                            "inside-block",
                                            "blockless-after-same-name-blockless",
                                            "blockless-after-blockless",
                                            "first-nested"
                                          ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "after-comment",
                                            "first-nested",
                                            "inside-block",
                                            "blockless-after-same-name-blockless",
                                            "blockless-after-blockless"
                                          ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                  ignoreAtRules =
                                    definitions.predicate.simpleStringOrArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                at-rule-name-case = definitions.predicate.lowerUpperRule,
                at-rule-name-newline-after =
                  definitions.predicate.alwaysMultiLineRule,
                at-rule-name-space-after = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "always", "always-single-line", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [ "always", "always-single-line", {  } ]
                              ],
                              definitions.predicate.coreRule
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                at-rule-no-unknown = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignoreAtRules =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                at-rule-no-vendor-prefix = definitions.predicate.booleanRule,
                at-rule-semicolon-newline-after = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "always", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "always", {  } ]
                              ],
                              definitions.predicate.coreRule
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                at-rule-whitelist = definitions.predicate.arrayStringRule,
              }
              {  }
              true
              predicates.always,
          block = predicates.records.record
              {
                block-closing-brace-empty-line-before = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "always-multi-line", "never", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [ "always-multi-line", "never", {  } ]
                              ],
                              definitions.predicate.coreRule
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                block-closing-brace-newline-after =
                  definitions.predicate.newlineSpaceWithIgnoreRule,
                block-closing-brace-newline-before =
                  definitions.predicate.newlineRule,
                block-closing-brace-space-after =
                  definitions.predicate.newlineSpaceRule,
                block-closing-brace-space-before =
                  definitions.predicate.newlineSpaceRule,
                block-no-empty = definitions.predicate.booleanRule,
                block-no-single-line = definitions.predicate.booleanRule,
                block-opening-brace-newline-after =
                  definitions.predicate.newlineRule,
                block-opening-brace-newline-before = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "always",
                            "always-single-line",
                            "never-single-line",
                            "always-multi-line",
                            "never-multi-line",
                            [  ]
                          ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "always",
                                  "always-single-line",
                                  "never-single-line",
                                  "always-multi-line",
                                  "never-multi-line",
                                  {  }
                                ]
                              ],
                              definitions.predicate.coreRule
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                block-opening-brace-space-after =
                  definitions.predicate.newlineSpaceRule,
                block-opening-brace-space-before =
                  definitions.predicate.newlineSpaceWithIgnoreRule,
              }
              {  }
              true
              predicates.always,
          booleanRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType '"Bool",
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [ predicates.isType '"Bool", predicates.enum [ true, [  ] ] ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Record ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, {  } ]
                        ],
                        definitions.predicate.coreRule
                      ]
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          color = predicates.records.record
              {
                color-hex-case = definitions.predicate.lowerUpperRule,
                color-hex-length = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "short", "long", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "short", "long", {  } ]
                              ],
                              definitions.predicate.coreRule
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                color-named = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "always-where-possible", "never", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [ "always-where-possible", "never", {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignore =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                color-no-hex = definitions.predicate.booleanRule,
                color-no-invalid-hex = definitions.predicate.booleanRule,
              }
              {  }
              true
              predicates.always,
          comment = predicates.records.record
              {
                comment-empty-line-before = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "always", "never", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "always", "never", {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  except = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum [ "first-nested" ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "between-comments",
                                            "after-comment",
                                            "stylelint-commands"
                                          ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                comment-no-empty = definitions.predicate.booleanRule,
                comment-whitespace-inside =
                  definitions.predicate.alwaysNeverRule,
                comment-word-blacklist = definitions.predicate.arrayStringRule,
              }
              {  }
              true
              predicates.always,
          coreRule = predicates.records.record
              {
                disableFix = predicates.isType '"Bool",
                message = predicates.isType '"String",
                reportDisables = predicates.isType '"Bool",
                severity = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "warning", "error" ]
                    ],
              }
              {  }
              true
              predicates.always,
          customMedia = predicates.records.record
              { custom-media-pattern = definitions.predicate.stringRule, }
              {  }
              true
              predicates.always,
          customProperty = predicates.records.record
              {
                custom-property-empty-line-before = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "always", "never", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "always", "never", {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  except = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "after-comment",
                                            "after-custom-property",
                                            "first-nested"
                                          ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "after-comment",
                                            "inside-single-line-block"
                                          ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                custom-property-no-outside-root =
                  definitions.predicate.booleanRule,
                custom-property-pattern = definitions.predicate.stringRule,
              }
              {  }
              true
              predicates.always,
          declaration = predicates.records.record
              {
                declaration-bang-space-after =
                  definitions.predicate.alwaysNeverRule,
                declaration-bang-space-before =
                  definitions.predicate.alwaysNeverRule,
                declaration-colon-newline-after =
                  definitions.predicate.alwaysMultiLineRule,
                declaration-colon-space-after = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "always", "never", "always-single-line", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "always",
                                  "never",
                                  "always-single-line",
                                  {  }
                                ]
                              ],
                              definitions.predicate.coreRule
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                declaration-colon-space-before =
                  definitions.predicate.alwaysNeverRule,
                declaration-empty-line-before = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "always", "never", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "always", "never", {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  except = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "after-comment",
                                            "after-declaration",
                                            "first-nested"
                                          ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "after-comment",
                                            "after-declaration",
                                            "inside-single-line-block"
                                          ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                declaration-no-important = definitions.predicate.booleanRule,
                declaration-property-unit-blacklist =
                  definitions.predicate.objectRule,
                declaration-property-unit-whitelist =
                  definitions.predicate.objectRule,
                declaration-property-value-blacklist =
                  definitions.predicate.objectRule,
                declaration-property-value-whitelist =
                  definitions.predicate.objectRule,
              }
              {  }
              true
              predicates.always,
          declarationBlock = predicates.records.record
              {
                declaration-block-no-duplicate-properties = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "consecutive-duplicates",
                                            "consecutive-duplicates-with-different-values",
                                            "consecutive-duplicates-with-different-syntaxes",
                                            "consecutive-duplicates-with-same-prefixless-values"
                                          ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                  ignoreProperties =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                declaration-block-no-ignored-properties =
                  definitions.predicate.booleanRule,
                declaration-block-no-redundant-longhand-properties =
                  predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignoreShorthands =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                declaration-block-no-shorthand-property-overrides =
                  definitions.predicate.booleanRule,
                declaration-block-properties-order = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "alphabetical", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Array",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "alphabetical", [  ], {  } ]
                              ],
                              predicates.isType '"String",
                              definitions.predicate.simpleArrayStringRule,
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  order = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum [ "strict", "flexible" ]
                                      ],
                                  properties =
                                    definitions.predicate.simpleArrayStringRule,
                                  unspecified = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "top",
                                          "bottom",
                                          "bottomAlphabetical",
                                          "ignore"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always,
                                predicates.records.dependencies
                                {
                                  order = [ "properties" ],
                                  properties = [ "order" ],
                                }
                              ]
                            ]
                          ]),
                          predicates.arrays.minItems 1,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                declaration-block-semicolon-newline-after =
                  definitions.predicate.newlineRule,
                declaration-block-semicolon-newline-before =
                  definitions.predicate.newlineRule,
                declaration-block-semicolon-space-after =
                  definitions.predicate.spaceRule,
                declaration-block-semicolon-space-before =
                  definitions.predicate.spaceRule,
                declaration-block-single-line-max-declarations =
                  definitions.predicate.integerRule,
                declaration-block-trailing-semicolon =
                  definitions.predicate.alwaysNeverRule,
              }
              {  }
              true
              predicates.always,
          font = predicates.records.record
              {
                font-family-name-quotes = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "always-where-required",
                            "always-where-recommended",
                            "always-unless-keyword",
                            [  ]
                          ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "always-where-required",
                                  "always-where-recommended",
                                  "always-unless-keyword",
                                  {  }
                                ]
                              ],
                              definitions.predicate.coreRule
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                font-weight-notation = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "numeric", "named-where-possible", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [ "numeric", "named-where-possible", {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum [ "relative" ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
              }
              {  }
              true
              predicates.always,
          function = predicates.records.record
              {
                function-blacklist = definitions.predicate.arrayStringRule,
                function-calc-no-unspaced-operator =
                  definitions.predicate.booleanRule,
                function-comma-newline-after =
                  definitions.predicate.newlineRule,
                function-comma-newline-before =
                  definitions.predicate.newlineRule,
                function-comma-space-after = definitions.predicate.spaceRule,
                function-comma-space-before = definitions.predicate.spaceRule,
                function-linear-gradient-no-nonstandard-direction =
                  definitions.predicate.booleanRule,
                function-max-empty-lines = definitions.predicate.integerRule,
                function-name-case = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "lower", "upper", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "lower", "upper", {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignoreFunctions =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                function-parentheses-newline-inside =
                  definitions.predicate.newlineRule,
                function-parentheses-space-inside =
                  definitions.predicate.spaceRule,
                function-url-data-uris = definitions.predicate.alwaysNeverRule,
                function-url-no-scheme-relative =
                  definitions.predicate.booleanRule,
                function-url-quotes = definitions.predicate.alwaysNeverRule,
                function-url-scheme-whitelist =
                  definitions.predicate.arrayStringRule,
                function-whitelist = definitions.predicate.arrayStringRule,
                function-whitespace-after =
                  definitions.predicate.alwaysNeverRule,
              }
              {  }
              true
              predicates.always,
          generalSheet = predicates.records.record
              {
                indentation = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType 'Integer,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType 'Integer ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "tab", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType 'Integer),
                          predicates.arrays.minItems 1,
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType 'Integer,
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.isType 'Integer,
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "tab", {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  except = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [ "block", "param", "value" ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [ "inside-parens", "param", "value" ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                  indentInsideParens = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "twice",
                                          "once-at-root-twice-in-block"
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                max-empty-lines = definitions.predicate.integerRule,
                max-line-length = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType 'Integer,
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType 'Integer ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType 'Integer,
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.isType 'Integer,
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignore = predicates.allOf
                                      [
                                        predicates.anyOf
                                        [
                                          predicates.isType '"String",
                                          predicates.isType '"Array"
                                        ],
                                        predicates.anyOf
                                        [
                                          predicates.allOf
                                          [
                                            predicates.isType '"String",
                                            predicates.enum
                                            [ "non-comments", "comments" ]
                                          ],
                                          predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.allOf
                                            [
                                              predicates.isType '"String",
                                              predicates.enum
                                              [ "non-comments", "comments" ]
                                            ]),
                                            predicates.arrays.minItems 1,
                                            predicates.arrays.uniqueItems
                                          ]
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                max-nesting-depth = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType 'Integer,
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType 'Integer ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType 'Integer,
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.isType 'Integer,
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "blockless-at-rules",
                                            "pseudo-classes"
                                          ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                  ignoreAtRules =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                no-browser-hacks = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  browsers =
                                    definitions.predicate.simpleStringOrArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                no-descending-specificity = definitions.predicate.booleanRule,
                no-duplicate-selectors = definitions.predicate.booleanRule,
                no-empty-source = definitions.predicate.booleanRule,
                no-eol-whitespace = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum [ "empty-lines" ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                no-extra-semicolons = definitions.predicate.booleanRule,
                no-indistinguishable-colors = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignore =
                                    definitions.predicate.simpleArrayStringRule,
                                  threshold = predicates.allOf
                                      [
                                        predicates.isType 'Integer,
                                        predicates.numbers.maximum 100,
                                        predicates.numbers.minimum 0
                                      ],
                                  whitelist = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        definitions.predicate.simpleArrayStringRule,
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                no-invalid-double-slash-comments =
                  definitions.predicate.booleanRule,
                no-missing-end-of-source-newline =
                  definitions.predicate.booleanRule,
                no-unknown-animations = definitions.predicate.booleanRule,
                no-unsupported-browser-features = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  browsers = predicates.isType '"String",
                                  ignore =
                                    definitions.predicate.simpleStringOrArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                unicode-bom = definitions.predicate.alwaysNeverRule,
              }
              {  }
              true
              predicates.always,
          integerRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType 'Integer,
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType 'Integer ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Integer, predicates.isType 'Record ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.enum [ {  } ]
                        ],
                        definitions.predicate.coreRule
                      ]
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          keyframeDeclaration = predicates.records.record
              {
                keyframe-declaration-no-important =
                  definitions.predicate.booleanRule,
              }
              {  }
              true
              predicates.always,
          length = predicates.records.record
              { length-zero-no-unit = definitions.predicate.booleanRule, }
              {  }
              true
              predicates.always,
          lowerUpperRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType '"String",
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "lower", "upper", [  ] ]
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "lower", "upper", {  } ]
                        ],
                        definitions.predicate.coreRule
                      ]
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          mediaFeature = predicates.records.record
              {
                media-feature-colon-space-after =
                  definitions.predicate.alwaysNeverRule,
                media-feature-colon-space-before =
                  definitions.predicate.alwaysNeverRule,
                media-feature-name-case = definitions.predicate.lowerUpperRule,
                media-feature-name-no-unknown = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignoreMediaFeatureNames =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                media-feature-name-no-vendor-prefix =
                  definitions.predicate.booleanRule,
                media-feature-no-missing-punctuation =
                  definitions.predicate.booleanRule,
                media-feature-parentheses-space-inside =
                  definitions.predicate.alwaysNeverRule,
                media-feature-range-operator-space-after =
                  definitions.predicate.alwaysNeverRule,
                media-feature-range-operator-space-before =
                  definitions.predicate.alwaysNeverRule,
              }
              {  }
              true
              predicates.always,
          mediaQueryList = predicates.records.record
              {
                media-query-list-comma-newline-after =
                  definitions.predicate.newlineRule,
                media-query-list-comma-newline-before =
                  definitions.predicate.newlineRule,
                media-query-list-comma-space-after =
                  definitions.predicate.spaceRule,
                media-query-list-comma-space-before =
                  definitions.predicate.spaceRule,
              }
              {  }
              true
              predicates.always,
          newlineRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType '"String",
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [ "always", "always-multi-line", "never-multi-line", [  ] ]
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "always",
                            "always-multi-line",
                            "never-multi-line",
                            {  }
                          ]
                        ],
                        definitions.predicate.coreRule
                      ]
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          newlineSpaceRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType '"String",
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [
                      "always",
                      "never",
                      "always-single-line",
                      "never-single-line",
                      "always-multi-line",
                      "never-multi-line",
                      [  ]
                    ]
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "always",
                            "never",
                            "always-single-line",
                            "never-single-line",
                            "always-multi-line",
                            "never-multi-line",
                            {  }
                          ]
                        ],
                        definitions.predicate.coreRule
                      ]
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          newlineSpaceWithIgnoreRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType '"String",
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [
                      "always",
                      "never",
                      "always-single-line",
                      "never-single-line",
                      "always-multi-line",
                      "never-multi-line",
                      [  ]
                    ]
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "always",
                            "always-single-line",
                            "never-single-line",
                            "always-multi-line",
                            "never-multi-line",
                            {  }
                          ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          definitions.predicate.coreRule,
                          predicates.records.record
                          {
                            ignoreAtRules =
                              definitions.predicate.simpleStringOrArrayStringRule,
                          }
                          {  }
                          true
                          predicates.always
                        ]
                      ]
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          number = predicates.records.record
              {
                number-leading-zero = definitions.predicate.alwaysNeverRule,
                number-max-precision = definitions.predicate.integerRule,
                number-no-trailing-zeros = definitions.predicate.booleanRule,
              }
              {  }
              true
              predicates.always,
          objectRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType 'Record,
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = definitions.predicate.simpleArrayStringRule, }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf [ predicates.isType 'Record ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.coreRule,
                        predicates.records.record {  }
                        {
                          "^((?!message|severity).)*$" =
                            definitions.predicate.simpleArrayStringRule,
                        }
                        true
                        predicates.always
                      ]
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          property = predicates.records.record
              {
                property-blacklist = definitions.predicate.arrayStringRule,
                property-case = definitions.predicate.lowerUpperRule,
                property-no-unknown = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  checkPrefixed = predicates.isType '"Bool",
                                  ignoreProperties =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                property-no-vendor-prefix = definitions.predicate.booleanRule,
                property-whitelist = definitions.predicate.arrayStringRule,
              }
              {  }
              true
              predicates.always,
          rootRule = predicates.records.record
              {
                root-no-standard-properties = definitions.predicate.booleanRule,
              }
              {  }
              true
              predicates.always,
          rule = predicates.records.record
              {
                rule-nested-empty-line-before = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "always",
                            "never",
                            "always-multi-line",
                            "never-multi-line",
                            [  ]
                          ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "always",
                                  "never",
                                  "always-multi-line",
                                  "never-multi-line",
                                  {  }
                                ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  except = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum [ "first-nested" ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum [ "after-comment" ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                rule-non-nested-empty-line-before = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "always",
                            "never",
                            "always-multi-line",
                            "never-multi-line",
                            [  ]
                          ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "always",
                                  "never",
                                  "always-multi-line",
                                  "never-multi-line",
                                  {  }
                                ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  except = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [ "after-single-line-comment" ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum [ "after-comment" ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
              }
              {  }
              true
              predicates.always,
          selector = predicates.records.record
              {
                selector-attribute-brackets-space-inside =
                  definitions.predicate.alwaysNeverRule,
                selector-attribute-operator-blacklist =
                  definitions.predicate.arrayStringRule,
                selector-attribute-operator-space-after =
                  definitions.predicate.alwaysNeverRule,
                selector-attribute-operator-space-before =
                  definitions.predicate.alwaysNeverRule,
                selector-attribute-operator-whitelist =
                  definitions.predicate.arrayStringRule,
                selector-attribute-quotes =
                  definitions.predicate.alwaysNeverRule,
                selector-class-pattern = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Null,
                          predicates.isType '"String"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  resolveNestedSelectors = predicates.isType
                                      '"Bool",
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                selector-combinator-space-after =
                  definitions.predicate.alwaysNeverRule,
                selector-combinator-space-before =
                  definitions.predicate.alwaysNeverRule,
                selector-descendant-combinator-no-non-space =
                  definitions.predicate.booleanRule,
                selector-id-pattern = definitions.predicate.stringRule,
                selector-max-compound-selectors =
                  definitions.predicate.integerRule,
                selector-max-empty-lines = definitions.predicate.integerRule,
                selector-max-specificity = definitions.predicate.stringRule,
                selector-nested-pattern = definitions.predicate.stringRule,
                selector-no-attribute = definitions.predicate.booleanRule,
                selector-no-combinator = definitions.predicate.booleanRule,
                selector-no-id = definitions.predicate.booleanRule,
                selector-no-qualifying-type = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [ "attribute", "class", "id" ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                selector-no-type = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignore = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [ "compounded", "descendant" ]
                                        ]),
                                        predicates.arrays.minItems 1,
                                        predicates.arrays.uniqueItems
                                      ],
                                  ignoreTypes =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                selector-no-universal = definitions.predicate.booleanRule,
                selector-no-vendor-prefix = definitions.predicate.booleanRule,
                selector-pseudo-class-case =
                  definitions.predicate.lowerUpperRule,
                selector-pseudo-class-no-unknown = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignorePseudoClasses =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                selector-pseudo-class-parentheses-space-inside =
                  definitions.predicate.alwaysNeverRule,
                selector-pseudo-class-whitelist =
                  definitions.predicate.arrayStringRule,
                selector-pseudo-element-case =
                  definitions.predicate.lowerUpperRule,
                selector-pseudo-element-colon-notation =
                  definitions.predicate.singleDoubleRule,
                selector-pseudo-element-no-unknown = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignorePseudoElements =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                selector-root-no-composition =
                  definitions.predicate.booleanRule,
                selector-type-case = definitions.predicate.lowerUpperRule,
                selector-type-no-unknown = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignoreTypes =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
              }
              {  }
              true
              predicates.always,
          selectorList = predicates.records.record
              {
                selector-list-comma-newline-after =
                  definitions.predicate.newlineRule,
                selector-list-comma-newline-before =
                  definitions.predicate.newlineRule,
                selector-list-comma-space-after =
                  definitions.predicate.spaceRule,
                selector-list-comma-space-before =
                  definitions.predicate.spaceRule,
              }
              {  }
              true
              predicates.always,
          shorthandProperty = predicates.records.record
              {
                shorthand-property-no-redundant-values =
                  definitions.predicate.booleanRule,
              }
              {  }
              true
              predicates.always,
          simpleArrayStringRule = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String"),
                predicates.arrays.minItems 1,
                predicates.arrays.uniqueItems
              ],
          simpleStringOrArrayStringRule = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType '"Array" ],
                predicates.oneOf
                [
                  predicates.isType '"String",
                  definitions.predicate.simpleArrayStringRule
                ]
              ],
          singleDoubleRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType '"String",
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "single", "double", [  ] ]
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "single", "double", {  } ]
                        ],
                        definitions.predicate.coreRule
                      ]
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          spaceRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType '"String",
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [
                      "always",
                      "never",
                      "always-single-line",
                      "never-single-line",
                      [  ]
                    ]
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "always",
                            "never",
                            "always-single-line",
                            "never-single-line",
                            {  }
                          ]
                        ],
                        definitions.predicate.coreRule
                      ]
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          string = predicates.records.record
              {
                string-no-newline = definitions.predicate.booleanRule,
                string-quotes = definitions.predicate.singleDoubleRule,
              }
              {  }
              true
              predicates.always,
          stringRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType '"String",
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ {  } ]
                        ],
                        definitions.predicate.coreRule
                      ]
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          stylelintDisableComment = predicates.records.record
              {
                stylelint-disable-reason = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "always-before", "always-after", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [ "always-before", "always-after", {  } ]
                              ],
                              definitions.predicate.coreRule
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
              }
              {  }
              true
              predicates.always,
          time = predicates.records.record
              { time-no-imperceptible = definitions.predicate.booleanRule, }
              {  }
              true
              predicates.always,
          unit = predicates.records.record
              {
                unit-blacklist = definitions.predicate.unitRule,
                unit-case = definitions.predicate.lowerUpperRule,
                unit-no-unknown = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"Bool",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"Bool",
                          predicates.enum [ true, [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"Bool",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Bool",
                                predicates.enum [ true, {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignoreUnits =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                unit-whitelist = definitions.predicate.unitRule,
              }
              {  }
              true
              predicates.always,
          unitRule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.isType '"String",
                  predicates.isType '"Array"
                ],
                predicates.oneOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [
                      "em",
                      "ex",
                      "px",
                      "%",
                      "rem",
                      "vw",
                      "vh",
                      "vm",
                      "vmin",
                      "vmax",
                      "ch",
                      "in",
                      "cm",
                      "mm",
                      "q",
                      "pt",
                      "pc",
                      "deg",
                      "grad",
                      "rad",
                      "turn",
                      "ms",
                      "s",
                      "Hz",
                      "kHz",
                      "dpi",
                      "dpcm",
                      "dppx",
                      "fr",
                      [  ]
                    ]
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Array",
                        predicates.isType 'Record
                      ],
                      predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "em",
                            "ex",
                            "px",
                            "%",
                            "rem",
                            "vw",
                            "vh",
                            "vm",
                            "vmin",
                            "vmax",
                            "ch",
                            "in",
                            "cm",
                            "mm",
                            "q",
                            "pt",
                            "pc",
                            "deg",
                            "grad",
                            "rad",
                            "turn",
                            "ms",
                            "s",
                            "Hz",
                            "kHz",
                            "dpi",
                            "dpcm",
                            "dppx",
                            "fr",
                            [  ],
                            {  }
                          ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "em",
                              "ex",
                              "px",
                              "%",
                              "rem",
                              "vw",
                              "vh",
                              "vm",
                              "vmin",
                              "vmax",
                              "ch",
                              "in",
                              "cm",
                              "mm",
                              "q",
                              "pt",
                              "pc",
                              "deg",
                              "grad",
                              "rad",
                              "turn",
                              "ms",
                              "s",
                              "Hz",
                              "kHz",
                              "dpi",
                              "dpcm",
                              "dppx",
                              "fr"
                            ]
                          ]),
                          predicates.arrays.minItems 1,
                          predicates.arrays.uniqueItems
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          definitions.predicate.coreRule,
                          predicates.records.record
                          {
                            ignoreProperties = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record {  }
                                  {
                                    "(em|ex|ch|vw|vh|cm|mm|in|pt|pc|px|rem|vmin|vmax|%)" =
                                      definitions.predicate.simpleArrayStringRule,
                                  }
                                  true
                                  predicates.always
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ]
                      ]
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ]
                ]
              ],
          value = predicates.records.record
              {
                value-keyword-case = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.oneOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "lower", "upper", [  ] ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Record
                            ],
                            predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "lower", "upper", {  } ]
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                definitions.predicate.coreRule,
                                predicates.records.record
                                {
                                  ignoreKeywords =
                                    definitions.predicate.simpleArrayStringRule,
                                }
                                {  }
                                true
                                predicates.always
                              ]
                            ]
                          ]),
                          predicates.arrays.maxItems 2,
                          predicates.arrays.minItems 2,
                          predicates.arrays.uniqueItems
                        ]
                      ]
                    ],
                value-no-vendor-prefix = definitions.predicate.booleanRule,
              }
              {  }
              true
              predicates.always,
          valueList = predicates.records.record
              {
                value-list-comma-newline-after =
                  definitions.predicate.newlineRule,
                value-list-comma-newline-before =
                  definitions.predicate.newlineRule,
                value-list-comma-space-after = definitions.predicate.spaceRule,
                value-list-comma-space-before = definitions.predicate.spaceRule,
                value-list-max-empty-lines = definitions.predicate.integerRule,
              }
              {  }
              true
              predicates.always,
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.record
  {
    customSyntax = predicates.isType '"String",
    defaultSeverity = predicates.allOf
        [ predicates.isType '"String", predicates.enum [ "warning", "error" ] ],
    extends = definitions.predicate.simpleStringOrArrayStringRule,
    ignoreDisables = predicates.isType '"Bool",
    ignoreFiles = definitions.predicate.simpleStringOrArrayStringRule,
    overrides = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              customSyntax = predicates.isType '"String",
              files = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ],
              rules = definitions.predicate.allRules,
            }
            {  }
            true
            predicates.always
          ])
        ],
    plugins = definitions.predicate.simpleArrayStringRule,
    processors = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.anyOf
          [
            predicates.isType '"String",
            predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.items [ predicates.isType '"String" ],
              predicates.arrays.additionalItems (predicates.isType 'Record) 1
            ]
          ])
        ],
    reportDescriptionlessDisables = definitions.predicate.booleanRule,
    reportInvalidScopeDisables = definitions.predicate.booleanRule,
    reportNeedlessDisables = definitions.predicate.booleanRule,
    rules = definitions.predicate.allRules,
  }
  {  }
  true
  predicates.always
])