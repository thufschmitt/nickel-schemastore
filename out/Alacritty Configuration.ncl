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
          "Alacritty.Bell"
            | doc m%"
            The bell is rung every time the BEL control character is received.
            "%
            = {
                animation
                  | std.enum.TagOrString
                  | [|
                    'Linear,
                    'EaseOutCirc,
                    'EaseOutExpo,
                    'EaseOutQuint,
                    'EaseOutQuart,
                    'EaseOutCubic,
                    'EaseOutQuad,
                    'EaseOutSine,
                    'EaseOut,
                    'Ease
                  |]
                  | doc m%"
                  Animation effect for flashing the screen when the visual bell is rung.
                  "%
                  | optional,
                color
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.maxLength 7,
                    predicates.strings.minLength 7
                  ])
                  | doc m%"
                  Visual bell animation color.
                  "%
                  | optional,
                command | definitions.contract."Alacritty.Command" | optional,
                duration
                  | std.number.Integer
                  | doc m%"
                  Duration of the visual bell flash in milliseconds. A `duration` of `0` will
                   disable the visual bell animation.
                  "%
                  | optional,
              },
          "Alacritty.Command" = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                program | String | optional,
              },
          "Alacritty.Cursor" = {
                blink_interval
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  Cursor blinking interval in milliseconds.
                  "%
                  | optional,
                blink_timeout
                  | std.number.Integer
                  | doc m%"
                  Time after which cursor stops blinking in seconds. 
                  
                   Specifying '0' will disable timeout for blinking
                  "%
                  | optional,
                style
                  | definitions.contract."Alacritty.Cursor.Style"
                  | optional,
                thickness
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Thickness of the cursor relative to the cell width as floating point number from `0.0` to `1.0`.
                  "%
                  | optional,
                unfocused_hollow
                  | Bool
                  | doc m%"
                  If this is `true`, the cursor will be rendered as a hollow box when the window is not focused.
                  "%
                  | optional,
                vi_mode_style
                  | definitions.contract."Alacritty.Cursor.Style"
                  | doc m%"
                  
                  Vi mode cursor style
                   If the vi mode cursor style is `None` or not specified, it will fall back to
                   the style of the active value of the normal cursor.
                  "%
                  | optional,
              },
          "Alacritty.Cursor.Style"
            | doc m%"
            Cursor Style
            "%
            = {
                blinking
                  | std.enum.TagOrString
                  | [| 'Always, 'On, 'Off, 'Never |]
                  | doc m%"
                  # Cursor blinking state
                  
                   Values for `blinking`:
                     - Never: Prevent the cursor from ever blinking
                     - Off: Disable blinking by default
                     - On: Enable blinking by default
                     - Always: Force the cursor to always blink
                  "%
                  | optional,
                shape
                  | std.enum.TagOrString
                  | [| 'Underline, 'Beam, 'Block |]
                  | doc m%"
                  Cursor shape
                  
                   Values for `shape`:
                     - ▇ Block
                     - _ Underline
                     - | Beam
                  "%
                  | optional,
              },
          "Alacritty.Debug" = {
                highlight_damage
                  | Bool
                  | doc m%"
                  Highlight window damage information.
                  "%
                  | optional,
                log_level
                  | std.enum.TagOrString
                  | [| 'Trace, 'Debug, 'Info, 'Warn, 'Error, 'Off |]
                  | optional,
                persistent_logging
                  | Bool
                  | doc m%"
                  Keep the log file after quitting Alacritty.
                  "%
                  | optional,
                print_events
                  | Bool
                  | doc m%"
                  Print all received window events.
                  "%
                  | optional,
                render_timer
                  | Bool
                  | doc m%"
                  Display the time it takes to redraw each frame.
                  "%
                  | optional,
              },
          "Alacritty.Font" = {
                bold
                  | {
                    family
                      | String
                      | doc m%"
                      If the bold family is not specified, it will fall back to the
                       value specified for the normal font.
                      "%
                      | optional,
                    style
                      | String
                      | doc m%"
                      The `style` can be specified to pick a specific face.
                      "%
                      | optional,
                    ..
                  }
                  | optional,
                bold_italic
                  | {
                    family
                      | String
                      | doc m%"
                      If the bold_italic family is not specified, it will fall back to the
                       value specified for the normal font.
                      "%
                      | optional,
                    style
                      | String
                      | doc m%"
                      The `style` can be specified to pick a specific face.
                      "%
                      | optional,
                    ..
                  }
                  | optional,
                builtin_box_drawing
                  | Bool
                  | doc m%"
                  Use built-in font for box drawing characters.
                  
                   If `true`, Alacritty will use a custom built-in font for box drawing
                   characters (Unicode points 2500 - 259f).
                  "%
                  | optional,
                draw_bold_text_with_bright_colors
                  | Bool
                  | doc m%"
                  If `true`, bold text is drawn using the bright color variants.
                  "%
                  | optional,
                glyph_offset
                  | { x | Number | optional, y | Number | optional, }
                  | doc m%"
                  Glyph offset determines the locations of the glyphs within their cells with
                   the default being at the bottom. Increasing `x` moves the glyph to the
                   right, increasing `y` moves the glyph upward.
                  "%
                  | optional,
                italic
                  | {
                    family
                      | String
                      | doc m%"
                      If the italic family is not specified, it will fall back to the
                       value specified for the normal font.
                      "%
                      | optional,
                    style
                      | String
                      | doc m%"
                      The `style` can be specified to pick a specific face.
                      "%
                      | optional,
                    ..
                  }
                  | optional,
                normal
                  | {
                    family
                      | String
                      | doc m%"
                      Font family
                      
                       Default:
                         - (macOS) Menlo
                         - (Linux/BSD) monospace
                         - (Windows) Consolas
                      "%
                      | optional,
                    style
                      | String
                      | doc m%"
                      The `style` can be specified to pick a specific face.
                      "%
                      | optional,
                    ..
                  }
                  | optional,
                offset
                  | { x | Number | optional, y | Number | optional, }
                  | doc m%"
                  Offset is the extra space around each character. `offset.y` can be thought
                   of as modifying the line spacing, and `offset.x` as modifying the letter
                   spacing.
                  "%
                  | optional,
                size
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Point size
                  "%
                  | optional,
              },
          "Alacritty.KeyBindings"
            | doc m%"
            Key bindings are specified as a list of objects. For example, this is the default paste binding:
             `- { key: V, mods: Control|Shift, action: Paste }`
            "%
            = {
                action
                  | definitions.contract."Alacritty.KeyBindings.Action"
                  | optional,
                chars
                  | definitions.contract."Alacritty.KeyBindings.Chars"
                  | optional,
                command | definitions.contract."Alacritty.Command" | optional,
                key
                  | definitions.contract."Alacritty.KeyBindings.Key"
                  | optional,
                mode | definitions.contract."Alacritty.Mode" | optional,
                mods
                  | String
                  | doc m%"
                  Key modifiers to filter binding actions
                  
                      - Command
                      - Control
                      - Option
                      - Super
                      - Shift
                      - Alt
                      Multiple `mods` can be combined using `|` like this:
                         `mods: Control|Shift`.
                      Whitespace and capitalization are relevant and must match the example.
                  "%
                  | optional,
              },
          "Alacritty.KeyBindings.Action"
            | doc m%"
            Execute a predefined action
               - ToggleViMode
               - SearchForward
                   Start searching toward the right of the search origin.
               - SearchBackward
                   Start searching toward the left of the search origin.
               - Copy
               - Paste
               - IncreaseFontSize
               - DecreaseFontSize
               - ResetFontSize
               - ScrollPageUp
               - ScrollPageDown
               - ScrollHalfPageUp
               - ScrollHalfPageDown
               - ScrollLineUp
               - ScrollLineDown
               - ScrollToTop
               - ScrollToBottom
               - ClearHistory
                   Remove the terminal's scrollback history.
               - Hide
                   Hide the Alacritty window.
               - Minimize
                   Minimize the Alacritty window.
               - Quit
                   Quit Alacritty.
               - ToggleFullscreen
               - SpawnNewInstance
                   Spawn a new instance of Alacritty.
               - CreateNewWindow
                   Create a new Alacritty window from the current process.
               - ClearLogNotice
                   Clear Alacritty's UI warning and error notice.
               - ClearSelection
                   Remove the active selection.
               - ReceiveChar
               - None
             - Vi mode exclusive actions:
               - Open
                   Perform the action of the first matching hint under the vi mode cursor
                   with `mouse.enabled` set to `true`.
               - ToggleNormalSelection
               - ToggleLineSelection
               - ToggleBlockSelection
               - ToggleSemanticSelection
                   Toggle semantic selection based on `selection.semantic_escape_chars`.
               - CenterAroundViCursor
                   Center view around vi mode cursor
             - Vi mode exclusive cursor motion actions:
               - Up
                   One line up.
               - Down
                   One line down.
               - Left
                   One character left.
               - Right
                   One character right.
               - First
                   First column, or beginning of the line when already at the first column.
               - Last
                   Last column, or beginning of the line when already at the last column.
               - FirstOccupied
                   First non-empty cell in this terminal row, or first non-empty cell of
                   the line when already at the first cell of the row.
               - High
                   Top of the screen.
               - Middle
                   Center of the screen.
               - Low
                   Bottom of the screen.
               - SemanticLeft
                   Start of the previous semantically separated word.
               - SemanticRight
                   Start of the next semantically separated word.
               - SemanticLeftEnd
                   End of the previous semantically separated word.
               - SemanticRightEnd
                   End of the next semantically separated word.
               - WordLeft
                   Start of the previous whitespace separated word.
               - WordRight
                   Start of the next whitespace separated word.
               - WordLeftEnd
                   End of the previous whitespace separated word.
               - WordRightEnd
                   End of the next whitespace separated word.
               - Bracket
                   Character matching the bracket at the cursor's location.
               - SearchNext
                   Beginning of the next match.
               - SearchPrevious
                   Beginning of the previous match.
               - SearchStart
                   Start of the match to the left of the vi mode cursor.
               - SearchEnd
                   End of the match to the right of the vi mode cursor.
             - Search mode exclusive actions:
               - SearchFocusNext
                   Move the focus to the next search match.
               - SearchFocusPrevious
                   Move the focus to the previous search match.
               - SearchConfirm
               - SearchCancel
               - SearchClear
                   Reset the search regex.
               - SearchDeleteWord
                   Delete the last word in the search regex.
               - SearchHistoryPrevious
                   Go to the previous regex in the search history.
               - SearchHistoryNext
                   Go to the next regex in the search history.
             - macOS exclusive actions:
               - ToggleSimpleFullscreen
                   Enter fullscreen without occupying another space.
             - Linux/BSD exclusive actions:
               - CopySelection
                   Copy from the selection buffer.
               - PasteSelection
                   Paste from the selection buffer.
             
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'PasteSelection,
                  'CopySelection,
                  'ToggleSimpleFullscreen,
                  'SearchHistoryNext,
                  'SearchHistoryPrevious,
                  'SearchDeleteWord,
                  'SearchClear,
                  'SearchCancel,
                  'SearchConfirm,
                  'SearchFocusPrevious,
                  'SearchFocusNext,
                  'SearchEnd,
                  'SearchStart,
                  'SearchPrevious,
                  'SearchNext,
                  'Bracket,
                  'WordRightEnd,
                  'WordLeftEnd,
                  'WordRight,
                  'WordLeft,
                  'SemanticRightEnd,
                  'SemanticLeftEnd,
                  'SemanticRight,
                  'SemanticLeft,
                  'Low,
                  'Middle,
                  'High,
                  'FirstOccupied,
                  'Last,
                  'First,
                  'Right,
                  'Left,
                  'Down,
                  'Up,
                  'CenterAroundViCursor,
                  'ToggleSemanticSelection,
                  'ToggleBlockSelection,
                  'ToggleLineSelection,
                  'ToggleNormalSelection,
                  'Open,
                  'None,
                  'ReceiveChar,
                  'ClearSelection,
                  'ClearLogNotice,
                  'CreateNewWindow,
                  'SpawnNewInstance,
                  'ToggleFullscreen,
                  'Quit,
                  'Minimize,
                  'Hide,
                  'ClearHistory,
                  'ScrollToBottom,
                  'ScrollToTop,
                  'ScrollLineDown,
                  'ScrollLineUp,
                  'ScrollHalfPageDown,
                  'ScrollHalfPageUp,
                  'ScrollPageDown,
                  'ScrollPageUp,
                  'ResetFontSize,
                  'DecreaseFontSize,
                  'IncreaseFontSize,
                  'Paste,
                  'Copy,
                  'SearchBackward,
                  'SearchForward,
                  'ToggleViMode
                |]
              ],
          "Alacritty.KeyBindings.Chars"
            | doc m%"
            The `chars` field writes the specified string to the terminal. This makes
                it possible to pass escape sequences. To find escape codes for bindings
                like `PageUp` (`"\x1b[5~"`), you can run the command `showkey -a` outside
                of tmux. Note that applications use terminfo to map escape sequences back
                to keys. It is therefore required to update the terminfo when changing an
                escape sequence.
            "%
            = String,
          "Alacritty.KeyBindings.Key"
            | doc m%"
            Identifier of the key pressed.
            
             - A-Z
             - F1-F24
             - Key0-Key9
            
             A full list with available key codes can be found here:
             https://docs.rs/glutin/*/glutin/event/enum.VirtualKeyCode.html#variants
            
             Instead of using the name of the keys, the `key` field also supports using the scancode of the desired key. Scancodes have to be specified as a decimal number. This command will allow you to display the hex scancodes for certain keys:
            
                `showkey --scancodes`.
            "%
            = String,
          "Alacritty.Mode" = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  '"~Vi",
                  '"~Alt",
                  '"~Search",
                  '"~AppKeypad",
                  '"~AppCursor",
                  'Vi,
                  'Alt,
                  'Search,
                  'AppKeypad,
                  'AppCursor
                |]
              ],
          "Alacritty.MouseBinding" = {
                action | String,
                mouse | std.enum.TagOrString | [| 'Right, 'Middle, 'Left |],
              },
          "Alacritty.Selection" = {
                save_to_clipboard
                  | Bool
                  | doc m%"
                  When set to `true`, selected text will be copied to the primary clipboard.
                  "%
                  | optional,
                semantic_escape_chars
                  | String
                  | doc m%"
                  This string contains all characters that are used as separators for "semantic words" in Alacritty.
                  "%
                  | optional,
              },
          "Alacritty.Window" = {
                class
                  | {
                    general | String | optional,
                    instance | String | optional,
                    ..
                  }
                  | doc m%"
                  Window class (Linux/BSD only):
                  "%
                  | optional,
                decorations
                  | std.enum.TagOrString
                  | [| 'buttonless, 'transparent, 'none, 'full |]
                  | doc m%"
                  Values for `decorations`: 
                       - full: Borders and title bar 
                       - none: Neither borders nor title bar 
                  
                   Values for `decorations` (macOS only):
                       - transparent: Title bar, transparent background and title bar buttons
                       - buttonless: Title bar, transparent background and no title bar buttons
                  "%
                  | optional,
                decorations_theme_variant
                  | String
                  | doc m%"
                  Decorations theme variant (Linux/BSD only)
                  
                  Override the variant of the GTK theme/Wayland client side decorations.
                   Commonly supported values are `dark` and `light`. Set this to `None` to use
                   the default theme variant.
                  "%
                  | optional,
                dimensions
                  | {
                    columns
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 2
                      ])
                      | optional,
                    lines
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ])
                      | optional,
                  }
                  | doc m%"
                  Window dimensions (changes require restart). 
                   Number of lines/columns (not pixels) in the terminal. Both lines and columns
                   must be non-zero for this to take effect. The number of columns must be at
                   least `2`, while using a value of `0` for columns and lines will fall back
                   to the window manager's recommended size
                  "%
                  | optional,
                dynamic_padding
                  | Bool
                  | doc m%"
                  Spread additional padding evenly around the terminal content.
                  "%
                  | optional,
                dynamic_title
                  | Bool
                  | doc m%"
                  Allow terminal applications to change Alacritty's window title.
                  "%
                  | optional,
                opacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Background opacity
                  
                   Window opacity as a floating point number from `0.0` to `1.0`.
                   The value `0.0` is completely transparent and `1.0` is opaque.
                  "%
                  | optional,
                padding
                  | { x | Number | optional, y | Number | optional, }
                  | doc m%"
                  # Window padding (changes require restart)
                  
                   Blank space added around the window in pixels. This padding is scaled
                   by DPI and the specified value is always added at both opposing sides.
                  "%
                  | optional,
                position
                  | { x | Number | optional, y | Number | optional, }
                  | doc m%"
                  Window position (changes require restart)
                  Specified in number of pixels.
                  If the position is not set, the window manager will handle the placement.
                  "%
                  | optional,
                scrolling
                  | {
                    history
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ])
                      | doc m%"
                      Maximum number of lines in the scrollback buffer.
                       Specifying '0' will disable scrolling.
                      "%
                      | optional,
                    multiplier
                      | std.number.Integer
                      | doc m%"
                      Scrolling distance multiplier.
                      "%
                      | optional,
                  }
                  | optional,
                startup_mode
                  | std.enum.TagOrString
                  | [| 'SimpleFullscreen, 'Fullscreen, 'Maximized, 'Windowed |]
                  | doc m%"
                    # Startup Mode (changes require restart)
                  
                   Values for `startup_mode`:
                     - Windowed
                     - Maximized
                     - Fullscreen
                  
                   Values for `startup_mode` (macOS only):
                     - SimpleFullscreen
                  "%
                  | optional,
                title
                  | String
                  | doc m%"
                  Window Title
                  "%
                  | optional,
              },
        },
    predicate = {
          "Alacritty.Bell"
            | doc m%"
            The bell is rung every time the BEL control character is received.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  animation = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Ease",
                          "EaseOut",
                          "EaseOutSine",
                          "EaseOutQuad",
                          "EaseOutCubic",
                          "EaseOutQuart",
                          "EaseOutQuint",
                          "EaseOutExpo",
                          "EaseOutCirc",
                          "Linear"
                        ]
                      ],
                  color = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.maxLength 7,
                        predicates.strings.minLength 7
                      ],
                  command = definitions.predicate."Alacritty.Command",
                  duration = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          "Alacritty.Command" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  program = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          "Alacritty.Cursor" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  blink_interval = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  blink_timeout = predicates.isType 'Integer,
                  style = definitions.predicate."Alacritty.Cursor.Style",
                  thickness = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  unfocused_hollow = predicates.isType '"Bool",
                  vi_mode_style =
                    definitions.predicate."Alacritty.Cursor.Style",
                }
                {  }
                false
                predicates.never
              ],
          "Alacritty.Cursor.Style"
            | doc m%"
            Cursor Style
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  blinking = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Never", "Off", "On", "Always" ]
                      ],
                  shape = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Block", "Beam", "Underline" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "Alacritty.Debug" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  highlight_damage = predicates.isType '"Bool",
                  log_level = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "Off", "Error", "Warn", "Info", "Debug", "Trace" ]
                      ],
                  persistent_logging = predicates.isType '"Bool",
                  print_events = predicates.isType '"Bool",
                  render_timer = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          "Alacritty.Font" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bold = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          family = predicates.isType '"String",
                          style = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  bold_italic = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          family = predicates.isType '"String",
                          style = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  builtin_box_drawing = predicates.isType '"Bool",
                  draw_bold_text_with_bright_colors = predicates.isType '"Bool",
                  glyph_offset = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          x = predicates.isType '"Number",
                          y = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  italic = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          family = predicates.isType '"String",
                          style = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  normal = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          family = predicates.isType '"String",
                          style = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  offset = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          x = predicates.isType '"Number",
                          y = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  size = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "Alacritty.KeyBindings"
            | doc m%"
            Key bindings are specified as a list of objects. For example, this is the default paste binding:
             `- { key: V, mods: Control|Shift, action: Paste }`
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  action = definitions.predicate."Alacritty.KeyBindings.Action",
                  chars = definitions.predicate."Alacritty.KeyBindings.Chars",
                  command = definitions.predicate."Alacritty.Command",
                  key = definitions.predicate."Alacritty.KeyBindings.Key",
                  mode = definitions.predicate."Alacritty.Mode",
                  mods = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          "Alacritty.KeyBindings.Action"
            | doc m%"
            Execute a predefined action
               - ToggleViMode
               - SearchForward
                   Start searching toward the right of the search origin.
               - SearchBackward
                   Start searching toward the left of the search origin.
               - Copy
               - Paste
               - IncreaseFontSize
               - DecreaseFontSize
               - ResetFontSize
               - ScrollPageUp
               - ScrollPageDown
               - ScrollHalfPageUp
               - ScrollHalfPageDown
               - ScrollLineUp
               - ScrollLineDown
               - ScrollToTop
               - ScrollToBottom
               - ClearHistory
                   Remove the terminal's scrollback history.
               - Hide
                   Hide the Alacritty window.
               - Minimize
                   Minimize the Alacritty window.
               - Quit
                   Quit Alacritty.
               - ToggleFullscreen
               - SpawnNewInstance
                   Spawn a new instance of Alacritty.
               - CreateNewWindow
                   Create a new Alacritty window from the current process.
               - ClearLogNotice
                   Clear Alacritty's UI warning and error notice.
               - ClearSelection
                   Remove the active selection.
               - ReceiveChar
               - None
             - Vi mode exclusive actions:
               - Open
                   Perform the action of the first matching hint under the vi mode cursor
                   with `mouse.enabled` set to `true`.
               - ToggleNormalSelection
               - ToggleLineSelection
               - ToggleBlockSelection
               - ToggleSemanticSelection
                   Toggle semantic selection based on `selection.semantic_escape_chars`.
               - CenterAroundViCursor
                   Center view around vi mode cursor
             - Vi mode exclusive cursor motion actions:
               - Up
                   One line up.
               - Down
                   One line down.
               - Left
                   One character left.
               - Right
                   One character right.
               - First
                   First column, or beginning of the line when already at the first column.
               - Last
                   Last column, or beginning of the line when already at the last column.
               - FirstOccupied
                   First non-empty cell in this terminal row, or first non-empty cell of
                   the line when already at the first cell of the row.
               - High
                   Top of the screen.
               - Middle
                   Center of the screen.
               - Low
                   Bottom of the screen.
               - SemanticLeft
                   Start of the previous semantically separated word.
               - SemanticRight
                   Start of the next semantically separated word.
               - SemanticLeftEnd
                   End of the previous semantically separated word.
               - SemanticRightEnd
                   End of the next semantically separated word.
               - WordLeft
                   Start of the previous whitespace separated word.
               - WordRight
                   Start of the next whitespace separated word.
               - WordLeftEnd
                   End of the previous whitespace separated word.
               - WordRightEnd
                   End of the next whitespace separated word.
               - Bracket
                   Character matching the bracket at the cursor's location.
               - SearchNext
                   Beginning of the next match.
               - SearchPrevious
                   Beginning of the previous match.
               - SearchStart
                   Start of the match to the left of the vi mode cursor.
               - SearchEnd
                   End of the match to the right of the vi mode cursor.
             - Search mode exclusive actions:
               - SearchFocusNext
                   Move the focus to the next search match.
               - SearchFocusPrevious
                   Move the focus to the previous search match.
               - SearchConfirm
               - SearchCancel
               - SearchClear
                   Reset the search regex.
               - SearchDeleteWord
                   Delete the last word in the search regex.
               - SearchHistoryPrevious
                   Go to the previous regex in the search history.
               - SearchHistoryNext
                   Go to the next regex in the search history.
             - macOS exclusive actions:
               - ToggleSimpleFullscreen
                   Enter fullscreen without occupying another space.
             - Linux/BSD exclusive actions:
               - CopySelection
                   Copy from the selection buffer.
               - PasteSelection
                   Paste from the selection buffer.
             
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "ToggleViMode",
                  "SearchForward",
                  "SearchBackward",
                  "Copy",
                  "Paste",
                  "IncreaseFontSize",
                  "DecreaseFontSize",
                  "ResetFontSize",
                  "ScrollPageUp",
                  "ScrollPageDown",
                  "ScrollHalfPageUp",
                  "ScrollHalfPageDown",
                  "ScrollLineUp",
                  "ScrollLineDown",
                  "ScrollToTop",
                  "ScrollToBottom",
                  "ClearHistory",
                  "Hide",
                  "Minimize",
                  "Quit",
                  "ToggleFullscreen",
                  "SpawnNewInstance",
                  "CreateNewWindow",
                  "ClearLogNotice",
                  "ClearSelection",
                  "ReceiveChar",
                  "None",
                  "Open",
                  "ToggleNormalSelection",
                  "ToggleLineSelection",
                  "ToggleBlockSelection",
                  "ToggleSemanticSelection",
                  "CenterAroundViCursor",
                  "Up",
                  "Down",
                  "Left",
                  "Right",
                  "First",
                  "Last",
                  "FirstOccupied",
                  "High",
                  "Middle",
                  "Low",
                  "SemanticLeft",
                  "SemanticRight",
                  "SemanticLeftEnd",
                  "SemanticRightEnd",
                  "WordLeft",
                  "WordRight",
                  "WordLeftEnd",
                  "WordRightEnd",
                  "Bracket",
                  "SearchNext",
                  "SearchPrevious",
                  "SearchStart",
                  "SearchEnd",
                  "SearchFocusNext",
                  "SearchFocusPrevious",
                  "SearchConfirm",
                  "SearchCancel",
                  "SearchClear",
                  "SearchDeleteWord",
                  "SearchHistoryPrevious",
                  "SearchHistoryNext",
                  "ToggleSimpleFullscreen",
                  "CopySelection",
                  "PasteSelection"
                ]
              ],
          "Alacritty.KeyBindings.Chars"
            | doc m%"
            The `chars` field writes the specified string to the terminal. This makes
                it possible to pass escape sequences. To find escape codes for bindings
                like `PageUp` (`"\x1b[5~"`), you can run the command `showkey -a` outside
                of tmux. Note that applications use terminfo to map escape sequences back
                to keys. It is therefore required to update the terminfo when changing an
                escape sequence.
            "%
            = predicates.isType '"String",
          "Alacritty.KeyBindings.Key"
            | doc m%"
            Identifier of the key pressed.
            
             - A-Z
             - F1-F24
             - Key0-Key9
            
             A full list with available key codes can be found here:
             https://docs.rs/glutin/*/glutin/event/enum.VirtualKeyCode.html#variants
            
             Instead of using the name of the keys, the `key` field also supports using the scancode of the desired key. Scancodes have to be specified as a decimal number. This command will allow you to display the hex scancodes for certain keys:
            
                `showkey --scancodes`.
            "%
            = predicates.isType '"String",
          "Alacritty.Mode" = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "AppCursor",
                  "AppKeypad",
                  "Search",
                  "Alt",
                  "Vi",
                  "~AppCursor",
                  "~AppKeypad",
                  "~Search",
                  "~Alt",
                  "~Vi"
                ]
              ],
          "Alacritty.MouseBinding" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "action", "mouse" ],
                predicates.records.record
                {
                  action = predicates.isType '"String",
                  mouse = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Left", "Middle", "Right" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "Alacritty.Selection" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  save_to_clipboard = predicates.isType '"Bool",
                  semantic_escape_chars = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          "Alacritty.Window" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  class = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          general = predicates.isType '"String",
                          instance = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  decorations = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "full", "none", "transparent", "buttonless" ]
                      ],
                  decorations_theme_variant = predicates.isType '"String",
                  dimensions = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          columns = predicates.allOf
                              [
                                predicates.isType '"Number",
                                predicates.numbers.minimum 2
                              ],
                          lines = predicates.allOf
                              [
                                predicates.isType '"Number",
                                predicates.numbers.minimum 0
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  dynamic_padding = predicates.isType '"Bool",
                  dynamic_title = predicates.isType '"Bool",
                  opacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  padding = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          x = predicates.isType '"Number",
                          y = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  position = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          x = predicates.isType '"Number",
                          y = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  scrolling = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          history = predicates.allOf
                              [
                                predicates.isType 'Integer,
                                predicates.numbers.minimum 0
                              ],
                          multiplier = predicates.isType 'Integer,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  startup_mode = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Windowed",
                          "Maximized",
                          "Fullscreen",
                          "SimpleFullscreen"
                        ]
                      ],
                  title = predicates.isType '"String",
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
  predicates.isType 'Record,
  predicates.records.record
  {
    alt_send_esc = predicates.isType '"Bool",
    bell = definitions.predicate."Alacritty.Bell",
    cursor = definitions.predicate."Alacritty.Cursor",
    debug = definitions.predicate."Alacritty.Debug",
    env = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true predicates.always
        ],
    font = definitions.predicate."Alacritty.Font",
    "import" = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    ipc_socket = predicates.isType '"Bool",
    key_bindings = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          definitions.predicate."Alacritty.KeyBindings"
        ],
    live_config_reload = predicates.isType '"Bool",
    mouse_bindings = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          definitions.predicate."Alacritty.MouseBinding"
        ],
    selection = definitions.predicate."Alacritty.Selection",
    window = definitions.predicate."Alacritty.Window",
    working_directory = predicates.isType '"String",
  }
  {  }
  true
  predicates.always
])