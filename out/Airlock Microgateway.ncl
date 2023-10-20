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
          DefaultActionDto = {
                enabled
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ])
                  | doc m%"
                  Enable this default header action
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Name of the default header action
                  "%
                  | optional,
              },
          ExpertSettingsDto-nullable = predicates.contract_from_predicate
              definitions.predicate.ExpertSettingsDto-nullable,
          PatternDto-nullable = predicates.contract_from_predicate
              definitions.predicate.PatternDto-nullable,
          PatternWithRewriteDto-nullable = predicates.contract_from_predicate
              definitions.predicate.PatternWithRewriteDto-nullable,
          PatternWithoutInvertDto = {
                ignore_case
                  | Bool
                  | doc m%"
                  Whether to ignore case.
                  "%
                  | optional,
                pattern
                  | String
                  | doc m%"
                  A regex pattern used to match, cannot be empty. If you need a pattern that matches every string use ".*"
                  "%,
              },
          PatternWithoutInvertDto-nullable = predicates.contract_from_predicate
              definitions.predicate.PatternWithoutInvertDto-nullable,
          RemoveHeaderActionDto-nullable = predicates.contract_from_predicate
              definitions.predicate.RemoveHeaderActionDto-nullable,
          RewriteHeaderValueDto-nullable = predicates.contract_from_predicate
              definitions.predicate.RewriteHeaderValueDto-nullable,
          SimpleHeaderActionDto-nullable = predicates.contract_from_predicate
              definitions.predicate.SimpleHeaderActionDto-nullable,
          SimplePatternDto-nullable = predicates.contract_from_predicate
              definitions.predicate.SimplePatternDto-nullable,
        },
    predicate = {
          DefaultActionDto = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  name = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          ExpertSettingsDto-nullable = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  apache = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  security_gate = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          PatternDto-nullable = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.required [ "pattern" ],
                predicates.records.record
                {
                  ignore_case = predicates.isType '"Bool",
                  inverted = predicates.isType '"Bool",
                  pattern = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PatternWithRewriteDto-nullable = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  regex = predicates.allOf
                      [
                        definitions.predicate.PatternDto-nullable,
                        predicates.always
                      ],
                  substitution = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          PatternWithoutInvertDto = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "pattern" ],
                predicates.records.record
                {
                  ignore_case = predicates.isType '"Bool",
                  pattern = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PatternWithoutInvertDto-nullable = predicates.anyOf
              [
                predicates.isType 'Null,
                definitions.predicate.PatternWithoutInvertDto
              ],
          RemoveHeaderActionDto-nullable = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  name = predicates.allOf
                      [
                        definitions.predicate.PatternDto-nullable,
                        predicates.always
                      ],
                  value = predicates.allOf
                      [
                        definitions.predicate.PatternDto-nullable,
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          RewriteHeaderValueDto-nullable = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  name = predicates.allOf
                      [
                        definitions.predicate.PatternDto-nullable,
                        predicates.always
                      ],
                  replace = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  value = predicates.allOf
                      [
                        definitions.predicate.PatternDto-nullable,
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          SimpleHeaderActionDto-nullable = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  name = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  value = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          SimplePatternDto-nullable = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  pattern = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

{
  apps
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
          mappings = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    access_token = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            audittoken = predicates.anyOf
                                [
                                  predicates.isType '"Bool",
                                  predicates.isType 'Null
                                ],
                            claims = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      claim = predicates.anyOf
                                          [
                                            predicates.isType '"String",
                                            predicates.isType 'Null
                                          ],
                                      regex = predicates.allOf
                                          [
                                            definitions.predicate.PatternDto-nullable,
                                            predicates.always
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            expiry_checked = predicates.anyOf
                                [
                                  predicates.isType '"Bool",
                                  predicates.isType 'Null
                                ],
                            extraction = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.isType 'Null
                                  ],
                                  predicates.records.record
                                  {
                                    cookie = predicates.anyOf
                                        [
                                          predicates.isType '"String",
                                          predicates.isType 'Null
                                        ],
                                    header = predicates.allOf
                                        [
                                          definitions.predicate.PatternWithRewriteDto-nullable,
                                          predicates.always
                                        ],
                                    mode = predicates.anyOf
                                        [
                                          predicates.isType 'Null,
                                          predicates.allOf
                                          [
                                            predicates.isType '"String",
                                            predicates.enum
                                            [ "header", "parameter", "cookie" ]
                                          ]
                                        ],
                                    parameter = predicates.anyOf
                                        [
                                          predicates.isType '"String",
                                          predicates.isType 'Null
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            jwks_providers = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            mandatory = predicates.anyOf
                                [
                                  predicates.isType '"Bool",
                                  predicates.isType 'Null
                                ],
                            roles = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      claim = predicates.anyOf
                                          [
                                            predicates.isType '"String",
                                            predicates.isType 'Null
                                          ],
                                      extraction = predicates.allOf
                                          [
                                            definitions.predicate.PatternWithRewriteDto-nullable,
                                            predicates.always
                                          ],
                                      token_lifetime = predicates.anyOf
                                          [
                                            predicates.isType '"Bool",
                                            predicates.isType 'Null
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            signature_mandatory = predicates.anyOf
                                [
                                  predicates.isType '"Bool",
                                  predicates.isType 'Null
                                ],
                            skew = predicates.anyOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.isType 'Null
                                ],
                            tech_client_id_claim = predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType 'Null
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    allow_rules = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              content_type = predicates.allOf
                                  [
                                    definitions.predicate.PatternDto-nullable,
                                    predicates.always
                                  ],
                              enabled = predicates.isType '"Bool",
                              log_only = predicates.isType '"Bool",
                              method = predicates.allOf
                                  [
                                    definitions.predicate.PatternDto-nullable,
                                    predicates.always
                                  ],
                              name = predicates.isType '"String",
                              path = predicates.allOf
                                  [
                                    definitions.predicate.PatternDto-nullable,
                                    predicates.always
                                  ],
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    api_security = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            json_content_type = predicates.allOf
                                [
                                  definitions.predicate.PatternDto-nullable,
                                  predicates.always
                                ],
                            openapi = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.isType 'Null
                                  ],
                                  predicates.records.record
                                  {
                                    log_only = predicates.anyOf
                                        [
                                          predicates.isType '"Bool",
                                          predicates.isType 'Null
                                        ],
                                    path_matching = predicates.anyOf
                                        [
                                          predicates.isType 'Null,
                                          predicates.allOf
                                          [
                                            predicates.isType '"String",
                                            predicates.enum
                                            [ "client_view", "backend_view" ]
                                          ]
                                        ],
                                    response_validation = predicates.anyOf
                                        [
                                          predicates.isType '"Bool",
                                          predicates.isType 'Null
                                        ],
                                    spec = predicates.anyOf
                                        [
                                          predicates.isType '"String",
                                          predicates.isType 'Null
                                        ],
                                    spec_file = predicates.anyOf
                                        [
                                          predicates.isType '"String",
                                          predicates.isType 'Null
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            treat_json_objects_as_parameters = predicates.anyOf
                                [
                                  predicates.isType '"Bool",
                                  predicates.isType 'Null
                                ],
                            treat_path_segments_as_parameters = predicates.anyOf
                                [
                                  predicates.isType '"Bool",
                                  predicates.isType 'Null
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    auth = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            access = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      method = predicates.allOf
                                          [
                                            definitions.predicate.PatternDto-nullable,
                                            predicates.always
                                          ],
                                      path = predicates.allOf
                                          [
                                            definitions.predicate.PatternDto-nullable,
                                            predicates.always
                                          ],
                                      roles = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.isType '"String")
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            client_certificate = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.isType 'Null
                                  ],
                                  predicates.records.record
                                  {
                                    verification = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [ "inherit", "optional", "required" ]
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            denied_access_url = predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType 'Null
                                ],
                            flow = predicates.anyOf
                                [
                                  predicates.isType 'Null,
                                  predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.enum
                                    [
                                      "redirect",
                                      "deny_access",
                                      "one_shot",
                                      "one_shot_with_body",
                                      "ntlm"
                                    ]
                                  ]
                                ],
                            logout_propagation_path = predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType 'Null
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    backend = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            expert_settings = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.isType 'Null
                                  ],
                                  predicates.records.record
                                  {
                                    security_gate = predicates.anyOf
                                        [
                                          predicates.isType '"String",
                                          predicates.isType 'Null
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            hosts = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      name = predicates.allOf
                                          [
                                            predicates.isType '"String",
                                            predicates.strings.pattern
                                            "^[A-Za-z0-9.\\-_:]+$"
                                          ],
                                      port = predicates.allOf
                                          [
                                            predicates.isType 'Integer,
                                            predicates.numbers.maximum 65535,
                                            predicates.numbers.minimum 1
                                          ],
                                      protocol = predicates.allOf
                                          [
                                            predicates.isType '"String",
                                            predicates.enum [ "https", "http" ]
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            name = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^[A-Za-z0-9.\\-_:]+$"
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    backend_path = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                    compress_response_traffic = predicates.anyOf
                        [ predicates.isType '"Bool", predicates.isType 'Null ],
                    control_api = predicates.anyOf
                        [ predicates.isType '"Bool", predicates.isType 'Null ],
                    cookies = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            encrypted = predicates.allOf
                                [
                                  definitions.predicate.SimplePatternDto-nullable,
                                  predicates.always
                                ],
                            passthrough = predicates.allOf
                                [
                                  definitions.predicate.SimplePatternDto-nullable,
                                  predicates.always
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    csrf_token = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            enabled = predicates.anyOf
                                [
                                  predicates.isType '"Bool",
                                  predicates.isType 'Null
                                ],
                            exceptions = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.isType 'Null
                                  ],
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      path =
                                        definitions.predicate.PatternWithoutInvertDto-nullable,
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            invalid_token_redirect_location = predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType 'Null
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    deny_rule_groups = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              enabled = predicates.anyOf
                                  [
                                    predicates.isType '"Bool",
                                    predicates.isType 'Null
                                  ],
                              exceptions = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        content_type =
                                          definitions.predicate.PatternDto-nullable,
                                        header_name =
                                          definitions.predicate.PatternDto-nullable,
                                        header_value =
                                          definitions.predicate.PatternDto-nullable,
                                        method =
                                          definitions.predicate.PatternDto-nullable,
                                        parameter_name =
                                          definitions.predicate.PatternDto-nullable,
                                        parameter_value =
                                          definitions.predicate.PatternDto-nullable,
                                        path =
                                          definitions.predicate.PatternDto-nullable,
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ])
                                  ],
                              level = predicates.anyOf
                                  [
                                    predicates.isType 'Null,
                                    predicates.allOf
                                    [
                                      predicates.isType '"String",
                                      predicates.enum
                                      [ "basic", "standard", "strict" ]
                                    ]
                                  ],
                              log_only = predicates.anyOf
                                  [
                                    predicates.isType '"Bool",
                                    predicates.isType 'Null
                                  ],
                              rule_group_keys = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    entry_path = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            enforce_trailing_slashes = predicates.anyOf
                                [
                                  predicates.isType '"Bool",
                                  predicates.isType 'Null
                                ],
                            ignore_case = predicates.anyOf
                                [
                                  predicates.isType '"Bool",
                                  predicates.isType 'Null
                                ],
                            type = predicates.anyOf
                                [
                                  predicates.isType 'Null,
                                  predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.enum [ "directory", "regex" ]
                                  ]
                                ],
                            value = predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType 'Null
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    env_cookies = predicates.anyOf
                        [ predicates.isType '"Bool", predicates.isType 'Null ],
                    expert_settings =
                      definitions.predicate.ExpertSettingsDto-nullable,
                    limits = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            http_limits = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.isType 'Null
                                  ],
                                  predicates.records.record
                                  {
                                    max_parameter_name_length = predicates.anyOf
                                        [
                                          predicates.isType 'Integer,
                                          predicates.isType 'Null
                                        ],
                                    max_parameter_value_length =
                                      predicates.anyOf
                                        [
                                          predicates.isType 'Integer,
                                          predicates.isType 'Null
                                        ],
                                    max_parameters = predicates.anyOf
                                        [
                                          predicates.isType 'Integer,
                                          predicates.isType 'Null
                                        ],
                                    parameter_length_exception =
                                      predicates.allOf
                                        [
                                          definitions.predicate.PatternDto-nullable,
                                          predicates.always
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            json_limits = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.isType 'Null
                                  ],
                                  predicates.records.record
                                  {
                                    max_array_items = predicates.anyOf
                                        [
                                          predicates.isType 'Integer,
                                          predicates.isType 'Null
                                        ],
                                    max_key_length = predicates.anyOf
                                        [
                                          predicates.isType 'Integer,
                                          predicates.isType 'Null
                                        ],
                                    max_keys = predicates.anyOf
                                        [
                                          predicates.isType 'Integer,
                                          predicates.isType 'Null
                                        ],
                                    max_length_exception = predicates.allOf
                                        [
                                          definitions.predicate.PatternDto-nullable,
                                          predicates.always
                                        ],
                                    max_nesting_depth = predicates.anyOf
                                        [
                                          predicates.isType 'Integer,
                                          predicates.isType 'Null
                                        ],
                                    max_total_entries = predicates.anyOf
                                        [
                                          predicates.isType 'Integer,
                                          predicates.isType 'Null
                                        ],
                                    max_value_length = predicates.anyOf
                                        [
                                          predicates.isType 'Integer,
                                          predicates.isType 'Null
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            max_path_length = predicates.anyOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.isType 'Null
                                ],
                            max_request_body_size = predicates.anyOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.isType 'Null
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    mapping_template_file = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                    name = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                    operational_mode = predicates.anyOf
                        [
                          predicates.isType 'Null,
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "production", "integration" ]
                          ]
                        ],
                    parameter_pollution = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            mixed_type = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.isType 'Null
                                  ],
                                  predicates.records.record
                                  {
                                    block_duplicates = predicates.anyOf
                                        [
                                          predicates.isType '"Bool",
                                          predicates.isType 'Null
                                        ],
                                    log_only = predicates.anyOf
                                        [
                                          predicates.isType '"Bool",
                                          predicates.isType 'Null
                                        ],
                                    parameter_name_exception = predicates.allOf
                                        [
                                          definitions.predicate.PatternDto-nullable,
                                          predicates.always
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            same_type = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.isType 'Null
                                  ],
                                  predicates.records.record
                                  {
                                    join_duplicates = predicates.anyOf
                                        [
                                          predicates.isType '"Bool",
                                          predicates.isType 'Null
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    "priority" = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Integer,
                            predicates.isType 'Null
                          ],
                          predicates.numbers.maximum 999,
                          predicates.numbers.minimum (-999)
                        ],
                    request = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            custom_actions = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.isType 'Null
                                  ],
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      add_header = predicates.allOf
                                          [
                                            definitions.predicate.SimpleHeaderActionDto-nullable,
                                            predicates.always
                                          ],
                                      add_missing_header = predicates.allOf
                                          [
                                            definitions.predicate.SimpleHeaderActionDto-nullable,
                                            predicates.always
                                          ],
                                      add_or_replace_header = predicates.allOf
                                          [
                                            definitions.predicate.SimpleHeaderActionDto-nullable,
                                            predicates.always
                                          ],
                                      geolocation_redirect = predicates.allOf
                                          [
                                            predicates.anyOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.isType 'Null
                                            ],
                                            predicates.records.record
                                            {
                                              continent_codes = predicates.allOf
                                                  [
                                                    predicates.anyOf
                                                    [
                                                      predicates.isType
                                                      '"Array",
                                                      predicates.isType 'Null
                                                    ],
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              country_codes = predicates.allOf
                                                  [
                                                    predicates.anyOf
                                                    [
                                                      predicates.isType
                                                      '"Array",
                                                      predicates.isType 'Null
                                                    ],
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              status_code = predicates.anyOf
                                                  [
                                                    predicates.isType 'Integer,
                                                    predicates.isType 'Null
                                                  ],
                                              target_url = predicates.anyOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.isType 'Null
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      header_redirect = predicates.allOf
                                          [
                                            predicates.anyOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.isType 'Null
                                            ],
                                            predicates.records.record
                                            {
                                              name = predicates.allOf
                                                  [
                                                    definitions.predicate.PatternDto-nullable,
                                                    predicates.always
                                                  ],
                                              status_code = predicates.anyOf
                                                  [
                                                    predicates.isType 'Integer,
                                                    predicates.isType 'Null
                                                  ],
                                              target_url = predicates.anyOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.isType 'Null
                                                  ],
                                              value = predicates.allOf
                                                  [
                                                    definitions.predicate.PatternDto-nullable,
                                                    predicates.always
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      name = predicates.isType '"String",
                                      remove_header = predicates.allOf
                                          [
                                            definitions.predicate.RemoveHeaderActionDto-nullable,
                                            predicates.always
                                          ],
                                      rewrite_header_value = predicates.allOf
                                          [
                                            definitions.predicate.RewriteHeaderValueDto-nullable,
                                            predicates.always
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            default_actions = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.isType 'Null
                                  ],
                                  predicates.arrays.arrayOf
                                  definitions.predicate.DefaultActionDto
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    response = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            custom_actions = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.isType 'Null
                                  ],
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      add_header = predicates.allOf
                                          [
                                            definitions.predicate.SimpleHeaderActionDto-nullable,
                                            predicates.always
                                          ],
                                      add_missing_header = predicates.allOf
                                          [
                                            definitions.predicate.SimpleHeaderActionDto-nullable,
                                            predicates.always
                                          ],
                                      add_or_replace_header = predicates.allOf
                                          [
                                            definitions.predicate.SimpleHeaderActionDto-nullable,
                                            predicates.always
                                          ],
                                      name = predicates.isType '"String",
                                      remove_header = predicates.allOf
                                          [
                                            definitions.predicate.RemoveHeaderActionDto-nullable,
                                            predicates.always
                                          ],
                                      rewrite_cookie = predicates.allOf
                                          [
                                            predicates.anyOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.isType 'Null
                                            ],
                                            predicates.records.record
                                            {
                                              cookie = predicates.allOf
                                                  [
                                                    definitions.predicate.PatternDto-nullable,
                                                    predicates.always
                                                  ],
                                              domain = predicates.allOf
                                                  [
                                                    definitions.predicate.PatternWithoutInvertDto-nullable,
                                                    predicates.always
                                                  ],
                                              domain_replace = predicates.anyOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.isType 'Null
                                                  ],
                                              http_only_mode = predicates.allOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.enum
                                                    [
                                                      "auto",
                                                      "keep",
                                                      "remove",
                                                      "add"
                                                    ]
                                                  ],
                                              path = predicates.allOf
                                                  [
                                                    definitions.predicate.PatternWithoutInvertDto-nullable,
                                                    predicates.always
                                                  ],
                                              path_replace = predicates.anyOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.isType 'Null
                                                  ],
                                              secure_mode = predicates.allOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.enum
                                                    [
                                                      "auto",
                                                      "keep",
                                                      "remove",
                                                      "add"
                                                    ]
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      rewrite_header_value = predicates.allOf
                                          [
                                            definitions.predicate.RewriteHeaderValueDto-nullable,
                                            predicates.always
                                          ],
                                      rewrite_raw_cookie = predicates.allOf
                                          [
                                            predicates.anyOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.isType 'Null
                                            ],
                                            predicates.records.record
                                            {
                                              replace = predicates.anyOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.isType 'Null
                                                  ],
                                              value = predicates.allOf
                                                  [
                                                    definitions.predicate.PatternWithoutInvertDto-nullable,
                                                    predicates.always
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            default_actions = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.isType 'Null
                                  ],
                                  predicates.arrays.arrayOf
                                  definitions.predicate.DefaultActionDto
                                ],
                            error_page_replacements = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.isType 'Null
                                  ],
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      page = predicates.anyOf
                                          [
                                            predicates.isType '"String",
                                            predicates.isType 'Null
                                          ],
                                      status_code = predicates.allOf
                                          [
                                            definitions.predicate.SimplePatternDto-nullable,
                                            predicates.always
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            rewrites = predicates.allOf
                                [
                                  predicates.anyOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.isType 'Null
                                  ],
                                  predicates.records.record
                                  {
                                    any = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              content = predicates.allOf
                                                  [
                                                    definitions.predicate.PatternWithoutInvertDto-nullable,
                                                    predicates.always
                                                  ],
                                              content_type = predicates.isType
                                                  '"String",
                                              to = predicates.anyOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.isType 'Null
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                    html = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              options = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.allOf
                                                    [
                                                      predicates.isType
                                                      '"String",
                                                      predicates.enum
                                                      [
                                                        "url",
                                                        "event",
                                                        "embedded"
                                                      ]
                                                    ])
                                                  ],
                                              to = predicates.anyOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.isType 'Null
                                                  ],
                                              url = predicates.allOf
                                                  [
                                                    definitions.predicate.PatternWithoutInvertDto-nullable,
                                                    predicates.always
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                    json = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              content = predicates.allOf
                                                  [
                                                    definitions.predicate.PatternWithoutInvertDto-nullable,
                                                    predicates.always
                                                  ],
                                              path = predicates.isType
                                                  '"String",
                                              replace = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                    location_header = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              to = predicates.anyOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.isType 'Null
                                                  ],
                                              url = predicates.allOf
                                                  [
                                                    definitions.predicate.PatternWithoutInvertDto-nullable,
                                                    predicates.always
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    session_handling = predicates.anyOf
                        [
                          predicates.isType 'Null,
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "enforce_session",
                              "optional_session",
                              "optional_session_no_refresh",
                              "ignore_session"
                            ]
                          ]
                        ],
                    threat_handling = predicates.anyOf
                        [
                          predicates.isType 'Null,
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [ "terminate_session", "block", "notify" ]
                          ]
                        ],
                    timeouts = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            backend_http_response = predicates.anyOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.isType 'Null
                                ],
                            idle_session = predicates.anyOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.isType 'Null
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          virtual_host = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  aliases = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  auth = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Record, predicates.isType 'Null ],
                        predicates.records.record
                        {
                          client_certificate = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Record,
                                  predicates.isType 'Null
                                ],
                                predicates.records.record
                                {
                                  ca_selection = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  ca_selection_file = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  ca_validation = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  ca_validation_file = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  crl = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  crl_file = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  verification = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [ "off", "optional", "required" ]
                                      ],
                                  verification_depth = predicates.isType
                                      'Integer,
                                }
                                {  }
                                false
                                predicates.never
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  certificate = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Record, predicates.isType 'Null ],
                        predicates.records.record
                        {
                          ca_chain = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType 'Null
                              ],
                          ca_chain_file = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType 'Null
                              ],
                          certificate = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType 'Null
                              ],
                          certificate_file = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType 'Null
                              ],
                          privatekey = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType 'Null
                              ],
                          privatekey_file = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType 'Null
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  encoded_slashes = predicates.isType '"Bool",
                  expert_settings =
                    definitions.predicate.ExpertSettingsDto-nullable,
                  hostname = predicates.isType '"String",
                  http2_enabled = predicates.isType '"Bool",
                  http_enabled = predicates.isType '"Bool",
                  http_port = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 65535,
                        predicates.numbers.minimum 1
                      ],
                  https_enabled = predicates.isType '"Bool",
                  https_port = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 65535,
                        predicates.numbers.minimum 1
                      ],
                  name = predicates.isType '"String",
                  redirects = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "dest", "path" ],
                          predicates.records.record
                          {
                            dest = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.minLength 1,
                                  predicates.strings.pattern
                                  "^(http://|https://|ftp://|/)\\S*?$"
                                ],
                            path = predicates.allOf
                                [
                                  definitions.predicate.PatternWithoutInvertDto,
                                  predicates.always
                                ],
                            status_code = predicates.allOf
                                [
                                  predicates.isType 'Integer,
                                  predicates.numbers.maximum 308,
                                  predicates.numbers.minimum 301
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                  session_cookie_domain = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  session_cookie_path = predicates.isType '"String",
                  strict_fqdn = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
        }
        {  }
        false
        predicates.never
      ])
    ])
    | optional,
  deny_rule_groups
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
          deny_rules = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    content_type = definitions.predicate.PatternDto-nullable,
                    header_name = definitions.predicate.PatternDto-nullable,
                    header_value = definitions.predicate.PatternDto-nullable,
                    method = definitions.predicate.PatternDto-nullable,
                    name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(?![ \\t\\n]*\\(default(.*)\\))[\\s\\S]*"
                        ],
                    parameter_name = definitions.predicate.PatternDto-nullable,
                    parameter_value = definitions.predicate.PatternDto-nullable,
                    path = definitions.predicate.PatternDto-nullable,
                    rule_key = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(?![ \\t\\n]*\\(default(.*)\\))[\\s\\S]*"
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          name = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(?![ \\t\\n]*\\(default(.*)\\))[\\s\\S]*"
              ],
          rule_group_key = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(?![ \\t\\n]*\\(default(.*)\\))[\\s\\S]*"
              ],
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Custom deny rule groups that can be referenced in mappings on top of the built in Airlock deny rules.
    "%
    | optional,
  expert_settings | definitions.contract.ExpertSettingsDto-nullable | optional,
  jwks_providers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType 'Record, predicates.isType 'Null ],
      predicates.records.record
      {
        local = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  issuer = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  jwks = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  jwks_file = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ])
            ],
        refresh_interval = predicates.isType 'Integer,
        remote = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "service_url" ],
                predicates.records.record
                {
                  issuer = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  name = predicates.isType '"String",
                  service_url = predicates.isType '"String",
                  tls = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          cipher_suite = predicates.isType '"String",
                          client = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Record,
                                  predicates.isType 'Null
                                ],
                                predicates.records.record
                                {
                                  ca_chain = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  ca_chain_file = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  certificate = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  certificate_file = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  privatekey = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  privatekey_file = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          force_new_session = predicates.isType '"Bool",
                          protocol = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "DEFAULT",
                                  "TLSv1_0",
                                  "TLSv1_1",
                                  "TLSv1_2",
                                  "TLSv1_3"
                                ]
                              ],
                          server = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Record,
                                  predicates.isType 'Null
                                ],
                                predicates.records.record
                                {
                                  ca_validation = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  ca_validation_file = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  host_name_verification = predicates.isType
                                      '"Bool",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never
              ])
            ],
      }
      {  }
      false
      predicates.never
    ])
    | doc m%"
    JWKS Providers which can be referenced in apps[].mappings[].access_token.
    "%
    | optional,
  license
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ])
    | doc m%"
    The encoded license.
    "%
    | optional,
  license_file
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"String", predicates.isType 'Null ])
    | doc m%"
    The license file path.
    "%
    | optional,
  log
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType 'Record, predicates.isType 'Null ],
      predicates.records.record
      {
        level = predicates.allOf
            [
              predicates.isType '"String",
              predicates.enum [ "info", "trace" ]
            ],
      }
      {  }
      false
      predicates.never
    ])
    | optional,
  metrics
    | {
      statsd
        | {
          enabled
            | Bool
            | doc m%"
            Enable sending of statsd metrics. Default is 'true'
            "%
            | optional,
        }
        | doc m%"
        Use this to enable sending metrics using the statsd protocol.
        "%
        | optional,
    }
    | doc m%"
    Configuration for metrics sending.
    "%
    | optional,
  remote_ip
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType 'Record, predicates.isType 'Null ],
      predicates.records.required [ "header", "internal_proxies" ],
      predicates.records.record
      {
        header = predicates.isType '"String",
        internal_proxies = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ],
      }
      {  }
      false
      predicates.never
    ])
    | optional,
  session
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf [ predicates.isType 'Record, predicates.isType 'Null ],
      predicates.records.record
      {
        encryption_passphrase = predicates.anyOf
            [ predicates.isType '"String", predicates.isType 'Null ],
        encryption_passphrase_file = predicates.anyOf
            [ predicates.isType '"String", predicates.isType 'Null ],
        idle_timeout = predicates.isType 'Integer,
        lifetime = predicates.isType 'Integer,
        redis_hosts = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ],
        store_mode = predicates.allOf
            [
              predicates.isType '"String",
              predicates.enum [ "server", "cluster", "disabled" ]
            ],
      }
      {  }
      false
      predicates.never
    ])
    | optional,
}