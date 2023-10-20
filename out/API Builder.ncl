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
          annotation = predicates.contract_from_predicate
              definitions.predicate.annotation,
          apidoc = {
                version
                  | String
                  | doc m%"
                  Specifies the version of the API Builder specification that this file is written for. The latest version can be found by visiting /apicollective/apibuilder-spec.
                  "%,
              },
          attribute = {
                description | String | optional,
                name
                  | String
                  | doc m%"
                  the name and identifier of the attribute.
                  "%,
                value
                  | {  .. }
                  | doc m%"
                  a JSON object that is usually utilized by a downstream Generator.
                  "%,
              },
          body = {
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.attribute
                  ])
                  | doc m%"
                  JSON Array defining additional meta data about this body for use by generators.
                  "%
                  | optional,
                deprecation | definitions.contract.deprecation | optional,
                description
                  | String
                  | doc m%"
                  Optional description for what this body provides. Supports GFM.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Specifies the type of this body. Acceptable values include the name of either an enum, a model, or a (primitive type). To specify a List, the type name can be wrapped with "[]". For example, to specify that the type is a collection of strings, use "[string]". To specify a Map, the type name can be prefixed with "map[type]". For example, to specify that the type is a Map of string to long, use "map[long]". Note that for map, the keys must be strings (per the JSON specification).
                  "%,
              },
          contact
            | doc m%"
            Specifies contact information for this service
            "%
            = {
                email
                  | String
                  | doc m%"
                  Email address of the contact person/organization
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Identifying name of the contact person/organization
                  "%
                  | optional,
                url
                  | String
                  | doc m%"
                  URL pointing to the contact information
                  "%
                  | optional,
              },
          deprecation
            | doc m%"
            JSON Object that indicates that this object is deprecated.
            "%
            = {
                description
                  | String
                  | doc m%"
                  Optional, but recommended to contain notes for what the user is supposed to do now that this property is deprecated. Supports GFM.
                  "%
                  | optional,
              },
          enum = predicates.contract_from_predicate definitions.predicate.enum,
          enumvalues = {
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.attribute
                  ])
                  | doc m%"
                  JSON Array defining additional meta data about this enum value for use by generators.
                  "%
                  | optional,
                deprecation | definitions.contract.deprecation | optional,
                description
                  | String
                  | doc m%"
                  Optional description for what this enum value provides. Supports GFM.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the value. Names must start with a letter.
                  "%,
                value
                  | String
                  | doc m%"
                  The actual string representation of this value when serializing. If not specified, defaults to 'name'.
                  "%
                  | optional,
              },
          field = {
                annotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  JSON Array of type string where each value indicates the name of a declared annotation (optional),
                  "%
                  | optional,
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.attribute
                  ])
                  | doc m%"
                  JSON Array defining additional meta data about this field for use by generators.
                  "%
                  | optional,
                "default"
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  Optional default value. The value must be valid for the type specified for this field. For example, if you specify a field named 'limit' with type 'integer', an acceptable default would be 10.
                  "%
                  | optional,
                deprecation | definitions.contract.deprecation | optional,
                description
                  | String
                  | doc m%"
                  Optional description for what this field provides. Supports GFM.
                  "%
                  | optional,
                example
                  | String
                  | doc m%"
                  Optional - an example value for this field used only in the produced documentation
                  "%
                  | optional,
                maximum
                  | std.number.Integer
                  | doc m%"
                  Optional - For a string, refers to the maximum length. For an array, the maximum number of elements in the array. For example, a value of 1 for an array would indicate the array must have at most 1 element.
                  "%
                  | optional,
                minimum
                  | std.number.Integer
                  | doc m%"
                  Optional - For a string, refers to the minimum length. For an array, the minimum number of elements in the array. For example, a value of 1 for an array would indicate the array must have at least 1 element.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[a-zA-Z0-9_]*$"
                  ])
                  | doc m%"
                  Specifies the name of the field. Names must be alphanumeric and start with a letter. Valid characters are a-z, A-Z, 0-9 and _ characters.
                  "%,
                required
                  | Bool
                  | doc m%"
                  By default, all fields are considered required. To make a field optional, set "required" to false. When a field is marked as required, it must be present in any form of a model for that form to be valid. In client-server scenario, this means that any defaults that are present in the model must be applied by the client. If you want a default to be applied by the receiver, you should mark the field as "required": false
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Specifies the type of this field. Acceptable values include the name of either an enum, a model, or a (primitive type). To specify a List, the type name can be wrapped with "[]". For example, to specify that the type is a collection of strings, use "[string]". To specify a Map, the type name can be prefixed with "map[type]". For example, to specify that the type is a Map of string to long, use "map[long]". Note that for map, the keys must be strings (per the JSON specification).
                  "%,
              },
          header = {
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.attribute
                  ])
                  | doc m%"
                  JSON Array defining additional meta data about this header for use by generators.
                  "%
                  | optional,
                "default"
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  The default value for this header. If specified, generated clients will automatically include this header in all requests. Default values must be specified as strings.
                  "%
                  | optional,
                deprecation | definitions.contract.deprecation | optional,
                description
                  | String
                  | doc m%"
                  Optional description for what this header provides. Supports GFM.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the header.
                  "%,
                required
                  | Bool
                  | doc m%"
                  boolean: true|false. By default, all headers are considered required. To make a parameter optional, set "required" to false.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  The type of this header. Acceptable values are either the name of an enum or string. To specify a collection (meaning multiple values for this header can be provided), the type name can be wrapped with "[]". For example, to specify that the type is a collection of strings, use "[string]".
                  "%,
              },
          "import" = {
                uri
                  | String
                  | doc m%"
                  The complete URI to the service specification that we are importing. Within API Builder, you can find the URL to the service specification by clicking on the "service.json" link for a service.
                  "%,
              },
          info = {
                contact
                  | definitions.contract.contact
                  | doc m%"
                  Specifies contact information for this service.
                  "%
                  | optional,
                license
                  | definitions.contract.license
                  | doc m%"
                  Specifies the license under which this service is released.
                  "%
                  | optional,
              },
          interface = predicates.contract_from_predicate
              definitions.predicate.interface,
          license
            | doc m%"
            specifies the license under which this service is released
            "%
            = {
                name
                  | String
                  | doc m%"
                  Name of the license - e.g. MIT
                  "%,
                url
                  | String
                  | doc m%"
                  URL of the license itself
                  "%
                  | optional,
              },
          model
            | doc m%"
            specifies the name of the model. Names must be alphanumeric and start with a letter. Valid characters are a-z, A-Z, 0-9 and _ characters. The name must be unique in the set of names assigned to enums, interfaces, models, or unions types.
            "%
            = predicates.contract_from_predicate definitions.predicate.model,
          operation
            | doc m%"
            
            "%
            = {
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.attribute
                  ])
                  | doc m%"
                  JSON array defining additional meta data about this operation for use by generators.
                  "%
                  | optional,
                body
                  | definitions.contract.body
                  | doc m%"
                  Optional specification for the type of the body of this request. For all operations that support bodies (e.g. POST, PUT, PATCH), allows you to specify the type of the body.
                  "%
                  | optional,
                deprecation | definitions.contract.deprecation | optional,
                description
                  | String
                  | doc m%"
                  Optional description for what this operation provides. Supports GFM.
                  "%
                  | optional,
                method
                  | String
                  | doc m%"
                  The HTTP method for this operation
                  "%,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.parameter
                  ])
                  | doc m%"
                  Optional JSON Array of the parameters to this method. By default, for GET methods, parameters are assumed to be in the path or in the query. For other methods, parameters are assumed to be in the path or form body, unless you have explicitly specified a body in which case parameters can be provided in the path or the query.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Optional path for this particular operation. If not provided, defaults to no additional path. Path parameters can be specified by prefixing a path element with ':'. For example, a path of '/:guid' would imply that this operation is available at /resource_path/:guid. Path parameter types are inferred by looking for a field with that name on the model associated with this resource. If not found, the datatype of any path parameter will be string.
                  "%
                  | optional,
                responses
                  | definitions.contract.response
                  | doc m%"
                  Optional JSON Object of HTTP Response Code to Response. If not provided, an HTTP NoContent response is assumed. Only responses for HTTP status codes that are interesting should be documented.
                  "%
                  | optional,
              },
          parameter = {
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.attribute
                  ])
                  | doc m%"
                  JSON array defining additional meta data about this parameter for use by generators.
                  "%
                  | optional,
                "default"
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  Optional default value. The value must be valid for the type specified for this parameter. For example, if you specify a parameter named 'limit' with type 'integer', an acceptable default would be 10
                  "%
                  | optional,
                deprecation | definitions.contract.deprecation | optional,
                description
                  | String
                  | doc m%"
                  Optional description for what this parameter provides. Supports GFM.
                  "%
                  | optional,
                example
                  | String
                  | doc m%"
                  Optional - an example value for this parameter used only in the produced documentation
                  "%
                  | optional,
                location
                  | String
                  | doc m%"
                  One of: path, query, form, header. Defines the location of this parameter. Default location varies based on the context of the parameter (e.g. if the operation method is a POST, the default will be Form; if a GET, the default will be Query)
                  "%
                  | optional,
                maximum
                  | std.number.Integer
                  | doc m%"
                  Optional - For a string, refers to the maximum length. For an array, the maximum number of elements in the array. For example, a value of 1 for an array would indicate the array must have at most 1 element.
                  "%
                  | optional,
                minimum
                  | std.number.Integer
                  | doc m%"
                  Optional - For a string, refers to the minimum length. For an array, the minimum number of elements in the array. For example, a value of 1 for an array would indicate the array must have at least 1 element.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[a-zA-Z0-9_]*$"
                  ])
                  | doc m%"
                  The name of the parameter. Names must be alphanumeric and must start with a letter. Valid characters are a-z, A-Z, 0-9 and _ characters.
                  "%,
                required
                  | Bool
                  | doc m%"
                  By default all parameters are considered required. To make a parameter optional, set "required" to false.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Specifies the type of this parameter. Acceptable values include the name of either an enum, a model, or a (primitive type). To specify a List, the type name can be wrapped with "[]". For example, to specify that the type is a collection of strings, use "[string]". To specify a Map, the type name can be prefixed with "map[type]". For example, to specify that the type is a Map of string to long, use "map[long]". Note that for map, the keys must be strings (per the JSON specification).
                  "%,
              },
          resource = predicates.contract_from_predicate
              definitions.predicate.resource,
          response = predicates.contract_from_predicate
              definitions.predicate.response,
          union = predicates.contract_from_predicate
              definitions.predicate.union,
          uniontype = {
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.attribute
                  ])
                  | doc m%"
                  JSON Array defining additional meta data about this union type for use by generators.
                  "%
                  | optional,
                "default"
                  | Bool
                  | doc m%"
                  If true, indicates that this type should be used as the default when deserializing union types. This field is only used by union types that require a discriminator and sets the default value for that discriminator during deserialization.
                  "%
                  | optional,
                deprecation | definitions.contract.deprecation | optional,
                description | String | optional,
                discriminator_value
                  | String
                  | doc m%"
                  The discriminator value defines the string to use in the discriminator field to identify this type. If not specified, the discriminator value will default to the name of the type itself.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Specifies the type to include in this union type. Acceptable values include the name of either an enum, a model, or a (primitive type).
                  description optional description for what this type provides. Supports GFM.
                  "%,
              },
        },
    predicate = {
          annotation = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z0-9_]*$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          deprecation = definitions.predicate.deprecation,
                          description = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                true
                predicates.always
              ],
          apidoc = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "version" ],
                predicates.records.record
                { version = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          attribute = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "value" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  value = predicates.isType 'Record,
                }
                {  }
                false
                predicates.never
              ],
          body = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.attribute
                      ],
                  deprecation = definitions.predicate.deprecation,
                  description = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          contact
            | doc m%"
            Specifies contact information for this service
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  email = predicates.isType '"String",
                  name = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          deprecation
            | doc m%"
            JSON Object that indicates that this object is deprecated.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { description = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          enum = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z0-9_]*$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "values" ],
                        predicates.records.record
                        {
                          attributes = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.attribute
                              ],
                          deprecation = definitions.predicate.deprecation,
                          description = predicates.isType '"String",
                          plural = predicates.isType '"String",
                          values = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.enumvalues
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                true
                predicates.always
              ],
          enumvalues = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.attribute
                      ],
                  deprecation = definitions.predicate.deprecation,
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          field = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "type" ],
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.attribute
                      ],
                  "default" = predicates.always,
                  deprecation = definitions.predicate.deprecation,
                  description = predicates.isType '"String",
                  example = predicates.isType '"String",
                  maximum = predicates.isType 'Integer,
                  minimum = predicates.isType 'Integer,
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^[a-zA-Z0-9_]*$"
                      ],
                  required = predicates.isType '"Bool",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          header = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "type" ],
                predicates.records.record
                {
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.attribute
                      ],
                  "default" = predicates.always,
                  deprecation = definitions.predicate.deprecation,
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  required = predicates.isType '"Bool",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          "import" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "uri" ],
                predicates.records.record { uri = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          info = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  contact = definitions.predicate.contact,
                  license = definitions.predicate.license,
                }
                {  }
                false
                predicates.never
              ],
          interface = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z0-9_]*$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          attributes = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.attribute
                              ],
                          deprecation = definitions.predicate.deprecation,
                          description = predicates.isType '"String",
                          fields = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.field
                              ],
                          plural = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                true
                predicates.always
              ],
          license
            | doc m%"
            specifies the license under which this service is released
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          model
            | doc m%"
            specifies the name of the model. Names must be alphanumeric and start with a letter. Valid characters are a-z, A-Z, 0-9 and _ characters. The name must be unique in the set of names assigned to enums, interfaces, models, or unions types.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z0-9_]*$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          attributes = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.attribute
                              ],
                          deprecation = definitions.predicate.deprecation,
                          description = predicates.isType '"String",
                          fields = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.field
                              ],
                          interfaces = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          plural = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                false
                predicates.never
              ],
          operation
            | doc m%"
            
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "method" ],
                predicates.records.record
                {
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.attribute
                      ],
                  body = definitions.predicate.body,
                  deprecation = definitions.predicate.deprecation,
                  description = predicates.isType '"String",
                  method = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.parameter
                      ],
                  path = predicates.isType '"String",
                  responses = definitions.predicate.response,
                }
                {  }
                false
                predicates.never
              ],
          parameter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "type" ],
                predicates.records.record
                {
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.attribute
                      ],
                  "default" = predicates.always,
                  deprecation = definitions.predicate.deprecation,
                  description = predicates.isType '"String",
                  example = predicates.isType '"String",
                  location = predicates.isType '"String",
                  maximum = predicates.isType 'Integer,
                  minimum = predicates.isType 'Integer,
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^[a-zA-Z0-9_]*$"
                      ],
                  required = predicates.isType '"Bool",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          resource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z0-9_.]*$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "operations" ],
                        predicates.records.record
                        {
                          attributes = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.attribute
                              ],
                          deprecation = definitions.predicate.deprecation,
                          description = predicates.isType '"String",
                          operations = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.operation
                              ],
                          path = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          response = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[0-9]*$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "type" ],
                        predicates.records.record
                        {
                          attributes = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.attribute
                              ],
                          deprecation = definitions.predicate.deprecation,
                          description = predicates.isType '"String",
                          headers = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.header
                              ],
                          type = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          union = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z0-9_]*$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "types" ],
                        predicates.records.record
                        {
                          attributes = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.attribute
                              ],
                          deprecation = definitions.predicate.deprecation,
                          description = predicates.isType '"String",
                          discriminator = predicates.isType '"String",
                          interfaces = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          plural = predicates.isType '"String",
                          types = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.uniontype
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          uniontype = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.attribute
                      ],
                  "default" = predicates.isType '"Bool",
                  deprecation = definitions.predicate.deprecation,
                  description = predicates.isType '"String",
                  discriminator_value = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.records.required [ "name" ],
  predicates.records.record
  {
    "$schema" = predicates.isType '"String",
    annotations = definitions.predicate.annotation,
    apidoc = definitions.predicate.apidoc,
    attributes = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.attribute
        ],
    base_url = predicates.isType '"String",
    description = predicates.isType '"String",
    enums = definitions.predicate.enum,
    headers = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.header
        ],
    imports = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate."import"
        ],
    info = definitions.predicate.info,
    interfaces = definitions.predicate.interface,
    models = definitions.predicate.model,
    name = predicates.isType '"String",
    namespace = predicates.isType '"String",
    resources = definitions.predicate.resource,
    unions = definitions.predicate.union,
  }
  {  }
  false
  predicates.never
])