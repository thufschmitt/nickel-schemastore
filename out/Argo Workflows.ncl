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
          "eventsource.CreateEventSourceRequest" = {
                eventSource
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSource"
                  | optional,
                namespace | String | optional,
                ..
              },
          "eventsource.EventSourceDeletedResponse" = {  .. },
          "eventsource.EventSourceWatchEvent" = {
                object
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSource"
                  | optional,
                type | String | optional,
                ..
              },
          "eventsource.LogEntry" = {
                eventName | String | optional,
                eventSourceName | String | optional,
                eventSourceType | String | optional,
                level | String | optional,
                msg | String | optional,
                namespace | String | optional,
                time
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | optional,
                ..
              },
          "eventsource.UpdateEventSourceRequest" = {
                eventSource
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSource"
                  | optional,
                name | String | optional,
                namespace | String | optional,
                ..
              },
          "google.protobuf.Any" = {
                type_url | String | optional,
                value | String | optional,
                ..
              },
          "grpc.gateway.runtime.Error" = {
                code | std.number.Integer | optional,
                details
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."google.protobuf.Any"
                  ])
                  | optional,
                error | String | optional,
                message | String | optional,
                ..
              },
          "grpc.gateway.runtime.StreamError" = {
                details
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."google.protobuf.Any"
                  ])
                  | optional,
                grpc_code | std.number.Integer | optional,
                http_code | std.number.Integer | optional,
                http_status | String | optional,
                message | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.AMQPConsumeConfig" = {
                autoAck | Bool | optional,
                consumerTag | String | optional,
                exclusive | Bool | optional,
                noLocal | Bool | optional,
                noWait | Bool | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.AMQPEventSource" = {
                auth
                  | definitions.contract."io.argoproj.events.v1alpha1.BasicAuth"
                  | optional,
                connectionBackoff
                  | definitions.contract."io.argoproj.events.v1alpha1.Backoff"
                  | optional,
                consume
                  | definitions.contract."io.argoproj.events.v1alpha1.AMQPConsumeConfig"
                  | optional,
                exchangeDeclare
                  | definitions.contract."io.argoproj.events.v1alpha1.AMQPExchangeDeclareConfig"
                  | optional,
                exchangeName | String | optional,
                exchangeType | String | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                jsonBody | Bool | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                queueBind
                  | definitions.contract."io.argoproj.events.v1alpha1.AMQPQueueBindConfig"
                  | optional,
                queueDeclare
                  | definitions.contract."io.argoproj.events.v1alpha1.AMQPQueueDeclareConfig"
                  | optional,
                routingKey | String | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                url | String | optional,
                urlSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.AMQPExchangeDeclareConfig" = {
                autoDelete | Bool | optional,
                durable | Bool | optional,
                internal | Bool | optional,
                noWait | Bool | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.AMQPQueueBindConfig" = {
                noWait | Bool | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.AMQPQueueDeclareConfig" = {
                arguments | String | optional,
                autoDelete | Bool | optional,
                durable | Bool | optional,
                exclusive | Bool | optional,
                name | String | optional,
                noWait | Bool | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.AWSLambdaTrigger" = {
                accessKey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                functionName
                  | String
                  | doc m%"
                  FunctionName refers to the name of the function to invoke.
                  "%
                  | optional,
                invocationType
                  | String
                  | doc m%"
                  Choose from the following options.
                  
                     * RequestResponse (default) - Invoke the function synchronously. Keep
                     the connection open until the function returns a response or times out.
                     The API response includes the function response and additional data.
                  
                     * Event - Invoke the function asynchronously. Send events that fail multiple
                     times to the function's dead-letter queue (if it's configured). The API
                     response only includes a status code.
                  
                     * DryRun - Validate parameter values and verify that the user or role
                     has permission to invoke the function.
                  +optional
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | optional,
                payload
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | doc m%"
                  Payload is the list of key-value extracted from an event payload to construct the request payload.
                  "%
                  | optional,
                region | String | optional,
                roleARN | String | optional,
                secretKey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.Amount"
            | doc m%"
            Amount represent a numeric amount.
            "%
            = { value | String | optional, .. },
          "io.argoproj.events.v1alpha1.ArgoWorkflowTrigger" = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                operation | String | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | optional,
                source
                  | definitions.contract."io.argoproj.events.v1alpha1.ArtifactLocation"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.ArtifactLocation" = {
                configmap
                  | definitions.contract."io.k8s.api.core.v1.ConfigMapKeySelector"
                  | optional,
                file
                  | definitions.contract."io.argoproj.events.v1alpha1.FileArtifact"
                  | optional,
                git
                  | definitions.contract."io.argoproj.events.v1alpha1.GitArtifact"
                  | optional,
                inline | String | optional,
                resource
                  | definitions.contract."io.argoproj.events.v1alpha1.Resource"
                  | optional,
                s3
                  | definitions.contract."io.argoproj.events.v1alpha1.S3Artifact"
                  | optional,
                url
                  | definitions.contract."io.argoproj.events.v1alpha1.URLArtifact"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.AzureEventHubsTrigger" = {
                fqdn | String | optional,
                hubName | String | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | optional,
                payload
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | doc m%"
                  Payload is the list of key-value extracted from an event payload to construct the request payload.
                  "%
                  | optional,
                sharedAccessKey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                sharedAccessKeyName
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.AzureEventsHubEventSource" = {
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                fqdn | String | optional,
                hubName | String | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                sharedAccessKey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                sharedAccessKeyName
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.Backoff" = {
                duration
                  | definitions.contract."io.argoproj.events.v1alpha1.Int64OrString"
                  | optional,
                factor
                  | definitions.contract."io.argoproj.events.v1alpha1.Amount"
                  | optional,
                jitter
                  | definitions.contract."io.argoproj.events.v1alpha1.Amount"
                  | optional,
                steps | std.number.Integer | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.BasicAuth" = {
                password
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  Password refers to the Kubernetes secret that holds the password required for basic auth.
                  "%
                  | optional,
                username
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  Username refers to the Kubernetes secret that holds the username required for basic auth.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.BitbucketAuth" = {
                basic
                  | definitions.contract."io.argoproj.events.v1alpha1.BitbucketBasicAuth"
                  | optional,
                oauthToken
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.BitbucketBasicAuth" = {
                password
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  Password refers to the K8s secret that holds the password.
                  "%
                  | optional,
                username
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  Username refers to the K8s secret that holds the username.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.BitbucketEventSource" = {
                auth
                  | definitions.contract."io.argoproj.events.v1alpha1.BitbucketAuth"
                  | doc m%"
                  Auth information required to connect to Bitbucket.
                  "%
                  | optional,
                deleteHookOnFinish | Bool | optional,
                events
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Events this webhook is subscribed to.
                  "%
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                owner | String | optional,
                projectKey | String | optional,
                repositories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.BitbucketRepository"
                  ])
                  | optional,
                repositorySlug | String | optional,
                webhook
                  | definitions.contract."io.argoproj.events.v1alpha1.WebhookContext"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.BitbucketRepository" = {
                owner | String | optional,
                repositorySlug | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.BitbucketServerEventSource" = {
                accessToken
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                bitbucketserverBaseURL | String | optional,
                deleteHookOnFinish | Bool | optional,
                events
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                projectKey | String | optional,
                repositories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.BitbucketServerRepository"
                  ])
                  | optional,
                repositorySlug | String | optional,
                webhook
                  | definitions.contract."io.argoproj.events.v1alpha1.WebhookContext"
                  | optional,
                webhookSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.BitbucketServerRepository" = {
                projectKey | String | optional,
                repositorySlug | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.CalendarEventSource" = {
                exclusionDates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  ExclusionDates defines the list of DATE-TIME exceptions for recurring events.
                  "%
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                interval | String | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                persistence
                  | definitions.contract."io.argoproj.events.v1alpha1.EventPersistence"
                  | optional,
                schedule | String | optional,
                timezone | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.CatchupConfiguration" = {
                enabled | Bool | optional,
                maxDuration | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.Condition" = {
                lastTransitionTime
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | optional,
                message | String | optional,
                reason | String | optional,
                status | String | optional,
                type | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.ConditionsResetByTime" = {
                cron | String | optional,
                timezone | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.ConditionsResetCriteria" = {
                byTime
                  | definitions.contract."io.argoproj.events.v1alpha1.ConditionsResetByTime"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.ConfigMapPersistence" = {
                createIfNotExist | Bool | optional,
                name | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.CustomTrigger"
            | doc m%"
            CustomTrigger refers to the specification of the custom trigger.
            "%
            = {
                certSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  CertSecret refers to the secret that contains cert for secure connection between sensor and custom trigger gRPC server.
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | doc m%"
                  Parameters is the list of parameters that is applied to resolved custom trigger trigger object.
                  "%
                  | optional,
                payload
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | doc m%"
                  Payload is the list of key-value extracted from an event payload to construct the request payload.
                  "%
                  | optional,
                secure | Bool | optional,
                serverNameOverride
                  | String
                  | doc m%"
                  ServerNameOverride for the secure connection between sensor and custom trigger gRPC server.
                  "%
                  | optional,
                serverURL | String | optional,
                spec
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Spec is the custom trigger resource specification that custom trigger gRPC server knows how to interpret.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.DataFilter" = {
                comparator
                  | String
                  | doc m%"
                  Comparator compares the event data with a user given value.
                  Can be ">=", ">", "=", "!=", "<", or "<=".
                  Is optional, and if left blank treated as equality "=".
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path is the JSONPath of the event's (JSON decoded) data key
                  Path is a series of keys separated by a dot. A key may contain wildcard characters '*' and '?'.
                  To access an array value use the index as the key. The dot and wildcard characters can be escaped with '\\'.
                  See https://github.com/tidwall/gjson#path-syntax for more information on how to use this.
                  "%
                  | optional,
                template | String | optional,
                type | String | optional,
                value
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.EmitterEventSource" = {
                broker
                  | String
                  | doc m%"
                  Broker URI to connect to.
                  "%
                  | optional,
                channelKey | String | optional,
                channelName | String | optional,
                connectionBackoff
                  | definitions.contract."io.argoproj.events.v1alpha1.Backoff"
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                jsonBody | Bool | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                password
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                username
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.EventContext" = {
                datacontenttype
                  | String
                  | doc m%"
                  DataContentType - A MIME (RFC2046) string describing the media type of `data`.
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  ID of the event; must be non-empty and unique within the scope of the producer.
                  "%
                  | optional,
                source
                  | String
                  | doc m%"
                  Source - A URI describing the event producer.
                  "%
                  | optional,
                specversion
                  | String
                  | doc m%"
                  SpecVersion - The version of the CloudEvents specification used by the io.argoproj.workflow.v1alpha1.
                  "%
                  | optional,
                subject | String | optional,
                time
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | doc m%"
                  Time - A Timestamp when the event happened.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Type - The type of the occurrence which has happened.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.EventDependency" = {
                eventName | String | optional,
                eventSourceName | String | optional,
                filters
                  | definitions.contract."io.argoproj.events.v1alpha1.EventDependencyFilter"
                  | optional,
                filtersLogicalOperator
                  | String
                  | doc m%"
                  FiltersLogicalOperator defines how different filters are evaluated together.
                  Available values: and (&&), or (||)
                  Is optional and if left blank treated as and (&&).
                  "%
                  | optional,
                name | String | optional,
                transform
                  | definitions.contract."io.argoproj.events.v1alpha1.EventDependencyTransformer"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.EventDependencyFilter"
            | doc m%"
            EventDependencyFilter defines filters and constraints for a io.argoproj.workflow.v1alpha1.
            "%
            = {
                context
                  | definitions.contract."io.argoproj.events.v1alpha1.EventContext"
                  | optional,
                data
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.DataFilter"
                  ])
                  | optional,
                dataLogicalOperator
                  | String
                  | doc m%"
                  DataLogicalOperator defines how multiple Data filters (if defined) are evaluated together.
                  Available values: and (&&), or (||)
                  Is optional and if left blank treated as and (&&).
                  "%
                  | optional,
                exprLogicalOperator
                  | String
                  | doc m%"
                  ExprLogicalOperator defines how multiple Exprs filters (if defined) are evaluated together.
                  Available values: and (&&), or (||)
                  Is optional and if left blank treated as and (&&).
                  "%
                  | optional,
                exprs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.ExprFilter"
                  ])
                  | doc m%"
                  Exprs contains the list of expressions evaluated against the event payload.
                  "%
                  | optional,
                script
                  | String
                  | doc m%"
                  Script refers to a Lua script evaluated to determine the validity of an io.argoproj.workflow.v1alpha1.
                  "%
                  | optional,
                time
                  | definitions.contract."io.argoproj.events.v1alpha1.TimeFilter"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.EventDependencyTransformer" = {
                jq | String | optional,
                script | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.EventPersistence" = {
                catchup
                  | definitions.contract."io.argoproj.events.v1alpha1.CatchupConfiguration"
                  | optional,
                configMap
                  | definitions.contract."io.argoproj.events.v1alpha1.ConfigMapPersistence"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.EventSource" = {
                metadata
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta"
                  | optional,
                spec
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceSpec"
                  | optional,
                status
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceStatus"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.EventSourceFilter" = {
                expression | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.EventSourceList" = {
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSource"
                  ])
                  | optional,
                metadata
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.EventSourceSpec" = {
                amqp
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.AMQPEventSource"
                  ])
                  | optional,
                azureEventsHub
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.AzureEventsHubEventSource"
                  ])
                  | optional,
                bitbucket
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.BitbucketEventSource"
                  ])
                  | optional,
                bitbucketserver
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.BitbucketServerEventSource"
                  ])
                  | optional,
                calendar
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.CalendarEventSource"
                  ])
                  | optional,
                emitter
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.EmitterEventSource"
                  ])
                  | optional,
                eventBusName | String | optional,
                file
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.FileEventSource"
                  ])
                  | optional,
                generic
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.GenericEventSource"
                  ])
                  | optional,
                github
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.GithubEventSource"
                  ])
                  | optional,
                gitlab
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.GitlabEventSource"
                  ])
                  | optional,
                hdfs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.HDFSEventSource"
                  ])
                  | optional,
                kafka
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.KafkaEventSource"
                  ])
                  | optional,
                minio
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.S3Artifact"
                  ])
                  | optional,
                mqtt
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.MQTTEventSource"
                  ])
                  | optional,
                nats
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.NATSEventsSource"
                  ])
                  | optional,
                nsq
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.NSQEventSource"
                  ])
                  | optional,
                pubSub
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.PubSubEventSource"
                  ])
                  | optional,
                pulsar
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.PulsarEventSource"
                  ])
                  | optional,
                redis
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.RedisEventSource"
                  ])
                  | optional,
                redisStream
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.RedisStreamEventSource"
                  ])
                  | optional,
                replicas | std.number.Integer | optional,
                resource
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.ResourceEventSource"
                  ])
                  | optional,
                service
                  | definitions.contract."io.argoproj.events.v1alpha1.Service"
                  | optional,
                slack
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.SlackEventSource"
                  ])
                  | optional,
                sns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.SNSEventSource"
                  ])
                  | optional,
                sqs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.SQSEventSource"
                  ])
                  | optional,
                storageGrid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.StorageGridEventSource"
                  ])
                  | optional,
                stripe
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.StripeEventSource"
                  ])
                  | optional,
                template
                  | definitions.contract."io.argoproj.events.v1alpha1.Template"
                  | optional,
                webhook
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.events.v1alpha1.WebhookEventSource"
                  ])
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.EventSourceStatus" = {
                status
                  | definitions.contract."io.argoproj.events.v1alpha1.Status"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.ExprFilter" = {
                expr
                  | String
                  | doc m%"
                  Expr refers to the expression that determines the outcome of the filter.
                  "%
                  | optional,
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.PayloadField"
                  ])
                  | doc m%"
                  Fields refers to set of keys that refer to the paths within event payload.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.FileArtifact" = {
                path | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.FileEventSource"
            | doc m%"
            FileEventSource describes an event-source for file related events.
            "%
            = {
                eventType | String | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                polling | Bool | optional,
                watchPathConfig
                  | definitions.contract."io.argoproj.events.v1alpha1.WatchPathConfig"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.GenericEventSource"
            | doc m%"
            GenericEventSource refers to a generic event source. It can be used to implement a custom event source.
            "%
            = {
                authSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                config | String | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                insecure
                  | Bool
                  | doc m%"
                  Insecure determines the type of connection.
                  "%
                  | optional,
                jsonBody | Bool | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                url
                  | String
                  | doc m%"
                  URL of the gRPC server that implements the event source.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.GitArtifact" = {
                branch | String | optional,
                cloneDirectory
                  | String
                  | doc m%"
                  Directory to clone the repository. We clone complete directory because GitArtifact is not limited to any specific Git service providers.
                  Hence we don't use any specific git provider client.
                  "%
                  | optional,
                creds
                  | definitions.contract."io.argoproj.events.v1alpha1.GitCreds"
                  | optional,
                filePath | String | optional,
                insecureIgnoreHostKey | Bool | optional,
                ref | String | optional,
                remote
                  | definitions.contract."io.argoproj.events.v1alpha1.GitRemoteConfig"
                  | optional,
                sshKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                tag | String | optional,
                url | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.GitCreds" = {
                password
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                username
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.GitRemoteConfig" = {
                name
                  | String
                  | doc m%"
                  Name of the remote to fetch from.
                  "%
                  | optional,
                urls
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  URLs the URLs of a remote repository. It must be non-empty. Fetch will
                  always use the first URL, while push will use all of them.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.GithubAppCreds" = {
                appID | String | optional,
                installationID | String | optional,
                privateKey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.GithubEventSource" = {
                active | Bool | optional,
                apiToken
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                contentType | String | optional,
                deleteHookOnFinish | Bool | optional,
                events
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                githubApp
                  | definitions.contract."io.argoproj.events.v1alpha1.GithubAppCreds"
                  | optional,
                githubBaseURL | String | optional,
                githubUploadURL | String | optional,
                id | String | optional,
                insecure | Bool | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                organizations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Organizations holds the names of organizations (used for organization level webhooks). Not required if Repositories is set.
                  "%
                  | optional,
                owner | String | optional,
                repositories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.OwnedRepositories"
                  ])
                  | doc m%"
                  Repositories holds the information of repositories, which uses repo owner as the key,
                  and list of repo names as the value. Not required if Organizations is set.
                  "%
                  | optional,
                repository | String | optional,
                webhook
                  | definitions.contract."io.argoproj.events.v1alpha1.WebhookContext"
                  | optional,
                webhookSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.GitlabEventSource" = {
                accessToken
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                deleteHookOnFinish | Bool | optional,
                enableSSLVerification | Bool | optional,
                events
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Events are gitlab event to listen to.
                  Refer https://github.com/xanzy/go-gitlab/blob/bf34eca5d13a9f4c3f501d8a97b8ac226d55e4d9/projects.go#L794.
                  "%
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                gitlabBaseURL | String | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                projectID | String | optional,
                projects
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                secretToken
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                webhook
                  | definitions.contract."io.argoproj.events.v1alpha1.WebhookContext"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.HDFSEventSource" = {
                addresses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                checkInterval | String | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                hdfsUser
                  | String
                  | doc m%"
                  HDFSUser is the user to access HDFS file system.
                  It is ignored if either ccache or keytab is used.
                  "%
                  | optional,
                krbCCacheSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  KrbCCacheSecret is the secret selector for Kerberos ccache
                  Either ccache or keytab can be set to use Kerberos.
                  "%
                  | optional,
                krbConfigConfigMap
                  | definitions.contract."io.k8s.api.core.v1.ConfigMapKeySelector"
                  | doc m%"
                  KrbConfig is the configmap selector for Kerberos config as string
                  It must be set if either ccache or keytab is used.
                  "%
                  | optional,
                krbKeytabSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  KrbKeytabSecret is the secret selector for Kerberos keytab
                  Either ccache or keytab can be set to use Kerberos.
                  "%
                  | optional,
                krbRealm
                  | String
                  | doc m%"
                  KrbRealm is the Kerberos realm used with Kerberos keytab
                  It must be set if keytab is used.
                  "%
                  | optional,
                krbServicePrincipalName
                  | String
                  | doc m%"
                  KrbServicePrincipalName is the principal name of Kerberos service
                  It must be set if either ccache or keytab is used.
                  "%
                  | optional,
                krbUsername
                  | String
                  | doc m%"
                  KrbUsername is the Kerberos username used with Kerberos keytab
                  It must be set if keytab is used.
                  "%
                  | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                type | String | optional,
                watchPathConfig
                  | definitions.contract."io.argoproj.events.v1alpha1.WatchPathConfig"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.HTTPTrigger" = {
                basicAuth
                  | definitions.contract."io.argoproj.events.v1alpha1.BasicAuth"
                  | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                method | String | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | doc m%"
                  Parameters is the list of key-value extracted from event's payload that are applied to
                  the HTTP trigger resource.
                  "%
                  | optional,
                payload
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | optional,
                secureHeaders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.SecureHeader"
                  ])
                  | optional,
                timeout | String | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                url
                  | String
                  | doc m%"
                  URL refers to the URL to send HTTP request to.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.Int64OrString" = {
                int64Val | String | optional,
                strVal | String | optional,
                type | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.K8SResourcePolicy" = {
                backoff
                  | definitions.contract."io.argoproj.events.v1alpha1.Backoff"
                  | optional,
                errorOnBackoffTimeout | Bool | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.KafkaConsumerGroup" = {
                groupName | String | optional,
                oldest | Bool | optional,
                rebalanceStrategy | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.KafkaEventSource" = {
                config
                  | String
                  | doc m%"
                  Yaml format Sarama config for Kafka connection.
                  It follows the struct of sarama.Config. See https://github.com/Shopify/sarama/blob/main/config.go
                  e.g.
                  
                  consumer:
                    fetch:
                      min: 1
                  net:
                    MaxOpenRequests: 5
                  
                  +optional
                  "%
                  | optional,
                connectionBackoff
                  | definitions.contract."io.argoproj.events.v1alpha1.Backoff"
                  | doc m%"
                  Backoff holds parameters applied to connection.
                  "%
                  | optional,
                consumerGroup
                  | definitions.contract."io.argoproj.events.v1alpha1.KafkaConsumerGroup"
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                jsonBody | Bool | optional,
                limitEventsPerSecond | String | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                partition | String | optional,
                sasl
                  | definitions.contract."io.argoproj.events.v1alpha1.SASLConfig"
                  | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                topic | String | optional,
                url | String | optional,
                version | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.KafkaTrigger"
            | doc m%"
            KafkaTrigger refers to the specification of the Kafka trigger.
            "%
            = {
                compress | Bool | optional,
                flushFrequency | std.number.Integer | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | doc m%"
                  Parameters is the list of parameters that is applied to resolved Kafka trigger object.
                  "%
                  | optional,
                partition
                  | std.number.Integer
                  | doc m%"
                  Partition to write data to.
                  "%
                  | optional,
                partitioningKey
                  | String
                  | doc m%"
                  The partitioning key for the messages put on the Kafka topic.
                  Defaults to broker url.
                  +optional.
                  "%
                  | optional,
                payload
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | doc m%"
                  Payload is the list of key-value extracted from an event payload to construct the request payload.
                  "%
                  | optional,
                requiredAcks
                  | std.number.Integer
                  | doc m%"
                  RequiredAcks used in producer to tell the broker how many replica acknowledgements
                  Defaults to 1 (Only wait for the leader to ack).
                  +optional.
                  "%
                  | optional,
                sasl
                  | definitions.contract."io.argoproj.events.v1alpha1.SASLConfig"
                  | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                topic | String | optional,
                url
                  | String
                  | doc m%"
                  URL of the Kafka broker, multiple URLs separated by comma.
                  "%
                  | optional,
                version | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.LogTrigger" = {
                intervalSeconds | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.MQTTEventSource" = {
                clientId | String | optional,
                connectionBackoff
                  | definitions.contract."io.argoproj.events.v1alpha1.Backoff"
                  | doc m%"
                  ConnectionBackoff holds backoff applied to connection.
                  "%
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                jsonBody | Bool | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                topic | String | optional,
                url | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.Metadata" = {
                annotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.NATSAuth" = {
                basic
                  | definitions.contract."io.argoproj.events.v1alpha1.BasicAuth"
                  | optional,
                credential
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                nkey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                token
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.NATSEventsSource" = {
                auth
                  | definitions.contract."io.argoproj.events.v1alpha1.NATSAuth"
                  | optional,
                connectionBackoff
                  | definitions.contract."io.argoproj.events.v1alpha1.Backoff"
                  | doc m%"
                  ConnectionBackoff holds backoff applied to connection.
                  "%
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                jsonBody | Bool | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                subject | String | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                url | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.NATSTrigger"
            | doc m%"
            NATSTrigger refers to the specification of the NATS trigger.
            "%
            = {
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | optional,
                payload
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | optional,
                subject
                  | String
                  | doc m%"
                  Name of the subject to put message on.
                  "%
                  | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                url
                  | String
                  | doc m%"
                  URL of the NATS cluster.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.NSQEventSource" = {
                channel | String | optional,
                connectionBackoff
                  | definitions.contract."io.argoproj.events.v1alpha1.Backoff"
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                hostAddress | String | optional,
                jsonBody | Bool | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                topic
                  | String
                  | doc m%"
                  Topic to subscribe to.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.OpenWhiskTrigger"
            | doc m%"
            OpenWhiskTrigger refers to the specification of the OpenWhisk trigger.
            "%
            = {
                actionName
                  | String
                  | doc m%"
                  Name of the action/function.
                  "%
                  | optional,
                authToken
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                host
                  | String
                  | doc m%"
                  Host URL of the OpenWhisk.
                  "%
                  | optional,
                namespace
                  | String
                  | doc m%"
                  Namespace for the action.
                  Defaults to "_".
                  +optional.
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | optional,
                payload
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | doc m%"
                  Payload is the list of key-value extracted from an event payload to construct the request payload.
                  "%
                  | optional,
                version | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.OwnedRepositories" = {
                names
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                owner | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.PayloadField"
            | doc m%"
            PayloadField binds a value at path within the event payload against a name.
            "%
            = {
                name
                  | String
                  | doc m%"
                  Name acts as key that holds the value at the path.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path is the JSONPath of the event's (JSON decoded) data key
                  Path is a series of keys separated by a dot. A key may contain wildcard characters '*' and '?'.
                  To access an array value use the index as the key. The dot and wildcard characters can be escaped with '\\'.
                  See https://github.com/tidwall/gjson#path-syntax for more information on how to use this.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.PubSubEventSource"
            | doc m%"
            PubSubEventSource refers to event-source for GCP PubSub related events.
            "%
            = {
                credentialSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                deleteSubscriptionOnFinish | Bool | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                jsonBody | Bool | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                projectID | String | optional,
                subscriptionID | String | optional,
                topic | String | optional,
                topicProjectID | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.PulsarEventSource" = {
                authTokenSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                connectionBackoff
                  | definitions.contract."io.argoproj.events.v1alpha1.Backoff"
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                jsonBody | Bool | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                tlsAllowInsecureConnection | Bool | optional,
                tlsTrustCertsSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                tlsValidateHostname | Bool | optional,
                topics
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                type | String | optional,
                url | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.PulsarTrigger"
            | doc m%"
            PulsarTrigger refers to the specification of the Pulsar trigger.
            "%
            = {
                authTokenSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                connectionBackoff
                  | definitions.contract."io.argoproj.events.v1alpha1.Backoff"
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | doc m%"
                  Parameters is the list of parameters that is applied to resolved Kafka trigger object.
                  "%
                  | optional,
                payload
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | doc m%"
                  Payload is the list of key-value extracted from an event payload to construct the request payload.
                  "%
                  | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                tlsAllowInsecureConnection | Bool | optional,
                tlsTrustCertsSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                tlsValidateHostname | Bool | optional,
                topic | String | optional,
                url | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.RateLimit" = {
                requestsPerUnit | std.number.Integer | optional,
                unit | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.RedisEventSource" = {
                channels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                db | std.number.Integer | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                hostAddress | String | optional,
                jsonBody | Bool | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                namespace | String | optional,
                password
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                username | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.RedisStreamEventSource" = {
                consumerGroup | String | optional,
                db | std.number.Integer | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                hostAddress | String | optional,
                maxMsgCountPerRead | std.number.Integer | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                password
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                streams
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Streams to look for entries. XREADGROUP is used on all streams using a single consumer group.
                  "%
                  | optional,
                tls
                  | definitions.contract."io.argoproj.events.v1alpha1.TLSConfig"
                  | optional,
                username | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.Resource"
            | doc m%"
            Resource represent arbitrary structured data.
            "%
            = { value | String | optional, .. },
          "io.argoproj.events.v1alpha1.ResourceEventSource"
            | doc m%"
            ResourceEventSource refers to a event-source for K8s resource related events.
            "%
            = {
                eventTypes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  EventTypes is the list of event type to watch.
                  Possible values are - ADD, UPDATE and DELETE.
                  "%
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.ResourceFilter"
                  | optional,
                groupVersionResource
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.GroupVersionResource"
                  | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                namespace | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.ResourceFilter" = {
                afterStart | Bool | optional,
                createdBy
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | optional,
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.Selector"
                  ])
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.Selector"
                  ])
                  | optional,
                prefix | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.S3Artifact" = {
                accessKey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                bucket
                  | definitions.contract."io.argoproj.events.v1alpha1.S3Bucket"
                  | optional,
                endpoint | String | optional,
                events
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.S3Filter"
                  | optional,
                insecure | Bool | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                region | String | optional,
                secretKey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.S3Bucket" = {
                key | String | optional,
                name | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.S3Filter" = {
                prefix | String | optional,
                suffix | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.SASLConfig" = {
                mechanism | String | optional,
                password
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                user
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.SNSEventSource" = {
                accessKey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                endpoint | String | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                region | String | optional,
                roleARN | String | optional,
                secretKey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                topicArn | String | optional,
                validateSignature | Bool | optional,
                webhook
                  | definitions.contract."io.argoproj.events.v1alpha1.WebhookContext"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.SQSEventSource" = {
                accessKey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                dlq | Bool | optional,
                endpoint | String | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                jsonBody | Bool | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                queue | String | optional,
                queueAccountId | String | optional,
                region | String | optional,
                roleARN | String | optional,
                secretKey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                sessionToken
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                waitTimeSeconds
                  | String
                  | doc m%"
                  WaitTimeSeconds is The duration (in seconds) for which the call waits for a message to arrive
                  in the queue before returning.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.SecureHeader" = {
                name | String | optional,
                valueFrom
                  | definitions.contract."io.argoproj.events.v1alpha1.ValueFromSource"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.Selector"
            | doc m%"
            Selector represents conditional operation to select K8s objects.
            "%
            = {
                key | String | optional,
                operation | String | optional,
                value | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.Sensor" = {
                metadata
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta"
                  | optional,
                spec
                  | definitions.contract."io.argoproj.events.v1alpha1.SensorSpec"
                  | optional,
                status
                  | definitions.contract."io.argoproj.events.v1alpha1.SensorStatus"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.SensorList" = {
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.Sensor"
                  ])
                  | optional,
                metadata
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.SensorSpec" = {
                dependencies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.EventDependency"
                  ])
                  | doc m%"
                  Dependencies is a list of the events that this sensor is dependent on.
                  "%
                  | optional,
                errorOnFailedRound
                  | Bool
                  | doc m%"
                  ErrorOnFailedRound if set to true, marks sensor state as `error` if the previous trigger round fails.
                  Once sensor state is set to `error`, no further triggers will be processed.
                  "%
                  | optional,
                eventBusName | String | optional,
                replicas | std.number.Integer | optional,
                template
                  | definitions.contract."io.argoproj.events.v1alpha1.Template"
                  | optional,
                triggers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.Trigger"
                  ])
                  | doc m%"
                  Triggers is a list of the things that this sensor evokes. These are the outputs from this sensor.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.SensorStatus"
            | doc m%"
            SensorStatus contains information about the status of a sensor.
            "%
            = {
                status
                  | definitions.contract."io.argoproj.events.v1alpha1.Status"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.Service" = {
                clusterIP | String | optional,
                ports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.ServicePort"
                  ])
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.SlackEventSource" = {
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                signingSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                token
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                webhook
                  | definitions.contract."io.argoproj.events.v1alpha1.WebhookContext"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.SlackTrigger"
            | doc m%"
            SlackTrigger refers to the specification of the slack notification trigger.
            "%
            = {
                channel | String | optional,
                message | String | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | optional,
                slackToken
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  SlackToken refers to the Kubernetes secret that holds the slack token required to send messages.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.StandardK8STrigger" = {
                liveObject | Bool | optional,
                operation | String | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | doc m%"
                  Parameters is the list of parameters that is applied to resolved K8s trigger object.
                  "%
                  | optional,
                patchStrategy | String | optional,
                source
                  | definitions.contract."io.argoproj.events.v1alpha1.ArtifactLocation"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.Status"
            | doc m%"
            Status is a common structure which can be used for Status field.
            "%
            = {
                conditions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.Condition"
                  ])
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.StatusPolicy" = {
                allow
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType 'Integer)
                  ])
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.StorageGridEventSource" = {
                apiURL
                  | String
                  | doc m%"
                  APIURL is the url of the storagegrid api.
                  "%
                  | optional,
                authToken
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                bucket
                  | String
                  | doc m%"
                  Name of the bucket to register notifications for.
                  "%
                  | optional,
                events
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.StorageGridFilter"
                  | doc m%"
                  Filter on object key which caused the notification.
                  "%
                  | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                region | String | optional,
                topicArn | String | optional,
                webhook
                  | definitions.contract."io.argoproj.events.v1alpha1.WebhookContext"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.StorageGridFilter" = {
                prefix | String | optional,
                suffix | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.StripeEventSource" = {
                apiKey
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                createWebhook | Bool | optional,
                eventFilter
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                webhook
                  | definitions.contract."io.argoproj.events.v1alpha1.WebhookContext"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.TLSConfig"
            | doc m%"
            TLSConfig refers to TLS configuration for a client.
            "%
            = {
                caCertSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                clientCertSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                clientKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                insecureSkipVerify | Bool | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.Template" = {
                affinity
                  | definitions.contract."io.k8s.api.core.v1.Affinity"
                  | optional,
                container
                  | definitions.contract."io.k8s.api.core.v1.Container"
                  | optional,
                imagePullSecrets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.LocalObjectReference"
                  ])
                  | optional,
                metadata
                  | definitions.contract."io.argoproj.events.v1alpha1.Metadata"
                  | optional,
                nodeSelector
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                "priority" | std.number.Integer | optional,
                priorityClassName | String | optional,
                securityContext
                  | definitions.contract."io.k8s.api.core.v1.PodSecurityContext"
                  | optional,
                serviceAccountName | String | optional,
                tolerations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.Toleration"
                  ])
                  | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.Volume"
                  ])
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.TimeFilter"
            | doc m%"
            TimeFilter describes a window in time.
            It filters out events that occur outside the time limits.
            In other words, only events that occur after Start and before Stop
            will pass this filter.
            "%
            = {
                start
                  | String
                  | doc m%"
                  Start is the beginning of a time window in UTC.
                  Before this time, events for this dependency are ignored.
                  Format is hh:mm:ss.
                  "%
                  | optional,
                stop
                  | String
                  | doc m%"
                  Stop is the end of a time window in UTC.
                  After or equal to this time, events for this dependency are ignored and
                  Format is hh:mm:ss.
                  If it is smaller than Start, it is treated as next day of Start
                  (e.g.: 22:00:00-01:00:00 means 22:00:00-25:00:00).
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.Trigger" = {
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                  ])
                  | optional,
                policy
                  | definitions.contract."io.argoproj.events.v1alpha1.TriggerPolicy"
                  | optional,
                rateLimit
                  | definitions.contract."io.argoproj.events.v1alpha1.RateLimit"
                  | optional,
                retryStrategy
                  | definitions.contract."io.argoproj.events.v1alpha1.Backoff"
                  | optional,
                template
                  | definitions.contract."io.argoproj.events.v1alpha1.TriggerTemplate"
                  | doc m%"
                  Template describes the trigger specification.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.TriggerParameter" = {
                dest
                  | String
                  | doc m%"
                  Dest is the JSONPath of a resource key.
                  A path is a series of keys separated by a dot. The colon character can be escaped with '.'
                  The -1 key can be used to append a value to an existing array.
                  See https://github.com/tidwall/sjson#path-syntax for more information about how this is used.
                  "%
                  | optional,
                operation
                  | String
                  | doc m%"
                  Operation is what to do with the existing value at Dest, whether to
                  'prepend', 'overwrite', or 'append' it.
                  "%
                  | optional,
                src
                  | definitions.contract."io.argoproj.events.v1alpha1.TriggerParameterSource"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.TriggerParameterSource" = {
                contextKey
                  | String
                  | doc m%"
                  ContextKey is the JSONPath of the event's (JSON decoded) context key
                  ContextKey is a series of keys separated by a dot. A key may contain wildcard characters '*' and '?'.
                  To access an array value use the index as the key. The dot and wildcard characters can be escaped with '\\'.
                  See https://github.com/tidwall/gjson#path-syntax for more information on how to use this.
                  "%
                  | optional,
                contextTemplate | String | optional,
                dataKey
                  | String
                  | doc m%"
                  DataKey is the JSONPath of the event's (JSON decoded) data key
                  DataKey is a series of keys separated by a dot. A key may contain wildcard characters '*' and '?'.
                  To access an array value use the index as the key. The dot and wildcard characters can be escaped with '\\'.
                  See https://github.com/tidwall/gjson#path-syntax for more information on how to use this.
                  "%
                  | optional,
                dataTemplate | String | optional,
                dependencyName
                  | String
                  | doc m%"
                  DependencyName refers to the name of the dependency. The event which is stored for this dependency is used as payload
                  for the parameterization. Make sure to refer to one of the dependencies you have defined under Dependencies list.
                  "%
                  | optional,
                value
                  | String
                  | doc m%"
                  Value is the default literal value to use for this parameter source
                  This is only used if the DataKey is invalid.
                  If the DataKey is invalid and this is not defined, this param source will produce an error.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.TriggerPolicy" = {
                k8s
                  | definitions.contract."io.argoproj.events.v1alpha1.K8SResourcePolicy"
                  | optional,
                status
                  | definitions.contract."io.argoproj.events.v1alpha1.StatusPolicy"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.TriggerTemplate"
            | doc m%"
            TriggerTemplate is the template that describes trigger specification.
            "%
            = {
                argoWorkflow
                  | definitions.contract."io.argoproj.events.v1alpha1.ArgoWorkflowTrigger"
                  | optional,
                awsLambda
                  | definitions.contract."io.argoproj.events.v1alpha1.AWSLambdaTrigger"
                  | optional,
                azureEventHubs
                  | definitions.contract."io.argoproj.events.v1alpha1.AzureEventHubsTrigger"
                  | optional,
                conditions | String | optional,
                conditionsReset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.events.v1alpha1.ConditionsResetCriteria"
                  ])
                  | optional,
                custom
                  | definitions.contract."io.argoproj.events.v1alpha1.CustomTrigger"
                  | optional,
                http
                  | definitions.contract."io.argoproj.events.v1alpha1.HTTPTrigger"
                  | optional,
                k8s
                  | definitions.contract."io.argoproj.events.v1alpha1.StandardK8STrigger"
                  | optional,
                kafka
                  | definitions.contract."io.argoproj.events.v1alpha1.KafkaTrigger"
                  | doc m%"
                  Kafka refers to the trigger designed to place messages on Kafka topic.
                  +optional.
                  "%
                  | optional,
                log
                  | definitions.contract."io.argoproj.events.v1alpha1.LogTrigger"
                  | optional,
                name
                  | String
                  | doc m%"
                  Name is a unique name of the action to take.
                  "%
                  | optional,
                nats
                  | definitions.contract."io.argoproj.events.v1alpha1.NATSTrigger"
                  | doc m%"
                  NATS refers to the trigger designed to place message on NATS subject.
                  +optional.
                  "%
                  | optional,
                openWhisk
                  | definitions.contract."io.argoproj.events.v1alpha1.OpenWhiskTrigger"
                  | optional,
                pulsar
                  | definitions.contract."io.argoproj.events.v1alpha1.PulsarTrigger"
                  | optional,
                slack
                  | definitions.contract."io.argoproj.events.v1alpha1.SlackTrigger"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.URLArtifact"
            | doc m%"
            URLArtifact contains information about an artifact at an http endpoint.
            "%
            = { path | String | optional, verifyCert | Bool | optional, .. },
          "io.argoproj.events.v1alpha1.ValueFromSource" = {
                configMapKeyRef
                  | definitions.contract."io.k8s.api.core.v1.ConfigMapKeySelector"
                  | optional,
                secretKeyRef
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.WatchPathConfig" = {
                directory | String | optional,
                path | String | optional,
                pathRegexp | String | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.WebhookContext" = {
                authSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                endpoint | String | optional,
                maxPayloadSize | String | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                method | String | optional,
                port
                  | String
                  | doc m%"
                  Port on which HTTP server is listening for incoming events.
                  "%
                  | optional,
                serverCertSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  ServerCertPath refers the file that contains the cert.
                  "%
                  | optional,
                serverKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                url
                  | String
                  | doc m%"
                  URL is the url of the server.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.events.v1alpha1.WebhookEventSource" = {
                filter
                  | definitions.contract."io.argoproj.events.v1alpha1.EventSourceFilter"
                  | optional,
                webhookContext
                  | definitions.contract."io.argoproj.events.v1alpha1.WebhookContext"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Amount"
            | doc m%"
            Amount represent a numeric amount.
            "%
            = Number,
          "io.argoproj.workflow.v1alpha1.ArchiveStrategy"
            | doc m%"
            ArchiveStrategy describes how to archive files/directory when saving artifacts
            "%
            = {
                none
                  | definitions.contract."io.argoproj.workflow.v1alpha1.NoneStrategy"
                  | optional,
                tar
                  | definitions.contract."io.argoproj.workflow.v1alpha1.TarStrategy"
                  | optional,
                zip
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ZipStrategy"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArchivedWorkflowDeletedResponse" = {
                
                ..
              },
          "io.argoproj.workflow.v1alpha1.Arguments"
            | doc m%"
            Arguments to a template
            "%
            = {
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Artifact"
                  ])
                  | doc m%"
                  Artifacts is the list of artifacts to pass to the template or workflow
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Parameter"
                  ])
                  | doc m%"
                  Parameters is the list of parameters to pass to the template or workflow
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtGCStatus"
            | doc m%"
            ArtGCStatus maintains state related to ArtifactGC
            "%
            = {
                notSpecified
                  | Bool
                  | doc m%"
                  if this is true, we already checked to see if we need to do it and we don't
                  "%
                  | optional,
                podsRecouped
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"Bool")
                  ])
                  | doc m%"
                  have completed Pods been processed? (mapped by Pod name) used to prevent re-processing the Status of a Pod more than once
                  "%
                  | optional,
                strategiesProcessed
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"Bool")
                  ])
                  | doc m%"
                  have Pods been started to perform this strategy? (enables us not to re-process what we've already done)
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Artifact"
            | doc m%"
            Artifact indicates an artifact to place at a specified path
            "%
            = {
                archive
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArchiveStrategy"
                  | doc m%"
                  Archive controls how the artifact will be saved to the artifact repository.
                  "%
                  | optional,
                archiveLogs
                  | Bool
                  | doc m%"
                  ArchiveLogs indicates if the container logs should be archived
                  "%
                  | optional,
                artifactGC
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtifactGC"
                  | doc m%"
                  ArtifactGC describes the strategy to use when to deleting an artifact from completed or deleted workflows
                  "%
                  | optional,
                artifactory
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtifactoryArtifact"
                  | doc m%"
                  Artifactory contains artifactory artifact location details
                  "%
                  | optional,
                azure
                  | definitions.contract."io.argoproj.workflow.v1alpha1.AzureArtifact"
                  | doc m%"
                  Azure contains Azure Storage artifact location details
                  "%
                  | optional,
                deleted
                  | Bool
                  | doc m%"
                  Has this been deleted?
                  "%
                  | optional,
                from
                  | String
                  | doc m%"
                  From allows an artifact to reference an artifact from a previous step
                  "%
                  | optional,
                fromExpression
                  | String
                  | doc m%"
                  FromExpression, if defined, is evaluated to specify the value for the artifact
                  "%
                  | optional,
                gcs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.GCSArtifact"
                  | doc m%"
                  GCS contains GCS artifact location details
                  "%
                  | optional,
                git
                  | definitions.contract."io.argoproj.workflow.v1alpha1.GitArtifact"
                  | doc m%"
                  Git contains git artifact location details
                  "%
                  | optional,
                globalName
                  | String
                  | doc m%"
                  GlobalName exports an output artifact to the global scope, making it available as '{{io.argoproj.workflow.v1alpha1.outputs.artifacts.XXXX}} and in workflow.status.outputs.artifacts
                  "%
                  | optional,
                hdfs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.HDFSArtifact"
                  | doc m%"
                  HDFS contains HDFS artifact location details
                  "%
                  | optional,
                http
                  | definitions.contract."io.argoproj.workflow.v1alpha1.HTTPArtifact"
                  | doc m%"
                  HTTP contains HTTP artifact location details
                  "%
                  | optional,
                mode
                  | std.number.Integer
                  | doc m%"
                  mode bits to use on this file, must be a value between 0 and 0777 set when loading input artifacts.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  name of the artifact. must be unique within a template's inputs/outputs.
                  "%,
                "optional"
                  | Bool
                  | doc m%"
                  Make Artifacts optional, if Artifacts doesn't generate or exist
                  "%
                  | optional,
                oss
                  | definitions.contract."io.argoproj.workflow.v1alpha1.OSSArtifact"
                  | doc m%"
                  OSS contains OSS artifact location details
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path is the container path to the artifact
                  "%
                  | optional,
                raw
                  | definitions.contract."io.argoproj.workflow.v1alpha1.RawArtifact"
                  | doc m%"
                  Raw contains raw artifact location details
                  "%
                  | optional,
                recurseMode
                  | Bool
                  | doc m%"
                  If mode is set, apply the permission recursively into the artifact if it is a folder
                  "%
                  | optional,
                s3
                  | definitions.contract."io.argoproj.workflow.v1alpha1.S3Artifact"
                  | doc m%"
                  S3 contains S3 artifact location details
                  "%
                  | optional,
                subPath
                  | String
                  | doc m%"
                  SubPath allows an artifact to be sourced from a subpath within the specified source
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactGC"
            | doc m%"
            ArtifactGC describes how to delete artifacts from completed Workflows - this is embedded into the WorkflowLevelArtifactGC, and also used for individual Artifacts to override that as needed
            "%
            = {
                podMetadata
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Metadata"
                  | doc m%"
                  PodMetadata is an optional field for specifying the Labels and Annotations that should be assigned to the Pod doing the deletion
                  "%
                  | optional,
                serviceAccountName
                  | String
                  | doc m%"
                  ServiceAccountName is an optional field for specifying the Service Account that should be assigned to the Pod doing the deletion
                  "%
                  | optional,
                strategy
                  | String
                  | doc m%"
                  Strategy is the strategy to use.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactGCSpec"
            | doc m%"
            ArtifactGCSpec specifies the Artifacts that need to be deleted
            "%
            = {
                artifactsByNode
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactNodeSpec"
                  ])
                  | doc m%"
                  ArtifactsByNode maps Node name to information pertaining to Artifacts on that Node
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactGCStatus"
            | doc m%"
            ArtifactGCStatus describes the result of the deletion
            "%
            = {
                artifactResultsByNode
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactResultNodeStatus"
                  ])
                  | doc m%"
                  ArtifactResultsByNode maps Node name to result
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactLocation"
            | doc m%"
            ArtifactLocation describes a location for a single or multiple artifacts. It is used as single artifact in the context of inputs/outputs (e.g. outputs.artifacts.artname). It is also used to describe the location of multiple artifacts such as the archive location of a single workflow step, which the executor will use as a default location to store its files.
            "%
            = {
                archiveLogs
                  | Bool
                  | doc m%"
                  ArchiveLogs indicates if the container logs should be archived
                  "%
                  | optional,
                artifactory
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtifactoryArtifact"
                  | doc m%"
                  Artifactory contains artifactory artifact location details
                  "%
                  | optional,
                azure
                  | definitions.contract."io.argoproj.workflow.v1alpha1.AzureArtifact"
                  | doc m%"
                  Azure contains Azure Storage artifact location details
                  "%
                  | optional,
                gcs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.GCSArtifact"
                  | doc m%"
                  GCS contains GCS artifact location details
                  "%
                  | optional,
                git
                  | definitions.contract."io.argoproj.workflow.v1alpha1.GitArtifact"
                  | doc m%"
                  Git contains git artifact location details
                  "%
                  | optional,
                hdfs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.HDFSArtifact"
                  | doc m%"
                  HDFS contains HDFS artifact location details
                  "%
                  | optional,
                http
                  | definitions.contract."io.argoproj.workflow.v1alpha1.HTTPArtifact"
                  | doc m%"
                  HTTP contains HTTP artifact location details
                  "%
                  | optional,
                oss
                  | definitions.contract."io.argoproj.workflow.v1alpha1.OSSArtifact"
                  | doc m%"
                  OSS contains OSS artifact location details
                  "%
                  | optional,
                raw
                  | definitions.contract."io.argoproj.workflow.v1alpha1.RawArtifact"
                  | doc m%"
                  Raw contains raw artifact location details
                  "%
                  | optional,
                s3
                  | definitions.contract."io.argoproj.workflow.v1alpha1.S3Artifact"
                  | doc m%"
                  S3 contains S3 artifact location details
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactNodeSpec"
            | doc m%"
            ArtifactNodeSpec specifies the Artifacts that need to be deleted for a given Node
            "%
            = {
                archiveLocation
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtifactLocation"
                  | doc m%"
                  ArchiveLocation is the template-level Artifact location specification
                  "%
                  | optional,
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Artifact"
                  ])
                  | doc m%"
                  Artifacts maps artifact name to Artifact description
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactPaths"
            | doc m%"
            ArtifactPaths expands a step from a collection of artifacts
            "%
            = {
                archive
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArchiveStrategy"
                  | doc m%"
                  Archive controls how the artifact will be saved to the artifact repository.
                  "%
                  | optional,
                archiveLogs
                  | Bool
                  | doc m%"
                  ArchiveLogs indicates if the container logs should be archived
                  "%
                  | optional,
                artifactGC
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtifactGC"
                  | doc m%"
                  ArtifactGC describes the strategy to use when to deleting an artifact from completed or deleted workflows
                  "%
                  | optional,
                artifactory
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtifactoryArtifact"
                  | doc m%"
                  Artifactory contains artifactory artifact location details
                  "%
                  | optional,
                azure
                  | definitions.contract."io.argoproj.workflow.v1alpha1.AzureArtifact"
                  | doc m%"
                  Azure contains Azure Storage artifact location details
                  "%
                  | optional,
                deleted
                  | Bool
                  | doc m%"
                  Has this been deleted?
                  "%
                  | optional,
                from
                  | String
                  | doc m%"
                  From allows an artifact to reference an artifact from a previous step
                  "%
                  | optional,
                fromExpression
                  | String
                  | doc m%"
                  FromExpression, if defined, is evaluated to specify the value for the artifact
                  "%
                  | optional,
                gcs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.GCSArtifact"
                  | doc m%"
                  GCS contains GCS artifact location details
                  "%
                  | optional,
                git
                  | definitions.contract."io.argoproj.workflow.v1alpha1.GitArtifact"
                  | doc m%"
                  Git contains git artifact location details
                  "%
                  | optional,
                globalName
                  | String
                  | doc m%"
                  GlobalName exports an output artifact to the global scope, making it available as '{{io.argoproj.workflow.v1alpha1.outputs.artifacts.XXXX}} and in workflow.status.outputs.artifacts
                  "%
                  | optional,
                hdfs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.HDFSArtifact"
                  | doc m%"
                  HDFS contains HDFS artifact location details
                  "%
                  | optional,
                http
                  | definitions.contract."io.argoproj.workflow.v1alpha1.HTTPArtifact"
                  | doc m%"
                  HTTP contains HTTP artifact location details
                  "%
                  | optional,
                mode
                  | std.number.Integer
                  | doc m%"
                  mode bits to use on this file, must be a value between 0 and 0777 set when loading input artifacts.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  name of the artifact. must be unique within a template's inputs/outputs.
                  "%,
                "optional"
                  | Bool
                  | doc m%"
                  Make Artifacts optional, if Artifacts doesn't generate or exist
                  "%
                  | optional,
                oss
                  | definitions.contract."io.argoproj.workflow.v1alpha1.OSSArtifact"
                  | doc m%"
                  OSS contains OSS artifact location details
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path is the container path to the artifact
                  "%
                  | optional,
                raw
                  | definitions.contract."io.argoproj.workflow.v1alpha1.RawArtifact"
                  | doc m%"
                  Raw contains raw artifact location details
                  "%
                  | optional,
                recurseMode
                  | Bool
                  | doc m%"
                  If mode is set, apply the permission recursively into the artifact if it is a folder
                  "%
                  | optional,
                s3
                  | definitions.contract."io.argoproj.workflow.v1alpha1.S3Artifact"
                  | doc m%"
                  S3 contains S3 artifact location details
                  "%
                  | optional,
                subPath
                  | String
                  | doc m%"
                  SubPath allows an artifact to be sourced from a subpath within the specified source
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactRepository"
            | doc m%"
            ArtifactRepository represents an artifact repository in which a controller will store its artifacts
            "%
            = {
                archiveLogs
                  | Bool
                  | doc m%"
                  ArchiveLogs enables log archiving
                  "%
                  | optional,
                artifactory
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtifactoryArtifactRepository"
                  | doc m%"
                  Artifactory stores artifacts to JFrog Artifactory
                  "%
                  | optional,
                azure
                  | definitions.contract."io.argoproj.workflow.v1alpha1.AzureArtifactRepository"
                  | doc m%"
                  Azure stores artifact in an Azure Storage account
                  "%
                  | optional,
                gcs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.GCSArtifactRepository"
                  | doc m%"
                  GCS stores artifact in a GCS object store
                  "%
                  | optional,
                hdfs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.HDFSArtifactRepository"
                  | doc m%"
                  HDFS stores artifacts in HDFS
                  "%
                  | optional,
                oss
                  | definitions.contract."io.argoproj.workflow.v1alpha1.OSSArtifactRepository"
                  | doc m%"
                  OSS stores artifact in a OSS-compliant object store
                  "%
                  | optional,
                s3
                  | definitions.contract."io.argoproj.workflow.v1alpha1.S3ArtifactRepository"
                  | doc m%"
                  S3 stores artifact in a S3-compliant object store
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactRepositoryRef" = {
                configMap
                  | String
                  | doc m%"
                  The name of the config map. Defaults to "artifact-repositories".
                  "%
                  | optional,
                key
                  | String
                  | doc m%"
                  The config map key. Defaults to the value of the "workflows.argoproj.io/default-artifact-repository" annotation.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactRepositoryRefStatus" = {
                artifactRepository
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtifactRepository"
                  | doc m%"
                  The repository the workflow will use. This maybe empty before v3.1.
                  "%
                  | optional,
                configMap
                  | String
                  | doc m%"
                  The name of the config map. Defaults to "artifact-repositories".
                  "%
                  | optional,
                "default"
                  | Bool
                  | doc m%"
                  If this ref represents the default artifact repository, rather than a config map.
                  "%
                  | optional,
                key
                  | String
                  | doc m%"
                  The config map key. Defaults to the value of the "workflows.argoproj.io/default-artifact-repository" annotation.
                  "%
                  | optional,
                namespace
                  | String
                  | doc m%"
                  The namespace of the config map. Defaults to the workflow's namespace, or the controller's namespace (if found).
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactResult"
            | doc m%"
            ArtifactResult describes the result of attempting to delete a given Artifact
            "%
            = {
                error
                  | String
                  | doc m%"
                  Error is an optional error message which should be set if Success==false
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name is the name of the Artifact
                  "%,
                success
                  | Bool
                  | doc m%"
                  Success describes whether the deletion succeeded
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactResultNodeStatus"
            | doc m%"
            ArtifactResultNodeStatus describes the result of the deletion on a given node
            "%
            = {
                artifactResults
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactResult"
                  ])
                  | doc m%"
                  ArtifactResults maps Artifact name to result of the deletion
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactoryArtifact"
            | doc m%"
            ArtifactoryArtifact is the location of an artifactory artifact
            "%
            = {
                passwordSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  PasswordSecret is the secret selector to the repository password
                  "%
                  | optional,
                url
                  | String
                  | doc m%"
                  URL of the artifact
                  "%,
                usernameSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  UsernameSecret is the secret selector to the repository username
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ArtifactoryArtifactRepository"
            | doc m%"
            ArtifactoryArtifactRepository defines the controller configuration for an artifactory artifact repository
            "%
            = {
                keyFormat
                  | String
                  | doc m%"
                  KeyFormat defines the format of how to store keys and can reference workflow variables.
                  "%
                  | optional,
                passwordSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  PasswordSecret is the secret selector to the repository password
                  "%
                  | optional,
                repoURL
                  | String
                  | doc m%"
                  RepoURL is the url for artifactory repo.
                  "%
                  | optional,
                usernameSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  UsernameSecret is the secret selector to the repository username
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.AzureArtifact"
            | doc m%"
            AzureArtifact is the location of a an Azure Storage artifact
            "%
            = {
                accountKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  AccountKeySecret is the secret selector to the Azure Blob Storage account access key
                  "%
                  | optional,
                blob
                  | String
                  | doc m%"
                  Blob is the blob name (i.e., path) in the container where the artifact resides
                  "%,
                container
                  | String
                  | doc m%"
                  Container is the container where resources will be stored
                  "%,
                endpoint
                  | String
                  | doc m%"
                  Endpoint is the service url associated with an account. It is most likely "https://<ACCOUNT_NAME>.blob.core.windows.net"
                  "%,
                useSDKCreds
                  | Bool
                  | doc m%"
                  UseSDKCreds tells the driver to figure out credentials based on sdk defaults.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.AzureArtifactRepository"
            | doc m%"
            AzureArtifactRepository defines the controller configuration for an Azure Blob Storage artifact repository
            "%
            = {
                accountKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  AccountKeySecret is the secret selector to the Azure Blob Storage account access key
                  "%
                  | optional,
                blobNameFormat
                  | String
                  | doc m%"
                  BlobNameFormat is defines the format of how to store blob names. Can reference workflow variables
                  "%
                  | optional,
                container
                  | String
                  | doc m%"
                  Container is the container where resources will be stored
                  "%,
                endpoint
                  | String
                  | doc m%"
                  Endpoint is the service url associated with an account. It is most likely "https://<ACCOUNT_NAME>.blob.core.windows.net"
                  "%,
                useSDKCreds
                  | Bool
                  | doc m%"
                  UseSDKCreds tells the driver to figure out credentials based on sdk defaults.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Backoff"
            | doc m%"
            Backoff is a backoff strategy to use within retryStrategy
            "%
            = {
                duration
                  | String
                  | doc m%"
                  Duration is the amount to back off. Default unit is seconds, but could also be a duration (e.g. "2m", "1h")
                  "%
                  | optional,
                factor
                  | definitions.contract."io.k8s.apimachinery.pkg.util.intstr.IntOrString"
                  | doc m%"
                  Factor is a factor to multiply the base duration after each failed retry
                  "%
                  | optional,
                maxDuration
                  | String
                  | doc m%"
                  MaxDuration is the maximum amount of time allowed for a workflow in the backoff strategy
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.BasicAuth"
            | doc m%"
            BasicAuth describes the secret selectors required for basic authentication
            "%
            = {
                passwordSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  PasswordSecret is the secret selector to the repository password
                  "%
                  | optional,
                usernameSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  UsernameSecret is the secret selector to the repository username
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Cache"
            | doc m%"
            Cache is the configuration for the type of cache to be used
            "%
            = {
                configMap
                  | definitions.contract."io.k8s.api.core.v1.ConfigMapKeySelector"
                  | doc m%"
                  ConfigMap sets a ConfigMap-based cache
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ClientCertAuth"
            | doc m%"
            ClientCertAuth holds necessary information for client authentication via certificates
            "%
            = {
                clientCertSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                clientKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate"
            | doc m%"
            ClusterWorkflowTemplate is the definition of a workflow template resource in cluster scope
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate",
          "io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplateCreateRequest" =
            {
                createOptions
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions"
                  | optional,
                template
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplateDeleteResponse" =
            {  .. },
          "io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplateLintRequest" = {
                createOptions
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions"
                  | optional,
                template
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplateList"
            | doc m%"
            ClusterWorkflowTemplateList is list of ClusterWorkflowTemplate resources
            "%
            = {
                apiVersion
                  | String
                  | doc m%"
                  APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.io.k8s.community/contributors/devel/sig-architecture/api-conventions.md#resources
                  "%
                  | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate"
                  ]),
                kind
                  | String
                  | doc m%"
                  Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.io.k8s.community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
                  "%
                  | optional,
                metadata
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
                ..
              },
          "io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplateUpdateRequest" =
            {
                name
                  | String
                  | doc m%"
                  DEPRECATED: This field is ignored.
                  "%
                  | optional,
                template
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.CollectEventRequest" = {
                name | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.CollectEventResponse" = {  .. },
          "io.argoproj.workflow.v1alpha1.Column"
            | doc m%"
            Column is a custom column that will be exposed in the Workflow List View.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.argoproj.workflow.v1alpha1.Column",
          "io.argoproj.workflow.v1alpha1.Condition" = {
                message
                  | String
                  | doc m%"
                  Message is the condition message
                  "%
                  | optional,
                status
                  | String
                  | doc m%"
                  Status is the status of the condition
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Type is the type of condition
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ContainerNode" = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Arguments to the entrypoint. The container image's CMD is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced to a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. "$$(VAR_NAME)" will produce the string literal "$(VAR_NAME)". Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
                  "%
                  | optional,
                command
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Entrypoint array. Not executed within a shell. The container image's ENTRYPOINT is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced to a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. "$$(VAR_NAME)" will produce the string literal "$(VAR_NAME)". Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
                  "%
                  | optional,
                dependencies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.EnvVar"
                  ])
                  | doc m%"
                  List of environment variables to set in the container. Cannot be updated.
                  "%
                  | optional,
                envFrom
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.EnvFromSource"
                  ])
                  | doc m%"
                  List of sources to populate environment variables in the container. The keys defined within a source must be a C_IDENTIFIER. All invalid keys will be reported as an event when the container is starting. When a key exists in multiple sources, the value associated with the last source will take precedence. Values defined by an Env with a duplicate key will take precedence. Cannot be updated.
                  "%
                  | optional,
                image
                  | String
                  | doc m%"
                  Container image name. More info: https://kubernetes.io/docs/concepts/containers/images This field is optional to allow higher level config management to default or override container images in workload controllers like Deployments and StatefulSets.
                  "%
                  | optional,
                imagePullPolicy
                  | String
                  | doc m%"
                  Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if :latest tag is specified, or IfNotPresent otherwise. Cannot be updated. More info: https://kubernetes.io/docs/concepts/containers/images#updating-images
                  "%
                  | optional,
                lifecycle
                  | definitions.contract."io.k8s.api.core.v1.Lifecycle"
                  | doc m%"
                  Actions that the management system should take in response to container lifecycle events. Cannot be updated.
                  "%
                  | optional,
                livenessProbe
                  | definitions.contract."io.k8s.api.core.v1.Probe"
                  | doc m%"
                  Periodic probe of container liveness. Container will be restarted if the probe fails. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the container specified as a DNS_LABEL. Each container in a pod must have a unique name (DNS_LABEL). Cannot be updated.
                  "%,
                ports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.ContainerPort"
                  ])
                  | doc m%"
                  List of ports to expose from the container. Exposing a port here gives the system additional information about the network connections a container uses, but is primarily informational. Not specifying a port here DOES NOT prevent that port from being exposed. Any port which is listening on the default "0.0.0.0" address inside a container will be accessible from the network. Cannot be updated.
                  "%
                  | optional,
                readinessProbe
                  | definitions.contract."io.k8s.api.core.v1.Probe"
                  | doc m%"
                  Periodic probe of container service readiness. Container will be removed from service endpoints if the probe fails. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                resources
                  | definitions.contract."io.k8s.api.core.v1.ResourceRequirements"
                  | doc m%"
                  Compute Resources required by this container. Cannot be updated. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
                  "%
                  | optional,
                securityContext
                  | definitions.contract."io.k8s.api.core.v1.SecurityContext"
                  | doc m%"
                  SecurityContext defines the security options the container should be run with. If set, the fields of SecurityContext override the equivalent fields of PodSecurityContext. More info: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
                  "%
                  | optional,
                startupProbe
                  | definitions.contract."io.k8s.api.core.v1.Probe"
                  | doc m%"
                  StartupProbe indicates that the Pod has successfully initialized. If specified, no other probes are executed until this completes successfully. If this probe fails, the Pod will be restarted, just as if the livenessProbe failed. This can be used to provide different probe parameters at the beginning of a Pod's lifecycle, when it might take a long time to load data or warm a cache, than during steady-state operation. This cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                stdin
                  | Bool
                  | doc m%"
                  Whether this container should allocate a buffer for stdin in the container runtime. If this is not set, reads from stdin in the container will always result in EOF. Default is false.
                  "%
                  | optional,
                stdinOnce
                  | Bool
                  | doc m%"
                  Whether the container runtime should close the stdin channel after it has been opened by a single attach. When stdin is true the stdin stream will remain open across multiple attach sessions. If stdinOnce is set to true, stdin is opened on container start, is empty until the first client attaches to stdin, and then remains open and accepts data until the client disconnects, at which time stdin is closed and remains closed until the container is restarted. If this flag is false, a container processes that reads from stdin will never receive an EOF. Default is false
                  "%
                  | optional,
                terminationMessagePath
                  | String
                  | doc m%"
                  Optional: Path at which the file to which the container's termination message will be written is mounted into the container's filesystem. Message written is intended to be brief final status, such as an assertion failure message. Will be truncated by the node if greater than 4096 bytes. The total message length across all containers will be limited to 12kb. Defaults to /dev/termination-log. Cannot be updated.
                  "%
                  | optional,
                terminationMessagePolicy
                  | String
                  | doc m%"
                  Indicate how the termination message should be populated. File will use the contents of terminationMessagePath to populate the container status message on both success and failure. FallbackToLogsOnError will use the last chunk of container log output if the termination message file is empty and the container exited with an error. The log output is limited to 2048 bytes or 80 lines, whichever is smaller. Defaults to File. Cannot be updated.
                  "%
                  | optional,
                tty
                  | Bool
                  | doc m%"
                  Whether this container should allocate a TTY for itself, also requires 'stdin' to be true. Default is false.
                  "%
                  | optional,
                volumeDevices
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.VolumeDevice"
                  ])
                  | doc m%"
                  volumeDevices is the list of block devices to be used by the container.
                  "%
                  | optional,
                volumeMounts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.VolumeMount"
                  ])
                  | doc m%"
                  Pod volumes to mount into the container's filesystem. Cannot be updated.
                  "%
                  | optional,
                workingDir
                  | String
                  | doc m%"
                  Container's working directory. If not specified, the container runtime's default will be used, which might be configured in the container image. Cannot be updated.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ContainerSetRetryStrategy" = {
                duration
                  | String
                  | doc m%"
                  Duration is the time between each retry, examples values are "300ms", "1s" or "5m". Valid time units are "ns", "us" (or "µs"), "ms", "s", "m", "h".
                  "%
                  | optional,
                retries
                  | definitions.contract."io.k8s.apimachinery.pkg.util.intstr.IntOrString"
                  | doc m%"
                  Nbr of retries
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ContainerSetTemplate" = {
                containers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ContainerNode"
                  ]),
                retryStrategy
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ContainerSetRetryStrategy"
                  | doc m%"
                  RetryStrategy describes how to retry a container nodes in the container set if it fails. Nbr of retries(default 0) and sleep duration between retries(default 0s, instant retry) can be set.
                  "%
                  | optional,
                volumeMounts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.VolumeMount"
                  ])
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ContinueOn"
            | doc m%"
            ContinueOn defines if a workflow should continue even if a task or step fails/errors. It can be specified if the workflow should continue when the pod errors, fails or both.
            "%
            = { error | Bool | optional, failed | Bool | optional, .. },
          "io.argoproj.workflow.v1alpha1.Counter"
            | doc m%"
            Counter is a Counter prometheus metric
            "%
            = {
                value
                  | String
                  | doc m%"
                  Value is the value of the metric
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.CreateCronWorkflowRequest" = {
                createOptions
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions"
                  | optional,
                cronWorkflow
                  | definitions.contract."io.argoproj.workflow.v1alpha1.CronWorkflow"
                  | optional,
                namespace | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.CreateS3BucketOptions"
            | doc m%"
            CreateS3BucketOptions options used to determine automatic automatic bucket-creation process
            "%
            = {
                objectLocking
                  | Bool
                  | doc m%"
                  ObjectLocking Enable object locking
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.CronWorkflow"
            | doc m%"
            CronWorkflow is the definition of a scheduled workflow resource
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.argoproj.workflow.v1alpha1.CronWorkflow",
          "io.argoproj.workflow.v1alpha1.CronWorkflowDeletedResponse" = {  .. },
          "io.argoproj.workflow.v1alpha1.CronWorkflowList"
            | doc m%"
            CronWorkflowList is list of CronWorkflow resources
            "%
            = {
                apiVersion
                  | String
                  | doc m%"
                  APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.io.k8s.community/contributors/devel/sig-architecture/api-conventions.md#resources
                  "%
                  | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.CronWorkflow"
                  ]),
                kind
                  | String
                  | doc m%"
                  Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.io.k8s.community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
                  "%
                  | optional,
                metadata
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
                ..
              },
          "io.argoproj.workflow.v1alpha1.CronWorkflowResumeRequest" = {
                name | String | optional,
                namespace | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.CronWorkflowSpec"
            | doc m%"
            CronWorkflowSpec is the specification of a CronWorkflow
            "%
            = {
                concurrencyPolicy
                  | String
                  | doc m%"
                  ConcurrencyPolicy is the K8s-style concurrency policy that will be used
                  "%
                  | optional,
                failedJobsHistoryLimit
                  | std.number.Integer
                  | doc m%"
                  FailedJobsHistoryLimit is the number of failed jobs to be kept at a time
                  "%
                  | optional,
                schedule
                  | String
                  | doc m%"
                  Schedule is a schedule to run the Workflow in Cron format
                  "%,
                startingDeadlineSeconds
                  | std.number.Integer
                  | doc m%"
                  StartingDeadlineSeconds is the K8s-style deadline that will limit the time a CronWorkflow will be run after its original scheduled time if it is missed.
                  "%
                  | optional,
                successfulJobsHistoryLimit
                  | std.number.Integer
                  | doc m%"
                  SuccessfulJobsHistoryLimit is the number of successful jobs to be kept at a time
                  "%
                  | optional,
                suspend
                  | Bool
                  | doc m%"
                  Suspend is a flag that will stop new CronWorkflows from running if set to true
                  "%
                  | optional,
                timezone
                  | String
                  | doc m%"
                  Timezone is the timezone against which the cron schedule will be calculated, e.g. "Asia/Tokyo". Default is machine's local time.
                  "%
                  | optional,
                workflowMetadata
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta"
                  | doc m%"
                  WorkflowMetadata contains some metadata of the workflow to be run
                  "%
                  | optional,
                workflowSpec
                  | definitions.contract."io.argoproj.workflow.v1alpha1.WorkflowSpec"
                  | doc m%"
                  WorkflowSpec is the spec of the workflow to be run
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.CronWorkflowStatus"
            | doc m%"
            CronWorkflowStatus is the status of a CronWorkflow
            "%
            = {
                active
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.ObjectReference"
                  ])
                  | doc m%"
                  Active is a list of active workflows stemming from this CronWorkflow
                  "%,
                conditions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Condition"
                  ])
                  | doc m%"
                  Conditions is a list of conditions the CronWorkflow may have
                  "%,
                lastScheduledTime
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | doc m%"
                  LastScheduleTime is the last time the CronWorkflow was scheduled
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.CronWorkflowSuspendRequest" = {
                name | String | optional,
                namespace | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.DAGTask"
            | doc m%"
            DAGTask represents a node in the graph during DAG execution
            "%
            = {
                arguments
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Arguments"
                  | doc m%"
                  Arguments are the parameter and artifact arguments to the template
                  "%
                  | optional,
                continueOn
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ContinueOn"
                  | doc m%"
                  ContinueOn makes argo to proceed with the following step even if this step fails. Errors and Failed states can be specified
                  "%
                  | optional,
                dependencies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Dependencies are name of other targets which this depends on
                  "%
                  | optional,
                depends
                  | String
                  | doc m%"
                  Depends are name of other targets which this depends on
                  "%
                  | optional,
                hooks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.workflow.v1alpha1.LifecycleHook"
                  ])
                  | doc m%"
                  Hooks hold the lifecycle hook which is invoked at lifecycle of task, irrespective of the success, failure, or error status of the primary task
                  "%
                  | optional,
                inline
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Template"
                  | doc m%"
                  Inline is the template. Template must be empty if this is declared (and vice-versa).
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name is the name of the target
                  "%,
                onExit
                  | String
                  | doc m%"
                  OnExit is a template reference which is invoked at the end of the template, irrespective of the success, failure, or error of the primary template. DEPRECATED: Use Hooks[exit].Template instead.
                  "%
                  | optional,
                template
                  | String
                  | doc m%"
                  Name of template to execute
                  "%
                  | optional,
                templateRef
                  | definitions.contract."io.argoproj.workflow.v1alpha1.TemplateRef"
                  | doc m%"
                  TemplateRef is the reference to the template resource to execute.
                  "%
                  | optional,
                when
                  | String
                  | doc m%"
                  When is an expression in which the task should conditionally execute
                  "%
                  | optional,
                withItems
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Item"
                  ])
                  | doc m%"
                  WithItems expands a task into multiple parallel tasks from the items in the list
                  "%
                  | optional,
                withParam
                  | String
                  | doc m%"
                  WithParam expands a task into multiple parallel tasks from the value in the parameter, which is expected to be a JSON list.
                  "%
                  | optional,
                withSequence
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Sequence"
                  | doc m%"
                  WithSequence expands a task into a numeric sequence
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.DAGTemplate"
            | doc m%"
            DAGTemplate is a template subtype for directed acyclic graph templates
            "%
            = {
                failFast
                  | Bool
                  | doc m%"
                  This flag is for DAG logic. The DAG logic has a built-in "fail fast" feature to stop scheduling new steps, as soon as it detects that one of the DAG nodes is failed. Then it waits until all DAG nodes are completed before failing the DAG itself. The FailFast flag default is true,  if set to false, it will allow a DAG to run all branches of the DAG to completion (either success or failure), regardless of the failed outcomes of branches in the DAG. More info and example about this feature at https://github.com/argoproj/argo-workflows/issues/1442
                  "%
                  | optional,
                target
                  | String
                  | doc m%"
                  Target are one or more names of targets to execute in a DAG
                  "%
                  | optional,
                tasks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.DAGTask"
                  ])
                  | doc m%"
                  Tasks are a list of DAG tasks
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Data"
            | doc m%"
            Data is a data template
            "%
            = {
                source
                  | definitions.contract."io.argoproj.workflow.v1alpha1.DataSource"
                  | doc m%"
                  Source sources external data into a data template
                  "%,
                transformation
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.TransformationStep"
                  ])
                  | doc m%"
                  Transformation applies a set of transformations
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.DataSource"
            | doc m%"
            DataSource sources external data into a data template
            "%
            = {
                artifactPaths
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtifactPaths"
                  | doc m%"
                  ArtifactPaths is a data transformation that collects a list of artifact paths
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Event" = {
                selector
                  | String
                  | doc m%"
                  Selector (https://github.com/antonmedv/expr) that we must must match the io.argoproj.workflow.v1alpha1. E.g. `payload.message == "test"`
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.EventResponse" = {  .. },
          "io.argoproj.workflow.v1alpha1.ExecutorConfig"
            | doc m%"
            ExecutorConfig holds configurations of an executor container.
            "%
            = {
                serviceAccountName
                  | String
                  | doc m%"
                  ServiceAccountName specifies the service account name of the executor container.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.GCSArtifact"
            | doc m%"
            GCSArtifact is the location of a GCS artifact
            "%
            = {
                bucket
                  | String
                  | doc m%"
                  Bucket is the name of the bucket
                  "%
                  | optional,
                key
                  | String
                  | doc m%"
                  Key is the path in the bucket where the artifact resides
                  "%,
                serviceAccountKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  ServiceAccountKeySecret is the secret selector to the bucket's service account key
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.GCSArtifactRepository"
            | doc m%"
            GCSArtifactRepository defines the controller configuration for a GCS artifact repository
            "%
            = {
                bucket
                  | String
                  | doc m%"
                  Bucket is the name of the bucket
                  "%
                  | optional,
                keyFormat
                  | String
                  | doc m%"
                  KeyFormat defines the format of how to store keys and can reference workflow variables.
                  "%
                  | optional,
                serviceAccountKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  ServiceAccountKeySecret is the secret selector to the bucket's service account key
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Gauge"
            | doc m%"
            Gauge is a Gauge prometheus metric
            "%
            = {
                operation
                  | String
                  | doc m%"
                  Operation defines the operation to apply with value and the metrics' current value
                  "%
                  | optional,
                realtime
                  | Bool
                  | doc m%"
                  Realtime emits this metric in real time if applicable
                  "%,
                value
                  | String
                  | doc m%"
                  Value is the value to be used in the operation with the metric's current value. If no operation is set, value is the value of the metric
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.GetUserInfoResponse" = {
                email | String | optional,
                emailVerified | Bool | optional,
                groups
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                issuer | String | optional,
                name | String | optional,
                serviceAccountName | String | optional,
                serviceAccountNamespace | String | optional,
                subject | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.GitArtifact"
            | doc m%"
            GitArtifact is the location of an git artifact
            "%
            = {
                branch
                  | String
                  | doc m%"
                  Branch is the branch to fetch when `SingleBranch` is enabled
                  "%
                  | optional,
                depth
                  | std.number.Integer
                  | doc m%"
                  Depth specifies clones/fetches should be shallow and include the given number of commits from the branch tip
                  "%
                  | optional,
                disableSubmodules
                  | Bool
                  | doc m%"
                  DisableSubmodules disables submodules during git clone
                  "%
                  | optional,
                fetch
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Fetch specifies a number of refs that should be fetched before checkout
                  "%
                  | optional,
                insecureIgnoreHostKey
                  | Bool
                  | doc m%"
                  InsecureIgnoreHostKey disables SSH strict host key checking during git clone
                  "%
                  | optional,
                passwordSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  PasswordSecret is the secret selector to the repository password
                  "%
                  | optional,
                repo
                  | String
                  | doc m%"
                  Repo is the git repository
                  "%,
                revision
                  | String
                  | doc m%"
                  Revision is the git commit, tag, branch to checkout
                  "%
                  | optional,
                singleBranch
                  | Bool
                  | doc m%"
                  SingleBranch enables single branch clone, using the `branch` parameter
                  "%
                  | optional,
                sshPrivateKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  SSHPrivateKeySecret is the secret selector to the repository ssh private key
                  "%
                  | optional,
                usernameSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  UsernameSecret is the secret selector to the repository username
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.HDFSArtifact"
            | doc m%"
            HDFSArtifact is the location of an HDFS artifact
            "%
            = {
                addresses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Addresses is accessible addresses of HDFS name nodes
                  "%
                  | optional,
                "force"
                  | Bool
                  | doc m%"
                  Force copies a file forcibly even if it exists
                  "%
                  | optional,
                hdfsUser
                  | String
                  | doc m%"
                  HDFSUser is the user to access HDFS file system. It is ignored if either ccache or keytab is used.
                  "%
                  | optional,
                krbCCacheSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  KrbCCacheSecret is the secret selector for Kerberos ccache Either ccache or keytab can be set to use Kerberos.
                  "%
                  | optional,
                krbConfigConfigMap
                  | definitions.contract."io.k8s.api.core.v1.ConfigMapKeySelector"
                  | doc m%"
                  KrbConfig is the configmap selector for Kerberos config as string It must be set if either ccache or keytab is used.
                  "%
                  | optional,
                krbKeytabSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  KrbKeytabSecret is the secret selector for Kerberos keytab Either ccache or keytab can be set to use Kerberos.
                  "%
                  | optional,
                krbRealm
                  | String
                  | doc m%"
                  KrbRealm is the Kerberos realm used with Kerberos keytab It must be set if keytab is used.
                  "%
                  | optional,
                krbServicePrincipalName
                  | String
                  | doc m%"
                  KrbServicePrincipalName is the principal name of Kerberos service It must be set if either ccache or keytab is used.
                  "%
                  | optional,
                krbUsername
                  | String
                  | doc m%"
                  KrbUsername is the Kerberos username used with Kerberos keytab It must be set if keytab is used.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path is a file path in HDFS
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.HDFSArtifactRepository"
            | doc m%"
            HDFSArtifactRepository defines the controller configuration for an HDFS artifact repository
            "%
            = {
                addresses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Addresses is accessible addresses of HDFS name nodes
                  "%
                  | optional,
                "force"
                  | Bool
                  | doc m%"
                  Force copies a file forcibly even if it exists
                  "%
                  | optional,
                hdfsUser
                  | String
                  | doc m%"
                  HDFSUser is the user to access HDFS file system. It is ignored if either ccache or keytab is used.
                  "%
                  | optional,
                krbCCacheSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  KrbCCacheSecret is the secret selector for Kerberos ccache Either ccache or keytab can be set to use Kerberos.
                  "%
                  | optional,
                krbConfigConfigMap
                  | definitions.contract."io.k8s.api.core.v1.ConfigMapKeySelector"
                  | doc m%"
                  KrbConfig is the configmap selector for Kerberos config as string It must be set if either ccache or keytab is used.
                  "%
                  | optional,
                krbKeytabSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  KrbKeytabSecret is the secret selector for Kerberos keytab Either ccache or keytab can be set to use Kerberos.
                  "%
                  | optional,
                krbRealm
                  | String
                  | doc m%"
                  KrbRealm is the Kerberos realm used with Kerberos keytab It must be set if keytab is used.
                  "%
                  | optional,
                krbServicePrincipalName
                  | String
                  | doc m%"
                  KrbServicePrincipalName is the principal name of Kerberos service It must be set if either ccache or keytab is used.
                  "%
                  | optional,
                krbUsername
                  | String
                  | doc m%"
                  KrbUsername is the Kerberos username used with Kerberos keytab It must be set if keytab is used.
                  "%
                  | optional,
                pathFormat
                  | String
                  | doc m%"
                  PathFormat is defines the format of path to store a file. Can reference workflow variables
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.HTTP" = {
                body
                  | String
                  | doc m%"
                  Body is content of the HTTP Request
                  "%
                  | optional,
                bodyFrom
                  | definitions.contract."io.argoproj.workflow.v1alpha1.HTTPBodySource"
                  | doc m%"
                  BodyFrom is  content of the HTTP Request as Bytes
                  "%
                  | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.HTTPHeader"
                  ])
                  | doc m%"
                  Headers are an optional list of headers to send with HTTP requests
                  "%
                  | optional,
                insecureSkipVerify
                  | Bool
                  | doc m%"
                  InsecureSkipVerify is a bool when if set to true will skip TLS verification for the HTTP client
                  "%
                  | optional,
                method
                  | String
                  | doc m%"
                  Method is HTTP methods for HTTP Request
                  "%
                  | optional,
                successCondition
                  | String
                  | doc m%"
                  SuccessCondition is an expression if evaluated to true is considered successful
                  "%
                  | optional,
                timeoutSeconds
                  | std.number.Integer
                  | doc m%"
                  TimeoutSeconds is request timeout for HTTP Request. Default is 30 seconds
                  "%
                  | optional,
                url
                  | String
                  | doc m%"
                  URL of the HTTP Request
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.HTTPArtifact"
            | doc m%"
            HTTPArtifact allows a file served on HTTP to be placed as an input artifact in a container
            "%
            = {
                auth
                  | definitions.contract."io.argoproj.workflow.v1alpha1.HTTPAuth"
                  | doc m%"
                  Auth contains information for client authentication
                  "%
                  | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Header"
                  ])
                  | doc m%"
                  Headers are an optional list of headers to send with HTTP requests for artifacts
                  "%
                  | optional,
                url
                  | String
                  | doc m%"
                  URL of the artifact
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.HTTPAuth" = {
                basicAuth
                  | definitions.contract."io.argoproj.workflow.v1alpha1.BasicAuth"
                  | optional,
                clientCert
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ClientCertAuth"
                  | optional,
                oauth2
                  | definitions.contract."io.argoproj.workflow.v1alpha1.OAuth2Auth"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.HTTPBodySource"
            | doc m%"
            HTTPBodySource contains the source of the HTTP body.
            "%
            = { bytes | String | optional, .. },
          "io.argoproj.workflow.v1alpha1.HTTPHeader" = {
                name | String,
                value | String | optional,
                valueFrom
                  | definitions.contract."io.argoproj.workflow.v1alpha1.HTTPHeaderSource"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.HTTPHeaderSource" = {
                secretKeyRef
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Header"
            | doc m%"
            Header indicate a key-value request header to be used when fetching artifacts over HTTP
            "%
            = {
                name
                  | String
                  | doc m%"
                  Name is the header name
                  "%,
                value
                  | String
                  | doc m%"
                  Value is the literal value to use for the header
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Histogram"
            | doc m%"
            Histogram is a Histogram prometheus metric
            "%
            = {
                buckets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Amount"
                  ])
                  | doc m%"
                  Buckets is a list of bucket divisors for the histogram
                  "%,
                value
                  | String
                  | doc m%"
                  Value is the value of the metric
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.InfoResponse" = {
                columns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Column"
                  ])
                  | optional,
                links
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Link"
                  ])
                  | optional,
                managedNamespace | String | optional,
                modals
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"Bool")
                  ])
                  | optional,
                navColor | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Inputs"
            | doc m%"
            Inputs are the mechanism for passing parameters, artifacts, volumes from one template to another
            "%
            = {
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Artifact"
                  ])
                  | doc m%"
                  Artifact are a list of artifacts passed as inputs
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Parameter"
                  ])
                  | doc m%"
                  Parameters are a list of parameters passed as inputs
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Item"
            | doc m%"
            Item expands a single workflow step into multiple parallel steps The value of Item can be a map, string, bool, or number
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.argoproj.workflow.v1alpha1.Item",
          "io.argoproj.workflow.v1alpha1.LabelKeys"
            | doc m%"
            LabelKeys is list of keys
            "%
            = {
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.LabelValueFrom" = {
                expression | String,
                ..
              },
          "io.argoproj.workflow.v1alpha1.LabelValues"
            | doc m%"
            Labels is list of workflow labels
            "%
            = {
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.LifecycleHook" = {
                arguments
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Arguments"
                  | doc m%"
                  Arguments hold arguments to the template
                  "%
                  | optional,
                expression
                  | String
                  | doc m%"
                  Expression is a condition expression for when a node will be retried. If it evaluates to false, the node will not be retried and the retry strategy will be ignored
                  "%
                  | optional,
                template
                  | String
                  | doc m%"
                  Template is the name of the template to execute by the hook
                  "%
                  | optional,
                templateRef
                  | definitions.contract."io.argoproj.workflow.v1alpha1.TemplateRef"
                  | doc m%"
                  TemplateRef is the reference to the template resource to execute by the hook
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Link"
            | doc m%"
            A link to another app.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.argoproj.workflow.v1alpha1.Link",
          "io.argoproj.workflow.v1alpha1.LintCronWorkflowRequest" = {
                cronWorkflow
                  | definitions.contract."io.argoproj.workflow.v1alpha1.CronWorkflow"
                  | optional,
                namespace | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.LogEntry" = {
                content | String | optional,
                podName | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ManifestFrom" = {
                artifact
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Artifact"
                  | doc m%"
                  Artifact contains the artifact to use
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.MemoizationStatus"
            | doc m%"
            MemoizationStatus is the status of this memoized node
            "%
            = {
                cacheName
                  | String
                  | doc m%"
                  Cache is the name of the cache that was used
                  "%,
                hit
                  | Bool
                  | doc m%"
                  Hit indicates whether this node was created from a cache entry
                  "%,
                key
                  | String
                  | doc m%"
                  Key is the name of the key used for this node's cache
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Memoize"
            | doc m%"
            Memoization enables caching for the Outputs of the template
            "%
            = {
                cache
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Cache"
                  | doc m%"
                  Cache sets and configures the kind of cache
                  "%,
                key
                  | String
                  | doc m%"
                  Key is the key to use as the caching key
                  "%,
                maxAge
                  | String
                  | doc m%"
                  MaxAge is the maximum age (e.g. "180s", "24h") of an entry that is still considered valid. If an entry is older than the MaxAge, it will be ignored.
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Metadata"
            | doc m%"
            Pod metdata
            "%
            = {
                annotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.MetricLabel"
            | doc m%"
            MetricLabel is a single label for a prometheus metric
            "%
            = { key | String, value | String, .. },
          "io.argoproj.workflow.v1alpha1.Metrics"
            | doc m%"
            Metrics are a list of metrics emitted from a Workflow/Template
            "%
            = {
                prometheus
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Prometheus"
                  ])
                  | doc m%"
                  Prometheus is a list of prometheus metrics to be emitted
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Mutex"
            | doc m%"
            Mutex holds Mutex configuration
            "%
            = {
                name
                  | String
                  | doc m%"
                  name of the mutex
                  "%
                  | optional,
                namespace
                  | String
                  | doc m%"
                  Namespace is the namespace of the mutex, default: [namespace of workflow]
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.MutexHolding"
            | doc m%"
            MutexHolding describes the mutex and the object which is holding it.
            "%
            = {
                holder
                  | String
                  | doc m%"
                  Holder is a reference to the object which holds the Mutex. Holding Scenario:
                    1. Current workflow's NodeID which is holding the lock.
                       e.g: ${NodeID}
                  Waiting Scenario:
                    1. Current workflow or other workflow NodeID which is holding the lock.
                       e.g: ${WorkflowName}/${NodeID}
                  "%
                  | optional,
                mutex
                  | String
                  | doc m%"
                  Reference for the mutex e.g: ${namespace}/mutex/${mutexName}
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.MutexStatus"
            | doc m%"
            MutexStatus contains which objects hold  mutex locks, and which objects this workflow is waiting on to release locks.
            "%
            = {
                holding
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.MutexHolding"
                  ])
                  | doc m%"
                  Holding is a list of mutexes and their respective objects that are held by mutex lock for this io.argoproj.workflow.v1alpha1.
                  "%
                  | optional,
                waiting
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.MutexHolding"
                  ])
                  | doc m%"
                  Waiting is a list of mutexes and their respective objects this workflow is waiting for.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.NodeFlag" = {
                hooked
                  | Bool
                  | doc m%"
                  Hooked tracks whether or not this node was triggered by hook or onExit
                  "%
                  | optional,
                retried
                  | Bool
                  | doc m%"
                  Retried tracks whether or not this node was retried by retryStrategy
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.NodeResult" = {
                message | String | optional,
                outputs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Outputs"
                  | optional,
                phase | String | optional,
                progress | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.NodeStatus"
            | doc m%"
            NodeStatus contains status information about an individual node in the workflow
            "%
            = {
                boundaryID
                  | String
                  | doc m%"
                  BoundaryID indicates the node ID of the associated template root node in which this node belongs to
                  "%
                  | optional,
                children
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Children is a list of child node IDs
                  "%
                  | optional,
                daemoned
                  | Bool
                  | doc m%"
                  Daemoned tracks whether or not this node was daemoned and need to be terminated
                  "%
                  | optional,
                displayName
                  | String
                  | doc m%"
                  DisplayName is a human readable representation of the node. Unique within a template boundary
                  "%
                  | optional,
                estimatedDuration
                  | std.number.Integer
                  | doc m%"
                  EstimatedDuration in seconds.
                  "%
                  | optional,
                finishedAt
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | doc m%"
                  Time at which this node completed
                  "%
                  | optional,
                hostNodeName
                  | String
                  | doc m%"
                  HostNodeName name of the Kubernetes node on which the Pod is running, if applicable
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  ID is a unique identifier of a node within the worklow It is implemented as a hash of the node name, which makes the ID deterministic
                  "%,
                inputs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Inputs"
                  | doc m%"
                  Inputs captures input parameter values and artifact locations supplied to this template invocation
                  "%
                  | optional,
                memoizationStatus
                  | definitions.contract."io.argoproj.workflow.v1alpha1.MemoizationStatus"
                  | doc m%"
                  MemoizationStatus holds information about cached nodes
                  "%
                  | optional,
                message
                  | String
                  | doc m%"
                  A human readable message indicating details about why the node is in this condition.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name is unique name in the node tree used to generate the node ID
                  "%,
                nodeFlag
                  | definitions.contract."io.argoproj.workflow.v1alpha1.NodeFlag"
                  | doc m%"
                  NodeFlag tracks some history of node. e.g.) hooked, retried, etc.
                  "%
                  | optional,
                outboundNodes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  OutboundNodes tracks the node IDs which are considered "outbound" nodes to a template invocation. For every invocation of a template, there are nodes which we considered as "outbound". Essentially, these are last nodes in the execution sequence to run, before the template is considered completed. These nodes are then connected as parents to a following step.
                  
                  In the case of single pod steps (i.e. container, script, resource templates), this list will be nil since the pod itself is already considered the "outbound" node. In the case of DAGs, outbound nodes are the "target" tasks (tasks with no children). In the case of steps, outbound nodes are all the containers involved in the last step group. NOTE: since templates are composable, the list of outbound nodes are carried upwards when a DAG/steps template invokes another DAG/steps template. In other words, the outbound nodes of a template, will be a superset of the outbound nodes of its last children.
                  "%
                  | optional,
                outputs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Outputs"
                  | doc m%"
                  Outputs captures output parameter values and artifact locations produced by this template invocation
                  "%
                  | optional,
                phase
                  | String
                  | doc m%"
                  Phase a simple, high-level summary of where the node is in its lifecycle. Can be used as a state machine. Will be one of these values "Pending", "Running" before the node is completed, or "Succeeded", "Skipped", "Failed", "Error", or "Omitted" as a final state.
                  "%
                  | optional,
                podIP
                  | String
                  | doc m%"
                  PodIP captures the IP of the pod for daemoned steps
                  "%
                  | optional,
                progress
                  | String
                  | doc m%"
                  Progress to completion
                  "%
                  | optional,
                resourcesDuration
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType 'Integer)
                  ])
                  | doc m%"
                  ResourcesDuration is indicative, but not accurate, resource duration. This is populated when the nodes completes.
                  "%
                  | optional,
                startedAt
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | doc m%"
                  Time at which this node started
                  "%
                  | optional,
                synchronizationStatus
                  | definitions.contract."io.argoproj.workflow.v1alpha1.NodeSynchronizationStatus"
                  | doc m%"
                  SynchronizationStatus is the synchronization status of the node
                  "%
                  | optional,
                templateName
                  | String
                  | doc m%"
                  TemplateName is the template name which this node corresponds to. Not applicable to virtual nodes (e.g. Retry, StepGroup)
                  "%
                  | optional,
                templateRef
                  | definitions.contract."io.argoproj.workflow.v1alpha1.TemplateRef"
                  | doc m%"
                  TemplateRef is the reference to the template resource which this node corresponds to. Not applicable to virtual nodes (e.g. Retry, StepGroup)
                  "%
                  | optional,
                templateScope
                  | String
                  | doc m%"
                  TemplateScope is the template scope in which the template of this node was retrieved.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Type indicates type of node
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.NodeSynchronizationStatus"
            | doc m%"
            NodeSynchronizationStatus stores the status of a node
            "%
            = {
                waiting
                  | String
                  | doc m%"
                  Waiting is the name of the lock that this node is waiting for
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.NoneStrategy"
            | doc m%"
            NoneStrategy indicates to skip tar process and upload the files or directory tree as independent files. Note that if the artifact is a directory, the artifact driver must support the ability to save/load the directory appropriately.
            "%
            = {  .. },
          "io.argoproj.workflow.v1alpha1.OAuth2Auth"
            | doc m%"
            OAuth2Auth holds all information for client authentication via OAuth2 tokens
            "%
            = {
                clientIDSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                clientSecretSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                endpointParams
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.OAuth2EndpointParam"
                  ])
                  | optional,
                scopes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                tokenURLSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.OAuth2EndpointParam"
            | doc m%"
            EndpointParam is for requesting optional fields that should be sent in the oauth request
            "%
            = {
                key
                  | String
                  | doc m%"
                  Name is the header name
                  "%,
                value
                  | String
                  | doc m%"
                  Value is the literal value to use for the header
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.OSSArtifact"
            | doc m%"
            OSSArtifact is the location of an Alibaba Cloud OSS artifact
            "%
            = {
                accessKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  AccessKeySecret is the secret selector to the bucket's access key
                  "%
                  | optional,
                bucket
                  | String
                  | doc m%"
                  Bucket is the name of the bucket
                  "%
                  | optional,
                createBucketIfNotPresent
                  | Bool
                  | doc m%"
                  CreateBucketIfNotPresent tells the driver to attempt to create the OSS bucket for output artifacts, if it doesn't exist
                  "%
                  | optional,
                endpoint
                  | String
                  | doc m%"
                  Endpoint is the hostname of the bucket endpoint
                  "%
                  | optional,
                key
                  | String
                  | doc m%"
                  Key is the path in the bucket where the artifact resides
                  "%,
                lifecycleRule
                  | definitions.contract."io.argoproj.workflow.v1alpha1.OSSLifecycleRule"
                  | doc m%"
                  LifecycleRule specifies how to manage bucket's lifecycle
                  "%
                  | optional,
                secretKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  SecretKeySecret is the secret selector to the bucket's secret key
                  "%
                  | optional,
                securityToken
                  | String
                  | doc m%"
                  SecurityToken is the user's temporary security token. For more details, check out: https://www.alibabacloud.com/help/doc-detail/100624.htm
                  "%
                  | optional,
                useSDKCreds
                  | Bool
                  | doc m%"
                  UseSDKCreds tells the driver to figure out credentials based on sdk defaults.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.OSSArtifactRepository"
            | doc m%"
            OSSArtifactRepository defines the controller configuration for an OSS artifact repository
            "%
            = {
                accessKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  AccessKeySecret is the secret selector to the bucket's access key
                  "%
                  | optional,
                bucket
                  | String
                  | doc m%"
                  Bucket is the name of the bucket
                  "%
                  | optional,
                createBucketIfNotPresent
                  | Bool
                  | doc m%"
                  CreateBucketIfNotPresent tells the driver to attempt to create the OSS bucket for output artifacts, if it doesn't exist
                  "%
                  | optional,
                endpoint
                  | String
                  | doc m%"
                  Endpoint is the hostname of the bucket endpoint
                  "%
                  | optional,
                keyFormat
                  | String
                  | doc m%"
                  KeyFormat defines the format of how to store keys and can reference workflow variables.
                  "%
                  | optional,
                lifecycleRule
                  | definitions.contract."io.argoproj.workflow.v1alpha1.OSSLifecycleRule"
                  | doc m%"
                  LifecycleRule specifies how to manage bucket's lifecycle
                  "%
                  | optional,
                secretKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  SecretKeySecret is the secret selector to the bucket's secret key
                  "%
                  | optional,
                securityToken
                  | String
                  | doc m%"
                  SecurityToken is the user's temporary security token. For more details, check out: https://www.alibabacloud.com/help/doc-detail/100624.htm
                  "%
                  | optional,
                useSDKCreds
                  | Bool
                  | doc m%"
                  UseSDKCreds tells the driver to figure out credentials based on sdk defaults.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.OSSLifecycleRule"
            | doc m%"
            OSSLifecycleRule specifies how to manage bucket's lifecycle
            "%
            = {
                markDeletionAfterDays
                  | std.number.Integer
                  | doc m%"
                  MarkDeletionAfterDays is the number of days before we delete objects in the bucket
                  "%
                  | optional,
                markInfrequentAccessAfterDays
                  | std.number.Integer
                  | doc m%"
                  MarkInfrequentAccessAfterDays is the number of days before we convert the objects in the bucket to Infrequent Access (IA) storage type
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Outputs"
            | doc m%"
            Outputs hold parameters, artifacts, and results from a step
            "%
            = {
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Artifact"
                  ])
                  | doc m%"
                  Artifacts holds the list of output artifacts produced by a step
                  "%
                  | optional,
                exitCode
                  | String
                  | doc m%"
                  ExitCode holds the exit code of a script template
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Parameter"
                  ])
                  | doc m%"
                  Parameters holds the list of output parameters produced by a step
                  "%
                  | optional,
                result
                  | String
                  | doc m%"
                  Result holds the result (stdout) of a script template
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ParallelSteps" =
            predicates.contract_from_predicate
              definitions.predicate."io.argoproj.workflow.v1alpha1.ParallelSteps",
          "io.argoproj.workflow.v1alpha1.Parameter"
            | doc m%"
            Parameter indicate a passed string parameter to a service template with an optional default value
            "%
            = {
                "default"
                  | String
                  | doc m%"
                  Default is the default value to use for an input parameter if a value was not supplied
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description is the parameter description
                  "%
                  | optional,
                enum
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Enum holds a list of string values to choose from, for the actual value of the parameter
                  "%
                  | optional,
                globalName
                  | String
                  | doc m%"
                  GlobalName exports an output parameter to the global scope, making it available as '{{io.argoproj.workflow.v1alpha1.outputs.parameters.XXXX}} and in workflow.status.outputs.parameters
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name is the parameter name
                  "%,
                value
                  | String
                  | doc m%"
                  Value is the literal value to use for the parameter. If specified in the context of an input parameter, the value takes precedence over any passed values
                  "%
                  | optional,
                valueFrom
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ValueFrom"
                  | doc m%"
                  ValueFrom is the source for the output parameter's value
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Plugin"
            | doc m%"
            Plugin is an Object with exactly one key
            "%
            = {  .. },
          "io.argoproj.workflow.v1alpha1.PodGC"
            | doc m%"
            PodGC describes how to delete completed pods as they complete
            "%
            = {
                deleteDelayDuration
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Duration"
                  | doc m%"
                  DeleteDelayDuration specifies the duration before pods in the GC queue get deleted.
                  "%
                  | optional,
                labelSelector
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector"
                  | doc m%"
                  LabelSelector is the label selector to check if the pods match the labels before being added to the pod GC queue.
                  "%
                  | optional,
                strategy
                  | String
                  | doc m%"
                  Strategy is the strategy to use. One of "OnPodCompletion", "OnPodSuccess", "OnWorkflowCompletion", "OnWorkflowSuccess". If unset, does not delete Pods
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Prometheus"
            | doc m%"
            Prometheus is a prometheus metric to be emitted
            "%
            = {
                counter
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Counter"
                  | doc m%"
                  Counter is a counter metric
                  "%
                  | optional,
                gauge
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Gauge"
                  | doc m%"
                  Gauge is a gauge metric
                  "%
                  | optional,
                help
                  | String
                  | doc m%"
                  Help is a string that describes the metric
                  "%,
                histogram
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Histogram"
                  | doc m%"
                  Histogram is a histogram metric
                  "%
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.MetricLabel"
                  ])
                  | doc m%"
                  Labels is a list of metric labels
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name is the name of the metric
                  "%,
                when
                  | String
                  | doc m%"
                  When is a conditional statement that decides when to emit the metric
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.RawArtifact"
            | doc m%"
            RawArtifact allows raw string content to be placed as an artifact in a container
            "%
            = {
                data
                  | String
                  | doc m%"
                  Data is the string contents of the artifact
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ResourceTemplate"
            | doc m%"
            ResourceTemplate is a template subtype to manipulate kubernetes resources
            "%
            = {
                action
                  | String
                  | doc m%"
                  Action is the action to perform to the resource. Must be one of: get, create, apply, delete, replace, patch
                  "%,
                failureCondition
                  | String
                  | doc m%"
                  FailureCondition is a label selector expression which describes the conditions of the k8s resource in which the step was considered failed
                  "%
                  | optional,
                flags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Flags is a set of additional options passed to kubectl before submitting a resource I.e. to disable resource validation: flags: [
                  	"--validate=false"  # disable resource validation
                  ]
                  "%
                  | optional,
                manifest
                  | String
                  | doc m%"
                  Manifest contains the kubernetes manifest
                  "%
                  | optional,
                manifestFrom
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ManifestFrom"
                  | doc m%"
                  ManifestFrom is the source for a single kubernetes manifest
                  "%
                  | optional,
                mergeStrategy
                  | String
                  | doc m%"
                  MergeStrategy is the strategy used to merge a patch. It defaults to "strategic" Must be one of: strategic, merge, json
                  "%
                  | optional,
                setOwnerReference
                  | Bool
                  | doc m%"
                  SetOwnerReference sets the reference to the workflow on the OwnerReference of generated resource.
                  "%
                  | optional,
                successCondition
                  | String
                  | doc m%"
                  SuccessCondition is a label selector expression which describes the conditions of the k8s resource in which it is acceptable to proceed to the following step
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ResubmitArchivedWorkflowRequest" = {
                memoized | Bool | optional,
                name | String | optional,
                namespace | String | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                uid | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.RetryAffinity"
            | doc m%"
            RetryAffinity prevents running steps on the same host.
            "%
            = {
                nodeAntiAffinity
                  | definitions.contract."io.argoproj.workflow.v1alpha1.RetryNodeAntiAffinity"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.RetryArchivedWorkflowRequest" = {
                name | String | optional,
                namespace | String | optional,
                nodeFieldSelector | String | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                restartSuccessful | Bool | optional,
                uid | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.RetryNodeAntiAffinity"
            | doc m%"
            RetryNodeAntiAffinity is a placeholder for future expansion, only empty nodeAntiAffinity is allowed. In order to prevent running steps on the same host, it uses "kubernetes.io/hostname".
            "%
            = {  .. },
          "io.argoproj.workflow.v1alpha1.RetryStrategy"
            | doc m%"
            RetryStrategy provides controls on how to retry a workflow step
            "%
            = {
                affinity
                  | definitions.contract."io.argoproj.workflow.v1alpha1.RetryAffinity"
                  | doc m%"
                  Affinity prevents running workflow's step on the same host
                  "%
                  | optional,
                backoff
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Backoff"
                  | doc m%"
                  Backoff is a backoff strategy
                  "%
                  | optional,
                expression
                  | String
                  | doc m%"
                  Expression is a condition expression for when a node will be retried. If it evaluates to false, the node will not be retried and the retry strategy will be ignored
                  "%
                  | optional,
                limit
                  | definitions.contract."io.k8s.apimachinery.pkg.util.intstr.IntOrString"
                  | doc m%"
                  Limit is the maximum number of retry attempts when retrying a container. It does not include the original container; the maximum number of total attempts will be `limit + 1`.
                  "%
                  | optional,
                retryPolicy
                  | String
                  | doc m%"
                  RetryPolicy is a policy of NodePhase statuses that will be retried
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.S3Artifact"
            | doc m%"
            S3Artifact is the location of an S3 artifact
            "%
            = {
                accessKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  AccessKeySecret is the secret selector to the bucket's access key
                  "%
                  | optional,
                bucket
                  | String
                  | doc m%"
                  Bucket is the name of the bucket
                  "%
                  | optional,
                caSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  CASecret specifies the secret that contains the CA, used to verify the TLS connection
                  "%
                  | optional,
                createBucketIfNotPresent
                  | definitions.contract."io.argoproj.workflow.v1alpha1.CreateS3BucketOptions"
                  | doc m%"
                  CreateBucketIfNotPresent tells the driver to attempt to create the S3 bucket for output artifacts, if it doesn't exist. Setting Enabled Encryption will apply either SSE-S3 to the bucket if KmsKeyId is not set or SSE-KMS if it is.
                  "%
                  | optional,
                encryptionOptions
                  | definitions.contract."io.argoproj.workflow.v1alpha1.S3EncryptionOptions"
                  | optional,
                endpoint
                  | String
                  | doc m%"
                  Endpoint is the hostname of the bucket endpoint
                  "%
                  | optional,
                insecure
                  | Bool
                  | doc m%"
                  Insecure will connect to the service with TLS
                  "%
                  | optional,
                key
                  | String
                  | doc m%"
                  Key is the key in the bucket where the artifact resides
                  "%
                  | optional,
                region
                  | String
                  | doc m%"
                  Region contains the optional bucket region
                  "%
                  | optional,
                roleARN
                  | String
                  | doc m%"
                  RoleARN is the Amazon Resource Name (ARN) of the role to assume.
                  "%
                  | optional,
                secretKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  SecretKeySecret is the secret selector to the bucket's secret key
                  "%
                  | optional,
                useSDKCreds
                  | Bool
                  | doc m%"
                  UseSDKCreds tells the driver to figure out credentials based on sdk defaults.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.S3ArtifactRepository"
            | doc m%"
            S3ArtifactRepository defines the controller configuration for an S3 artifact repository
            "%
            = {
                accessKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  AccessKeySecret is the secret selector to the bucket's access key
                  "%
                  | optional,
                bucket
                  | String
                  | doc m%"
                  Bucket is the name of the bucket
                  "%
                  | optional,
                caSecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  CASecret specifies the secret that contains the CA, used to verify the TLS connection
                  "%
                  | optional,
                createBucketIfNotPresent
                  | definitions.contract."io.argoproj.workflow.v1alpha1.CreateS3BucketOptions"
                  | doc m%"
                  CreateBucketIfNotPresent tells the driver to attempt to create the S3 bucket for output artifacts, if it doesn't exist. Setting Enabled Encryption will apply either SSE-S3 to the bucket if KmsKeyId is not set or SSE-KMS if it is.
                  "%
                  | optional,
                encryptionOptions
                  | definitions.contract."io.argoproj.workflow.v1alpha1.S3EncryptionOptions"
                  | optional,
                endpoint
                  | String
                  | doc m%"
                  Endpoint is the hostname of the bucket endpoint
                  "%
                  | optional,
                insecure
                  | Bool
                  | doc m%"
                  Insecure will connect to the service with TLS
                  "%
                  | optional,
                keyFormat
                  | String
                  | doc m%"
                  KeyFormat defines the format of how to store keys and can reference workflow variables.
                  "%
                  | optional,
                keyPrefix
                  | String
                  | doc m%"
                  KeyPrefix is prefix used as part of the bucket key in which the controller will store artifacts. DEPRECATED. Use KeyFormat instead
                  "%
                  | optional,
                region
                  | String
                  | doc m%"
                  Region contains the optional bucket region
                  "%
                  | optional,
                roleARN
                  | String
                  | doc m%"
                  RoleARN is the Amazon Resource Name (ARN) of the role to assume.
                  "%
                  | optional,
                secretKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  SecretKeySecret is the secret selector to the bucket's secret key
                  "%
                  | optional,
                useSDKCreds
                  | Bool
                  | doc m%"
                  UseSDKCreds tells the driver to figure out credentials based on sdk defaults.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.S3EncryptionOptions"
            | doc m%"
            S3EncryptionOptions used to determine encryption options during s3 operations
            "%
            = {
                enableEncryption
                  | Bool
                  | doc m%"
                  EnableEncryption tells the driver to encrypt objects if set to true. If kmsKeyId and serverSideCustomerKeySecret are not set, SSE-S3 will be used
                  "%
                  | optional,
                kmsEncryptionContext
                  | String
                  | doc m%"
                  KmsEncryptionContext is a json blob that contains an encryption context. See https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#encrypt_context for more information
                  "%
                  | optional,
                kmsKeyId
                  | String
                  | doc m%"
                  KMSKeyId tells the driver to encrypt the object using the specified KMS Key.
                  "%
                  | optional,
                serverSideCustomerKeySecret
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  ServerSideCustomerKeySecret tells the driver to encrypt the output artifacts using SSE-C with the specified secret.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ScriptTemplate"
            | doc m%"
            ScriptTemplate is a template subtype to enable scripting through code steps
            "%
            = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Arguments to the entrypoint. The container image's CMD is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced to a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. "$$(VAR_NAME)" will produce the string literal "$(VAR_NAME)". Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
                  "%
                  | optional,
                command
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Entrypoint array. Not executed within a shell. The container image's ENTRYPOINT is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced to a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. "$$(VAR_NAME)" will produce the string literal "$(VAR_NAME)". Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.EnvVar"
                  ])
                  | doc m%"
                  List of environment variables to set in the container. Cannot be updated.
                  "%
                  | optional,
                envFrom
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.EnvFromSource"
                  ])
                  | doc m%"
                  List of sources to populate environment variables in the container. The keys defined within a source must be a C_IDENTIFIER. All invalid keys will be reported as an event when the container is starting. When a key exists in multiple sources, the value associated with the last source will take precedence. Values defined by an Env with a duplicate key will take precedence. Cannot be updated.
                  "%
                  | optional,
                image
                  | String
                  | doc m%"
                  Container image name. More info: https://kubernetes.io/docs/concepts/containers/images This field is optional to allow higher level config management to default or override container images in workload controllers like Deployments and StatefulSets.
                  "%,
                imagePullPolicy
                  | String
                  | doc m%"
                  Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if :latest tag is specified, or IfNotPresent otherwise. Cannot be updated. More info: https://kubernetes.io/docs/concepts/containers/images#updating-images
                  "%
                  | optional,
                lifecycle
                  | definitions.contract."io.k8s.api.core.v1.Lifecycle"
                  | doc m%"
                  Actions that the management system should take in response to container lifecycle events. Cannot be updated.
                  "%
                  | optional,
                livenessProbe
                  | definitions.contract."io.k8s.api.core.v1.Probe"
                  | doc m%"
                  Periodic probe of container liveness. Container will be restarted if the probe fails. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the container specified as a DNS_LABEL. Each container in a pod must have a unique name (DNS_LABEL). Cannot be updated.
                  "%
                  | optional,
                ports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.ContainerPort"
                  ])
                  | doc m%"
                  List of ports to expose from the container. Exposing a port here gives the system additional information about the network connections a container uses, but is primarily informational. Not specifying a port here DOES NOT prevent that port from being exposed. Any port which is listening on the default "0.0.0.0" address inside a container will be accessible from the network. Cannot be updated.
                  "%
                  | optional,
                readinessProbe
                  | definitions.contract."io.k8s.api.core.v1.Probe"
                  | doc m%"
                  Periodic probe of container service readiness. Container will be removed from service endpoints if the probe fails. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                resources
                  | definitions.contract."io.k8s.api.core.v1.ResourceRequirements"
                  | doc m%"
                  Compute Resources required by this container. Cannot be updated. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
                  "%
                  | optional,
                securityContext
                  | definitions.contract."io.k8s.api.core.v1.SecurityContext"
                  | doc m%"
                  SecurityContext defines the security options the container should be run with. If set, the fields of SecurityContext override the equivalent fields of PodSecurityContext. More info: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
                  "%
                  | optional,
                source
                  | String
                  | doc m%"
                  Source contains the source code of the script to execute
                  "%,
                startupProbe
                  | definitions.contract."io.k8s.api.core.v1.Probe"
                  | doc m%"
                  StartupProbe indicates that the Pod has successfully initialized. If specified, no other probes are executed until this completes successfully. If this probe fails, the Pod will be restarted, just as if the livenessProbe failed. This can be used to provide different probe parameters at the beginning of a Pod's lifecycle, when it might take a long time to load data or warm a cache, than during steady-state operation. This cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                stdin
                  | Bool
                  | doc m%"
                  Whether this container should allocate a buffer for stdin in the container runtime. If this is not set, reads from stdin in the container will always result in EOF. Default is false.
                  "%
                  | optional,
                stdinOnce
                  | Bool
                  | doc m%"
                  Whether the container runtime should close the stdin channel after it has been opened by a single attach. When stdin is true the stdin stream will remain open across multiple attach sessions. If stdinOnce is set to true, stdin is opened on container start, is empty until the first client attaches to stdin, and then remains open and accepts data until the client disconnects, at which time stdin is closed and remains closed until the container is restarted. If this flag is false, a container processes that reads from stdin will never receive an EOF. Default is false
                  "%
                  | optional,
                terminationMessagePath
                  | String
                  | doc m%"
                  Optional: Path at which the file to which the container's termination message will be written is mounted into the container's filesystem. Message written is intended to be brief final status, such as an assertion failure message. Will be truncated by the node if greater than 4096 bytes. The total message length across all containers will be limited to 12kb. Defaults to /dev/termination-log. Cannot be updated.
                  "%
                  | optional,
                terminationMessagePolicy
                  | String
                  | doc m%"
                  Indicate how the termination message should be populated. File will use the contents of terminationMessagePath to populate the container status message on both success and failure. FallbackToLogsOnError will use the last chunk of container log output if the termination message file is empty and the container exited with an error. The log output is limited to 2048 bytes or 80 lines, whichever is smaller. Defaults to File. Cannot be updated.
                  "%
                  | optional,
                tty
                  | Bool
                  | doc m%"
                  Whether this container should allocate a TTY for itself, also requires 'stdin' to be true. Default is false.
                  "%
                  | optional,
                volumeDevices
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.VolumeDevice"
                  ])
                  | doc m%"
                  volumeDevices is the list of block devices to be used by the container.
                  "%
                  | optional,
                volumeMounts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.VolumeMount"
                  ])
                  | doc m%"
                  Pod volumes to mount into the container's filesystem. Cannot be updated.
                  "%
                  | optional,
                workingDir
                  | String
                  | doc m%"
                  Container's working directory. If not specified, the container runtime's default will be used, which might be configured in the container image. Cannot be updated.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.SemaphoreHolding" = {
                holders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Holders stores the list of current holder names in the io.argoproj.workflow.v1alpha1.
                  "%
                  | optional,
                semaphore
                  | String
                  | doc m%"
                  Semaphore stores the semaphore name.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.SemaphoreRef"
            | doc m%"
            SemaphoreRef is a reference of Semaphore
            "%
            = {
                configMapKeyRef
                  | definitions.contract."io.k8s.api.core.v1.ConfigMapKeySelector"
                  | doc m%"
                  ConfigMapKeyRef is configmap selector for Semaphore configuration
                  "%
                  | optional,
                namespace
                  | String
                  | doc m%"
                  Namespace is the namespace of the configmap, default: [namespace of workflow]
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.SemaphoreStatus" = {
                holding
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.SemaphoreHolding"
                  ])
                  | doc m%"
                  Holding stores the list of resource acquired synchronization lock for workflows.
                  "%
                  | optional,
                waiting
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.SemaphoreHolding"
                  ])
                  | doc m%"
                  Waiting indicates the list of current synchronization lock holders.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Sequence"
            | doc m%"
            Sequence expands a workflow step into numeric range
            "%
            = {
                count
                  | definitions.contract."io.k8s.apimachinery.pkg.util.intstr.IntOrString"
                  | doc m%"
                  Count is number of elements in the sequence (default: 0). Not to be used with end
                  "%
                  | optional,
                end
                  | definitions.contract."io.k8s.apimachinery.pkg.util.intstr.IntOrString"
                  | doc m%"
                  Number at which to end the sequence (default: 0). Not to be used with Count
                  "%
                  | optional,
                format
                  | String
                  | doc m%"
                  Format is a printf format string to format the value in the sequence
                  "%
                  | optional,
                start
                  | definitions.contract."io.k8s.apimachinery.pkg.util.intstr.IntOrString"
                  | doc m%"
                  Number at which to start the sequence (default: 0)
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Submit" = {
                arguments
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Arguments"
                  | doc m%"
                  Arguments extracted from the event and then set as arguments to the workflow created.
                  "%
                  | optional,
                metadata
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta"
                  | doc m%"
                  Metadata optional means to customize select fields of the workflow metadata
                  "%
                  | optional,
                workflowTemplateRef
                  | definitions.contract."io.argoproj.workflow.v1alpha1.WorkflowTemplateRef"
                  | doc m%"
                  WorkflowTemplateRef the workflow template to submit
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.SubmitOpts"
            | doc m%"
            SubmitOpts are workflow submission options
            "%
            = {
                annotations
                  | String
                  | doc m%"
                  Annotations adds to metadata.labels
                  "%
                  | optional,
                dryRun
                  | Bool
                  | doc m%"
                  DryRun validates the workflow on the client-side without creating it. This option is not supported in API
                  "%
                  | optional,
                entryPoint
                  | String
                  | doc m%"
                  Entrypoint overrides spec.entrypoint
                  "%
                  | optional,
                generateName
                  | String
                  | doc m%"
                  GenerateName overrides metadata.generateName
                  "%
                  | optional,
                labels
                  | String
                  | doc m%"
                  Labels adds to metadata.labels
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name overrides metadata.name
                  "%
                  | optional,
                ownerReference
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.OwnerReference"
                  | doc m%"
                  OwnerReference creates a metadata.ownerReference
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Parameters passes input parameters to workflow
                  "%
                  | optional,
                podPriorityClassName
                  | String
                  | doc m%"
                  Set the podPriorityClassName of the workflow
                  "%
                  | optional,
                "priority"
                  | std.number.Integer
                  | doc m%"
                  Priority is used if controller is configured to process limited number of workflows in parallel, higher priority workflows are processed first.
                  "%
                  | optional,
                serverDryRun
                  | Bool
                  | doc m%"
                  ServerDryRun validates the workflow on the server-side without creating it
                  "%
                  | optional,
                serviceAccount
                  | String
                  | doc m%"
                  ServiceAccount runs all pods in the workflow using specified ServiceAccount.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.SuppliedValueFrom"
            | doc m%"
            SuppliedValueFrom is a placeholder for a value to be filled in directly, either through the CLI, API, etc.
            "%
            = {  .. },
          "io.argoproj.workflow.v1alpha1.SuspendTemplate"
            | doc m%"
            SuspendTemplate is a template subtype to suspend a workflow at a predetermined point in time
            "%
            = {
                duration
                  | String
                  | doc m%"
                  Duration is the seconds to wait before automatically resuming a template. Must be a string. Default unit is seconds. Could also be a Duration, e.g.: "2m", "6h"
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Synchronization"
            | doc m%"
            Synchronization holds synchronization lock configuration
            "%
            = {
                mutex
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Mutex"
                  | doc m%"
                  Mutex holds the Mutex lock details
                  "%
                  | optional,
                semaphore
                  | definitions.contract."io.argoproj.workflow.v1alpha1.SemaphoreRef"
                  | doc m%"
                  Semaphore holds the Semaphore configuration
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.SynchronizationStatus"
            | doc m%"
            SynchronizationStatus stores the status of semaphore and mutex.
            "%
            = {
                mutex
                  | definitions.contract."io.argoproj.workflow.v1alpha1.MutexStatus"
                  | doc m%"
                  Mutex stores this workflow's mutex holder details
                  "%
                  | optional,
                semaphore
                  | definitions.contract."io.argoproj.workflow.v1alpha1.SemaphoreStatus"
                  | doc m%"
                  Semaphore stores this workflow's Semaphore holder details
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.TTLStrategy"
            | doc m%"
            TTLStrategy is the strategy for the time to live depending on if the workflow succeeded or failed
            "%
            = {
                secondsAfterCompletion
                  | std.number.Integer
                  | doc m%"
                  SecondsAfterCompletion is the number of seconds to live after completion
                  "%
                  | optional,
                secondsAfterFailure
                  | std.number.Integer
                  | doc m%"
                  SecondsAfterFailure is the number of seconds to live after failure
                  "%
                  | optional,
                secondsAfterSuccess
                  | std.number.Integer
                  | doc m%"
                  SecondsAfterSuccess is the number of seconds to live after success
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.TarStrategy"
            | doc m%"
            TarStrategy will tar and gzip the file or directory when saving
            "%
            = {
                compressionLevel
                  | std.number.Integer
                  | doc m%"
                  CompressionLevel specifies the gzip compression level to use for the artifact. Defaults to gzip.DefaultCompression.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Template"
            | doc m%"
            Template is a reusable and composable unit of execution in a workflow
            "%
            = {
                activeDeadlineSeconds
                  | definitions.contract."io.k8s.apimachinery.pkg.util.intstr.IntOrString"
                  | doc m%"
                  Optional duration in seconds relative to the StartTime that the pod may be active on a node before the system actively tries to terminate the pod; value must be positive integer This field is only applicable to container and script templates.
                  "%
                  | optional,
                affinity
                  | definitions.contract."io.k8s.api.core.v1.Affinity"
                  | doc m%"
                  Affinity sets the pod's scheduling constraints Overrides the affinity set at the workflow level (if any)
                  "%
                  | optional,
                archiveLocation
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtifactLocation"
                  | doc m%"
                  Location in which all files related to the step will be stored (logs, artifacts, etc...). Can be overridden by individual items in Outputs. If omitted, will use the default artifact repository location configured in the controller, appended with the <workflowname>/<nodename> in the key.
                  "%
                  | optional,
                automountServiceAccountToken
                  | Bool
                  | doc m%"
                  AutomountServiceAccountToken indicates whether a service account token should be automatically mounted in pods. ServiceAccountName of ExecutorConfig must be specified if this value is false.
                  "%
                  | optional,
                container
                  | definitions.contract."io.k8s.api.core.v1.Container"
                  | doc m%"
                  Container is the main container image to run in the pod
                  "%
                  | optional,
                containerSet
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ContainerSetTemplate"
                  | doc m%"
                  ContainerSet groups multiple containers within a single pod.
                  "%
                  | optional,
                daemon
                  | Bool
                  | doc m%"
                  Daemon will allow a workflow to proceed to the next step so long as the container reaches readiness
                  "%
                  | optional,
                dag
                  | definitions.contract."io.argoproj.workflow.v1alpha1.DAGTemplate"
                  | doc m%"
                  DAG template subtype which runs a DAG
                  "%
                  | optional,
                data
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Data"
                  | doc m%"
                  Data is a data template
                  "%
                  | optional,
                executor
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ExecutorConfig"
                  | doc m%"
                  Executor holds configurations of the executor container.
                  "%
                  | optional,
                failFast
                  | Bool
                  | doc m%"
                  FailFast, if specified, will fail this template if any of its child pods has failed. This is useful for when this template is expanded with `withItems`, etc.
                  "%
                  | optional,
                hostAliases
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.HostAlias"
                  ])
                  | doc m%"
                  HostAliases is an optional list of hosts and IPs that will be injected into the pod spec
                  "%
                  | optional,
                http
                  | definitions.contract."io.argoproj.workflow.v1alpha1.HTTP"
                  | doc m%"
                  HTTP makes a HTTP request
                  "%
                  | optional,
                initContainers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.UserContainer"
                  ])
                  | doc m%"
                  InitContainers is a list of containers which run before the main container.
                  "%
                  | optional,
                inputs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Inputs"
                  | doc m%"
                  Inputs describe what inputs parameters and artifacts are supplied to this template
                  "%
                  | optional,
                memoize
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Memoize"
                  | doc m%"
                  Memoize allows templates to use outputs generated from already executed templates
                  "%
                  | optional,
                metadata
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Metadata"
                  | doc m%"
                  Metdata sets the pods's metadata, i.e. annotations and labels
                  "%
                  | optional,
                metrics
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Metrics"
                  | doc m%"
                  Metrics are a list of metrics emitted from this template
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name is the name of the template
                  "%
                  | optional,
                nodeSelector
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  NodeSelector is a selector to schedule this step of the workflow to be run on the selected node(s). Overrides the selector set at the workflow level.
                  "%
                  | optional,
                outputs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Outputs"
                  | doc m%"
                  Outputs describe the parameters and artifacts that this template produces
                  "%
                  | optional,
                parallelism
                  | std.number.Integer
                  | doc m%"
                  Parallelism limits the max total parallel pods that can execute at the same time within the boundaries of this template invocation. If additional steps/dag templates are invoked, the pods created by those templates will not be counted towards this total.
                  "%
                  | optional,
                plugin
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Plugin"
                  | doc m%"
                  Plugin is a plugin template
                  "%
                  | optional,
                podSpecPatch
                  | String
                  | doc m%"
                  PodSpecPatch holds strategic merge patch to apply against the pod spec. Allows parameterization of container fields which are not strings (e.g. resource limits).
                  "%
                  | optional,
                "priority"
                  | std.number.Integer
                  | doc m%"
                  Priority to apply to workflow pods.
                  "%
                  | optional,
                priorityClassName
                  | String
                  | doc m%"
                  PriorityClassName to apply to workflow pods.
                  "%
                  | optional,
                resource
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ResourceTemplate"
                  | doc m%"
                  Resource template subtype which can run k8s resources
                  "%
                  | optional,
                retryStrategy
                  | definitions.contract."io.argoproj.workflow.v1alpha1.RetryStrategy"
                  | doc m%"
                  RetryStrategy describes how to retry a template when it fails
                  "%
                  | optional,
                schedulerName
                  | String
                  | doc m%"
                  If specified, the pod will be dispatched by specified scheduler. Or it will be dispatched by workflow scope scheduler if specified. If neither specified, the pod will be dispatched by default scheduler.
                  "%
                  | optional,
                script
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ScriptTemplate"
                  | doc m%"
                  Script runs a portion of code against an interpreter
                  "%
                  | optional,
                securityContext
                  | definitions.contract."io.k8s.api.core.v1.PodSecurityContext"
                  | doc m%"
                  SecurityContext holds pod-level security attributes and common container settings. Optional: Defaults to empty.  See type description for default values of each field.
                  "%
                  | optional,
                serviceAccountName
                  | String
                  | doc m%"
                  ServiceAccountName to apply to workflow pods
                  "%
                  | optional,
                sidecars
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.UserContainer"
                  ])
                  | doc m%"
                  Sidecars is a list of containers which run alongside the main container Sidecars are automatically killed when the main container completes
                  "%
                  | optional,
                steps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ParallelSteps"
                  ])
                  | doc m%"
                  Steps define a series of sequential/parallel workflow steps
                  "%
                  | optional,
                suspend
                  | definitions.contract."io.argoproj.workflow.v1alpha1.SuspendTemplate"
                  | doc m%"
                  Suspend template subtype which can suspend a workflow when reaching the step
                  "%
                  | optional,
                synchronization
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Synchronization"
                  | doc m%"
                  Synchronization holds synchronization lock configuration for this template
                  "%
                  | optional,
                timeout
                  | String
                  | doc m%"
                  Timeout allows to set the total node execution timeout duration counting from the node's start time. This duration also includes time in which the node spends in Pending state. This duration may not be applied to Step or DAG templates.
                  "%
                  | optional,
                tolerations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.Toleration"
                  ])
                  | doc m%"
                  Tolerations to apply to workflow pods.
                  "%
                  | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.Volume"
                  ])
                  | doc m%"
                  Volumes is a list of volumes that can be mounted by containers in a template.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.TemplateRef"
            | doc m%"
            TemplateRef is a reference of template resource.
            "%
            = {
                clusterScope
                  | Bool
                  | doc m%"
                  ClusterScope indicates the referred template is cluster scoped (i.e. a ClusterWorkflowTemplate).
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name is the resource name of the template.
                  "%
                  | optional,
                template
                  | String
                  | doc m%"
                  Template is the name of referred template in the resource.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.TransformationStep" = {
                expression
                  | String
                  | doc m%"
                  Expression defines an expr expression to apply
                  "%,
                ..
              },
          "io.argoproj.workflow.v1alpha1.UpdateCronWorkflowRequest" = {
                cronWorkflow
                  | definitions.contract."io.argoproj.workflow.v1alpha1.CronWorkflow"
                  | optional,
                name
                  | String
                  | doc m%"
                  DEPRECATED: This field is ignored.
                  "%
                  | optional,
                namespace | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.UserContainer"
            | doc m%"
            UserContainer is a container specified by a user.
            "%
            = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Arguments to the entrypoint. The container image's CMD is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced to a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. "$$(VAR_NAME)" will produce the string literal "$(VAR_NAME)". Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
                  "%
                  | optional,
                command
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Entrypoint array. Not executed within a shell. The container image's ENTRYPOINT is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced to a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. "$$(VAR_NAME)" will produce the string literal "$(VAR_NAME)". Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.EnvVar"
                  ])
                  | doc m%"
                  List of environment variables to set in the container. Cannot be updated.
                  "%
                  | optional,
                envFrom
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.EnvFromSource"
                  ])
                  | doc m%"
                  List of sources to populate environment variables in the container. The keys defined within a source must be a C_IDENTIFIER. All invalid keys will be reported as an event when the container is starting. When a key exists in multiple sources, the value associated with the last source will take precedence. Values defined by an Env with a duplicate key will take precedence. Cannot be updated.
                  "%
                  | optional,
                image
                  | String
                  | doc m%"
                  Container image name. More info: https://kubernetes.io/docs/concepts/containers/images This field is optional to allow higher level config management to default or override container images in workload controllers like Deployments and StatefulSets.
                  "%
                  | optional,
                imagePullPolicy
                  | String
                  | doc m%"
                  Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if :latest tag is specified, or IfNotPresent otherwise. Cannot be updated. More info: https://kubernetes.io/docs/concepts/containers/images#updating-images
                  "%
                  | optional,
                lifecycle
                  | definitions.contract."io.k8s.api.core.v1.Lifecycle"
                  | doc m%"
                  Actions that the management system should take in response to container lifecycle events. Cannot be updated.
                  "%
                  | optional,
                livenessProbe
                  | definitions.contract."io.k8s.api.core.v1.Probe"
                  | doc m%"
                  Periodic probe of container liveness. Container will be restarted if the probe fails. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                mirrorVolumeMounts
                  | Bool
                  | doc m%"
                  MirrorVolumeMounts will mount the same volumes specified in the main container to the container (including artifacts), at the same mountPaths. This enables dind daemon to partially see the same filesystem as the main container in order to use features such as docker volume binding
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the container specified as a DNS_LABEL. Each container in a pod must have a unique name (DNS_LABEL). Cannot be updated.
                  "%,
                ports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.ContainerPort"
                  ])
                  | doc m%"
                  List of ports to expose from the container. Exposing a port here gives the system additional information about the network connections a container uses, but is primarily informational. Not specifying a port here DOES NOT prevent that port from being exposed. Any port which is listening on the default "0.0.0.0" address inside a container will be accessible from the network. Cannot be updated.
                  "%
                  | optional,
                readinessProbe
                  | definitions.contract."io.k8s.api.core.v1.Probe"
                  | doc m%"
                  Periodic probe of container service readiness. Container will be removed from service endpoints if the probe fails. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                resources
                  | definitions.contract."io.k8s.api.core.v1.ResourceRequirements"
                  | doc m%"
                  Compute Resources required by this container. Cannot be updated. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
                  "%
                  | optional,
                securityContext
                  | definitions.contract."io.k8s.api.core.v1.SecurityContext"
                  | doc m%"
                  SecurityContext defines the security options the container should be run with. If set, the fields of SecurityContext override the equivalent fields of PodSecurityContext. More info: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
                  "%
                  | optional,
                startupProbe
                  | definitions.contract."io.k8s.api.core.v1.Probe"
                  | doc m%"
                  StartupProbe indicates that the Pod has successfully initialized. If specified, no other probes are executed until this completes successfully. If this probe fails, the Pod will be restarted, just as if the livenessProbe failed. This can be used to provide different probe parameters at the beginning of a Pod's lifecycle, when it might take a long time to load data or warm a cache, than during steady-state operation. This cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                stdin
                  | Bool
                  | doc m%"
                  Whether this container should allocate a buffer for stdin in the container runtime. If this is not set, reads from stdin in the container will always result in EOF. Default is false.
                  "%
                  | optional,
                stdinOnce
                  | Bool
                  | doc m%"
                  Whether the container runtime should close the stdin channel after it has been opened by a single attach. When stdin is true the stdin stream will remain open across multiple attach sessions. If stdinOnce is set to true, stdin is opened on container start, is empty until the first client attaches to stdin, and then remains open and accepts data until the client disconnects, at which time stdin is closed and remains closed until the container is restarted. If this flag is false, a container processes that reads from stdin will never receive an EOF. Default is false
                  "%
                  | optional,
                terminationMessagePath
                  | String
                  | doc m%"
                  Optional: Path at which the file to which the container's termination message will be written is mounted into the container's filesystem. Message written is intended to be brief final status, such as an assertion failure message. Will be truncated by the node if greater than 4096 bytes. The total message length across all containers will be limited to 12kb. Defaults to /dev/termination-log. Cannot be updated.
                  "%
                  | optional,
                terminationMessagePolicy
                  | String
                  | doc m%"
                  Indicate how the termination message should be populated. File will use the contents of terminationMessagePath to populate the container status message on both success and failure. FallbackToLogsOnError will use the last chunk of container log output if the termination message file is empty and the container exited with an error. The log output is limited to 2048 bytes or 80 lines, whichever is smaller. Defaults to File. Cannot be updated.
                  "%
                  | optional,
                tty
                  | Bool
                  | doc m%"
                  Whether this container should allocate a TTY for itself, also requires 'stdin' to be true. Default is false.
                  "%
                  | optional,
                volumeDevices
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.VolumeDevice"
                  ])
                  | doc m%"
                  volumeDevices is the list of block devices to be used by the container.
                  "%
                  | optional,
                volumeMounts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.VolumeMount"
                  ])
                  | doc m%"
                  Pod volumes to mount into the container's filesystem. Cannot be updated.
                  "%
                  | optional,
                workingDir
                  | String
                  | doc m%"
                  Container's working directory. If not specified, the container runtime's default will be used, which might be configured in the container image. Cannot be updated.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ValueFrom"
            | doc m%"
            ValueFrom describes a location in which to obtain the value to a parameter
            "%
            = {
                configMapKeyRef
                  | definitions.contract."io.k8s.api.core.v1.ConfigMapKeySelector"
                  | doc m%"
                  ConfigMapKeyRef is configmap selector for input parameter configuration
                  "%
                  | optional,
                "default"
                  | String
                  | doc m%"
                  Default specifies a value to be used if retrieving the value from the specified source fails
                  "%
                  | optional,
                event
                  | String
                  | doc m%"
                  Selector (https://github.com/antonmedv/expr) that is evaluated against the event to get the value of the parameter. E.g. `payload.message`
                  "%
                  | optional,
                expression
                  | String
                  | doc m%"
                  Expression, if defined, is evaluated to specify the value for the parameter
                  "%
                  | optional,
                jqFilter
                  | String
                  | doc m%"
                  JQFilter expression against the resource object in resource templates
                  "%
                  | optional,
                jsonPath
                  | String
                  | doc m%"
                  JSONPath of a resource to retrieve an output parameter value from in resource templates
                  "%
                  | optional,
                parameter
                  | String
                  | doc m%"
                  Parameter reference to a step or dag task in which to retrieve an output parameter value from (e.g. '{{steps.mystep.outputs.myparam}}')
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path in the container to retrieve an output parameter value from in container templates
                  "%
                  | optional,
                supplied
                  | definitions.contract."io.argoproj.workflow.v1alpha1.SuppliedValueFrom"
                  | doc m%"
                  Supplied value to be filled in directly, either through the CLI, API, etc.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Version" = {
                buildDate | String,
                compiler | String,
                gitCommit | String,
                gitTag | String,
                gitTreeState | String,
                goVersion | String,
                platform | String,
                version | String,
                ..
              },
          "io.argoproj.workflow.v1alpha1.VolumeClaimGC"
            | doc m%"
            VolumeClaimGC describes how to delete volumes from completed Workflows
            "%
            = {
                strategy
                  | String
                  | doc m%"
                  Strategy is the strategy to use. One of "OnWorkflowCompletion", "OnWorkflowSuccess". Defaults to "OnWorkflowSuccess"
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.Workflow"
            | doc m%"
            Workflow is the definition of a workflow resource
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.argoproj.workflow.v1alpha1.Workflow",
          "io.argoproj.workflow.v1alpha1.WorkflowCreateRequest" = {
                createOptions
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions"
                  | optional,
                instanceID
                  | String
                  | doc m%"
                  This field is no longer used.
                  "%
                  | optional,
                namespace | String | optional,
                serverDryRun | Bool | optional,
                workflow
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Workflow"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowDeleteResponse" = {  .. },
          "io.argoproj.workflow.v1alpha1.WorkflowEventBinding"
            | doc m%"
            WorkflowEventBinding is the definition of an event resource
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowEventBinding",
          "io.argoproj.workflow.v1alpha1.WorkflowEventBindingList"
            | doc m%"
            WorkflowEventBindingList is list of event resources
            "%
            = {
                apiVersion
                  | String
                  | doc m%"
                  APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.io.k8s.community/contributors/devel/sig-architecture/api-conventions.md#resources
                  "%
                  | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowEventBinding"
                  ]),
                kind
                  | String
                  | doc m%"
                  Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.io.k8s.community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
                  "%
                  | optional,
                metadata
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowEventBindingSpec" = {
                event
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Event"
                  | doc m%"
                  Event is the event to bind to
                  "%,
                submit
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Submit"
                  | doc m%"
                  Submit is the workflow template to submit
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowLevelArtifactGC"
            | doc m%"
            WorkflowLevelArtifactGC describes how to delete artifacts from completed Workflows - this spec is used on the Workflow level
            "%
            = {
                forceFinalizerRemoval
                  | Bool
                  | doc m%"
                  ForceFinalizerRemoval: if set to true, the finalizer will be removed in the case that Artifact GC fails
                  "%
                  | optional,
                podMetadata
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Metadata"
                  | doc m%"
                  PodMetadata is an optional field for specifying the Labels and Annotations that should be assigned to the Pod doing the deletion
                  "%
                  | optional,
                podSpecPatch
                  | String
                  | doc m%"
                  PodSpecPatch holds strategic merge patch to apply against the artgc pod spec.
                  "%
                  | optional,
                serviceAccountName
                  | String
                  | doc m%"
                  ServiceAccountName is an optional field for specifying the Service Account that should be assigned to the Pod doing the deletion
                  "%
                  | optional,
                strategy
                  | String
                  | doc m%"
                  Strategy is the strategy to use.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowLintRequest" = {
                namespace | String | optional,
                workflow
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Workflow"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowList"
            | doc m%"
            WorkflowList is list of Workflow resources
            "%
            = {
                apiVersion
                  | String
                  | doc m%"
                  APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.io.k8s.community/contributors/devel/sig-architecture/api-conventions.md#resources
                  "%
                  | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Workflow"
                  ]),
                kind
                  | String
                  | doc m%"
                  Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.io.k8s.community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
                  "%
                  | optional,
                metadata
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowMetadata" = {
                annotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                labelsFrom
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.workflow.v1alpha1.LabelValueFrom"
                  ])
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowResubmitRequest" = {
                memoized | Bool | optional,
                name | String | optional,
                namespace | String | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowResumeRequest" = {
                name | String | optional,
                namespace | String | optional,
                nodeFieldSelector | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowRetryRequest" = {
                name | String | optional,
                namespace | String | optional,
                nodeFieldSelector | String | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                restartSuccessful | Bool | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowSetRequest" = {
                message | String | optional,
                name | String | optional,
                namespace | String | optional,
                nodeFieldSelector | String | optional,
                outputParameters | String | optional,
                phase | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowSpec"
            | doc m%"
            WorkflowSpec is the specification of a Workflow.
            "%
            = {
                activeDeadlineSeconds
                  | std.number.Integer
                  | doc m%"
                  Optional duration in seconds relative to the workflow start time which the workflow is allowed to run before the controller terminates the io.argoproj.workflow.v1alpha1. A value of zero is used to terminate a Running workflow
                  "%
                  | optional,
                affinity
                  | definitions.contract."io.k8s.api.core.v1.Affinity"
                  | doc m%"
                  Affinity sets the scheduling constraints for all pods in the io.argoproj.workflow.v1alpha1. Can be overridden by an affinity specified in the template
                  "%
                  | optional,
                archiveLogs
                  | Bool
                  | doc m%"
                  ArchiveLogs indicates if the container logs should be archived
                  "%
                  | optional,
                arguments
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Arguments"
                  | doc m%"
                  Arguments contain the parameters and artifacts sent to the workflow entrypoint Parameters are referencable globally using the 'workflow' variable prefix. e.g. {{io.argoproj.workflow.v1alpha1.parameters.myparam}}
                  "%
                  | optional,
                artifactGC
                  | definitions.contract."io.argoproj.workflow.v1alpha1.WorkflowLevelArtifactGC"
                  | doc m%"
                  ArtifactGC describes the strategy to use when deleting artifacts from completed or deleted workflows (applies to all output Artifacts unless Artifact.ArtifactGC is specified, which overrides this)
                  "%
                  | optional,
                artifactRepositoryRef
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtifactRepositoryRef"
                  | doc m%"
                  ArtifactRepositoryRef specifies the configMap name and key containing the artifact repository config.
                  "%
                  | optional,
                automountServiceAccountToken
                  | Bool
                  | doc m%"
                  AutomountServiceAccountToken indicates whether a service account token should be automatically mounted in pods. ServiceAccountName of ExecutorConfig must be specified if this value is false.
                  "%
                  | optional,
                dnsConfig
                  | definitions.contract."io.k8s.api.core.v1.PodDNSConfig"
                  | doc m%"
                  PodDNSConfig defines the DNS parameters of a pod in addition to those generated from DNSPolicy.
                  "%
                  | optional,
                dnsPolicy
                  | String
                  | doc m%"
                  Set DNS policy for the pod. Defaults to "ClusterFirst". Valid values are 'ClusterFirstWithHostNet', 'ClusterFirst', 'Default' or 'None'. DNS parameters given in DNSConfig will be merged with the policy selected with DNSPolicy. To have DNS options set along with hostNetwork, you have to specify DNS policy explicitly to 'ClusterFirstWithHostNet'.
                  "%
                  | optional,
                entrypoint
                  | String
                  | doc m%"
                  Entrypoint is a template reference to the starting point of the io.argoproj.workflow.v1alpha1.
                  "%
                  | optional,
                executor
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ExecutorConfig"
                  | doc m%"
                  Executor holds configurations of executor containers of the io.argoproj.workflow.v1alpha1.
                  "%
                  | optional,
                hooks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.workflow.v1alpha1.LifecycleHook"
                  ])
                  | doc m%"
                  Hooks holds the lifecycle hook which is invoked at lifecycle of step, irrespective of the success, failure, or error status of the primary step
                  "%
                  | optional,
                hostAliases
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.HostAlias"
                  ])
                  | optional,
                hostNetwork
                  | Bool
                  | doc m%"
                  Host networking requested for this workflow pod. Default to false.
                  "%
                  | optional,
                imagePullSecrets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.LocalObjectReference"
                  ])
                  | doc m%"
                  ImagePullSecrets is a list of references to secrets in the same namespace to use for pulling any images in pods that reference this ServiceAccount. ImagePullSecrets are distinct from Secrets because Secrets can be mounted in the pod, but ImagePullSecrets are only accessed by the kubelet. More info: https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod
                  "%
                  | optional,
                metrics
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Metrics"
                  | doc m%"
                  Metrics are a list of metrics emitted from this Workflow
                  "%
                  | optional,
                nodeSelector
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  NodeSelector is a selector which will result in all pods of the workflow to be scheduled on the selected node(s). This is able to be overridden by a nodeSelector specified in the template.
                  "%
                  | optional,
                onExit
                  | String
                  | doc m%"
                  OnExit is a template reference which is invoked at the end of the workflow, irrespective of the success, failure, or error of the primary io.argoproj.workflow.v1alpha1.
                  "%
                  | optional,
                parallelism
                  | std.number.Integer
                  | doc m%"
                  Parallelism limits the max total parallel pods that can execute at the same time in a workflow
                  "%
                  | optional,
                podDisruptionBudget
                  | definitions.contract."io.k8s.api.policy.v1.PodDisruptionBudgetSpec"
                  | doc m%"
                  PodDisruptionBudget holds the number of concurrent disruptions that you allow for Workflow's Pods. Controller will automatically add the selector with workflow name, if selector is empty. Optional: Defaults to empty.
                  "%
                  | optional,
                podGC
                  | definitions.contract."io.argoproj.workflow.v1alpha1.PodGC"
                  | doc m%"
                  PodGC describes the strategy to use when deleting completed pods
                  "%
                  | optional,
                podMetadata
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Metadata"
                  | doc m%"
                  PodMetadata defines additional metadata that should be applied to workflow pods
                  "%
                  | optional,
                podPriority
                  | std.number.Integer
                  | doc m%"
                  Priority to apply to workflow pods. DEPRECATED: Use PodPriorityClassName instead.
                  "%
                  | optional,
                podPriorityClassName
                  | String
                  | doc m%"
                  PriorityClassName to apply to workflow pods.
                  "%
                  | optional,
                podSpecPatch
                  | String
                  | doc m%"
                  PodSpecPatch holds strategic merge patch to apply against the pod spec. Allows parameterization of container fields which are not strings (e.g. resource limits).
                  "%
                  | optional,
                "priority"
                  | std.number.Integer
                  | doc m%"
                  Priority is used if controller is configured to process limited number of workflows in parallel. Workflows with higher priority are processed first.
                  "%
                  | optional,
                retryStrategy
                  | definitions.contract."io.argoproj.workflow.v1alpha1.RetryStrategy"
                  | doc m%"
                  RetryStrategy for all templates in the io.argoproj.workflow.v1alpha1.
                  "%
                  | optional,
                schedulerName
                  | String
                  | doc m%"
                  Set scheduler name for all pods. Will be overridden if container/script template's scheduler name is set. Default scheduler will be used if neither specified.
                  "%
                  | optional,
                securityContext
                  | definitions.contract."io.k8s.api.core.v1.PodSecurityContext"
                  | doc m%"
                  SecurityContext holds pod-level security attributes and common container settings. Optional: Defaults to empty.  See type description for default values of each field.
                  "%
                  | optional,
                serviceAccountName
                  | String
                  | doc m%"
                  ServiceAccountName is the name of the ServiceAccount to run all pods of the workflow as.
                  "%
                  | optional,
                shutdown
                  | String
                  | doc m%"
                  Shutdown will shutdown the workflow according to its ShutdownStrategy
                  "%
                  | optional,
                suspend
                  | Bool
                  | doc m%"
                  Suspend will suspend the workflow and prevent execution of any future steps in the workflow
                  "%
                  | optional,
                synchronization
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Synchronization"
                  | doc m%"
                  Synchronization holds synchronization lock configuration for this Workflow
                  "%
                  | optional,
                templateDefaults
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Template"
                  | doc m%"
                  TemplateDefaults holds default template values that will apply to all templates in the Workflow, unless overridden on the template-level
                  "%
                  | optional,
                templates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Template"
                  ])
                  | doc m%"
                  Templates is a list of workflow templates used in a workflow
                  "%
                  | optional,
                tolerations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.Toleration"
                  ])
                  | doc m%"
                  Tolerations to apply to workflow pods.
                  "%
                  | optional,
                ttlStrategy
                  | definitions.contract."io.argoproj.workflow.v1alpha1.TTLStrategy"
                  | doc m%"
                  TTLStrategy limits the lifetime of a Workflow that has finished execution depending on if it Succeeded or Failed. If this struct is set, once the Workflow finishes, it will be deleted after the time to live expires. If this field is unset, the controller config map will hold the default values.
                  "%
                  | optional,
                volumeClaimGC
                  | definitions.contract."io.argoproj.workflow.v1alpha1.VolumeClaimGC"
                  | doc m%"
                  VolumeClaimGC describes the strategy to use when deleting volumes from completed workflows
                  "%
                  | optional,
                volumeClaimTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.PersistentVolumeClaim"
                  ])
                  | doc m%"
                  VolumeClaimTemplates is a list of claims that containers are allowed to reference. The Workflow controller will create the claims at the beginning of the workflow and delete the claims upon completion of the workflow
                  "%
                  | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.Volume"
                  ])
                  | doc m%"
                  Volumes is a list of volumes that can be mounted by containers in a io.argoproj.workflow.v1alpha1.
                  "%
                  | optional,
                workflowMetadata
                  | definitions.contract."io.argoproj.workflow.v1alpha1.WorkflowMetadata"
                  | doc m%"
                  WorkflowMetadata contains some metadata of the workflow to refer to
                  "%
                  | optional,
                workflowTemplateRef
                  | definitions.contract."io.argoproj.workflow.v1alpha1.WorkflowTemplateRef"
                  | doc m%"
                  WorkflowTemplateRef holds a reference to a WorkflowTemplate for execution
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowStatus"
            | doc m%"
            WorkflowStatus contains overall status information about a workflow
            "%
            = {
                artifactGCStatus
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtGCStatus"
                  | doc m%"
                  ArtifactGCStatus maintains the status of Artifact Garbage Collection
                  "%
                  | optional,
                artifactRepositoryRef
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ArtifactRepositoryRefStatus"
                  | doc m%"
                  ArtifactRepositoryRef is used to cache the repository to use so we do not need to determine it everytime we reconcile.
                  "%
                  | optional,
                compressedNodes
                  | String
                  | doc m%"
                  Compressed and base64 decoded Nodes map
                  "%
                  | optional,
                conditions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Condition"
                  ])
                  | doc m%"
                  Conditions is a list of conditions the Workflow may have
                  "%
                  | optional,
                estimatedDuration
                  | std.number.Integer
                  | doc m%"
                  EstimatedDuration in seconds.
                  "%
                  | optional,
                finishedAt
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | doc m%"
                  Time at which this workflow completed
                  "%
                  | optional,
                message
                  | String
                  | doc m%"
                  A human readable message indicating details about why the workflow is in this condition.
                  "%
                  | optional,
                nodes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.workflow.v1alpha1.NodeStatus"
                  ])
                  | doc m%"
                  Nodes is a mapping between a node ID and the node's status.
                  "%
                  | optional,
                offloadNodeStatusVersion
                  | String
                  | doc m%"
                  Whether on not node status has been offloaded to a database. If exists, then Nodes and CompressedNodes will be empty. This will actually be populated with a hash of the offloaded data.
                  "%
                  | optional,
                outputs
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Outputs"
                  | doc m%"
                  Outputs captures output values and artifact locations produced by the workflow via global outputs
                  "%
                  | optional,
                persistentVolumeClaims
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.Volume"
                  ])
                  | doc m%"
                  PersistentVolumeClaims tracks all PVCs that were created as part of the io.argoproj.workflow.v1alpha1. The contents of this list are drained at the end of the workflow.
                  "%
                  | optional,
                phase
                  | String
                  | doc m%"
                  Phase a simple, high-level summary of where the workflow is in its lifecycle. Will be "" (Unknown), "Pending", or "Running" before the workflow is completed, and "Succeeded", "Failed" or "Error" once the workflow has completed.
                  "%
                  | optional,
                progress
                  | String
                  | doc m%"
                  Progress to completion
                  "%
                  | optional,
                resourcesDuration
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType 'Integer)
                  ])
                  | doc m%"
                  ResourcesDuration is the total for the workflow
                  "%
                  | optional,
                startedAt
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | doc m%"
                  Time at which this workflow started
                  "%
                  | optional,
                storedTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Template"
                  ])
                  | doc m%"
                  StoredTemplates is a mapping between a template ref and the node's status.
                  "%
                  | optional,
                storedWorkflowTemplateSpec
                  | definitions.contract."io.argoproj.workflow.v1alpha1.WorkflowSpec"
                  | doc m%"
                  StoredWorkflowSpec stores the WorkflowTemplate spec for future execution.
                  "%
                  | optional,
                synchronization
                  | definitions.contract."io.argoproj.workflow.v1alpha1.SynchronizationStatus"
                  | doc m%"
                  Synchronization stores the status of synchronization locks
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowStep"
            | doc m%"
            WorkflowStep is a reference to a template to execute in a series of step
            "%
            = {
                arguments
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Arguments"
                  | doc m%"
                  Arguments hold arguments to the template
                  "%
                  | optional,
                continueOn
                  | definitions.contract."io.argoproj.workflow.v1alpha1.ContinueOn"
                  | doc m%"
                  ContinueOn makes argo to proceed with the following step even if this step fails. Errors and Failed states can be specified
                  "%
                  | optional,
                hooks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.workflow.v1alpha1.LifecycleHook"
                  ])
                  | doc m%"
                  Hooks holds the lifecycle hook which is invoked at lifecycle of step, irrespective of the success, failure, or error status of the primary step
                  "%
                  | optional,
                inline
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Template"
                  | doc m%"
                  Inline is the template. Template must be empty if this is declared (and vice-versa).
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the step
                  "%
                  | optional,
                onExit
                  | String
                  | doc m%"
                  OnExit is a template reference which is invoked at the end of the template, irrespective of the success, failure, or error of the primary template. DEPRECATED: Use Hooks[exit].Template instead.
                  "%
                  | optional,
                template
                  | String
                  | doc m%"
                  Template is the name of the template to execute as the step
                  "%
                  | optional,
                templateRef
                  | definitions.contract."io.argoproj.workflow.v1alpha1.TemplateRef"
                  | doc m%"
                  TemplateRef is the reference to the template resource to execute as the step.
                  "%
                  | optional,
                when
                  | String
                  | doc m%"
                  When is an expression in which the step should conditionally execute
                  "%
                  | optional,
                withItems
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Item"
                  ])
                  | doc m%"
                  WithItems expands a step into multiple parallel steps from the items in the list
                  "%
                  | optional,
                withParam
                  | String
                  | doc m%"
                  WithParam expands a step into multiple parallel steps from the value in the parameter, which is expected to be a JSON list.
                  "%
                  | optional,
                withSequence
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Sequence"
                  | doc m%"
                  WithSequence expands a step into a numeric sequence
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowStopRequest" = {
                message | String | optional,
                name | String | optional,
                namespace | String | optional,
                nodeFieldSelector | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowSubmitRequest" = {
                namespace | String | optional,
                resourceKind | String | optional,
                resourceName | String | optional,
                submitOptions
                  | definitions.contract."io.argoproj.workflow.v1alpha1.SubmitOpts"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowSuspendRequest" = {
                name | String | optional,
                namespace | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowTaskSetSpec" = {
                tasks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Template"
                  ])
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowTaskSetStatus" = {
                nodes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.argoproj.workflow.v1alpha1.NodeResult"
                  ])
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowTemplate"
            | doc m%"
            WorkflowTemplate is the definition of a workflow template resource
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowTemplate",
          "io.argoproj.workflow.v1alpha1.WorkflowTemplateCreateRequest" = {
                createOptions
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions"
                  | optional,
                namespace | String | optional,
                template
                  | definitions.contract."io.argoproj.workflow.v1alpha1.WorkflowTemplate"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowTemplateDeleteResponse" = {
                
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowTemplateLintRequest" = {
                createOptions
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions"
                  | optional,
                namespace | String | optional,
                template
                  | definitions.contract."io.argoproj.workflow.v1alpha1.WorkflowTemplate"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowTemplateList"
            | doc m%"
            WorkflowTemplateList is list of WorkflowTemplate resources
            "%
            = {
                apiVersion
                  | String
                  | doc m%"
                  APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.io.k8s.community/contributors/devel/sig-architecture/api-conventions.md#resources
                  "%
                  | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowTemplate"
                  ]),
                kind
                  | String
                  | doc m%"
                  Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.io.k8s.community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
                  "%
                  | optional,
                metadata
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowTemplateRef"
            | doc m%"
            WorkflowTemplateRef is a reference to a WorkflowTemplate resource.
            "%
            = {
                clusterScope
                  | Bool
                  | doc m%"
                  ClusterScope indicates the referred template is cluster scoped (i.e. a ClusterWorkflowTemplate).
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name is the resource name of the workflow template.
                  "%
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowTemplateUpdateRequest" = {
                name
                  | String
                  | doc m%"
                  DEPRECATED: This field is ignored.
                  "%
                  | optional,
                namespace | String | optional,
                template
                  | definitions.contract."io.argoproj.workflow.v1alpha1.WorkflowTemplate"
                  | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowTerminateRequest" = {
                name | String | optional,
                namespace | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.WorkflowWatchEvent" = {
                object
                  | definitions.contract."io.argoproj.workflow.v1alpha1.Workflow"
                  | optional,
                type | String | optional,
                ..
              },
          "io.argoproj.workflow.v1alpha1.ZipStrategy"
            | doc m%"
            ZipStrategy will unzip zipped input artifacts
            "%
            = {  .. },
          "io.k8s.api.core.v1.AWSElasticBlockStoreVolumeSource"
            | doc m%"
            Represents a Persistent Disk resource in AWS.
            
            An AWS EBS disk must exist before mounting to a container. The disk must also be in the same AWS zone as the kubelet. An AWS EBS disk can only be mounted as read/write once. AWS EBS volumes support ownership management and SELinux relabeling.
            "%
            = {
                fsType
                  | String
                  | doc m%"
                  Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
                  "%
                  | optional,
                partition
                  | std.number.Integer
                  | doc m%"
                  The partition in the volume that you want to mount. If omitted, the default is to mount by volume name. Examples: For volume /dev/sda1, you specify the partition as "1". Similarly, the volume partition for /dev/sda is "0" (or you can leave the property empty).
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  Specify "true" to force and set the ReadOnly property in VolumeMounts to "true". If omitted, the default is "false". More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
                  "%
                  | optional,
                volumeID
                  | String
                  | doc m%"
                  Unique ID of the persistent disk resource in AWS (Amazon EBS volume). More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
                  "%,
                ..
              },
          "io.k8s.api.core.v1.Affinity"
            | doc m%"
            Affinity is a group of affinity scheduling rules.
            "%
            = {
                nodeAffinity
                  | definitions.contract."io.k8s.api.core.v1.NodeAffinity"
                  | doc m%"
                  Describes node affinity scheduling rules for the pod.
                  "%
                  | optional,
                podAffinity
                  | definitions.contract."io.k8s.api.core.v1.PodAffinity"
                  | doc m%"
                  Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s)).
                  "%
                  | optional,
                podAntiAffinity
                  | definitions.contract."io.k8s.api.core.v1.PodAntiAffinity"
                  | doc m%"
                  Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s)).
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.AzureDiskVolumeSource"
            | doc m%"
            AzureDisk represents an Azure Data Disk mount on the host and bind mount to the pod.
            "%
            = {
                cachingMode
                  | String
                  | doc m%"
                  Host Caching mode: None, Read Only, Read Write.
                  "%
                  | optional,
                diskName
                  | String
                  | doc m%"
                  The Name of the data disk in the blob storage
                  "%,
                diskURI
                  | String
                  | doc m%"
                  The URI the data disk in the blob storage
                  "%,
                fsType
                  | String
                  | doc m%"
                  Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
                  "%
                  | optional,
                kind
                  | String
                  | doc m%"
                  Expected values Shared: multiple blob disks per storage account  Dedicated: single blob disk per storage account  Managed: azure managed data disk (only in managed availability set). defaults to shared
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.AzureFileVolumeSource"
            | doc m%"
            AzureFile represents an Azure File Service mount on the host and bind mount to the pod.
            "%
            = {
                readOnly
                  | Bool
                  | doc m%"
                  Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
                  "%
                  | optional,
                secretName
                  | String
                  | doc m%"
                  the name of secret that contains Azure Storage Account Name and Key
                  "%,
                shareName
                  | String
                  | doc m%"
                  Share Name
                  "%,
                ..
              },
          "io.k8s.api.core.v1.CSIVolumeSource"
            | doc m%"
            Represents a source location of a volume to mount, managed by an external CSI driver
            "%
            = {
                driver
                  | String
                  | doc m%"
                  Driver is the name of the CSI driver that handles this volume. Consult with your admin for the correct name as registered in the cluster.
                  "%,
                fsType
                  | String
                  | doc m%"
                  Filesystem type to mount. Ex. "ext4", "xfs", "ntfs". If not provided, the empty value is passed to the associated CSI driver which will determine the default filesystem to apply.
                  "%
                  | optional,
                nodePublishSecretRef
                  | definitions.contract."io.k8s.api.core.v1.LocalObjectReference"
                  | doc m%"
                  NodePublishSecretRef is a reference to the secret object containing sensitive information to pass to the CSI driver to complete the CSI NodePublishVolume and NodeUnpublishVolume calls. This field is optional, and  may be empty if no secret is required. If the secret object contains more than one secret, all secret references are passed.
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  Specifies a read-only configuration for the volume. Defaults to false (read/write).
                  "%
                  | optional,
                volumeAttributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  VolumeAttributes stores driver-specific properties that are passed to the CSI driver. Consult your driver's documentation for supported values.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.Capabilities"
            | doc m%"
            Adds and removes POSIX capabilities from running containers.
            "%
            = {
                add
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Added capabilities
                  "%
                  | optional,
                drop
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Removed capabilities
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.CephFSVolumeSource"
            | doc m%"
            Represents a Ceph Filesystem mount that lasts the lifetime of a pod Cephfs volumes do not support ownership management or SELinux relabeling.
            "%
            = {
                monitors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Required: Monitors is a collection of Ceph monitors More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
                  "%,
                path
                  | String
                  | doc m%"
                  Optional: Used as the mounted root, rather than the full Ceph tree, default is /
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts. More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
                  "%
                  | optional,
                secretFile
                  | String
                  | doc m%"
                  Optional: SecretFile is the path to key ring for User, default is /etc/ceph/user.secret More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
                  "%
                  | optional,
                secretRef
                  | definitions.contract."io.k8s.api.core.v1.LocalObjectReference"
                  | doc m%"
                  Optional: SecretRef is reference to the authentication secret for User, default is empty. More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
                  "%
                  | optional,
                user
                  | String
                  | doc m%"
                  Optional: User is the rados user name, default is admin More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.CinderVolumeSource"
            | doc m%"
            Represents a cinder volume resource in Openstack. A Cinder volume must exist before mounting to a container. The volume must also be in the same region as the kubelet. Cinder volumes support ownership management and SELinux relabeling.
            "%
            = {
                fsType
                  | String
                  | doc m%"
                  Filesystem type to mount. Must be a filesystem type supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
                  "%
                  | optional,
                secretRef
                  | definitions.contract."io.k8s.api.core.v1.LocalObjectReference"
                  | doc m%"
                  Optional: points to a secret object containing parameters used to connect to OpenStack.
                  "%
                  | optional,
                volumeID
                  | String
                  | doc m%"
                  volume id used to identify the volume in cinder. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
                  "%,
                ..
              },
          "io.k8s.api.core.v1.ConfigMapEnvSource"
            | doc m%"
            ConfigMapEnvSource selects a ConfigMap to populate the environment variables with.
            
            The contents of the target ConfigMap's Data field will represent the key-value pairs as environment variables.
            "%
            = {
                name
                  | String
                  | doc m%"
                  Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                  "%
                  | optional,
                "optional"
                  | Bool
                  | doc m%"
                  Specify whether the ConfigMap must be defined
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.ConfigMapKeySelector"
            | doc m%"
            Selects a key from a ConfigMap.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.api.core.v1.ConfigMapKeySelector",
          "io.k8s.api.core.v1.ConfigMapProjection"
            | doc m%"
            Adapts a ConfigMap into a projected volume.
            
            The contents of the target ConfigMap's Data field will be presented in a projected volume as files using the keys in the Data field as the file names, unless the items element is populated with specific mappings of keys to paths. Note that this is identical to a configmap volume source without the default mode.
            "%
            = {
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.KeyToPath"
                  ])
                  | doc m%"
                  If unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                  "%
                  | optional,
                "optional"
                  | Bool
                  | doc m%"
                  Specify whether the ConfigMap or its keys must be defined
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.ConfigMapVolumeSource"
            | doc m%"
            Adapts a ConfigMap into a volume.
            
            The contents of the target ConfigMap's Data field will be presented in a volume as files using the keys in the Data field as the file names, unless the items element is populated with specific mappings of keys to paths. ConfigMap volumes support ownership management and SELinux relabeling.
            "%
            = {
                defaultMode
                  | std.number.Integer
                  | doc m%"
                  Optional: mode bits used to set permissions on created files by default. Must be an octal value between 0000 and 0777 or a decimal value between 0 and 511. YAML accepts both octal and decimal values, JSON requires decimal values for mode bits. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
                  "%
                  | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.KeyToPath"
                  ])
                  | doc m%"
                  If unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                  "%
                  | optional,
                "optional"
                  | Bool
                  | doc m%"
                  Specify whether the ConfigMap or its keys must be defined
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.Container"
            | doc m%"
            A single application container that you want to run within a pod.
            "%
            = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Arguments to the entrypoint. The docker image's CMD is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced to a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. "$$(VAR_NAME)" will produce the string literal "$(VAR_NAME)". Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
                  "%
                  | optional,
                command
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Entrypoint array. Not executed within a shell. The docker image's ENTRYPOINT is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced to a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. "$$(VAR_NAME)" will produce the string literal "$(VAR_NAME)". Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.EnvVar"
                  ])
                  | doc m%"
                  List of environment variables to set in the container. Cannot be updated.
                  "%
                  | optional,
                envFrom
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.EnvFromSource"
                  ])
                  | doc m%"
                  List of sources to populate environment variables in the container. The keys defined within a source must be a C_IDENTIFIER. All invalid keys will be reported as an event when the container is starting. When a key exists in multiple sources, the value associated with the last source will take precedence. Values defined by an Env with a duplicate key will take precedence. Cannot be updated.
                  "%
                  | optional,
                image
                  | String
                  | doc m%"
                  Docker image name. More info: https://kubernetes.io/docs/concepts/containers/images This field is optional to allow higher level config management to default or override container images in workload controllers like Deployments and StatefulSets.
                  "%,
                imagePullPolicy
                  | std.enum.TagOrString
                  | [| 'Never, 'IfNotPresent, 'Always |]
                  | doc m%"
                  Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if :latest tag is specified, or IfNotPresent otherwise. Cannot be updated. More info: https://kubernetes.io/docs/concepts/containers/images#updating-images
                  
                  Possible enum values:
                   - `"Always"` means that kubelet always attempts to pull the latest image. Container will fail If the pull fails.
                   - `"IfNotPresent"` means that kubelet pulls if the image isn't present on disk. Container will fail if the image isn't present and the pull fails.
                   - `"Never"` means that kubelet never pulls an image, but only uses a local image. Container will fail if the image isn't present
                  "%
                  | optional,
                lifecycle
                  | definitions.contract."io.k8s.api.core.v1.Lifecycle"
                  | doc m%"
                  Actions that the management system should take in response to container lifecycle events. Cannot be updated.
                  "%
                  | optional,
                livenessProbe
                  | definitions.contract."io.k8s.api.core.v1.Probe"
                  | doc m%"
                  Periodic probe of container liveness. Container will be restarted if the probe fails. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the container specified as a DNS_LABEL. Each container in a pod must have a unique name (DNS_LABEL). Cannot be updated.
                  "%
                  | optional,
                ports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.ContainerPort"
                  ])
                  | doc m%"
                  List of ports to expose from the container. Exposing a port here gives the system additional information about the network connections a container uses, but is primarily informational. Not specifying a port here DOES NOT prevent that port from being exposed. Any port which is listening on the default "0.0.0.0" address inside a container will be accessible from the network. Cannot be updated.
                  "%
                  | optional,
                readinessProbe
                  | definitions.contract."io.k8s.api.core.v1.Probe"
                  | doc m%"
                  Periodic probe of container service readiness. Container will be removed from service endpoints if the probe fails. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                resources
                  | definitions.contract."io.k8s.api.core.v1.ResourceRequirements"
                  | doc m%"
                  Compute Resources required by this container. Cannot be updated. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
                  "%
                  | optional,
                securityContext
                  | definitions.contract."io.k8s.api.core.v1.SecurityContext"
                  | doc m%"
                  SecurityContext defines the security options the container should be run with. If set, the fields of SecurityContext override the equivalent fields of PodSecurityContext. More info: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
                  "%
                  | optional,
                startupProbe
                  | definitions.contract."io.k8s.api.core.v1.Probe"
                  | doc m%"
                  StartupProbe indicates that the Pod has successfully initialized. If specified, no other probes are executed until this completes successfully. If this probe fails, the Pod will be restarted, just as if the livenessProbe failed. This can be used to provide different probe parameters at the beginning of a Pod's lifecycle, when it might take a long time to load data or warm a cache, than during steady-state operation. This cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                stdin
                  | Bool
                  | doc m%"
                  Whether this container should allocate a buffer for stdin in the container runtime. If this is not set, reads from stdin in the container will always result in EOF. Default is false.
                  "%
                  | optional,
                stdinOnce
                  | Bool
                  | doc m%"
                  Whether the container runtime should close the stdin channel after it has been opened by a single attach. When stdin is true the stdin stream will remain open across multiple attach sessions. If stdinOnce is set to true, stdin is opened on container start, is empty until the first client attaches to stdin, and then remains open and accepts data until the client disconnects, at which time stdin is closed and remains closed until the container is restarted. If this flag is false, a container processes that reads from stdin will never receive an EOF. Default is false
                  "%
                  | optional,
                terminationMessagePath
                  | String
                  | doc m%"
                  Optional: Path at which the file to which the container's termination message will be written is mounted into the container's filesystem. Message written is intended to be brief final status, such as an assertion failure message. Will be truncated by the node if greater than 4096 bytes. The total message length across all containers will be limited to 12kb. Defaults to /dev/termination-log. Cannot be updated.
                  "%
                  | optional,
                terminationMessagePolicy
                  | std.enum.TagOrString
                  | [| 'File, 'FallbackToLogsOnError |]
                  | doc m%"
                  Indicate how the termination message should be populated. File will use the contents of terminationMessagePath to populate the container status message on both success and failure. FallbackToLogsOnError will use the last chunk of container log output if the termination message file is empty and the container exited with an error. The log output is limited to 2048 bytes or 80 lines, whichever is smaller. Defaults to File. Cannot be updated.
                  
                  Possible enum values:
                   - `"FallbackToLogsOnError"` will read the most recent contents of the container logs for the container status message when the container exits with an error and the terminationMessagePath has no contents.
                   - `"File"` is the default behavior and will set the container status message to the contents of the container's terminationMessagePath when the container exits.
                  "%
                  | optional,
                tty
                  | Bool
                  | doc m%"
                  Whether this container should allocate a TTY for itself, also requires 'stdin' to be true. Default is false.
                  "%
                  | optional,
                volumeDevices
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.VolumeDevice"
                  ])
                  | doc m%"
                  volumeDevices is the list of block devices to be used by the container.
                  "%
                  | optional,
                volumeMounts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.VolumeMount"
                  ])
                  | doc m%"
                  Pod volumes to mount into the container's filesystem. Cannot be updated.
                  "%
                  | optional,
                workingDir
                  | String
                  | doc m%"
                  Container's working directory. If not specified, the container runtime's default will be used, which might be configured in the container image. Cannot be updated.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.ContainerPort"
            | doc m%"
            ContainerPort represents a network port in a single container.
            "%
            = {
                containerPort
                  | std.number.Integer
                  | doc m%"
                  Number of port to expose on the pod's IP address. This must be a valid port number, 0 < x < 65536.
                  "%,
                hostIP
                  | String
                  | doc m%"
                  What host IP to bind the external port to.
                  "%
                  | optional,
                hostPort
                  | std.number.Integer
                  | doc m%"
                  Number of port to expose on the host. If specified, this must be a valid port number, 0 < x < 65536. If HostNetwork is specified, this must match ContainerPort. Most containers do not need this.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  If specified, this must be an IANA_SVC_NAME and unique within the pod. Each named port in a pod must have a unique name. Name for the port that can be referred to by services.
                  "%
                  | optional,
                protocol
                  | std.enum.TagOrString
                  | [| 'UDP, 'TCP, 'SCTP |]
                  | doc m%"
                  Protocol for port. Must be UDP, TCP, or SCTP. Defaults to "TCP".
                  
                  Possible enum values:
                   - `"SCTP"` is the SCTP protocol.
                   - `"TCP"` is the TCP protocol.
                   - `"UDP"` is the UDP protocol.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.DownwardAPIProjection"
            | doc m%"
            Represents downward API info for projecting into a projected volume. Note that this is identical to a downwardAPI volume source without the default mode.
            "%
            = {
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.DownwardAPIVolumeFile"
                  ])
                  | doc m%"
                  Items is a list of DownwardAPIVolume file
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.DownwardAPIVolumeFile"
            | doc m%"
            DownwardAPIVolumeFile represents information to create the file containing the pod field
            "%
            = {
                fieldRef
                  | definitions.contract."io.k8s.api.core.v1.ObjectFieldSelector"
                  | doc m%"
                  Required: Selects a field of the pod: only annotations, labels, name and namespace are supported.
                  "%
                  | optional,
                mode
                  | std.number.Integer
                  | doc m%"
                  Optional: mode bits used to set permissions on this file, must be an octal value between 0000 and 0777 or a decimal value between 0 and 511. YAML accepts both octal and decimal values, JSON requires decimal values for mode bits. If not specified, the volume defaultMode will be used. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Required: Path is  the relative path name of the file to be created. Must not be absolute or contain the '..' path. Must be utf-8 encoded. The first item of the relative path must not start with '..'
                  "%,
                resourceFieldRef
                  | definitions.contract."io.k8s.api.core.v1.ResourceFieldSelector"
                  | doc m%"
                  Selects a resource of the container: only resources limits and requests (limits.cpu, limits.memory, requests.cpu and requests.memory) are currently supported.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.DownwardAPIVolumeSource"
            | doc m%"
            DownwardAPIVolumeSource represents a volume containing downward API info. Downward API volumes support ownership management and SELinux relabeling.
            "%
            = {
                defaultMode
                  | std.number.Integer
                  | doc m%"
                  Optional: mode bits to use on created files by default. Must be a Optional: mode bits used to set permissions on created files by default. Must be an octal value between 0000 and 0777 or a decimal value between 0 and 511. YAML accepts both octal and decimal values, JSON requires decimal values for mode bits. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
                  "%
                  | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.DownwardAPIVolumeFile"
                  ])
                  | doc m%"
                  Items is a list of downward API volume file
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.EmptyDirVolumeSource"
            | doc m%"
            Represents an empty directory for a pod. Empty directory volumes support ownership management and SELinux relabeling.
            "%
            = {
                medium
                  | String
                  | doc m%"
                  What type of storage medium should back this directory. The default is "" which means to use the node's default medium. Must be an empty string (default) or Memory. More info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir
                  "%
                  | optional,
                sizeLimit
                  | definitions.contract."io.k8s.apimachinery.pkg.api.resource.Quantity"
                  | doc m%"
                  Total amount of local storage required for this EmptyDir volume. The size limit is also applicable for memory medium. The maximum usage on memory medium EmptyDir would be the minimum value between the SizeLimit specified here and the sum of memory limits of all containers in a pod. The default is nil which means that the limit is undefined. More info: http://kubernetes.io/docs/user-guide/volumes#emptydir
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.EnvFromSource"
            | doc m%"
            EnvFromSource represents the source of a set of ConfigMaps
            "%
            = {
                configMapRef
                  | definitions.contract."io.k8s.api.core.v1.ConfigMapEnvSource"
                  | doc m%"
                  The ConfigMap to select from
                  "%
                  | optional,
                prefix
                  | String
                  | doc m%"
                  An optional identifier to prepend to each key in the ConfigMap. Must be a C_IDENTIFIER.
                  "%
                  | optional,
                secretRef
                  | definitions.contract."io.k8s.api.core.v1.SecretEnvSource"
                  | doc m%"
                  The Secret to select from
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.EnvVar"
            | doc m%"
            EnvVar represents an environment variable present in a Container.
            "%
            = {
                name
                  | String
                  | doc m%"
                  Name of the environment variable. Must be a C_IDENTIFIER.
                  "%,
                value
                  | String
                  | doc m%"
                  Variable references $(VAR_NAME) are expanded using the previously defined environment variables in the container and any service environment variables. If a variable cannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced to a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. "$$(VAR_NAME)" will produce the string literal "$(VAR_NAME)". Escaped references will never be expanded, regardless of whether the variable exists or not. Defaults to "".
                  "%
                  | optional,
                valueFrom
                  | definitions.contract."io.k8s.api.core.v1.EnvVarSource"
                  | doc m%"
                  Source for the environment variable's value. Cannot be used if value is not empty.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.EnvVarSource"
            | doc m%"
            EnvVarSource represents a source for the value of an EnvVar.
            "%
            = {
                configMapKeyRef
                  | definitions.contract."io.k8s.api.core.v1.ConfigMapKeySelector"
                  | doc m%"
                  Selects a key of a ConfigMap.
                  "%
                  | optional,
                fieldRef
                  | definitions.contract."io.k8s.api.core.v1.ObjectFieldSelector"
                  | doc m%"
                  Selects a field of the pod: supports metadata.name, metadata.namespace, `metadata.labels['<KEY>']`, `metadata.annotations['<KEY>']`, spec.nodeName, spec.serviceAccountName, status.hostIP, status.podIP, status.podIPs.
                  "%
                  | optional,
                resourceFieldRef
                  | definitions.contract."io.k8s.api.core.v1.ResourceFieldSelector"
                  | doc m%"
                  Selects a resource of the container: only resources limits and requests (limits.cpu, limits.memory, limits.ephemeral-storage, requests.cpu, requests.memory and requests.ephemeral-storage) are currently supported.
                  "%
                  | optional,
                secretKeyRef
                  | definitions.contract."io.k8s.api.core.v1.SecretKeySelector"
                  | doc m%"
                  Selects a key of a secret in the pod's namespace
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.EphemeralVolumeSource"
            | doc m%"
            Represents an ephemeral volume that is handled by a normal storage driver.
            "%
            = {
                volumeClaimTemplate
                  | definitions.contract."io.k8s.api.core.v1.PersistentVolumeClaimTemplate"
                  | doc m%"
                  Will be used to create a stand-alone PVC to provision the volume. The pod in which this EphemeralVolumeSource is embedded will be the owner of the PVC, i.e. the PVC will be deleted together with the pod.  The name of the PVC will be `<pod name>-<volume name>` where `<volume name>` is the name from the `PodSpec.Volumes` array entry. Pod validation will reject the pod if the concatenated name is not valid for a PVC (for example, too long).
                  
                  An existing PVC with that name that is not owned by the pod will *not* be used for the pod to avoid using an unrelated volume by mistake. Starting the pod is then blocked until the unrelated PVC is removed. If such a pre-created PVC is meant to be used by the pod, the PVC has to updated with an owner reference to the pod once the pod exists. Normally this should not be necessary, but it may be useful when manually reconstructing a broken cluster.
                  
                  This field is read-only and no changes will be made by Kubernetes to the PVC after it has been created.
                  
                  Required, must not be nil.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.Event"
            | doc m%"
            Event is a report of an event somewhere in the cluster.  Events have a limited retention time and triggers and messages may evolve with time.  Event consumers should not rely on the timing of an event with a given Reason reflecting a consistent underlying trigger, or the continued existence of events with that Reason.  Events should be treated as informative, best-effort, supplemental data.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.api.core.v1.Event",
          "io.k8s.api.core.v1.EventSeries"
            | doc m%"
            EventSeries contain information on series of events, i.e. thing that was/is happening continuously for some time.
            "%
            = {
                count
                  | std.number.Integer
                  | doc m%"
                  Number of occurrences in this series up to the last heartbeat time
                  "%
                  | optional,
                lastObservedTime
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.MicroTime"
                  | doc m%"
                  Time of the last occurrence observed
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.EventSource"
            | doc m%"
            EventSource contains information for an event.
            "%
            = {
                component
                  | String
                  | doc m%"
                  Component from which the event is generated.
                  "%
                  | optional,
                host
                  | String
                  | doc m%"
                  Node name on which the event is generated.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.ExecAction"
            | doc m%"
            ExecAction describes a "run in container" action.
            "%
            = {
                command
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.FCVolumeSource"
            | doc m%"
            Represents a Fibre Channel volume. Fibre Channel volumes can only be mounted as read/write once. Fibre Channel volumes support ownership management and SELinux relabeling.
            "%
            = {
                fsType
                  | String
                  | doc m%"
                  Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
                  "%
                  | optional,
                lun
                  | std.number.Integer
                  | doc m%"
                  Optional: FC target lun number
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
                  "%
                  | optional,
                targetWWNs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Optional: FC target worldwide names (WWNs)
                  "%
                  | optional,
                wwids
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Optional: FC volume world wide identifiers (wwids) Either wwids or combination of targetWWNs and lun must be set, but not both simultaneously.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.FlexVolumeSource"
            | doc m%"
            FlexVolume represents a generic volume resource that is provisioned/attached using an exec based plugin.
            "%
            = {
                driver
                  | String
                  | doc m%"
                  Driver is the name of the driver to use for this volume.
                  "%,
                fsType
                  | String
                  | doc m%"
                  Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". The default filesystem depends on FlexVolume script.
                  "%
                  | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Optional: Extra command options if any.
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
                  "%
                  | optional,
                secretRef
                  | definitions.contract."io.k8s.api.core.v1.LocalObjectReference"
                  | doc m%"
                  Optional: SecretRef is reference to the secret object containing sensitive information to pass to the plugin scripts. This may be empty if no secret object is specified. If the secret object contains more than one secret, all secrets are passed to the plugin scripts.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.FlockerVolumeSource"
            | doc m%"
            Represents a Flocker volume mounted by the Flocker agent. One and only one of datasetName and datasetUUID should be set. Flocker volumes do not support ownership management or SELinux relabeling.
            "%
            = {
                datasetName
                  | String
                  | doc m%"
                  Name of the dataset stored as metadata -> name on the dataset for Flocker should be considered as deprecated
                  "%
                  | optional,
                datasetUUID
                  | String
                  | doc m%"
                  UUID of the dataset. This is unique identifier of a Flocker dataset
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.GCEPersistentDiskVolumeSource"
            | doc m%"
            Represents a Persistent Disk resource in Google Compute Engine.
            
            A GCE PD must exist before mounting to a container. The disk must also be in the same GCE project and zone as the kubelet. A GCE PD can only be mounted as read/write once or read-only many times. GCE PDs support ownership management and SELinux relabeling.
            "%
            = {
                fsType
                  | String
                  | doc m%"
                  Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
                  "%
                  | optional,
                partition
                  | std.number.Integer
                  | doc m%"
                  The partition in the volume that you want to mount. If omitted, the default is to mount by volume name. Examples: For volume /dev/sda1, you specify the partition as "1". Similarly, the volume partition for /dev/sda is "0" (or you can leave the property empty). More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
                  "%
                  | optional,
                pdName
                  | String
                  | doc m%"
                  Unique name of the PD resource in GCE. Used to identify the disk in GCE. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
                  "%,
                readOnly
                  | Bool
                  | doc m%"
                  ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.GRPCAction" = {
                port
                  | std.number.Integer
                  | doc m%"
                  Port number of the gRPC service. Number must be in the range 1 to 65535.
                  "%,
                service
                  | String
                  | doc m%"
                  Service is the name of the service to place in the gRPC HealthCheckRequest (see https://github.com/grpc/grpc/blob/master/doc/health-checking.md).
                  
                  If this is not specified, the default behavior is defined by gRPC.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.GitRepoVolumeSource"
            | doc m%"
            Represents a volume that is populated with the contents of a git repository. Git repo volumes do not support ownership management. Git repo volumes support SELinux relabeling.
            
            DEPRECATED: GitRepo is deprecated. To provision a container with a git repo, mount an EmptyDir into an InitContainer that clones the repo using git, then mount the EmptyDir into the Pod's container.
            "%
            = {
                directory
                  | String
                  | doc m%"
                  Target directory name. Must not contain or start with '..'.  If '.' is supplied, the volume directory will be the git repository.  Otherwise, if specified, the volume will contain the git repository in the subdirectory with the given name.
                  "%
                  | optional,
                repository
                  | String
                  | doc m%"
                  Repository URL
                  "%,
                revision
                  | String
                  | doc m%"
                  Commit hash for the specified revision.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.GlusterfsVolumeSource"
            | doc m%"
            Represents a Glusterfs mount that lasts the lifetime of a pod. Glusterfs volumes do not support ownership management or SELinux relabeling.
            "%
            = {
                endpoints
                  | String
                  | doc m%"
                  EndpointsName is the endpoint name that details Glusterfs topology. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
                  "%,
                path
                  | String
                  | doc m%"
                  Path is the Glusterfs volume path. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
                  "%,
                readOnly
                  | Bool
                  | doc m%"
                  ReadOnly here will force the Glusterfs volume to be mounted with read-only permissions. Defaults to false. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.HTTPGetAction"
            | doc m%"
            HTTPGetAction describes an action based on HTTP Get requests.
            "%
            = {
                host
                  | String
                  | doc m%"
                  Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                  "%
                  | optional,
                httpHeaders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.HTTPHeader"
                  ])
                  | doc m%"
                  Custom headers to set in the request. HTTP allows repeated headers.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path to access on the HTTP server.
                  "%
                  | optional,
                port
                  | definitions.contract."io.k8s.apimachinery.pkg.util.intstr.IntOrString"
                  | doc m%"
                  Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                  "%,
                scheme
                  | std.enum.TagOrString
                  | [| 'HTTPS, 'HTTP |]
                  | doc m%"
                  Scheme to use for connecting to the host. Defaults to HTTP.
                  
                  Possible enum values:
                   - `"HTTP"` means that the scheme used will be http://
                   - `"HTTPS"` means that the scheme used will be https://
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.HTTPHeader"
            | doc m%"
            HTTPHeader describes a custom header to be used in HTTP probes
            "%
            = {
                name
                  | String
                  | doc m%"
                  The header field name
                  "%,
                value
                  | String
                  | doc m%"
                  The header field value
                  "%,
                ..
              },
          "io.k8s.api.core.v1.HostAlias"
            | doc m%"
            HostAlias holds the mapping between IP and hostnames that will be injected as an entry in the pod's hosts file.
            "%
            = {
                hostnames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Hostnames for the above IP address.
                  "%
                  | optional,
                ip
                  | String
                  | doc m%"
                  IP address of the host file entry.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.HostPathVolumeSource"
            | doc m%"
            Represents a host path mapped into a pod. Host path volumes do not support ownership management or SELinux relabeling.
            "%
            = {
                path
                  | String
                  | doc m%"
                  Path of the directory on the host. If the path is a symlink, it will follow the link to the real path. More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath
                  "%,
                type
                  | String
                  | doc m%"
                  Type for HostPath Volume Defaults to "" More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.ISCSIVolumeSource"
            | doc m%"
            Represents an ISCSI disk. ISCSI volumes can only be mounted as read/write once. ISCSI volumes support ownership management and SELinux relabeling.
            "%
            = {
                chapAuthDiscovery
                  | Bool
                  | doc m%"
                  whether support iSCSI Discovery CHAP authentication
                  "%
                  | optional,
                chapAuthSession
                  | Bool
                  | doc m%"
                  whether support iSCSI Session CHAP authentication
                  "%
                  | optional,
                fsType
                  | String
                  | doc m%"
                  Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#iscsi
                  "%
                  | optional,
                initiatorName
                  | String
                  | doc m%"
                  Custom iSCSI Initiator Name. If initiatorName is specified with iscsiInterface simultaneously, new iSCSI interface <target portal>:<volume name> will be created for the connection.
                  "%
                  | optional,
                iqn
                  | String
                  | doc m%"
                  Target iSCSI Qualified Name.
                  "%,
                iscsiInterface
                  | String
                  | doc m%"
                  iSCSI Interface Name that uses an iSCSI transport. Defaults to 'default' (tcp).
                  "%
                  | optional,
                lun
                  | std.number.Integer
                  | doc m%"
                  iSCSI Target Lun number.
                  "%,
                portals
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  iSCSI Target Portal List. The portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260).
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false.
                  "%
                  | optional,
                secretRef
                  | definitions.contract."io.k8s.api.core.v1.LocalObjectReference"
                  | doc m%"
                  CHAP Secret for iSCSI target and initiator authentication
                  "%
                  | optional,
                targetPortal
                  | String
                  | doc m%"
                  iSCSI Target Portal. The Portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260).
                  "%,
                ..
              },
          "io.k8s.api.core.v1.KeyToPath"
            | doc m%"
            Maps a string key to a path within a volume.
            "%
            = {
                key
                  | String
                  | doc m%"
                  The key to project.
                  "%,
                mode
                  | std.number.Integer
                  | doc m%"
                  Optional: mode bits used to set permissions on this file. Must be an octal value between 0000 and 0777 or a decimal value between 0 and 511. YAML accepts both octal and decimal values, JSON requires decimal values for mode bits. If not specified, the volume defaultMode will be used. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  The relative path of the file to map the key to. May not be an absolute path. May not contain the path element '..'. May not start with the string '..'.
                  "%,
                ..
              },
          "io.k8s.api.core.v1.Lifecycle"
            | doc m%"
            Lifecycle describes actions that the management system should take in response to container lifecycle events. For the PostStart and PreStop lifecycle handlers, management of the container blocks until the action is complete, unless the container process fails, in which case the handler is aborted.
            "%
            = {
                postStart
                  | definitions.contract."io.k8s.api.core.v1.LifecycleHandler"
                  | doc m%"
                  PostStart is called immediately after a container is created. If the handler fails, the container is terminated and restarted according to its restart policy. Other management of the container blocks until the hook completes. More info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks
                  "%
                  | optional,
                preStop
                  | definitions.contract."io.k8s.api.core.v1.LifecycleHandler"
                  | doc m%"
                  PreStop is called immediately before a container is terminated due to an API request or management event such as liveness/startup probe failure, preemption, resource contention, etc. The handler is not called if the container crashes or exits. The Pod's termination grace period countdown begins before the PreStop hook is executed. Regardless of the outcome of the handler, the container will eventually terminate within the Pod's termination grace period (unless delayed by finalizers). Other management of the container blocks until the hook completes or until the termination grace period is reached. More info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.LifecycleHandler"
            | doc m%"
            LifecycleHandler defines a specific action that should be taken in a lifecycle hook. One and only one of the fields, except TCPSocket must be specified.
            "%
            = {
                exec
                  | definitions.contract."io.k8s.api.core.v1.ExecAction"
                  | doc m%"
                  Exec specifies the action to take.
                  "%
                  | optional,
                httpGet
                  | definitions.contract."io.k8s.api.core.v1.HTTPGetAction"
                  | doc m%"
                  HTTPGet specifies the http request to perform.
                  "%
                  | optional,
                tcpSocket
                  | definitions.contract."io.k8s.api.core.v1.TCPSocketAction"
                  | doc m%"
                  Deprecated. TCPSocket is NOT supported as a LifecycleHandler and kept for the backward compatibility. There are no validation of this field and lifecycle hooks will fail in runtime when tcp handler is specified.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.LocalObjectReference"
            | doc m%"
            LocalObjectReference contains enough information to let you locate the referenced object inside the same namespace.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.api.core.v1.LocalObjectReference",
          "io.k8s.api.core.v1.NFSVolumeSource"
            | doc m%"
            Represents an NFS mount that lasts the lifetime of a pod. NFS volumes do not support ownership management or SELinux relabeling.
            "%
            = {
                path
                  | String
                  | doc m%"
                  Path that is exported by the NFS server. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
                  "%,
                readOnly
                  | Bool
                  | doc m%"
                  ReadOnly here will force the NFS export to be mounted with read-only permissions. Defaults to false. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
                  "%
                  | optional,
                server
                  | String
                  | doc m%"
                  Server is the hostname or IP address of the NFS server. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
                  "%,
                ..
              },
          "io.k8s.api.core.v1.NodeAffinity"
            | doc m%"
            Node affinity is a group of node affinity scheduling rules.
            "%
            = {
                preferredDuringSchedulingIgnoredDuringExecution
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.PreferredSchedulingTerm"
                  ])
                  | doc m%"
                  The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node matches the corresponding matchExpressions; the node(s) with the highest sum are the most preferred.
                  "%
                  | optional,
                requiredDuringSchedulingIgnoredDuringExecution
                  | definitions.contract."io.k8s.api.core.v1.NodeSelector"
                  | doc m%"
                  If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to an update), the system may or may not try to eventually evict the pod from its node.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.NodeSelector"
            | doc m%"
            A node selector represents the union of the results of one or more label queries over a set of nodes; that is, it represents the OR of the selectors represented by the node selector terms.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.api.core.v1.NodeSelector",
          "io.k8s.api.core.v1.NodeSelectorRequirement"
            | doc m%"
            A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values.
            "%
            = {
                key
                  | String
                  | doc m%"
                  The label key that the selector applies to.
                  "%,
                operator
                  | std.enum.TagOrString
                  | [| 'NotIn, 'Lt, 'In, 'Gt, 'Exists, 'DoesNotExist |]
                  | doc m%"
                  Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
                  
                  Possible enum values:
                   - `"DoesNotExist"`
                   - `"Exists"`
                   - `"Gt"`
                   - `"In"`
                   - `"Lt"`
                   - `"NotIn"`
                  "%,
                values
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.NodeSelectorTerm"
            | doc m%"
            A null or empty node selector term matches no objects. The requirements of them are ANDed. The TopologySelectorTerm type implements a subset of the NodeSelectorTerm.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.api.core.v1.NodeSelectorTerm",
          "io.k8s.api.core.v1.ObjectFieldSelector"
            | doc m%"
            ObjectFieldSelector selects an APIVersioned field of an object.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.api.core.v1.ObjectFieldSelector",
          "io.k8s.api.core.v1.ObjectReference"
            | doc m%"
            ObjectReference contains enough information to let you inspect or modify the referred object.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.api.core.v1.ObjectReference",
          "io.k8s.api.core.v1.PersistentVolumeClaim"
            | doc m%"
            PersistentVolumeClaim is a user's request for and claim to a persistent volume
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.api.core.v1.PersistentVolumeClaim",
          "io.k8s.api.core.v1.PersistentVolumeClaimCondition"
            | doc m%"
            PersistentVolumeClaimCondition contails details about state of pvc
            "%
            = {
                lastProbeTime
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | doc m%"
                  Last time we probed the condition.
                  "%
                  | optional,
                lastTransitionTime
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | doc m%"
                  Last time the condition transitioned from one status to another.
                  "%
                  | optional,
                message
                  | String
                  | doc m%"
                  Human-readable message indicating details about last transition.
                  "%
                  | optional,
                reason
                  | String
                  | doc m%"
                  Unique, this should be a short, machine understandable string that gives the reason for condition's last transition. If it reports "ResizeStarted" that means the underlying persistent volume is being resized.
                  "%
                  | optional,
                status | String,
                type
                  | std.enum.TagOrString
                  | [| 'Resizing, 'FileSystemResizePending |]
                  | doc m%"
                  
                  
                  
                  Possible enum values:
                   - `"FileSystemResizePending"` - controller resize is finished and a file system resize is pending on node
                   - `"Resizing"` - a user trigger resize of pvc has been started
                  "%,
                ..
              },
          "io.k8s.api.core.v1.PersistentVolumeClaimSpec"
            | doc m%"
            PersistentVolumeClaimSpec describes the common attributes of storage devices and allows a Source for provider-specific attributes
            "%
            = {
                accessModes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  AccessModes contains the desired access modes the volume should have. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#access-modes-1
                  "%
                  | optional,
                dataSource
                  | definitions.contract."io.k8s.api.core.v1.TypedLocalObjectReference"
                  | doc m%"
                  This field can be used to specify either: * An existing VolumeSnapshot object (snapshot.storage.k8s.io/VolumeSnapshot) * An existing PVC (PersistentVolumeClaim) If the provisioner or an external controller can support the specified data source, it will create a new volume based on the contents of the specified data source. If the AnyVolumeDataSource feature gate is enabled, this field will always have the same contents as the DataSourceRef field.
                  "%
                  | optional,
                dataSourceRef
                  | definitions.contract."io.k8s.api.core.v1.TypedLocalObjectReference"
                  | doc m%"
                  Specifies the object from which to populate the volume with data, if a non-empty volume is desired. This may be any local object from a non-empty API group (non core object) or a PersistentVolumeClaim object. When this field is specified, volume binding will only succeed if the type of the specified object matches some installed volume populator or dynamic provisioner. This field will replace the functionality of the DataSource field and as such if both fields are non-empty, they must have the same value. For backwards compatibility, both fields (DataSource and DataSourceRef) will be set to the same value automatically if one of them is empty and the other is non-empty. There are two important differences between DataSource and DataSourceRef: * While DataSource only allows two specific types of objects, DataSourceRef
                    allows any non-core object, as well as PersistentVolumeClaim objects.
                  * While DataSource ignores disallowed values (dropping them), DataSourceRef
                    preserves all values, and generates an error if a disallowed value is
                    specified.
                  (Alpha) Using this field requires the AnyVolumeDataSource feature gate to be enabled.
                  "%
                  | optional,
                resources
                  | definitions.contract."io.k8s.api.core.v1.ResourceRequirements"
                  | doc m%"
                  Resources represents the minimum resources the volume should have. If RecoverVolumeExpansionFailure feature is enabled users are allowed to specify resource requirements that are lower than previous value but must still be higher than capacity recorded in the status field of the claim. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#resources
                  "%
                  | optional,
                selector
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector"
                  | doc m%"
                  A label query over volumes to consider for binding.
                  "%
                  | optional,
                storageClassName
                  | String
                  | doc m%"
                  Name of the StorageClass required by the claim. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#class-1
                  "%
                  | optional,
                volumeMode
                  | String
                  | doc m%"
                  volumeMode defines what type of volume is required by the claim. Value of Filesystem is implied when not included in claim spec.
                  "%
                  | optional,
                volumeName
                  | String
                  | doc m%"
                  VolumeName is the binding reference to the PersistentVolume backing this claim.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.PersistentVolumeClaimStatus"
            | doc m%"
            PersistentVolumeClaimStatus is the current status of a persistent volume claim.
            "%
            = {
                accessModes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  AccessModes contains the actual access modes the volume backing the PVC has. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#access-modes-1
                  "%
                  | optional,
                allocatedResources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity"
                  ])
                  | doc m%"
                  The storage resource within AllocatedResources tracks the capacity allocated to a PVC. It may be larger than the actual capacity when a volume expansion operation is requested. For storage quota, the larger value from allocatedResources and PVC.spec.resources is used. If allocatedResources is not set, PVC.spec.resources alone is used for quota calculation. If a volume expansion capacity request is lowered, allocatedResources is only lowered if there are no expansion operations in progress and if the actual volume capacity is equal or lower than the requested capacity. This is an alpha field and requires enabling RecoverVolumeExpansionFailure feature.
                  "%
                  | optional,
                capacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity"
                  ])
                  | doc m%"
                  Represents the actual resources of the underlying volume.
                  "%
                  | optional,
                conditions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.PersistentVolumeClaimCondition"
                  ])
                  | doc m%"
                  Current Condition of persistent volume claim. If underlying persistent volume is being resized then the Condition will be set to 'ResizeStarted'.
                  "%
                  | optional,
                phase
                  | std.enum.TagOrString
                  | [| 'Pending, 'Lost, 'Bound |]
                  | doc m%"
                  Phase represents the current phase of PersistentVolumeClaim.
                  
                  Possible enum values:
                   - `"Bound"` used for PersistentVolumeClaims that are bound
                   - `"Lost"` used for PersistentVolumeClaims that lost their underlying PersistentVolume. The claim was bound to a PersistentVolume and this volume does not exist any longer and all data on it was lost.
                   - `"Pending"` used for PersistentVolumeClaims that are not yet bound
                  "%
                  | optional,
                resizeStatus
                  | String
                  | doc m%"
                  ResizeStatus stores status of resize operation. ResizeStatus is not set by default but when expansion is complete resizeStatus is set to empty string by resize controller or kubelet. This is an alpha field and requires enabling RecoverVolumeExpansionFailure feature.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.PersistentVolumeClaimTemplate"
            | doc m%"
            PersistentVolumeClaimTemplate is used to produce PersistentVolumeClaim objects as part of an EphemeralVolumeSource.
            "%
            = {
                metadata
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta"
                  | doc m%"
                  May contain labels and annotations that will be copied into the PVC when creating it. No other fields are allowed and will be rejected during validation.
                  "%
                  | optional,
                spec
                  | definitions.contract."io.k8s.api.core.v1.PersistentVolumeClaimSpec"
                  | doc m%"
                  The specification for the PersistentVolumeClaim. The entire content is copied unchanged into the PVC that gets created from this template. The same fields as in a PersistentVolumeClaim are also valid here.
                  "%,
                ..
              },
          "io.k8s.api.core.v1.PersistentVolumeClaimVolumeSource"
            | doc m%"
            PersistentVolumeClaimVolumeSource references the user's PVC in the same namespace. This volume finds the bound PV and mounts that volume for the pod. A PersistentVolumeClaimVolumeSource is, essentially, a wrapper around another type of volume that is owned by someone else (the system).
            "%
            = {
                claimName
                  | String
                  | doc m%"
                  ClaimName is the name of a PersistentVolumeClaim in the same namespace as the pod using this volume. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims
                  "%,
                readOnly
                  | Bool
                  | doc m%"
                  Will force the ReadOnly setting in VolumeMounts. Default false.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.PhotonPersistentDiskVolumeSource"
            | doc m%"
            Represents a Photon Controller persistent disk resource.
            "%
            = {
                fsType
                  | String
                  | doc m%"
                  Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
                  "%
                  | optional,
                pdID
                  | String
                  | doc m%"
                  ID that identifies Photon Controller persistent disk
                  "%,
                ..
              },
          "io.k8s.api.core.v1.PodAffinity"
            | doc m%"
            Pod affinity is a group of inter pod affinity scheduling rules.
            "%
            = {
                preferredDuringSchedulingIgnoredDuringExecution
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.WeightedPodAffinityTerm"
                  ])
                  | doc m%"
                  The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
                  "%
                  | optional,
                requiredDuringSchedulingIgnoredDuringExecution
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.PodAffinityTerm"
                  ])
                  | doc m%"
                  If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.PodAffinityTerm"
            | doc m%"
            Defines a set of pods (namely those matching the labelSelector relative to the given namespace(s)) that this pod should be co-located (affinity) or not co-located (anti-affinity) with, where co-located is defined as running on a node whose value of the label with key <topologyKey> matches that of any node on which a pod of the set of pods is running
            "%
            = {
                labelSelector
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector"
                  | doc m%"
                  A label query over a set of resources, in this case pods.
                  "%
                  | optional,
                namespaceSelector
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector"
                  | doc m%"
                  A label query over the set of namespaces that the term applies to. The term is applied to the union of the namespaces selected by this field and the ones listed in the namespaces field. null selector and null or empty namespaces list means "this pod's namespace". An empty selector ({}) matches all namespaces. This field is beta-level and is only honored when PodAffinityNamespaceSelector feature is enabled.
                  "%
                  | optional,
                namespaces
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  namespaces specifies a static list of namespace names that the term applies to. The term is applied to the union of the namespaces listed in this field and the ones selected by namespaceSelector. null or empty namespaces list and null namespaceSelector means "this pod's namespace"
                  "%
                  | optional,
                topologyKey
                  | String
                  | doc m%"
                  This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed.
                  "%,
                ..
              },
          "io.k8s.api.core.v1.PodAntiAffinity"
            | doc m%"
            Pod anti affinity is a group of inter pod anti affinity scheduling rules.
            "%
            = {
                preferredDuringSchedulingIgnoredDuringExecution
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.WeightedPodAffinityTerm"
                  ])
                  | doc m%"
                  The scheduler will prefer to schedule pods to nodes that satisfy the anti-affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling anti-affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
                  "%
                  | optional,
                requiredDuringSchedulingIgnoredDuringExecution
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.PodAffinityTerm"
                  ])
                  | doc m%"
                  If the anti-affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the anti-affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.PodDNSConfig"
            | doc m%"
            PodDNSConfig defines the DNS parameters of a pod in addition to those generated from DNSPolicy.
            "%
            = {
                nameservers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of DNS name server IP addresses. This will be appended to the base nameservers generated from DNSPolicy. Duplicated nameservers will be removed.
                  "%
                  | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.PodDNSConfigOption"
                  ])
                  | doc m%"
                  A list of DNS resolver options. This will be merged with the base options generated from DNSPolicy. Duplicated entries will be removed. Resolution options given in Options will override those that appear in the base DNSPolicy.
                  "%
                  | optional,
                searches
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of DNS search domains for host-name lookup. This will be appended to the base search paths generated from DNSPolicy. Duplicated search paths will be removed.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.PodDNSConfigOption"
            | doc m%"
            PodDNSConfigOption defines DNS resolver options of a pod.
            "%
            = {
                name
                  | String
                  | doc m%"
                  Required.
                  "%
                  | optional,
                value | String | optional,
                ..
              },
          "io.k8s.api.core.v1.PodSecurityContext"
            | doc m%"
            PodSecurityContext holds pod-level security attributes and common container settings. Some fields are also present in container.securityContext.  Field values of container.securityContext take precedence over field values of PodSecurityContext.
            "%
            = {
                fsGroup
                  | std.number.Integer
                  | doc m%"
                  A special supplemental group that applies to all containers in a pod. Some volume types allow the Kubelet to change the ownership of that volume to be owned by the pod:
                  
                  1. The owning GID will be the FSGroup 2. The setgid bit is set (new files created in the volume will be owned by FSGroup) 3. The permission bits are OR'd with rw-rw----
                  
                  If unset, the Kubelet will not modify the ownership and permissions of any volume. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                fsGroupChangePolicy
                  | String
                  | doc m%"
                  fsGroupChangePolicy defines behavior of changing ownership and permission of the volume before being exposed inside Pod. This field will only apply to volume types which support fsGroup based ownership(and permissions). It will have no effect on ephemeral volume types such as: secret, configmaps and emptydir. Valid values are "OnRootMismatch" and "Always". If not specified, "Always" is used. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                runAsGroup
                  | std.number.Integer
                  | doc m%"
                  The GID to run the entrypoint of the container process. Uses runtime default if unset. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                runAsNonRoot
                  | Bool
                  | doc m%"
                  Indicates that the container must run as a non-root user. If true, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root) and fail to start the container if it does. If unset or false, no such validation will be performed. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
                  "%
                  | optional,
                runAsUser
                  | std.number.Integer
                  | doc m%"
                  The UID to run the entrypoint of the container process. Defaults to user specified in image metadata if unspecified. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                seLinuxOptions
                  | definitions.contract."io.k8s.api.core.v1.SELinuxOptions"
                  | doc m%"
                  The SELinux context to be applied to all containers. If unspecified, the container runtime will allocate a random SELinux context for each container.  May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                seccompProfile
                  | definitions.contract."io.k8s.api.core.v1.SeccompProfile"
                  | doc m%"
                  The seccomp options to use by the containers in this pod. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                supplementalGroups
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType 'Integer)
                  ])
                  | doc m%"
                  A list of groups applied to the first process run in each container, in addition to the container's primary GID.  If unspecified, no groups will be added to any container. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                sysctls
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.Sysctl"
                  ])
                  | doc m%"
                  Sysctls hold a list of namespaced sysctls used for the pod. Pods with unsupported sysctls (by the container runtime) might fail to launch. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                windowsOptions
                  | definitions.contract."io.k8s.api.core.v1.WindowsSecurityContextOptions"
                  | doc m%"
                  The Windows specific settings applied to all containers. If unspecified, the options within a container's SecurityContext will be used. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. Note that this field cannot be set when spec.os.name is linux.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.PortworxVolumeSource"
            | doc m%"
            PortworxVolumeSource represents a Portworx volume resource.
            "%
            = {
                fsType
                  | String
                  | doc m%"
                  FSType represents the filesystem type to mount Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs". Implicitly inferred to be "ext4" if unspecified.
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
                  "%
                  | optional,
                volumeID
                  | String
                  | doc m%"
                  VolumeID uniquely identifies a Portworx volume
                  "%,
                ..
              },
          "io.k8s.api.core.v1.PreferredSchedulingTerm"
            | doc m%"
            An empty preferred scheduling term matches all objects with implicit weight 0 (i.e. it's a no-op). A null preferred scheduling term matches no objects (i.e. is also a no-op).
            "%
            = {
                preference
                  | definitions.contract."io.k8s.api.core.v1.NodeSelectorTerm"
                  | doc m%"
                  A node selector term, associated with the corresponding weight.
                  "%,
                weight
                  | std.number.Integer
                  | doc m%"
                  Weight associated with matching the corresponding nodeSelectorTerm, in the range 1-100.
                  "%,
                ..
              },
          "io.k8s.api.core.v1.Probe"
            | doc m%"
            Probe describes a health check to be performed against a container to determine whether it is alive or ready to receive traffic.
            "%
            = {
                exec
                  | definitions.contract."io.k8s.api.core.v1.ExecAction"
                  | doc m%"
                  Exec specifies the action to take.
                  "%
                  | optional,
                failureThreshold
                  | std.number.Integer
                  | doc m%"
                  Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1.
                  "%
                  | optional,
                grpc
                  | definitions.contract."io.k8s.api.core.v1.GRPCAction"
                  | doc m%"
                  GRPC specifies an action involving a GRPC port. This is an alpha field and requires enabling GRPCContainerProbe feature gate.
                  "%
                  | optional,
                httpGet
                  | definitions.contract."io.k8s.api.core.v1.HTTPGetAction"
                  | doc m%"
                  HTTPGet specifies the http request to perform.
                  "%
                  | optional,
                initialDelaySeconds
                  | std.number.Integer
                  | doc m%"
                  Number of seconds after the container has started before liveness probes are initiated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                periodSeconds
                  | std.number.Integer
                  | doc m%"
                  How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.
                  "%
                  | optional,
                successThreshold
                  | std.number.Integer
                  | doc m%"
                  Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup. Minimum value is 1.
                  "%
                  | optional,
                tcpSocket
                  | definitions.contract."io.k8s.api.core.v1.TCPSocketAction"
                  | doc m%"
                  TCPSocket specifies an action involving a TCP port.
                  "%
                  | optional,
                terminationGracePeriodSeconds
                  | std.number.Integer
                  | doc m%"
                  Optional duration in seconds the pod needs to terminate gracefully upon probe failure. The grace period is the duration in seconds after the processes running in the pod are sent a termination signal and the time when the processes are forcibly halted with a kill signal. Set this value longer than the expected cleanup time for your process. If this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this value overrides the value provided by the pod spec. Value must be non-negative integer. The value zero indicates stop immediately via the kill signal (no opportunity to shut down). This is a beta field and requires enabling ProbeTerminationGracePeriod feature gate. Minimum value is 1. spec.terminationGracePeriodSeconds is used if unset.
                  "%
                  | optional,
                timeoutSeconds
                  | std.number.Integer
                  | doc m%"
                  Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.ProjectedVolumeSource"
            | doc m%"
            Represents a projected volume source
            "%
            = {
                defaultMode
                  | std.number.Integer
                  | doc m%"
                  Mode bits used to set permissions on created files by default. Must be an octal value between 0000 and 0777 or a decimal value between 0 and 511. YAML accepts both octal and decimal values, JSON requires decimal values for mode bits. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
                  "%
                  | optional,
                sources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.VolumeProjection"
                  ])
                  | doc m%"
                  list of volume projections
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.QuobyteVolumeSource"
            | doc m%"
            Represents a Quobyte mount that lasts the lifetime of a pod. Quobyte volumes do not support ownership management or SELinux relabeling.
            "%
            = {
                group
                  | String
                  | doc m%"
                  Group to map volume access to Default is no group
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  ReadOnly here will force the Quobyte volume to be mounted with read-only permissions. Defaults to false.
                  "%
                  | optional,
                registry
                  | String
                  | doc m%"
                  Registry represents a single or multiple Quobyte Registry services specified as a string as host:port pair (multiple entries are separated with commas) which acts as the central registry for volumes
                  "%,
                tenant
                  | String
                  | doc m%"
                  Tenant owning the given Quobyte volume in the Backend Used with dynamically provisioned Quobyte volumes, value is set by the plugin
                  "%
                  | optional,
                user
                  | String
                  | doc m%"
                  User to map volume access to Defaults to serivceaccount user
                  "%
                  | optional,
                volume
                  | String
                  | doc m%"
                  Volume is a string that references an already created Quobyte volume by name.
                  "%,
                ..
              },
          "io.k8s.api.core.v1.RBDVolumeSource"
            | doc m%"
            Represents a Rados Block Device mount that lasts the lifetime of a pod. RBD volumes support ownership management and SELinux relabeling.
            "%
            = {
                fsType
                  | String
                  | doc m%"
                  Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#rbd
                  "%
                  | optional,
                image
                  | String
                  | doc m%"
                  The rados image name. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
                  "%,
                keyring
                  | String
                  | doc m%"
                  Keyring is the path to key ring for RBDUser. Default is /etc/ceph/keyring. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
                  "%
                  | optional,
                monitors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A collection of Ceph monitors. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
                  "%,
                pool
                  | String
                  | doc m%"
                  The rados pool name. Default is rbd. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
                  "%
                  | optional,
                secretRef
                  | definitions.contract."io.k8s.api.core.v1.LocalObjectReference"
                  | doc m%"
                  SecretRef is name of the authentication secret for RBDUser. If provided overrides keyring. Default is nil. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
                  "%
                  | optional,
                user
                  | String
                  | doc m%"
                  The rados user name. Default is admin. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.ResourceFieldSelector"
            | doc m%"
            ResourceFieldSelector represents container resources (cpu, memory) and their output format
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.api.core.v1.ResourceFieldSelector",
          "io.k8s.api.core.v1.ResourceRequirements"
            | doc m%"
            ResourceRequirements describes the compute resource requirements.
            "%
            = {
                limits
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity"
                  ])
                  | doc m%"
                  Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
                  "%
                  | optional,
                requests
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity"
                  ])
                  | doc m%"
                  Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.SELinuxOptions"
            | doc m%"
            SELinuxOptions are the labels to be applied to the container
            "%
            = {
                level
                  | String
                  | doc m%"
                  Level is SELinux level label that applies to the container.
                  "%
                  | optional,
                role
                  | String
                  | doc m%"
                  Role is a SELinux role label that applies to the container.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Type is a SELinux type label that applies to the container.
                  "%
                  | optional,
                user
                  | String
                  | doc m%"
                  User is a SELinux user label that applies to the container.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.ScaleIOVolumeSource"
            | doc m%"
            ScaleIOVolumeSource represents a persistent ScaleIO volume
            "%
            = {
                fsType
                  | String
                  | doc m%"
                  Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Default is "xfs".
                  "%
                  | optional,
                gateway
                  | String
                  | doc m%"
                  The host address of the ScaleIO API Gateway.
                  "%,
                protectionDomain
                  | String
                  | doc m%"
                  The name of the ScaleIO Protection Domain for the configured storage.
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
                  "%
                  | optional,
                secretRef
                  | definitions.contract."io.k8s.api.core.v1.LocalObjectReference"
                  | doc m%"
                  SecretRef references to the secret for ScaleIO user and other sensitive information. If this is not provided, Login operation will fail.
                  "%,
                sslEnabled
                  | Bool
                  | doc m%"
                  Flag to enable/disable SSL communication with Gateway, default false
                  "%
                  | optional,
                storageMode
                  | String
                  | doc m%"
                  Indicates whether the storage for a volume should be ThickProvisioned or ThinProvisioned. Default is ThinProvisioned.
                  "%
                  | optional,
                storagePool
                  | String
                  | doc m%"
                  The ScaleIO Storage Pool associated with the protection domain.
                  "%
                  | optional,
                system
                  | String
                  | doc m%"
                  The name of the storage system as configured in ScaleIO.
                  "%,
                volumeName
                  | String
                  | doc m%"
                  The name of a volume already created in the ScaleIO system that is associated with this volume source.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.SeccompProfile"
            | doc m%"
            SeccompProfile defines a pod/container's seccomp profile settings. Only one profile source may be set.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.api.core.v1.SeccompProfile",
          "io.k8s.api.core.v1.SecretEnvSource"
            | doc m%"
            SecretEnvSource selects a Secret to populate the environment variables with.
            
            The contents of the target Secret's Data field will represent the key-value pairs as environment variables.
            "%
            = {
                name
                  | String
                  | doc m%"
                  Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                  "%
                  | optional,
                "optional"
                  | Bool
                  | doc m%"
                  Specify whether the Secret must be defined
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.SecretKeySelector"
            | doc m%"
            SecretKeySelector selects a key of a Secret.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
          "io.k8s.api.core.v1.SecretProjection"
            | doc m%"
            Adapts a secret into a projected volume.
            
            The contents of the target Secret's Data field will be presented in a projected volume as files using the keys in the Data field as the file names. Note that this is identical to a secret volume source without the default mode.
            "%
            = {
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.KeyToPath"
                  ])
                  | doc m%"
                  If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                  "%
                  | optional,
                "optional"
                  | Bool
                  | doc m%"
                  Specify whether the Secret or its key must be defined
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.SecretVolumeSource"
            | doc m%"
            Adapts a Secret into a volume.
            
            The contents of the target Secret's Data field will be presented in a volume as files using the keys in the Data field as the file names. Secret volumes support ownership management and SELinux relabeling.
            "%
            = {
                defaultMode
                  | std.number.Integer
                  | doc m%"
                  Optional: mode bits used to set permissions on created files by default. Must be an octal value between 0000 and 0777 or a decimal value between 0 and 511. YAML accepts both octal and decimal values, JSON requires decimal values for mode bits. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
                  "%
                  | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.api.core.v1.KeyToPath"
                  ])
                  | doc m%"
                  If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
                  "%
                  | optional,
                "optional"
                  | Bool
                  | doc m%"
                  Specify whether the Secret or its keys must be defined
                  "%
                  | optional,
                secretName
                  | String
                  | doc m%"
                  Name of the secret in the pod's namespace to use. More info: https://kubernetes.io/docs/concepts/storage/volumes#secret
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.SecurityContext"
            | doc m%"
            SecurityContext holds security configuration that will be applied to a container. Some fields are present in both SecurityContext and PodSecurityContext.  When both are set, the values in SecurityContext take precedence.
            "%
            = {
                allowPrivilegeEscalation
                  | Bool
                  | doc m%"
                  AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process. This bool directly controls if the no_new_privs flag will be set on the container process. AllowPrivilegeEscalation is true always when the container is: 1) run as Privileged 2) has CAP_SYS_ADMIN Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                capabilities
                  | definitions.contract."io.k8s.api.core.v1.Capabilities"
                  | doc m%"
                  The capabilities to add/drop when running containers. Defaults to the default set of capabilities granted by the container runtime. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                privileged
                  | Bool
                  | doc m%"
                  Run container in privileged mode. Processes in privileged containers are essentially equivalent to root on the host. Defaults to false. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                procMount
                  | String
                  | doc m%"
                  procMount denotes the type of proc mount to use for the containers. The default is DefaultProcMount which uses the container runtime defaults for readonly paths and masked paths. This requires the ProcMountType feature flag to be enabled. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                readOnlyRootFilesystem
                  | Bool
                  | doc m%"
                  Whether this container has a read-only root filesystem. Default is false. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                runAsGroup
                  | std.number.Integer
                  | doc m%"
                  The GID to run the entrypoint of the container process. Uses runtime default if unset. May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                runAsNonRoot
                  | Bool
                  | doc m%"
                  Indicates that the container must run as a non-root user. If true, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root) and fail to start the container if it does. If unset or false, no such validation will be performed. May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
                  "%
                  | optional,
                runAsUser
                  | std.number.Integer
                  | doc m%"
                  The UID to run the entrypoint of the container process. Defaults to user specified in image metadata if unspecified. May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                seLinuxOptions
                  | definitions.contract."io.k8s.api.core.v1.SELinuxOptions"
                  | doc m%"
                  The SELinux context to be applied to the container. If unspecified, the container runtime will allocate a random SELinux context for each container.  May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                seccompProfile
                  | definitions.contract."io.k8s.api.core.v1.SeccompProfile"
                  | doc m%"
                  The seccomp options to use by this container. If seccomp options are provided at both the pod & container level, the container options override the pod options. Note that this field cannot be set when spec.os.name is windows.
                  "%
                  | optional,
                windowsOptions
                  | definitions.contract."io.k8s.api.core.v1.WindowsSecurityContextOptions"
                  | doc m%"
                  The Windows specific settings applied to all containers. If unspecified, the options from the PodSecurityContext will be used. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. Note that this field cannot be set when spec.os.name is linux.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.ServiceAccountTokenProjection"
            | doc m%"
            ServiceAccountTokenProjection represents a projected service account token volume. This projection can be used to insert a service account token into the pods runtime filesystem for use against APIs (Kubernetes API Server or otherwise).
            "%
            = {
                audience
                  | String
                  | doc m%"
                  Audience is the intended audience of the token. A recipient of a token must identify itself with an identifier specified in the audience of the token, and otherwise should reject the token. The audience defaults to the identifier of the apiserver.
                  "%
                  | optional,
                expirationSeconds
                  | std.number.Integer
                  | doc m%"
                  ExpirationSeconds is the requested duration of validity of the service account token. As the token approaches expiration, the kubelet volume plugin will proactively rotate the service account token. The kubelet will start trying to rotate the token if the token is older than 80 percent of its time to live or if the token is older than 24 hours.Defaults to 1 hour and must be at least 10 minutes.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path is the path relative to the mount point of the file to project the token into.
                  "%,
                ..
              },
          "io.k8s.api.core.v1.ServicePort"
            | doc m%"
            ServicePort contains information on service's port.
            "%
            = {
                appProtocol
                  | String
                  | doc m%"
                  The application protocol for this port. This field follows standard Kubernetes label syntax. Un-prefixed names are reserved for IANA standard service names (as per RFC-6335 and http://www.iana.org/assignments/service-names). Non-standard protocols should use prefixed names such as mycompany.com/my-custom-protocol.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of this port within the service. This must be a DNS_LABEL. All ports within a ServiceSpec must have unique names. When considering the endpoints for a Service, this must match the 'name' field in the EndpointPort. Optional if only one ServicePort is defined on this service.
                  "%
                  | optional,
                nodePort
                  | std.number.Integer
                  | doc m%"
                  The port on each node on which this service is exposed when type is NodePort or LoadBalancer.  Usually assigned by the system. If a value is specified, in-range, and not in use it will be used, otherwise the operation will fail.  If not specified, a port will be allocated if this Service requires one.  If this field is specified when creating a Service which does not need it, creation will fail. This field will be wiped when updating a Service to no longer need it (e.g. changing type from NodePort to ClusterIP). More info: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
                  "%
                  | optional,
                port
                  | std.number.Integer
                  | doc m%"
                  The port that will be exposed by this service.
                  "%,
                protocol
                  | std.enum.TagOrString
                  | [| 'UDP, 'TCP, 'SCTP |]
                  | doc m%"
                  The IP protocol for this port. Supports "TCP", "UDP", and "SCTP". Default is TCP.
                  
                  Possible enum values:
                   - `"SCTP"` is the SCTP protocol.
                   - `"TCP"` is the TCP protocol.
                   - `"UDP"` is the UDP protocol.
                  "%
                  | optional,
                targetPort
                  | definitions.contract."io.k8s.apimachinery.pkg.util.intstr.IntOrString"
                  | doc m%"
                  Number or name of the port to access on the pods targeted by the service. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME. If this is a string, it will be looked up as a named port in the target Pod's container ports. If this is not specified, the value of the 'port' field is used (an identity map). This field is ignored for services with clusterIP=None, and should be omitted or set equal to the 'port' field. More info: https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.StorageOSVolumeSource"
            | doc m%"
            Represents a StorageOS persistent volume resource.
            "%
            = {
                fsType
                  | String
                  | doc m%"
                  Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
                  "%
                  | optional,
                secretRef
                  | definitions.contract."io.k8s.api.core.v1.LocalObjectReference"
                  | doc m%"
                  SecretRef specifies the secret to use for obtaining the StorageOS API credentials.  If not specified, default values will be attempted.
                  "%
                  | optional,
                volumeName
                  | String
                  | doc m%"
                  VolumeName is the human-readable name of the StorageOS volume.  Volume names are only unique within a namespace.
                  "%
                  | optional,
                volumeNamespace
                  | String
                  | doc m%"
                  VolumeNamespace specifies the scope of the volume within StorageOS.  If no namespace is specified then the Pod's namespace will be used.  This allows the Kubernetes name scoping to be mirrored within StorageOS for tighter integration. Set VolumeName to any name to override the default behaviour. Set to "default" if you are not using namespaces within StorageOS. Namespaces that do not pre-exist within StorageOS will be created.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.Sysctl"
            | doc m%"
            Sysctl defines a kernel parameter to be set
            "%
            = {
                name
                  | String
                  | doc m%"
                  Name of a property to set
                  "%,
                value
                  | String
                  | doc m%"
                  Value of a property to set
                  "%,
                ..
              },
          "io.k8s.api.core.v1.TCPSocketAction"
            | doc m%"
            TCPSocketAction describes an action based on opening a socket
            "%
            = {
                host
                  | String
                  | doc m%"
                  Optional: Host name to connect to, defaults to the pod IP.
                  "%
                  | optional,
                port
                  | definitions.contract."io.k8s.apimachinery.pkg.util.intstr.IntOrString"
                  | doc m%"
                  Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                  "%,
                ..
              },
          "io.k8s.api.core.v1.Toleration"
            | doc m%"
            The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>.
            "%
            = {
                effect
                  | std.enum.TagOrString
                  | [| 'PreferNoSchedule, 'NoSchedule, 'NoExecute |]
                  | doc m%"
                  Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute.
                  
                  Possible enum values:
                   - `"NoExecute"` Evict any already-running pods that do not tolerate the taint. Currently enforced by NodeController.
                   - `"NoSchedule"` Do not allow new pods to schedule onto the node unless they tolerate the taint, but allow all pods submitted to Kubelet without going through the scheduler to start, and allow all already-running pods to continue running. Enforced by the scheduler.
                   - `"PreferNoSchedule"` Like TaintEffectNoSchedule, but the scheduler tries not to schedule new pods onto the node, rather than prohibiting new pods from scheduling onto the node entirely. Enforced by the scheduler.
                  "%
                  | optional,
                key
                  | String
                  | doc m%"
                  Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys.
                  "%
                  | optional,
                operator
                  | std.enum.TagOrString
                  | [| 'Exists, 'Equal |]
                  | doc m%"
                  Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category.
                  
                  Possible enum values:
                   - `"Equal"`
                   - `"Exists"`
                  "%
                  | optional,
                tolerationSeconds
                  | std.number.Integer
                  | doc m%"
                  TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system.
                  "%
                  | optional,
                value
                  | String
                  | doc m%"
                  Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.TypedLocalObjectReference"
            | doc m%"
            TypedLocalObjectReference contains enough information to let you locate the typed referenced object inside the same namespace.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.api.core.v1.TypedLocalObjectReference",
          "io.k8s.api.core.v1.Volume"
            | doc m%"
            Volume represents a named volume in a pod that may be accessed by any container in the pod.
            "%
            = {
                awsElasticBlockStore
                  | definitions.contract."io.k8s.api.core.v1.AWSElasticBlockStoreVolumeSource"
                  | doc m%"
                  AWSElasticBlockStore represents an AWS Disk resource that is attached to a kubelet's host machine and then exposed to the pod. More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
                  "%
                  | optional,
                azureDisk
                  | definitions.contract."io.k8s.api.core.v1.AzureDiskVolumeSource"
                  | doc m%"
                  AzureDisk represents an Azure Data Disk mount on the host and bind mount to the pod.
                  "%
                  | optional,
                azureFile
                  | definitions.contract."io.k8s.api.core.v1.AzureFileVolumeSource"
                  | doc m%"
                  AzureFile represents an Azure File Service mount on the host and bind mount to the pod.
                  "%
                  | optional,
                cephfs
                  | definitions.contract."io.k8s.api.core.v1.CephFSVolumeSource"
                  | doc m%"
                  CephFS represents a Ceph FS mount on the host that shares a pod's lifetime
                  "%
                  | optional,
                cinder
                  | definitions.contract."io.k8s.api.core.v1.CinderVolumeSource"
                  | doc m%"
                  Cinder represents a cinder volume attached and mounted on kubelets host machine. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
                  "%
                  | optional,
                configMap
                  | definitions.contract."io.k8s.api.core.v1.ConfigMapVolumeSource"
                  | doc m%"
                  ConfigMap represents a configMap that should populate this volume
                  "%
                  | optional,
                csi
                  | definitions.contract."io.k8s.api.core.v1.CSIVolumeSource"
                  | doc m%"
                  CSI (Container Storage Interface) represents ephemeral storage that is handled by certain external CSI drivers (Beta feature).
                  "%
                  | optional,
                downwardAPI
                  | definitions.contract."io.k8s.api.core.v1.DownwardAPIVolumeSource"
                  | doc m%"
                  DownwardAPI represents downward API about the pod that should populate this volume
                  "%
                  | optional,
                emptyDir
                  | definitions.contract."io.k8s.api.core.v1.EmptyDirVolumeSource"
                  | doc m%"
                  EmptyDir represents a temporary directory that shares a pod's lifetime. More info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir
                  "%
                  | optional,
                ephemeral
                  | definitions.contract."io.k8s.api.core.v1.EphemeralVolumeSource"
                  | doc m%"
                  Ephemeral represents a volume that is handled by a cluster storage driver. The volume's lifecycle is tied to the pod that defines it - it will be created before the pod starts, and deleted when the pod is removed.
                  
                  Use this if: a) the volume is only needed while the pod runs, b) features of normal volumes like restoring from snapshot or capacity
                     tracking are needed,
                  c) the storage driver is specified through a storage class, and d) the storage driver supports dynamic volume provisioning through
                     a PersistentVolumeClaim (see EphemeralVolumeSource for more
                     information on the connection between this volume type
                     and PersistentVolumeClaim).
                  
                  Use PersistentVolumeClaim or one of the vendor-specific APIs for volumes that persist for longer than the lifecycle of an individual pod.
                  
                  Use CSI for light-weight local ephemeral volumes if the CSI driver is meant to be used that way - see the documentation of the driver for more information.
                  
                  A pod can use both types of ephemeral volumes and persistent volumes at the same time.
                  "%
                  | optional,
                fc
                  | definitions.contract."io.k8s.api.core.v1.FCVolumeSource"
                  | doc m%"
                  FC represents a Fibre Channel resource that is attached to a kubelet's host machine and then exposed to the pod.
                  "%
                  | optional,
                flexVolume
                  | definitions.contract."io.k8s.api.core.v1.FlexVolumeSource"
                  | doc m%"
                  FlexVolume represents a generic volume resource that is provisioned/attached using an exec based plugin.
                  "%
                  | optional,
                flocker
                  | definitions.contract."io.k8s.api.core.v1.FlockerVolumeSource"
                  | doc m%"
                  Flocker represents a Flocker volume attached to a kubelet's host machine. This depends on the Flocker control service being running
                  "%
                  | optional,
                gcePersistentDisk
                  | definitions.contract."io.k8s.api.core.v1.GCEPersistentDiskVolumeSource"
                  | doc m%"
                  GCEPersistentDisk represents a GCE Disk resource that is attached to a kubelet's host machine and then exposed to the pod. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
                  "%
                  | optional,
                gitRepo
                  | definitions.contract."io.k8s.api.core.v1.GitRepoVolumeSource"
                  | doc m%"
                  GitRepo represents a git repository at a particular revision. DEPRECATED: GitRepo is deprecated. To provision a container with a git repo, mount an EmptyDir into an InitContainer that clones the repo using git, then mount the EmptyDir into the Pod's container.
                  "%
                  | optional,
                glusterfs
                  | definitions.contract."io.k8s.api.core.v1.GlusterfsVolumeSource"
                  | doc m%"
                  Glusterfs represents a Glusterfs mount on the host that shares a pod's lifetime. More info: https://examples.k8s.io/volumes/glusterfs/README.md
                  "%
                  | optional,
                hostPath
                  | definitions.contract."io.k8s.api.core.v1.HostPathVolumeSource"
                  | doc m%"
                  HostPath represents a pre-existing file or directory on the host machine that is directly exposed to the container. This is generally used for system agents or other privileged things that are allowed to see the host machine. Most containers will NOT need this. More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath
                  "%
                  | optional,
                iscsi
                  | definitions.contract."io.k8s.api.core.v1.ISCSIVolumeSource"
                  | doc m%"
                  ISCSI represents an ISCSI Disk resource that is attached to a kubelet's host machine and then exposed to the pod. More info: https://examples.k8s.io/volumes/iscsi/README.md
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Volume's name. Must be a DNS_LABEL and unique within the pod. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                  "%,
                nfs
                  | definitions.contract."io.k8s.api.core.v1.NFSVolumeSource"
                  | doc m%"
                  NFS represents an NFS mount on the host that shares a pod's lifetime More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
                  "%
                  | optional,
                persistentVolumeClaim
                  | definitions.contract."io.k8s.api.core.v1.PersistentVolumeClaimVolumeSource"
                  | doc m%"
                  PersistentVolumeClaimVolumeSource represents a reference to a PersistentVolumeClaim in the same namespace. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims
                  "%
                  | optional,
                photonPersistentDisk
                  | definitions.contract."io.k8s.api.core.v1.PhotonPersistentDiskVolumeSource"
                  | doc m%"
                  PhotonPersistentDisk represents a PhotonController persistent disk attached and mounted on kubelets host machine
                  "%
                  | optional,
                portworxVolume
                  | definitions.contract."io.k8s.api.core.v1.PortworxVolumeSource"
                  | doc m%"
                  PortworxVolume represents a portworx volume attached and mounted on kubelets host machine
                  "%
                  | optional,
                projected
                  | definitions.contract."io.k8s.api.core.v1.ProjectedVolumeSource"
                  | doc m%"
                  Items for all in one resources secrets, configmaps, and downward API
                  "%
                  | optional,
                quobyte
                  | definitions.contract."io.k8s.api.core.v1.QuobyteVolumeSource"
                  | doc m%"
                  Quobyte represents a Quobyte mount on the host that shares a pod's lifetime
                  "%
                  | optional,
                rbd
                  | definitions.contract."io.k8s.api.core.v1.RBDVolumeSource"
                  | doc m%"
                  RBD represents a Rados Block Device mount on the host that shares a pod's lifetime. More info: https://examples.k8s.io/volumes/rbd/README.md
                  "%
                  | optional,
                scaleIO
                  | definitions.contract."io.k8s.api.core.v1.ScaleIOVolumeSource"
                  | doc m%"
                  ScaleIO represents a ScaleIO persistent volume attached and mounted on Kubernetes nodes.
                  "%
                  | optional,
                secret
                  | definitions.contract."io.k8s.api.core.v1.SecretVolumeSource"
                  | doc m%"
                  Secret represents a secret that should populate this volume. More info: https://kubernetes.io/docs/concepts/storage/volumes#secret
                  "%
                  | optional,
                storageos
                  | definitions.contract."io.k8s.api.core.v1.StorageOSVolumeSource"
                  | doc m%"
                  StorageOS represents a StorageOS volume attached and mounted on Kubernetes nodes.
                  "%
                  | optional,
                vsphereVolume
                  | definitions.contract."io.k8s.api.core.v1.VsphereVirtualDiskVolumeSource"
                  | doc m%"
                  VsphereVolume represents a vSphere volume attached and mounted on kubelets host machine
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.VolumeDevice"
            | doc m%"
            volumeDevice describes a mapping of a raw block device within a container.
            "%
            = {
                devicePath
                  | String
                  | doc m%"
                  devicePath is the path inside of the container that the device will be mapped to.
                  "%,
                name
                  | String
                  | doc m%"
                  name must match the name of a persistentVolumeClaim in the pod
                  "%,
                ..
              },
          "io.k8s.api.core.v1.VolumeMount"
            | doc m%"
            VolumeMount describes a mounting of a Volume within a container.
            "%
            = {
                mountPath
                  | String
                  | doc m%"
                  Path within the container at which the volume should be mounted.  Must not contain ':'.
                  "%,
                mountPropagation
                  | String
                  | doc m%"
                  mountPropagation determines how mounts are propagated from the host to container and the other way around. When not set, MountPropagationNone is used. This field is beta in 1.10.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  This must match the Name of a Volume.
                  "%,
                readOnly
                  | Bool
                  | doc m%"
                  Mounted read-only if true, read-write otherwise (false or unspecified). Defaults to false.
                  "%
                  | optional,
                subPath
                  | String
                  | doc m%"
                  Path within the volume from which the container's volume should be mounted. Defaults to "" (volume's root).
                  "%
                  | optional,
                subPathExpr
                  | String
                  | doc m%"
                  Expanded path within the volume from which the container's volume should be mounted. Behaves similarly to SubPath but environment variable references $(VAR_NAME) are expanded using the container's environment. Defaults to "" (volume's root). SubPathExpr and SubPath are mutually exclusive.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.VolumeProjection"
            | doc m%"
            Projection that may be projected along with other supported volume types
            "%
            = {
                configMap
                  | definitions.contract."io.k8s.api.core.v1.ConfigMapProjection"
                  | doc m%"
                  information about the configMap data to project
                  "%
                  | optional,
                downwardAPI
                  | definitions.contract."io.k8s.api.core.v1.DownwardAPIProjection"
                  | doc m%"
                  information about the downwardAPI data to project
                  "%
                  | optional,
                secret
                  | definitions.contract."io.k8s.api.core.v1.SecretProjection"
                  | doc m%"
                  information about the secret data to project
                  "%
                  | optional,
                serviceAccountToken
                  | definitions.contract."io.k8s.api.core.v1.ServiceAccountTokenProjection"
                  | doc m%"
                  information about the serviceAccountToken data to project
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.core.v1.VsphereVirtualDiskVolumeSource"
            | doc m%"
            Represents a vSphere volume resource.
            "%
            = {
                fsType
                  | String
                  | doc m%"
                  Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
                  "%
                  | optional,
                storagePolicyID
                  | String
                  | doc m%"
                  Storage Policy Based Management (SPBM) profile ID associated with the StoragePolicyName.
                  "%
                  | optional,
                storagePolicyName
                  | String
                  | doc m%"
                  Storage Policy Based Management (SPBM) profile name.
                  "%
                  | optional,
                volumePath
                  | String
                  | doc m%"
                  Path that identifies vSphere volume vmdk
                  "%,
                ..
              },
          "io.k8s.api.core.v1.WeightedPodAffinityTerm"
            | doc m%"
            The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)
            "%
            = {
                podAffinityTerm
                  | definitions.contract."io.k8s.api.core.v1.PodAffinityTerm"
                  | doc m%"
                  Required. A pod affinity term, associated with the corresponding weight.
                  "%,
                weight
                  | std.number.Integer
                  | doc m%"
                  weight associated with matching the corresponding podAffinityTerm, in the range 1-100.
                  "%,
                ..
              },
          "io.k8s.api.core.v1.WindowsSecurityContextOptions"
            | doc m%"
            WindowsSecurityContextOptions contain Windows-specific options and credentials.
            "%
            = {
                gmsaCredentialSpec
                  | String
                  | doc m%"
                  GMSACredentialSpec is where the GMSA admission webhook (https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the GMSA credential spec named by the GMSACredentialSpecName field.
                  "%
                  | optional,
                gmsaCredentialSpecName
                  | String
                  | doc m%"
                  GMSACredentialSpecName is the name of the GMSA credential spec to use.
                  "%
                  | optional,
                hostProcess
                  | Bool
                  | doc m%"
                  HostProcess determines if a container should be run as a 'Host Process' container. This field is alpha-level and will only be honored by components that enable the WindowsHostProcessContainers feature flag. Setting this field without the feature flag will result in errors when validating the Pod. All of a Pod's containers must have the same effective HostProcess value (it is not allowed to have a mix of HostProcess containers and non-HostProcess containers).  In addition, if HostProcess is true then HostNetwork must also be set to true.
                  "%
                  | optional,
                runAsUserName
                  | String
                  | doc m%"
                  The UserName in Windows to run the entrypoint of the container process. Defaults to the user specified in image metadata if unspecified. May also be set in PodSecurityContext. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
                  "%
                  | optional,
                ..
              },
          "io.k8s.api.policy.v1.PodDisruptionBudgetSpec"
            | doc m%"
            PodDisruptionBudgetSpec is a description of a PodDisruptionBudget.
            "%
            = {
                maxUnavailable
                  | definitions.contract."io.k8s.apimachinery.pkg.util.intstr.IntOrString"
                  | doc m%"
                  An eviction is allowed if at most "maxUnavailable" pods selected by "selector" are unavailable after the eviction, i.e. even in absence of the evicted pod. For example, one can prevent all voluntary evictions by specifying 0. This is a mutually exclusive setting with "minAvailable".
                  "%
                  | optional,
                minAvailable
                  | definitions.contract."io.k8s.apimachinery.pkg.util.intstr.IntOrString"
                  | doc m%"
                  An eviction is allowed if at least "minAvailable" pods selected by "selector" will still be available after the eviction, i.e. even in the absence of the evicted pod.  So for example you can prevent all voluntary evictions by specifying "100%".
                  "%
                  | optional,
                selector
                  | predicates.contract_from_predicate
                  definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector"
                  | doc m%"
                  Label query over pods whose evictions are managed by the disruption budget. A null selector will match no pods, while an empty ({}) selector will select all pods within the namespace.
                  "%
                  | optional,
                ..
              },
          "io.k8s.apimachinery.pkg.api.resource.Quantity"
            | doc m%"
            Quantity is a fixed-point representation of a number. It provides convenient marshaling/unmarshaling in JSON and YAML, in addition to String() and AsInt64() accessors.
            
            The serialization format is:
            
            <quantity>        ::= <signedNumber><suffix>
              (Note that <suffix> may be empty, from the "" case in <decimalSI>.)
            <digit>           ::= 0 | 1 | ... | 9 <digits>          ::= <digit> | <digit><digits> <number>          ::= <digits> | <digits>.<digits> | <digits>. | .<digits> <sign>            ::= "+" | "-" <signedNumber>    ::= <number> | <sign><number> <suffix>          ::= <binarySI> | <decimalExponent> | <decimalSI> <binarySI>        ::= Ki | Mi | Gi | Ti | Pi | Ei
              (International System of units; See: http://physics.nist.gov/cuu/Units/binary.html)
            <decimalSI>       ::= m | "" | k | M | G | T | P | E
              (Note that 1024 = 1Ki but 1000 = 1k; I didn't choose the capitalization.)
            <decimalExponent> ::= "e" <signedNumber> | "E" <signedNumber>
            
            No matter which of the three exponent forms is used, no quantity may represent a number greater than 2^63-1 in magnitude, nor may it have more than 3 decimal places. Numbers larger or more precise will be capped or rounded up. (E.g.: 0.1m will rounded up to 1m.) This may be extended in the future if we require larger or smaller quantities.
            
            When a Quantity is parsed from a string, it will remember the type of suffix it had, and will use the same type again when it is serialized.
            
            Before serializing, Quantity will be put in "canonical form". This means that Exponent/suffix will be adjusted up or down (with a corresponding increase or decrease in Mantissa) such that:
              a. No precision is lost
              b. No fractional digits will be emitted
              c. The exponent (or suffix) is as large as possible.
            The sign will be omitted unless the number is negative.
            
            Examples:
              1.5 will be serialized as "1500m"
              1.5Gi will be serialized as "1536Mi"
            
            Note that the quantity will NEVER be internally represented by a floating point number. That is the whole point of this exercise.
            
            Non-canonical values will still parse as long as they are well formed, but will be re-emitted in their canonical form. (So always use canonical form, or don't diff.)
            
            This format is intended to make it difficult to use these numbers without writing some sort of special handling code in the hopes that that will cause implementors to also use a fixed point implementation.
            "%
            = String,
          "io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions"
            | doc m%"
            CreateOptions may be provided when creating an API object.
            "%
            = {
                dryRun
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                fieldManager | String | optional,
                fieldValidation | String | optional,
                ..
              },
          "io.k8s.apimachinery.pkg.apis.meta.v1.Duration"
            | doc m%"
            Duration is a wrapper around time.Duration which supports correct
            marshaling to YAML and JSON. In particular, it marshals into strings, which
            can be used as map keys in json.
            "%
            = { duration | String | optional, .. },
          "io.k8s.apimachinery.pkg.apis.meta.v1.FieldsV1"
            | doc m%"
            FieldsV1 stores a set of fields in a data structure like a Trie, in JSON format.
            
            Each key is either a '.' representing the field itself, and will always map to an empty set, or a string representing a sub-field or item. The string will follow one of these four formats: 'f:<name>', where <name> is the name of a field in a struct, or key in a map 'v:<value>', where <value> is the exact json formatted value of a list item 'i:<index>', where <index> is position of a item in a list 'k:<keys>', where <keys> is a map of  a list item's key fields to their unique values If a key maps to an empty Fields value, the field that key represents is part of the set.
            
            The exact format is defined in sigs.k8s.io/structured-merge-diff
            "%
            = {  .. },
          "io.k8s.apimachinery.pkg.apis.meta.v1.GroupVersionResource"
            | doc m%"
            +protobuf.options.(gogoproto.goproto_stringer)=false
            "%
            = {
                group | String | optional,
                resource | String | optional,
                version | String | optional,
                ..
              },
          "io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector"
            | doc m%"
            A label selector is a label query over a set of resources. The result of matchLabels and matchExpressions are ANDed. An empty label selector matches all objects. A null label selector matches no objects.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector",
          "io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelectorRequirement"
            | doc m%"
            A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.
            "%
            = {
                key
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  key is the label key that the selector applies to.
                  "%,
                operator
                  | String
                  | doc m%"
                  operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.
                  "%,
                values
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.
                  "%
                  | optional,
                ..
              },
          "io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta"
            | doc m%"
            ListMeta describes metadata that synthetic resources must have, including lists and various status objects. A resource may have only one of {ObjectMeta, ListMeta}.
            "%
            = {
                continue
                  | String
                  | doc m%"
                  continue may be set if the user set a limit on the number of items returned, and indicates that the server has more data available. The value is opaque and may be used to issue another request to the endpoint that served this list to retrieve the next set of available objects. Continuing a consistent list may not be possible if the server configuration has changed or more than a few minutes have passed. The resourceVersion field returned when using this continue value will be identical to the value in the first response, unless you have received this token from an error message.
                  "%
                  | optional,
                remainingItemCount
                  | std.number.Integer
                  | doc m%"
                  remainingItemCount is the number of subsequent items in the list which are not included in this list response. If the list request contained label or field selectors, then the number of remaining items is unknown and the field will be left unset and omitted during serialization. If the list is complete (either because it is not chunking or because this is the last chunk), then there are no more remaining items and this field will be left unset and omitted during serialization. Servers older than v1.15 do not set this field. The intended use of the remainingItemCount is *estimating* the size of a collection. Clients should not rely on the remainingItemCount to be set or to be exact.
                  "%
                  | optional,
                resourceVersion
                  | String
                  | doc m%"
                  String that identifies the server's internal version of this object that can be used by clients to determine when objects have changed. Value must be treated as opaque by clients and passed unmodified back to the server. Populated by the system. Read-only. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#concurrency-control-and-consistency
                  "%
                  | optional,
                selfLink
                  | String
                  | doc m%"
                  selfLink is a URL representing this object. Populated by the system. Read-only.
                  
                  DEPRECATED Kubernetes will stop propagating this field in 1.20 release and the field is planned to be removed in 1.21 release.
                  "%
                  | optional,
                ..
              },
          "io.k8s.apimachinery.pkg.apis.meta.v1.ManagedFieldsEntry"
            | doc m%"
            ManagedFieldsEntry is a workflow-id, a FieldSet and the group version of the resource that the fieldset applies to.
            "%
            = {
                apiVersion
                  | String
                  | doc m%"
                  APIVersion defines the version of this resource that this field set applies to. The format is "group/version" just like the top-level APIVersion field. It is necessary to track the version of a field set because it cannot be automatically converted.
                  "%
                  | optional,
                fieldsType
                  | String
                  | doc m%"
                  FieldsType is the discriminator for the different fields format and version. There is currently only one possible value: "FieldsV1"
                  "%
                  | optional,
                fieldsV1
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.FieldsV1"
                  | doc m%"
                  FieldsV1 holds the first JSON version format as described in the "FieldsV1" type.
                  "%
                  | optional,
                manager
                  | String
                  | doc m%"
                  Manager is an identifier of the workflow managing these fields.
                  "%
                  | optional,
                operation
                  | String
                  | doc m%"
                  Operation is the type of operation which lead to this ManagedFieldsEntry being created. The only valid values for this field are 'Apply' and 'Update'.
                  "%
                  | optional,
                subresource
                  | String
                  | doc m%"
                  Subresource is the name of the subresource used to update that object, or empty string if the object was updated through the main resource. The value of this field is used to distinguish between managers, even if they share the same name. For example, a status update will be distinct from a regular update using the same manager name. Note that the APIVersion field is not related to the Subresource field and it always corresponds to the version of the main resource.
                  "%
                  | optional,
                time
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | doc m%"
                  Time is timestamp of when these fields were set. It should always be empty if Operation is 'Apply'
                  "%
                  | optional,
                ..
              },
          "io.k8s.apimachinery.pkg.apis.meta.v1.MicroTime"
            | doc m%"
            MicroTime is version of Time with microsecond level precision.
            "%
            = String,
          "io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta"
            | doc m%"
            ObjectMeta is metadata that all persisted resources must have, which includes all objects users must create.
            "%
            = {
                annotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Annotations is an unstructured key value map stored with a resource that may be set by external tools to store and retrieve arbitrary metadata. They are not queryable and should be preserved when modifying objects. More info: http://kubernetes.io/docs/user-guide/annotations
                  "%
                  | optional,
                clusterName
                  | String
                  | doc m%"
                  The name of the cluster which the object belongs to. This is used to distinguish resources with same name and namespace in different clusters. This field is not set anywhere right now and apiserver is going to ignore it if set in create or update request.
                  "%
                  | optional,
                creationTimestamp
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | doc m%"
                  CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC.
                  
                  Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
                  "%
                  | optional,
                deletionGracePeriodSeconds
                  | std.number.Integer
                  | doc m%"
                  Number of seconds allowed for this object to gracefully terminate before it will be removed from the system. Only set when deletionTimestamp is also set. May only be shortened. Read-only.
                  "%
                  | optional,
                deletionTimestamp
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | doc m%"
                  DeletionTimestamp is RFC 3339 date and time at which this resource will be deleted. This field is set by the server when a graceful deletion is requested by the user, and is not directly settable by a client. The resource is expected to be deleted (no longer visible from resource lists, and not reachable by name) after the time in this field, once the finalizers list is empty. As long as the finalizers list contains items, deletion is blocked. Once the deletionTimestamp is set, this value may not be unset or be set further into the future, although it may be shortened or the resource may be deleted prior to this time. For example, a user may request that a pod is deleted in 30 seconds. The Kubelet will react by sending a graceful termination signal to the containers in the pod. After that 30 seconds, the Kubelet will send a hard termination signal (SIGKILL) to the container and after cleanup, remove the pod from the API. In the presence of network partitions, this object may still exist after this timestamp, until an administrator or automated process can determine the resource is fully terminated. If not set, graceful deletion of the object has not been requested.
                  
                  Populated by the system when a graceful deletion is requested. Read-only. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
                  "%
                  | optional,
                finalizers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Must be empty before the object is deleted from the registry. Each entry is an identifier for the responsible component that will remove the entry from the list. If the deletionTimestamp of the object is non-nil, entries in this list can only be removed. Finalizers may be processed and removed in any order.  Order is NOT enforced because it introduces significant risk of stuck finalizers. finalizers is a shared field, any actor with permission can reorder it. If the finalizer list is processed in order, then this can lead to a situation in which the component responsible for the first finalizer in the list is waiting for a signal (field value, external system, or other) produced by a component responsible for a finalizer later in the list, resulting in a deadlock. Without enforced ordering finalizers are free to order amongst themselves and are not vulnerable to ordering changes in the list.
                  "%
                  | optional,
                generateName
                  | String
                  | doc m%"
                  GenerateName is an optional prefix, used by the server, to generate a unique name ONLY IF the Name field has not been provided. If this field is used, the name returned to the client will be different than the name passed. This value will also be combined with a unique suffix. The provided value has the same validation rules as the Name field, and may be truncated by the length of the suffix required to make the value unique on the server.
                  
                  If this field is specified and the generated name exists, the server will NOT return a 409 - instead, it will either return 201 Created or 500 with Reason ServerTimeout indicating a unique name could not be found in the time allotted, and the client should retry (optionally after the time indicated in the Retry-After header).
                  
                  Applied only if Name is not specified. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#idempotency
                  "%
                  | optional,
                generation
                  | std.number.Integer
                  | doc m%"
                  A sequence number representing a specific generation of the desired state. Populated by the system. Read-only.
                  "%
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels
                  "%
                  | optional,
                managedFields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ManagedFieldsEntry"
                  ])
                  | doc m%"
                  ManagedFields maps workflow-id and version to the set of fields that are managed by that workflow. This is mostly for internal housekeeping, and users typically shouldn't need to set or understand this field. A workflow can be the user's name, a controller's name, or the name of a specific apply path like "ci-cd". The set of fields is always in the version that the workflow used when modifying the object.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name must be unique within a namespace. Is required when creating resources, although some resources may allow a client to request the generation of an appropriate name automatically. Name is primarily intended for creation idempotence and configuration definition. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/identifiers#names
                  "%
                  | optional,
                namespace
                  | String
                  | doc m%"
                  Namespace defines the space within which each name must be unique. An empty namespace is equivalent to the "default" namespace, but "default" is the canonical representation. Not all objects are required to be scoped to a namespace - the value of this field for those objects will be empty.
                  
                  Must be a DNS_LABEL. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/namespaces
                  "%
                  | optional,
                ownerReferences
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.OwnerReference"
                  ])
                  | doc m%"
                  List of objects depended by this object. If ALL objects in the list have been deleted, this object will be garbage collected. If this object is managed by a controller, then an entry in this list will point to this controller, with the controller field set to true. There cannot be more than one managing controller.
                  "%
                  | optional,
                resourceVersion
                  | String
                  | doc m%"
                  An opaque value that represents the internal version of this object that can be used by clients to determine when objects have changed. May be used for optimistic concurrency, change detection, and the watch operation on a resource or set of resources. Clients must treat these values as opaque and passed unmodified back to the server. They may only be valid for a particular resource or set of resources.
                  
                  Populated by the system. Read-only. Value must be treated as opaque by clients and . More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#concurrency-control-and-consistency
                  "%
                  | optional,
                selfLink
                  | String
                  | doc m%"
                  SelfLink is a URL representing this object. Populated by the system. Read-only.
                  
                  DEPRECATED Kubernetes will stop propagating this field in 1.20 release and the field is planned to be removed in 1.21 release.
                  "%
                  | optional,
                uid
                  | String
                  | doc m%"
                  UID is the unique in time and space value for this object. It is typically generated by the server on successful creation of a resource and is not allowed to change on PUT operations.
                  
                  Populated by the system. Read-only. More info: http://kubernetes.io/docs/user-guide/identifiers#uids
                  "%
                  | optional,
                ..
              },
          "io.k8s.apimachinery.pkg.apis.meta.v1.OwnerReference"
            | doc m%"
            OwnerReference contains enough information to let you identify an owning object. An owning object must be in the same namespace as the dependent, or be cluster-scoped, so there is no namespace field.
            "%
            = predicates.contract_from_predicate
              definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.OwnerReference",
          "io.k8s.apimachinery.pkg.apis.meta.v1.StatusCause"
            | doc m%"
            StatusCause provides more information about an api.Status failure, including cases when multiple errors are encountered.
            "%
            = {
                field
                  | String
                  | doc m%"
                  The field of the resource that has caused this error, as named by its JSON serialization. May include dot and postfix notation for nested attributes. Arrays are zero-indexed.  Fields may appear more than once in an array of causes due to fields having multiple errors. Optional.
                  
                  Examples:
                    "name" - the field "name" on the current resource
                    "items[0].name" - the field "name" on the first array entry in "items"
                  "%
                  | optional,
                message
                  | String
                  | doc m%"
                  A human-readable description of the cause of the error.  This field may be presented as-is to a reader.
                  "%
                  | optional,
                reason
                  | String
                  | doc m%"
                  A machine-readable description of the cause of the error. If this value is empty there is no information available.
                  "%
                  | optional,
                ..
              },
          "io.k8s.apimachinery.pkg.apis.meta.v1.Time"
            | doc m%"
            Time is a wrapper around time.Time which supports correct marshaling to YAML and JSON.  Wrappers are provided for many of the factory methods that the time package offers.
            "%
            = String,
          "io.k8s.apimachinery.pkg.util.intstr.IntOrString" = String,
          "sensor.CreateSensorRequest" = {
                createOptions
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions"
                  | optional,
                namespace | String | optional,
                sensor
                  | definitions.contract."io.argoproj.events.v1alpha1.Sensor"
                  | optional,
                ..
              },
          "sensor.DeleteSensorResponse" = {  .. },
          "sensor.LogEntry" = {
                dependencyName | String | optional,
                eventContext | String | optional,
                level | String | optional,
                msg | String | optional,
                namespace | String | optional,
                sensorName | String | optional,
                time
                  | definitions.contract."io.k8s.apimachinery.pkg.apis.meta.v1.Time"
                  | optional,
                triggerName | String | optional,
                ..
              },
          "sensor.SensorWatchEvent" = {
                object
                  | definitions.contract."io.argoproj.events.v1alpha1.Sensor"
                  | optional,
                type | String | optional,
                ..
              },
          "sensor.UpdateSensorRequest" = {
                name | String | optional,
                namespace | String | optional,
                sensor
                  | definitions.contract."io.argoproj.events.v1alpha1.Sensor"
                  | optional,
                ..
              },
        },
    predicate = {
          "eventsource.CreateEventSourceRequest" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  eventSource =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSource",
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "eventsource.EventSourceDeletedResponse" = predicates.isType 'Record,
          "eventsource.EventSourceWatchEvent" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  object =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSource",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "eventsource.LogEntry" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  eventName = predicates.isType '"String",
                  eventSourceName = predicates.isType '"String",
                  eventSourceType = predicates.isType '"String",
                  level = predicates.isType '"String",
                  msg = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  time =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                }
                {  }
                true
                predicates.always
              ],
          "eventsource.UpdateEventSourceRequest" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  eventSource =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSource",
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "google.protobuf.Any" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  type_url = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "grpc.gateway.runtime.Error" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  code = predicates.isType 'Integer,
                  details = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."google.protobuf.Any"
                      ],
                  error = predicates.isType '"String",
                  message = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "grpc.gateway.runtime.StreamError" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  details = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."google.protobuf.Any"
                      ],
                  grpc_code = predicates.isType 'Integer,
                  http_code = predicates.isType 'Integer,
                  http_status = predicates.isType '"String",
                  message = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.AMQPConsumeConfig" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  autoAck = predicates.isType '"Bool",
                  consumerTag = predicates.isType '"String",
                  exclusive = predicates.isType '"Bool",
                  noLocal = predicates.isType '"Bool",
                  noWait = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.AMQPEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  auth =
                    definitions.predicate."io.argoproj.events.v1alpha1.BasicAuth",
                  connectionBackoff =
                    definitions.predicate."io.argoproj.events.v1alpha1.Backoff",
                  consume =
                    definitions.predicate."io.argoproj.events.v1alpha1.AMQPConsumeConfig",
                  exchangeDeclare =
                    definitions.predicate."io.argoproj.events.v1alpha1.AMQPExchangeDeclareConfig",
                  exchangeName = predicates.isType '"String",
                  exchangeType = predicates.isType '"String",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  jsonBody = predicates.isType '"Bool",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  queueBind =
                    definitions.predicate."io.argoproj.events.v1alpha1.AMQPQueueBindConfig",
                  queueDeclare =
                    definitions.predicate."io.argoproj.events.v1alpha1.AMQPQueueDeclareConfig",
                  routingKey = predicates.isType '"String",
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  url = predicates.isType '"String",
                  urlSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.AMQPExchangeDeclareConfig" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  autoDelete = predicates.isType '"Bool",
                  durable = predicates.isType '"Bool",
                  internal = predicates.isType '"Bool",
                  noWait = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.AMQPQueueBindConfig" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { noWait = predicates.isType '"Bool", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.AMQPQueueDeclareConfig" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  arguments = predicates.isType '"String",
                  autoDelete = predicates.isType '"Bool",
                  durable = predicates.isType '"Bool",
                  exclusive = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  noWait = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.AWSLambdaTrigger" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessKey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  functionName = predicates.isType '"String",
                  invocationType = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  payload = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  region = predicates.isType '"String",
                  roleARN = predicates.isType '"String",
                  secretKey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.Amount"
            | doc m%"
            Amount represent a numeric amount.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { value = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.ArgoWorkflowTrigger" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  operation = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  source =
                    definitions.predicate."io.argoproj.events.v1alpha1.ArtifactLocation",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.ArtifactLocation" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configmap =
                    definitions.predicate."io.k8s.api.core.v1.ConfigMapKeySelector",
                  file =
                    definitions.predicate."io.argoproj.events.v1alpha1.FileArtifact",
                  git =
                    definitions.predicate."io.argoproj.events.v1alpha1.GitArtifact",
                  inline = predicates.isType '"String",
                  resource =
                    definitions.predicate."io.argoproj.events.v1alpha1.Resource",
                  s3 =
                    definitions.predicate."io.argoproj.events.v1alpha1.S3Artifact",
                  url =
                    definitions.predicate."io.argoproj.events.v1alpha1.URLArtifact",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.AzureEventHubsTrigger" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fqdn = predicates.isType '"String",
                  hubName = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  payload = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  sharedAccessKey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  sharedAccessKeyName =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.AzureEventsHubEventSource" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  fqdn = predicates.isType '"String",
                  hubName = predicates.isType '"String",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  sharedAccessKey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  sharedAccessKeyName =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.Backoff" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  duration =
                    definitions.predicate."io.argoproj.events.v1alpha1.Int64OrString",
                  factor =
                    definitions.predicate."io.argoproj.events.v1alpha1.Amount",
                  jitter =
                    definitions.predicate."io.argoproj.events.v1alpha1.Amount",
                  steps = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.BasicAuth" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  password =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  username =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.BitbucketAuth" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  basic =
                    definitions.predicate."io.argoproj.events.v1alpha1.BitbucketBasicAuth",
                  oauthToken =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.BitbucketBasicAuth" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  password =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  username =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.BitbucketEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  auth =
                    definitions.predicate."io.argoproj.events.v1alpha1.BitbucketAuth",
                  deleteHookOnFinish = predicates.isType '"Bool",
                  events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  owner = predicates.isType '"String",
                  projectKey = predicates.isType '"String",
                  repositories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.BitbucketRepository"
                      ],
                  repositorySlug = predicates.isType '"String",
                  webhook =
                    definitions.predicate."io.argoproj.events.v1alpha1.WebhookContext",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.BitbucketRepository" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  owner = predicates.isType '"String",
                  repositorySlug = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.BitbucketServerEventSource" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessToken =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  bitbucketserverBaseURL = predicates.isType '"String",
                  deleteHookOnFinish = predicates.isType '"Bool",
                  events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  projectKey = predicates.isType '"String",
                  repositories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.BitbucketServerRepository"
                      ],
                  repositorySlug = predicates.isType '"String",
                  webhook =
                    definitions.predicate."io.argoproj.events.v1alpha1.WebhookContext",
                  webhookSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.BitbucketServerRepository" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  projectKey = predicates.isType '"String",
                  repositorySlug = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.CalendarEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  exclusionDates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  interval = predicates.isType '"String",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  persistence =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventPersistence",
                  schedule = predicates.isType '"String",
                  timezone = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.CatchupConfiguration" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  maxDuration = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.Condition" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  lastTransitionTime =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  message = predicates.isType '"String",
                  reason = predicates.isType '"String",
                  status = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.ConditionsResetByTime" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cron = predicates.isType '"String",
                  timezone = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.ConditionsResetCriteria" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  byTime =
                    definitions.predicate."io.argoproj.events.v1alpha1.ConditionsResetByTime",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.ConfigMapPersistence" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createIfNotExist = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.CustomTrigger"
            | doc m%"
            CustomTrigger refers to the specification of the custom trigger.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  certSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  payload = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  secure = predicates.isType '"Bool",
                  serverNameOverride = predicates.isType '"String",
                  serverURL = predicates.isType '"String",
                  spec = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.DataFilter" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  comparator = predicates.isType '"String",
                  path = predicates.isType '"String",
                  template = predicates.isType '"String",
                  type = predicates.isType '"String",
                  value = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.EmitterEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  broker = predicates.isType '"String",
                  channelKey = predicates.isType '"String",
                  channelName = predicates.isType '"String",
                  connectionBackoff =
                    definitions.predicate."io.argoproj.events.v1alpha1.Backoff",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  jsonBody = predicates.isType '"Bool",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  password =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  username =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.EventContext" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  datacontenttype = predicates.isType '"String",
                  id = predicates.isType '"String",
                  source = predicates.isType '"String",
                  specversion = predicates.isType '"String",
                  subject = predicates.isType '"String",
                  time =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.EventDependency" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  eventName = predicates.isType '"String",
                  eventSourceName = predicates.isType '"String",
                  filters =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventDependencyFilter",
                  filtersLogicalOperator = predicates.isType '"String",
                  name = predicates.isType '"String",
                  transform =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventDependencyTransformer",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.EventDependencyFilter"
            | doc m%"
            EventDependencyFilter defines filters and constraints for a io.argoproj.workflow.v1alpha1.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  context =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventContext",
                  data = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.DataFilter"
                      ],
                  dataLogicalOperator = predicates.isType '"String",
                  exprLogicalOperator = predicates.isType '"String",
                  exprs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.ExprFilter"
                      ],
                  script = predicates.isType '"String",
                  time =
                    definitions.predicate."io.argoproj.events.v1alpha1.TimeFilter",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.EventDependencyTransformer" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  jq = predicates.isType '"String",
                  script = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.EventPersistence" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  catchup =
                    definitions.predicate."io.argoproj.events.v1alpha1.CatchupConfiguration",
                  configMap =
                    definitions.predicate."io.argoproj.events.v1alpha1.ConfigMapPersistence",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.EventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                  spec =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceSpec",
                  status =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceStatus",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.EventSourceFilter" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { expression = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.EventSourceList" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.EventSource"
                      ],
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.EventSourceSpec" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  amqp = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.AMQPEventSource"
                      ],
                  azureEventsHub = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.AzureEventsHubEventSource"
                      ],
                  bitbucket = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.BitbucketEventSource"
                      ],
                  bitbucketserver = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.BitbucketServerEventSource"
                      ],
                  calendar = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.CalendarEventSource"
                      ],
                  emitter = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.EmitterEventSource"
                      ],
                  eventBusName = predicates.isType '"String",
                  file = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.FileEventSource"
                      ],
                  generic = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.GenericEventSource"
                      ],
                  github = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.GithubEventSource"
                      ],
                  gitlab = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.GitlabEventSource"
                      ],
                  hdfs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.HDFSEventSource"
                      ],
                  kafka = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.KafkaEventSource"
                      ],
                  minio = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.S3Artifact"
                      ],
                  mqtt = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.MQTTEventSource"
                      ],
                  nats = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.NATSEventsSource"
                      ],
                  nsq = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.NSQEventSource"
                      ],
                  pubSub = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.PubSubEventSource"
                      ],
                  pulsar = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.PulsarEventSource"
                      ],
                  redis = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.RedisEventSource"
                      ],
                  redisStream = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.RedisStreamEventSource"
                      ],
                  replicas = predicates.isType 'Integer,
                  resource = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.ResourceEventSource"
                      ],
                  service =
                    definitions.predicate."io.argoproj.events.v1alpha1.Service",
                  slack = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.SlackEventSource"
                      ],
                  sns = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.SNSEventSource"
                      ],
                  sqs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.SQSEventSource"
                      ],
                  storageGrid = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.StorageGridEventSource"
                      ],
                  stripe = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.StripeEventSource"
                      ],
                  template =
                    definitions.predicate."io.argoproj.events.v1alpha1.Template",
                  webhook = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.events.v1alpha1.WebhookEventSource"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.EventSourceStatus" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  status =
                    definitions.predicate."io.argoproj.events.v1alpha1.Status",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.ExprFilter" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  expr = predicates.isType '"String",
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.PayloadField"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.FileArtifact" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { path = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.FileEventSource"
            | doc m%"
            FileEventSource describes an event-source for file related events.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  eventType = predicates.isType '"String",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  polling = predicates.isType '"Bool",
                  watchPathConfig =
                    definitions.predicate."io.argoproj.events.v1alpha1.WatchPathConfig",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.GenericEventSource"
            | doc m%"
            GenericEventSource refers to a generic event source. It can be used to implement a custom event source.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  authSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  config = predicates.isType '"String",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  insecure = predicates.isType '"Bool",
                  jsonBody = predicates.isType '"Bool",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.GitArtifact" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  branch = predicates.isType '"String",
                  cloneDirectory = predicates.isType '"String",
                  creds =
                    definitions.predicate."io.argoproj.events.v1alpha1.GitCreds",
                  filePath = predicates.isType '"String",
                  insecureIgnoreHostKey = predicates.isType '"Bool",
                  ref = predicates.isType '"String",
                  remote =
                    definitions.predicate."io.argoproj.events.v1alpha1.GitRemoteConfig",
                  sshKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  tag = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.GitCreds" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  password =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  username =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.GitRemoteConfig" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  urls = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.GithubAppCreds" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appID = predicates.isType '"String",
                  installationID = predicates.isType '"String",
                  privateKey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.GithubEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = predicates.isType '"Bool",
                  apiToken =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  contentType = predicates.isType '"String",
                  deleteHookOnFinish = predicates.isType '"Bool",
                  events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  githubApp =
                    definitions.predicate."io.argoproj.events.v1alpha1.GithubAppCreds",
                  githubBaseURL = predicates.isType '"String",
                  githubUploadURL = predicates.isType '"String",
                  id = predicates.isType '"String",
                  insecure = predicates.isType '"Bool",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  organizations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  owner = predicates.isType '"String",
                  repositories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.OwnedRepositories"
                      ],
                  repository = predicates.isType '"String",
                  webhook =
                    definitions.predicate."io.argoproj.events.v1alpha1.WebhookContext",
                  webhookSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.GitlabEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessToken =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  deleteHookOnFinish = predicates.isType '"Bool",
                  enableSSLVerification = predicates.isType '"Bool",
                  events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  gitlabBaseURL = predicates.isType '"String",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  projectID = predicates.isType '"String",
                  projects = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  secretToken =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  webhook =
                    definitions.predicate."io.argoproj.events.v1alpha1.WebhookContext",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.HDFSEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addresses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  checkInterval = predicates.isType '"String",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  hdfsUser = predicates.isType '"String",
                  krbCCacheSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  krbConfigConfigMap =
                    definitions.predicate."io.k8s.api.core.v1.ConfigMapKeySelector",
                  krbKeytabSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  krbRealm = predicates.isType '"String",
                  krbServicePrincipalName = predicates.isType '"String",
                  krbUsername = predicates.isType '"String",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  type = predicates.isType '"String",
                  watchPathConfig =
                    definitions.predicate."io.argoproj.events.v1alpha1.WatchPathConfig",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.HTTPTrigger" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  basicAuth =
                    definitions.predicate."io.argoproj.events.v1alpha1.BasicAuth",
                  headers = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  method = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  payload = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  secureHeaders = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.SecureHeader"
                      ],
                  timeout = predicates.isType '"String",
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.Int64OrString" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  int64Val = predicates.isType '"String",
                  strVal = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.K8SResourcePolicy" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  backoff =
                    definitions.predicate."io.argoproj.events.v1alpha1.Backoff",
                  errorOnBackoffTimeout = predicates.isType '"Bool",
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.KafkaConsumerGroup" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  groupName = predicates.isType '"String",
                  oldest = predicates.isType '"Bool",
                  rebalanceStrategy = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.KafkaEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  config = predicates.isType '"String",
                  connectionBackoff =
                    definitions.predicate."io.argoproj.events.v1alpha1.Backoff",
                  consumerGroup =
                    definitions.predicate."io.argoproj.events.v1alpha1.KafkaConsumerGroup",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  jsonBody = predicates.isType '"Bool",
                  limitEventsPerSecond = predicates.isType '"String",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  partition = predicates.isType '"String",
                  sasl =
                    definitions.predicate."io.argoproj.events.v1alpha1.SASLConfig",
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  topic = predicates.isType '"String",
                  url = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.KafkaTrigger"
            | doc m%"
            KafkaTrigger refers to the specification of the Kafka trigger.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  compress = predicates.isType '"Bool",
                  flushFrequency = predicates.isType 'Integer,
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  partition = predicates.isType 'Integer,
                  partitioningKey = predicates.isType '"String",
                  payload = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  requiredAcks = predicates.isType 'Integer,
                  sasl =
                    definitions.predicate."io.argoproj.events.v1alpha1.SASLConfig",
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  topic = predicates.isType '"String",
                  url = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.LogTrigger" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { intervalSeconds = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.MQTTEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clientId = predicates.isType '"String",
                  connectionBackoff =
                    definitions.predicate."io.argoproj.events.v1alpha1.Backoff",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  jsonBody = predicates.isType '"Bool",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  topic = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.Metadata" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.NATSAuth" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  basic =
                    definitions.predicate."io.argoproj.events.v1alpha1.BasicAuth",
                  credential =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  nkey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  token =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.NATSEventsSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  auth =
                    definitions.predicate."io.argoproj.events.v1alpha1.NATSAuth",
                  connectionBackoff =
                    definitions.predicate."io.argoproj.events.v1alpha1.Backoff",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  jsonBody = predicates.isType '"Bool",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  subject = predicates.isType '"String",
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.NATSTrigger"
            | doc m%"
            NATSTrigger refers to the specification of the NATS trigger.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  payload = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  subject = predicates.isType '"String",
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.NSQEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  channel = predicates.isType '"String",
                  connectionBackoff =
                    definitions.predicate."io.argoproj.events.v1alpha1.Backoff",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  hostAddress = predicates.isType '"String",
                  jsonBody = predicates.isType '"Bool",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  topic = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.OpenWhiskTrigger"
            | doc m%"
            OpenWhiskTrigger refers to the specification of the OpenWhisk trigger.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  actionName = predicates.isType '"String",
                  authToken =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  host = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  payload = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  version = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.OwnedRepositories" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  names = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  owner = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.PayloadField"
            | doc m%"
            PayloadField binds a value at path within the event payload against a name.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  path = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.PubSubEventSource"
            | doc m%"
            PubSubEventSource refers to event-source for GCP PubSub related events.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  credentialSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  deleteSubscriptionOnFinish = predicates.isType '"Bool",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  jsonBody = predicates.isType '"Bool",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  projectID = predicates.isType '"String",
                  subscriptionID = predicates.isType '"String",
                  topic = predicates.isType '"String",
                  topicProjectID = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.PulsarEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  authTokenSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  connectionBackoff =
                    definitions.predicate."io.argoproj.events.v1alpha1.Backoff",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  jsonBody = predicates.isType '"Bool",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  tlsAllowInsecureConnection = predicates.isType '"Bool",
                  tlsTrustCertsSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  tlsValidateHostname = predicates.isType '"Bool",
                  topics = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  type = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.PulsarTrigger"
            | doc m%"
            PulsarTrigger refers to the specification of the Pulsar trigger.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  authTokenSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  connectionBackoff =
                    definitions.predicate."io.argoproj.events.v1alpha1.Backoff",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  payload = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  tlsAllowInsecureConnection = predicates.isType '"Bool",
                  tlsTrustCertsSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  tlsValidateHostname = predicates.isType '"Bool",
                  topic = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.RateLimit" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  requestsPerUnit = predicates.isType 'Integer,
                  unit = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.RedisEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  channels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  db = predicates.isType 'Integer,
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  hostAddress = predicates.isType '"String",
                  jsonBody = predicates.isType '"Bool",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  namespace = predicates.isType '"String",
                  password =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  username = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.RedisStreamEventSource" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  consumerGroup = predicates.isType '"String",
                  db = predicates.isType 'Integer,
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  hostAddress = predicates.isType '"String",
                  maxMsgCountPerRead = predicates.isType 'Integer,
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  password =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  streams = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  tls =
                    definitions.predicate."io.argoproj.events.v1alpha1.TLSConfig",
                  username = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.Resource"
            | doc m%"
            Resource represent arbitrary structured data.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { value = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.ResourceEventSource"
            | doc m%"
            ResourceEventSource refers to a event-source for K8s resource related events.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  eventTypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.ResourceFilter",
                  groupVersionResource =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.GroupVersionResource",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.ResourceFilter" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  afterStart = predicates.isType '"Bool",
                  createdBy =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.Selector"
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.Selector"
                      ],
                  prefix = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.S3Artifact" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessKey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  bucket =
                    definitions.predicate."io.argoproj.events.v1alpha1.S3Bucket",
                  endpoint = predicates.isType '"String",
                  events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.S3Filter",
                  insecure = predicates.isType '"Bool",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  region = predicates.isType '"String",
                  secretKey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.S3Bucket" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.S3Filter" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  prefix = predicates.isType '"String",
                  suffix = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.SASLConfig" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  mechanism = predicates.isType '"String",
                  password =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  user =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.SNSEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessKey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  endpoint = predicates.isType '"String",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  region = predicates.isType '"String",
                  roleARN = predicates.isType '"String",
                  secretKey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  topicArn = predicates.isType '"String",
                  validateSignature = predicates.isType '"Bool",
                  webhook =
                    definitions.predicate."io.argoproj.events.v1alpha1.WebhookContext",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.SQSEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessKey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  dlq = predicates.isType '"Bool",
                  endpoint = predicates.isType '"String",
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  jsonBody = predicates.isType '"Bool",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  queue = predicates.isType '"String",
                  queueAccountId = predicates.isType '"String",
                  region = predicates.isType '"String",
                  roleARN = predicates.isType '"String",
                  secretKey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  sessionToken =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  waitTimeSeconds = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.SecureHeader" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  valueFrom =
                    definitions.predicate."io.argoproj.events.v1alpha1.ValueFromSource",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.Selector"
            | doc m%"
            Selector represents conditional operation to select K8s objects.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  operation = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.Sensor" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                  spec =
                    definitions.predicate."io.argoproj.events.v1alpha1.SensorSpec",
                  status =
                    definitions.predicate."io.argoproj.events.v1alpha1.SensorStatus",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.SensorList" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.Sensor"
                      ],
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.SensorSpec" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  dependencies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.EventDependency"
                      ],
                  errorOnFailedRound = predicates.isType '"Bool",
                  eventBusName = predicates.isType '"String",
                  replicas = predicates.isType 'Integer,
                  template =
                    definitions.predicate."io.argoproj.events.v1alpha1.Template",
                  triggers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.Trigger"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.SensorStatus"
            | doc m%"
            SensorStatus contains information about the status of a sensor.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  status =
                    definitions.predicate."io.argoproj.events.v1alpha1.Status",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.Service" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clusterIP = predicates.isType '"String",
                  ports = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.ServicePort"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.SlackEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  signingSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  token =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  webhook =
                    definitions.predicate."io.argoproj.events.v1alpha1.WebhookContext",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.SlackTrigger"
            | doc m%"
            SlackTrigger refers to the specification of the slack notification trigger.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  channel = predicates.isType '"String",
                  message = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  slackToken =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.StandardK8STrigger" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  liveObject = predicates.isType '"Bool",
                  operation = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  patchStrategy = predicates.isType '"String",
                  source =
                    definitions.predicate."io.argoproj.events.v1alpha1.ArtifactLocation",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.Status"
            | doc m%"
            Status is a common structure which can be used for Status field.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  conditions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.Condition"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.StatusPolicy" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType 'Integer)
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.StorageGridEventSource" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiURL = predicates.isType '"String",
                  authToken =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  bucket = predicates.isType '"String",
                  events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.StorageGridFilter",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  region = predicates.isType '"String",
                  topicArn = predicates.isType '"String",
                  webhook =
                    definitions.predicate."io.argoproj.events.v1alpha1.WebhookContext",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.StorageGridFilter" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  prefix = predicates.isType '"String",
                  suffix = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.StripeEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiKey =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  createWebhook = predicates.isType '"Bool",
                  eventFilter = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  webhook =
                    definitions.predicate."io.argoproj.events.v1alpha1.WebhookContext",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.TLSConfig"
            | doc m%"
            TLSConfig refers to TLS configuration for a client.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  caCertSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  clientCertSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  clientKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  insecureSkipVerify = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.Template" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  affinity =
                    definitions.predicate."io.k8s.api.core.v1.Affinity",
                  container =
                    definitions.predicate."io.k8s.api.core.v1.Container",
                  imagePullSecrets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.LocalObjectReference"
                      ],
                  metadata =
                    definitions.predicate."io.argoproj.events.v1alpha1.Metadata",
                  nodeSelector = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  "priority" = predicates.isType 'Integer,
                  priorityClassName = predicates.isType '"String",
                  securityContext =
                    definitions.predicate."io.k8s.api.core.v1.PodSecurityContext",
                  serviceAccountName = predicates.isType '"String",
                  tolerations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.Toleration"
                      ],
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.Volume"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.TimeFilter"
            | doc m%"
            TimeFilter describes a window in time.
            It filters out events that occur outside the time limits.
            In other words, only events that occur after Start and before Stop
            will pass this filter.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  start = predicates.isType '"String",
                  stop = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.Trigger" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameter"
                      ],
                  policy =
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerPolicy",
                  rateLimit =
                    definitions.predicate."io.argoproj.events.v1alpha1.RateLimit",
                  retryStrategy =
                    definitions.predicate."io.argoproj.events.v1alpha1.Backoff",
                  template =
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerTemplate",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.TriggerParameter" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  dest = predicates.isType '"String",
                  operation = predicates.isType '"String",
                  src =
                    definitions.predicate."io.argoproj.events.v1alpha1.TriggerParameterSource",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.TriggerParameterSource" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  contextKey = predicates.isType '"String",
                  contextTemplate = predicates.isType '"String",
                  dataKey = predicates.isType '"String",
                  dataTemplate = predicates.isType '"String",
                  dependencyName = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.TriggerPolicy" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  k8s =
                    definitions.predicate."io.argoproj.events.v1alpha1.K8SResourcePolicy",
                  status =
                    definitions.predicate."io.argoproj.events.v1alpha1.StatusPolicy",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.TriggerTemplate"
            | doc m%"
            TriggerTemplate is the template that describes trigger specification.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  argoWorkflow =
                    definitions.predicate."io.argoproj.events.v1alpha1.ArgoWorkflowTrigger",
                  awsLambda =
                    definitions.predicate."io.argoproj.events.v1alpha1.AWSLambdaTrigger",
                  azureEventHubs =
                    definitions.predicate."io.argoproj.events.v1alpha1.AzureEventHubsTrigger",
                  conditions = predicates.isType '"String",
                  conditionsReset = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.events.v1alpha1.ConditionsResetCriteria"
                      ],
                  custom =
                    definitions.predicate."io.argoproj.events.v1alpha1.CustomTrigger",
                  http =
                    definitions.predicate."io.argoproj.events.v1alpha1.HTTPTrigger",
                  k8s =
                    definitions.predicate."io.argoproj.events.v1alpha1.StandardK8STrigger",
                  kafka =
                    definitions.predicate."io.argoproj.events.v1alpha1.KafkaTrigger",
                  log =
                    definitions.predicate."io.argoproj.events.v1alpha1.LogTrigger",
                  name = predicates.isType '"String",
                  nats =
                    definitions.predicate."io.argoproj.events.v1alpha1.NATSTrigger",
                  openWhisk =
                    definitions.predicate."io.argoproj.events.v1alpha1.OpenWhiskTrigger",
                  pulsar =
                    definitions.predicate."io.argoproj.events.v1alpha1.PulsarTrigger",
                  slack =
                    definitions.predicate."io.argoproj.events.v1alpha1.SlackTrigger",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.URLArtifact"
            | doc m%"
            URLArtifact contains information about an artifact at an http endpoint.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  verifyCert = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.ValueFromSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configMapKeyRef =
                    definitions.predicate."io.k8s.api.core.v1.ConfigMapKeySelector",
                  secretKeyRef =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.WatchPathConfig" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  directory = predicates.isType '"String",
                  path = predicates.isType '"String",
                  pathRegexp = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.WebhookContext" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  authSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  endpoint = predicates.isType '"String",
                  maxPayloadSize = predicates.isType '"String",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  method = predicates.isType '"String",
                  port = predicates.isType '"String",
                  serverCertSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  serverKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.events.v1alpha1.WebhookEventSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  filter =
                    definitions.predicate."io.argoproj.events.v1alpha1.EventSourceFilter",
                  webhookContext =
                    definitions.predicate."io.argoproj.events.v1alpha1.WebhookContext",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Amount"
            | doc m%"
            Amount represent a numeric amount.
            "%
            = predicates.isType '"Number",
          "io.argoproj.workflow.v1alpha1.ArchiveStrategy"
            | doc m%"
            ArchiveStrategy describes how to archive files/directory when saving artifacts
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  none =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.NoneStrategy",
                  tar =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.TarStrategy",
                  zip =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ZipStrategy",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArchivedWorkflowDeletedResponse" =
            predicates.isType 'Record,
          "io.argoproj.workflow.v1alpha1.Arguments"
            | doc m%"
            Arguments to a template
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Artifact"
                      ],
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Parameter"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtGCStatus"
            | doc m%"
            ArtGCStatus maintains state related to ArtifactGC
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  notSpecified = predicates.isType '"Bool",
                  podsRecouped = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"Bool")
                      ],
                  strategiesProcessed = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"Bool")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Artifact"
            | doc m%"
            Artifact indicates an artifact to place at a specified path
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  archive =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArchiveStrategy",
                  archiveLogs = predicates.isType '"Bool",
                  artifactGC =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactGC",
                  artifactory =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactoryArtifact",
                  azure =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.AzureArtifact",
                  deleted = predicates.isType '"Bool",
                  from = predicates.isType '"String",
                  fromExpression = predicates.isType '"String",
                  gcs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.GCSArtifact",
                  git =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.GitArtifact",
                  globalName = predicates.isType '"String",
                  hdfs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.HDFSArtifact",
                  http =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.HTTPArtifact",
                  mode = predicates.isType 'Integer,
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                  oss =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.OSSArtifact",
                  path = predicates.isType '"String",
                  raw =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.RawArtifact",
                  recurseMode = predicates.isType '"Bool",
                  s3 =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.S3Artifact",
                  subPath = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactGC"
            | doc m%"
            ArtifactGC describes how to delete artifacts from completed Workflows - this is embedded into the WorkflowLevelArtifactGC, and also used for individual Artifacts to override that as needed
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  podMetadata =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Metadata",
                  serviceAccountName = predicates.isType '"String",
                  strategy = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactGCSpec"
            | doc m%"
            ArtifactGCSpec specifies the Artifacts that need to be deleted
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactsByNode = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactNodeSpec"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactGCStatus"
            | doc m%"
            ArtifactGCStatus describes the result of the deletion
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactResultsByNode = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactResultNodeStatus"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactLocation"
            | doc m%"
            ArtifactLocation describes a location for a single or multiple artifacts. It is used as single artifact in the context of inputs/outputs (e.g. outputs.artifacts.artname). It is also used to describe the location of multiple artifacts such as the archive location of a single workflow step, which the executor will use as a default location to store its files.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  archiveLogs = predicates.isType '"Bool",
                  artifactory =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactoryArtifact",
                  azure =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.AzureArtifact",
                  gcs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.GCSArtifact",
                  git =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.GitArtifact",
                  hdfs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.HDFSArtifact",
                  http =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.HTTPArtifact",
                  oss =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.OSSArtifact",
                  raw =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.RawArtifact",
                  s3 =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.S3Artifact",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactNodeSpec"
            | doc m%"
            ArtifactNodeSpec specifies the Artifacts that need to be deleted for a given Node
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  archiveLocation =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactLocation",
                  artifacts = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Artifact"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactPaths"
            | doc m%"
            ArtifactPaths expands a step from a collection of artifacts
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  archive =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArchiveStrategy",
                  archiveLogs = predicates.isType '"Bool",
                  artifactGC =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactGC",
                  artifactory =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactoryArtifact",
                  azure =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.AzureArtifact",
                  deleted = predicates.isType '"Bool",
                  from = predicates.isType '"String",
                  fromExpression = predicates.isType '"String",
                  gcs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.GCSArtifact",
                  git =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.GitArtifact",
                  globalName = predicates.isType '"String",
                  hdfs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.HDFSArtifact",
                  http =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.HTTPArtifact",
                  mode = predicates.isType 'Integer,
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                  oss =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.OSSArtifact",
                  path = predicates.isType '"String",
                  raw =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.RawArtifact",
                  recurseMode = predicates.isType '"Bool",
                  s3 =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.S3Artifact",
                  subPath = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactRepository"
            | doc m%"
            ArtifactRepository represents an artifact repository in which a controller will store its artifacts
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  archiveLogs = predicates.isType '"Bool",
                  artifactory =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactoryArtifactRepository",
                  azure =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.AzureArtifactRepository",
                  gcs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.GCSArtifactRepository",
                  hdfs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.HDFSArtifactRepository",
                  oss =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.OSSArtifactRepository",
                  s3 =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.S3ArtifactRepository",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactRepositoryRef" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configMap = predicates.isType '"String",
                  key = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactRepositoryRefStatus" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactRepository =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactRepository",
                  configMap = predicates.isType '"String",
                  "default" = predicates.isType '"Bool",
                  key = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactResult"
            | doc m%"
            ArtifactResult describes the result of attempting to delete a given Artifact
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  error = predicates.isType '"String",
                  name = predicates.isType '"String",
                  success = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactResultNodeStatus"
            | doc m%"
            ArtifactResultNodeStatus describes the result of the deletion on a given node
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactResults = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactResult"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactoryArtifact"
            | doc m%"
            ArtifactoryArtifact is the location of an artifactory artifact
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "url" ],
                predicates.records.record
                {
                  passwordSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  url = predicates.isType '"String",
                  usernameSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ArtifactoryArtifactRepository"
            | doc m%"
            ArtifactoryArtifactRepository defines the controller configuration for an artifactory artifact repository
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  keyFormat = predicates.isType '"String",
                  passwordSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  repoURL = predicates.isType '"String",
                  usernameSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.AzureArtifact"
            | doc m%"
            AzureArtifact is the location of a an Azure Storage artifact
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "blob", "container", "endpoint" ],
                predicates.records.record
                {
                  accountKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  blob = predicates.isType '"String",
                  container = predicates.isType '"String",
                  endpoint = predicates.isType '"String",
                  useSDKCreds = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.AzureArtifactRepository"
            | doc m%"
            AzureArtifactRepository defines the controller configuration for an Azure Blob Storage artifact repository
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "container", "endpoint" ],
                predicates.records.record
                {
                  accountKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  blobNameFormat = predicates.isType '"String",
                  container = predicates.isType '"String",
                  endpoint = predicates.isType '"String",
                  useSDKCreds = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Backoff"
            | doc m%"
            Backoff is a backoff strategy to use within retryStrategy
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  duration = predicates.isType '"String",
                  factor =
                    definitions.predicate."io.k8s.apimachinery.pkg.util.intstr.IntOrString",
                  maxDuration = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.BasicAuth"
            | doc m%"
            BasicAuth describes the secret selectors required for basic authentication
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  passwordSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  usernameSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Cache"
            | doc m%"
            Cache is the configuration for the type of cache to be used
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "configMap" ],
                predicates.records.record
                {
                  configMap =
                    definitions.predicate."io.k8s.api.core.v1.ConfigMapKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ClientCertAuth"
            | doc m%"
            ClientCertAuth holds necessary information for client authentication via certificates
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clientCertSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  clientKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate"
            | doc m%"
            ClusterWorkflowTemplate is the definition of a workflow template resource in cluster scope
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "metadata", "spec" ],
                predicates.records.record
                {
                  apiVersion = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.const "argoproj.io/v1alpha1"
                      ],
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.const "ClusterWorkflowTemplate"
                      ],
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                  spec =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowSpec",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplateCreateRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createOptions =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions",
                  template =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplateDeleteResponse" =
            predicates.isType 'Record,
          "io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplateLintRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createOptions =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions",
                  template =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplateList"
            | doc m%"
            ClusterWorkflowTemplateList is list of ClusterWorkflowTemplate resources
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "items", "metadata" ],
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate"
                      ],
                  kind = predicates.isType '"String",
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplateUpdateRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  template =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.CollectEventRequest" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { name = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.CollectEventResponse" =
            predicates.isType 'Record,
          "io.argoproj.workflow.v1alpha1.Column"
            | doc m%"
            Column is a custom column that will be exposed in the Workflow List View.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key", "name", "type" ],
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  name = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Condition" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  message = predicates.isType '"String",
                  status = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ContainerNode" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  command = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  dependencies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.EnvVar"
                      ],
                  envFrom = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.EnvFromSource"
                      ],
                  image = predicates.isType '"String",
                  imagePullPolicy = predicates.isType '"String",
                  lifecycle =
                    definitions.predicate."io.k8s.api.core.v1.Lifecycle",
                  livenessProbe =
                    definitions.predicate."io.k8s.api.core.v1.Probe",
                  name = predicates.isType '"String",
                  ports = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.ContainerPort"
                      ],
                  readinessProbe =
                    definitions.predicate."io.k8s.api.core.v1.Probe",
                  resources =
                    definitions.predicate."io.k8s.api.core.v1.ResourceRequirements",
                  securityContext =
                    definitions.predicate."io.k8s.api.core.v1.SecurityContext",
                  startupProbe =
                    definitions.predicate."io.k8s.api.core.v1.Probe",
                  stdin = predicates.isType '"Bool",
                  stdinOnce = predicates.isType '"Bool",
                  terminationMessagePath = predicates.isType '"String",
                  terminationMessagePolicy = predicates.isType '"String",
                  tty = predicates.isType '"Bool",
                  volumeDevices = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.VolumeDevice"
                      ],
                  volumeMounts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.VolumeMount"
                      ],
                  workingDir = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ContainerSetRetryStrategy" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "retries" ],
                predicates.records.record
                {
                  duration = predicates.isType '"String",
                  retries =
                    definitions.predicate."io.k8s.apimachinery.pkg.util.intstr.IntOrString",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ContainerSetTemplate" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "containers" ],
                predicates.records.record
                {
                  containers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.ContainerNode"
                      ],
                  retryStrategy =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ContainerSetRetryStrategy",
                  volumeMounts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.VolumeMount"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ContinueOn"
            | doc m%"
            ContinueOn defines if a workflow should continue even if a task or step fails/errors. It can be specified if the workflow should continue when the pod errors, fails or both.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  error = predicates.isType '"Bool",
                  failed = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Counter"
            | doc m%"
            Counter is a Counter prometheus metric
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "value" ],
                predicates.records.record
                { value = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.CreateCronWorkflowRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createOptions =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions",
                  cronWorkflow =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.CronWorkflow",
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.CreateS3BucketOptions"
            | doc m%"
            CreateS3BucketOptions options used to determine automatic automatic bucket-creation process
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { objectLocking = predicates.isType '"Bool", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.CronWorkflow"
            | doc m%"
            CronWorkflow is the definition of a scheduled workflow resource
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "metadata", "spec" ],
                predicates.records.record
                {
                  apiVersion = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.const "argoproj.io/v1alpha1"
                      ],
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.const "CronWorkflow"
                      ],
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                  spec =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.CronWorkflowSpec",
                  status =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.CronWorkflowStatus",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.CronWorkflowDeletedResponse" =
            predicates.isType 'Record,
          "io.argoproj.workflow.v1alpha1.CronWorkflowList"
            | doc m%"
            CronWorkflowList is list of CronWorkflow resources
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "items", "metadata" ],
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.CronWorkflow"
                      ],
                  kind = predicates.isType '"String",
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.CronWorkflowResumeRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.CronWorkflowSpec"
            | doc m%"
            CronWorkflowSpec is the specification of a CronWorkflow
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "schedule", "workflowSpec" ],
                predicates.records.record
                {
                  concurrencyPolicy = predicates.isType '"String",
                  failedJobsHistoryLimit = predicates.isType 'Integer,
                  schedule = predicates.isType '"String",
                  startingDeadlineSeconds = predicates.isType 'Integer,
                  successfulJobsHistoryLimit = predicates.isType 'Integer,
                  suspend = predicates.isType '"Bool",
                  timezone = predicates.isType '"String",
                  workflowMetadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                  workflowSpec =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowSpec",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.CronWorkflowStatus"
            | doc m%"
            CronWorkflowStatus is the status of a CronWorkflow
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "active", "conditions", "lastScheduledTime" ],
                predicates.records.record
                {
                  active = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.ObjectReference"
                      ],
                  conditions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Condition"
                      ],
                  lastScheduledTime =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.CronWorkflowSuspendRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.DAGTask"
            | doc m%"
            DAGTask represents a node in the graph during DAG execution
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  arguments =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Arguments",
                  continueOn =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ContinueOn",
                  dependencies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  depends = predicates.isType '"String",
                  hooks = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.workflow.v1alpha1.LifecycleHook"
                      ],
                  inline =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Template",
                  name = predicates.isType '"String",
                  onExit = predicates.isType '"String",
                  template = predicates.isType '"String",
                  templateRef =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.TemplateRef",
                  when = predicates.isType '"String",
                  withItems = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Item"
                      ],
                  withParam = predicates.isType '"String",
                  withSequence =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Sequence",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.DAGTemplate"
            | doc m%"
            DAGTemplate is a template subtype for directed acyclic graph templates
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tasks" ],
                predicates.records.record
                {
                  failFast = predicates.isType '"Bool",
                  target = predicates.isType '"String",
                  tasks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.DAGTask"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Data"
            | doc m%"
            Data is a data template
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "source", "transformation" ],
                predicates.records.record
                {
                  source =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.DataSource",
                  transformation = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.TransformationStep"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.DataSource"
            | doc m%"
            DataSource sources external data into a data template
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactPaths =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactPaths",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Event" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "selector" ],
                predicates.records.record
                { selector = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.EventResponse" = predicates.isType
              'Record,
          "io.argoproj.workflow.v1alpha1.ExecutorConfig"
            | doc m%"
            ExecutorConfig holds configurations of an executor container.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { serviceAccountName = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.GCSArtifact"
            | doc m%"
            GCSArtifact is the location of a GCS artifact
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key" ],
                predicates.records.record
                {
                  bucket = predicates.isType '"String",
                  key = predicates.isType '"String",
                  serviceAccountKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.GCSArtifactRepository"
            | doc m%"
            GCSArtifactRepository defines the controller configuration for a GCS artifact repository
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bucket = predicates.isType '"String",
                  keyFormat = predicates.isType '"String",
                  serviceAccountKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Gauge"
            | doc m%"
            Gauge is a Gauge prometheus metric
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "realtime", "value" ],
                predicates.records.record
                {
                  operation = predicates.isType '"String",
                  realtime = predicates.isType '"Bool",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.GetUserInfoResponse" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  email = predicates.isType '"String",
                  emailVerified = predicates.isType '"Bool",
                  groups = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  issuer = predicates.isType '"String",
                  name = predicates.isType '"String",
                  serviceAccountName = predicates.isType '"String",
                  serviceAccountNamespace = predicates.isType '"String",
                  subject = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.GitArtifact"
            | doc m%"
            GitArtifact is the location of an git artifact
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "repo" ],
                predicates.records.record
                {
                  branch = predicates.isType '"String",
                  depth = predicates.isType 'Integer,
                  disableSubmodules = predicates.isType '"Bool",
                  fetch = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  insecureIgnoreHostKey = predicates.isType '"Bool",
                  passwordSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  repo = predicates.isType '"String",
                  revision = predicates.isType '"String",
                  singleBranch = predicates.isType '"Bool",
                  sshPrivateKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  usernameSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.HDFSArtifact"
            | doc m%"
            HDFSArtifact is the location of an HDFS artifact
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  addresses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  "force" = predicates.isType '"Bool",
                  hdfsUser = predicates.isType '"String",
                  krbCCacheSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  krbConfigConfigMap =
                    definitions.predicate."io.k8s.api.core.v1.ConfigMapKeySelector",
                  krbKeytabSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  krbRealm = predicates.isType '"String",
                  krbServicePrincipalName = predicates.isType '"String",
                  krbUsername = predicates.isType '"String",
                  path = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.HDFSArtifactRepository"
            | doc m%"
            HDFSArtifactRepository defines the controller configuration for an HDFS artifact repository
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addresses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  "force" = predicates.isType '"Bool",
                  hdfsUser = predicates.isType '"String",
                  krbCCacheSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  krbConfigConfigMap =
                    definitions.predicate."io.k8s.api.core.v1.ConfigMapKeySelector",
                  krbKeytabSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  krbRealm = predicates.isType '"String",
                  krbServicePrincipalName = predicates.isType '"String",
                  krbUsername = predicates.isType '"String",
                  pathFormat = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.HTTP" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "url" ],
                predicates.records.record
                {
                  body = predicates.isType '"String",
                  bodyFrom =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.HTTPBodySource",
                  headers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.HTTPHeader"
                      ],
                  insecureSkipVerify = predicates.isType '"Bool",
                  method = predicates.isType '"String",
                  successCondition = predicates.isType '"String",
                  timeoutSeconds = predicates.isType 'Integer,
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.HTTPArtifact"
            | doc m%"
            HTTPArtifact allows a file served on HTTP to be placed as an input artifact in a container
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "url" ],
                predicates.records.record
                {
                  auth =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.HTTPAuth",
                  headers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Header"
                      ],
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.HTTPAuth" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  basicAuth =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.BasicAuth",
                  clientCert =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ClientCertAuth",
                  oauth2 =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.OAuth2Auth",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.HTTPBodySource"
            | doc m%"
            HTTPBodySource contains the source of the HTTP body.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { bytes = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.HTTPHeader" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  value = predicates.isType '"String",
                  valueFrom =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.HTTPHeaderSource",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.HTTPHeaderSource" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  secretKeyRef =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Header"
            | doc m%"
            Header indicate a key-value request header to be used when fetching artifacts over HTTP
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "value" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Histogram"
            | doc m%"
            Histogram is a Histogram prometheus metric
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "buckets", "value" ],
                predicates.records.record
                {
                  buckets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Amount"
                      ],
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.InfoResponse" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  columns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Column"
                      ],
                  links = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Link"
                      ],
                  managedNamespace = predicates.isType '"String",
                  modals = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"Bool")
                      ],
                  navColor = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Inputs"
            | doc m%"
            Inputs are the mechanism for passing parameters, artifacts, volumes from one template to another
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Artifact"
                      ],
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Parameter"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Item"
            | doc m%"
            Item expands a single workflow step into multiple parallel steps The value of Item can be a map, string, bool, or number
            "%
            = predicates.always,
          "io.argoproj.workflow.v1alpha1.LabelKeys"
            | doc m%"
            LabelKeys is list of keys
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.LabelValueFrom" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "expression" ],
                predicates.records.record
                { expression = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.LabelValues"
            | doc m%"
            Labels is list of workflow labels
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.LifecycleHook" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  arguments =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Arguments",
                  expression = predicates.isType '"String",
                  template = predicates.isType '"String",
                  templateRef =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.TemplateRef",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Link"
            | doc m%"
            A link to another app.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "scope", "url" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  scope = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.LintCronWorkflowRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cronWorkflow =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.CronWorkflow",
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.LogEntry" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  content = predicates.isType '"String",
                  podName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ManifestFrom" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "artifact" ],
                predicates.records.record
                {
                  artifact =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Artifact",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.MemoizationStatus"
            | doc m%"
            MemoizationStatus is the status of this memoized node
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "cacheName", "hit", "key" ],
                predicates.records.record
                {
                  cacheName = predicates.isType '"String",
                  hit = predicates.isType '"Bool",
                  key = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Memoize"
            | doc m%"
            Memoization enables caching for the Outputs of the template
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "cache", "key", "maxAge" ],
                predicates.records.record
                {
                  cache =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Cache",
                  key = predicates.isType '"String",
                  maxAge = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Metadata"
            | doc m%"
            Pod metdata
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.MetricLabel"
            | doc m%"
            MetricLabel is a single label for a prometheus metric
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key", "value" ],
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Metrics"
            | doc m%"
            Metrics are a list of metrics emitted from a Workflow/Template
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "prometheus" ],
                predicates.records.record
                {
                  prometheus = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Prometheus"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Mutex"
            | doc m%"
            Mutex holds Mutex configuration
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.MutexHolding"
            | doc m%"
            MutexHolding describes the mutex and the object which is holding it.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  holder = predicates.isType '"String",
                  mutex = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.MutexStatus"
            | doc m%"
            MutexStatus contains which objects hold  mutex locks, and which objects this workflow is waiting on to release locks.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  holding = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.MutexHolding"
                      ],
                  waiting = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.MutexHolding"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.NodeFlag" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  hooked = predicates.isType '"Bool",
                  retried = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.NodeResult" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  message = predicates.isType '"String",
                  outputs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Outputs",
                  phase = predicates.isType '"String",
                  progress = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.NodeStatus"
            | doc m%"
            NodeStatus contains status information about an individual node in the workflow
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id", "name", "type" ],
                predicates.records.record
                {
                  boundaryID = predicates.isType '"String",
                  children = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  daemoned = predicates.isType '"Bool",
                  displayName = predicates.isType '"String",
                  estimatedDuration = predicates.isType 'Integer,
                  finishedAt =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  hostNodeName = predicates.isType '"String",
                  id = predicates.isType '"String",
                  inputs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Inputs",
                  memoizationStatus =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.MemoizationStatus",
                  message = predicates.isType '"String",
                  name = predicates.isType '"String",
                  nodeFlag =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.NodeFlag",
                  outboundNodes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  outputs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Outputs",
                  phase = predicates.isType '"String",
                  podIP = predicates.isType '"String",
                  progress = predicates.isType '"String",
                  resourcesDuration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType 'Integer)
                      ],
                  startedAt =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  synchronizationStatus =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.NodeSynchronizationStatus",
                  templateName = predicates.isType '"String",
                  templateRef =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.TemplateRef",
                  templateScope = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.NodeSynchronizationStatus"
            | doc m%"
            NodeSynchronizationStatus stores the status of a node
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { waiting = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.NoneStrategy"
            | doc m%"
            NoneStrategy indicates to skip tar process and upload the files or directory tree as independent files. Note that if the artifact is a directory, the artifact driver must support the ability to save/load the directory appropriately.
            "%
            = predicates.isType 'Record,
          "io.argoproj.workflow.v1alpha1.OAuth2Auth"
            | doc m%"
            OAuth2Auth holds all information for client authentication via OAuth2 tokens
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clientIDSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  clientSecretSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  endpointParams = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.OAuth2EndpointParam"
                      ],
                  scopes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  tokenURLSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.OAuth2EndpointParam"
            | doc m%"
            EndpointParam is for requesting optional fields that should be sent in the oauth request
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key" ],
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.OSSArtifact"
            | doc m%"
            OSSArtifact is the location of an Alibaba Cloud OSS artifact
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key" ],
                predicates.records.record
                {
                  accessKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  bucket = predicates.isType '"String",
                  createBucketIfNotPresent = predicates.isType '"Bool",
                  endpoint = predicates.isType '"String",
                  key = predicates.isType '"String",
                  lifecycleRule =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.OSSLifecycleRule",
                  secretKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  securityToken = predicates.isType '"String",
                  useSDKCreds = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.OSSArtifactRepository"
            | doc m%"
            OSSArtifactRepository defines the controller configuration for an OSS artifact repository
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  bucket = predicates.isType '"String",
                  createBucketIfNotPresent = predicates.isType '"Bool",
                  endpoint = predicates.isType '"String",
                  keyFormat = predicates.isType '"String",
                  lifecycleRule =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.OSSLifecycleRule",
                  secretKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  securityToken = predicates.isType '"String",
                  useSDKCreds = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.OSSLifecycleRule"
            | doc m%"
            OSSLifecycleRule specifies how to manage bucket's lifecycle
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  markDeletionAfterDays = predicates.isType 'Integer,
                  markInfrequentAccessAfterDays = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Outputs"
            | doc m%"
            Outputs hold parameters, artifacts, and results from a step
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Artifact"
                      ],
                  exitCode = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Parameter"
                      ],
                  result = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ParallelSteps" = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowStep"
              ],
          "io.argoproj.workflow.v1alpha1.Parameter"
            | doc m%"
            Parameter indicate a passed string parameter to a service template with an optional default value
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  "default" = predicates.isType '"String",
                  description = predicates.isType '"String",
                  enum = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  globalName = predicates.isType '"String",
                  name = predicates.isType '"String",
                  value = predicates.isType '"String",
                  valueFrom =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ValueFrom",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Plugin"
            | doc m%"
            Plugin is an Object with exactly one key
            "%
            = predicates.isType 'Record,
          "io.argoproj.workflow.v1alpha1.PodGC"
            | doc m%"
            PodGC describes how to delete completed pods as they complete
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  deleteDelayDuration =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Duration",
                  labelSelector =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector",
                  strategy = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Prometheus"
            | doc m%"
            Prometheus is a prometheus metric to be emitted
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "help", "name" ],
                predicates.records.record
                {
                  counter =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Counter",
                  gauge =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Gauge",
                  help = predicates.isType '"String",
                  histogram =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Histogram",
                  labels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.MetricLabel"
                      ],
                  name = predicates.isType '"String",
                  when = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.RawArtifact"
            | doc m%"
            RawArtifact allows raw string content to be placed as an artifact in a container
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "data" ],
                predicates.records.record
                { data = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ResourceTemplate"
            | doc m%"
            ResourceTemplate is a template subtype to manipulate kubernetes resources
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "action" ],
                predicates.records.record
                {
                  action = predicates.isType '"String",
                  failureCondition = predicates.isType '"String",
                  flags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  manifest = predicates.isType '"String",
                  manifestFrom =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ManifestFrom",
                  mergeStrategy = predicates.isType '"String",
                  setOwnerReference = predicates.isType '"Bool",
                  successCondition = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ResubmitArchivedWorkflowRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  memoized = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  uid = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.RetryAffinity"
            | doc m%"
            RetryAffinity prevents running steps on the same host.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  nodeAntiAffinity =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.RetryNodeAntiAffinity",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.RetryArchivedWorkflowRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  nodeFieldSelector = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  restartSuccessful = predicates.isType '"Bool",
                  uid = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.RetryNodeAntiAffinity"
            | doc m%"
            RetryNodeAntiAffinity is a placeholder for future expansion, only empty nodeAntiAffinity is allowed. In order to prevent running steps on the same host, it uses "kubernetes.io/hostname".
            "%
            = predicates.isType 'Record,
          "io.argoproj.workflow.v1alpha1.RetryStrategy"
            | doc m%"
            RetryStrategy provides controls on how to retry a workflow step
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  affinity =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.RetryAffinity",
                  backoff =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Backoff",
                  expression = predicates.isType '"String",
                  limit =
                    definitions.predicate."io.k8s.apimachinery.pkg.util.intstr.IntOrString",
                  retryPolicy = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.S3Artifact"
            | doc m%"
            S3Artifact is the location of an S3 artifact
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  bucket = predicates.isType '"String",
                  caSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  createBucketIfNotPresent =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.CreateS3BucketOptions",
                  encryptionOptions =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.S3EncryptionOptions",
                  endpoint = predicates.isType '"String",
                  insecure = predicates.isType '"Bool",
                  key = predicates.isType '"String",
                  region = predicates.isType '"String",
                  roleARN = predicates.isType '"String",
                  secretKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  useSDKCreds = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.S3ArtifactRepository"
            | doc m%"
            S3ArtifactRepository defines the controller configuration for an S3 artifact repository
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  bucket = predicates.isType '"String",
                  caSecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  createBucketIfNotPresent =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.CreateS3BucketOptions",
                  encryptionOptions =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.S3EncryptionOptions",
                  endpoint = predicates.isType '"String",
                  insecure = predicates.isType '"Bool",
                  keyFormat = predicates.isType '"String",
                  keyPrefix = predicates.isType '"String",
                  region = predicates.isType '"String",
                  roleARN = predicates.isType '"String",
                  secretKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                  useSDKCreds = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.S3EncryptionOptions"
            | doc m%"
            S3EncryptionOptions used to determine encryption options during s3 operations
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enableEncryption = predicates.isType '"Bool",
                  kmsEncryptionContext = predicates.isType '"String",
                  kmsKeyId = predicates.isType '"String",
                  serverSideCustomerKeySecret =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ScriptTemplate"
            | doc m%"
            ScriptTemplate is a template subtype to enable scripting through code steps
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image", "source" ],
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  command = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.EnvVar"
                      ],
                  envFrom = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.EnvFromSource"
                      ],
                  image = predicates.isType '"String",
                  imagePullPolicy = predicates.isType '"String",
                  lifecycle =
                    definitions.predicate."io.k8s.api.core.v1.Lifecycle",
                  livenessProbe =
                    definitions.predicate."io.k8s.api.core.v1.Probe",
                  name = predicates.isType '"String",
                  ports = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.ContainerPort"
                      ],
                  readinessProbe =
                    definitions.predicate."io.k8s.api.core.v1.Probe",
                  resources =
                    definitions.predicate."io.k8s.api.core.v1.ResourceRequirements",
                  securityContext =
                    definitions.predicate."io.k8s.api.core.v1.SecurityContext",
                  source = predicates.isType '"String",
                  startupProbe =
                    definitions.predicate."io.k8s.api.core.v1.Probe",
                  stdin = predicates.isType '"Bool",
                  stdinOnce = predicates.isType '"Bool",
                  terminationMessagePath = predicates.isType '"String",
                  terminationMessagePolicy = predicates.isType '"String",
                  tty = predicates.isType '"Bool",
                  volumeDevices = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.VolumeDevice"
                      ],
                  volumeMounts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.VolumeMount"
                      ],
                  workingDir = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.SemaphoreHolding" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  holders = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  semaphore = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.SemaphoreRef"
            | doc m%"
            SemaphoreRef is a reference of Semaphore
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configMapKeyRef =
                    definitions.predicate."io.k8s.api.core.v1.ConfigMapKeySelector",
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.SemaphoreStatus" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  holding = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.SemaphoreHolding"
                      ],
                  waiting = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.SemaphoreHolding"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Sequence"
            | doc m%"
            Sequence expands a workflow step into numeric range
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  count =
                    definitions.predicate."io.k8s.apimachinery.pkg.util.intstr.IntOrString",
                  end =
                    definitions.predicate."io.k8s.apimachinery.pkg.util.intstr.IntOrString",
                  format = predicates.isType '"String",
                  start =
                    definitions.predicate."io.k8s.apimachinery.pkg.util.intstr.IntOrString",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Submit" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "workflowTemplateRef" ],
                predicates.records.record
                {
                  arguments =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Arguments",
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                  workflowTemplateRef =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowTemplateRef",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.SubmitOpts"
            | doc m%"
            SubmitOpts are workflow submission options
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.isType '"String",
                  dryRun = predicates.isType '"Bool",
                  entryPoint = predicates.isType '"String",
                  generateName = predicates.isType '"String",
                  labels = predicates.isType '"String",
                  name = predicates.isType '"String",
                  ownerReference =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.OwnerReference",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  podPriorityClassName = predicates.isType '"String",
                  "priority" = predicates.isType 'Integer,
                  serverDryRun = predicates.isType '"Bool",
                  serviceAccount = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.SuppliedValueFrom"
            | doc m%"
            SuppliedValueFrom is a placeholder for a value to be filled in directly, either through the CLI, API, etc.
            "%
            = predicates.isType 'Record,
          "io.argoproj.workflow.v1alpha1.SuspendTemplate"
            | doc m%"
            SuspendTemplate is a template subtype to suspend a workflow at a predetermined point in time
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { duration = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Synchronization"
            | doc m%"
            Synchronization holds synchronization lock configuration
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  mutex =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Mutex",
                  semaphore =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.SemaphoreRef",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.SynchronizationStatus"
            | doc m%"
            SynchronizationStatus stores the status of semaphore and mutex.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  mutex =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.MutexStatus",
                  semaphore =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.SemaphoreStatus",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.TTLStrategy"
            | doc m%"
            TTLStrategy is the strategy for the time to live depending on if the workflow succeeded or failed
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  secondsAfterCompletion = predicates.isType 'Integer,
                  secondsAfterFailure = predicates.isType 'Integer,
                  secondsAfterSuccess = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.TarStrategy"
            | doc m%"
            TarStrategy will tar and gzip the file or directory when saving
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { compressionLevel = predicates.isType 'Integer, }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Template"
            | doc m%"
            Template is a reusable and composable unit of execution in a workflow
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  activeDeadlineSeconds =
                    definitions.predicate."io.k8s.apimachinery.pkg.util.intstr.IntOrString",
                  affinity =
                    definitions.predicate."io.k8s.api.core.v1.Affinity",
                  archiveLocation =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactLocation",
                  automountServiceAccountToken = predicates.isType '"Bool",
                  container =
                    definitions.predicate."io.k8s.api.core.v1.Container",
                  containerSet =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ContainerSetTemplate",
                  daemon = predicates.isType '"Bool",
                  dag =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.DAGTemplate",
                  data =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Data",
                  executor =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ExecutorConfig",
                  failFast = predicates.isType '"Bool",
                  hostAliases = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.HostAlias"
                      ],
                  http =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.HTTP",
                  initContainers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.UserContainer"
                      ],
                  inputs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Inputs",
                  memoize =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Memoize",
                  metadata =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Metadata",
                  metrics =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Metrics",
                  name = predicates.isType '"String",
                  nodeSelector = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  outputs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Outputs",
                  parallelism = predicates.isType 'Integer,
                  plugin =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Plugin",
                  podSpecPatch = predicates.isType '"String",
                  "priority" = predicates.isType 'Integer,
                  priorityClassName = predicates.isType '"String",
                  resource =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ResourceTemplate",
                  retryStrategy =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.RetryStrategy",
                  schedulerName = predicates.isType '"String",
                  script =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ScriptTemplate",
                  securityContext =
                    definitions.predicate."io.k8s.api.core.v1.PodSecurityContext",
                  serviceAccountName = predicates.isType '"String",
                  sidecars = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.UserContainer"
                      ],
                  steps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.ParallelSteps"
                      ],
                  suspend =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.SuspendTemplate",
                  synchronization =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Synchronization",
                  timeout = predicates.isType '"String",
                  tolerations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.Toleration"
                      ],
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.Volume"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.TemplateRef"
            | doc m%"
            TemplateRef is a reference of template resource.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clusterScope = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  template = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.TransformationStep" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "expression" ],
                predicates.records.record
                { expression = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.UpdateCronWorkflowRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cronWorkflow =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.CronWorkflow",
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.UserContainer"
            | doc m%"
            UserContainer is a container specified by a user.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  command = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.EnvVar"
                      ],
                  envFrom = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.EnvFromSource"
                      ],
                  image = predicates.isType '"String",
                  imagePullPolicy = predicates.isType '"String",
                  lifecycle =
                    definitions.predicate."io.k8s.api.core.v1.Lifecycle",
                  livenessProbe =
                    definitions.predicate."io.k8s.api.core.v1.Probe",
                  mirrorVolumeMounts = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  ports = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.ContainerPort"
                      ],
                  readinessProbe =
                    definitions.predicate."io.k8s.api.core.v1.Probe",
                  resources =
                    definitions.predicate."io.k8s.api.core.v1.ResourceRequirements",
                  securityContext =
                    definitions.predicate."io.k8s.api.core.v1.SecurityContext",
                  startupProbe =
                    definitions.predicate."io.k8s.api.core.v1.Probe",
                  stdin = predicates.isType '"Bool",
                  stdinOnce = predicates.isType '"Bool",
                  terminationMessagePath = predicates.isType '"String",
                  terminationMessagePolicy = predicates.isType '"String",
                  tty = predicates.isType '"Bool",
                  volumeDevices = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.VolumeDevice"
                      ],
                  volumeMounts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.VolumeMount"
                      ],
                  workingDir = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ValueFrom"
            | doc m%"
            ValueFrom describes a location in which to obtain the value to a parameter
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configMapKeyRef =
                    definitions.predicate."io.k8s.api.core.v1.ConfigMapKeySelector",
                  "default" = predicates.isType '"String",
                  event = predicates.isType '"String",
                  expression = predicates.isType '"String",
                  jqFilter = predicates.isType '"String",
                  jsonPath = predicates.isType '"String",
                  parameter = predicates.isType '"String",
                  path = predicates.isType '"String",
                  supplied =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.SuppliedValueFrom",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Version" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "buildDate",
                  "compiler",
                  "gitCommit",
                  "gitTag",
                  "gitTreeState",
                  "goVersion",
                  "platform",
                  "version"
                ],
                predicates.records.record
                {
                  buildDate = predicates.isType '"String",
                  compiler = predicates.isType '"String",
                  gitCommit = predicates.isType '"String",
                  gitTag = predicates.isType '"String",
                  gitTreeState = predicates.isType '"String",
                  goVersion = predicates.isType '"String",
                  platform = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.VolumeClaimGC"
            | doc m%"
            VolumeClaimGC describes how to delete volumes from completed Workflows
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { strategy = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.Workflow"
            | doc m%"
            Workflow is the definition of a workflow resource
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "metadata", "spec" ],
                predicates.records.record
                {
                  apiVersion = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.const "argoproj.io/v1alpha1"
                      ],
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.const "Workflow"
                      ],
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                  spec =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowSpec",
                  status =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowStatus",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowCreateRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createOptions =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions",
                  instanceID = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  serverDryRun = predicates.isType '"Bool",
                  workflow =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Workflow",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowDeleteResponse" =
            predicates.isType 'Record,
          "io.argoproj.workflow.v1alpha1.WorkflowEventBinding"
            | doc m%"
            WorkflowEventBinding is the definition of an event resource
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "metadata", "spec" ],
                predicates.records.record
                {
                  apiVersion = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.const "argoproj.io/v1alpha1"
                      ],
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.const "WorkflowEventBinding"
                      ],
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                  spec =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowEventBindingSpec",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowEventBindingList"
            | doc m%"
            WorkflowEventBindingList is list of event resources
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "items", "metadata" ],
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowEventBinding"
                      ],
                  kind = predicates.isType '"String",
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowEventBindingSpec" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "event" ],
                predicates.records.record
                {
                  event =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Event",
                  submit =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Submit",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowLevelArtifactGC"
            | doc m%"
            WorkflowLevelArtifactGC describes how to delete artifacts from completed Workflows - this spec is used on the Workflow level
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  forceFinalizerRemoval = predicates.isType '"Bool",
                  podMetadata =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Metadata",
                  podSpecPatch = predicates.isType '"String",
                  serviceAccountName = predicates.isType '"String",
                  strategy = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowLintRequest" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  namespace = predicates.isType '"String",
                  workflow =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Workflow",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowList"
            | doc m%"
            WorkflowList is list of Workflow resources
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "items", "metadata" ],
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Workflow"
                      ],
                  kind = predicates.isType '"String",
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowMetadata" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  labelsFrom = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.workflow.v1alpha1.LabelValueFrom"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowResubmitRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  memoized = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowResumeRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  nodeFieldSelector = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowRetryRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  nodeFieldSelector = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  restartSuccessful = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowSetRequest" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  message = predicates.isType '"String",
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  nodeFieldSelector = predicates.isType '"String",
                  outputParameters = predicates.isType '"String",
                  phase = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowSpec"
            | doc m%"
            WorkflowSpec is the specification of a Workflow.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  activeDeadlineSeconds = predicates.isType 'Integer,
                  affinity =
                    definitions.predicate."io.k8s.api.core.v1.Affinity",
                  archiveLogs = predicates.isType '"Bool",
                  arguments =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Arguments",
                  artifactGC =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowLevelArtifactGC",
                  artifactRepositoryRef =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactRepositoryRef",
                  automountServiceAccountToken = predicates.isType '"Bool",
                  dnsConfig =
                    definitions.predicate."io.k8s.api.core.v1.PodDNSConfig",
                  dnsPolicy = predicates.isType '"String",
                  entrypoint = predicates.isType '"String",
                  executor =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ExecutorConfig",
                  hooks = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.workflow.v1alpha1.LifecycleHook"
                      ],
                  hostAliases = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.HostAlias"
                      ],
                  hostNetwork = predicates.isType '"Bool",
                  imagePullSecrets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.LocalObjectReference"
                      ],
                  metrics =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Metrics",
                  nodeSelector = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  onExit = predicates.isType '"String",
                  parallelism = predicates.isType 'Integer,
                  podDisruptionBudget =
                    definitions.predicate."io.k8s.api.policy.v1.PodDisruptionBudgetSpec",
                  podGC =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.PodGC",
                  podMetadata =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Metadata",
                  podPriority = predicates.isType 'Integer,
                  podPriorityClassName = predicates.isType '"String",
                  podSpecPatch = predicates.isType '"String",
                  "priority" = predicates.isType 'Integer,
                  retryStrategy =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.RetryStrategy",
                  schedulerName = predicates.isType '"String",
                  securityContext =
                    definitions.predicate."io.k8s.api.core.v1.PodSecurityContext",
                  serviceAccountName = predicates.isType '"String",
                  shutdown = predicates.isType '"String",
                  suspend = predicates.isType '"Bool",
                  synchronization =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Synchronization",
                  templateDefaults =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Template",
                  templates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Template"
                      ],
                  tolerations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.Toleration"
                      ],
                  ttlStrategy =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.TTLStrategy",
                  volumeClaimGC =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.VolumeClaimGC",
                  volumeClaimTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.PersistentVolumeClaim"
                      ],
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.Volume"
                      ],
                  workflowMetadata =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowMetadata",
                  workflowTemplateRef =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowTemplateRef",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowStatus"
            | doc m%"
            WorkflowStatus contains overall status information about a workflow
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactGCStatus =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtGCStatus",
                  artifactRepositoryRef =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ArtifactRepositoryRefStatus",
                  compressedNodes = predicates.isType '"String",
                  conditions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Condition"
                      ],
                  estimatedDuration = predicates.isType 'Integer,
                  finishedAt =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  message = predicates.isType '"String",
                  nodes = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.workflow.v1alpha1.NodeStatus"
                      ],
                  offloadNodeStatusVersion = predicates.isType '"String",
                  outputs =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Outputs",
                  persistentVolumeClaims = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.Volume"
                      ],
                  phase = predicates.isType '"String",
                  progress = predicates.isType '"String",
                  resourcesDuration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType 'Integer)
                      ],
                  startedAt =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  storedTemplates = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Template"
                      ],
                  storedWorkflowTemplateSpec =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowSpec",
                  synchronization =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.SynchronizationStatus",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowStep"
            | doc m%"
            WorkflowStep is a reference to a template to execute in a series of step
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  arguments =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Arguments",
                  continueOn =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.ContinueOn",
                  hooks = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.workflow.v1alpha1.LifecycleHook"
                      ],
                  inline =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Template",
                  name = predicates.isType '"String",
                  onExit = predicates.isType '"String",
                  template = predicates.isType '"String",
                  templateRef =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.TemplateRef",
                  when = predicates.isType '"String",
                  withItems = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Item"
                      ],
                  withParam = predicates.isType '"String",
                  withSequence =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Sequence",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowStopRequest" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  message = predicates.isType '"String",
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  nodeFieldSelector = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowSubmitRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  namespace = predicates.isType '"String",
                  resourceKind = predicates.isType '"String",
                  resourceName = predicates.isType '"String",
                  submitOptions =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.SubmitOpts",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowSuspendRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowTaskSetSpec" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  tasks = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.workflow.v1alpha1.Template"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowTaskSetStatus" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  nodes = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.argoproj.workflow.v1alpha1.NodeResult"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowTemplate"
            | doc m%"
            WorkflowTemplate is the definition of a workflow template resource
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "metadata", "spec" ],
                predicates.records.record
                {
                  apiVersion = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.const "argoproj.io/v1alpha1"
                      ],
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.const "WorkflowTemplate"
                      ],
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                  spec =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowSpec",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowTemplateCreateRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createOptions =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions",
                  namespace = predicates.isType '"String",
                  template =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowTemplate",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowTemplateDeleteResponse" =
            predicates.isType 'Record,
          "io.argoproj.workflow.v1alpha1.WorkflowTemplateLintRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createOptions =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions",
                  namespace = predicates.isType '"String",
                  template =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowTemplate",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowTemplateList"
            | doc m%"
            WorkflowTemplateList is list of WorkflowTemplate resources
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "items", "metadata" ],
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowTemplate"
                      ],
                  kind = predicates.isType '"String",
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowTemplateRef"
            | doc m%"
            WorkflowTemplateRef is a reference to a WorkflowTemplate resource.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clusterScope = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowTemplateUpdateRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  template =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowTemplate",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowTerminateRequest" =
            predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.WorkflowWatchEvent" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  object =
                    definitions.predicate."io.argoproj.workflow.v1alpha1.Workflow",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.argoproj.workflow.v1alpha1.ZipStrategy"
            | doc m%"
            ZipStrategy will unzip zipped input artifacts
            "%
            = predicates.isType 'Record,
          "io.k8s.api.core.v1.AWSElasticBlockStoreVolumeSource"
            | doc m%"
            Represents a Persistent Disk resource in AWS.
            
            An AWS EBS disk must exist before mounting to a container. The disk must also be in the same AWS zone as the kubelet. An AWS EBS disk can only be mounted as read/write once. AWS EBS volumes support ownership management and SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "volumeID" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  partition = predicates.isType 'Integer,
                  readOnly = predicates.isType '"Bool",
                  volumeID = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.Affinity"
            | doc m%"
            Affinity is a group of affinity scheduling rules.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  nodeAffinity =
                    definitions.predicate."io.k8s.api.core.v1.NodeAffinity",
                  podAffinity =
                    definitions.predicate."io.k8s.api.core.v1.PodAffinity",
                  podAntiAffinity =
                    definitions.predicate."io.k8s.api.core.v1.PodAntiAffinity",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.AzureDiskVolumeSource"
            | doc m%"
            AzureDisk represents an Azure Data Disk mount on the host and bind mount to the pod.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "diskName", "diskURI" ],
                predicates.records.record
                {
                  cachingMode = predicates.isType '"String",
                  diskName = predicates.isType '"String",
                  diskURI = predicates.isType '"String",
                  fsType = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.AzureFileVolumeSource"
            | doc m%"
            AzureFile represents an Azure File Service mount on the host and bind mount to the pod.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "secretName", "shareName" ],
                predicates.records.record
                {
                  readOnly = predicates.isType '"Bool",
                  secretName = predicates.isType '"String",
                  shareName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.CSIVolumeSource"
            | doc m%"
            Represents a source location of a volume to mount, managed by an external CSI driver
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "driver" ],
                predicates.records.record
                {
                  driver = predicates.isType '"String",
                  fsType = predicates.isType '"String",
                  nodePublishSecretRef =
                    definitions.predicate."io.k8s.api.core.v1.LocalObjectReference",
                  readOnly = predicates.isType '"Bool",
                  volumeAttributes = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.Capabilities"
            | doc m%"
            Adds and removes POSIX capabilities from running containers.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  add = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  drop = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.CephFSVolumeSource"
            | doc m%"
            Represents a Ceph Filesystem mount that lasts the lifetime of a pod Cephfs volumes do not support ownership management or SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "monitors" ],
                predicates.records.record
                {
                  monitors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  path = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretFile = predicates.isType '"String",
                  secretRef =
                    definitions.predicate."io.k8s.api.core.v1.LocalObjectReference",
                  user = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.CinderVolumeSource"
            | doc m%"
            Represents a cinder volume resource in Openstack. A Cinder volume must exist before mounting to a container. The volume must also be in the same region as the kubelet. Cinder volumes support ownership management and SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "volumeID" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretRef =
                    definitions.predicate."io.k8s.api.core.v1.LocalObjectReference",
                  volumeID = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ConfigMapEnvSource"
            | doc m%"
            ConfigMapEnvSource selects a ConfigMap to populate the environment variables with.
            
            The contents of the target ConfigMap's Data field will represent the key-value pairs as environment variables.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ConfigMapKeySelector"
            | doc m%"
            Selects a key from a ConfigMap.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key" ],
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ConfigMapProjection"
            | doc m%"
            Adapts a ConfigMap into a projected volume.
            
            The contents of the target ConfigMap's Data field will be presented in a projected volume as files using the keys in the Data field as the file names, unless the items element is populated with specific mappings of keys to paths. Note that this is identical to a configmap volume source without the default mode.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.KeyToPath"
                      ],
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ConfigMapVolumeSource"
            | doc m%"
            Adapts a ConfigMap into a volume.
            
            The contents of the target ConfigMap's Data field will be presented in a volume as files using the keys in the Data field as the file names, unless the items element is populated with specific mappings of keys to paths. ConfigMap volumes support ownership management and SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultMode = predicates.isType 'Integer,
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.KeyToPath"
                      ],
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.Container"
            | doc m%"
            A single application container that you want to run within a pod.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image" ],
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  command = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.EnvVar"
                      ],
                  envFrom = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.EnvFromSource"
                      ],
                  image = predicates.isType '"String",
                  imagePullPolicy = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Always", "IfNotPresent", "Never" ]
                      ],
                  lifecycle =
                    definitions.predicate."io.k8s.api.core.v1.Lifecycle",
                  livenessProbe =
                    definitions.predicate."io.k8s.api.core.v1.Probe",
                  name = predicates.isType '"String",
                  ports = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.ContainerPort"
                      ],
                  readinessProbe =
                    definitions.predicate."io.k8s.api.core.v1.Probe",
                  resources =
                    definitions.predicate."io.k8s.api.core.v1.ResourceRequirements",
                  securityContext =
                    definitions.predicate."io.k8s.api.core.v1.SecurityContext",
                  startupProbe =
                    definitions.predicate."io.k8s.api.core.v1.Probe",
                  stdin = predicates.isType '"Bool",
                  stdinOnce = predicates.isType '"Bool",
                  terminationMessagePath = predicates.isType '"String",
                  terminationMessagePolicy = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "FallbackToLogsOnError", "File" ]
                      ],
                  tty = predicates.isType '"Bool",
                  volumeDevices = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.VolumeDevice"
                      ],
                  volumeMounts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.VolumeMount"
                      ],
                  workingDir = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ContainerPort"
            | doc m%"
            ContainerPort represents a network port in a single container.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "containerPort" ],
                predicates.records.record
                {
                  containerPort = predicates.isType 'Integer,
                  hostIP = predicates.isType '"String",
                  hostPort = predicates.isType 'Integer,
                  name = predicates.isType '"String",
                  protocol = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "SCTP", "TCP", "UDP" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.DownwardAPIProjection"
            | doc m%"
            Represents downward API info for projecting into a projected volume. Note that this is identical to a downwardAPI volume source without the default mode.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.DownwardAPIVolumeFile"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.DownwardAPIVolumeFile"
            | doc m%"
            DownwardAPIVolumeFile represents information to create the file containing the pod field
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  fieldRef =
                    definitions.predicate."io.k8s.api.core.v1.ObjectFieldSelector",
                  mode = predicates.isType 'Integer,
                  path = predicates.isType '"String",
                  resourceFieldRef =
                    definitions.predicate."io.k8s.api.core.v1.ResourceFieldSelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.DownwardAPIVolumeSource"
            | doc m%"
            DownwardAPIVolumeSource represents a volume containing downward API info. Downward API volumes support ownership management and SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultMode = predicates.isType 'Integer,
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.DownwardAPIVolumeFile"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.EmptyDirVolumeSource"
            | doc m%"
            Represents an empty directory for a pod. Empty directory volumes support ownership management and SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  medium = predicates.isType '"String",
                  sizeLimit =
                    definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.EnvFromSource"
            | doc m%"
            EnvFromSource represents the source of a set of ConfigMaps
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configMapRef =
                    definitions.predicate."io.k8s.api.core.v1.ConfigMapEnvSource",
                  prefix = predicates.isType '"String",
                  secretRef =
                    definitions.predicate."io.k8s.api.core.v1.SecretEnvSource",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.EnvVar"
            | doc m%"
            EnvVar represents an environment variable present in a Container.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  value = predicates.isType '"String",
                  valueFrom =
                    definitions.predicate."io.k8s.api.core.v1.EnvVarSource",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.EnvVarSource"
            | doc m%"
            EnvVarSource represents a source for the value of an EnvVar.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configMapKeyRef =
                    definitions.predicate."io.k8s.api.core.v1.ConfigMapKeySelector",
                  fieldRef =
                    definitions.predicate."io.k8s.api.core.v1.ObjectFieldSelector",
                  resourceFieldRef =
                    definitions.predicate."io.k8s.api.core.v1.ResourceFieldSelector",
                  secretKeyRef =
                    definitions.predicate."io.k8s.api.core.v1.SecretKeySelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.EphemeralVolumeSource"
            | doc m%"
            Represents an ephemeral volume that is handled by a normal storage driver.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  volumeClaimTemplate =
                    definitions.predicate."io.k8s.api.core.v1.PersistentVolumeClaimTemplate",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.Event"
            | doc m%"
            Event is a report of an event somewhere in the cluster.  Events have a limited retention time and triggers and messages may evolve with time.  Event consumers should not rely on the timing of an event with a given Reason reflecting a consistent underlying trigger, or the continued existence of events with that Reason.  Events should be treated as informative, best-effort, supplemental data.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "involvedObject", "metadata" ],
                predicates.records.record
                {
                  action = predicates.isType '"String",
                  apiVersion = predicates.isType '"String",
                  count = predicates.isType 'Integer,
                  eventTime =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.MicroTime",
                  firstTimestamp =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  involvedObject =
                    definitions.predicate."io.k8s.api.core.v1.ObjectReference",
                  kind = predicates.isType '"String",
                  lastTimestamp =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  message = predicates.isType '"String",
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                  reason = predicates.isType '"String",
                  related =
                    definitions.predicate."io.k8s.api.core.v1.ObjectReference",
                  reportingComponent = predicates.isType '"String",
                  reportingInstance = predicates.isType '"String",
                  series =
                    definitions.predicate."io.k8s.api.core.v1.EventSeries",
                  source =
                    definitions.predicate."io.k8s.api.core.v1.EventSource",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.EventSeries"
            | doc m%"
            EventSeries contain information on series of events, i.e. thing that was/is happening continuously for some time.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  count = predicates.isType 'Integer,
                  lastObservedTime =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.MicroTime",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.EventSource"
            | doc m%"
            EventSource contains information for an event.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  component = predicates.isType '"String",
                  host = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ExecAction"
            | doc m%"
            ExecAction describes a "run in container" action.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  command = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.FCVolumeSource"
            | doc m%"
            Represents a Fibre Channel volume. Fibre Channel volumes can only be mounted as read/write once. Fibre Channel volumes support ownership management and SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  lun = predicates.isType 'Integer,
                  readOnly = predicates.isType '"Bool",
                  targetWWNs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  wwids = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.FlexVolumeSource"
            | doc m%"
            FlexVolume represents a generic volume resource that is provisioned/attached using an exec based plugin.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "driver" ],
                predicates.records.record
                {
                  driver = predicates.isType '"String",
                  fsType = predicates.isType '"String",
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  readOnly = predicates.isType '"Bool",
                  secretRef =
                    definitions.predicate."io.k8s.api.core.v1.LocalObjectReference",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.FlockerVolumeSource"
            | doc m%"
            Represents a Flocker volume mounted by the Flocker agent. One and only one of datasetName and datasetUUID should be set. Flocker volumes do not support ownership management or SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  datasetName = predicates.isType '"String",
                  datasetUUID = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.GCEPersistentDiskVolumeSource"
            | doc m%"
            Represents a Persistent Disk resource in Google Compute Engine.
            
            A GCE PD must exist before mounting to a container. The disk must also be in the same GCE project and zone as the kubelet. A GCE PD can only be mounted as read/write once or read-only many times. GCE PDs support ownership management and SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "pdName" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  partition = predicates.isType 'Integer,
                  pdName = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.GRPCAction" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "port" ],
                predicates.records.record
                {
                  port = predicates.isType 'Integer,
                  service = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.GitRepoVolumeSource"
            | doc m%"
            Represents a volume that is populated with the contents of a git repository. Git repo volumes do not support ownership management. Git repo volumes support SELinux relabeling.
            
            DEPRECATED: GitRepo is deprecated. To provision a container with a git repo, mount an EmptyDir into an InitContainer that clones the repo using git, then mount the EmptyDir into the Pod's container.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "repository" ],
                predicates.records.record
                {
                  directory = predicates.isType '"String",
                  repository = predicates.isType '"String",
                  revision = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.GlusterfsVolumeSource"
            | doc m%"
            Represents a Glusterfs mount that lasts the lifetime of a pod. Glusterfs volumes do not support ownership management or SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "endpoints", "path" ],
                predicates.records.record
                {
                  endpoints = predicates.isType '"String",
                  path = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.HTTPGetAction"
            | doc m%"
            HTTPGetAction describes an action based on HTTP Get requests.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "port" ],
                predicates.records.record
                {
                  host = predicates.isType '"String",
                  httpHeaders = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.HTTPHeader"
                      ],
                  path = predicates.isType '"String",
                  port =
                    definitions.predicate."io.k8s.apimachinery.pkg.util.intstr.IntOrString",
                  scheme = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "HTTP", "HTTPS" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.HTTPHeader"
            | doc m%"
            HTTPHeader describes a custom header to be used in HTTP probes
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "value" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.HostAlias"
            | doc m%"
            HostAlias holds the mapping between IP and hostnames that will be injected as an entry in the pod's hosts file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  hostnames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ip = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.HostPathVolumeSource"
            | doc m%"
            Represents a host path mapped into a pod. Host path volumes do not support ownership management or SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ISCSIVolumeSource"
            | doc m%"
            Represents an ISCSI disk. ISCSI volumes can only be mounted as read/write once. ISCSI volumes support ownership management and SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "iqn", "lun", "targetPortal" ],
                predicates.records.record
                {
                  chapAuthDiscovery = predicates.isType '"Bool",
                  chapAuthSession = predicates.isType '"Bool",
                  fsType = predicates.isType '"String",
                  initiatorName = predicates.isType '"String",
                  iqn = predicates.isType '"String",
                  iscsiInterface = predicates.isType '"String",
                  lun = predicates.isType 'Integer,
                  portals = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  readOnly = predicates.isType '"Bool",
                  secretRef =
                    definitions.predicate."io.k8s.api.core.v1.LocalObjectReference",
                  targetPortal = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.KeyToPath"
            | doc m%"
            Maps a string key to a path within a volume.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key", "path" ],
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  mode = predicates.isType 'Integer,
                  path = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.Lifecycle"
            | doc m%"
            Lifecycle describes actions that the management system should take in response to container lifecycle events. For the PostStart and PreStop lifecycle handlers, management of the container blocks until the action is complete, unless the container process fails, in which case the handler is aborted.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  postStart =
                    definitions.predicate."io.k8s.api.core.v1.LifecycleHandler",
                  preStop =
                    definitions.predicate."io.k8s.api.core.v1.LifecycleHandler",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.LifecycleHandler"
            | doc m%"
            LifecycleHandler defines a specific action that should be taken in a lifecycle hook. One and only one of the fields, except TCPSocket must be specified.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  exec = definitions.predicate."io.k8s.api.core.v1.ExecAction",
                  httpGet =
                    definitions.predicate."io.k8s.api.core.v1.HTTPGetAction",
                  tcpSocket =
                    definitions.predicate."io.k8s.api.core.v1.TCPSocketAction",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.LocalObjectReference"
            | doc m%"
            LocalObjectReference contains enough information to let you locate the referenced object inside the same namespace.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { name = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.NFSVolumeSource"
            | doc m%"
            Represents an NFS mount that lasts the lifetime of a pod. NFS volumes do not support ownership management or SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path", "server" ],
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  server = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.NodeAffinity"
            | doc m%"
            Node affinity is a group of node affinity scheduling rules.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  preferredDuringSchedulingIgnoredDuringExecution =
                    predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.PreferredSchedulingTerm"
                      ],
                  requiredDuringSchedulingIgnoredDuringExecution =
                    definitions.predicate."io.k8s.api.core.v1.NodeSelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.NodeSelector"
            | doc m%"
            A node selector represents the union of the results of one or more label queries over a set of nodes; that is, it represents the OR of the selectors represented by the node selector terms.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "nodeSelectorTerms" ],
                predicates.records.record
                {
                  nodeSelectorTerms = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.NodeSelectorTerm"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.NodeSelectorRequirement"
            | doc m%"
            A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key", "operator" ],
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  operator = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "DoesNotExist", "Exists", "Gt", "In", "Lt", "NotIn" ]
                      ],
                  values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.NodeSelectorTerm"
            | doc m%"
            A null or empty node selector term matches no objects. The requirements of them are ANDed. The TopologySelectorTerm type implements a subset of the NodeSelectorTerm.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  matchExpressions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.NodeSelectorRequirement"
                      ],
                  matchFields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.NodeSelectorRequirement"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ObjectFieldSelector"
            | doc m%"
            ObjectFieldSelector selects an APIVersioned field of an object.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fieldPath" ],
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  fieldPath = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ObjectReference"
            | doc m%"
            ObjectReference contains enough information to let you inspect or modify the referred object.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  fieldPath = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  resourceVersion = predicates.isType '"String",
                  uid = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PersistentVolumeClaim"
            | doc m%"
            PersistentVolumeClaim is a user's request for and claim to a persistent volume
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                  spec =
                    definitions.predicate."io.k8s.api.core.v1.PersistentVolumeClaimSpec",
                  status =
                    definitions.predicate."io.k8s.api.core.v1.PersistentVolumeClaimStatus",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PersistentVolumeClaimCondition"
            | doc m%"
            PersistentVolumeClaimCondition contails details about state of pvc
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "status", "type" ],
                predicates.records.record
                {
                  lastProbeTime =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  lastTransitionTime =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  message = predicates.isType '"String",
                  reason = predicates.isType '"String",
                  status = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "FileSystemResizePending", "Resizing" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PersistentVolumeClaimSpec"
            | doc m%"
            PersistentVolumeClaimSpec describes the common attributes of storage devices and allows a Source for provider-specific attributes
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessModes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  dataSource =
                    definitions.predicate."io.k8s.api.core.v1.TypedLocalObjectReference",
                  dataSourceRef =
                    definitions.predicate."io.k8s.api.core.v1.TypedLocalObjectReference",
                  resources =
                    definitions.predicate."io.k8s.api.core.v1.ResourceRequirements",
                  selector =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector",
                  storageClassName = predicates.isType '"String",
                  volumeMode = predicates.isType '"String",
                  volumeName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PersistentVolumeClaimStatus"
            | doc m%"
            PersistentVolumeClaimStatus is the current status of a persistent volume claim.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessModes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  allocatedResources = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity"
                      ],
                  capacity = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity"
                      ],
                  conditions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.PersistentVolumeClaimCondition"
                      ],
                  phase = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Bound", "Lost", "Pending" ]
                      ],
                  resizeStatus = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PersistentVolumeClaimTemplate"
            | doc m%"
            PersistentVolumeClaimTemplate is used to produce PersistentVolumeClaim objects as part of an EphemeralVolumeSource.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "spec" ],
                predicates.records.record
                {
                  metadata =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                  spec =
                    definitions.predicate."io.k8s.api.core.v1.PersistentVolumeClaimSpec",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PersistentVolumeClaimVolumeSource"
            | doc m%"
            PersistentVolumeClaimVolumeSource references the user's PVC in the same namespace. This volume finds the bound PV and mounts that volume for the pod. A PersistentVolumeClaimVolumeSource is, essentially, a wrapper around another type of volume that is owned by someone else (the system).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "claimName" ],
                predicates.records.record
                {
                  claimName = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PhotonPersistentDiskVolumeSource"
            | doc m%"
            Represents a Photon Controller persistent disk resource.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "pdID" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  pdID = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PodAffinity"
            | doc m%"
            Pod affinity is a group of inter pod affinity scheduling rules.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  preferredDuringSchedulingIgnoredDuringExecution =
                    predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.WeightedPodAffinityTerm"
                      ],
                  requiredDuringSchedulingIgnoredDuringExecution =
                    predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.PodAffinityTerm"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PodAffinityTerm"
            | doc m%"
            Defines a set of pods (namely those matching the labelSelector relative to the given namespace(s)) that this pod should be co-located (affinity) or not co-located (anti-affinity) with, where co-located is defined as running on a node whose value of the label with key <topologyKey> matches that of any node on which a pod of the set of pods is running
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "topologyKey" ],
                predicates.records.record
                {
                  labelSelector =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector",
                  namespaceSelector =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector",
                  namespaces = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  topologyKey = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PodAntiAffinity"
            | doc m%"
            Pod anti affinity is a group of inter pod anti affinity scheduling rules.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  preferredDuringSchedulingIgnoredDuringExecution =
                    predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.WeightedPodAffinityTerm"
                      ],
                  requiredDuringSchedulingIgnoredDuringExecution =
                    predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.PodAffinityTerm"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PodDNSConfig"
            | doc m%"
            PodDNSConfig defines the DNS parameters of a pod in addition to those generated from DNSPolicy.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  nameservers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  options = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.PodDNSConfigOption"
                      ],
                  searches = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PodDNSConfigOption"
            | doc m%"
            PodDNSConfigOption defines DNS resolver options of a pod.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PodSecurityContext"
            | doc m%"
            PodSecurityContext holds pod-level security attributes and common container settings. Some fields are also present in container.securityContext.  Field values of container.securityContext take precedence over field values of PodSecurityContext.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsGroup = predicates.isType 'Integer,
                  fsGroupChangePolicy = predicates.isType '"String",
                  runAsGroup = predicates.isType 'Integer,
                  runAsNonRoot = predicates.isType '"Bool",
                  runAsUser = predicates.isType 'Integer,
                  seLinuxOptions =
                    definitions.predicate."io.k8s.api.core.v1.SELinuxOptions",
                  seccompProfile =
                    definitions.predicate."io.k8s.api.core.v1.SeccompProfile",
                  supplementalGroups = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType 'Integer)
                      ],
                  sysctls = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.Sysctl"
                      ],
                  windowsOptions =
                    definitions.predicate."io.k8s.api.core.v1.WindowsSecurityContextOptions",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PortworxVolumeSource"
            | doc m%"
            PortworxVolumeSource represents a Portworx volume resource.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "volumeID" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  volumeID = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.PreferredSchedulingTerm"
            | doc m%"
            An empty preferred scheduling term matches all objects with implicit weight 0 (i.e. it's a no-op). A null preferred scheduling term matches no objects (i.e. is also a no-op).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "preference", "weight" ],
                predicates.records.record
                {
                  preference =
                    definitions.predicate."io.k8s.api.core.v1.NodeSelectorTerm",
                  weight = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.Probe"
            | doc m%"
            Probe describes a health check to be performed against a container to determine whether it is alive or ready to receive traffic.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  exec = definitions.predicate."io.k8s.api.core.v1.ExecAction",
                  failureThreshold = predicates.isType 'Integer,
                  grpc = definitions.predicate."io.k8s.api.core.v1.GRPCAction",
                  httpGet =
                    definitions.predicate."io.k8s.api.core.v1.HTTPGetAction",
                  initialDelaySeconds = predicates.isType 'Integer,
                  periodSeconds = predicates.isType 'Integer,
                  successThreshold = predicates.isType 'Integer,
                  tcpSocket =
                    definitions.predicate."io.k8s.api.core.v1.TCPSocketAction",
                  terminationGracePeriodSeconds = predicates.isType 'Integer,
                  timeoutSeconds = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ProjectedVolumeSource"
            | doc m%"
            Represents a projected volume source
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultMode = predicates.isType 'Integer,
                  sources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.VolumeProjection"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.QuobyteVolumeSource"
            | doc m%"
            Represents a Quobyte mount that lasts the lifetime of a pod. Quobyte volumes do not support ownership management or SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "registry", "volume" ],
                predicates.records.record
                {
                  group = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  registry = predicates.isType '"String",
                  tenant = predicates.isType '"String",
                  user = predicates.isType '"String",
                  volume = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.RBDVolumeSource"
            | doc m%"
            Represents a Rados Block Device mount that lasts the lifetime of a pod. RBD volumes support ownership management and SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image", "monitors" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  image = predicates.isType '"String",
                  keyring = predicates.isType '"String",
                  monitors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  pool = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretRef =
                    definitions.predicate."io.k8s.api.core.v1.LocalObjectReference",
                  user = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ResourceFieldSelector"
            | doc m%"
            ResourceFieldSelector represents container resources (cpu, memory) and their output format
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "resource" ],
                predicates.records.record
                {
                  containerName = predicates.isType '"String",
                  divisor =
                    definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity",
                  resource = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ResourceRequirements"
            | doc m%"
            ResourceRequirements describes the compute resource requirements.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  limits = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity"
                      ],
                  requests = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate."io.k8s.apimachinery.pkg.api.resource.Quantity"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.SELinuxOptions"
            | doc m%"
            SELinuxOptions are the labels to be applied to the container
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  level = predicates.isType '"String",
                  role = predicates.isType '"String",
                  type = predicates.isType '"String",
                  user = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ScaleIOVolumeSource"
            | doc m%"
            ScaleIOVolumeSource represents a persistent ScaleIO volume
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "gateway", "secretRef", "system" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  gateway = predicates.isType '"String",
                  protectionDomain = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretRef =
                    definitions.predicate."io.k8s.api.core.v1.LocalObjectReference",
                  sslEnabled = predicates.isType '"Bool",
                  storageMode = predicates.isType '"String",
                  storagePool = predicates.isType '"String",
                  system = predicates.isType '"String",
                  volumeName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.SeccompProfile"
            | doc m%"
            SeccompProfile defines a pod/container's seccomp profile settings. Only one profile source may be set.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  localhostProfile = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "Localhost", "RuntimeDefault", "Unconfined" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.SecretEnvSource"
            | doc m%"
            SecretEnvSource selects a Secret to populate the environment variables with.
            
            The contents of the target Secret's Data field will represent the key-value pairs as environment variables.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.SecretKeySelector"
            | doc m%"
            SecretKeySelector selects a key of a Secret.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key" ],
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.SecretProjection"
            | doc m%"
            Adapts a secret into a projected volume.
            
            The contents of the target Secret's Data field will be presented in a projected volume as files using the keys in the Data field as the file names. Note that this is identical to a secret volume source without the default mode.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.KeyToPath"
                      ],
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.SecretVolumeSource"
            | doc m%"
            Adapts a Secret into a volume.
            
            The contents of the target Secret's Data field will be presented in a volume as files using the keys in the Data field as the file names. Secret volumes support ownership management and SELinux relabeling.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultMode = predicates.isType 'Integer,
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.api.core.v1.KeyToPath"
                      ],
                  "optional" = predicates.isType '"Bool",
                  secretName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.SecurityContext"
            | doc m%"
            SecurityContext holds security configuration that will be applied to a container. Some fields are present in both SecurityContext and PodSecurityContext.  When both are set, the values in SecurityContext take precedence.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowPrivilegeEscalation = predicates.isType '"Bool",
                  capabilities =
                    definitions.predicate."io.k8s.api.core.v1.Capabilities",
                  privileged = predicates.isType '"Bool",
                  procMount = predicates.isType '"String",
                  readOnlyRootFilesystem = predicates.isType '"Bool",
                  runAsGroup = predicates.isType 'Integer,
                  runAsNonRoot = predicates.isType '"Bool",
                  runAsUser = predicates.isType 'Integer,
                  seLinuxOptions =
                    definitions.predicate."io.k8s.api.core.v1.SELinuxOptions",
                  seccompProfile =
                    definitions.predicate."io.k8s.api.core.v1.SeccompProfile",
                  windowsOptions =
                    definitions.predicate."io.k8s.api.core.v1.WindowsSecurityContextOptions",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ServiceAccountTokenProjection"
            | doc m%"
            ServiceAccountTokenProjection represents a projected service account token volume. This projection can be used to insert a service account token into the pods runtime filesystem for use against APIs (Kubernetes API Server or otherwise).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  audience = predicates.isType '"String",
                  expirationSeconds = predicates.isType 'Integer,
                  path = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.ServicePort"
            | doc m%"
            ServicePort contains information on service's port.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "port" ],
                predicates.records.record
                {
                  appProtocol = predicates.isType '"String",
                  name = predicates.isType '"String",
                  nodePort = predicates.isType 'Integer,
                  port = predicates.isType 'Integer,
                  protocol = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "SCTP", "TCP", "UDP" ]
                      ],
                  targetPort =
                    definitions.predicate."io.k8s.apimachinery.pkg.util.intstr.IntOrString",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.StorageOSVolumeSource"
            | doc m%"
            Represents a StorageOS persistent volume resource.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretRef =
                    definitions.predicate."io.k8s.api.core.v1.LocalObjectReference",
                  volumeName = predicates.isType '"String",
                  volumeNamespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.Sysctl"
            | doc m%"
            Sysctl defines a kernel parameter to be set
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "value" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.TCPSocketAction"
            | doc m%"
            TCPSocketAction describes an action based on opening a socket
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "port" ],
                predicates.records.record
                {
                  host = predicates.isType '"String",
                  port =
                    definitions.predicate."io.k8s.apimachinery.pkg.util.intstr.IntOrString",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.Toleration"
            | doc m%"
            The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  effect = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "NoExecute", "NoSchedule", "PreferNoSchedule" ]
                      ],
                  key = predicates.isType '"String",
                  operator = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Equal", "Exists" ]
                      ],
                  tolerationSeconds = predicates.isType 'Integer,
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.TypedLocalObjectReference"
            | doc m%"
            TypedLocalObjectReference contains enough information to let you locate the typed referenced object inside the same namespace.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind", "name" ],
                predicates.records.record
                {
                  apiGroup = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.Volume"
            | doc m%"
            Volume represents a named volume in a pod that may be accessed by any container in the pod.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  awsElasticBlockStore =
                    definitions.predicate."io.k8s.api.core.v1.AWSElasticBlockStoreVolumeSource",
                  azureDisk =
                    definitions.predicate."io.k8s.api.core.v1.AzureDiskVolumeSource",
                  azureFile =
                    definitions.predicate."io.k8s.api.core.v1.AzureFileVolumeSource",
                  cephfs =
                    definitions.predicate."io.k8s.api.core.v1.CephFSVolumeSource",
                  cinder =
                    definitions.predicate."io.k8s.api.core.v1.CinderVolumeSource",
                  configMap =
                    definitions.predicate."io.k8s.api.core.v1.ConfigMapVolumeSource",
                  csi =
                    definitions.predicate."io.k8s.api.core.v1.CSIVolumeSource",
                  downwardAPI =
                    definitions.predicate."io.k8s.api.core.v1.DownwardAPIVolumeSource",
                  emptyDir =
                    definitions.predicate."io.k8s.api.core.v1.EmptyDirVolumeSource",
                  ephemeral =
                    definitions.predicate."io.k8s.api.core.v1.EphemeralVolumeSource",
                  fc =
                    definitions.predicate."io.k8s.api.core.v1.FCVolumeSource",
                  flexVolume =
                    definitions.predicate."io.k8s.api.core.v1.FlexVolumeSource",
                  flocker =
                    definitions.predicate."io.k8s.api.core.v1.FlockerVolumeSource",
                  gcePersistentDisk =
                    definitions.predicate."io.k8s.api.core.v1.GCEPersistentDiskVolumeSource",
                  gitRepo =
                    definitions.predicate."io.k8s.api.core.v1.GitRepoVolumeSource",
                  glusterfs =
                    definitions.predicate."io.k8s.api.core.v1.GlusterfsVolumeSource",
                  hostPath =
                    definitions.predicate."io.k8s.api.core.v1.HostPathVolumeSource",
                  iscsi =
                    definitions.predicate."io.k8s.api.core.v1.ISCSIVolumeSource",
                  name = predicates.isType '"String",
                  nfs =
                    definitions.predicate."io.k8s.api.core.v1.NFSVolumeSource",
                  persistentVolumeClaim =
                    definitions.predicate."io.k8s.api.core.v1.PersistentVolumeClaimVolumeSource",
                  photonPersistentDisk =
                    definitions.predicate."io.k8s.api.core.v1.PhotonPersistentDiskVolumeSource",
                  portworxVolume =
                    definitions.predicate."io.k8s.api.core.v1.PortworxVolumeSource",
                  projected =
                    definitions.predicate."io.k8s.api.core.v1.ProjectedVolumeSource",
                  quobyte =
                    definitions.predicate."io.k8s.api.core.v1.QuobyteVolumeSource",
                  rbd =
                    definitions.predicate."io.k8s.api.core.v1.RBDVolumeSource",
                  scaleIO =
                    definitions.predicate."io.k8s.api.core.v1.ScaleIOVolumeSource",
                  secret =
                    definitions.predicate."io.k8s.api.core.v1.SecretVolumeSource",
                  storageos =
                    definitions.predicate."io.k8s.api.core.v1.StorageOSVolumeSource",
                  vsphereVolume =
                    definitions.predicate."io.k8s.api.core.v1.VsphereVirtualDiskVolumeSource",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.VolumeDevice"
            | doc m%"
            volumeDevice describes a mapping of a raw block device within a container.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "devicePath", "name" ],
                predicates.records.record
                {
                  devicePath = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.VolumeMount"
            | doc m%"
            VolumeMount describes a mounting of a Volume within a container.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "mountPath", "name" ],
                predicates.records.record
                {
                  mountPath = predicates.isType '"String",
                  mountPropagation = predicates.isType '"String",
                  name = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  subPath = predicates.isType '"String",
                  subPathExpr = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.VolumeProjection"
            | doc m%"
            Projection that may be projected along with other supported volume types
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configMap =
                    definitions.predicate."io.k8s.api.core.v1.ConfigMapProjection",
                  downwardAPI =
                    definitions.predicate."io.k8s.api.core.v1.DownwardAPIProjection",
                  secret =
                    definitions.predicate."io.k8s.api.core.v1.SecretProjection",
                  serviceAccountToken =
                    definitions.predicate."io.k8s.api.core.v1.ServiceAccountTokenProjection",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.VsphereVirtualDiskVolumeSource"
            | doc m%"
            Represents a vSphere volume resource.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "volumePath" ],
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  storagePolicyID = predicates.isType '"String",
                  storagePolicyName = predicates.isType '"String",
                  volumePath = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.WeightedPodAffinityTerm"
            | doc m%"
            The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "podAffinityTerm", "weight" ],
                predicates.records.record
                {
                  podAffinityTerm =
                    definitions.predicate."io.k8s.api.core.v1.PodAffinityTerm",
                  weight = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.core.v1.WindowsSecurityContextOptions"
            | doc m%"
            WindowsSecurityContextOptions contain Windows-specific options and credentials.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  gmsaCredentialSpec = predicates.isType '"String",
                  gmsaCredentialSpecName = predicates.isType '"String",
                  hostProcess = predicates.isType '"Bool",
                  runAsUserName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.api.policy.v1.PodDisruptionBudgetSpec"
            | doc m%"
            PodDisruptionBudgetSpec is a description of a PodDisruptionBudget.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  maxUnavailable =
                    definitions.predicate."io.k8s.apimachinery.pkg.util.intstr.IntOrString",
                  minAvailable =
                    definitions.predicate."io.k8s.apimachinery.pkg.util.intstr.IntOrString",
                  selector =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.apimachinery.pkg.api.resource.Quantity"
            | doc m%"
            Quantity is a fixed-point representation of a number. It provides convenient marshaling/unmarshaling in JSON and YAML, in addition to String() and AsInt64() accessors.
            
            The serialization format is:
            
            <quantity>        ::= <signedNumber><suffix>
              (Note that <suffix> may be empty, from the "" case in <decimalSI>.)
            <digit>           ::= 0 | 1 | ... | 9 <digits>          ::= <digit> | <digit><digits> <number>          ::= <digits> | <digits>.<digits> | <digits>. | .<digits> <sign>            ::= "+" | "-" <signedNumber>    ::= <number> | <sign><number> <suffix>          ::= <binarySI> | <decimalExponent> | <decimalSI> <binarySI>        ::= Ki | Mi | Gi | Ti | Pi | Ei
              (International System of units; See: http://physics.nist.gov/cuu/Units/binary.html)
            <decimalSI>       ::= m | "" | k | M | G | T | P | E
              (Note that 1024 = 1Ki but 1000 = 1k; I didn't choose the capitalization.)
            <decimalExponent> ::= "e" <signedNumber> | "E" <signedNumber>
            
            No matter which of the three exponent forms is used, no quantity may represent a number greater than 2^63-1 in magnitude, nor may it have more than 3 decimal places. Numbers larger or more precise will be capped or rounded up. (E.g.: 0.1m will rounded up to 1m.) This may be extended in the future if we require larger or smaller quantities.
            
            When a Quantity is parsed from a string, it will remember the type of suffix it had, and will use the same type again when it is serialized.
            
            Before serializing, Quantity will be put in "canonical form". This means that Exponent/suffix will be adjusted up or down (with a corresponding increase or decrease in Mantissa) such that:
              a. No precision is lost
              b. No fractional digits will be emitted
              c. The exponent (or suffix) is as large as possible.
            The sign will be omitted unless the number is negative.
            
            Examples:
              1.5 will be serialized as "1500m"
              1.5Gi will be serialized as "1536Mi"
            
            Note that the quantity will NEVER be internally represented by a floating point number. That is the whole point of this exercise.
            
            Non-canonical values will still parse as long as they are well formed, but will be re-emitted in their canonical form. (So always use canonical form, or don't diff.)
            
            This format is intended to make it difficult to use these numbers without writing some sort of special handling code in the hopes that that will cause implementors to also use a fixed point implementation.
            "%
            = predicates.isType '"String",
          "io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions"
            | doc m%"
            CreateOptions may be provided when creating an API object.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  dryRun = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  fieldManager = predicates.isType '"String",
                  fieldValidation = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.apimachinery.pkg.apis.meta.v1.Duration"
            | doc m%"
            Duration is a wrapper around time.Duration which supports correct
            marshaling to YAML and JSON. In particular, it marshals into strings, which
            can be used as map keys in json.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { duration = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          "io.k8s.apimachinery.pkg.apis.meta.v1.FieldsV1"
            | doc m%"
            FieldsV1 stores a set of fields in a data structure like a Trie, in JSON format.
            
            Each key is either a '.' representing the field itself, and will always map to an empty set, or a string representing a sub-field or item. The string will follow one of these four formats: 'f:<name>', where <name> is the name of a field in a struct, or key in a map 'v:<value>', where <value> is the exact json formatted value of a list item 'i:<index>', where <index> is position of a item in a list 'k:<keys>', where <keys> is a map of  a list item's key fields to their unique values If a key maps to an empty Fields value, the field that key represents is part of the set.
            
            The exact format is defined in sigs.k8s.io/structured-merge-diff
            "%
            = predicates.isType 'Record,
          "io.k8s.apimachinery.pkg.apis.meta.v1.GroupVersionResource"
            | doc m%"
            +protobuf.options.(gogoproto.goproto_stringer)=false
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  group = predicates.isType '"String",
                  resource = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector"
            | doc m%"
            A label selector is a label query over a set of resources. The result of matchLabels and matchExpressions are ANDed. An empty label selector matches all objects. A null label selector matches no objects.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  matchExpressions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelectorRequirement"
                      ],
                  matchLabels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelectorRequirement"
            | doc m%"
            A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key", "operator" ],
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  operator = predicates.isType '"String",
                  values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta"
            | doc m%"
            ListMeta describes metadata that synthetic resources must have, including lists and various status objects. A resource may have only one of {ObjectMeta, ListMeta}.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  continue = predicates.isType '"String",
                  remainingItemCount = predicates.isType 'Integer,
                  resourceVersion = predicates.isType '"String",
                  selfLink = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.apimachinery.pkg.apis.meta.v1.ManagedFieldsEntry"
            | doc m%"
            ManagedFieldsEntry is a workflow-id, a FieldSet and the group version of the resource that the fieldset applies to.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  fieldsType = predicates.isType '"String",
                  fieldsV1 =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.FieldsV1",
                  manager = predicates.isType '"String",
                  operation = predicates.isType '"String",
                  subresource = predicates.isType '"String",
                  time =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.apimachinery.pkg.apis.meta.v1.MicroTime"
            | doc m%"
            MicroTime is version of Time with microsecond level precision.
            "%
            = predicates.isType '"String",
          "io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta"
            | doc m%"
            ObjectMeta is metadata that all persisted resources must have, which includes all objects users must create.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  clusterName = predicates.isType '"String",
                  creationTimestamp =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  deletionGracePeriodSeconds = predicates.isType 'Integer,
                  deletionTimestamp =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  finalizers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  generateName = predicates.isType '"String",
                  generation = predicates.isType 'Integer,
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  managedFields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.ManagedFieldsEntry"
                      ],
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  ownerReferences = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.OwnerReference"
                      ],
                  resourceVersion = predicates.isType '"String",
                  selfLink = predicates.isType '"String",
                  uid = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.apimachinery.pkg.apis.meta.v1.OwnerReference"
            | doc m%"
            OwnerReference contains enough information to let you identify an owning object. An owning object must be in the same namespace as the dependent, or be cluster-scoped, so there is no namespace field.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "apiVersion", "kind", "name", "uid" ],
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  blockOwnerDeletion = predicates.isType '"Bool",
                  controller = predicates.isType '"Bool",
                  kind = predicates.isType '"String",
                  name = predicates.isType '"String",
                  uid = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.apimachinery.pkg.apis.meta.v1.StatusCause"
            | doc m%"
            StatusCause provides more information about an api.Status failure, including cases when multiple errors are encountered.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  field = predicates.isType '"String",
                  message = predicates.isType '"String",
                  reason = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "io.k8s.apimachinery.pkg.apis.meta.v1.Time"
            | doc m%"
            Time is a wrapper around time.Time which supports correct marshaling to YAML and JSON.  Wrappers are provided for many of the factory methods that the time package offers.
            "%
            = predicates.isType '"String",
          "io.k8s.apimachinery.pkg.util.intstr.IntOrString" = predicates.isType
              '"String",
          "sensor.CreateSensorRequest" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createOptions =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.CreateOptions",
                  namespace = predicates.isType '"String",
                  sensor =
                    definitions.predicate."io.argoproj.events.v1alpha1.Sensor",
                }
                {  }
                true
                predicates.always
              ],
          "sensor.DeleteSensorResponse" = predicates.isType 'Record,
          "sensor.LogEntry" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  dependencyName = predicates.isType '"String",
                  eventContext = predicates.isType '"String",
                  level = predicates.isType '"String",
                  msg = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  sensorName = predicates.isType '"String",
                  time =
                    definitions.predicate."io.k8s.apimachinery.pkg.apis.meta.v1.Time",
                  triggerName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "sensor.SensorWatchEvent" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  object =
                    definitions.predicate."io.argoproj.events.v1alpha1.Sensor",
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          "sensor.UpdateSensorRequest" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  sensor =
                    definitions.predicate."io.argoproj.events.v1alpha1.Sensor",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.oneOf
  [
    definitions.predicate."io.argoproj.workflow.v1alpha1.ClusterWorkflowTemplate",
    definitions.predicate."io.argoproj.workflow.v1alpha1.CronWorkflow",
    definitions.predicate."io.argoproj.workflow.v1alpha1.Workflow",
    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowEventBinding",
    definitions.predicate."io.argoproj.workflow.v1alpha1.WorkflowTemplate"
  ]
])