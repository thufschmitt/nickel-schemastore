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
          arrayOfNonEmptyStrings = predicates.contract_from_predicate
              definitions.predicate.arrayOfNonEmptyStrings,
          cache = predicates.contract_from_predicate
              definitions.predicate.cache,
          deployment = predicates.contract_from_predicate
              definitions.predicate.deployment,
          envVar = predicates.contract_from_predicate
              definitions.predicate.envVar,
          envVars = predicates.contract_from_predicate
              definitions.predicate.envVars,
          "import" = predicates.contract_from_predicate
              definitions.predicate."import",
          job = {
                addons
                  | {
                    apt
                      | {
                        packages
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ])
                          | doc m%"
                          To install packages from the package whitelist before your custom build steps
                          "%
                          | optional,
                        sources
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.oneOf
                            [
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "sourceline" ],
                                predicates.records.record
                                {
                                  key_url = predicates.isType '"String",
                                  sourceline = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                              predicates.isType '"String"
                            ])
                          ])
                          | optional,
                        update
                          | Bool
                          | doc m%"
                          To update the list of available packages
                          "%
                          | optional,
                      }
                      | doc m%"
                      To install packages not included in the default container-based-infrastructure you need to use the APT addon, as sudo apt-get is not available
                      "%
                      | optional,
                    artifacts
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.enum [ true ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            debug = predicates.isType '"Bool",
                            paths = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            s3_region = predicates.isType '"String",
                            working_dir = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ]
                      ])
                      | optional,
                    browserstack
                      | {
                        access_key
                          | definitions.contract.possiblySecretString
                          | optional,
                        app_path
                          | definitions.contract.nonEmptyString
                          | optional,
                        forcelocal | Bool | optional,
                        only | definitions.contract.nonEmptyString | optional,
                        proxyHost
                          | definitions.contract.nonEmptyString
                          | optional,
                        proxyPass
                          | definitions.contract.nonEmptyString
                          | optional,
                        proxyPort
                          | definitions.contract.nonEmptyString
                          | optional,
                        proxyUser
                          | definitions.contract.nonEmptyString
                          | optional,
                        username
                          | definitions.contract.nonEmptyString
                          | optional,
                        ..
                      }
                      | doc m%"
                      BrowserStack addon
                      "%
                      | optional,
                    chrome
                      | std.enum.TagOrString
                      | [| 'beta, 'stable |]
                      | doc m%"
                      Chrome addon
                      "%
                      | optional,
                    coverity_scan
                      | {
                        branch_pattern
                          | String
                          | doc m%"
                          Pattern to match selecting branches that will run analysis. We recommend leaving this set to 'coverity_scan'
                          "%
                          | optional,
                        build_command
                          | String
                          | doc m%"
                          The command that will be added as an argument to 'cov-build' to compile your project for analysis
                          "%
                          | optional,
                        build_command_prepend
                          | String
                          | doc m%"
                          Commands to prepare for build_command
                          "%
                          | optional,
                        notification_email
                          | String
                          | doc m%"
                          Where email notification of build analysis results will be sent
                          "%
                          | optional,
                        project
                          | {
                            description | String | optional,
                            name | String,
                            version | Number | optional,
                            ..
                          }
                          | doc m%"
                          GitHub project metadata
                          "%
                          | optional,
                        ..
                      }
                      | doc m%"
                      Coverity Scan addon
                      "%
                      | optional,
                    firefox
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "latest",
                            "latest-esr",
                            "latest-beta",
                            "latest-dev",
                            "latest-nightly",
                            "latest-unsigned"
                          ]
                        ],
                        definitions.predicate.nonEmptyString
                      ])
                      | doc m%"
                      Firefox addon
                      "%
                      | optional,
                    homebrew
                      | {
                        brewfile
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            definitions.predicate.nonEmptyString,
                            predicates.isType '"Bool"
                          ])
                          | optional,
                        casks
                          | definitions.contract.stringOrStringArrayUnique
                          | optional,
                        packages
                          | definitions.contract.stringOrStringArrayUnique
                          | optional,
                        taps
                          | definitions.contract.stringOrStringArrayUnique
                          | optional,
                        update | Bool | optional,
                      }
                      | doc m%"
                      Homebrew addon
                      "%
                      | optional,
                    hosts
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ])
                      | doc m%"
                      If your build requires setting up custom hostnames, you can specify a single host or a list of them. Travis CI will automatically setup the hostnames in /etc/hosts for both IPv4 and IPv6.
                      "%
                      | optional,
                    mariadb
                      | String
                      | doc m%"
                      MariaDB addon
                      "%
                      | optional,
                    postgresql
                      | String
                      | doc m%"
                      PostgreSQL addon
                      "%
                      | optional,
                    rethinkdb
                      | String
                      | doc m%"
                      RethinkDB addon
                      "%
                      | optional,
                    sauce_connect
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            access_key = predicates.isType '"String",
                            username = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                        predicates.isType '"Bool"
                      ])
                      | doc m%"
                      Sauce Connect addon
                      "%
                      | optional,
                    snaps
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        definitions.predicate.nonEmptyString,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.oneOf
                          [
                            definitions.predicate.nonEmptyString,
                            predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "name" ],
                              predicates.records.record
                              {
                                channel = definitions.predicate.nonEmptyString,
                                classic = predicates.isType '"Bool",
                                confinement = predicates.enum
                                    [ "classic", "devmode" ],
                                name = definitions.predicate.nonEmptyString,
                              }
                              {  }
                              false
                              predicates.never
                            ]
                          ]),
                          predicates.arrays.minItems 1,
                          predicates.arrays.uniqueItems
                        ]
                      ])
                      | doc m%"
                      Snaps addon
                      "%
                      | optional,
                    sonarcloud
                      | {
                        organization | String | optional,
                        token | definitions.contract.secretString | optional,
                        ..
                      }
                      | doc m%"
                      SonarCloud addon
                      "%
                      | optional,
                    srcclr
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { debug = predicates.isType '"Bool", }
                          {  }
                          false
                          predicates.never
                        ]
                      ])
                      | doc m%"
                      SourceClear addon
                      "%
                      | optional,
                    ssh_known_hosts
                      | definitions.contract.stringOrStringArrayUnique
                      | doc m%"
                      Travis CI can add entries to ~/.ssh/known_hosts prior to cloning your git repository, which is necessary if there are git submodules from domains other than github.com, gist.github.com, or ssh.github.com.
                      "%
                      | optional,
                  }
                  | optional,
                after_deploy | definitions.contract.step | optional,
                after_failure | definitions.contract.step | optional,
                after_script | definitions.contract.step | optional,
                after_success | definitions.contract.step | optional,
                android
                  | {
                    components
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ])
                      | optional,
                    licenses
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ])
                      | optional,
                  }
                  | optional,
                apt_packages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                arch
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.enum
                    [
                      "amd64",
                      "x86_64",
                      "arm64",
                      "ppc64le",
                      "s390x",
                      "arm64-graviton2"
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.enum
                      [
                        "amd64",
                        "arm64",
                        "ppc64le",
                        "s390x",
                        "arm64-graviton2"
                      ]),
                      predicates.arrays.minItems 1,
                      predicates.arrays.uniqueItems
                    ]
                  ])
                  | doc m%"
                  The CPU Architecture to run the job on
                  "%
                  | optional,
                before_cache | definitions.contract.step | optional,
                before_deploy | definitions.contract.step | optional,
                before_install | definitions.contract.step | optional,
                before_script | definitions.contract.step | optional,
                bioc_packages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                branches
                  | {
                    except
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ])
                      | optional,
                    only
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ])
                      | optional,
                  }
                  | doc m%"
                  Specify which branches to build
                  "%
                  | optional,
                brew_packages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of packages to install via brew. This option is ignored on non-OS X builds.
                  "%
                  | optional,
                bundler_args | String | optional,
                cache
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.enum [ false ],
                    definitions.predicate.cache,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.oneOf
                      [
                        definitions.predicate.cache,
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            directories = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ])
                    ],
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        apt = predicates.isType '"Bool",
                        bundler = predicates.isType '"Bool",
                        cargo = predicates.isType '"Bool",
                        ccache = predicates.isType '"Bool",
                        cocoapods = predicates.isType '"Bool",
                        directories = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                        npm = predicates.isType '"Bool",
                        packages = predicates.isType '"Bool",
                        pip = predicates.isType '"Bool",
                        timeout = predicates.isType '"Number",
                        yarn = predicates.isType '"Bool",
                      }
                      {  }
                      false
                      predicates.never
                    ]
                  ])
                  | optional,
                compiler
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.enum [ "clang", "gcc" ])
                    ],
                    predicates.enum [ "clang", "gcc" ]
                  ])
                  | optional,
                cran
                  | String
                  | doc m%"
                  CRAN mirror to use for fetching packages
                  "%
                  | optional,
                crystal
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                d
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                dart
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                dart_task
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        dartanalyzer = predicates.isType '"Bool",
                        dartfmt = predicates.isType '"Bool",
                        install_dartium = predicates.isType '"Bool",
                        test = predicates.isType '"String",
                        xvfb = predicates.isType '"Bool",
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ])
                  | optional,
                deploy
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.deployment
                    ],
                    definitions.predicate.deployment
                  ])
                  | optional,
                dist
                  | predicates.contract_from_predicate
                  (predicates.enum
                  [ "precise", "trusty", "xenial", "bionic", "focal", "jammy" ])
                  | doc m%"
                  The Ubuntu distribution to use
                  "%
                  | optional,
                elixir
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ])
                  | optional,
                elm | definitions.contract.stringOrStringArrayUnique | optional,
                elm-format | definitions.contract.nonEmptyString | optional,
                elm-test | definitions.contract.nonEmptyString | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.envVars,
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        global = definitions.predicate.envVars,
                        jobs = definitions.predicate.envVars,
                        matrix = definitions.predicate.envVars,
                      }
                      {  }
                      false
                      predicates.never
                    ]
                  ])
                  | optional,
                erlang
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ])
                  | optional,
                gemfile
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                ghc
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                git
                  | {
                    autocrlf
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "input" ]
                        ]
                      ])
                      | doc m%"
                      Specify handling of line endings when cloning repository
                      "%
                      | optional,
                    clone
                      | Bool
                      | doc m%"
                      In some work flows, like build stages, it might be beneficial to skip the automatic git clone step.
                      "%
                      | optional,
                    depth
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [ predicates.isType 'Integer, predicates.enum [ false ] ])
                      | optional,
                    lfs_skip_smudge
                      | Bool
                      | doc m%"
                      Skip fetching the git-lfs files during the initial git clone (equivalent to git lfs smudge --skip),
                      "%
                      | optional,
                    quiet
                      | Bool
                      | doc m%"
                      Travis CI clones repositories without the quiet flag (-q) by default. Enabling the quiet flag can be useful if you're trying to avoid log file size limits or even if you just don't need to include it.
                      "%
                      | optional,
                    sparse_checkout
                      | definitions.contract.nonEmptyString
                      | doc m%"
                      Is a path to the existing file in the current repository with data you'd like to put into $GIT_DIR/info/sparse-checkout file of format described in Git documentation.
                      "%
                      | optional,
                    submodules
                      | Bool
                      | doc m%"
                      Control whether submodules should be cloned
                      "%
                      | optional,
                  }
                  | optional,
                go
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ])
                  | optional,
                haxe
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                hxml
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                install | definitions.contract.step | optional,
                jdk
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                julia
                  | definitions.contract.stringOrNumberOrAcceptBothTypeAsArrayUnique
                  | optional,
                language
                  | predicates.contract_from_predicate
                  (predicates.enum
                  [
                    "android",
                    "bash",
                    "c",
                    "c++",
                    "clojure",
                    "cpp",
                    "crystal",
                    "csharp",
                    "d",
                    "dart",
                    "dartlang",
                    "elixir",
                    "elm",
                    "erlang",
                    "generic",
                    "go",
                    "golang",
                    "groovy",
                    "haskell",
                    "haxe",
                    "java",
                    "javascript",
                    "julia",
                    "jvm",
                    "matlab",
                    "minimal",
                    "nix",
                    "node",
                    "node.js",
                    "node_js",
                    "nodejs",
                    "obj-c",
                    "obj_c",
                    "objective-c",
                    "objective_c",
                    "perl",
                    "perl6",
                    "php",
                    "python",
                    "r",
                    "ruby",
                    "rust",
                    "scala",
                    "sh",
                    "shell",
                    "smalltalk"
                  ])
                  | optional,
                lein | String | optional,
                matlab
                  | definitions.contract.stringOrStringArrayUnique
                  | optional,
                mono
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.enum [ "none" ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                neko | String | optional,
                node_js
                  | definitions.contract.stringOrNumberOrAcceptBothTypeAsArrayUnique
                  | optional,
                opt_release
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ])
                  | optional,
                os
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.enum
                    [ "osx", "linux", "linux-ppc64le", "windows" ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.enum
                      [ "osx", "linux", "linux-ppc64le", "windows" ]),
                      predicates.arrays.minItems 1,
                      predicates.arrays.uniqueItems
                    ]
                  ])
                  | doc m%"
                  The operating system to run the job on
                  "%
                  | optional,
                osx_image
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.xcodeVersions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.xcodeVersions,
                      predicates.arrays.minItems 1,
                      predicates.arrays.uniqueItems
                    ]
                  ])
                  | optional,
                pandoc_version | String | optional,
                perl
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                perl6
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                php
                  | definitions.contract.stringOrNumberOrAcceptBothTypeAsArrayUnique
                  | optional,
                podfile
                  | String
                  | doc m%"
                  By default, Travis CI will assume that your Podfile is in the root of the repository. If this is not the case, you can specify where the Podfile is
                  "%
                  | optional,
                python
                  | definitions.contract.stringOrNumberOrAcceptBothTypeAsArrayUnique
                  | optional,
                r
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ])
                  | optional,
                r_binary_packages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                r_github_packages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                r_packages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                repos
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Dictionary of repositories to pass to options(repos)
                  "%
                  | optional,
                rust
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Number"
                  ])
                  | optional,
                rvm
                  | definitions.contract.stringOrNumberOrAcceptBothTypeAsArrayUnique
                  | optional,
                sbt_args | String | optional,
                scala
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                script | definitions.contract.step | optional,
                services
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    definitions.predicate.service,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.service
                    ]
                  ])
                  | optional,
                smalltalk
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                solution
                  | String
                  | doc m%"
                  When the optional solution key is present, Travis will run NuGet package restore and build the given solution.
                  "%
                  | optional,
                sudo
                  | predicates.contract_from_predicate
                  (predicates.enum [ true, false, "", "required", "enabled" ])
                  | doc m%"
                  sudo is deprecated
                  "%
                  | optional,
                xcode_project | String | optional,
                xcode_scheme | String | optional,
                xcode_sdk | String | optional,
                xcode_workspace | String | optional,
                ..
              },
          nonEmptyString = predicates.contract_from_predicate
              definitions.predicate.nonEmptyString,
          nonEmptyStringOrArrayOfNonEmptyStrings =
            predicates.contract_from_predicate
              definitions.predicate.nonEmptyStringOrArrayOfNonEmptyStrings,
          notRequiredNonEmptyString = predicates.contract_from_predicate
              definitions.predicate.notRequiredNonEmptyString,
          notRequiredNonEmptyStringOrArrayOfNonEmptyStrings =
            predicates.contract_from_predicate
              definitions.predicate.notRequiredNonEmptyStringOrArrayOfNonEmptyStrings,
          notificationFrequency = predicates.contract_from_predicate
              definitions.predicate.notificationFrequency,
          notificationObject = predicates.contract_from_predicate
              definitions.predicate.notificationObject,
          possiblySecretString = predicates.contract_from_predicate
              definitions.predicate.possiblySecretString,
          possiblySecretStringOrPossiblySecretStringTypeArrayUnique =
            predicates.contract_from_predicate
              definitions.predicate.possiblySecretStringOrPossiblySecretStringTypeArrayUnique,
          secretString = {
                secure | definitions.contract.nonEmptyString | optional,
              },
          service = predicates.contract_from_predicate
              definitions.predicate.service,
          slackRoom
            | doc m%"
            Your account name, token and optional channel
            "%
            = predicates.contract_from_predicate
              definitions.predicate.slackRoom,
          step = predicates.contract_from_predicate definitions.predicate.step,
          stringArrayUnique = predicates.contract_from_predicate
              definitions.predicate.stringArrayUnique,
          stringOrNumber = predicates.contract_from_predicate
              definitions.predicate.stringOrNumber,
          stringOrNumberAndBothAreTypeArrayUnique =
            predicates.contract_from_predicate
              definitions.predicate.stringOrNumberAndBothAreTypeArrayUnique,
          stringOrNumberOrAcceptBothTypeAsArrayUnique =
            predicates.contract_from_predicate
              definitions.predicate.stringOrNumberOrAcceptBothTypeAsArrayUnique,
          stringOrStringArrayUnique = predicates.contract_from_predicate
              definitions.predicate.stringOrStringArrayUnique,
          xcodeVersions = predicates.contract_from_predicate
              definitions.predicate.xcodeVersions,
        },
    predicate = {
          arrayOfNonEmptyStrings = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.nonEmptyString
              ],
          cache = predicates.enum
              [
                "apt",
                "bundler",
                "cargo",
                "ccache",
                "cocoapods",
                "packages",
                "pip",
                "yarn",
                "npm"
              ],
          deployment = predicates.allOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    on = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            all_branches = predicates.isType '"Bool",
                            branch = predicates.isType '"String",
                            condition = predicates.isType '"String",
                            repo = predicates.isType '"String",
                            skip_cleanup = predicates.isType '"Bool",
                            tags = predicates.oneOf
                                [
                                  predicates.isType '"Bool",
                                  predicates.isType '"String"
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "provider", "script" ],
                    predicates.records.record
                    {
                      provider = predicates.enum [ "script" ],
                      script = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.records.required
                        [ "api_key", "email", "provider" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                      predicates.allOf
                      [
                        predicates.records.required
                        [ "api_token", "email", "provider" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]
                    ],
                    predicates.records.record
                    {
                      api_key = definitions.predicate.possiblySecretString,
                      api_token = definitions.predicate.possiblySecretString,
                      email = definitions.predicate.possiblySecretString,
                      provider = predicates.enum [ "npm" ],
                      tag = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "provider" ],
                    predicates.records.record
                    {
                      domain = predicates.isType '"String",
                      project = predicates.isType '"String",
                      provider = predicates.enum [ "surge" ],
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "provider" ],
                    predicates.records.record
                    {
                      api_key = definitions.predicate.possiblySecretString,
                      file = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ]
                          ],
                      file_glob = predicates.isType '"Bool",
                      overwrite = predicates.isType '"Bool",
                      password = definitions.predicate.possiblySecretString,
                      provider = predicates.enum [ "releases" ],
                      user = definitions.predicate.possiblySecretString,
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "api_key", "provider" ],
                    predicates.records.record
                    {
                      api_key = predicates.anyOf
                          [
                            definitions.predicate.possiblySecretString,
                            predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record {  } {  } true
                              definitions.predicate.possiblySecretString
                            ]
                          ],
                      app = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record {  } {  } true
                              (predicates.isType '"String")
                            ]
                          ],
                      provider = predicates.enum [ "heroku" ],
                      run = predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ]
                          ],
                      skip_cleanup = predicates.isType '"Bool",
                      strategy = predicates.enum [ "api", "git" ],
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required
                    [
                      "access_key_id",
                      "bucket",
                      "provider",
                      "secret_access_key"
                    ],
                    predicates.records.record
                    {
                      access_key_id =
                        definitions.predicate.possiblySecretString,
                      acl = predicates.enum
                          [
                            "private",
                            "public_read",
                            "public_read_write",
                            "authenticated_read",
                            "bucket_owner_read",
                            "bucket_owner_full_control"
                          ],
                      bucket = predicates.isType '"String",
                      cache_control = predicates.isType '"String",
                      default_text_charset = predicates.isType '"String",
                      detect_encoding = predicates.isType '"Bool",
                      endpoint = predicates.isType '"String",
                      expires = predicates.isType '"String",
                      local_dir = predicates.isType '"String",
                      provider = predicates.enum [ "s3" ],
                      region = predicates.isType '"String",
                      secret_access_key =
                        definitions.predicate.possiblySecretString,
                      skip_cleanup = predicates.isType '"Bool",
                      upload-dir = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "provider" ],
                    predicates.records.record
                    {
                      provider = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.not
                            (predicates.enum
                            [
                              "script",
                              "npm",
                              "surge",
                              "releases",
                              "heroku",
                              "s3"
                            ])
                          ],
                    }
                    {  }
                    true
                    predicates.always
                  ]
                ]
              ],
          envVar = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "[^=]+=.*"
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    secure = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "[^=]+=.*"
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          envVars = predicates.oneOf
              [
                definitions.predicate.envVar,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.envVar
                ]
              ],
          "import" = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "source" ],
                  predicates.records.record
                  {
                    "if" = definitions.predicate.nonEmptyString,
                    mode = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "merge",
                            "deep_merge",
                            "deep_merge_append",
                            "deep_merge_prepend"
                          ]
                        ],
                    source = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ],
                definitions.predicate.nonEmptyString
              ],
          job = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addons = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          apt = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  packages = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.isType '"String")
                                      ],
                                  sources = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.oneOf
                                        [
                                          predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "sourceline" ],
                                            predicates.records.record
                                            {
                                              key_url = predicates.isType
                                                  '"String",
                                              sourceline = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                          predicates.isType '"String"
                                        ])
                                      ],
                                  update = predicates.isType '"Bool",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          artifacts = predicates.oneOf
                              [
                                predicates.enum [ true ],
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    debug = predicates.isType '"Bool",
                                    paths = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    s3_region = predicates.isType '"String",
                                    working_dir = predicates.isType '"String",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ]
                              ],
                          browserstack = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  access_key =
                                    definitions.predicate.possiblySecretString,
                                  app_path =
                                    definitions.predicate.nonEmptyString,
                                  forcelocal = predicates.isType '"Bool",
                                  only = definitions.predicate.nonEmptyString,
                                  proxyHost =
                                    definitions.predicate.nonEmptyString,
                                  proxyPass =
                                    definitions.predicate.nonEmptyString,
                                  proxyPort =
                                    definitions.predicate.nonEmptyString,
                                  proxyUser =
                                    definitions.predicate.nonEmptyString,
                                  username =
                                    definitions.predicate.nonEmptyString,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          chrome = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "stable", "beta" ]
                              ],
                          coverity_scan = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  branch_pattern = predicates.isType '"String",
                                  build_command = predicates.isType '"String",
                                  build_command_prepend = predicates.isType
                                      '"String",
                                  notification_email = predicates.isType
                                      '"String",
                                  project = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.required [ "name" ],
                                        predicates.records.record
                                        {
                                          description = predicates.isType
                                              '"String",
                                          name = predicates.isType '"String",
                                          version = predicates.isType '"Number",
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          firefox = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [
                                    "latest",
                                    "latest-esr",
                                    "latest-beta",
                                    "latest-dev",
                                    "latest-nightly",
                                    "latest-unsigned"
                                  ]
                                ],
                                definitions.predicate.nonEmptyString
                              ],
                          homebrew = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  brewfile = predicates.oneOf
                                      [
                                        definitions.predicate.nonEmptyString,
                                        predicates.isType '"Bool"
                                      ],
                                  casks =
                                    definitions.predicate.stringOrStringArrayUnique,
                                  packages =
                                    definitions.predicate.stringOrStringArrayUnique,
                                  taps =
                                    definitions.predicate.stringOrStringArrayUnique,
                                  update = predicates.isType '"Bool",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          hosts = predicates.oneOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                                predicates.isType '"String"
                              ],
                          mariadb = predicates.isType '"String",
                          postgresql = predicates.isType '"String",
                          rethinkdb = predicates.isType '"String",
                          sauce_connect = predicates.oneOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    access_key = predicates.isType '"String",
                                    username = predicates.isType '"String",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                                predicates.isType '"Bool"
                              ],
                          snaps = predicates.oneOf
                              [
                                definitions.predicate.nonEmptyString,
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.oneOf
                                  [
                                    definitions.predicate.nonEmptyString,
                                    predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.required [ "name" ],
                                      predicates.records.record
                                      {
                                        channel =
                                          definitions.predicate.nonEmptyString,
                                        classic = predicates.isType '"Bool",
                                        confinement = predicates.enum
                                            [ "classic", "devmode" ],
                                        name =
                                          definitions.predicate.nonEmptyString,
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ]
                                  ]),
                                  predicates.arrays.minItems 1,
                                  predicates.arrays.uniqueItems
                                ]
                              ],
                          sonarcloud = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  organization = predicates.isType '"String",
                                  token = definitions.predicate.secretString,
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          srcclr = predicates.oneOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  { debug = predicates.isType '"Bool", }
                                  {  }
                                  false
                                  predicates.never
                                ]
                              ],
                          ssh_known_hosts =
                            definitions.predicate.stringOrStringArrayUnique,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  after_deploy = definitions.predicate.step,
                  after_failure = definitions.predicate.step,
                  after_script = definitions.predicate.step,
                  after_success = definitions.predicate.step,
                  android = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          components = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          licenses = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  apt_packages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  arch = predicates.oneOf
                      [
                        predicates.enum
                        [
                          "amd64",
                          "x86_64",
                          "arm64",
                          "ppc64le",
                          "s390x",
                          "arm64-graviton2"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.enum
                          [
                            "amd64",
                            "arm64",
                            "ppc64le",
                            "s390x",
                            "arm64-graviton2"
                          ]),
                          predicates.arrays.minItems 1,
                          predicates.arrays.uniqueItems
                        ]
                      ],
                  before_cache = definitions.predicate.step,
                  before_deploy = definitions.predicate.step,
                  before_install = definitions.predicate.step,
                  before_script = definitions.predicate.step,
                  bioc_packages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  branches = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          except = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          only = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  brew_packages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  bundler_args = predicates.isType '"String",
                  cache = predicates.oneOf
                      [
                        predicates.enum [ false ],
                        definitions.predicate.cache,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.oneOf
                          [
                            definitions.predicate.cache,
                            predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                directories = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.isType '"String")
                                    ],
                              }
                              {  }
                              false
                              predicates.never
                            ]
                          ])
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            apt = predicates.isType '"Bool",
                            bundler = predicates.isType '"Bool",
                            cargo = predicates.isType '"Bool",
                            ccache = predicates.isType '"Bool",
                            cocoapods = predicates.isType '"Bool",
                            directories = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            npm = predicates.isType '"Bool",
                            packages = predicates.isType '"Bool",
                            pip = predicates.isType '"Bool",
                            timeout = predicates.isType '"Number",
                            yarn = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                  compiler = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.enum [ "clang", "gcc" ])
                        ],
                        predicates.enum [ "clang", "gcc" ]
                      ],
                  cran = predicates.isType '"String",
                  crystal = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  d = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  dart = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  dart_task = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            dartanalyzer = predicates.isType '"Bool",
                            dartfmt = predicates.isType '"Bool",
                            install_dartium = predicates.isType '"Bool",
                            test = predicates.isType '"String",
                            xvfb = predicates.isType '"Bool",
                          }
                          {  }
                          true
                          predicates.always
                        ])
                      ],
                  deploy = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.deployment
                        ],
                        definitions.predicate.deployment
                      ],
                  dist = predicates.enum
                      [
                        "precise",
                        "trusty",
                        "xenial",
                        "bionic",
                        "focal",
                        "jammy"
                      ],
                  elixir = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  elm = definitions.predicate.stringOrStringArrayUnique,
                  elm-format = definitions.predicate.nonEmptyString,
                  elm-test = definitions.predicate.nonEmptyString,
                  env = predicates.oneOf
                      [
                        definitions.predicate.envVars,
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            global = definitions.predicate.envVars,
                            jobs = definitions.predicate.envVars,
                            matrix = definitions.predicate.envVars,
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                  erlang = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  gemfile = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  ghc = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  git = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          autocrlf = predicates.oneOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "input" ]
                                ]
                              ],
                          clone = predicates.isType '"Bool",
                          depth = predicates.oneOf
                              [
                                predicates.isType 'Integer,
                                predicates.enum [ false ]
                              ],
                          lfs_skip_smudge = predicates.isType '"Bool",
                          quiet = predicates.isType '"Bool",
                          sparse_checkout =
                            definitions.predicate.nonEmptyString,
                          submodules = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  go = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  haxe = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  hxml = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  install = definitions.predicate.step,
                  jdk = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  julia =
                    definitions.predicate.stringOrNumberOrAcceptBothTypeAsArrayUnique,
                  language = predicates.enum
                      [
                        "android",
                        "bash",
                        "c",
                        "c++",
                        "clojure",
                        "cpp",
                        "crystal",
                        "csharp",
                        "d",
                        "dart",
                        "dartlang",
                        "elixir",
                        "elm",
                        "erlang",
                        "generic",
                        "go",
                        "golang",
                        "groovy",
                        "haskell",
                        "haxe",
                        "java",
                        "javascript",
                        "julia",
                        "jvm",
                        "matlab",
                        "minimal",
                        "nix",
                        "node",
                        "node.js",
                        "node_js",
                        "nodejs",
                        "obj-c",
                        "obj_c",
                        "objective-c",
                        "objective_c",
                        "perl",
                        "perl6",
                        "php",
                        "python",
                        "r",
                        "ruby",
                        "rust",
                        "scala",
                        "sh",
                        "shell",
                        "smalltalk"
                      ],
                  lein = predicates.isType '"String",
                  matlab = definitions.predicate.stringOrStringArrayUnique,
                  mono = predicates.oneOf
                      [
                        predicates.enum [ "none" ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  neko = predicates.isType '"String",
                  node_js =
                    definitions.predicate.stringOrNumberOrAcceptBothTypeAsArrayUnique,
                  opt_release = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  os = predicates.oneOf
                      [
                        predicates.enum
                        [ "osx", "linux", "linux-ppc64le", "windows" ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.enum
                          [ "osx", "linux", "linux-ppc64le", "windows" ]),
                          predicates.arrays.minItems 1,
                          predicates.arrays.uniqueItems
                        ]
                      ],
                  osx_image = predicates.oneOf
                      [
                        definitions.predicate.xcodeVersions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.xcodeVersions,
                          predicates.arrays.minItems 1,
                          predicates.arrays.uniqueItems
                        ]
                      ],
                  pandoc_version = predicates.isType '"String",
                  perl = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  perl6 = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  php =
                    definitions.predicate.stringOrNumberOrAcceptBothTypeAsArrayUnique,
                  podfile = predicates.isType '"String",
                  python =
                    definitions.predicate.stringOrNumberOrAcceptBothTypeAsArrayUnique,
                  r = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  r_binary_packages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  r_github_packages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  r_packages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  repos = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  rust = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  rvm =
                    definitions.predicate.stringOrNumberOrAcceptBothTypeAsArrayUnique,
                  sbt_args = predicates.isType '"String",
                  scala = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  script = definitions.predicate.step,
                  services = predicates.oneOf
                      [
                        definitions.predicate.service,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.service
                        ]
                      ],
                  smalltalk = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  solution = predicates.isType '"String",
                  sudo = predicates.enum
                      [ true, false, "", "required", "enabled" ],
                  xcode_project = predicates.isType '"String",
                  xcode_scheme = predicates.isType '"String",
                  xcode_sdk = predicates.isType '"String",
                  xcode_workspace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          nonEmptyString = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          nonEmptyStringOrArrayOfNonEmptyStrings = predicates.oneOf
              [
                definitions.predicate.nonEmptyString,
                definitions.predicate.arrayOfNonEmptyStrings
              ],
          notRequiredNonEmptyString = predicates.oneOf
              [ definitions.predicate.nonEmptyString, predicates.isType 'Null ],
          notRequiredNonEmptyStringOrArrayOfNonEmptyStrings = predicates.oneOf
              [
                definitions.predicate.nonEmptyStringOrArrayOfNonEmptyStrings,
                predicates.isType 'Null
              ],
          notificationFrequency = predicates.enum
              [ "always", "never", "change" ],
          notificationObject = predicates.always,
          possiblySecretString = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { secure = predicates.isType '"String", }
                  {  }
                  false
                  predicates.never
                ]
              ],
          possiblySecretStringOrPossiblySecretStringTypeArrayUnique =
            predicates.oneOf
              [
                definitions.predicate.possiblySecretString,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.possiblySecretString,
                  predicates.arrays.minItems 1,
                  predicates.arrays.uniqueItems
                ]
              ],
          secretString = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { secure = definitions.predicate.nonEmptyString, }
                {  }
                false
                predicates.never
              ],
          service = predicates.enum
              [
                "cassandra",
                "couchdb",
                "docker",
                "elasticsearch",
                "mariadb",
                "memcached",
                "mongodb",
                "mysql",
                "neo4j",
                "postgresql",
                "rabbitmq",
                "redis",
                "redis-server",
                "rethinkdb",
                "riak",
                "xvfb"
              ],
          slackRoom
            | doc m%"
            Your account name, token and optional channel
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern ".+:.+(#.+)?"
                ],
                definitions.predicate.secretString
              ],
          step = predicates.anyOf
              [
                predicates.isType '"Bool",
                predicates.enum [ "skip", "ignore" ],
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          stringArrayUnique = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.nonEmptyString,
                predicates.arrays.minItems 1,
                predicates.arrays.uniqueItems
              ],
          stringOrNumber = predicates.oneOf
              [
                definitions.predicate.nonEmptyString,
                predicates.isType '"Number"
              ],
          stringOrNumberAndBothAreTypeArrayUnique = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.stringOrNumber,
                predicates.arrays.minItems 1,
                predicates.arrays.uniqueItems
              ],
          stringOrNumberOrAcceptBothTypeAsArrayUnique = predicates.oneOf
              [
                definitions.predicate.stringOrNumber,
                definitions.predicate.stringOrNumberAndBothAreTypeArrayUnique
              ],
          stringOrStringArrayUnique = predicates.oneOf
              [
                definitions.predicate.nonEmptyString,
                definitions.predicate.stringArrayUnique
              ],
          xcodeVersions = predicates.enum
              [
                "xcode6.4",
                "xcode7.3",
                "xcode8",
                "xcode8.3",
                "xcode9",
                "xcode9.1",
                "xcode9.2",
                "xcode9.3",
                "xcode9.4",
                "xcode10",
                "xcode10.1",
                "xcode10.2",
                "xcode10.3",
                "xcode11",
                "xcode11.1",
                "xcode11.2",
                "xcode11.3",
                "xcode11.4",
                "xcode11.4.1",
                "xcode11.5",
                "xcode11.6",
                "xcode12u",
                "xcode12",
                "xcode12.2",
                "xcode12.3",
                "xcode12.4",
                "xcode12.5",
                "xcode13.1",
                "xcode13.2",
                "xcode13.3",
                "xcode13.4",
                "xcode14",
                "xcode14.1",
                "xcode14.2"
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  definitions.predicate.job,
  predicates.allOf
  [
    predicates.isType 'Record,
    predicates.records.record
    {
      "import" = predicates.oneOf
          [
            predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate."import",
              predicates.arrays.uniqueItems
            ],
            definitions.predicate."import"
          ],
      jobs = predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              allow_failures = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.job
                  ],
              exclude = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      definitions.predicate.job,
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { stage = predicates.isType '"String", }
                        {  }
                        true
                        predicates.always
                      ]
                    ])
                  ],
              fast_finish = predicates.isType '"Bool",
              include = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      definitions.predicate.job,
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { stage = predicates.isType '"String", }
                        {  }
                        true
                        predicates.always
                      ]
                    ])
                  ],
            }
            {  }
            false
            predicates.never
          ],
      matrix = predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              allow_failures = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.job
                  ],
              exclude = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.job
                  ],
              fast_finish = predicates.isType '"Bool",
              include = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.job
                  ],
            }
            {  }
            false
            predicates.never
          ],
      notifications = predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              campfire = predicates.oneOf
                  [
                    definitions.predicate.possiblySecretStringOrPossiblySecretStringTypeArrayUnique,
                    predicates.isType '"Bool",
                    definitions.predicate."notificationObject/campfire",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."notificationObject/campfire",
                      predicates.arrays.minItems 1,
                      predicates.arrays.uniqueItems
                    ]
                  ],
              email = predicates.oneOf
                  [
                    definitions.predicate.possiblySecretStringOrPossiblySecretStringTypeArrayUnique,
                    predicates.isType '"Bool",
                    definitions.predicate."notificationObject/email",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."notificationObject/email",
                      predicates.arrays.minItems 1,
                      predicates.arrays.uniqueItems
                    ]
                  ],
              flowdock = predicates.oneOf
                  [
                    definitions.predicate.possiblySecretString,
                    predicates.isType '"Bool",
                    definitions.predicate."notificationObject/flowdock",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."notificationObject/flowdock",
                      predicates.arrays.minItems 1,
                      predicates.arrays.uniqueItems
                    ]
                  ],
              hipchat = predicates.oneOf
                  [
                    definitions.predicate.possiblySecretStringOrPossiblySecretStringTypeArrayUnique,
                    predicates.isType '"Bool",
                    definitions.predicate."notificationObject/hipchat",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."notificationObject/hipchat",
                      predicates.arrays.minItems 1,
                      predicates.arrays.uniqueItems
                    ]
                  ],
              irc = predicates.oneOf
                  [
                    definitions.predicate.possiblySecretStringOrPossiblySecretStringTypeArrayUnique,
                    predicates.isType '"Bool",
                    definitions.predicate."notificationObject/irc",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."notificationObject/irc",
                      predicates.arrays.minItems 1,
                      predicates.arrays.uniqueItems
                    ]
                  ],
              pushover = predicates.oneOf
                  [
                    definitions.predicate.nonEmptyStringOrArrayOfNonEmptyStrings,
                    predicates.isType '"Bool",
                    definitions.predicate."notificationObject/pushover",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."notificationObject/pushover",
                      predicates.arrays.minItems 1,
                      predicates.arrays.uniqueItems
                    ]
                  ],
              slack = predicates.oneOf
                  [
                    definitions.predicate.slackRoom,
                    predicates.isType '"Bool",
                    definitions.predicate."notificationObject/slack",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."notificationObject/slack",
                      predicates.arrays.minItems 1,
                      predicates.arrays.uniqueItems
                    ]
                  ],
              webhooks = predicates.oneOf
                  [
                    definitions.predicate.possiblySecretStringOrPossiblySecretStringTypeArrayUnique,
                    predicates.isType '"Bool",
                    definitions.predicate."notificationObject/webhooks",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."notificationObject/webhooks",
                      predicates.arrays.minItems 1,
                      predicates.arrays.uniqueItems
                    ]
                  ],
            }
            {  }
            false
            predicates.never
          ],
      stages = predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf
            (predicates.oneOf
            [
              predicates.isType '"String",
              predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "if" = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ]
            ])
          ],
      version = predicates.allOf
          [
            predicates.isType '"String",
            predicates.strings.pattern
            "^(~>|>|>=|=|<=|<) (\\d+(?:\\.\\d+)?(?:\\.\\d+)?)$"
          ],
    }
    {  }
    true
    predicates.always
  ]
])