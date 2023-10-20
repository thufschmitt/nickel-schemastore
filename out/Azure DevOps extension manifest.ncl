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
          Badge
            | doc m%"
            A link to external metadata badge.
            "%
            = {
                description
                  | String
                  | doc m%"
                  Description of the badge, to be displayed on hover.
                  "%
                  | optional,
                href
                  | String
                  | doc m%"
                  Link the user navigates to when selecting the badge.
                  "%
                  | optional,
                uri
                  | String
                  | doc m%"
                  The absolute URL of the badge image to be displayed.
                  "%,
                ..
              },
          Content
            | doc m%"
            A content file that describes the extension to users.
            "%
            = {
                path
                  | String
                  | doc m%"
                  The path to the file in the extension.
                  "%,
                ..
              },
          Contribution
            | doc m%"
            An individual contribution made by an extension
            "%
            = {
                constraints
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ContributionConstraint
                  ])
                  | doc m%"
                  List of constraints (filters) that should be applied to the availability of this contribution
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of the contribution/type
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  Fully qualified identifier of the contribution/type
                  "%,
                includes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Includes is a set of contributions that should have this contribution included in their targets list.
                  "%
                  | optional,
                properties
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  Properties/attributes of this contribution
                  "%
                  | optional,
                restrictedTo
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of demanded claims in order for the user to see this contribution (like anonymous, public, member...).
                  "%
                  | optional,
                targets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The ids of the contribution(s) that this contribution targets. (parent contributions)
                  "%,
                type
                  | String
                  | doc m%"
                  Id of the Contribution Type
                  "%,
                visibleTo
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  VisibleTo can be used to restrict whom can reference a given contribution/type. This value should be a list of publishers or extensions access is restricted too.  Examples: "ms" - Means only the "ms" publisher can reference this. "ms.vss-web" - Means only the "vss-web" extension from the "ms" publisher can reference this.
                  "%
                  | optional,
                ..
              },
          ContributionConstraint
            | doc m%"
            Specifies a constraint that can be used to dynamically include/exclude a given contribution
            "%
            = {
                group
                  | Number
                  | doc m%"
                  An optional property that can be specified to group constraints together. All constraints within a group are AND'd together (all must be evaluate to True in order for the contribution to be included). Different groups of constraints are OR'd (only one group needs to evaluate to True for the contribution to be included).
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  Fully qualified identifier of a shared constraint
                  "%
                  | optional,
                inverse
                  | Bool
                  | doc m%"
                  If true, negate the result of the filter (include the contribution if the applied filter returns false instead of true)
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the IContributionFilter plugin
                  "%
                  | optional,
                properties
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  Properties that are fed to the contribution filter class
                  "%
                  | optional,
                relationships
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Constraints can be optionally be applied to one or more of the relationships defined in the contribution. If no relationships are defined then all relationships are associated with the constraint. This means the default behaviour will eliminate the contribution from the tree completely if the constraint is applied.
                  "%
                  | optional,
                ..
              },
          ContributionLicensingBehaviorType
            | doc m%"
            Represents different ways of including contributions based on licensing
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ContributionLicensingBehaviorType,
          ContributionPropertyDescription
            | doc m%"
            Description about a property of a contribution type
            "%
            = {
                description
                  | String
                  | doc m%"
                  Description of the property
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the property
                  "%
                  | optional,
                required
                  | Bool
                  | doc m%"
                  True if this property is required
                  "%
                  | optional,
                type
                  | definitions.contract.ContributionPropertyType
                  | doc m%"
                  The type of value used for this property
                  "%
                  | optional,
                ..
              },
          ContributionPropertyType
            | doc m%"
            The type of value used for a property
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ContributionPropertyType,
          ContributionType
            | doc m%"
            A contribution type, given by a json schema
            "%
            = {
                description
                  | String
                  | doc m%"
                  Description of the contribution/type
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  Fully qualified identifier of the contribution/type
                  "%
                  | optional,
                indexed
                  | Bool
                  | doc m%"
                  Controls whether or not contributions of this type have the type indexed for queries. This allows clients to find all extensions that have a contribution of this type.  NOTE: Only TrustedPartners are allowed to specify indexed contribution types.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Friendly name of the contribution/type
                  "%
                  | optional,
                properties
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.ContributionPropertyDescription
                  ])
                  | doc m%"
                  Describes the allowed properties for this contribution type
                  "%
                  | optional,
                visibleTo
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  VisibleTo can be used to restrict whom can reference a given contribution/type. This value should be a list of publishers or extensions access is restricted too.  Examples: "ms" - Means only the "ms" publisher can reference this. "ms.vss-web" - Means only the "vss-web" extension from the "ms" publisher can reference this.
                  "%
                  | optional,
                ..
              },
          ExtensionEventCallback
            | doc m%"
            Base class for an event callback for an extension
            "%
            = {
                uri
                  | String
                  | doc m%"
                  The uri of the endpoint that is hit when an event occurs
                  "%
                  | optional,
                ..
              },
          ExtensionEventCallbackCollection
            | doc m%"
            Collection of event callbacks - endpoints called when particular extension events occur.
            "%
            = {
                postDisable
                  | definitions.contract.ExtensionEventCallback
                  | doc m%"
                  Optional.  Defines an endpoint that gets called via a POST request to notify that an extension disable has occurred.
                  "%
                  | optional,
                postEnable
                  | definitions.contract.ExtensionEventCallback
                  | doc m%"
                  Optional.  Defines an endpoint that gets called via a POST request to notify that an extension enable has occurred.
                  "%
                  | optional,
                postInstall
                  | definitions.contract.ExtensionEventCallback
                  | doc m%"
                  Optional.  Defines an endpoint that gets called via a POST request to notify that an extension install has completed.
                  "%
                  | optional,
                postUninstall
                  | definitions.contract.ExtensionEventCallback
                  | doc m%"
                  Optional.  Defines an endpoint that gets called via a POST request to notify that an extension uninstall has occurred.
                  "%
                  | optional,
                postUpdate
                  | definitions.contract.ExtensionEventCallback
                  | doc m%"
                  Optional.  Defines an endpoint that gets called via a POST request to notify that an extension update has occurred.
                  "%
                  | optional,
                preInstall
                  | definitions.contract.ExtensionEventCallback
                  | doc m%"
                  Optional.  Defines an endpoint that gets called via a POST request to notify that an extension install is about to occur.  Response indicates whether to proceed or abort.
                  "%
                  | optional,
                versionCheck
                  | definitions.contract.ExtensionEventCallback
                  | doc m%"
                  For multi-version extensions, defines an endpoint that gets called via an OPTIONS request to determine the particular version of the extension to be used
                  "%
                  | optional,
                ..
              },
          ExtensionLicensing
            | doc m%"
            How an extension should handle including contributions based on licensing
            "%
            = {
                overrides
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.LicensingOverride
                  ])
                  | doc m%"
                  A list of contributions which deviate from the default licensing behavior
                  "%
                  | optional,
                ..
              },
          File = {
                addressable
                  | Bool
                  | doc m%"
                  (optional) Set to true if you want your file to be URL-addressable. Defaults to false.
                  "%
                  | optional,
                assetType
                  | String
                  | doc m%"
                  (optional) Specify the value of the Type attribute of the asset entry in the VSIX manifest. Can also be an array of strings, in which case multiple asset entries get added for this file. Defaults to the packagePath.
                  "%
                  | optional,
                contentType
                  | String
                  | doc m%"
                  (optional) MIME type of the file. Defaults to a best guess based on the file extension and OS settings.
                  "%
                  | optional,
                lang
                  | String
                  | doc m%"
                  (optional) Language of this asset. Localized files are served based on the Accept-Language header. Leave blank to signify this file is in the default (or fallback) language. Localized versions of the same file should have the same assetType.
                  "%
                  | optional,
                packagePath
                  | String
                  | doc m%"
                  (optional) Path to the resource within the package. Defaults to the relative path on disk from your root directory.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path to resource on disk, which can be relative to your root directory.
                  "%,
                ..
              },
          LicensingOverride
            | doc m%"
            Maps a contribution to a licensing behavior
            "%
            = {
                behavior
                  | definitions.contract.ContributionLicensingBehaviorType
                  | doc m%"
                  How the inclusion of this contribution should change based on licensing
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  Fully qualified contribution id which we want to define licensing behavior for
                  "%
                  | optional,
                ..
              },
          Link = {
                uri
                  | String
                  | doc m%"
                  The absolute URL of the link.
                  "%
                  | optional,
                ..
              },
          Target = {
                id
                  | std.enum.TagOrString
                  | [|
                    '"Microsoft.TeamFoundation.Server.Integration",
                    '"Microsoft.VisualStudio.Services.Integration",
                    '"Microsoft.TeamFoundation.Server",
                    '"Microsoft.VisualStudio.Services"
                  |],
                ..
              },
        },
    predicate = {
          Badge
            | doc m%"
            A link to external metadata badge.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "uri" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  href = predicates.isType '"String",
                  uri = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Content
            | doc m%"
            A content file that describes the extension to users.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                { path = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          Contribution
            | doc m%"
            An individual contribution made by an extension
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id", "targets", "type" ],
                predicates.records.record
                {
                  constraints = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ContributionConstraint
                      ],
                  description = predicates.isType '"String",
                  id = predicates.isType '"String",
                  includes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  properties = predicates.always,
                  restrictedTo = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  targets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  type = predicates.isType '"String",
                  visibleTo = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          ContributionConstraint
            | doc m%"
            Specifies a constraint that can be used to dynamically include/exclude a given contribution
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  group = predicates.isType '"Number",
                  id = predicates.isType '"String",
                  inverse = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  properties = predicates.always,
                  relationships = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          ContributionLicensingBehaviorType
            | doc m%"
            Represents different ways of including contributions based on licensing
            "%
            = predicates.allOf
              [ predicates.isType '"Number", predicates.enum [ 0, 1, 2 ] ],
          ContributionPropertyDescription
            | doc m%"
            Description about a property of a contribution type
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  required = predicates.isType '"Bool",
                  type = definitions.predicate.ContributionPropertyType,
                }
                {  }
                true
                predicates.always
              ],
          ContributionPropertyType
            | doc m%"
            The type of value used for a property
            "%
            = predicates.allOf
              [
                predicates.isType '"Number",
                predicates.enum [ 0, 1, 128, 16, 2, 256, 32, 4, 512, 64, 8 ]
              ],
          ContributionType
            | doc m%"
            A contribution type, given by a json schema
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  id = predicates.isType '"String",
                  indexed = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.ContributionPropertyDescription
                      ],
                  visibleTo = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          ExtensionEventCallback
            | doc m%"
            Base class for an event callback for an extension
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record { uri = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          ExtensionEventCallbackCollection
            | doc m%"
            Collection of event callbacks - endpoints called when particular extension events occur.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  postDisable = definitions.predicate.ExtensionEventCallback,
                  postEnable = definitions.predicate.ExtensionEventCallback,
                  postInstall = definitions.predicate.ExtensionEventCallback,
                  postUninstall = definitions.predicate.ExtensionEventCallback,
                  postUpdate = definitions.predicate.ExtensionEventCallback,
                  preInstall = definitions.predicate.ExtensionEventCallback,
                  versionCheck = definitions.predicate.ExtensionEventCallback,
                }
                {  }
                true
                predicates.always
              ],
          ExtensionLicensing
            | doc m%"
            How an extension should handle including contributions based on licensing
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  overrides = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.LicensingOverride
                      ],
                }
                {  }
                true
                predicates.always
              ],
          File = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  addressable = predicates.isType '"Bool",
                  assetType = predicates.isType '"String",
                  contentType = predicates.isType '"String",
                  lang = predicates.isType '"String",
                  packagePath = predicates.isType '"String",
                  path = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          LicensingOverride
            | doc m%"
            Maps a contribution to a licensing behavior
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  behavior =
                    definitions.predicate.ContributionLicensingBehaviorType,
                  id = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Link = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record { uri = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          Target = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Microsoft.VisualStudio.Services",
                          "Microsoft.TeamFoundation.Server",
                          "Microsoft.VisualStudio.Services.Integration",
                          "Microsoft.TeamFoundation.Server.Integration"
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  badges
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.Badge
    ])
    | doc m%"
    Array of links to external metadata badges like TravisCI, Appveyor, and so on, from the approved badges sites.
    "%
    | optional,
  baseUri
    | String
    | doc m%"
    Uri used as base for other relative uri's defined in extension
    "%
    | optional,
  branding
    | {
      color
        | String
        | doc m%"
        Primary color of the extension or publisher; can be a hex (#ff00ff), RGB (rgb(100,200,50)), or supported HTML color names (blue).
        "%
        | optional,
      theme
        | std.enum.TagOrString
        | [| 'light, 'dark |]
        | doc m%"
        Complements the color; use dark for dark branding colors, or light for lighter branding colors.
        "%
        | optional,
      ..
    }
    | doc m%"
    Dictionary of brand-related properties.
    "%
    | optional,
  categories
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType '"String",
        predicates.enum
        [
          "Azure Repos",
          "Azure Boards",
          "Azure Pipelines",
          "Azure Test Plans",
          "Azure Artifacts"
        ]
      ]),
      predicates.arrays.minItems 1
    ])
    | doc m%"
    Array of strings representing the categories your extension belongs to. At least one category must be provided and there's no limit to how many categories you may include. Valid values: Azure Repos, Azure Boards, Azure Pipelines, Azure Test Plans, and Azure Artifacts.
    "%
    | optional,
  constraints
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.ContributionConstraint
    ])
    | doc m%"
    List of shared constraints defined by this extension
    "%
    | optional,
  content
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record { details = definitions.predicate.Content, }
      {  }
      true
      definitions.predicate.Content
    ])
    | doc m%"
    Dictionary of content files that describe your extension to users.
    "%
    | optional,
  contributionTypes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.ContributionType
    ])
    | doc m%"
    List of contribution types defined by this extension
    "%
    | optional,
  contributions
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.Contribution
    ])
    | doc m%"
    List of contributions made by this extension
    "%
    | optional,
  demands
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of explicit demands required by this extension
    "%
    | optional,
  description
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.maxLength 200 ])
    | doc m%"
    A few sentences describing the extensions. Limited to 200 characters.
    "%
    | optional,
  eventCallbacks
    | definitions.contract.ExtensionEventCallbackCollection
    | doc m%"
    Collection of endpoints that get called when particular extension events occur
    "%
    | optional,
  fallbackBaseUri
    | String
    | doc m%"
    Secondary location that can be used as base for other relative uri's defined in extension
    "%
    | optional,
  files
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.File
    ])
    | doc m%"
    The files section is where you reference any files you wish to include in your extension.
    "%
    | optional,
  icons
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record { "default" = predicates.isType '"String", }
      {  }
      true
      (predicates.isType '"String")
    ])
    | doc m%"
    Dictionary of icons representing the extension.
    "%
    | optional,
  id
    | String
    | doc m%"
    The extension's identifier.
    "%
    | optional,
  language
    | String
    | doc m%"
    Language Culture Name set by the Gallery
    "%
    | optional,
  licensing
    | definitions.contract.ExtensionLicensing
    | doc m%"
    How this extension behaves with respect to licensing
    "%
    | optional,
  links
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record
      {
        getstarted = definitions.predicate.Link,
        learn = definitions.predicate.Link,
        license = definitions.predicate.Link,
        privacypolicy = definitions.predicate.Link,
        support = definitions.predicate.Link,
      }
      {  }
      true
      definitions.predicate.Link
    ])
    | doc m%"
    Dictionary of links that help users learn more about your extension, get support, and move.
    "%
    | optional,
  manifestVersion
    | Number
    | doc m%"
    Version of the extension manifest format/content. Should be 1.
    "%
    | optional,
  name
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.maxLength 200 ])
    | doc m%"
    A short, human-readable name of the extension. Limited to 200 characters.
    "%
    | optional,
  publisher
    | String
    | doc m%"
    The identifier of the publisher. This identifier must match the identifier the extension is published under.
    "%
    | optional,
  repository
    | {
      type
        | String
        | doc m%"
        Type of repository. Example: git.
        "%
        | optional,
      uri
        | String
        | doc m%"
        Absolute URL of the repository.
        "%
        | optional,
      ..
    }
    | doc m%"
    Dictionary of properties describing the source code repository for the extension.
    "%
    | optional,
  restrictedTo
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Default user claims applied to all contributions (except the ones which have been specified restrictedTo explicitly) to control the visibility of a contribution.
    "%
    | optional,
  scopes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of all oauth scopes required by this extension
    "%
    | optional,
  screenshots
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.Content
    ])
    | doc m%"
    Array of images that couldn't be included in your content.
    "%
    | optional,
  serviceInstanceType
    | String
    | doc m%"
    The ServiceInstanceType(Guid) of the VSTS service that must be available to an account in order for the extension to be installed
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
    Array of string tags to help users find your extension.
    "%
    | optional,
  targets
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.Target,
      predicates.arrays.minItems 1
    ])
    | doc m%"
    The products and services supported by your integration or extension.
    "%
    | optional,
  version
    | String
    | doc m%"
    A string specifying the version of an extension. Should be in the format major.minor.patch.
    "%
    | optional,
  ..
}