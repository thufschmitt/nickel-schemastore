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
          compilerOptions = {
                baseDir
                  | definitions.contract.nonEmptyString
                  | doc m%"
                  Specifies the base directory of input and output files.
                  "%
                  | optional,
                bindings
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate."compilerOptions/properties/bindings/definitions/bindings",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."compilerOptions/properties/bindings/definitions/bindings",
                      predicates.arrays.uniqueItems
                    ]
                  ])
                  | doc m%"
                  Specified the bindings to generate.
                  "%
                  | optional,
                converge
                  | Bool
                  | doc m%"
                  Re-optimizes until no further improvements can be made.
                  "%
                  | optional,
                debug
                  | Bool
                  | doc m%"
                  Enables debug information in emitted binaries.
                  "%
                  | optional,
                disable
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.webAssemblyFeatures,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.webAssemblyFeatures,
                      predicates.arrays.uniqueItems
                    ]
                  ])
                  | doc m%"
                  Disables WebAssembly features that are enabled by default.
                  "%
                  | optional,
                enable
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.webAssemblyFeatures,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.webAssemblyFeatures,
                      predicates.arrays.uniqueItems
                    ]
                  ])
                  | doc m%"
                  Enables WebAssembly features that are disabled by default.
                  "%
                  | optional,
                exportRuntime
                  | Bool
                  | doc m%"
                  Exports the runtime helpers (__new, __collect etc.).
                  "%
                  | optional,
                exportStart
                  | definitions.contract.nonEmptyString
                  | doc m%"
                  Exports the start function instead of calling it implicitly.
                  "%
                  | optional,
                exportTable
                  | Bool
                  | doc m%"
                  Exports the function table as 'table'.
                  "%
                  | optional,
                importMemory
                  | Bool
                  | doc m%"
                  Imports the memory provided as 'env.memory'.
                  "%
                  | optional,
                importTable
                  | Bool
                  | doc m%"
                  Imports the function table provided as 'env.table'.
                  "%
                  | optional,
                initialMemory
                  | Number
                  | doc m%"
                  Sets the initial memory size in pages.
                  "%
                  | optional,
                lib
                  | definitions.contract.nonEmptyStringOrArrayOfNonEmptyStrings
                  | doc m%"
                  Adds one or multiple paths to custom library components.
                  "%
                  | optional,
                lowMemoryLimit
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Enforces very low (<64k) memory constraints.
                  "%
                  | optional,
                maximumMemory
                  | Number
                  | doc m%"
                  Sets the maximum memory size in pages.
                  "%
                  | optional,
                memoryBase
                  | Number
                  | doc m%"
                  Sets the start offset of compiler-generated static memory.
                  "%
                  | optional,
                noAssert
                  | Bool
                  | doc m%"
                  Replaces assertions with just their value without trapping.
                  "%
                  | optional,
                noColors
                  | Bool
                  | doc m%"
                  Disables terminal colors.
                  "%
                  | optional,
                noEmit
                  | Bool
                  | doc m%"
                  Performs compilation as usual but does not emit code.
                  "%
                  | optional,
                noExportMemory
                  | Bool
                  | doc m%"
                  Does not export the memory as 'memory'.
                  "%
                  | optional,
                noUnsafe
                  | Bool
                  | doc m%"
                  Disallows the use of unsafe features in user code.
                  "%
                  | optional,
                noValidate
                  | Bool
                  | doc m%"
                  Skips validating the module using Binaryen.
                  "%
                  | optional,
                optimize
                  | Bool
                  | doc m%"
                  Optimizes the module.
                  "%
                  | optional,
                optimizeLevel
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 3,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  How much to focus on optimizing code.
                  "%
                  | optional,
                outFile
                  | definitions.contract.nonEmptyString
                  | doc m%"
                  Specifies the WebAssembly output file (.wasm).
                  "%
                  | optional,
                path
                  | definitions.contract.nonEmptyStringOrArrayOfNonEmptyStrings
                  | doc m%"
                  Adds one or multiple paths to package resolution.
                  "%
                  | optional,
                pedantic
                  | Bool
                  | doc m%"
                  Make yourself sad for no good reason.
                  "%
                  | optional,
                runPasses
                  | definitions.contract.nonEmptyStringOrArrayOfNonEmptyStrings
                  | doc m%"
                  Specifies additional Binaryen passes to run.
                  "%
                  | optional,
                runtime
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "incremental", "minimal", "stub" ]
                    ],
                    definitions.predicate.nonEmptyString
                  ])
                  | doc m%"
                  Specifies the runtime variant to include in the program.
                  "%
                  | optional,
                sharedMemory
                  | Number
                  | doc m%"
                  Declare memory as shared. Requires maximumMemory.
                  "%
                  | optional,
                shrinkLevel
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 2,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  How much to focus on shrinking code size.
                  "%
                  | optional,
                sourceMap
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.nonEmptyString
                  ])
                  | doc m%"
                  Enables source map generation. Optionally takes the URL.
                  "%
                  | optional,
                stackSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Exports the runtime helpers (__new, __collect etc.).
                  "%
                  | optional,
                stats
                  | Bool
                  | doc m%"
                  Prints measuring information on I/O and compile times.
                  "%
                  | optional,
                tableBase
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Sets the start offset of emitted table elements.
                  "%
                  | optional,
                textFile
                  | definitions.contract.nonEmptyString
                  | doc m%"
                  Specifies the WebAssembly text output file (.wat).
                  "%
                  | optional,
                transform
                  | definitions.contract.nonEmptyStringOrArrayOfNonEmptyStrings
                  | doc m%"
                  Specifies the path to a custom transform to 'require'.
                  "%
                  | optional,
                trapMode
                  | std.enum.TagOrString
                  | [| 'js, 'clamp, 'allow |]
                  | doc m%"
                  Sets the trap mode to use.
                  "%
                  | optional,
                use
                  | definitions.contract.nonEmptyStringOrArrayOfNonEmptyStrings
                  | doc m%"
                  Aliases a global object under another name.
                  "%
                  | optional,
                wasm
                  | definitions.contract.nonEmptyString
                  | doc m%"
                  Uses the specified Wasm binary of the compiler.
                  "%
                  | optional,
                zeroFilledMemory
                  | Bool
                  | doc m%"
                  Assume that imported memory is zero filled. Requires importMemory.
                  "%
                  | optional,
              },
          nonEmptyString = predicates.contract_from_predicate
              definitions.predicate.nonEmptyString,
          nonEmptyStringOrArrayOfNonEmptyStrings =
            predicates.contract_from_predicate
              definitions.predicate.nonEmptyStringOrArrayOfNonEmptyStrings,
          webAssemblyFeatures = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'memory64,
                  'gc,
                  'multi-value,
                  'reference-types,
                  'tail-calls,
                  'exception-handling,
                  'threads,
                  'simd,
                  'bulk-memory,
                  'nontrapping-f2i,
                  'mutable-globals,
                  'sign-extension
                |]
              ],
        },
    predicate = {
          arrayOfNonEmptyStrings = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.nonEmptyString,
                predicates.arrays.uniqueItems
              ],
          compilerOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  baseDir = definitions.predicate.nonEmptyString,
                  bindings = predicates.anyOf
                      [
                        definitions.predicate."compilerOptions/properties/bindings/definitions/bindings",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate."compilerOptions/properties/bindings/definitions/bindings",
                          predicates.arrays.uniqueItems
                        ]
                      ],
                  converge = predicates.isType '"Bool",
                  debug = predicates.isType '"Bool",
                  disable = predicates.anyOf
                      [
                        definitions.predicate.webAssemblyFeatures,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.webAssemblyFeatures,
                          predicates.arrays.uniqueItems
                        ]
                      ],
                  enable = predicates.anyOf
                      [
                        definitions.predicate.webAssemblyFeatures,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.webAssemblyFeatures,
                          predicates.arrays.uniqueItems
                        ]
                      ],
                  exportRuntime = predicates.isType '"Bool",
                  exportStart = definitions.predicate.nonEmptyString,
                  exportTable = predicates.isType '"Bool",
                  importMemory = predicates.isType '"Bool",
                  importTable = predicates.isType '"Bool",
                  initialMemory = predicates.isType '"Number",
                  lib =
                    definitions.predicate.nonEmptyStringOrArrayOfNonEmptyStrings,
                  lowMemoryLimit = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  maximumMemory = predicates.isType '"Number",
                  memoryBase = predicates.isType '"Number",
                  noAssert = predicates.isType '"Bool",
                  noColors = predicates.isType '"Bool",
                  noEmit = predicates.isType '"Bool",
                  noExportMemory = predicates.isType '"Bool",
                  noUnsafe = predicates.isType '"Bool",
                  noValidate = predicates.isType '"Bool",
                  optimize = predicates.isType '"Bool",
                  optimizeLevel = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 3,
                        predicates.numbers.minimum 0
                      ],
                  outFile = definitions.predicate.nonEmptyString,
                  path =
                    definitions.predicate.nonEmptyStringOrArrayOfNonEmptyStrings,
                  pedantic = predicates.isType '"Bool",
                  runPasses =
                    definitions.predicate.nonEmptyStringOrArrayOfNonEmptyStrings,
                  runtime = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "incremental", "minimal", "stub" ]
                        ],
                        definitions.predicate.nonEmptyString
                      ],
                  sharedMemory = predicates.isType '"Number",
                  shrinkLevel = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 2,
                        predicates.numbers.minimum 0
                      ],
                  sourceMap = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.nonEmptyString
                      ],
                  stackSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  stats = predicates.isType '"Bool",
                  tableBase = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  textFile = definitions.predicate.nonEmptyString,
                  transform =
                    definitions.predicate.nonEmptyStringOrArrayOfNonEmptyStrings,
                  trapMode = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "allow", "clamp", "js" ]
                      ],
                  use =
                    definitions.predicate.nonEmptyStringOrArrayOfNonEmptyStrings,
                  wasm = definitions.predicate.nonEmptyString,
                  zeroFilledMemory = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          nonEmptyString = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          nonEmptyStringOrArrayOfNonEmptyStrings = predicates.anyOf
              [
                definitions.predicate.nonEmptyString,
                definitions.predicate.arrayOfNonEmptyStrings
              ],
          webAssemblyFeatures = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "sign-extension",
                  "mutable-globals",
                  "nontrapping-f2i",
                  "bulk-memory",
                  "simd",
                  "threads",
                  "exception-handling",
                  "tail-calls",
                  "reference-types",
                  "multi-value",
                  "gc",
                  "memory64"
                ]
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
    entries = definitions.predicate.arrayOfNonEmptyStrings,
    extends = definitions.predicate.nonEmptyString,
    options = definitions.predicate.compilerOptions,
    targets = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          definitions.predicate.compilerOptions
        ],
  }
  {  }
  false
  predicates.never
])