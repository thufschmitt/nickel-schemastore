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
          AcceleratorOption = predicates.contract_from_predicate
              definitions.predicate.AcceleratorOption,
          Chain-1 = {
                applyTo
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^$|^[^/].*$"
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  The path patterns used to filter which files to apply the Transforms to
                  "%
                  | optional,
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                transformations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.Loop-2,
                      definitions.predicate.Chain-2,
                      definitions.predicate.Provenance-2,
                      definitions.predicate.Exclude-2,
                      definitions.predicate.Include-2,
                      definitions.predicate.Combo-2,
                      definitions.predicate.ReplaceText-2,
                      definitions.predicate.InvokeFragment-2,
                      definitions.predicate.Merge-2,
                      definitions.predicate.OpenRewriteRecipe-2,
                      definitions.predicate.RewritePath-2,
                      definitions.predicate.UniquePath-2,
                      definitions.predicate.YTT-2,
                      definitions.predicate.Let-2,
                      definitions.predicate.UseEncoding-2,
                      definitions.predicate.InvokeFragment-2
                    ])
                  ])
                  | doc m%"
                  A list of child Transforms to apply sequentially
                  "%
                  | optional,
                ..
              },
          Chain-2 = predicates.contract_from_predicate
              definitions.predicate.Chain-2,
          Combo-1 = {
                applyTo
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^$|^[^/].*$"
                    ]),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  The path patterns used to filter which files to apply the Transforms to
                  "%
                  | optional,
                chain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.Loop-2,
                      definitions.predicate.Chain-2,
                      definitions.predicate.Provenance-2,
                      definitions.predicate.Exclude-2,
                      definitions.predicate.Include-2,
                      definitions.predicate.Combo-2,
                      definitions.predicate.ReplaceText-2,
                      definitions.predicate.InvokeFragment-2,
                      definitions.predicate.Merge-2,
                      definitions.predicate.OpenRewriteRecipe-2,
                      definitions.predicate.RewritePath-2,
                      definitions.predicate.UniquePath-2,
                      definitions.predicate.YTT-2,
                      definitions.predicate.Let-2,
                      definitions.predicate.UseEncoding-2,
                      definitions.predicate.InvokeFragment-2
                    ])
                  ])
                  | doc m%"
                  A list of child Transforms to apply sequentially
                  "%
                  | optional,
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                exclude
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^$|^[^/].*$"
                    ])
                  ])
                  | doc m%"
                  The path patterns used to filter which files to exclude
                  "%
                  | optional,
                include
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^$|^[^/].*$"
                    ])
                  ])
                  | doc m%"
                  The path patterns used to filter which files to include
                  "%
                  | optional,
                "let"
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [ definitions.predicate.DerivedSymbol, predicates.always ])
                  ])
                  | doc m%"
                  A list of additional variables and their values
                  "%
                  | optional,
                "merge"
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.Loop-2,
                      definitions.predicate.Chain-2,
                      definitions.predicate.Provenance-2,
                      definitions.predicate.Exclude-2,
                      definitions.predicate.Include-2,
                      definitions.predicate.Combo-2,
                      definitions.predicate.ReplaceText-2,
                      definitions.predicate.InvokeFragment-2,
                      definitions.predicate.Merge-2,
                      definitions.predicate.OpenRewriteRecipe-2,
                      definitions.predicate.RewritePath-2,
                      definitions.predicate.UniquePath-2,
                      definitions.predicate.YTT-2,
                      definitions.predicate.Let-2,
                      definitions.predicate.UseEncoding-2,
                      definitions.predicate.InvokeFragment-2
                    ])
                  ])
                  | doc m%"
                  A list of child Transforms to be executed in parallel
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                onConflict
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.ConflictResolution,
                    predicates.always
                  ])
                  | optional,
                ..
              },
          Combo-2 = predicates.contract_from_predicate
              definitions.predicate.Combo-2,
          ConflictResolution = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'NWayDiff,
                  'FavorForeign,
                  'FavorOwn,
                  'Append,
                  'UseLast,
                  'UseFirst,
                  'Fail
                |]
              ],
          DependsOn = {
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1,
                    predicates.strings.pattern "^$|^[a-z][a-z0-9A-Z]*$"
                  ])
                  | doc m%"
                  The options name
                  "%
                  | optional,
                value
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  The desired options value to compare against
                  "%
                  | optional,
                ..
              },
          DerivedSymbol = {
                expression
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1,
                    predicates.strings.pattern "^$|^[a-z][a-z0-9A-Z]*$"
                  ])
                  | doc m%"
                  The name under which the new symbol will be added
                  "%
                  | optional,
                ..
              },
          Exclude-1 = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                patterns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^$|^[^/].*$"
                    ])
                  ])
                  | doc m%"
                  The path patterns used to filter which files to exclude
                  "%
                  | optional,
                ..
              },
          Exclude-2 = predicates.contract_from_predicate
              definitions.predicate.Exclude-2,
          Expression = String,
          Include-1 = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                patterns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1,
                      predicates.strings.pattern "^$|^[^/].*$"
                    ])
                  ])
                  | doc m%"
                  The path patterns used to filter which files to include
                  "%
                  | optional,
                ..
              },
          Include-2 = predicates.contract_from_predicate
              definitions.predicate.Include-2,
          InvokeFragment-1 = {
                anchor
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^$|^[^/]$|^[^/](.+)[^/]$"
                  ])
                  | optional,
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                "let"
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [ definitions.predicate.DerivedSymbol, predicates.always ])
                  ])
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                reference
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1,
                    predicates.strings.pattern "^[a-z0-9]([a-z0-9-]*[a-z0-9])?$"
                  ])
                  | optional,
                ..
              },
          InvokeFragment-2 = predicates.contract_from_predicate
              definitions.predicate.InvokeFragment-2,
          Let-1 = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                "in"
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Loop-2,
                    definitions.predicate.Chain-2,
                    definitions.predicate.Provenance-2,
                    definitions.predicate.Exclude-2,
                    definitions.predicate.Include-2,
                    definitions.predicate.Combo-2,
                    definitions.predicate.ReplaceText-2,
                    definitions.predicate.InvokeFragment-2,
                    definitions.predicate.Merge-2,
                    definitions.predicate.OpenRewriteRecipe-2,
                    definitions.predicate.RewritePath-2,
                    definitions.predicate.UniquePath-2,
                    definitions.predicate.YTT-2,
                    definitions.predicate.Let-2,
                    definitions.predicate.UseEncoding-2,
                    definitions.predicate.InvokeFragment-2
                  ])
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                noShadow
                  | Bool
                  | doc m%"
                  Whether shadowing should be turned off
                  "%
                  | optional,
                symbols
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [ definitions.predicate.DerivedSymbol, predicates.always ])
                  ])
                  | doc m%"
                  A list of additional variables and their values
                  "%
                  | optional,
                ..
              },
          Let-2 = predicates.contract_from_predicate
              definitions.predicate.Let-2,
          Loop-1 = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                doAsChain
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Loop-2,
                    definitions.predicate.Chain-2,
                    definitions.predicate.Provenance-2,
                    definitions.predicate.Exclude-2,
                    definitions.predicate.Include-2,
                    definitions.predicate.Combo-2,
                    definitions.predicate.ReplaceText-2,
                    definitions.predicate.InvokeFragment-2,
                    definitions.predicate.Merge-2,
                    definitions.predicate.OpenRewriteRecipe-2,
                    definitions.predicate.RewritePath-2,
                    definitions.predicate.UniquePath-2,
                    definitions.predicate.YTT-2,
                    definitions.predicate.Let-2,
                    definitions.predicate.UseEncoding-2,
                    definitions.predicate.InvokeFragment-2
                  ])
                  | optional,
                doAsMerge
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Loop-2,
                    definitions.predicate.Chain-2,
                    definitions.predicate.Provenance-2,
                    definitions.predicate.Exclude-2,
                    definitions.predicate.Include-2,
                    definitions.predicate.Combo-2,
                    definitions.predicate.ReplaceText-2,
                    definitions.predicate.InvokeFragment-2,
                    definitions.predicate.Merge-2,
                    definitions.predicate.OpenRewriteRecipe-2,
                    definitions.predicate.RewritePath-2,
                    definitions.predicate.UniquePath-2,
                    definitions.predicate.YTT-2,
                    definitions.predicate.Let-2,
                    definitions.predicate.UseEncoding-2,
                    definitions.predicate.InvokeFragment-2
                  ])
                  | optional,
                index
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^$|^[a-z][a-z0-9A-Z]*$"
                  ])
                  | doc m%"
                  The variable's name to be assigned to the index of the current element on each iteration
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                on
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                var
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^$|^[a-z][a-z0-9A-Z]*$"
                  ])
                  | doc m%"
                  The name of the variable to be assigned to the current element on each iteration
                  "%
                  | optional,
                ..
              },
          Loop-2 = predicates.contract_from_predicate
              definitions.predicate.Loop-2,
          Merge-1 = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                sources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.Loop-2,
                      definitions.predicate.Chain-2,
                      definitions.predicate.Provenance-2,
                      definitions.predicate.Exclude-2,
                      definitions.predicate.Include-2,
                      definitions.predicate.Combo-2,
                      definitions.predicate.ReplaceText-2,
                      definitions.predicate.InvokeFragment-2,
                      definitions.predicate.Merge-2,
                      definitions.predicate.OpenRewriteRecipe-2,
                      definitions.predicate.RewritePath-2,
                      definitions.predicate.UniquePath-2,
                      definitions.predicate.YTT-2,
                      definitions.predicate.Let-2,
                      definitions.predicate.UseEncoding-2,
                      definitions.predicate.InvokeFragment-2
                    ])
                  ])
                  | doc m%"
                  A list of child Transforms to be executed in parallel
                  "%
                  | optional,
                ..
              },
          Merge-2 = predicates.contract_from_predicate
              definitions.predicate.Merge-2,
          OpenRewriteRecipe-1 = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Keys and values that depend on the class of the recipe
                  "%
                  | optional,
                parseOrFail | Bool | optional,
                recipe
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[a-zA-Z_$][a-zA-Z\\d_$]*(?:\\.[a-zA-Z_$][a-zA-Z\\d_$]*)*$"
                  ])
                  | doc m%"
                  Full qualified classname of the recipe
                  "%
                  | optional,
                ..
              },
          OpenRewriteRecipe-2 = predicates.contract_from_predicate
              definitions.predicate.OpenRewriteRecipe-2,
          Pattern = String,
          Provenance-1 = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                ..
              },
          Provenance-2 = predicates.contract_from_predicate
              definitions.predicate.Provenance-2,
          ReplaceText-1 = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                regex
                  | {
                    pattern
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [ definitions.predicate.Pattern, predicates.always ])
                      | optional,
                    with
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ])
                      | optional,
                    ..
                  }
                  | doc m%"
                  The replacement rule using a single regular expression
                  "%
                  | optional,
                substitutions
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
                        text = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.minLength 1
                            ],
                        with = predicates.allOf
                            [
                              definitions.predicate.Expression,
                              predicates.always
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ])
                  | doc m%"
                  The replacement rules using literal text tokens
                  "%
                  | optional,
                ..
              },
          ReplaceText-2 = predicates.contract_from_predicate
              definitions.predicate.ReplaceText-2,
          RewritePath-1 = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                matchOrFail
                  | Bool
                  | doc m%"
                  Whether an error should occur if the regex doesn't match
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                regex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Pattern, predicates.always ])
                  | optional,
                rewriteTo
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                ..
              },
          RewritePath-2 = predicates.contract_from_predicate
              definitions.predicate.RewritePath-2,
          UniquePath-1 = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                strategy
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.ConflictResolution,
                    predicates.always
                  ])
                  | optional,
                ..
              },
          UniquePath-2 = predicates.contract_from_predicate
              definitions.predicate.UniquePath-2,
          UseEncoding-1 = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                encoding
                  | {  .. }
                  | doc m%"
                  The encuding to use, as recognized by the java java.nio.charset.Charset class
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                ..
              },
          UseEncoding-2 = predicates.contract_from_predicate
              definitions.predicate.UseEncoding-2,
          YTT-1 = {
                allowList
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [ definitions.predicate.Pattern, predicates.always ])
                  ])
                  | doc m%"
                  A list of variable names that are allowed to be passed to YTT
                  "%
                  | optional,
                condition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.Expression, predicates.always ])
                  | optional,
                denyList
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [ definitions.predicate.Pattern, predicates.always ])
                  ])
                  | doc m%"
                  A list of variable names that are denied from being passed to YTT
                  "%
                  | optional,
                extraArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [ definitions.predicate.Expression, predicates.always ])
                  ])
                  | doc m%"
                  A list of SpEL expressions whose results are additional command line arguments
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The transform name
                  "%
                  | optional,
                ..
              },
          YTT-2 = predicates.contract_from_predicate
              definitions.predicate.YTT-2,
        },
    predicate = {
          AcceleratorOption = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.records.record
                  {
                    dataType = predicates.const "string",
                    defaultValue = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    dataType = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.const "string")
                        ],
                    defaultValue = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    dataType = predicates.const "number",
                    defaultValue = predicates.isType '"Number",
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    dataType = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.const "number")
                        ],
                    defaultValue = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"Number")
                        ],
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    dataType = predicates.const "boolean",
                    defaultValue = predicates.isType '"Bool",
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    dataType = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.const "boolean")
                        ],
                    defaultValue = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.isType '"Bool")
                        ],
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    dataType = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^$|^[A-Z][a-z0-9A-Z]*$"
                        ],
                    defaultValue = predicates.isType 'Record,
                  }
                  {  }
                  true
                  predicates.always,
                  predicates.records.record
                  {
                    dataType = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "^$|^[A-Z][a-z0-9A-Z]*$"
                          ])
                        ],
                    defaultValue = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.isType 'Record)
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
                predicates.records.record
                {
                  choices = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            text = predicates.isType '"String",
                            value = predicates.always,
                          }
                          {  }
                          true
                          predicates.always
                        ])
                      ],
                  dataType = predicates.anyOf
                      [
                        predicates.const "string",
                        predicates.const "number",
                        predicates.const "boolean",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^$|^[A-Z][a-z0-9A-Z]*$"
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.const "string"),
                          predicates.arrays.maxItems 1,
                          predicates.arrays.minItems 1
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.const "number"),
                          predicates.arrays.maxItems 1,
                          predicates.arrays.minItems 1
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.const "boolean"),
                          predicates.arrays.maxItems 1,
                          predicates.arrays.minItems 1
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "^$|^[A-Z][a-z0-9A-Z]*$"
                          ]),
                          predicates.arrays.maxItems 1,
                          predicates.arrays.minItems 1
                        ],
                        predicates.isType 'Null
                      ],
                  defaultValue = predicates.always,
                  dependsOn = predicates.allOf
                      [ definitions.predicate.DependsOn, predicates.always ],
                  description = predicates.isType '"String",
                  inputType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "text", "textarea", "checkbox", "select", "radio" ]
                      ],
                  label = predicates.isType '"String",
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1,
                        predicates.strings.pattern "^$|^[a-z][a-z0-9A-Z]*$"
                      ],
                  required = predicates.isType '"Bool",
                  validationRegex = predicates.allOf
                      [ definitions.predicate.Pattern, predicates.always ],
                }
                {  }
                true
                predicates.always
              ],
          Chain-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  applyTo = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^$|^[^/].*$"
                        ]),
                        predicates.arrays.minItems 1
                      ],
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  name = predicates.isType '"String",
                  transformations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.Loop-2,
                          definitions.predicate.Chain-2,
                          definitions.predicate.Provenance-2,
                          definitions.predicate.Exclude-2,
                          definitions.predicate.Include-2,
                          definitions.predicate.Combo-2,
                          definitions.predicate.ReplaceText-2,
                          definitions.predicate.InvokeFragment-2,
                          definitions.predicate.Merge-2,
                          definitions.predicate.OpenRewriteRecipe-2,
                          definitions.predicate.RewritePath-2,
                          definitions.predicate.UniquePath-2,
                          definitions.predicate.YTT-2,
                          definitions.predicate.Let-2,
                          definitions.predicate.UseEncoding-2,
                          definitions.predicate.InvokeFragment-2
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Chain-2 = predicates.allOf
              [
                definitions.predicate.Chain-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record { type = predicates.const "Chain", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          Combo-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  applyTo = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^$|^[^/].*$"
                        ]),
                        predicates.arrays.minItems 1
                      ],
                  chain = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.Loop-2,
                          definitions.predicate.Chain-2,
                          definitions.predicate.Provenance-2,
                          definitions.predicate.Exclude-2,
                          definitions.predicate.Include-2,
                          definitions.predicate.Combo-2,
                          definitions.predicate.ReplaceText-2,
                          definitions.predicate.InvokeFragment-2,
                          definitions.predicate.Merge-2,
                          definitions.predicate.OpenRewriteRecipe-2,
                          definitions.predicate.RewritePath-2,
                          definitions.predicate.UniquePath-2,
                          definitions.predicate.YTT-2,
                          definitions.predicate.Let-2,
                          definitions.predicate.UseEncoding-2,
                          definitions.predicate.InvokeFragment-2
                        ])
                      ],
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^$|^[^/].*$"
                        ])
                      ],
                  include = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^$|^[^/].*$"
                        ])
                      ],
                  "let" = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          definitions.predicate.DerivedSymbol,
                          predicates.always
                        ])
                      ],
                  "merge" = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.Loop-2,
                          definitions.predicate.Chain-2,
                          definitions.predicate.Provenance-2,
                          definitions.predicate.Exclude-2,
                          definitions.predicate.Include-2,
                          definitions.predicate.Combo-2,
                          definitions.predicate.ReplaceText-2,
                          definitions.predicate.InvokeFragment-2,
                          definitions.predicate.Merge-2,
                          definitions.predicate.OpenRewriteRecipe-2,
                          definitions.predicate.RewritePath-2,
                          definitions.predicate.UniquePath-2,
                          definitions.predicate.YTT-2,
                          definitions.predicate.Let-2,
                          definitions.predicate.UseEncoding-2,
                          definitions.predicate.InvokeFragment-2
                        ])
                      ],
                  name = predicates.isType '"String",
                  onConflict = predicates.allOf
                      [
                        definitions.predicate.ConflictResolution,
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Combo-2 = predicates.allOf
              [
                definitions.predicate.Combo-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record { type = predicates.const "Combo", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          ConflictResolution = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "Fail",
                  "UseFirst",
                  "UseLast",
                  "Append",
                  "FavorOwn",
                  "FavorForeign",
                  "NWayDiff"
                ]
              ],
          DependsOn = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1,
                        predicates.strings.pattern "^$|^[a-z][a-z0-9A-Z]*$"
                      ],
                  value = predicates.always,
                }
                {  }
                true
                predicates.always
              ],
          DerivedSymbol = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  expression = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1,
                        predicates.strings.pattern "^$|^[a-z][a-z0-9A-Z]*$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Exclude-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  name = predicates.isType '"String",
                  patterns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^$|^[^/].*$"
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Exclude-2 = predicates.allOf
              [
                definitions.predicate.Exclude-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record
                  { type = predicates.const "Exclude", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          Expression = predicates.isType '"String",
          Include-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  name = predicates.isType '"String",
                  patterns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1,
                          predicates.strings.pattern "^$|^[^/].*$"
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Include-2 = predicates.allOf
              [
                definitions.predicate.Include-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record
                  { type = predicates.const "Include", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          InvokeFragment-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  anchor = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^$|^[^/]$|^[^/](.+)[^/]$"
                      ],
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  "let" = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          definitions.predicate.DerivedSymbol,
                          predicates.always
                        ])
                      ],
                  name = predicates.isType '"String",
                  reference = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1,
                        predicates.strings.pattern
                        "^[a-z0-9]([a-z0-9-]*[a-z0-9])?$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          InvokeFragment-2 = predicates.allOf
              [
                definitions.predicate.InvokeFragment-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record
                  { type = predicates.const "InvokeFragment", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          Let-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  "in" = predicates.anyOf
                      [
                        definitions.predicate.Loop-2,
                        definitions.predicate.Chain-2,
                        definitions.predicate.Provenance-2,
                        definitions.predicate.Exclude-2,
                        definitions.predicate.Include-2,
                        definitions.predicate.Combo-2,
                        definitions.predicate.ReplaceText-2,
                        definitions.predicate.InvokeFragment-2,
                        definitions.predicate.Merge-2,
                        definitions.predicate.OpenRewriteRecipe-2,
                        definitions.predicate.RewritePath-2,
                        definitions.predicate.UniquePath-2,
                        definitions.predicate.YTT-2,
                        definitions.predicate.Let-2,
                        definitions.predicate.UseEncoding-2,
                        definitions.predicate.InvokeFragment-2
                      ],
                  name = predicates.isType '"String",
                  noShadow = predicates.isType '"Bool",
                  symbols = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          definitions.predicate.DerivedSymbol,
                          predicates.always
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Let-2 = predicates.allOf
              [
                definitions.predicate.Let-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record { type = predicates.const "Let", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          Loop-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  doAsChain = predicates.anyOf
                      [
                        definitions.predicate.Loop-2,
                        definitions.predicate.Chain-2,
                        definitions.predicate.Provenance-2,
                        definitions.predicate.Exclude-2,
                        definitions.predicate.Include-2,
                        definitions.predicate.Combo-2,
                        definitions.predicate.ReplaceText-2,
                        definitions.predicate.InvokeFragment-2,
                        definitions.predicate.Merge-2,
                        definitions.predicate.OpenRewriteRecipe-2,
                        definitions.predicate.RewritePath-2,
                        definitions.predicate.UniquePath-2,
                        definitions.predicate.YTT-2,
                        definitions.predicate.Let-2,
                        definitions.predicate.UseEncoding-2,
                        definitions.predicate.InvokeFragment-2
                      ],
                  doAsMerge = predicates.anyOf
                      [
                        definitions.predicate.Loop-2,
                        definitions.predicate.Chain-2,
                        definitions.predicate.Provenance-2,
                        definitions.predicate.Exclude-2,
                        definitions.predicate.Include-2,
                        definitions.predicate.Combo-2,
                        definitions.predicate.ReplaceText-2,
                        definitions.predicate.InvokeFragment-2,
                        definitions.predicate.Merge-2,
                        definitions.predicate.OpenRewriteRecipe-2,
                        definitions.predicate.RewritePath-2,
                        definitions.predicate.UniquePath-2,
                        definitions.predicate.YTT-2,
                        definitions.predicate.Let-2,
                        definitions.predicate.UseEncoding-2,
                        definitions.predicate.InvokeFragment-2
                      ],
                  index = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^$|^[a-z][a-z0-9A-Z]*$"
                      ],
                  name = predicates.isType '"String",
                  on = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  var = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^$|^[a-z][a-z0-9A-Z]*$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Loop-2 = predicates.allOf
              [
                definitions.predicate.Loop-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record { type = predicates.const "Loop", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          Merge-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  name = predicates.isType '"String",
                  sources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.Loop-2,
                          definitions.predicate.Chain-2,
                          definitions.predicate.Provenance-2,
                          definitions.predicate.Exclude-2,
                          definitions.predicate.Include-2,
                          definitions.predicate.Combo-2,
                          definitions.predicate.ReplaceText-2,
                          definitions.predicate.InvokeFragment-2,
                          definitions.predicate.Merge-2,
                          definitions.predicate.OpenRewriteRecipe-2,
                          definitions.predicate.RewritePath-2,
                          definitions.predicate.UniquePath-2,
                          definitions.predicate.YTT-2,
                          definitions.predicate.Let-2,
                          definitions.predicate.UseEncoding-2,
                          definitions.predicate.InvokeFragment-2
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Merge-2 = predicates.allOf
              [
                definitions.predicate.Merge-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record { type = predicates.const "Merge", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          OpenRewriteRecipe-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  name = predicates.isType '"String",
                  options = predicates.isType 'Record,
                  parseOrFail = predicates.isType '"Bool",
                  recipe = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[a-zA-Z_$][a-zA-Z\\d_$]*(?:\\.[a-zA-Z_$][a-zA-Z\\d_$]*)*$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          OpenRewriteRecipe-2 = predicates.allOf
              [
                definitions.predicate.OpenRewriteRecipe-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record
                  { type = predicates.const "OpenRewriteRecipe", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          Pattern = predicates.isType '"String",
          Provenance-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Provenance-2 = predicates.allOf
              [
                definitions.predicate.Provenance-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record
                  { type = predicates.const "Provenance", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          ReplaceText-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  name = predicates.isType '"String",
                  regex = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          pattern = predicates.allOf
                              [
                                definitions.predicate.Pattern,
                                predicates.always
                              ],
                          with = predicates.allOf
                              [
                                definitions.predicate.Expression,
                                predicates.always
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  substitutions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            text = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.minLength 1
                                ],
                            with = predicates.allOf
                                [
                                  definitions.predicate.Expression,
                                  predicates.always
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ])
                      ],
                }
                {  }
                true
                predicates.always
              ],
          ReplaceText-2 = predicates.allOf
              [
                definitions.predicate.ReplaceText-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record
                  { type = predicates.const "ReplaceText", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          RewritePath-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  matchOrFail = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  regex = predicates.allOf
                      [ definitions.predicate.Pattern, predicates.always ],
                  rewriteTo = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                }
                {  }
                true
                predicates.always
              ],
          RewritePath-2 = predicates.allOf
              [
                definitions.predicate.RewritePath-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record
                  { type = predicates.const "RewritePath", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          UniquePath-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  name = predicates.isType '"String",
                  strategy = predicates.allOf
                      [
                        definitions.predicate.ConflictResolution,
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          UniquePath-2 = predicates.allOf
              [
                definitions.predicate.UniquePath-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record
                  { type = predicates.const "UniquePath", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          UseEncoding-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  encoding = predicates.isType 'Record,
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          UseEncoding-2 = predicates.allOf
              [
                definitions.predicate.UseEncoding-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record
                  { type = predicates.const "UseEncoding", }
                  {  }
                  true
                  predicates.always
                ]
              ],
          YTT-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowList = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [ definitions.predicate.Pattern, predicates.always ])
                      ],
                  condition = predicates.allOf
                      [ definitions.predicate.Expression, predicates.always ],
                  denyList = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [ definitions.predicate.Pattern, predicates.always ])
                      ],
                  extraArgs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [ definitions.predicate.Expression, predicates.always ])
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          YTT-2 = predicates.allOf
              [
                definitions.predicate.YTT-1,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type" ],
                  predicates.records.record { type = predicates.const "YTT", }
                  {  }
                  true
                  predicates.always
                ]
              ],
        },
  }
in

{
  accelerator
    | {
      description
        | String
        | doc m%"
        A more detailed description
        "%
        | optional,
      displayName
        | String
        | doc m%"
        A human-readable name
        "%
        | optional,
      iconUrl
        | String
        | doc m%"
        A URL pointing to an icon image
        "%
        | optional,
      imports
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
              expose = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        as = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.minLength 1,
                              predicates.strings.pattern
                              "^$|^[a-z][a-z0-9A-Z]*$"
                            ],
                        dependsOn = predicates.allOf
                            [
                              definitions.predicate.DependsOn,
                              predicates.always
                            ],
                        name = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.minLength 1,
                              predicates.strings.pattern
                              "^\\*$|^$|^[a-z][a-z0-9A-Z]*$"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              exposeTypes = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        as = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.minLength 1,
                              predicates.strings.pattern
                              "^$|^[A-Z][a-z0-9A-Z]*$"
                            ],
                        name = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.minLength 1,
                              predicates.strings.pattern
                              "^\\*$|^$|^[A-Z][a-z0-9A-Z]*$"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              name = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | doc m%"
        The list of fragment to import
        "%
        | optional,
      options
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ definitions.predicate.AcceleratorOption, predicates.always ])
        ])
        | doc m%"
        The list of options passed to the UI to create input text boxes
        "%
        | optional,
      tags
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        A list of tags used to filter accelerators
        "%
        | optional,
      types
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
              name = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1,
                    predicates.strings.pattern "^$|^[A-Z][a-z0-9A-Z]*$"
                  ],
              struct = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      definitions.predicate.AcceleratorOption,
                      predicates.always
                    ]),
                    predicates.arrays.minItems 1
                  ],
            }
            {  }
            true
            predicates.always
          ])
        ])
        | doc m%"
        The definitions of custom types
        "%
        | optional,
      ..
    }
    | doc m%"
    The metadata (non-behavioral) part of an App Accelerator's accelerator.yaml file
    "%
    | optional,
  engine
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.Loop-2,
      definitions.predicate.Chain-2,
      definitions.predicate.Provenance-2,
      definitions.predicate.Exclude-2,
      definitions.predicate.Include-2,
      definitions.predicate.Combo-2,
      definitions.predicate.ReplaceText-2,
      definitions.predicate.InvokeFragment-2,
      definitions.predicate.Merge-2,
      definitions.predicate.OpenRewriteRecipe-2,
      definitions.predicate.RewritePath-2,
      definitions.predicate.UniquePath-2,
      definitions.predicate.YTT-2,
      definitions.predicate.Let-2,
      definitions.predicate.UseEncoding-2,
      definitions.predicate.InvokeFragment-2
    ])
    | optional,
  ..
}