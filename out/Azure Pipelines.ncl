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
          any = predicates.contract_from_predicate definitions.predicate.any,
          any_allowExpressions = predicates.contract_from_predicate
              definitions.predicate.any_allowExpressions,
          boolean = predicates.contract_from_predicate
              definitions.predicate.boolean,
          branchFilter
            | doc m%"
            branch name or prefix filter
            "%
            = predicates.contract_from_predicate
              definitions.predicate.branchFilter,
          branchFilterArray = predicates.contract_from_predicate
              definitions.predicate.branchFilterArray,
          buildResource = predicates.contract_from_predicate
              definitions.predicate.buildResource,
          buildResourceTrigger = predicates.contract_from_predicate
              definitions.predicate.buildResourceTrigger,
          buildResources = predicates.contract_from_predicate
              definitions.predicate.buildResources,
          canaryDeploymentIncrements = predicates.contract_from_predicate
              definitions.predicate.canaryDeploymentIncrements,
          canaryDeploymentStrategy = {
                deploy
                  | definitions.contract.deployHook
                  | doc m%"
                  Deploy hook for canary deployment strategy
                  "%
                  | optional,
                increments
                  | definitions.contract.canaryDeploymentIncrements
                  | doc m%"
                  Maximum batch size for deployment
                  "%
                  | optional,
                on
                  | definitions.contract.onSuccessOrFailureHook
                  | doc m%"
                  On success or failure hook for canary deployment strategy
                  "%
                  | optional,
                postRouteTraffic
                  | definitions.contract.postRouteTrafficHook
                  | doc m%"
                  Post route traffic hook for canary deployment strategy
                  "%
                  | optional,
                preDeploy
                  | definitions.contract.preDeployHook
                  | doc m%"
                  Pre deploy hook for canary deployment strategy
                  "%
                  | optional,
                routeTraffic
                  | definitions.contract.routeTrafficHook
                  | doc m%"
                  Route traffic hook for canary deployment strategy
                  "%
                  | optional,
              },
          containerArtifactType = predicates.contract_from_predicate
              definitions.predicate.containerArtifactType,
          containerBase = {
                endpoint
                  | definitions.contract.string_allowExpressions
                  | doc m%"
                  ID of the service endpoint connecting to a private container registry
                  "%
                  | optional,
                env
                  | definitions.contract.mappingOfStringString
                  | doc m%"
                  Variables to map into the container's environment
                  "%
                  | optional,
                image
                  | definitions.contract.string
                  | doc m%"
                  Container image tag
                  "%,
                mapDockerSocket
                  | definitions.contract.boolean
                  | doc m%"
                  Set this flag to false to force the agent not to setup the /var/run/docker.sock volume on container jobs
                  "%
                  | optional,
                mountReadOnly | definitions.contract.readOnlyMounts | optional,
                options
                  | definitions.contract.string_allowExpressions
                  | doc m%"
                  Options to pass into container host
                  "%
                  | optional,
                ports
                  | definitions.contract.sequenceOfString_allowExpressions
                  | optional,
                volumes
                  | definitions.contract.sequenceOfString_allowExpressions
                  | optional,
              },
          containerResource = predicates.contract_from_predicate
              definitions.predicate.containerResource,
          containerResourceTrigger = predicates.contract_from_predicate
              definitions.predicate.containerResourceTrigger,
          containerResources = predicates.contract_from_predicate
              definitions.predicate.containerResources,
          deployHook = {
                pool
                  | definitions.contract.pool
                  | doc m%"
                  Pool where deploy steps will run
                  "%
                  | optional,
                steps
                  | definitions.contract.steps
                  | doc m%"
                  A list of steps to run
                  "%
                  | optional,
              },
          deploymentEnvironment
            | doc m%"
            Environment details
            "%
            = predicates.contract_from_predicate
              definitions.predicate.deploymentEnvironment,
          deploymentStrategy = predicates.contract_from_predicate
              definitions.predicate.deploymentStrategy,
          explicitResources = {
                pools
                  | definitions.contract.sequenceOfNonEmptyString
                  | doc m%"
                  Pool references
                  "%
                  | optional,
                repositories
                  | definitions.contract.sequenceOfNonEmptyString
                  | doc m%"
                  Repository references
                  "%
                  | optional,
              },
          extends = {
                parameters
                  | definitions.contract.mapping
                  | doc m%"
                  Parameters used in the extend
                  "%
                  | optional,
                template | definitions.contract.nonEmptyString | optional,
              },
          extendsParameters = predicates.contract_from_predicate
              definitions.predicate.extendsParameters,
          extendsTemplate = predicates.contract_from_predicate
              definitions.predicate.extendsTemplate,
          extendsTemplateBase = {
                parameters | definitions.contract.extendsParameters | optional,
                resources | definitions.contract.resources | optional,
                trigger | definitions.contract.trigger | optional,
                variables | definitions.contract.variables | optional,
              },
          includeExcludeFilters = {
                exclude | definitions.contract.branchFilterArray | optional,
                include | definitions.contract.branchFilterArray | optional,
              },
          includeExcludeStringFilters = predicates.contract_from_predicate
              definitions.predicate.includeExcludeStringFilters,
          job = predicates.contract_from_predicate definitions.predicate.job,
          jobContainer = predicates.contract_from_predicate
              definitions.predicate.jobContainer,
          jobContinueOnError = String,
          jobDecoratorSteps = {
                steps
                  | definitions.contract.tasks
                  | doc m%"
                  A list of steps to run in this job
                  "%
                  | optional,
              },
          jobDependsOn = predicates.contract_from_predicate
              definitions.predicate.jobDependsOn,
          jobMatrix = predicates.contract_from_predicate
              definitions.predicate.jobMatrix,
          jobServices = {  .. },
          jobStrategy = predicates.contract_from_predicate
              definitions.predicate.jobStrategy,
          jobWorkspace = {
                clean
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.enum [ "outputs", "resources", "all" ],
                    definitions.predicate.string
                  ])
                  | doc m%"
                  Which parts of the workspace should be scorched before fetching
                  "%
                  | optional,
              },
          jobs = predicates.contract_from_predicate definitions.predicate.jobs,
          jobsTemplate = predicates.contract_from_predicate
              definitions.predicate.jobsTemplate,
          legacyRepoResourceAlias = predicates.contract_from_predicate
              definitions.predicate.legacyRepoResourceAlias,
          legacyResource = predicates.contract_from_predicate
              definitions.predicate.legacyResource,
          lockBehavior = predicates.contract_from_predicate
              definitions.predicate.lockBehavior,
          mapping = {  .. },
          mappingOfStringString = {  .. },
          matrixProperties
            | doc m%"
            Variable-value pair to pass in this matrix instance
            "%
            = {  .. },
          nonEmptyString = String,
          onFailureHook = {
                pool
                  | definitions.contract.pool
                  | doc m%"
                  Pool where post on failure steps will run
                  "%
                  | optional,
                steps
                  | definitions.contract.steps
                  | doc m%"
                  A list of steps to run
                  "%
                  | optional,
              },
          onSuccessHook = {
                pool
                  | definitions.contract.pool
                  | doc m%"
                  Pool where on success steps will run
                  "%
                  | optional,
                steps
                  | definitions.contract.steps
                  | doc m%"
                  A list of steps to run
                  "%
                  | optional,
              },
          onSuccessOrFailureHook = {
                failure
                  | definitions.contract.onFailureHook
                  | doc m%"
                  Runs on failure of any step
                  "%
                  | optional,
                success
                  | definitions.contract.onSuccessHook
                  | doc m%"
                  Runs on success of all of the steps
                  "%
                  | optional,
              },
          packageResource = predicates.contract_from_predicate
              definitions.predicate.packageResource,
          packageResourceTrigger = predicates.contract_from_predicate
              definitions.predicate.packageResourceTrigger,
          packageResources = predicates.contract_from_predicate
              definitions.predicate.packageResources,
          parametersTemplate = predicates.contract_from_predicate
              definitions.predicate.parametersTemplate,
          phase = predicates.contract_from_predicate
              definitions.predicate.phase,
          phaseQueueTarget
            | doc m%"
            Queue details
            "%
            = predicates.contract_from_predicate
              definitions.predicate.phaseQueueTarget,
          phaseServerTarget = predicates.contract_from_predicate
              definitions.predicate.phaseServerTarget,
          phaseTargetDemands = predicates.contract_from_predicate
              definitions.predicate.phaseTargetDemands,
          phaseTargetMatrix
            | doc m%"
            List of permutations of variable values to run
            "%
            = predicates.contract_from_predicate
              definitions.predicate.phaseTargetMatrix,
          phaseTargetWorkspace = {
                clean
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.enum [ "outputs", "resources", "all" ],
                    definitions.predicate.string
                  ])
                  | doc m%"
                  Scorch the repo before fetching?
                  "%
                  | optional,
              },
          phases = predicates.contract_from_predicate
              definitions.predicate.phases,
          pipeline = predicates.contract_from_predicate
              definitions.predicate.pipeline,
          pipelineAnyBase = {
                appendCommitMessageToRunName
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Append the commit message to the build number
                  "%
                  | optional,
                container
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Container resource name
                  "%
                  | optional,
                continueOnError
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Continue running even on failure?
                  "%
                  | optional,
                extends
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Extends a template
                  "%
                  | optional,
                jobs
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Jobs which make up the pipeline
                  "%
                  | optional,
                lockBehavior
                  | definitions.contract.lockBehavior
                  | doc m%"
                  Behavior lock requests from this stage should exhibit in relation to other exclusive lock requests
                  "%
                  | optional,
                name
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pipeline name
                  "%
                  | optional,
                parameters
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pipeline template parameters
                  "%
                  | optional,
                phases
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  Phases which make up the pipeline
                  "%
                  | optional,
                pool
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pool where this job will run
                  "%
                  | optional,
                pr
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pull request triggers
                  "%
                  | optional,
                queue
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  Queue where this phase will run
                  "%
                  | optional,
                resources
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Containers and repositories used in the build
                  "%
                  | optional,
                schedules
                  | definitions.contract.any_allowExpressions
                  | optional,
                server
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  True if this is an agent-less phase (runs on server)
                  "%
                  | optional,
                services | definitions.contract.any_allowExpressions | optional,
                stages | definitions.contract.any_allowExpressions | optional,
                steps
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  A list of steps to run
                  "%
                  | optional,
                strategy
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Execution strategy for the job
                  "%
                  | optional,
                trigger
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Continuous integration triggers
                  "%
                  | optional,
                variables
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Variables for the entire pipeline
                  "%
                  | optional,
                workspace
                  | definitions.contract.any_allowExpressions
                  | optional,
              },
          pipelineBase = {
                appendCommitMessageToRunName
                  | definitions.contract.boolean
                  | doc m%"
                  Append the commit message to the build number
                  "%
                  | optional,
                lockBehavior
                  | definitions.contract.lockBehavior
                  | doc m%"
                  Behavior lock requests from this stage should exhibit in relation to other exclusive lock requests
                  "%
                  | optional,
                name
                  | definitions.contract.string_allowExpressions
                  | doc m%"
                  Pipeline name
                  "%
                  | optional,
                parameters
                  | definitions.contract.pipelineTemplateParameters
                  | doc m%"
                  Pipeline template parameters
                  "%
                  | optional,
                pr
                  | definitions.contract.pr
                  | doc m%"
                  Pull request triggers
                  "%
                  | optional,
                resources
                  | definitions.contract.resources
                  | doc m%"
                  Containers and repositories used in the build
                  "%
                  | optional,
                schedules | definitions.contract.schedules | optional,
                trigger
                  | definitions.contract.trigger
                  | doc m%"
                  Continuous integration triggers
                  "%
                  | optional,
                variables
                  | definitions.contract.variables
                  | doc m%"
                  Variables for this pipeline
                  "%
                  | optional,
              },
          pipelinePR = {
                appendCommitMessageToRunName
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Append the commit message to the build number
                  "%
                  | optional,
                container
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Container resource name
                  "%
                  | optional,
                continueOnError
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Continue running even on failure?
                  "%
                  | optional,
                extends
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Extends a template
                  "%
                  | optional,
                jobs
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Jobs which make up the pipeline
                  "%
                  | optional,
                lockBehavior
                  | definitions.contract.lockBehavior
                  | doc m%"
                  Behavior lock requests from this stage should exhibit in relation to other exclusive lock requests
                  "%
                  | optional,
                name
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pipeline name
                  "%
                  | optional,
                parameters
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pipeline template parameters
                  "%
                  | optional,
                phases
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  Phases which make up the pipeline
                  "%
                  | optional,
                pool
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pool where this job will run
                  "%
                  | optional,
                pr
                  | definitions.contract.pr
                  | doc m%"
                  Pull request triggers
                  "%
                  | optional,
                queue
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  Queue where this phase will run
                  "%
                  | optional,
                resources
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Containers and repositories used in the build
                  "%
                  | optional,
                schedules
                  | definitions.contract.any_allowExpressions
                  | optional,
                server
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  True if this is an agent-less phase (runs on server)
                  "%
                  | optional,
                services | definitions.contract.any_allowExpressions | optional,
                stages | definitions.contract.any_allowExpressions | optional,
                steps
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  A list of steps to run
                  "%
                  | optional,
                strategy
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Execution strategy for the job
                  "%
                  | optional,
                trigger
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Continuous integration triggers
                  "%
                  | optional,
                variables
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Variables for the entire pipeline
                  "%
                  | optional,
                workspace
                  | definitions.contract.any_allowExpressions
                  | optional,
              },
          pipelineParameters = {
                appendCommitMessageToRunName
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Append the commit message to the build number
                  "%
                  | optional,
                container
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Container resource name
                  "%
                  | optional,
                continueOnError
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Continue running even on failure?
                  "%
                  | optional,
                extends
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Extends a template
                  "%
                  | optional,
                jobs
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Jobs which make up the pipeline
                  "%
                  | optional,
                lockBehavior
                  | definitions.contract.lockBehavior
                  | doc m%"
                  Behavior lock requests from this stage should exhibit in relation to other exclusive lock requests
                  "%
                  | optional,
                name
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pipeline name
                  "%
                  | optional,
                parameters
                  | definitions.contract.pipelineTemplateParameters
                  | doc m%"
                  Pipeline template parameters
                  "%
                  | optional,
                phases
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  Phases which make up the pipeline
                  "%
                  | optional,
                pool
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pool where this job will run
                  "%
                  | optional,
                pr
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pull request triggers
                  "%
                  | optional,
                queue
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  Queue where this phase will run
                  "%
                  | optional,
                resources
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Containers and repositories used in the build
                  "%
                  | optional,
                schedules
                  | definitions.contract.any_allowExpressions
                  | optional,
                server
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  True if this is an agent-less phase (runs on server)
                  "%
                  | optional,
                services | definitions.contract.any_allowExpressions | optional,
                stages | definitions.contract.any_allowExpressions | optional,
                steps
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  A list of steps to run
                  "%
                  | optional,
                strategy
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Execution strategy for the job
                  "%
                  | optional,
                trigger
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Continuous integration triggers
                  "%
                  | optional,
                variables
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Variables for the entire pipeline
                  "%
                  | optional,
                workspace
                  | definitions.contract.any_allowExpressions
                  | optional,
              },
          pipelineResource = predicates.contract_from_predicate
              definitions.predicate.pipelineResource,
          pipelineResourceTrigger = predicates.contract_from_predicate
              definitions.predicate.pipelineResourceTrigger,
          pipelineResources = predicates.contract_from_predicate
              definitions.predicate.pipelineResources,
          pipelineSchedules = {
                appendCommitMessageToRunName
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Append the commit message to the build number
                  "%
                  | optional,
                container
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Container resource name
                  "%
                  | optional,
                continueOnError
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Continue running even on failure?
                  "%
                  | optional,
                extends
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Extends a template
                  "%
                  | optional,
                jobs
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Jobs which make up the pipeline
                  "%
                  | optional,
                lockBehavior
                  | definitions.contract.lockBehavior
                  | doc m%"
                  Behavior lock requests from this stage should exhibit in relation to other exclusive lock requests
                  "%
                  | optional,
                name
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pipeline name
                  "%
                  | optional,
                parameters
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pipeline template parameters
                  "%
                  | optional,
                phases
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  Phases which make up the pipeline
                  "%
                  | optional,
                pool
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pool where this job will run
                  "%
                  | optional,
                pr
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pull request triggers
                  "%
                  | optional,
                queue
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  Queue where this phase will run
                  "%
                  | optional,
                resources
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Containers and repositories used in the build
                  "%
                  | optional,
                schedules | definitions.contract.schedules | optional,
                server
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  True if this is an agent-less phase (runs on server)
                  "%
                  | optional,
                services | definitions.contract.any_allowExpressions | optional,
                stages | definitions.contract.any_allowExpressions | optional,
                steps
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  A list of steps to run
                  "%
                  | optional,
                strategy
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Execution strategy for the job
                  "%
                  | optional,
                trigger
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Continuous integration triggers
                  "%
                  | optional,
                variables
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Variables for the entire pipeline
                  "%
                  | optional,
                workspace
                  | definitions.contract.any_allowExpressions
                  | optional,
              },
          pipelineTemplateParameter = predicates.contract_from_predicate
              definitions.predicate.pipelineTemplateParameter,
          pipelineTemplateParameterType = predicates.contract_from_predicate
              definitions.predicate.pipelineTemplateParameterType,
          pipelineTemplateParameters = predicates.contract_from_predicate
              definitions.predicate.pipelineTemplateParameters,
          pipelineTrigger = {
                appendCommitMessageToRunName
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Append the commit message to the build number
                  "%
                  | optional,
                container
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Container resource name
                  "%
                  | optional,
                continueOnError
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Continue running even on failure?
                  "%
                  | optional,
                extends
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Extends a template
                  "%
                  | optional,
                jobs
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Jobs which make up the pipeline
                  "%
                  | optional,
                lockBehavior
                  | definitions.contract.lockBehavior
                  | doc m%"
                  Behavior lock requests from this stage should exhibit in relation to other exclusive lock requests
                  "%
                  | optional,
                name
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pipeline name
                  "%
                  | optional,
                parameters
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pipeline template parameters
                  "%
                  | optional,
                phases
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  Phases which make up the pipeline
                  "%
                  | optional,
                pool
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pool where this job will run
                  "%
                  | optional,
                pr
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Pull request triggers
                  "%
                  | optional,
                queue
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  Queue where this phase will run
                  "%
                  | optional,
                resources
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Containers and repositories used in the build
                  "%
                  | optional,
                schedules
                  | definitions.contract.any_allowExpressions
                  | optional,
                server
                  | predicates.contract_from_predicate
                  definitions.predicate.any_allowExpressions
                  | doc m%"
                  True if this is an agent-less phase (runs on server)
                  "%
                  | optional,
                services | definitions.contract.any_allowExpressions | optional,
                stages | definitions.contract.any_allowExpressions | optional,
                steps
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  A list of steps to run
                  "%
                  | optional,
                strategy
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Execution strategy for the job
                  "%
                  | optional,
                trigger
                  | definitions.contract.trigger
                  | doc m%"
                  Continuous integration triggers
                  "%
                  | optional,
                variables
                  | definitions.contract.any_allowExpressions
                  | doc m%"
                  Variables for the entire pipeline
                  "%
                  | optional,
                workspace
                  | definitions.contract.any_allowExpressions
                  | optional,
              },
          pool
            | doc m%"
            Pool details
            "%
            = predicates.contract_from_predicate definitions.predicate.pool,
          poolDemands = predicates.contract_from_predicate
              definitions.predicate.poolDemands,
          postRouteTrafficHook = {
                pool
                  | definitions.contract.pool
                  | doc m%"
                  Pool where post route traffic steps will run
                  "%
                  | optional,
                steps
                  | definitions.contract.steps
                  | doc m%"
                  A list of steps to run
                  "%
                  | optional,
              },
          pr = predicates.contract_from_predicate definitions.predicate.pr,
          preDeployHook = {
                pool
                  | definitions.contract.pool
                  | doc m%"
                  Pool where pre deploy steps will run
                  "%
                  | optional,
                steps
                  | definitions.contract.steps
                  | doc m%"
                  A list of steps to run
                  "%
                  | optional,
              },
          readOnlyMounts = {
                externals
                  | definitions.contract.boolean
                  | doc m%"
                  Mount the externals directory as readonly
                  "%
                  | optional,
                tasks
                  | definitions.contract.boolean
                  | doc m%"
                  Mount the tasks directory as readonly
                  "%
                  | optional,
                tools
                  | definitions.contract.boolean
                  | doc m%"
                  Mount the tools directory as readonly
                  "%
                  | optional,
                work
                  | definitions.contract.boolean
                  | doc m%"
                  Mount the work directory as readonly
                  "%
                  | optional,
              },
          referenceName = predicates.contract_from_predicate
              definitions.predicate.referenceName,
          repositoryCheckoutOptions = {
                clean
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.enum [ "true", "false" ],
                    definitions.predicate.string
                  ])
                  | doc m%"
                  Scorch the repo before fetching?
                  "%
                  | optional,
                fetchDepth
                  | definitions.contract.string
                  | doc m%"
                  Depth of Git graph to fetch
                  "%
                  | optional,
                fetchTags
                  | definitions.contract.string
                  | doc m%"
                  Fetch tags?
                  "%
                  | optional,
                lfs
                  | definitions.contract.string
                  | doc m%"
                  Fetch and checkout Git LFS objects?
                  "%
                  | optional,
                persistCredentials
                  | definitions.contract.string
                  | doc m%"
                  Keep credentials available for later use?
                  "%
                  | optional,
                submodules
                  | definitions.contract.string
                  | doc m%"
                  Fetch and checkout submodules?
                  "%
                  | optional,
              },
          repositoryResource = predicates.contract_from_predicate
              definitions.predicate.repositoryResource,
          repositoryResources = predicates.contract_from_predicate
              definitions.predicate.repositoryResources,
          resources = predicates.contract_from_predicate
              definitions.predicate.resources,
          rollingDeploymentStrategy = {
                deploy
                  | definitions.contract.deployHook
                  | doc m%"
                  Deploy hook for rolling deployment strategy
                  "%
                  | optional,
                maxParallel
                  | definitions.contract.nonEmptyString
                  | doc m%"
                  Maximum number of jobs running in parallel
                  "%
                  | optional,
                on
                  | definitions.contract.onSuccessOrFailureHook
                  | doc m%"
                  On success or failure hook for rolling deployment strategy
                  "%
                  | optional,
                postRouteTraffic
                  | definitions.contract.postRouteTrafficHook
                  | doc m%"
                  Post route traffic hook for rolling deployment strategy
                  "%
                  | optional,
                preDeploy
                  | definitions.contract.preDeployHook
                  | doc m%"
                  Pre deploy hook for rolling deployment strategy
                  "%
                  | optional,
                routeTraffic
                  | definitions.contract.routeTrafficHook
                  | doc m%"
                  Route traffic hook for rolling deployment strategy
                  "%
                  | optional,
              },
          routeTrafficHook = {
                pool
                  | definitions.contract.pool
                  | doc m%"
                  Pool where route traffic steps will run
                  "%
                  | optional,
                steps
                  | definitions.contract.steps
                  | doc m%"
                  A list of steps to run
                  "%
                  | optional,
              },
          runOnceDeploymentStrategy = {
                deploy
                  | definitions.contract.deployHook
                  | doc m%"
                  Deploy hook for runOnce deployment strategy
                  "%
                  | optional,
                on
                  | definitions.contract.onSuccessOrFailureHook
                  | doc m%"
                  On success or failure hook for runOnce deployment strategy
                  "%
                  | optional,
                postRouteTraffic
                  | definitions.contract.postRouteTrafficHook
                  | doc m%"
                  Post route traffic hook for runOnce deployment strategy
                  "%
                  | optional,
                preDeploy
                  | definitions.contract.preDeployHook
                  | doc m%"
                  Pre deploy hook for runOnce deployment strategy
                  "%
                  | optional,
                routeTraffic
                  | definitions.contract.routeTrafficHook
                  | doc m%"
                  Route traffic hook for runOnce deployment strategy
                  "%
                  | optional,
              },
          schedule = predicates.contract_from_predicate
              definitions.predicate.schedule,
          schedules = predicates.contract_from_predicate
              definitions.predicate.schedules,
          sequence = predicates.contract_from_predicate
              definitions.predicate.sequence,
          sequenceOfNonEmptyString = predicates.contract_from_predicate
              definitions.predicate.sequenceOfNonEmptyString,
          sequenceOfString_allowExpressions = predicates.contract_from_predicate
              definitions.predicate.sequenceOfString_allowExpressions,
          stage = predicates.contract_from_predicate
              definitions.predicate.stage,
          stages = predicates.contract_from_predicate
              definitions.predicate.stages,
          stagesTemplate = {
                parameters | definitions.contract.templateParameters | optional,
                stages | definitions.contract.stages | optional,
              },
          step = predicates.contract_from_predicate definitions.predicate.step,
          stepTarget
            | doc m%"
            Step target
            "%
            = predicates.contract_from_predicate
              definitions.predicate.stepTarget,
          steps = predicates.contract_from_predicate
              definitions.predicate.steps,
          stepsTemplate = {
                parameters
                  | definitions.contract.templateParameters
                  | doc m%"
                  Step-specific parameters
                  "%
                  | optional,
                steps
                  | definitions.contract.steps
                  | doc m%"
                  A list of steps to run
                  "%
                  | optional,
              },
          string = String,
          string_allowExpressions = String,
          task = predicates.contract_from_predicate definitions.predicate.task,
          taskBase = {
                condition
                  | definitions.contract.string
                  | doc m%"
                  Evaluate this condition expression to determine whether to run this task
                  "%
                  | optional,
                continueOnError
                  | definitions.contract.boolean
                  | doc m%"
                  Continue running even on failure?
                  "%
                  | optional,
                displayName
                  | definitions.contract.string
                  | doc m%"
                  Human-readable name for the task
                  "%
                  | optional,
                enabled
                  | definitions.contract.boolean
                  | doc m%"
                  Run this task when the job runs?
                  "%
                  | optional,
                env
                  | definitions.contract.mappingOfStringString
                  | doc m%"
                  Variables to map into the process's environment
                  "%
                  | optional,
                name
                  | definitions.contract.referenceName
                  | doc m%"
                  ID of the step
                  "%
                  | optional,
                retryCountOnTaskFailure
                  | definitions.contract.string
                  | doc m%"
                  Number of retries if the task fails
                  "%
                  | optional,
                target
                  | definitions.contract.stepTarget
                  | doc m%"
                  Environment in which to run this task
                  "%
                  | optional,
                timeoutInMinutes
                  | definitions.contract.nonEmptyString
                  | doc m%"
                  Time to wait for this task to complete before the server kills it
                  "%
                  | optional,
              },
          tasks = predicates.contract_from_predicate
              definitions.predicate.tasks,
          templateContext = {  .. },
          templateParameter = predicates.contract_from_predicate
              definitions.predicate.templateParameter,
          templateParameterType = predicates.contract_from_predicate
              definitions.predicate.templateParameterType,
          templateParameters = predicates.contract_from_predicate
              definitions.predicate.templateParameters,
          trigger = predicates.contract_from_predicate
              definitions.predicate.trigger,
          triggerBranchFilter = predicates.contract_from_predicate
              definitions.predicate.triggerBranchFilter,
          variable = predicates.contract_from_predicate
              definitions.predicate.variable,
          variableRestrictions = predicates.contract_from_predicate
              definitions.predicate.variableRestrictions,
          variables = predicates.contract_from_predicate
              definitions.predicate.variables,
          variablesTemplate = {
                parameters | definitions.contract.templateParameters | optional,
                variables | definitions.contract.variables | optional,
              },
          webhookFilter = predicates.contract_from_predicate
              definitions.predicate.webhookFilter,
          webhookFilters = predicates.contract_from_predicate
              definitions.predicate.webhookFilters,
          webhookResource = predicates.contract_from_predicate
              definitions.predicate.webhookResource,
          webhookResources = predicates.contract_from_predicate
              definitions.predicate.webhookResources,
        },
    predicate = {
          any = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.any
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true predicates.always
                ]
              ],
          any_allowExpressions = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.any
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true predicates.always
                ]
              ],
          boolean = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^true$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^y$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^yes$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^on$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^false$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^n$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^no$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^off$"
                ]
              ],
          branchFilter
            | doc m%"
            branch name or prefix filter
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^[^\\/~\\^\\: \\[\\]\\\\]+(\\/[^\\/~\\^\\: \\[\\]\\\\]+)*$"
              ],
          branchFilterArray = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.branchFilter
              ],
          buildResource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "build", "connection", "source", "type" ],
                predicates.records.record
                {
                  branch = definitions.predicate.string_allowExpressions,
                  build = definitions.predicate.referenceName,
                  connection = definitions.predicate.nonEmptyString,
                  source = definitions.predicate.nonEmptyString,
                  trigger = definitions.predicate.buildResourceTrigger,
                  type = definitions.predicate.nonEmptyString,
                  version = definitions.predicate.string_allowExpressions,
                }
                {  }
                false
                predicates.never
              ],
          buildResourceTrigger = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^none$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^true$"
                ]
              ],
          buildResources = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.buildResource
              ],
          canaryDeploymentIncrements = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.nonEmptyString
              ],
          canaryDeploymentStrategy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  deploy = definitions.predicate.deployHook,
                  increments = definitions.predicate.canaryDeploymentIncrements,
                  on = definitions.predicate.onSuccessOrFailureHook,
                  postRouteTraffic = definitions.predicate.postRouteTrafficHook,
                  preDeploy = definitions.predicate.preDeployHook,
                  routeTraffic = definitions.predicate.routeTrafficHook,
                }
                {  }
                false
                predicates.never
              ],
          containerArtifactType = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^ACR$"
                ],
                predicates.isType '"String"
              ],
          containerBase = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image" ],
                predicates.records.record
                {
                  endpoint = definitions.predicate.string_allowExpressions,
                  env = definitions.predicate.mappingOfStringString,
                  image = definitions.predicate.string,
                  mapDockerSocket = definitions.predicate.boolean,
                  mountReadOnly = definitions.predicate.readOnlyMounts,
                  options = definitions.predicate.string_allowExpressions,
                  ports =
                    definitions.predicate.sequenceOfString_allowExpressions,
                  volumes =
                    definitions.predicate.sequenceOfString_allowExpressions,
                }
                {  }
                false
                predicates.never
              ],
          containerResource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "container", "image" ],
                predicates.records.record
                {
                  container = definitions.predicate.referenceName,
                  endpoint = definitions.predicate.string_allowExpressions,
                  env = definitions.predicate.mappingOfStringString,
                  image = definitions.predicate.string,
                  mapDockerSocket = definitions.predicate.boolean,
                  mountReadOnly = definitions.predicate.readOnlyMounts,
                  options = definitions.predicate.string_allowExpressions,
                  ports =
                    definitions.predicate.sequenceOfString_allowExpressions,
                  trigger = definitions.predicate.containerResourceTrigger,
                  type = definitions.predicate.containerArtifactType,
                  volumes =
                    definitions.predicate.sequenceOfString_allowExpressions,
                }
                {  }
                true
                predicates.always
              ],
          containerResourceTrigger = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^none$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^true$"
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    enabled = definitions.predicate.boolean,
                    tags = definitions.predicate.includeExcludeStringFilters,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          containerResources = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.containerResource
              ],
          deployHook = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  pool = definitions.predicate.pool,
                  steps = definitions.predicate.steps,
                }
                {  }
                false
                predicates.never
              ],
          deploymentEnvironment
            | doc m%"
            Environment details
            "%
            = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    name = definitions.predicate.nonEmptyString,
                    resourceId = definitions.predicate.nonEmptyString,
                    resourceName = definitions.predicate.nonEmptyString,
                    resourceType = definitions.predicate.nonEmptyString,
                    tags = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          deploymentStrategy = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { runOnce = definitions.predicate.runOnceDeploymentStrategy, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { rolling = definitions.predicate.rollingDeploymentStrategy, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { canary = definitions.predicate.canaryDeploymentStrategy, }
                  {  }
                  false
                  predicates.never
                ]
              ],
          explicitResources = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  pools = definitions.predicate.sequenceOfNonEmptyString,
                  repositories = definitions.predicate.sequenceOfNonEmptyString,
                }
                {  }
                false
                predicates.never
              ],
          extends = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  parameters = definitions.predicate.mapping,
                  template = definitions.predicate.nonEmptyString,
                }
                {  }
                false
                predicates.never
              ],
          extendsParameters = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.templateParameter
              ],
          extendsTemplate = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    parameters = definitions.predicate.extendsParameters,
                    resources = definitions.predicate.resources,
                    stages = definitions.predicate.stages,
                    trigger = definitions.predicate.trigger,
                    variables = definitions.predicate.variables,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    jobs = definitions.predicate.jobs,
                    parameters = definitions.predicate.extendsParameters,
                    resources = definitions.predicate.resources,
                    trigger = definitions.predicate.trigger,
                    variables = definitions.predicate.variables,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    parameters = definitions.predicate.extendsParameters,
                    resources = definitions.predicate.resources,
                    steps = definitions.predicate.steps,
                    trigger = definitions.predicate.trigger,
                    variables = definitions.predicate.variables,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    extends = definitions.predicate.extends,
                    parameters = definitions.predicate.extendsParameters,
                    resources = definitions.predicate.resources,
                    trigger = definitions.predicate.trigger,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          extendsTemplateBase = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  parameters = definitions.predicate.extendsParameters,
                  resources = definitions.predicate.resources,
                  trigger = definitions.predicate.trigger,
                  variables = definitions.predicate.variables,
                }
                {  }
                false
                predicates.never
              ],
          includeExcludeFilters = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  exclude = definitions.predicate.branchFilterArray,
                  include = definitions.predicate.branchFilterArray,
                }
                {  }
                false
                predicates.never
              ],
          includeExcludeStringFilters = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.nonEmptyString
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    exclude = definitions.predicate.sequenceOfNonEmptyString,
                    include = definitions.predicate.sequenceOfNonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          job = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    cancelTimeoutInMinutes =
                      definitions.predicate.nonEmptyString,
                    condition = definitions.predicate.string,
                    container = definitions.predicate.jobContainer,
                    continueOnError = definitions.predicate.jobContinueOnError,
                    dependsOn = definitions.predicate.jobDependsOn,
                    displayName = definitions.predicate.string,
                    job = definitions.predicate.referenceName,
                    pool = definitions.predicate.pool,
                    services = definitions.predicate.jobServices,
                    steps = definitions.predicate.steps,
                    strategy = definitions.predicate.jobStrategy,
                    templateContext = definitions.predicate.templateContext,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                    uses = definitions.predicate.explicitResources,
                    variables = definitions.predicate.variables,
                    workspace = definitions.predicate.jobWorkspace,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    cancelTimeoutInMinutes =
                      definitions.predicate.nonEmptyString,
                    condition = definitions.predicate.string,
                    container = definitions.predicate.jobContainer,
                    continueOnError = definitions.predicate.jobContinueOnError,
                    dependsOn = definitions.predicate.jobDependsOn,
                    deployment = definitions.predicate.string,
                    displayName = definitions.predicate.string,
                    environment = definitions.predicate.deploymentEnvironment,
                    pool = definitions.predicate.pool,
                    services = definitions.predicate.jobServices,
                    strategy = definitions.predicate.deploymentStrategy,
                    templateContext = definitions.predicate.templateContext,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                    uses = definitions.predicate.explicitResources,
                    variables = definitions.predicate.variables,
                    workspace = definitions.predicate.jobWorkspace,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    parameters = definitions.predicate.mapping,
                    template = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          jobContainer = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { alias = definitions.predicate.string, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "image" ],
                  predicates.records.record
                  {
                    endpoint = definitions.predicate.string_allowExpressions,
                    env = definitions.predicate.mappingOfStringString,
                    image = definitions.predicate.string,
                    mapDockerSocket = definitions.predicate.boolean,
                    mountReadOnly = definitions.predicate.readOnlyMounts,
                    options = definitions.predicate.string_allowExpressions,
                    ports =
                      definitions.predicate.sequenceOfString_allowExpressions,
                    volumes =
                      definitions.predicate.sequenceOfString_allowExpressions,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          jobContinueOnError = predicates.isType '"String",
          jobDecoratorSteps = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { steps = definitions.predicate.tasks, }
                {  }
                false
                predicates.never
              ],
          jobDependsOn = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.string
                ]
              ],
          jobMatrix = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 1,
                  predicates.records.record {  }
                  {
                    "^[A-Za-z0-9_]+$" = definitions.predicate.matrixProperties,
                  }
                  true
                  predicates.always
                ],
                predicates.isType '"String"
              ],
          jobServices = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true predicates.always
              ],
          jobStrategy = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    matrix = definitions.predicate.jobMatrix,
                    maxParallel = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { parallel = definitions.predicate.nonEmptyString, }
                  {  }
                  false
                  predicates.never
                ]
              ],
          jobWorkspace = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clean = predicates.allOf
                      [
                        predicates.enum [ "outputs", "resources", "all" ],
                        definitions.predicate.string
                      ],
                }
                {  }
                false
                predicates.never
              ],
          jobs = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.job
              ],
          jobsTemplate = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    jobs = definitions.predicate.jobs,
                    parameters = definitions.predicate.templateParameters,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    parameters = definitions.predicate.templateParameters,
                    phases = definitions.predicate.phases,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          legacyRepoResourceAlias = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^self$"
              ],
          legacyResource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clean = predicates.allOf
                      [
                        predicates.enum [ "true", "false" ],
                        definitions.predicate.string
                      ],
                  fetchDepth = definitions.predicate.string,
                  lfs = definitions.predicate.string,
                  repo = definitions.predicate.legacyRepoResourceAlias,
                }
                {  }
                false
                predicates.never
              ],
          lockBehavior = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^sequential$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^runLatest$"
                ]
              ],
          mapping = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true predicates.always
              ],
          mappingOfStringString = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true predicates.always
              ],
          matrixProperties
            | doc m%"
            Variable-value pair to pass in this matrix instance
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true predicates.always
              ],
          nonEmptyString = predicates.isType '"String",
          onFailureHook = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  pool = definitions.predicate.pool,
                  steps = definitions.predicate.steps,
                }
                {  }
                false
                predicates.never
              ],
          onSuccessHook = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  pool = definitions.predicate.pool,
                  steps = definitions.predicate.steps,
                }
                {  }
                false
                predicates.never
              ],
          onSuccessOrFailureHook = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  failure = definitions.predicate.onFailureHook,
                  success = definitions.predicate.onSuccessHook,
                }
                {  }
                false
                predicates.never
              ],
          packageResource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "connection", "name", "package", "type" ],
                predicates.records.record
                {
                  connection = definitions.predicate.nonEmptyString,
                  name = definitions.predicate.nonEmptyString,
                  package = definitions.predicate.referenceName,
                  tag = definitions.predicate.string_allowExpressions,
                  trigger = definitions.predicate.packageResourceTrigger,
                  type = definitions.predicate.nonEmptyString,
                  version = definitions.predicate.string_allowExpressions,
                }
                {  }
                false
                predicates.never
              ],
          packageResourceTrigger = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^none$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^true$"
                ]
              ],
          packageResources = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.packageResource
              ],
          parametersTemplate = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "steps" ],
                  predicates.records.record
                  {
                    parameters = definitions.predicate.templateParameters,
                    steps = definitions.predicate.steps,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    jobs = definitions.predicate.jobs,
                    parameters = definitions.predicate.templateParameters,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    parameters = definitions.predicate.templateParameters,
                    stages = definitions.predicate.stages,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "extends" ],
                  predicates.records.record
                  {
                    extends = definitions.predicate.extends,
                    parameters = definitions.predicate.templateParameters,
                    resources = definitions.predicate.resources,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          phase = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.jobContinueOnError,
                    dependsOn = definitions.predicate.jobDependsOn,
                    displayName = definitions.predicate.string,
                    phase = definitions.predicate.referenceName,
                    queue = definitions.predicate.phaseQueueTarget,
                    steps = definitions.predicate.steps,
                    variables = definitions.predicate.variables,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.jobContinueOnError,
                    dependsOn = definitions.predicate.jobDependsOn,
                    displayName = definitions.predicate.string,
                    phase = definitions.predicate.referenceName,
                    server = definitions.predicate.phaseServerTarget,
                    steps = definitions.predicate.steps,
                    variables = definitions.predicate.variables,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    parameters = definitions.predicate.mapping,
                    template = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          phaseQueueTarget
            | doc m%"
            Queue details
            "%
            = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    cancelTimeoutInMinutes =
                      definitions.predicate.nonEmptyString,
                    container = definitions.predicate.nonEmptyString,
                    demands = definitions.predicate.phaseTargetDemands,
                    matrix = definitions.predicate.phaseTargetMatrix,
                    name = definitions.predicate.string,
                    parallel = definitions.predicate.nonEmptyString,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                    workspace = definitions.predicate.phaseTargetWorkspace,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          phaseServerTarget = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    cancelTimeoutInMinutes =
                      definitions.predicate.nonEmptyString,
                    matrix = definitions.predicate.phaseTargetMatrix,
                    parallel = definitions.predicate.nonEmptyString,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          phaseTargetDemands = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.nonEmptyString
                ]
              ],
          phaseTargetMatrix
            | doc m%"
            List of permutations of variable values to run
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.isType '"String"
                ],
                predicates.records.minProperties 1,
                predicates.records.record {  }
                { "^[A-Za-z0-9_]+$" = definitions.predicate.matrixProperties, }
                true
                predicates.always
              ],
          phaseTargetWorkspace = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clean = predicates.allOf
                      [
                        predicates.enum [ "outputs", "resources", "all" ],
                        definitions.predicate.string
                      ],
                }
                {  }
                false
                predicates.never
              ],
          phases = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.phase
              ],
          pipeline = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "stages" ],
                  predicates.records.record
                  {
                    appendCommitMessageToRunName =
                      definitions.predicate.boolean,
                    lockBehavior = definitions.predicate.lockBehavior,
                    name = definitions.predicate.string_allowExpressions,
                    parameters =
                      definitions.predicate.pipelineTemplateParameters,
                    pool = definitions.predicate.pool,
                    pr = definitions.predicate.pr,
                    resources = definitions.predicate.resources,
                    schedules = definitions.predicate.schedules,
                    stages = definitions.predicate.stages,
                    trigger = definitions.predicate.trigger,
                    variables = definitions.predicate.variables,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "extends" ],
                  predicates.records.record
                  {
                    appendCommitMessageToRunName =
                      definitions.predicate.boolean,
                    extends = definitions.predicate.extends,
                    lockBehavior = definitions.predicate.lockBehavior,
                    name = definitions.predicate.string_allowExpressions,
                    parameters =
                      definitions.predicate.pipelineTemplateParameters,
                    pool = definitions.predicate.pool,
                    pr = definitions.predicate.pr,
                    resources = definitions.predicate.resources,
                    schedules = definitions.predicate.schedules,
                    trigger = definitions.predicate.trigger,
                    variables = definitions.predicate.variables,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "jobs" ],
                  predicates.records.record
                  {
                    appendCommitMessageToRunName =
                      definitions.predicate.boolean,
                    jobs = definitions.predicate.jobs,
                    lockBehavior = definitions.predicate.lockBehavior,
                    name = definitions.predicate.string_allowExpressions,
                    parameters =
                      definitions.predicate.pipelineTemplateParameters,
                    pool = definitions.predicate.pool,
                    pr = definitions.predicate.pr,
                    resources = definitions.predicate.resources,
                    schedules = definitions.predicate.schedules,
                    trigger = definitions.predicate.trigger,
                    variables = definitions.predicate.variables,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "phases" ],
                  predicates.records.record
                  {
                    appendCommitMessageToRunName =
                      definitions.predicate.boolean,
                    lockBehavior = definitions.predicate.lockBehavior,
                    name = definitions.predicate.string_allowExpressions,
                    parameters =
                      definitions.predicate.pipelineTemplateParameters,
                    phases = definitions.predicate.phases,
                    pr = definitions.predicate.pr,
                    resources = definitions.predicate.resources,
                    schedules = definitions.predicate.schedules,
                    trigger = definitions.predicate.trigger,
                    variables = definitions.predicate.variables,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "steps" ],
                  predicates.records.record
                  {
                    appendCommitMessageToRunName =
                      definitions.predicate.boolean,
                    container = definitions.predicate.jobContainer,
                    continueOnError = definitions.predicate.jobContinueOnError,
                    lockBehavior = definitions.predicate.lockBehavior,
                    name = definitions.predicate.string_allowExpressions,
                    parameters =
                      definitions.predicate.pipelineTemplateParameters,
                    pool = definitions.predicate.pool,
                    pr = definitions.predicate.pr,
                    resources = definitions.predicate.resources,
                    schedules = definitions.predicate.schedules,
                    services = definitions.predicate.jobServices,
                    steps = definitions.predicate.steps,
                    strategy = definitions.predicate.jobStrategy,
                    trigger = definitions.predicate.trigger,
                    variables = definitions.predicate.variables,
                    workspace = definitions.predicate.jobWorkspace,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "steps" ],
                  predicates.records.record
                  {
                    appendCommitMessageToRunName =
                      definitions.predicate.boolean,
                    continueOnError = definitions.predicate.jobContinueOnError,
                    lockBehavior = definitions.predicate.lockBehavior,
                    name = definitions.predicate.string_allowExpressions,
                    parameters =
                      definitions.predicate.pipelineTemplateParameters,
                    pr = definitions.predicate.pr,
                    queue = definitions.predicate.phaseQueueTarget,
                    resources = definitions.predicate.resources,
                    schedules = definitions.predicate.schedules,
                    steps = definitions.predicate.steps,
                    trigger = definitions.predicate.trigger,
                    variables = definitions.predicate.variables,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "steps" ],
                  predicates.records.record
                  {
                    appendCommitMessageToRunName =
                      definitions.predicate.boolean,
                    continueOnError = definitions.predicate.jobContinueOnError,
                    lockBehavior = definitions.predicate.lockBehavior,
                    name = definitions.predicate.string_allowExpressions,
                    parameters =
                      definitions.predicate.pipelineTemplateParameters,
                    pr = definitions.predicate.pr,
                    resources = definitions.predicate.resources,
                    schedules = definitions.predicate.schedules,
                    server = definitions.predicate.phaseServerTarget,
                    steps = definitions.predicate.steps,
                    trigger = definitions.predicate.trigger,
                    variables = definitions.predicate.variables,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          pipelineAnyBase = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appendCommitMessageToRunName =
                    definitions.predicate.any_allowExpressions,
                  container = definitions.predicate.any_allowExpressions,
                  continueOnError = definitions.predicate.any_allowExpressions,
                  extends = definitions.predicate.any_allowExpressions,
                  jobs = definitions.predicate.any_allowExpressions,
                  lockBehavior = definitions.predicate.lockBehavior,
                  name = definitions.predicate.any_allowExpressions,
                  parameters = definitions.predicate.any_allowExpressions,
                  phases = definitions.predicate.any_allowExpressions,
                  pool = definitions.predicate.any_allowExpressions,
                  pr = definitions.predicate.any_allowExpressions,
                  queue = definitions.predicate.any_allowExpressions,
                  resources = definitions.predicate.any_allowExpressions,
                  schedules = definitions.predicate.any_allowExpressions,
                  server = definitions.predicate.any_allowExpressions,
                  services = definitions.predicate.any_allowExpressions,
                  stages = definitions.predicate.any_allowExpressions,
                  steps = definitions.predicate.any_allowExpressions,
                  strategy = definitions.predicate.any_allowExpressions,
                  trigger = definitions.predicate.any_allowExpressions,
                  variables = definitions.predicate.any_allowExpressions,
                  workspace = definitions.predicate.any_allowExpressions,
                }
                {  }
                false
                predicates.never
              ],
          pipelineBase = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appendCommitMessageToRunName = definitions.predicate.boolean,
                  lockBehavior = definitions.predicate.lockBehavior,
                  name = definitions.predicate.string_allowExpressions,
                  parameters = definitions.predicate.pipelineTemplateParameters,
                  pr = definitions.predicate.pr,
                  resources = definitions.predicate.resources,
                  schedules = definitions.predicate.schedules,
                  trigger = definitions.predicate.trigger,
                  variables = definitions.predicate.variables,
                }
                {  }
                false
                predicates.never
              ],
          pipelinePR = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appendCommitMessageToRunName =
                    definitions.predicate.any_allowExpressions,
                  container = definitions.predicate.any_allowExpressions,
                  continueOnError = definitions.predicate.any_allowExpressions,
                  extends = definitions.predicate.any_allowExpressions,
                  jobs = definitions.predicate.any_allowExpressions,
                  lockBehavior = definitions.predicate.lockBehavior,
                  name = definitions.predicate.any_allowExpressions,
                  parameters = definitions.predicate.any_allowExpressions,
                  phases = definitions.predicate.any_allowExpressions,
                  pool = definitions.predicate.any_allowExpressions,
                  pr = definitions.predicate.pr,
                  queue = definitions.predicate.any_allowExpressions,
                  resources = definitions.predicate.any_allowExpressions,
                  schedules = definitions.predicate.any_allowExpressions,
                  server = definitions.predicate.any_allowExpressions,
                  services = definitions.predicate.any_allowExpressions,
                  stages = definitions.predicate.any_allowExpressions,
                  steps = definitions.predicate.any_allowExpressions,
                  strategy = definitions.predicate.any_allowExpressions,
                  trigger = definitions.predicate.any_allowExpressions,
                  variables = definitions.predicate.any_allowExpressions,
                  workspace = definitions.predicate.any_allowExpressions,
                }
                {  }
                false
                predicates.never
              ],
          pipelineParameters = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appendCommitMessageToRunName =
                    definitions.predicate.any_allowExpressions,
                  container = definitions.predicate.any_allowExpressions,
                  continueOnError = definitions.predicate.any_allowExpressions,
                  extends = definitions.predicate.any_allowExpressions,
                  jobs = definitions.predicate.any_allowExpressions,
                  lockBehavior = definitions.predicate.lockBehavior,
                  name = definitions.predicate.any_allowExpressions,
                  parameters = definitions.predicate.pipelineTemplateParameters,
                  phases = definitions.predicate.any_allowExpressions,
                  pool = definitions.predicate.any_allowExpressions,
                  pr = definitions.predicate.any_allowExpressions,
                  queue = definitions.predicate.any_allowExpressions,
                  resources = definitions.predicate.any_allowExpressions,
                  schedules = definitions.predicate.any_allowExpressions,
                  server = definitions.predicate.any_allowExpressions,
                  services = definitions.predicate.any_allowExpressions,
                  stages = definitions.predicate.any_allowExpressions,
                  steps = definitions.predicate.any_allowExpressions,
                  strategy = definitions.predicate.any_allowExpressions,
                  trigger = definitions.predicate.any_allowExpressions,
                  variables = definitions.predicate.any_allowExpressions,
                  workspace = definitions.predicate.any_allowExpressions,
                }
                {  }
                false
                predicates.never
              ],
          pipelineResource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "pipeline" ],
                predicates.records.record
                {
                  branch = definitions.predicate.string_allowExpressions,
                  pipeline = definitions.predicate.referenceName,
                  project = definitions.predicate.nonEmptyString,
                  source = definitions.predicate.nonEmptyString,
                  tags = definitions.predicate.sequenceOfNonEmptyString,
                  trigger = definitions.predicate.pipelineResourceTrigger,
                  version = definitions.predicate.string_allowExpressions,
                }
                {  }
                false
                predicates.never
              ],
          pipelineResourceTrigger = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^none$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^true$"
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    branches = definitions.predicate.triggerBranchFilter,
                    enabled = definitions.predicate.boolean,
                    stages = definitions.predicate.sequenceOfNonEmptyString,
                    tags = definitions.predicate.sequenceOfNonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          pipelineResources = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.pipelineResource
              ],
          pipelineSchedules = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appendCommitMessageToRunName =
                    definitions.predicate.any_allowExpressions,
                  container = definitions.predicate.any_allowExpressions,
                  continueOnError = definitions.predicate.any_allowExpressions,
                  extends = definitions.predicate.any_allowExpressions,
                  jobs = definitions.predicate.any_allowExpressions,
                  lockBehavior = definitions.predicate.lockBehavior,
                  name = definitions.predicate.any_allowExpressions,
                  parameters = definitions.predicate.any_allowExpressions,
                  phases = definitions.predicate.any_allowExpressions,
                  pool = definitions.predicate.any_allowExpressions,
                  pr = definitions.predicate.any_allowExpressions,
                  queue = definitions.predicate.any_allowExpressions,
                  resources = definitions.predicate.any_allowExpressions,
                  schedules = definitions.predicate.schedules,
                  server = definitions.predicate.any_allowExpressions,
                  services = definitions.predicate.any_allowExpressions,
                  stages = definitions.predicate.any_allowExpressions,
                  steps = definitions.predicate.any_allowExpressions,
                  strategy = definitions.predicate.any_allowExpressions,
                  trigger = definitions.predicate.any_allowExpressions,
                  variables = definitions.predicate.any_allowExpressions,
                  workspace = definitions.predicate.any_allowExpressions,
                }
                {  }
                false
                predicates.never
              ],
          pipelineTemplateParameter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "default" = definitions.predicate.any,
                  displayName = definitions.predicate.string,
                  name = definitions.predicate.nonEmptyString,
                  type = definitions.predicate.pipelineTemplateParameterType,
                  values = definitions.predicate.sequenceOfNonEmptyString,
                }
                {  }
                false
                predicates.never
              ],
          pipelineTemplateParameterType = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^boolean$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^container$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^containerList$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^deployment$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^deploymentList$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^environment$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^filePath$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^job$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^jobList$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^number$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^object$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^pool$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^secureFile$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^serviceConnection$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^stage$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^stageList$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^step$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^stepList$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^string$"
                ]
              ],
          pipelineTemplateParameters = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.pipelineTemplateParameter
              ],
          pipelineTrigger = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appendCommitMessageToRunName =
                    definitions.predicate.any_allowExpressions,
                  container = definitions.predicate.any_allowExpressions,
                  continueOnError = definitions.predicate.any_allowExpressions,
                  extends = definitions.predicate.any_allowExpressions,
                  jobs = definitions.predicate.any_allowExpressions,
                  lockBehavior = definitions.predicate.lockBehavior,
                  name = definitions.predicate.any_allowExpressions,
                  parameters = definitions.predicate.any_allowExpressions,
                  phases = definitions.predicate.any_allowExpressions,
                  pool = definitions.predicate.any_allowExpressions,
                  pr = definitions.predicate.any_allowExpressions,
                  queue = definitions.predicate.any_allowExpressions,
                  resources = definitions.predicate.any_allowExpressions,
                  schedules = definitions.predicate.any_allowExpressions,
                  server = definitions.predicate.any_allowExpressions,
                  services = definitions.predicate.any_allowExpressions,
                  stages = definitions.predicate.any_allowExpressions,
                  steps = definitions.predicate.any_allowExpressions,
                  strategy = definitions.predicate.any_allowExpressions,
                  trigger = definitions.predicate.trigger,
                  variables = definitions.predicate.any_allowExpressions,
                  workspace = definitions.predicate.any_allowExpressions,
                }
                {  }
                false
                predicates.never
              ],
          pool
            | doc m%"
            Pool details
            "%
            = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    demands = definitions.predicate.poolDemands,
                    name = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  true
                  predicates.always
                ]
              ],
          poolDemands = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.nonEmptyString
                ]
              ],
          postRouteTrafficHook = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  pool = definitions.predicate.pool,
                  steps = definitions.predicate.steps,
                }
                {  }
                false
                predicates.never
              ],
          pr = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^none$"
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.branchFilter
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    autoCancel = definitions.predicate.boolean,
                    branches = definitions.predicate.includeExcludeFilters,
                    drafts = definitions.predicate.boolean,
                    paths = definitions.predicate.includeExcludeFilters,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          preDeployHook = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  pool = definitions.predicate.pool,
                  steps = definitions.predicate.steps,
                }
                {  }
                false
                predicates.never
              ],
          readOnlyMounts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  externals = definitions.predicate.boolean,
                  tasks = definitions.predicate.boolean,
                  tools = definitions.predicate.boolean,
                  work = definitions.predicate.boolean,
                }
                {  }
                false
                predicates.never
              ],
          referenceName = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[-_A-Za-z0-9]*$"
              ],
          repositoryCheckoutOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clean = predicates.allOf
                      [
                        predicates.enum [ "true", "false" ],
                        definitions.predicate.string
                      ],
                  fetchDepth = definitions.predicate.string,
                  fetchTags = definitions.predicate.string,
                  lfs = definitions.predicate.string,
                  persistCredentials = definitions.predicate.string,
                  submodules = definitions.predicate.string,
                }
                {  }
                false
                predicates.never
              ],
          repositoryResource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "repository" ],
                predicates.records.record
                {
                  checkoutOptions =
                    definitions.predicate.repositoryCheckoutOptions,
                  endpoint = definitions.predicate.nonEmptyString,
                  ref = definitions.predicate.string_allowExpressions,
                  repository = definitions.predicate.referenceName,
                  trigger = definitions.predicate.trigger,
                }
                {  }
                true
                predicates.always
              ],
          repositoryResources = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.repositoryResource
              ],
          resources = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    builds = definitions.predicate.buildResources,
                    containers = definitions.predicate.containerResources,
                    packages = definitions.predicate.packageResources,
                    pipelines = definitions.predicate.pipelineResources,
                    repositories = definitions.predicate.repositoryResources,
                    webhooks = definitions.predicate.webhookResources,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.legacyResource
                ]
              ],
          rollingDeploymentStrategy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  deploy = definitions.predicate.deployHook,
                  maxParallel = definitions.predicate.nonEmptyString,
                  on = definitions.predicate.onSuccessOrFailureHook,
                  postRouteTraffic = definitions.predicate.postRouteTrafficHook,
                  preDeploy = definitions.predicate.preDeployHook,
                  routeTraffic = definitions.predicate.routeTrafficHook,
                }
                {  }
                false
                predicates.never
              ],
          routeTrafficHook = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  pool = definitions.predicate.pool,
                  steps = definitions.predicate.steps,
                }
                {  }
                false
                predicates.never
              ],
          runOnceDeploymentStrategy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  deploy = definitions.predicate.deployHook,
                  on = definitions.predicate.onSuccessOrFailureHook,
                  postRouteTraffic = definitions.predicate.postRouteTrafficHook,
                  preDeploy = definitions.predicate.preDeployHook,
                  routeTraffic = definitions.predicate.routeTrafficHook,
                }
                {  }
                false
                predicates.never
              ],
          schedule = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  always = definitions.predicate.boolean,
                  batch = definitions.predicate.boolean,
                  branches = definitions.predicate.includeExcludeFilters,
                  cron = definitions.predicate.nonEmptyString,
                  displayName = definitions.predicate.string,
                }
                {  }
                false
                predicates.never
              ],
          schedules = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.schedule
              ],
          sequence = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.any
              ],
          sequenceOfNonEmptyString = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.nonEmptyString
              ],
          sequenceOfString_allowExpressions = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.string_allowExpressions
              ],
          stage = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    condition = definitions.predicate.string,
                    dependsOn = definitions.predicate.jobDependsOn,
                    displayName = definitions.predicate.string,
                    jobs = definitions.predicate.jobs,
                    lockBehavior = definitions.predicate.lockBehavior,
                    pool = definitions.predicate.pool,
                    stage = definitions.predicate.string,
                    templateContext = definitions.predicate.templateContext,
                    variables = definitions.predicate.variables,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    parameters = definitions.predicate.mapping,
                    template = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          stages = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.stage
              ],
          stagesTemplate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  parameters = definitions.predicate.templateParameters,
                  stages = definitions.predicate.stages,
                }
                {  }
                false
                predicates.never
              ],
          step = predicates.anyOf
              [
                predicates.allOf
                [ predicates.isType 'Record, definitions.predicate.task ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "script" ],
                  predicates.records.record
                  {
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.boolean,
                    displayName = definitions.predicate.string,
                    enabled = definitions.predicate.boolean,
                    env = definitions.predicate.mappingOfStringString,
                    failOnStderr = definitions.predicate.string,
                    name = definitions.predicate.referenceName,
                    retryCountOnTaskFailure = definitions.predicate.string,
                    script = definitions.predicate.string,
                    target = definitions.predicate.stepTarget,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                    workingDirectory = definitions.predicate.string,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "powershell" ],
                  predicates.records.record
                  {
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.boolean,
                    displayName = definitions.predicate.string,
                    enabled = definitions.predicate.boolean,
                    env = definitions.predicate.mappingOfStringString,
                    errorActionPreference = definitions.predicate.string,
                    failOnStderr = definitions.predicate.string,
                    ignoreLASTEXITCODE = definitions.predicate.string,
                    name = definitions.predicate.referenceName,
                    powershell = definitions.predicate.string,
                    retryCountOnTaskFailure = definitions.predicate.string,
                    target = definitions.predicate.stepTarget,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                    workingDirectory = definitions.predicate.string,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "pwsh" ],
                  predicates.records.record
                  {
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.boolean,
                    displayName = definitions.predicate.string,
                    enabled = definitions.predicate.boolean,
                    env = definitions.predicate.mappingOfStringString,
                    errorActionPreference = definitions.predicate.string,
                    failOnStderr = definitions.predicate.string,
                    ignoreLASTEXITCODE = definitions.predicate.string,
                    name = definitions.predicate.referenceName,
                    pwsh = definitions.predicate.string,
                    retryCountOnTaskFailure = definitions.predicate.string,
                    target = definitions.predicate.stepTarget,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                    workingDirectory = definitions.predicate.string,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "bash" ],
                  predicates.records.record
                  {
                    bash = definitions.predicate.string,
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.boolean,
                    displayName = definitions.predicate.string,
                    enabled = definitions.predicate.boolean,
                    env = definitions.predicate.mappingOfStringString,
                    failOnStderr = definitions.predicate.string,
                    name = definitions.predicate.referenceName,
                    retryCountOnTaskFailure = definitions.predicate.string,
                    target = definitions.predicate.stepTarget,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                    workingDirectory = definitions.predicate.string,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    checkout = definitions.predicate.string,
                    clean = predicates.allOf
                        [
                          predicates.enum [ "true", "false" ],
                          definitions.predicate.string
                        ],
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.boolean,
                    displayName = definitions.predicate.string,
                    enabled = definitions.predicate.boolean,
                    env = definitions.predicate.mappingOfStringString,
                    fetchDepth = definitions.predicate.string,
                    fetchTags = definitions.predicate.string,
                    lfs = definitions.predicate.string,
                    name = definitions.predicate.referenceName,
                    path = definitions.predicate.string,
                    persistCredentials = definitions.predicate.string,
                    retryCountOnTaskFailure = definitions.predicate.string,
                    submodules = definitions.predicate.string,
                    target = definitions.predicate.stepTarget,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "download" ],
                  predicates.records.record
                  {
                    artifact = definitions.predicate.nonEmptyString,
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.boolean,
                    displayName = definitions.predicate.string,
                    download = definitions.predicate.nonEmptyString,
                    enabled = definitions.predicate.boolean,
                    env = definitions.predicate.mappingOfStringString,
                    name = definitions.predicate.referenceName,
                    patterns = definitions.predicate.nonEmptyString,
                    retryCountOnTaskFailure = definitions.predicate.string,
                    target = definitions.predicate.stepTarget,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    artifact = definitions.predicate.string,
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.boolean,
                    displayName = definitions.predicate.string,
                    downloadBuild = definitions.predicate.nonEmptyString,
                    enabled = definitions.predicate.boolean,
                    env = definitions.predicate.mappingOfStringString,
                    name = definitions.predicate.referenceName,
                    path = definitions.predicate.string,
                    patterns = definitions.predicate.string,
                    retryCountOnTaskFailure = definitions.predicate.string,
                    target = definitions.predicate.stepTarget,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.boolean,
                    displayName = definitions.predicate.string,
                    enabled = definitions.predicate.boolean,
                    env = definitions.predicate.mappingOfStringString,
                    getPackage = definitions.predicate.nonEmptyString,
                    name = definitions.predicate.referenceName,
                    path = definitions.predicate.string,
                    retryCountOnTaskFailure = definitions.predicate.string,
                    target = definitions.predicate.stepTarget,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    artifact = definitions.predicate.string,
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.boolean,
                    displayName = definitions.predicate.string,
                    enabled = definitions.predicate.boolean,
                    env = definitions.predicate.mappingOfStringString,
                    name = definitions.predicate.referenceName,
                    retryCountOnTaskFailure = definitions.predicate.string,
                    target = definitions.predicate.stepTarget,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                    upload = definitions.predicate.string,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    artifact = definitions.predicate.string,
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.boolean,
                    displayName = definitions.predicate.string,
                    enabled = definitions.predicate.boolean,
                    env = definitions.predicate.mappingOfStringString,
                    name = definitions.predicate.referenceName,
                    publish = definitions.predicate.string,
                    retryCountOnTaskFailure = definitions.predicate.string,
                    target = definitions.predicate.stepTarget,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    parameters = definitions.predicate.mapping,
                    template = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    condition = definitions.predicate.string,
                    continueOnError = definitions.predicate.boolean,
                    displayName = definitions.predicate.string,
                    enabled = definitions.predicate.boolean,
                    env = definitions.predicate.mappingOfStringString,
                    name = definitions.predicate.referenceName,
                    retryCountOnTaskFailure = definitions.predicate.string,
                    reviewApp = definitions.predicate.string,
                    target = definitions.predicate.stepTarget,
                    timeoutInMinutes = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          stepTarget
            | doc m%"
            Step target
            "%
            = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    commands = predicates.allOf
                        [
                          predicates.enum [ "any", "restricted" ],
                          definitions.predicate.string
                        ],
                    container = definitions.predicate.nonEmptyString,
                    settableVariables =
                      definitions.predicate.variableRestrictions,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          steps = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.step
              ],
          stepsTemplate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  parameters = definitions.predicate.templateParameters,
                  steps = definitions.predicate.steps,
                }
                {  }
                false
                predicates.never
              ],
          string = predicates.isType '"String",
          string_allowExpressions = predicates.isType '"String",
          task = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            debugPreference = predicates.enum
                                [
                                  "default",
                                  "stop",
                                  "continue",
                                  "silentlyContinue"
                                ],
                            errorActionPreference = predicates.enum
                                [
                                  "default",
                                  "stop",
                                  "continue",
                                  "silentlyContinue"
                                ],
                            failOnStderr = predicates.isType '"Bool",
                            filePath = predicates.isType '"String",
                            ignoreLASTEXITCODE = predicates.isType '"Bool",
                            informationPreference = predicates.enum
                                [
                                  "default",
                                  "stop",
                                  "continue",
                                  "silentlyContinue"
                                ],
                            progressPreference = predicates.enum
                                [
                                  "default",
                                  "stop",
                                  "continue",
                                  "silentlyContinue"
                                ],
                            pwsh = predicates.isType '"Bool",
                            runScriptInSeparateScope = predicates.isType
                                '"Bool",
                            script = predicates.isType '"String",
                            showWarnings = predicates.isType '"Bool",
                            targetType = predicates.enum
                                [ "filePath", "inline" ],
                            verbosePreference = predicates.enum
                                [
                                  "default",
                                  "stop",
                                  "continue",
                                  "silentlyContinue"
                                ],
                            warningPreference = predicates.enum
                                [
                                  "default",
                                  "stop",
                                  "continue",
                                  "silentlyContinue"
                                ],
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^PowerShell@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            failOnStandardError = predicates.isType '"Bool",
                            inlineScript = predicates.isType '"String",
                            scriptName = predicates.isType '"String",
                            scriptType = predicates.enum
                                [ "inlineScript", "filePath" ],
                            workingFolder = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^PowerShell@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            Inline = predicates.isType '"String",
                            ScriptArguments = predicates.isType '"String",
                            ScriptPath = predicates.isType '"String",
                            ScriptType = predicates.enum
                                [ "FilePath", "InlineScript" ],
                            azureClassicSubscription = predicates.isType
                                '"String",
                            azureConnectionType = predicates.enum
                                [
                                  "ConnectedServiceName",
                                  "ConnectedServiceNameARM"
                                ],
                            azurePowerShellVersion = predicates.enum
                                [ "LatestVersion", "OtherVersion" ],
                            azureSubscription = predicates.isType '"String",
                            preferredAzurePowerShellVersion = predicates.isType
                                '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^AzurePowerShell@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            FailOnStandardError = predicates.isType '"Bool",
                            Inline = predicates.isType '"String",
                            ScriptArguments = predicates.isType '"String",
                            ScriptPath = predicates.isType '"String",
                            ScriptType = predicates.enum
                                [ "FilePath", "InlineScript" ],
                            azureClassicSubscription = predicates.isType
                                '"String",
                            azureConnectionType = predicates.enum
                                [
                                  "ConnectedServiceName",
                                  "ConnectedServiceNameARM"
                                ],
                            azurePowerShellVersion = predicates.enum
                                [ "LatestVersion", "OtherVersion" ],
                            azureSubscription = predicates.isType '"String",
                            errorActionPreference = predicates.enum
                                [ "stop", "continue", "silentlyContinue" ],
                            preferredAzurePowerShellVersion = predicates.isType
                                '"String",
                            validateScriptSignature = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^AzurePowerShell@3$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "azureSubscription" ],
                            predicates.records.record
                            {
                              FailOnStandardError = predicates.isType '"Bool",
                              Inline = predicates.isType '"String",
                              RestrictContextToCurrentTask = predicates.isType
                                  '"Bool",
                              ScriptArguments = predicates.isType '"String",
                              ScriptPath = predicates.isType '"String",
                              ScriptType = predicates.enum
                                  [ "FilePath", "InlineScript" ],
                              azurePowerShellVersion = predicates.enum
                                  [ "LatestVersion", "OtherVersion" ],
                              azureSubscription = predicates.isType '"String",
                              errorActionPreference = predicates.enum
                                  [ "stop", "continue", "silentlyContinue" ],
                              preferredAzurePowerShellVersion =
                                predicates.isType '"String",
                              pwsh = predicates.isType '"Bool",
                              validateScriptSignature = predicates.isType
                                  '"Bool",
                              workingDirectory = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzurePowerShell@4$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "azureSubscription" ],
                            predicates.records.record
                            {
                              FailOnStandardError = predicates.isType '"Bool",
                              Inline = predicates.isType '"String",
                              ScriptArguments = predicates.isType '"String",
                              ScriptPath = predicates.isType '"String",
                              ScriptType = predicates.enum
                                  [ "FilePath", "InlineScript" ],
                              azurePowerShellVersion = predicates.enum
                                  [ "LatestVersion", "OtherVersion" ],
                              azureSubscription = predicates.isType '"String",
                              errorActionPreference = predicates.enum
                                  [ "stop", "continue", "silentlyContinue" ],
                              preferredAzurePowerShellVersion =
                                predicates.isType '"String",
                              pwsh = predicates.isType '"Bool",
                              validateScriptSignature = predicates.isType
                                  '"Bool",
                              workingDirectory = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzurePowerShell@5$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            ConnectedServiceName = predicates.isType '"String",
                            ConnectedServiceNameARM = predicates.isType
                                '"String",
                            ConnectedServiceNameSelector = predicates.enum
                                [
                                  "ConnectedServiceName",
                                  "ConnectedServiceNameARM"
                                ],
                            Inline = predicates.isType '"String",
                            ScriptArguments = predicates.isType '"String",
                            ScriptPath = predicates.isType '"String",
                            ScriptType = predicates.enum
                                [ "FilePath", "InlineScript" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^AzurePowerShell@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "SqlPassword", "SqlUsername" ],
                            predicates.records.record
                            {
                              DatabaseName = predicates.isType '"String",
                              ServerName = predicates.isType '"String",
                              SqlAdditionalArguments = predicates.isType
                                  '"String",
                              SqlFile = predicates.isType '"String",
                              SqlInline = predicates.isType '"String",
                              SqlPassword = predicates.isType '"String",
                              SqlUsername = predicates.isType '"String",
                              TaskNameSelector = predicates.enum
                                  [ "SqlTaskFile", "InlineSqlTask" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^MysqlDeploymentOnMachineGroup@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            artifactFeeds = predicates.isType '"String",
                            externalFeeds = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^PipAuthenticate@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            artifactFeeds = predicates.isType '"String",
                            onlyAddExtraIndex = predicates.isType '"Bool",
                            pythonDownloadServiceConnections = predicates.isType
                                '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^PipAuthenticate@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            allowBrokenSymlinks = predicates.isType '"Bool",
                            checkStyleRunAnalysis = predicates.isType '"Bool",
                            codeCoverageClassFilesDirectories =
                              predicates.isType '"String",
                            codeCoverageClassFilter = predicates.isType
                                '"String",
                            codeCoverageFailIfEmpty = predicates.isType '"Bool",
                            codeCoverageRestoreOriginalPomXml =
                              predicates.isType '"Bool",
                            codeCoverageSourceDirectories = predicates.isType
                                '"String",
                            codeCoverageToolOption = predicates.enum
                                [ "None", "Cobertura", "JaCoCo" ],
                            effectivePomSkip = predicates.isType '"Bool",
                            failWhenBugsFound = predicates.isType '"Bool",
                            findBugsRunAnalysis = predicates.isType '"Bool",
                            goals = predicates.isType '"String",
                            isJacocoCoverageReportXML = predicates.isType
                                '"Bool",
                            javaHomeOption = predicates.enum
                                [ "JDKVersion", "Path" ],
                            jdkArchitectureOption = predicates.enum
                                [ "x86", "x64" ],
                            jdkDirectory = predicates.isType '"String",
                            jdkVersionOption = predicates.enum
                                [
                                  "default",
                                  "1.17",
                                  "1.11",
                                  "1.10",
                                  "1.9",
                                  "1.8",
                                  "1.7",
                                  "1.6"
                                ],
                            mavenAuthenticateFeed = predicates.isType '"Bool",
                            mavenDirectory = predicates.isType '"String",
                            mavenOptions = predicates.isType '"String",
                            mavenPomFile = predicates.isType '"String",
                            mavenSetM2Home = predicates.isType '"Bool",
                            mavenVersionOption = predicates.enum
                                [ "Default", "Path" ],
                            options = predicates.isType '"String",
                            pmdRunAnalysis = predicates.isType '"Bool",
                            publishJUnitResults = predicates.isType '"Bool",
                            sonarQubeRunAnalysis = predicates.isType '"Bool",
                            spotBugsGoal = predicates.enum
                                [ "spotbugs", "check" ],
                            spotBugsRunAnalysis = predicates.isType '"Bool",
                            spotBugsVersion = predicates.isType '"String",
                            sqMavenPluginVersionChoice = predicates.enum
                                [ "latest", "pom" ],
                            testResultsFiles = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Maven@3$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            allowBrokenSymlinks = predicates.isType '"Bool",
                            checkStyleRunAnalysis = predicates.isType '"Bool",
                            codeCoverageClassFilesDirectories =
                              predicates.isType '"String",
                            codeCoverageClassFilter = predicates.isType
                                '"String",
                            codeCoverageFailIfEmpty = predicates.isType '"Bool",
                            codeCoverageRestoreOriginalPomXml =
                              predicates.isType '"Bool",
                            codeCoverageSourceDirectories = predicates.isType
                                '"String",
                            codeCoverageToolOption = predicates.enum
                                [ "None", "Cobertura", "JaCoCo" ],
                            effectivePomSkip = predicates.isType '"Bool",
                            failWhenBugsFound = predicates.isType '"Bool",
                            findBugsRunAnalysis = predicates.isType '"Bool",
                            goals = predicates.isType '"String",
                            isJacocoCoverageReportXML = predicates.isType
                                '"Bool",
                            javaHomeOption = predicates.enum
                                [ "JDKVersion", "Path" ],
                            jdkArchitectureOption = predicates.enum
                                [ "x86", "x64" ],
                            jdkDirectory = predicates.isType '"String",
                            jdkVersionOption = predicates.enum
                                [
                                  "default",
                                  "1.17",
                                  "1.11",
                                  "1.10",
                                  "1.9",
                                  "1.8",
                                  "1.7",
                                  "1.6"
                                ],
                            mavenAuthenticateFeed = predicates.isType '"Bool",
                            mavenDirectory = predicates.isType '"String",
                            mavenOptions = predicates.isType '"String",
                            mavenPomFile = predicates.isType '"String",
                            mavenSetM2Home = predicates.isType '"Bool",
                            mavenVersionOption = predicates.enum
                                [ "Default", "Path" ],
                            options = predicates.isType '"String",
                            pmdRunAnalysis = predicates.isType '"Bool",
                            publishJUnitResults = predicates.isType '"Bool",
                            sonarQubeRunAnalysis = predicates.isType '"Bool",
                            spotBugsGoal = predicates.enum
                                [ "spotbugs", "check" ],
                            spotBugsRunAnalysis = predicates.isType '"Bool",
                            spotBugsVersion = predicates.isType '"String",
                            sqMavenPluginVersionChoice = predicates.enum
                                [ "latest", "pom" ],
                            testResultsFiles = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Maven@4$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            checkStyleRunAnalysis = predicates.isType '"Bool",
                            codeCoverageClassFilesDirectories =
                              predicates.isType '"String",
                            codeCoverageClassFilter = predicates.isType
                                '"String",
                            codeCoverageFailIfEmpty = predicates.isType '"Bool",
                            codeCoverageSourceDirectories = predicates.isType
                                '"String",
                            codeCoverageToolOption = predicates.enum
                                [ "None", "Cobertura", "JaCoCo" ],
                            findBugsRunAnalysis = predicates.isType '"Bool",
                            goals = predicates.isType '"String",
                            javaHomeOption = predicates.enum
                                [ "JDKVersion", "Path" ],
                            jdkArchitectureOption = predicates.enum
                                [ "x86", "x64" ],
                            jdkDirectory = predicates.isType '"String",
                            jdkVersionOption = predicates.enum
                                [ "default", "1.9", "1.8", "1.7", "1.6" ],
                            mavenAuthenticateFeed = predicates.isType '"Bool",
                            mavenDirectory = predicates.isType '"String",
                            mavenOptions = predicates.isType '"String",
                            mavenPomFile = predicates.isType '"String",
                            mavenSetM2Home = predicates.isType '"Bool",
                            mavenVersionOption = predicates.enum
                                [ "Default", "Path" ],
                            options = predicates.isType '"String",
                            pmdRunAnalysis = predicates.isType '"Bool",
                            publishJUnitResults = predicates.isType '"Bool",
                            sonarQubeDBPassword = predicates.isType '"String",
                            sonarQubeDBUrl = predicates.isType '"String",
                            sonarQubeDBUsername = predicates.isType '"String",
                            sonarQubeFailWhenQualityGateFails =
                              predicates.isType '"Bool",
                            sonarQubeIncludeFullReport = predicates.isType
                                '"Bool",
                            sonarQubeProjectKey = predicates.isType '"String",
                            sonarQubeProjectName = predicates.isType '"String",
                            sonarQubeProjectVersion = predicates.isType
                                '"String",
                            sonarQubeRunAnalysis = predicates.isType '"Bool",
                            sonarQubeServiceEndpoint = predicates.isType
                                '"String",
                            sonarQubeSpecifyDB = predicates.isType '"Bool",
                            testResultsFiles = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Maven@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            allowBrokenSymlinks = predicates.isType '"Bool",
                            checkStyleRunAnalysis = predicates.isType '"Bool",
                            codeCoverageClassFilesDirectories =
                              predicates.isType '"String",
                            codeCoverageClassFilter = predicates.isType
                                '"String",
                            codeCoverageFailIfEmpty = predicates.isType '"Bool",
                            codeCoverageRestoreOriginalPomXml =
                              predicates.isType '"Bool",
                            codeCoverageSourceDirectories = predicates.isType
                                '"String",
                            codeCoverageToolOption = predicates.enum
                                [ "None", "Cobertura", "JaCoCo" ],
                            findBugsRunAnalysis = predicates.isType '"Bool",
                            goals = predicates.isType '"String",
                            isJacocoCoverageReportXML = predicates.isType
                                '"Bool",
                            javaHomeOption = predicates.enum
                                [ "JDKVersion", "Path" ],
                            jdkArchitectureOption = predicates.enum
                                [ "x86", "x64" ],
                            jdkDirectory = predicates.isType '"String",
                            jdkVersionOption = predicates.enum
                                [
                                  "default",
                                  "1.17",
                                  "1.11",
                                  "1.10",
                                  "1.9",
                                  "1.8",
                                  "1.7",
                                  "1.6"
                                ],
                            mavenAuthenticateFeed = predicates.isType '"Bool",
                            mavenDirectory = predicates.isType '"String",
                            mavenOptions = predicates.isType '"String",
                            mavenPomFile = predicates.isType '"String",
                            mavenSetM2Home = predicates.isType '"Bool",
                            mavenVersionOption = predicates.enum
                                [ "Default", "Path" ],
                            options = predicates.isType '"String",
                            pmdRunAnalysis = predicates.isType '"Bool",
                            publishJUnitResults = predicates.isType '"Bool",
                            sonarQubeRunAnalysis = predicates.isType '"Bool",
                            sqMavenPluginVersionChoice = predicates.enum
                                [ "latest", "pom" ],
                            testResultsFiles = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Maven@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            buildProperties = predicates.isType '"String",
                            command = predicates.enum
                                [
                                  "build",
                                  "push",
                                  "pack",
                                  "publish",
                                  "restore",
                                  "run",
                                  "test",
                                  "custom"
                                ],
                            configuration = predicates.isType '"String",
                            custom = predicates.isType '"String",
                            externalFeedCredentials = predicates.isType
                                '"String",
                            feedsToUse = predicates.enum [ "select", "config" ],
                            includeNuGetOrg = predicates.isType '"Bool",
                            includesource = predicates.isType '"Bool",
                            includesymbols = predicates.isType '"Bool",
                            majorVersion = predicates.isType '"String",
                            minorVersion = predicates.isType '"String",
                            modifyOutputPath = predicates.isType '"Bool",
                            noCache = predicates.isType '"Bool",
                            nobuild = predicates.isType '"Bool",
                            nuGetFeedType = predicates.enum
                                [ "internal", "external" ],
                            nugetConfigPath = predicates.isType '"String",
                            packDirectory = predicates.isType '"String",
                            packagesToPack = predicates.isType '"String",
                            packagesToPush = predicates.isType '"String",
                            patchVersion = predicates.isType '"String",
                            projects = predicates.isType '"String",
                            publishFeedCredentials = predicates.isType
                                '"String",
                            publishPackageMetadata = predicates.isType '"Bool",
                            publishTestResults = predicates.isType '"Bool",
                            publishVstsFeed = predicates.isType '"String",
                            publishWebProjects = predicates.isType '"Bool",
                            restoreArguments = predicates.isType '"String",
                            restoreDirectory = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                            verbosityPack = predicates.enum
                                [
                                  "-",
                                  "Quiet",
                                  "Minimal",
                                  "Normal",
                                  "Detailed",
                                  "Diagnostic"
                                ],
                            verbosityRestore = predicates.enum
                                [
                                  "-",
                                  "Quiet",
                                  "Minimal",
                                  "Normal",
                                  "Detailed",
                                  "Diagnostic"
                                ],
                            versionEnvVar = predicates.isType '"String",
                            versioningScheme = predicates.enum
                                [
                                  "off",
                                  "byPrereleaseNumber",
                                  "byEnvVar",
                                  "byBuildNumber"
                                ],
                            vstsFeed = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                            zipAfterPublish = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^DotNetCoreCLI@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            command = predicates.enum
                                [
                                  "build",
                                  "publish",
                                  "restore",
                                  "test",
                                  "run"
                                ],
                            projects = predicates.isType '"String",
                            publishWebProjects = predicates.isType '"Bool",
                            zipAfterPublish = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^DotNetCoreCLI@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            command = predicates.enum
                                [
                                  "build",
                                  "publish",
                                  "restore",
                                  "test",
                                  "run"
                                ],
                            projects = predicates.isType '"String",
                            publishWebProjects = predicates.isType '"Bool",
                            zipAfterPublish = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^DotNetCoreCLI@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "email", "password" ],
                            predicates.records.record
                            {
                              email = predicates.isType '"String",
                              password = predicates.isType '"String",
                              solutionFile = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^XamarinComponentRestore@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "ConnectedServiceName", "WebAppName" ],
                            predicates.records.record
                            {
                              AdditionalArguments = predicates.isType '"String",
                              ConnectedServiceName = predicates.isType
                                  '"String",
                              DeployToSlotFlag = predicates.isType '"Bool",
                              ExcludeFilesFromAppDataFlag = predicates.isType
                                  '"Bool",
                              Package = predicates.isType '"String",
                              RemoveAdditionalFilesFlag = predicates.isType
                                  '"Bool",
                              ResourceGroupName = predicates.isType '"String",
                              SetParametersFile = predicates.isType '"String",
                              SlotName = predicates.isType '"String",
                              TakeAppOfflineFlag = predicates.isType '"Bool",
                              UseWebDeploy = predicates.isType '"Bool",
                              VirtualApplication = predicates.isType '"String",
                              WebAppName = predicates.isType '"String",
                              WebAppUri = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureRmWebAppDeployment@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            AdditionalArguments = predicates.isType '"String",
                            AppSettings = predicates.isType '"String",
                            ConfigurationSettings = predicates.isType '"String",
                            ConnectionType = predicates.enum
                                [ "AzureRM", "PublishProfile" ],
                            DeploymentType = predicates.enum
                                [ "webDeploy", "zipDeploy", "runFromZip" ],
                            DockerImageTag = predicates.isType '"String",
                            DockerNamespace = predicates.isType '"String",
                            DockerRepository = predicates.isType '"String",
                            ExcludeFilesFromAppDataFlag = predicates.isType
                                '"Bool",
                            InlineScript = predicates.isType '"String",
                            JSONFiles = predicates.isType '"String",
                            PublishProfilePassword = predicates.isType
                                '"String",
                            PublishProfilePath = predicates.isType '"String",
                            RemoveAdditionalFilesFlag = predicates.isType
                                '"Bool",
                            RenameFilesFlag = predicates.isType '"Bool",
                            ResourceGroupName = predicates.isType '"String",
                            RuntimeStack = predicates.isType '"String",
                            RuntimeStackFunction = predicates.enum
                                [
                                  "DOTNET|2.2",
                                  "DOTNET|3.1",
                                  "JAVA|8",
                                  "JAVA|11",
                                  "NODE|8",
                                  "NODE|10",
                                  "NODE|12",
                                  "NODE|14",
                                  "PYTHON|3.6",
                                  "PYTHON|3.7",
                                  "PYTHON|3.8"
                                ],
                            ScriptPath = predicates.isType '"String",
                            ScriptType = predicates.enum
                                [ "", "Inline Script", "File Path" ],
                            SetParametersFile = predicates.isType '"String",
                            SlotName = predicates.isType '"String",
                            StartupCommand = predicates.isType '"String",
                            TakeAppOfflineFlag = predicates.isType '"Bool",
                            VirtualApplication = predicates.isType '"String",
                            WebAppName = predicates.isType '"String",
                            WebConfigParameters = predicates.isType '"String",
                            appType = predicates.enum
                                [
                                  "webApp",
                                  "webAppLinux",
                                  "webAppContainer",
                                  "webAppHyperVContainer",
                                  "functionApp",
                                  "functionAppLinux",
                                  "functionAppContainer",
                                  "apiApp",
                                  "mobileApp"
                                ],
                            azureSubscription = predicates.isType '"String",
                            deployToSlotOrASE = predicates.isType '"Bool",
                            enableCustomDeployment = predicates.isType '"Bool",
                            enableXmlTransform = predicates.isType '"Bool",
                            enableXmlVariableSubstitution = predicates.isType
                                '"Bool",
                            packageForLinux = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^AzureRmWebAppDeployment@4$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "WebAppName", "azureSubscription" ],
                            predicates.records.record
                            {
                              AdditionalArguments = predicates.isType '"String",
                              AppSettings = predicates.isType '"String",
                              AzureContainerRegistry = predicates.isType
                                  '"String",
                              AzureContainerRegistryImage = predicates.isType
                                  '"String",
                              AzureContainerRegistryLoginServer =
                                predicates.isType '"String",
                              AzureContainerRegistryTag = predicates.isType
                                  '"String",
                              ConfigurationSettings = predicates.isType
                                  '"String",
                              DeployToSlotFlag = predicates.isType '"Bool",
                              DockerImageTag = predicates.isType '"String",
                              DockerNamespace = predicates.isType '"String",
                              DockerRepository = predicates.isType '"String",
                              DockerRepositoryAccess = predicates.enum
                                  [ "private", "public" ],
                              ExcludeFilesFromAppDataFlag = predicates.isType
                                  '"Bool",
                              GenerateWebConfig = predicates.isType '"Bool",
                              ImageSource = predicates.enum
                                  [ "Registry", "Builtin" ],
                              InlineScript = predicates.isType '"String",
                              JSONFiles = predicates.isType '"String",
                              Package = predicates.isType '"String",
                              PrivateRegistryImage = predicates.isType
                                  '"String",
                              PrivateRegistryTag = predicates.isType '"String",
                              RemoveAdditionalFilesFlag = predicates.isType
                                  '"Bool",
                              RenameFilesFlag = predicates.isType '"Bool",
                              ResourceGroupName = predicates.isType '"String",
                              RuntimeStack = predicates.isType '"String",
                              ScriptPath = predicates.isType '"String",
                              ScriptType = predicates.enum
                                  [ "", "Inline Script", "File Path" ],
                              SetParametersFile = predicates.isType '"String",
                              SlotName = predicates.isType '"String",
                              StartupCommand = predicates.isType '"String",
                              TakeAppOfflineFlag = predicates.isType '"Bool",
                              UseWebDeploy = predicates.isType '"Bool",
                              VirtualApplication = predicates.isType '"String",
                              WebAppName = predicates.isType '"String",
                              WebAppUri = predicates.isType '"String",
                              WebConfigParameters = predicates.isType '"String",
                              appType = predicates.enum
                                  [
                                    "app",
                                    "applinux",
                                    "functionapp",
                                    "api",
                                    "mobileapp"
                                  ],
                              azureSubscription = predicates.isType '"String",
                              dockerRegistryConnection = predicates.isType
                                  '"String",
                              enableXmlTransform = predicates.isType '"Bool",
                              enableXmlVariableSubstitution = predicates.isType
                                  '"Bool",
                              packageForLinux = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureRmWebAppDeployment@3$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "Machines" ],
                            predicates.records.record
                            {
                              AuthenticationMechanism = predicates.enum
                                  [ "Default", "Credssp" ],
                              CommunicationProtocol = predicates.enum
                                  [ "Http", "Https" ],
                              ErrorActionPreference = predicates.enum
                                  [ "stop", "continue", "silentlyContinue" ],
                              InitializationScript = predicates.isType
                                  '"String",
                              InlineScript = predicates.isType '"String",
                              Machines = predicates.isType '"String",
                              NewPsSessionOptionArguments = predicates.isType
                                  '"String",
                              RunPowershellInParallel = predicates.isType
                                  '"Bool",
                              ScriptArguments = predicates.isType '"String",
                              ScriptPath = predicates.isType '"String",
                              ScriptType = predicates.enum
                                  [ "FilePath", "Inline" ],
                              SessionVariables = predicates.isType '"String",
                              UserName = predicates.isType '"String",
                              UserPassword = predicates.isType '"String",
                              WorkingDirectory = predicates.isType '"String",
                              failOnStderr = predicates.isType '"Bool",
                              ignoreLASTEXITCODE = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^PowerShellOnTargetMachines@3$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "EnvironmentName", "ScriptPath" ],
                            predicates.records.record
                            {
                              AdminPassword = predicates.isType '"String",
                              AdminUserName = predicates.isType '"String",
                              EnvironmentName = predicates.isType '"String",
                              InitializationScriptPath = predicates.isType
                                  '"String",
                              MachineNames = predicates.isType '"String",
                              Protocol = predicates.enum [ "Http", "Https" ],
                              ResourceFilteringMethod = predicates.enum
                                  [ "machineNames", "tags" ],
                              RunPowershellInParallel = predicates.isType
                                  '"Bool",
                              ScriptArguments = predicates.isType '"String",
                              ScriptPath = predicates.isType '"String",
                              SessionVariables = predicates.isType '"String",
                              TestCertificate = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^PowerShellOnTargetMachines@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "EnvironmentName", "ScriptPath" ],
                            predicates.records.record
                            {
                              AdminPassword = predicates.isType '"String",
                              AdminUserName = predicates.isType '"String",
                              EnvironmentName = predicates.isType '"String",
                              InitializationScriptPath = predicates.isType
                                  '"String",
                              MachineNames = predicates.isType '"String",
                              Protocol = predicates.enum [ "Http", "Https" ],
                              ResourceFilteringMethod = predicates.enum
                                  [ "machineNames", "tags" ],
                              RunPowershellInParallel = predicates.isType
                                  '"Bool",
                              ScriptArguments = predicates.isType '"String",
                              ScriptPath = predicates.isType '"String",
                              SessionVariables = predicates.isType '"String",
                              TestCertificate = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^PowerShellOnTargetMachines@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "summaryFileLocation" ],
                            predicates.records.record
                            {
                              additionalCodeCoverageFiles = predicates.isType
                                  '"String",
                              codeCoverageTool = predicates.enum
                                  [ "Cobertura", "JaCoCo" ],
                              failIfCoverageEmpty = predicates.isType '"Bool",
                              pathToSources = predicates.isType '"String",
                              reportDirectory = predicates.isType '"String",
                              summaryFileLocation = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^PublishCodeCoverageResults@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "summaryFileLocation" ],
                            predicates.records.record
                            {
                              failIfCoverageEmpty = predicates.isType '"Bool",
                              pathToSources = predicates.isType '"String",
                              summaryFileLocation = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^PublishCodeCoverageResults@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "dropLocation", "testMachineGroup" ],
                            predicates.records.record
                            {
                              autMachineGroup = predicates.isType '"String",
                              codeCoverageEnabled = predicates.isType '"Bool",
                              configuration = predicates.isType '"String",
                              customSlicingEnabled = predicates.isType '"Bool",
                              dropLocation = predicates.isType '"String",
                              overrideRunParams = predicates.isType '"String",
                              platform = predicates.isType '"String",
                              runSettingsFile = predicates.isType '"String",
                              sourcefilters = predicates.isType '"String",
                              testConfiguration = predicates.isType '"String",
                              testConfigurations = predicates.isType '"String",
                              testFilterCriteria = predicates.isType '"String",
                              testMachineGroup = predicates.isType '"String",
                              testPlan = predicates.isType '"String",
                              testRunTitle = predicates.isType '"String",
                              testSelection = predicates.enum
                                  [ "testAssembly", "testPlan" ],
                              testSuite = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^RunVisualStudioTestsusingTestAgent@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            emailRecipients = predicates.isType '"String",
                            instructions = predicates.isType '"String",
                            onTimeout = predicates.enum [ "reject", "resume" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^ManualIntervention@8$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            provProfileSecureFile = predicates.isType '"String",
                            provProfileSourceRepository = predicates.isType
                                '"String",
                            provisioningProfileLocation = predicates.enum
                                [ "secureFiles", "sourceRepository" ],
                            removeProfile = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^InstallAppleProvisioningProfile@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "provProfileSecureFile" ],
                            predicates.records.record
                            {
                              provProfileSecureFile = predicates.isType
                                  '"String",
                              removeProfile = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^InstallAppleProvisioningProfile@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record {  } {  } false
                          predicates.never,
                      task = predicates.strings.pattern "^SonarQubePostTest@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "packageDirectory", "pypiConnection" ],
                            predicates.records.record
                            {
                              alsoPublishWheel = predicates.isType '"Bool",
                              packageDirectory = predicates.isType '"String",
                              pypiConnection = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^PyPIPublisher@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "ConnectedServiceName", "ScriptPath" ],
                            predicates.records.record
                            {
                              ConnectedServiceName = predicates.isType
                                  '"String",
                              ScriptArguments = predicates.isType '"String",
                              ScriptPath = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^ChefKnife@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            goBin = predicates.isType '"String",
                            goPath = predicates.isType '"String",
                            version = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^GoTool@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "provisioningProfile" ],
                            predicates.records.record
                            {
                              appName = predicates.isType '"String",
                              appPath = predicates.isType '"String",
                              ipaName = predicates.isType '"String",
                              ipaPath = predicates.isType '"String",
                              provisioningProfile = predicates.isType '"String",
                              sdk = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^XcodePackageiOS@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            command = predicates.enum
                                [ "get", "build", "test", "custom" ],
                            customCommand = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Go@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record {  } {  } false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^PublishPipelineMetadata@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            action = predicates.enum
                                [
                                  "Build an image",
                                  "Tag images",
                                  "Push an image",
                                  "Push images",
                                  "Run an image",
                                  "Run a Docker command"
                                ],
                            addBaseImageData = predicates.isType '"Bool",
                            additionalImageTags = predicates.isType '"String",
                            azureContainerRegistry = predicates.isType
                                '"String",
                            azureSubscription = predicates.isType '"String",
                            buildArguments = predicates.isType '"String",
                            containerCommand = predicates.isType '"String",
                            containerName = predicates.isType '"String",
                            containerregistrytype = predicates.enum
                                [
                                  "Azure Container Registry",
                                  "Container Registry"
                                ],
                            context = predicates.isType '"String",
                            customCommand = predicates.isType '"String",
                            defaultContext = predicates.isType '"Bool",
                            detached = predicates.isType '"Bool",
                            dockerFile = predicates.isType '"String",
                            dockerHostEndpoint = predicates.isType '"String",
                            dockerRegistryConnection = predicates.isType
                                '"String",
                            enforceDockerNamingConvention = predicates.isType
                                '"Bool",
                            entrypoint = predicates.isType '"String",
                            envVars = predicates.isType '"String",
                            imageDigestFile = predicates.isType '"String",
                            imageName = predicates.isType '"String",
                            imageNamesPath = predicates.isType '"String",
                            includeLatestTag = predicates.isType '"Bool",
                            includeSourceTags = predicates.isType '"Bool",
                            memory = predicates.isType '"String",
                            ports = predicates.isType '"String",
                            qualifyImageName = predicates.isType '"Bool",
                            restartMaxRetries = predicates.isType '"String",
                            restartPolicy = predicates.enum
                                [
                                  "no",
                                  "onFailure",
                                  "always",
                                  "unlessStopped"
                                ],
                            volumes = predicates.isType '"String",
                            workDir = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Docker@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            addBaseImageData = predicates.isType '"Bool",
                            addDefaultLabels = predicates.isType '"Bool",
                            arguments = predicates.isType '"String",
                            azureContainerRegistry = predicates.isType
                                '"String",
                            azureSubscriptionEndpoint = predicates.isType
                                '"String",
                            buildContext = predicates.isType '"String",
                            command = predicates.enum
                                [
                                  "Build an image",
                                  "Tag image",
                                  "Push an image",
                                  "Run an image",
                                  "login",
                                  "logout"
                                ],
                            containerCommand = predicates.isType '"String",
                            containerName = predicates.isType '"String",
                            containerregistrytype = predicates.enum
                                [
                                  "Azure Container Registry",
                                  "Container Registry"
                                ],
                            dockerFile = predicates.isType '"String",
                            dockerHostEndpoint = predicates.isType '"String",
                            dockerRegistryEndpoint = predicates.isType
                                '"String",
                            enforceDockerNamingConvention = predicates.isType
                                '"Bool",
                            entrypointOverride = predicates.isType '"String",
                            envVars = predicates.isType '"String",
                            imageDigestFile = predicates.isType '"String",
                            imageName = predicates.isType '"String",
                            imageNamesPath = predicates.isType '"String",
                            includeLatestTag = predicates.isType '"Bool",
                            includeSourceTags = predicates.isType '"Bool",
                            maxRestartRetries = predicates.isType '"String",
                            memoryLimit = predicates.isType '"String",
                            ports = predicates.isType '"String",
                            pushMultipleImages = predicates.isType '"Bool",
                            qualifyImageName = predicates.isType '"Bool",
                            qualifySourceImageName = predicates.isType '"Bool",
                            restartPolicy = predicates.enum
                                [
                                  "no",
                                  "onFailure",
                                  "always",
                                  "unlessStopped"
                                ],
                            runInBackground = predicates.isType '"Bool",
                            tagMultipleImages = predicates.isType '"Bool",
                            useDefaultContext = predicates.isType '"Bool",
                            volumes = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Docker@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            Dockerfile = predicates.isType '"String",
                            addBaseImageData = predicates.isType '"Bool",
                            addPipelineData = predicates.isType '"Bool",
                            arguments = predicates.isType '"String",
                            buildContext = predicates.isType '"String",
                            command = predicates.enum
                                [
                                  "buildAndPush",
                                  "build",
                                  "push",
                                  "login",
                                  "logout",
                                  "start",
                                  "stop"
                                ],
                            container = predicates.isType '"String",
                            containerRegistry = predicates.isType '"String",
                            repository = predicates.isType '"String",
                            tags = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Docker@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "jobName", "serverEndpoint" ],
                            predicates.records.record
                            {
                              captureConsole = predicates.isType '"Bool",
                              capturePipeline = predicates.isType '"Bool",
                              isMultibranchJob = predicates.isType '"Bool",
                              jobName = predicates.isType '"String",
                              jobParameters = predicates.isType '"String",
                              multibranchPipelineBranch = predicates.isType
                                  '"String",
                              parameterizedJob = predicates.isType '"Bool",
                              serverEndpoint = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^JenkinsQueueJob@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "jobName", "serverEndpoint" ],
                            predicates.records.record
                            {
                              captureConsole = predicates.isType '"Bool",
                              capturePipeline = predicates.isType '"Bool",
                              delayBetweenRetries = predicates.isType '"String",
                              failOnUnstableResult = predicates.isType '"Bool",
                              isMultibranchJob = predicates.isType '"Bool",
                              isParameterizedJob = predicates.isType '"Bool",
                              jobName = predicates.isType '"String",
                              jobParameters = predicates.isType '"String",
                              multibranchPipelineBranch = predicates.isType
                                  '"String",
                              retryCount = predicates.isType '"String",
                              serverEndpoint = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^JenkinsQueueJob@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "rootDirectory" ],
                            predicates.records.record
                            {
                              clean = predicates.isType '"Bool",
                              cleanContents = predicates.isType '"Bool",
                              credentialsOption = predicates.enum
                                  [ "serviceEndpoint", "inputs" ],
                              customCmds = predicates.isType '"String",
                              enableUtf8 = predicates.isType '"Bool",
                              filePatterns = predicates.isType '"String",
                              password = predicates.isType '"String",
                              preservePaths = predicates.isType '"Bool",
                              remoteDirectory = predicates.isType '"String",
                              rootDirectory = predicates.isType '"String",
                              serverEndpoint = predicates.isType '"String",
                              serverUrl = predicates.isType '"String",
                              trustSSL = predicates.isType '"Bool",
                              username = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^FtpUpload@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "rootDirectory" ],
                            predicates.records.record
                            {
                              clean = predicates.isType '"Bool",
                              cleanContents = predicates.isType '"Bool",
                              credentialsOption = predicates.enum
                                  [ "serviceEndpoint", "inputs" ],
                              filePatterns = predicates.isType '"String",
                              overwrite = predicates.isType '"Bool",
                              password = predicates.isType '"String",
                              preservePaths = predicates.isType '"Bool",
                              remoteDirectory = predicates.isType '"String",
                              rootDirectory = predicates.isType '"String",
                              serverEndpoint = predicates.isType '"String",
                              serverUrl = predicates.isType '"String",
                              trustSSL = predicates.isType '"Bool",
                              username = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^FtpUpload@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "AdminPassword",
                              "AdminUserName",
                              "MachineNames",
                              "SourcePath",
                              "TargetPath"
                            ],
                            predicates.records.record
                            {
                              AdditionalArguments = predicates.isType '"String",
                              AdminPassword = predicates.isType '"String",
                              AdminUserName = predicates.isType '"String",
                              CleanTargetBeforeCopy = predicates.isType '"Bool",
                              CopyFilesInParallel = predicates.isType '"Bool",
                              MachineNames = predicates.isType '"String",
                              SourcePath = predicates.isType '"String",
                              TargetPath = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^WindowsMachineFileCopy@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "SourcePath", "TargetPath" ],
                            predicates.records.record
                            {
                              AdditionalArguments = predicates.isType '"String",
                              AdminPassword = predicates.isType '"String",
                              AdminUserName = predicates.isType '"String",
                              CleanTargetBeforeCopy = predicates.isType '"Bool",
                              CopyFilesInParallel = predicates.isType '"Bool",
                              EnvironmentName = predicates.isType '"String",
                              MachineNames = predicates.isType '"String",
                              ResourceFilteringMethod = predicates.enum
                                  [ "machineNames", "tags" ],
                              SourcePath = predicates.isType '"String",
                              TargetPath = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^WindowsMachineFileCopy@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            avdAbi = predicates.isType '"String",
                            avdForce = predicates.isType '"Bool",
                            avdName = predicates.isType '"String",
                            avdOptionalArgs = predicates.isType '"String",
                            createAvd = predicates.isType '"Bool",
                            deleteAvd = predicates.isType '"Bool",
                            emulatorDevice = predicates.isType '"String",
                            emulatorHeadless = predicates.isType '"Bool",
                            emulatorOptionalArgs = predicates.isType '"String",
                            emulatorTarget = predicates.isType '"String",
                            emulatorTimeout = predicates.isType '"String",
                            gradleArguments = predicates.isType '"String",
                            gradleProj = predicates.isType '"String",
                            gradleWrapper = predicates.isType '"String",
                            startEmulator = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^AndroidBuild@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            artifactFeed = predicates.isType '"String",
                            pythonUploadServiceConnection = predicates.isType
                                '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^TwineAuthenticate@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            artifactFeeds = predicates.isType '"String",
                            externalFeeds = predicates.isType '"String",
                            publishPackageMetadata = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^TwineAuthenticate@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "WebSiteName" ],
                            predicates.records.record
                            {
                              AdditionalArguments = predicates.isType '"String",
                              ExcludeFilesFromAppDataFlag = predicates.isType
                                  '"Bool",
                              JSONFiles = predicates.isType '"String",
                              Package = predicates.isType '"String",
                              RemoveAdditionalFilesFlag = predicates.isType
                                  '"Bool",
                              SetParametersFile = predicates.isType '"String",
                              TakeAppOfflineFlag = predicates.isType '"Bool",
                              VirtualApplication = predicates.isType '"String",
                              WebSiteName = predicates.isType '"String",
                              XmlTransformation = predicates.isType '"Bool",
                              XmlVariableSubstitution = predicates.isType
                                  '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^IISWebAppDeploymentOnMachineGroup@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            failOnStderr = predicates.isType '"Bool",
                            pythonInterpreter = predicates.isType '"String",
                            script = predicates.isType '"String",
                            scriptPath = predicates.isType '"String",
                            scriptSource = predicates.enum
                                [ "filePath", "inline" ],
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^PythonScript@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            helmVersionToInstall = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^HelmInstaller@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            checkLatestHelmVersion = predicates.isType '"Bool",
                            checkLatestKubectl = predicates.isType '"Bool",
                            helmVersion = predicates.isType '"String",
                            installKubectl = predicates.isType '"Bool",
                            kubectlVersion = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^HelmInstaller@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          { nodeVersion = predicates.enum [ "6", "10" ], }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^NodeTaskRunnerInstaller@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "email", "password" ],
                            predicates.records.record
                            {
                              action = predicates.enum
                                  [ "Activate", "Deactivate" ],
                              email = predicates.isType '"String",
                              password = predicates.isType '"String",
                              product = predicates.enum [ "MA", "MT", "MM" ],
                              timeout = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^XamarinLicense@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            forceReinstallCredentialProvider = predicates.isType
                                '"Bool",
                            nuGetServiceConnections = predicates.isType
                                '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^NuGetAuthenticate@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            forceReinstallCredentialProvider = predicates.isType
                                '"Bool",
                            nuGetServiceConnections = predicates.isType
                                '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^NuGetAuthenticate@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "packageName", "version" ],
                            predicates.records.record
                            {
                              externalFeedCredentials = predicates.isType
                                  '"String",
                              packageName = predicates.isType '"String",
                              restoreDirectory = predicates.isType '"String",
                              version = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^DownloadGitHubNugetPackage@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            artifactsFeeds = predicates.isType '"String",
                            mavenServiceConnections = predicates.isType
                                '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^MavenAuthenticate@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "resourceName" ],
                            predicates.records.record
                            {
                              baseEnvironmentName = predicates.isType '"String",
                              resourceName = predicates.isType '"String",
                              reviewResourceName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^ReviewApp@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "jdkArchitectureOption", "jdkSourceOption" ],
                            predicates.records.record
                            {
                              azureCommonVirtualFile = predicates.isType
                                  '"String",
                              azureContainerName = predicates.isType '"String",
                              azureResourceGroupName = predicates.isType
                                  '"String",
                              azureResourceManagerEndpoint = predicates.isType
                                  '"String",
                              azureStorageAccountName = predicates.isType
                                  '"String",
                              cleanDestinationDirectory = predicates.isType
                                  '"Bool",
                              createExtractDirectory = predicates.isType
                                  '"Bool",
                              jdkArchitectureOption = predicates.enum
                                  [ "x64", "x86" ],
                              jdkDestinationDirectory = predicates.isType
                                  '"String",
                              jdkFile = predicates.isType '"String",
                              jdkSourceOption = predicates.enum
                                  [
                                    "AzureStorage",
                                    "LocalDirectory",
                                    "PreInstalled"
                                  ],
                              versionSpec = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^JavaToolInstaller@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "Attributes",
                              "Environment",
                              "connectedServiceName"
                            ],
                            predicates.records.record
                            {
                              Attributes = predicates.isType '"String",
                              Environment = predicates.isType '"String",
                              chefWaitTime = predicates.isType '"String",
                              connectedServiceName = predicates.isType
                                  '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^Chef@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "appName", "appType", "connectedServiceNameARM" ],
                            predicates.records.record
                            {
                              appName = predicates.isType '"String",
                              appSettings = predicates.isType '"String",
                              appType = predicates.enum
                                  [ "functionApp", "functionAppLinux" ],
                              connectedServiceNameARM = predicates.isType
                                  '"String",
                              deployToSlotOrASE = predicates.isType '"Bool",
                              deploymentMethod = predicates.enum
                                  [ "auto", "zipDeploy", "runFromPackage" ],
                              package = predicates.isType '"String",
                              resourceGroupName = predicates.isType '"String",
                              runtimeStack = predicates.enum
                                  [
                                    "DOTNET|2.2",
                                    "DOTNET|3.1",
                                    "DOTNET|6.0",
                                    "DOTNET-ISOLATED|7.0",
                                    "JAVA|8",
                                    "JAVA|11",
                                    "NODE|8",
                                    "NODE|10",
                                    "NODE|12",
                                    "NODE|14",
                                    "NODE|16",
                                    "NODE|18",
                                    "PYTHON|3.6",
                                    "PYTHON|3.7",
                                    "PYTHON|3.8",
                                    "PYTHON|3.9",
                                    "PYTHON|3.10"
                                  ],
                              slotName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureFunctionApp@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "appName", "appType", "azureSubscription" ],
                            predicates.records.record
                            {
                              appName = predicates.isType '"String",
                              appSettings = predicates.isType '"String",
                              appType = predicates.enum
                                  [ "functionApp", "functionAppLinux" ],
                              azureSubscription = predicates.isType '"String",
                              configurationStrings = predicates.isType
                                  '"String",
                              customWebConfig = predicates.isType '"String",
                              deployToSlotOrASE = predicates.isType '"Bool",
                              deploymentMethod = predicates.enum
                                  [ "auto", "zipDeploy", "runFromPackage" ],
                              package = predicates.isType '"String",
                              resourceGroupName = predicates.isType '"String",
                              runtimeStack = predicates.enum
                                  [
                                    "DOTNET|2.2",
                                    "DOTNET|3.1",
                                    "DOTNET|6.0",
                                    "JAVA|8",
                                    "JAVA|11",
                                    "NODE|8",
                                    "NODE|10",
                                    "NODE|12",
                                    "NODE|14",
                                    "NODE|16",
                                    "PYTHON|3.6",
                                    "PYTHON|3.7",
                                    "PYTHON|3.8",
                                    "PYTHON|3.9"
                                  ],
                              slotName = predicates.isType '"String",
                              startUpCommand = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureFunctionApp@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "workingFile" ],
                            predicates.records.record
                            {
                              customEndpoint = predicates.isType '"String",
                              workingFile = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^npmAuthenticate@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            clean = predicates.isType '"Bool",
                            configuration = predicates.isType '"String",
                            createLogFile = predicates.isType '"Bool",
                            logFileVerbosity = predicates.enum
                                [
                                  "quiet",
                                  "minimal",
                                  "normal",
                                  "detailed",
                                  "diagnostic"
                                ],
                            logProjectEvents = predicates.isType '"Bool",
                            maximumCpuCount = predicates.isType '"Bool",
                            msbuildArchitecture = predicates.enum
                                [ "x86", "x64" ],
                            msbuildArguments = predicates.isType '"String",
                            msbuildLocation = predicates.isType '"String",
                            msbuildLocationMethod = predicates.enum
                                [ "version", "location" ],
                            msbuildVersion = predicates.enum
                                [
                                  "latest",
                                  "17.0",
                                  "16.0",
                                  "15.0",
                                  "14.0",
                                  "12.0",
                                  "4.0"
                                ],
                            platform = predicates.isType '"String",
                            restoreNugetPackages = predicates.isType '"Bool",
                            solution = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^MSBuild@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "ConnectedServiceName",
                              "azureResourceGroup",
                              "deployScriptPath",
                              "location",
                              "packagePath",
                              "storageAccountName"
                            ],
                            predicates.records.record
                            {
                              ConnectedServiceName = predicates.isType
                                  '"String",
                              additionalBuilderParameters = predicates.isType
                                  '"String",
                              azureResourceGroup = predicates.isType '"String",
                              baseImage = predicates.enum
                                  [
                                    "MicrosoftWindowsServer:WindowsServer:2012-R2-Datacenter:windows",
                                    "MicrosoftWindowsServer:WindowsServer:2016-Datacenter:windows",
                                    "MicrosoftWindowsServer:WindowsServer:2012-Datacenter:windows",
                                    "MicrosoftWindowsServer:WindowsServer:2008-R2-SP1:windows",
                                    "Canonical:UbuntuServer:14.04.4-LTS:linux",
                                    "Canonical:UbuntuServer:16.04-LTS:linux",
                                    "Canonical:UbuntuServer:18.04-LTS:linux",
                                    "RedHat:RHEL:7.2:linux",
                                    "RedHat:RHEL:6.8:linux",
                                    "OpenLogic:CentOS:7.2:linux",
                                    "OpenLogic:CentOS:6.8:linux",
                                    "credativ:Debian:8:linux",
                                    "credativ:Debian:7:linux",
                                    "SUSE:openSUSE-Leap:42.2:linux",
                                    "SUSE:SLES:12-SP2:linux",
                                    "SUSE:SLES:11-SP4:linux"
                                  ],
                              baseImageSource = predicates.enum
                                  [ "default", "customVhd" ],
                              customImageOSType = predicates.enum
                                  [ "windows", "linux" ],
                              customImageUrl = predicates.isType '"String",
                              customTemplateLocation = predicates.isType
                                  '"String",
                              customTemplateParameters = predicates.isType
                                  '"String",
                              deployScriptArguments = predicates.isType
                                  '"String",
                              deployScriptPath = predicates.isType '"String",
                              imageId = predicates.isType '"String",
                              imageUri = predicates.isType '"String",
                              isManagedImage = predicates.isType '"Bool",
                              location = predicates.isType '"String",
                              managedImageName = predicates.isType '"String",
                              packagePath = predicates.isType '"String",
                              packerVersion = predicates.isType '"String",
                              skipTempFileCleanupDuringVMDeprovision =
                                predicates.isType '"Bool",
                              storageAccountName = predicates.isType '"String",
                              templateType = predicates.enum
                                  [ "builtin", "custom" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^PackerBuild@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "ConnectedServiceName",
                              "azureResourceGroup",
                              "deployScriptPath",
                              "location",
                              "packagePath",
                              "storageAccountName"
                            ],
                            predicates.records.record
                            {
                              ConnectedServiceName = predicates.isType
                                  '"String",
                              additionalBuilderParameters = predicates.isType
                                  '"String",
                              azureResourceGroup = predicates.isType '"String",
                              baseImage = predicates.enum
                                  [
                                    "MicrosoftWindowsServer:WindowsServer:2012-R2-Datacenter:windows",
                                    "MicrosoftWindowsServer:WindowsServer:2016-Datacenter:windows",
                                    "MicrosoftWindowsServer:WindowsServer:2012-Datacenter:windows",
                                    "MicrosoftWindowsServer:WindowsServer:2008-R2-SP1:windows",
                                    "Canonical:UbuntuServer:14.04.4-LTS:linux",
                                    "Canonical:UbuntuServer:16.04-LTS:linux",
                                    "RedHat:RHEL:7.2:linux",
                                    "RedHat:RHEL:6.8:linux",
                                    "OpenLogic:CentOS:7.2:linux",
                                    "OpenLogic:CentOS:6.8:linux",
                                    "credativ:Debian:8:linux",
                                    "credativ:Debian:7:linux",
                                    "SUSE:openSUSE-Leap:42.2:linux",
                                    "SUSE:SLES:12-SP2:linux",
                                    "SUSE:SLES:11-SP4:linux"
                                  ],
                              baseImageSource = predicates.enum
                                  [ "default", "customVhd" ],
                              customImageOSType = predicates.enum
                                  [ "windows", "linux" ],
                              customImageUrl = predicates.isType '"String",
                              customTemplateLocation = predicates.isType
                                  '"String",
                              customTemplateParameters = predicates.isType
                                  '"String",
                              deployScriptArguments = predicates.isType
                                  '"String",
                              deployScriptPath = predicates.isType '"String",
                              imageUri = predicates.isType '"String",
                              location = predicates.isType '"String",
                              packagePath = predicates.isType '"String",
                              skipTempFileCleanupDuringVMDeprovision =
                                predicates.isType '"Bool",
                              storageAccountName = predicates.isType '"String",
                              templateType = predicates.enum
                                  [ "builtin", "custom" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^PackerBuild@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            buildProperties = predicates.isType '"String",
                            configurationToPack = predicates.isType '"String",
                            includeReferencedProjects = predicates.isType
                                '"Bool",
                            nuGetAdditionalArgs = predicates.isType '"String",
                            nuGetPath = predicates.isType '"String",
                            outputdir = predicates.isType '"String",
                            requestedMajorVersion = predicates.isType '"String",
                            requestedMinorVersion = predicates.isType '"String",
                            requestedPatchVersion = predicates.isType '"String",
                            searchPattern = predicates.isType '"String",
                            versionByBuild = predicates.enum
                                [
                                  "false",
                                  "byPrereleaseNumber",
                                  "byEnvVar",
                                  "true"
                                ],
                            versionEnvVar = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^NuGetPackager@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            checkLatestVersion = predicates.isType '"Bool",
                            version = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^DuffleInstaller@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "applicationPackagePath" ],
                            predicates.records.record
                            {
                              applicationPackagePath = predicates.isType
                                  '"String",
                              buildNumber = predicates.isType '"String",
                              compareType = predicates.enum
                                  [ "LastSuccessful", "Specific" ],
                              logAllChanges = predicates.isType '"Bool",
                              pkgArtifactName = predicates.isType '"String",
                              updateOnlyChanged = predicates.isType '"Bool",
                              versionBehavior = predicates.enum
                                  [ "Append", "Replace" ],
                              versionSuffix = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^ServiceFabricUpdateAppVersions@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "applicationPackagePath" ],
                            predicates.records.record
                            {
                              applicationPackagePath = predicates.isType
                                  '"String",
                              buildNumber = predicates.isType '"String",
                              compareType = predicates.enum
                                  [ "LastSuccessful", "Specific" ],
                              imageDigestsPath = predicates.isType '"String",
                              imageNamesPath = predicates.isType '"String",
                              logAllChanges = predicates.isType '"Bool",
                              overwriteExistingPkgArtifact = predicates.isType
                                  '"Bool",
                              pkgArtifactName = predicates.isType '"String",
                              updateOnlyChanged = predicates.isType '"Bool",
                              updateType = predicates.enum
                                  [
                                    "Manifest versions",
                                    "Docker image settings"
                                  ],
                              versionBehavior = predicates.enum
                                  [ "Append", "Replace" ],
                              versionSuffix = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^ServiceFabricUpdateManifests@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "ResourceGroupName", "connectedServiceNameARM" ],
                            predicates.records.record
                            {
                              ResourceGroupName = predicates.isType '"String",
                              alertRule = predicates.isType '"String",
                              alertState = predicates.enum
                                  [ "New", "Acknowledged", "Closed" ],
                              connectedServiceNameARM = predicates.isType
                                  '"String",
                              filterType = predicates.enum
                                  [ "resource", "alertrule", "none" ],
                              monitorCondition = predicates.enum
                                  [ "Fired ", "Resolved" ],
                              resource = predicates.isType '"String",
                              severity = predicates.enum
                                  [ "Sev0", "Sev1", "Sev2", "Sev3", "Sev4" ],
                              timeRange = predicates.enum
                                  [ "1h", "1d", "7d", "30d" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureMonitor@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "ResourceGroupName",
                              "alertRules",
                              "connectedServiceNameARM",
                              "resourceName"
                            ],
                            predicates.records.record
                            {
                              ResourceGroupName = predicates.isType '"String",
                              ResourceType = predicates.enum
                                  [
                                    "Microsoft.Insights/components",
                                    "Microsoft.Web/sites",
                                    "Microsoft.Storage/storageAccounts",
                                    "Microsoft.Compute/virtualMachines"
                                  ],
                              alertRules = predicates.isType '"String",
                              connectedServiceNameARM = predicates.isType
                                  '"String",
                              resourceName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureMonitor@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "Action",
                              "LoadBalancer",
                              "ResourceGroupName",
                              "azureSubscription"
                            ],
                            predicates.records.record
                            {
                              Action = predicates.enum
                                  [ "Disconnect", "Connect" ],
                              LoadBalancer = predicates.isType '"String",
                              ResourceGroupName = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureNLBManagement@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "TestDrop" ],
                            predicates.records.record
                            {
                              LoadTest = predicates.isType '"String",
                              TestDrop = predicates.isType '"String",
                              agentCount = predicates.enum
                                  [ "1", "2", "3", "4", "5" ],
                              connectedServiceName = predicates.isType
                                  '"String",
                              geoLocation = predicates.enum
                                  [
                                    "Default",
                                    "Australia East",
                                    "Australia Southeast",
                                    "Brazil South",
                                    "Central India",
                                    "Central US",
                                    "East Asia",
                                    "East US 2",
                                    "East US",
                                    "Japan East",
                                    "Japan West",
                                    "North Central US",
                                    "North Europe",
                                    "South Central US",
                                    "South India",
                                    "Southeast Asia",
                                    "West Europe",
                                    "West US"
                                  ],
                              machineType = predicates.enum [ "0", "2" ],
                              runDuration = predicates.enum
                                  [ "60", "120", "180", "240", "300" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^ApacheJMeterLoadTest@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            abortOnContainerExit = predicates.isType '"Bool",
                            action = predicates.enum
                                [
                                  "Build services",
                                  "Push services",
                                  "Run services",
                                  "Run a specific service",
                                  "Lock services",
                                  "Write service image digests",
                                  "Combine configuration",
                                  "Run a Docker Compose command"
                                ],
                            additionalDockerComposeFiles = predicates.isType
                                '"String",
                            additionalImageTags = predicates.isType '"String",
                            arguments = predicates.isType '"String",
                            azureContainerRegistry = predicates.isType
                                '"String",
                            azureSubscription = predicates.isType '"String",
                            baseResolveDirectory = predicates.isType '"String",
                            buildImages = predicates.isType '"Bool",
                            containerCommand = predicates.isType '"String",
                            containerName = predicates.isType '"String",
                            containerregistrytype = predicates.enum
                                [
                                  "Azure Container Registry",
                                  "Container Registry"
                                ],
                            currentWorkingDirectory = predicates.isType
                                '"String",
                            detached = predicates.isType '"Bool",
                            dockerComposeCommand = predicates.isType '"String",
                            dockerComposeFile = predicates.isType '"String",
                            dockerComposeFileArgs = predicates.isType '"String",
                            dockerComposePath = predicates.isType '"String",
                            dockerHostEndpoint = predicates.isType '"String",
                            dockerRegistryEndpoint = predicates.isType
                                '"String",
                            entrypoint = predicates.isType '"String",
                            imageDigestComposeFile = predicates.isType
                                '"String",
                            includeLatestTag = predicates.isType '"Bool",
                            includeSourceTags = predicates.isType '"Bool",
                            nopIfNoDockerComposeFile = predicates.isType
                                '"Bool",
                            outputDockerComposeFile = predicates.isType
                                '"String",
                            ports = predicates.isType '"String",
                            projectName = predicates.isType '"String",
                            qualifyImageNames = predicates.isType '"Bool",
                            removeBuildOptions = predicates.isType '"Bool",
                            requireAdditionalDockerComposeFiles =
                              predicates.isType '"Bool",
                            serviceName = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^DockerCompose@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "AlertRules",
                              "ResourceGroupName",
                              "ResourceName",
                              "azureSubscription"
                            ],
                            predicates.records.record
                            {
                              AlertRules = predicates.isType '"String",
                              NotifyEmails = predicates.isType '"String",
                              NotifyServiceOwners = predicates.isType '"Bool",
                              ResourceGroupName = predicates.isType '"String",
                              ResourceName = predicates.isType '"String",
                              ResourceType = predicates.enum
                                  [
                                    "Microsoft.Insights/components",
                                    "Microsoft.Web/sites",
                                    "Microsoft.Storage/storageAccounts",
                                    "Microsoft.Compute/virtualMachines"
                                  ],
                              azureSubscription = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureMonitorAlerts@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "appFile",
                              "devices",
                              "email",
                              "teamApiKey",
                              "testAssemblyDirectory"
                            ],
                            predicates.records.record
                            {
                              appFile = predicates.isType '"String",
                              devices = predicates.isType '"String",
                              dsymFile = predicates.isType '"String",
                              email = predicates.isType '"String",
                              localeOption = predicates.enum
                                  [
                                    "da_DK",
                                    "nl_NL",
                                    "en_GB",
                                    "en_US",
                                    "fr_FR",
                                    "de_DE",
                                    "ja_JP",
                                    "ru_RU",
                                    "es_MX",
                                    "es_ES",
                                    "user"
                                  ],
                              optionalArgs = predicates.isType '"String",
                              parallelizationOption = predicates.enum
                                  [ "none", "--fixture-chunk", "--test-chunk" ],
                              publishNUnitResults = predicates.isType '"Bool",
                              series = predicates.isType '"String",
                              teamApiKey = predicates.isType '"String",
                              testAssemblyDirectory = predicates.isType
                                  '"String",
                              testCloudFile = predicates.isType '"String",
                              userDefinedLocale = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^XamarinTestCloud@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "applicationPackagePath",
                              "serviceConnectionName"
                            ],
                            predicates.records.record
                            {
                              ConsiderWarningAsError = predicates.isType
                                  '"Bool",
                              DefaultServiceTypeHealthPolicy = predicates.isType
                                  '"String",
                              FailureAction = predicates.enum
                                  [ "Rollback", "Manual" ],
                              ForceRestart = predicates.isType '"Bool",
                              HealthCheckRetryTimeoutSec = predicates.isType
                                  '"String",
                              HealthCheckStableDurationSec = predicates.isType
                                  '"String",
                              HealthCheckWaitDurationSec = predicates.isType
                                  '"String",
                              MaxPercentUnhealthyDeployedApplications =
                                predicates.isType '"String",
                              ServiceTypeHealthPolicyMap = predicates.isType
                                  '"String",
                              TimeoutSec = predicates.isType '"String",
                              UpgradeDomainTimeoutSec = predicates.isType
                                  '"String",
                              UpgradeReplicaSetCheckTimeoutSec =
                                predicates.isType '"String",
                              UpgradeTimeoutSec = predicates.isType '"String",
                              applicationPackagePath = predicates.isType
                                  '"String",
                              applicationParameterPath = predicates.isType
                                  '"String",
                              azureSubscription = predicates.isType '"String",
                              compressPackage = predicates.isType '"Bool",
                              configureDockerSettings = predicates.isType
                                  '"Bool",
                              copyPackageTimeoutSec = predicates.isType
                                  '"String",
                              dockerRegistryConnection = predicates.isType
                                  '"String",
                              isUpgrade = predicates.isType '"Bool",
                              overrideApplicationParameter = predicates.isType
                                  '"Bool",
                              overridePublishProfileSettings = predicates.isType
                                  '"Bool",
                              overwriteBehavior = predicates.enum
                                  [
                                    "Always",
                                    "Never",
                                    "SameAppTypeAndVersion"
                                  ],
                              passwordEncrypted = predicates.isType '"Bool",
                              publishProfilePath = predicates.isType '"String",
                              registerPackageTimeoutSec = predicates.isType
                                  '"String",
                              registryCredentials = predicates.enum
                                  [
                                    "AzureResourceManagerEndpoint",
                                    "ContainerRegistryEndpoint",
                                    "UsernamePassword"
                                  ],
                              registryPassword = predicates.isType '"String",
                              registryUserName = predicates.isType '"String",
                              serviceConnectionName = predicates.isType
                                  '"String",
                              skipPackageValidation = predicates.isType '"Bool",
                              skipUpgradeSameTypeAndVersion = predicates.isType
                                  '"Bool",
                              unregisterUnusedVersions = predicates.isType
                                  '"Bool",
                              upgradeMode = predicates.enum
                                  [
                                    "Monitored",
                                    "UnmonitoredAuto",
                                    "UnmonitoredManual"
                                  ],
                              useDiffPackage = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^ServiceFabricDeploy@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            actions = predicates.isType '"String",
                            archivePath = predicates.isType '"String",
                            args = predicates.isType '"String",
                            configuration = predicates.isType '"String",
                            destinationDevices = predicates.isType '"String",
                            destinationPlatform = predicates.isType '"String",
                            destinationPlatformOption = predicates.enum
                                [ "default", "iOS", "tvOS", "macOS", "custom" ],
                            destinationSimulators = predicates.isType '"String",
                            destinationTypeOption = predicates.enum
                                [ "simulators", "devices" ],
                            exportArgs = predicates.isType '"String",
                            exportMethod = predicates.isType '"String",
                            exportOptions = predicates.enum
                                [ "auto", "plist", "specify" ],
                            exportOptionsPlist = predicates.isType '"String",
                            exportPath = predicates.isType '"String",
                            exportTeamId = predicates.isType '"String",
                            packageApp = predicates.isType '"Bool",
                            provisioningProfileName = predicates.isType
                                '"String",
                            provisioningProfileUuid = predicates.isType
                                '"String",
                            publishJUnitResults = predicates.isType '"Bool",
                            scheme = predicates.isType '"String",
                            sdk = predicates.isType '"String",
                            signingIdentity = predicates.isType '"String",
                            signingOption = predicates.enum
                                [ "nosign", "default", "manual", "auto" ],
                            teamId = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                            useXcpretty = predicates.isType '"Bool",
                            workingDirectory = predicates.isType '"String",
                            xcWorkspacePath = predicates.isType '"String",
                            xcodeDeveloperDir = predicates.isType '"String",
                            xcodeVersion = predicates.enum
                                [
                                  "8",
                                  "9",
                                  "10",
                                  "11",
                                  "12",
                                  "13",
                                  "default",
                                  "specifyPath"
                                ],
                            xcprettyArgs = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Xcode@5$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            actions = predicates.isType '"String",
                            archivePath = predicates.isType '"String",
                            args = predicates.isType '"String",
                            configuration = predicates.isType '"String",
                            cwd = predicates.isType '"String",
                            defaultKeychainPassword = predicates.isType
                                '"String",
                            exportArgs = predicates.isType '"String",
                            exportMethod = predicates.isType '"String",
                            exportOptions = predicates.enum
                                [ "auto", "plist", "specify" ],
                            exportOptionsPlist = predicates.isType '"String",
                            exportPath = predicates.isType '"String",
                            exportTeamId = predicates.isType '"String",
                            iosSigningIdentity = predicates.isType '"String",
                            outputPattern = predicates.isType '"String",
                            p12 = predicates.isType '"String",
                            p12pwd = predicates.isType '"String",
                            packageApp = predicates.isType '"Bool",
                            provProfile = predicates.isType '"String",
                            provProfileUuid = predicates.isType '"String",
                            publishJUnitResults = predicates.isType '"Bool",
                            removeProfile = predicates.isType '"Bool",
                            scheme = predicates.isType '"String",
                            sdk = predicates.isType '"String",
                            signMethod = predicates.enum [ "file", "id" ],
                            teamId = predicates.isType '"String",
                            unlockDefaultKeychain = predicates.isType '"Bool",
                            useXcpretty = predicates.isType '"Bool",
                            xcWorkspacePath = predicates.isType '"String",
                            xcode8AutomaticSigning = predicates.isType '"Bool",
                            xcodeDeveloperDir = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Xcode@3$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            actions = predicates.isType '"String",
                            archivePath = predicates.isType '"String",
                            args = predicates.isType '"String",
                            configuration = predicates.isType '"String",
                            destinationDevices = predicates.isType '"String",
                            destinationPlatform = predicates.isType '"String",
                            destinationPlatformOption = predicates.enum
                                [ "default", "iOS", "tvOS", "macOS", "custom" ],
                            destinationSimulators = predicates.isType '"String",
                            destinationTypeOption = predicates.enum
                                [ "simulators", "devices" ],
                            exportArgs = predicates.isType '"String",
                            exportMethod = predicates.isType '"String",
                            exportOptions = predicates.enum
                                [ "auto", "plist", "specify" ],
                            exportOptionsPlist = predicates.isType '"String",
                            exportPath = predicates.isType '"String",
                            exportTeamId = predicates.isType '"String",
                            outputPattern = predicates.isType '"String",
                            packageApp = predicates.isType '"Bool",
                            provisioningProfileUuid = predicates.isType
                                '"String",
                            publishJUnitResults = predicates.isType '"Bool",
                            scheme = predicates.isType '"String",
                            sdk = predicates.isType '"String",
                            signingIdentity = predicates.isType '"String",
                            signingOption = predicates.enum
                                [ "nosign", "default", "manual", "auto" ],
                            teamId = predicates.isType '"String",
                            useXcpretty = predicates.isType '"Bool",
                            workingDirectory = predicates.isType '"String",
                            xcWorkspacePath = predicates.isType '"String",
                            xcodeDeveloperDir = predicates.isType '"String",
                            xcodeVersion = predicates.enum
                                [ "8", "9", "default", "specifyPath" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Xcode@4$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            actions = predicates.isType '"String",
                            archivePath = predicates.isType '"String",
                            args = predicates.isType '"String",
                            configuration = predicates.isType '"String",
                            cwd = predicates.isType '"String",
                            defaultKeychainPassword = predicates.isType
                                '"String",
                            exportMethod = predicates.isType '"String",
                            exportOptions = predicates.enum
                                [ "auto", "plist", "specify" ],
                            exportOptionsPlist = predicates.isType '"String",
                            exportPath = predicates.isType '"String",
                            exportTeamId = predicates.isType '"String",
                            iosSigningIdentity = predicates.isType '"String",
                            outputPattern = predicates.isType '"String",
                            p12 = predicates.isType '"String",
                            p12pwd = predicates.isType '"String",
                            packageApp = predicates.isType '"Bool",
                            packageTool = predicates.enum
                                [ "xcrun", "xcodebuild" ],
                            provProfile = predicates.isType '"String",
                            provProfileUuid = predicates.isType '"String",
                            publishJUnitResults = predicates.isType '"Bool",
                            removeProfile = predicates.isType '"Bool",
                            scheme = predicates.isType '"String",
                            sdk = predicates.isType '"String",
                            signMethod = predicates.enum [ "file", "id" ],
                            teamId = predicates.isType '"String",
                            unlockDefaultKeychain = predicates.isType '"Bool",
                            useXcpretty = predicates.isType '"Bool",
                            useXctool = predicates.isType '"Bool",
                            xcWorkspacePath = predicates.isType '"String",
                            xcode8AutomaticSigning = predicates.isType '"Bool",
                            xcodeDeveloperDir = predicates.isType '"String",
                            xctoolReporter = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Xcode@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            connectedServiceName = predicates.isType '"String",
                            continueOnEmptyNupkgMatch = predicates.isType
                                '"Bool",
                            feedName = predicates.isType '"String",
                            nuGetAdditionalArgs = predicates.isType '"String",
                            nuGetFeedType = predicates.enum
                                [ "external", "internal" ],
                            nuGetPath = predicates.isType '"String",
                            nuGetVersion = predicates.enum
                                [
                                  "3.3.0",
                                  "3.5.0.1829",
                                  "4.0.0.2283",
                                  "custom"
                                ],
                            searchPattern = predicates.isType '"String",
                            verbosity = predicates.enum
                                [ "-", "Quiet", "Normal", "Detailed" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^NuGetPublisher@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "queryId" ],
                            predicates.records.record
                            {
                              maxThreshold = predicates.isType '"String",
                              minThreshold = predicates.isType '"String",
                              queryId = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^queryWorkItems@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "appName", "azureSubscription" ],
                            predicates.records.record
                            {
                              appName = predicates.isType '"String",
                              appSettings = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                              configurationStrings = predicates.isType
                                  '"String",
                              containerCommand = predicates.isType '"String",
                              containers = predicates.isType '"String",
                              deployToSlotOrASE = predicates.isType '"Bool",
                              multicontainerConfigFile = predicates.isType
                                  '"String",
                              resourceGroupName = predicates.isType '"String",
                              slotName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureWebAppContainer@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            AdditionalArguments = predicates.isType '"String",
                            AdditionalArgumentsSql = predicates.isType
                                '"String",
                            AppLockName = predicates.isType '"String",
                            AuthScheme = predicates.enum
                                [
                                  "windowsAuthentication",
                                  "sqlServerAuthentication"
                                ],
                            ConnectionString = predicates.isType '"String",
                            DacpacFile = predicates.isType '"String",
                            DatabaseName = predicates.isType '"String",
                            ExclusiveLock = predicates.isType '"Bool",
                            ExecuteInTransaction = predicates.isType '"Bool",
                            InlineSql = predicates.isType '"String",
                            PublishProfile = predicates.isType '"String",
                            ServerName = predicates.isType '"String",
                            SqlFile = predicates.isType '"String",
                            SqlPassword = predicates.isType '"String",
                            SqlUsername = predicates.isType '"String",
                            TargetMethod = predicates.enum
                                [
                                  "server",
                                  "connectionString",
                                  "publishProfile"
                                ],
                            TaskType = predicates.enum
                                [ "dacpac", "sqlQuery", "sqlInline" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^SqlDacpacDeploymentOnMachineGroup@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "key", "path" ],
                            predicates.records.record
                            {
                              cacheHitVar = predicates.isType '"String",
                              key = predicates.isType '"String",
                              path = predicates.isType '"String",
                              restoreKeys = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^CacheBeta@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "key", "path" ],
                            predicates.records.record
                            {
                              cacheHitVar = predicates.isType '"String",
                              key = predicates.isType '"String",
                              path = predicates.isType '"String",
                              restoreKeys = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^Cache@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "key", "path" ],
                            predicates.records.record
                            {
                              cacheHitVar = predicates.isType '"String",
                              key = predicates.isType '"String",
                              path = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^CacheBeta@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            cmakeArgs = predicates.isType '"String",
                            runInsideShell = predicates.isType '"Bool",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^CMake@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "appFile" ],
                            predicates.records.record
                            {
                              appFile = predicates.isType '"String",
                              appSlug = predicates.isType '"String",
                              appiumBuildDirectory = predicates.isType
                                  '"String",
                              artifactsDirectory = predicates.isType '"String",
                              calabashConfigFile = predicates.isType '"String",
                              calabashProfile = predicates.isType '"String",
                              calabashProjectDirectory = predicates.isType
                                  '"String",
                              calabashSkipConfigCheck = predicates.isType
                                  '"Bool",
                              cliFile = predicates.isType '"String",
                              credentialsOption = predicates.enum
                                  [ "serviceEndpoint", "inputs" ],
                              devices = predicates.isType '"String",
                              dsymDirectory = predicates.isType '"String",
                              espressoBuildDirectory = predicates.isType
                                  '"String",
                              espressoTestApkFile = predicates.isType '"String",
                              frameworkOption = predicates.enum
                                  [
                                    "appium",
                                    "espresso",
                                    "calabash",
                                    "uitest",
                                    "xcuitest"
                                  ],
                              localeOption = predicates.enum
                                  [
                                    "da_DK",
                                    "nl_NL",
                                    "en_GB",
                                    "en_US",
                                    "fr_FR",
                                    "de_DE",
                                    "ja_JP",
                                    "ru_RU",
                                    "es_MX",
                                    "es_ES",
                                    "user"
                                  ],
                              loginOptions = predicates.isType '"String",
                              password = predicates.isType '"String",
                              prepareOptions = predicates.isType '"String",
                              prepareTests = predicates.isType '"Bool",
                              runOptions = predicates.isType '"String",
                              runTests = predicates.isType '"Bool",
                              series = predicates.isType '"String",
                              serverEndpoint = predicates.isType '"String",
                              showDebugOutput = predicates.isType '"Bool",
                              signInfo = predicates.isType '"String",
                              skipWaitingForResults = predicates.isType '"Bool",
                              uiTestBuildDirectory = predicates.isType
                                  '"String",
                              uiTestKeyPassword = predicates.isType '"String",
                              uiTestStorePassword = predicates.isType '"String",
                              uiTestToolsDirectory = predicates.isType
                                  '"String",
                              uitestKeyAlias = predicates.isType '"String",
                              uitestStorePath = predicates.isType '"String",
                              userDefinedLocale = predicates.isType '"String",
                              username = predicates.isType '"String",
                              xcUITestBuildDirectory = predicates.isType
                                  '"String",
                              xcUITestIpaFile = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AppCenterTest@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "app" ],
                            predicates.records.record
                            {
                              app = predicates.isType '"String",
                              appSlug = predicates.isType '"String",
                              appiumBuildDir = predicates.isType '"String",
                              artifactsDir = predicates.isType '"String",
                              async = predicates.isType '"Bool",
                              calabashConfigFile = predicates.isType '"String",
                              calabashProfile = predicates.isType '"String",
                              calabashProjectDir = predicates.isType '"String",
                              calabashSkipConfigCheck = predicates.isType
                                  '"Bool",
                              cliLocationOverride = predicates.isType '"String",
                              credsType = predicates.enum
                                  [ "serviceEndpoint", "inputs" ],
                              debug = predicates.isType '"Bool",
                              devices = predicates.isType '"String",
                              dsymDir = predicates.isType '"String",
                              enablePrepare = predicates.isType '"Bool",
                              enableRun = predicates.isType '"Bool",
                              espressoBuildDir = predicates.isType '"String",
                              espressoTestApkPath = predicates.isType '"String",
                              framework = predicates.enum
                                  [
                                    "appium",
                                    "espresso",
                                    "calabash",
                                    "uitest",
                                    "xcuitest"
                                  ],
                              locale = predicates.enum
                                  [
                                    "da_DK",
                                    "nl_NL",
                                    "en_GB",
                                    "en_US",
                                    "fr_FR",
                                    "de_DE",
                                    "ja_JP",
                                    "ru_RU",
                                    "es_MX",
                                    "es_ES",
                                    "user"
                                  ],
                              loginOpts = predicates.isType '"String",
                              password = predicates.isType '"String",
                              prepareOpts = predicates.isType '"String",
                              runOpts = predicates.isType '"String",
                              series = predicates.isType '"String",
                              serverEndpoint = predicates.isType '"String",
                              signInfo = predicates.isType '"String",
                              uitestBuildDir = predicates.isType '"String",
                              uitestKeyAlias = predicates.isType '"String",
                              uitestKeyPass = predicates.isType '"String",
                              uitestStoreFile = predicates.isType '"String",
                              uitestStorePass = predicates.isType '"String",
                              uitestToolsDir = predicates.isType '"String",
                              userDefinedLocale = predicates.isType '"String",
                              username = predicates.isType '"String",
                              xcuitestBuildDir = predicates.isType '"String",
                              xcuitestTestIpaPath = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^VSMobileCenterTest@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "secureFile" ],
                            predicates.records.record
                            {
                              retryCount = predicates.isType '"String",
                              secureFile = predicates.isType '"String",
                              socketTimeout = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^DownloadSecureFile@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "azureSubscription" ],
                            predicates.records.record
                            {
                              acrName = predicates.isType '"String",
                              acrPassword = predicates.isType '"String",
                              acrUsername = predicates.isType '"String",
                              appSourcePath = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                              containerAppEnvironment = predicates.isType
                                  '"String",
                              containerAppName = predicates.isType '"String",
                              disableTelemetry = predicates.isType '"Bool",
                              dockerfilePath = predicates.isType '"String",
                              environmentVariables = predicates.isType
                                  '"String",
                              imageToBuild = predicates.isType '"String",
                              imageToDeploy = predicates.isType '"String",
                              ingress = predicates.isType '"String",
                              location = predicates.isType '"String",
                              resourceGroup = predicates.isType '"String",
                              runtimeStack = predicates.isType '"String",
                              targetPort = predicates.isType '"String",
                              workingDirectory = predicates.isType '"String",
                              yamlConfigPath = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureContainerApps@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "azureSubscription" ],
                            predicates.records.record
                            {
                              acrName = predicates.isType '"String",
                              acrPassword = predicates.isType '"String",
                              acrUsername = predicates.isType '"String",
                              appSourcePath = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                              containerAppEnvironment = predicates.isType
                                  '"String",
                              containerAppName = predicates.isType '"String",
                              disableTelemetry = predicates.isType '"Bool",
                              dockerfilePath = predicates.isType '"String",
                              environmentVariables = predicates.isType
                                  '"String",
                              imageToBuild = predicates.isType '"String",
                              imageToDeploy = predicates.isType '"String",
                              ingress = predicates.isType '"String",
                              location = predicates.isType '"String",
                              resourceGroup = predicates.isType '"String",
                              runtimeStack = predicates.isType '"String",
                              targetPort = predicates.isType '"String",
                              workingDirectory = predicates.isType '"String",
                              yamlConfigPath = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureContainerApps@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            addToPath = predicates.isType '"Bool",
                            versionSpec = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^UseRubyVersion@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            enableCodeCoverage = predicates.isType '"Bool",
                            gruntCli = predicates.isType '"String",
                            gruntFile = predicates.isType '"String",
                            publishJUnitResults = predicates.isType '"Bool",
                            srcFiles = predicates.isType '"String",
                            targets = predicates.isType '"String",
                            testFiles = predicates.isType '"String",
                            testFramework = predicates.enum
                                [ "Mocha", "Jasmine" ],
                            testResultsFiles = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Grunt@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            AdditionalArguments = predicates.isType '"String",
                            AuthenticationType = predicates.enum
                                [
                                  "server",
                                  "aadAuthenticationPassword",
                                  "aadAuthenticationIntegrated",
                                  "connectionString",
                                  "servicePrincipal"
                                ],
                            BacpacFile = predicates.isType '"String",
                            ConnectionString = predicates.isType '"String",
                            DacpacFile = predicates.isType '"String",
                            DatabaseName = predicates.isType '"String",
                            DeleteFirewallRule = predicates.isType '"Bool",
                            DeploymentAction = predicates.enum
                                [
                                  "Publish",
                                  "Extract",
                                  "Export",
                                  "Import",
                                  "Script",
                                  "DriftReport",
                                  "DeployReport"
                                ],
                            EndIpAddress = predicates.isType '"String",
                            InlineAdditionalArguments = predicates.isType
                                '"String",
                            IpDetectionMethod = predicates.enum
                                [ "AutoDetect", "IPAddressRange" ],
                            PublishProfile = predicates.isType '"String",
                            ServerName = predicates.isType '"String",
                            SqlAdditionalArguments = predicates.isType
                                '"String",
                            SqlFile = predicates.isType '"String",
                            SqlInline = predicates.isType '"String",
                            SqlPassword = predicates.isType '"String",
                            SqlUsername = predicates.isType '"String",
                            StartIpAddress = predicates.isType '"String",
                            aadSqlPassword = predicates.isType '"String",
                            aadSqlUsername = predicates.isType '"String",
                            azureClassicSubscription = predicates.isType
                                '"String",
                            azureConnectionType = predicates.enum
                                [
                                  "ConnectedServiceName",
                                  "ConnectedServiceNameARM"
                                ],
                            azureSubscription = predicates.isType '"String",
                            deployType = predicates.enum
                                [ "DacpacTask", "SqlTask", "InlineSqlTask" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^SqlAzureDacpacDeployment@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "configFile",
                              "dockerRegistryServiceConnection",
                              "repository"
                            ],
                            predicates.records.record
                            {
                              configFile = predicates.isType '"String",
                              dockerRegistryServiceConnection =
                                predicates.isType '"String",
                              failTaskOnFailedTests = predicates.isType '"Bool",
                              repository = predicates.isType '"String",
                              tag = predicates.isType '"String",
                              testRunTitle = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^ContainerStructureTest@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "EnvironmentName", "WebDeployPackage" ],
                            predicates.records.record
                            {
                              AddBinding = predicates.isType '"Bool",
                              AdminPassword = predicates.isType '"String",
                              AdminUserName = predicates.isType '"String",
                              AppCmdCommands = predicates.isType '"String",
                              AppPoolIdentity = predicates.enum
                                  [
                                    "ApplicationPoolIdentity",
                                    "LocalService",
                                    "LocalSystem",
                                    "NetworkService",
                                    "SpecificUser"
                                  ],
                              AppPoolName = predicates.isType '"String",
                              AppPoolPassword = predicates.isType '"String",
                              AppPoolUsername = predicates.isType '"String",
                              AssignDuplicateBinding = predicates.isType
                                  '"Bool",
                              CreateAppPool = predicates.isType '"Bool",
                              CreateWebSite = predicates.isType '"Bool",
                              DeployInParallel = predicates.isType '"Bool",
                              DotNetVersion = predicates.enum
                                  [ "v4.0", "v2.0", "No Managed Code" ],
                              EnvironmentName = predicates.isType '"String",
                              HostNameWithHttp = predicates.isType '"String",
                              HostNameWithOutSNI = predicates.isType '"String",
                              HostNameWithSNI = predicates.isType '"String",
                              IPAddress = predicates.isType '"String",
                              MachineFilter = predicates.isType '"String",
                              OverRideParams = predicates.isType '"String",
                              PipeLineMode = predicates.enum
                                  [ "Integrated", "Classic" ],
                              Port = predicates.isType '"String",
                              Protocol = predicates.enum [ "https", "http" ],
                              ResourceFilteringMethod = predicates.enum
                                  [ "machineNames", "tags" ],
                              SSLCertThumbPrint = predicates.isType '"String",
                              ServerNameIndication = predicates.isType '"Bool",
                              TestCertificate = predicates.isType '"Bool",
                              WebDeployPackage = predicates.isType '"String",
                              WebDeployParamFile = predicates.isType '"String",
                              WebSiteAuthUserName = predicates.isType '"String",
                              WebSiteAuthUserPassword = predicates.isType
                                  '"String",
                              WebSiteName = predicates.isType '"String",
                              WebSitePhysicalPath = predicates.isType '"String",
                              WebSitePhysicalPathAuth = predicates.enum
                                  [
                                    "WebSiteUserPassThrough",
                                    "WebSiteWindowsAuth"
                                  ],
                              WinRMProtocol = predicates.enum
                                  [ "Http", "Https" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^IISWebAppDeployment@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "LoadTest" ],
                            predicates.records.record
                            {
                              LoadTest = predicates.isType '"String",
                              MachineType = predicates.enum [ "0", "2" ],
                              TestDrop = predicates.isType '"String",
                              TestSettings = predicates.isType '"String",
                              ThresholdLimit = predicates.isType '"String",
                              activeRunSettings = predicates.enum
                                  [ "useFile", "changeActive" ],
                              connectedServiceName = predicates.isType
                                  '"String",
                              numOfSelfProvisionedAgents = predicates.isType
                                  'Integer,
                              resourceGroupName = predicates.isType '"String",
                              runSettingName = predicates.isType '"String",
                              testContextParameters = predicates.isType
                                  '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^CloudLoadTest@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          { kubectlVersion = predicates.isType '"String", }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^KubectlInstaller@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "filename" ],
                            predicates.records.record
                            {
                              arguments = predicates.isType '"String",
                              failOnStandardError = predicates.isType '"Bool",
                              filename = predicates.isType '"String",
                              workingFolder = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^CmdLine@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            failOnStderr = predicates.isType '"Bool",
                            script = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^CmdLine@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "command" ],
                            predicates.records.record
                            {
                              arguments = predicates.isType '"String",
                              command = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^NuGet@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            Dockerfile = predicates.isType '"String",
                            buildContext = predicates.isType '"String",
                            dockerRegistryServiceConnection = predicates.isType
                                '"String",
                            repository = predicates.isType '"String",
                            tags = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^ContainerBuild@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            feed = predicates.isType '"String",
                            includeNuGetOrg = predicates.isType '"Bool",
                            noCache = predicates.isType '"Bool",
                            nugetConfigPath = predicates.isType '"String",
                            packagesDirectory = predicates.isType '"String",
                            selectOrConfig = predicates.enum
                                [ "select", "config" ],
                            solution = predicates.isType '"String",
                            verbosity = predicates.enum
                                [ "-", "Quiet", "Normal", "Detailed" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^NuGetRestore@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            allowPackageConflicts = predicates.isType '"Bool",
                            arguments = predicates.isType '"String",
                            basePath = predicates.isType '"String",
                            buildProperties = predicates.isType '"String",
                            command = predicates.enum
                                [ "restore", "pack", "push", "custom" ],
                            configuration = predicates.isType '"String",
                            disableParallelProcessing = predicates.isType
                                '"Bool",
                            externalFeedCredentials = predicates.isType
                                '"String",
                            feedsToUse = predicates.enum [ "select", "config" ],
                            includeNuGetOrg = predicates.isType '"Bool",
                            includeReferencedProjects = predicates.isType
                                '"Bool",
                            includeSymbols = predicates.isType '"Bool",
                            majorVersion = predicates.isType '"String",
                            minorVersion = predicates.isType '"String",
                            noCache = predicates.isType '"Bool",
                            nuGetFeedType = predicates.enum
                                [ "internal", "external" ],
                            nugetConfigPath = predicates.isType '"String",
                            packDestination = predicates.isType '"String",
                            packTimezone = predicates.enum [ "utc", "local" ],
                            packagesToPack = predicates.isType '"String",
                            packagesToPush = predicates.isType '"String",
                            patchVersion = predicates.isType '"String",
                            publishFeedCredentials = predicates.isType
                                '"String",
                            publishPackageMetadata = predicates.isType '"Bool",
                            publishVstsFeed = predicates.isType '"String",
                            restoreDirectory = predicates.isType '"String",
                            restoreSolution = predicates.isType '"String",
                            toolPackage = predicates.isType '"Bool",
                            verbosityPack = predicates.enum
                                [ "Quiet", "Normal", "Detailed" ],
                            verbosityPush = predicates.enum
                                [ "Quiet", "Normal", "Detailed" ],
                            verbosityRestore = predicates.enum
                                [ "Quiet", "Normal", "Detailed" ],
                            versionEnvVar = predicates.isType '"String",
                            versioningScheme = predicates.enum
                                [
                                  "off",
                                  "byPrereleaseNumber",
                                  "byEnvVar",
                                  "byBuildNumber"
                                ],
                            vstsFeed = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^NuGetCommand@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            noCache = predicates.isType '"Bool",
                            nuGetPath = predicates.isType '"String",
                            nuGetRestoreArgs = predicates.isType '"String",
                            nuGetVersion = predicates.enum
                                [
                                  "3.3.0",
                                  "3.5.0.1829",
                                  "4.0.0.2283",
                                  "custom"
                                ],
                            nugetConfigPath = predicates.isType '"String",
                            restoreMode = predicates.enum
                                [ "restore", "install" ],
                            solution = predicates.isType '"String",
                            verbosity = predicates.enum
                                [ "-", "Quiet", "Normal", "Detailed" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^NuGetInstaller@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          { delayForMinutes = predicates.isType '"String", }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Delay@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            args = predicates.isType '"String",
                            buildForSimulator = predicates.isType '"Bool",
                            clean = predicates.isType '"Bool",
                            configuration = predicates.isType '"String",
                            mdtoolFile = predicates.isType '"String",
                            packageApp = predicates.isType '"Bool",
                            runNugetRestore = predicates.isType '"Bool",
                            signingIdentity = predicates.isType '"String",
                            signingProvisioningProfileID = predicates.isType
                                '"String",
                            solutionFile = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^XamariniOS@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            args = predicates.isType '"String",
                            buildForSimulator = predicates.isType '"Bool",
                            buildToolOption = predicates.enum
                                [ "xbuild", "msbuild" ],
                            clean = predicates.isType '"Bool",
                            configuration = predicates.isType '"String",
                            mdtoolFile = predicates.isType '"String",
                            packageApp = predicates.isType '"Bool",
                            runNugetRestore = predicates.isType '"Bool",
                            signingDefaultKeychainPassword = predicates.isType
                                '"String",
                            signingIdentity = predicates.isType '"String",
                            signingOption = predicates.enum [ "file", "id" ],
                            signingP12File = predicates.isType '"String",
                            signingP12Password = predicates.isType '"String",
                            signingProvisioningProfileFile = predicates.isType
                                '"String",
                            signingProvisioningProfileID = predicates.isType
                                '"String",
                            signingRemoveProfile = predicates.isType '"Bool",
                            signingUnlockDefaultKeychain = predicates.isType
                                '"Bool",
                            solutionFile = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^XamariniOS@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            configuration = predicates.isType '"String",
                            mergeTestResults = predicates.isType '"Bool",
                            platform = predicates.isType '"String",
                            publishRunAttachments = predicates.isType '"Bool",
                            testResultsFiles = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                            testRunner = predicates.enum
                                [ "JUnit", "NUnit", "VSTest", "XUnit" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^PublishTestResults@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            buildConfiguration = predicates.isType '"String",
                            buildPlatform = predicates.isType '"String",
                            failTaskOnFailedTests = predicates.isType '"Bool",
                            mergeTestResults = predicates.isType '"Bool",
                            publishRunAttachments = predicates.isType '"Bool",
                            searchFolder = predicates.isType '"String",
                            testResultsFiles = predicates.isType '"String",
                            testResultsFormat = predicates.enum
                                [
                                  "JUnit",
                                  "NUnit",
                                  "VSTest",
                                  "XUnit",
                                  "CTest"
                                ],
                            testRunTitle = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^PublishTestResults@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "Destination", "SourcePath" ],
                            predicates.records.record
                            {
                              AdditionalArgumentsForBlobCopy = predicates.isType
                                  '"String",
                              AdditionalArgumentsForVMCopy = predicates.isType
                                  '"String",
                              BlobPrefix = predicates.isType '"String",
                              CleanTargetBeforeCopy = predicates.isType '"Bool",
                              ContainerName = predicates.isType '"String",
                              CopyFilesInParallel = predicates.isType '"Bool",
                              Destination = predicates.enum
                                  [ "AzureBlob", "AzureVMs" ],
                              MachineNames = predicates.isType '"String",
                              ResourceFilteringMethod = predicates.enum
                                  [ "machineNames", "tags" ],
                              SourcePath = predicates.isType '"String",
                              TargetPath = predicates.isType '"String",
                              azureClassicSubscription = predicates.isType
                                  '"String",
                              azureConnectionType = predicates.enum
                                  [
                                    "ConnectedServiceName",
                                    "ConnectedServiceNameARM"
                                  ],
                              azureSubscription = predicates.isType '"String",
                              classicStorage = predicates.isType '"String",
                              cloudService = predicates.isType '"String",
                              enableCopyPrerequisites = predicates.isType
                                  '"Bool",
                              outputStorageContainerSasToken = predicates.isType
                                  '"String",
                              outputStorageUri = predicates.isType '"String",
                              resourceGroup = predicates.isType '"String",
                              skipCACheck = predicates.isType '"Bool",
                              storage = predicates.isType '"String",
                              vmsAdminPassword = predicates.isType '"String",
                              vmsAdminUserName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureFileCopy@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "Destination",
                              "SourcePath",
                              "azureSubscription",
                              "storage"
                            ],
                            predicates.records.record
                            {
                              AdditionalArgumentsForBlobCopy = predicates.isType
                                  '"String",
                              AdditionalArgumentsForVMCopy = predicates.isType
                                  '"String",
                              BlobPrefix = predicates.isType '"String",
                              CleanTargetBeforeCopy = predicates.isType '"Bool",
                              ContainerName = predicates.isType '"String",
                              CopyFilesInParallel = predicates.isType '"Bool",
                              Destination = predicates.enum
                                  [ "AzureBlob", "AzureVMs" ],
                              MachineNames = predicates.isType '"String",
                              ResourceFilteringMethod = predicates.enum
                                  [ "machineNames", "tags" ],
                              SourcePath = predicates.isType '"String",
                              TargetPath = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                              enableCopyPrerequisites = predicates.isType
                                  '"Bool",
                              resourceGroup = predicates.isType '"String",
                              sasTokenTimeOutInMinutes = predicates.isType
                                  '"String",
                              skipCACheck = predicates.isType '"Bool",
                              storage = predicates.isType '"String",
                              vmsAdminPassword = predicates.isType '"String",
                              vmsAdminUserName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureFileCopy@4$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "Destination",
                              "SourcePath",
                              "azureSubscription",
                              "storage"
                            ],
                            predicates.records.record
                            {
                              AdditionalArgumentsForBlobCopy = predicates.isType
                                  '"String",
                              AdditionalArgumentsForVMCopy = predicates.isType
                                  '"String",
                              BlobPrefix = predicates.isType '"String",
                              CleanTargetBeforeCopy = predicates.isType '"Bool",
                              ContainerName = predicates.isType '"String",
                              CopyFilesInParallel = predicates.isType '"Bool",
                              Destination = predicates.enum
                                  [ "AzureBlob", "AzureVMs" ],
                              MachineNames = predicates.isType '"String",
                              ResourceFilteringMethod = predicates.enum
                                  [ "machineNames", "tags" ],
                              SourcePath = predicates.isType '"String",
                              TargetPath = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                              enableCopyPrerequisites = predicates.isType
                                  '"Bool",
                              resourceGroup = predicates.isType '"String",
                              sasTokenTimeOutInMinutes = predicates.isType
                                  '"String",
                              skipCACheck = predicates.isType '"Bool",
                              storage = predicates.isType '"String",
                              vmsAdminPassword = predicates.isType '"String",
                              vmsAdminUserName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureFileCopy@5$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "Destination", "SourcePath" ],
                            predicates.records.record
                            {
                              AdditionalArguments = predicates.isType '"String",
                              BlobPrefix = predicates.isType '"String",
                              CleanTargetBeforeCopy = predicates.isType '"Bool",
                              ContainerName = predicates.isType '"String",
                              CopyFilesInParallel = predicates.isType '"Bool",
                              Destination = predicates.enum
                                  [ "AzureBlob", "AzureVMs" ],
                              MachineNames = predicates.isType '"String",
                              ResourceFilteringMethod = predicates.enum
                                  [ "machineNames", "tags" ],
                              SourcePath = predicates.isType '"String",
                              TargetPath = predicates.isType '"String",
                              azureClassicSubscription = predicates.isType
                                  '"String",
                              azureConnectionType = predicates.enum
                                  [
                                    "ConnectedServiceName",
                                    "ConnectedServiceNameARM"
                                  ],
                              azureSubscription = predicates.isType '"String",
                              classicStorage = predicates.isType '"String",
                              cloudService = predicates.isType '"String",
                              enableCopyPrerequisites = predicates.isType
                                  '"Bool",
                              outputStorageContainerSasToken = predicates.isType
                                  '"String",
                              outputStorageUri = predicates.isType '"String",
                              resourceGroup = predicates.isType '"String",
                              skipCACheck = predicates.isType '"Bool",
                              storage = predicates.isType '"String",
                              vmsAdminPassword = predicates.isType '"String",
                              vmsAdminUserName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureFileCopy@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "Destination",
                              "SourcePath",
                              "azureSubscription",
                              "storage"
                            ],
                            predicates.records.record
                            {
                              AdditionalArgumentsForBlobCopy = predicates.isType
                                  '"String",
                              AdditionalArgumentsForVMCopy = predicates.isType
                                  '"String",
                              BlobPrefix = predicates.isType '"String",
                              CleanTargetBeforeCopy = predicates.isType '"Bool",
                              ContainerName = predicates.isType '"String",
                              CopyFilesInParallel = predicates.isType '"Bool",
                              Destination = predicates.enum
                                  [ "AzureBlob", "AzureVMs" ],
                              MachineNames = predicates.isType '"String",
                              ResourceFilteringMethod = predicates.enum
                                  [ "machineNames", "tags" ],
                              SourcePath = predicates.isType '"String",
                              TargetPath = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                              enableCopyPrerequisites = predicates.isType
                                  '"Bool",
                              outputStorageContainerSasToken = predicates.isType
                                  '"String",
                              outputStorageUri = predicates.isType '"String",
                              resourceGroup = predicates.isType '"String",
                              sasTokenTimeOutInMinutes = predicates.isType
                                  '"String",
                              skipCACheck = predicates.isType '"Bool",
                              storage = predicates.isType '"String",
                              vmsAdminPassword = predicates.isType '"String",
                              vmsAdminUserName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureFileCopy@3$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            CompressSymbols = predicates.isType '"Bool",
                            DetailedLog = predicates.isType '"Bool",
                            IndexSources = predicates.isType '"Bool",
                            IndexableFileFormats = predicates.enum
                                [ "Default", "Pdb", "SourceMap", "All" ],
                            PublishSymbols = predicates.isType '"Bool",
                            SearchPattern = predicates.isType '"String",
                            SymbolExpirationInDays = predicates.isType
                                '"String",
                            SymbolServerType = predicates.enum
                                [ " ", "TeamServices", "FileShare" ],
                            SymbolsArtifactName = predicates.isType '"String",
                            SymbolsFolder = predicates.isType '"String",
                            SymbolsMaximumWaitTime = predicates.isType
                                '"String",
                            SymbolsPath = predicates.isType '"String",
                            SymbolsProduct = predicates.isType '"String",
                            SymbolsVersion = predicates.isType '"String",
                            TreatNotIndexedAsWarning = predicates.isType
                                '"Bool",
                            UseNetCoreClientTool = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^PublishSymbols@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            SearchPattern = predicates.isType '"String",
                            SkipIndexing = predicates.isType '"Bool",
                            SymbolsArtifactName = predicates.isType '"String",
                            SymbolsFolder = predicates.isType '"String",
                            SymbolsMaximumWaitTime = predicates.isType
                                '"String",
                            SymbolsPath = predicates.isType '"String",
                            SymbolsProduct = predicates.isType '"String",
                            SymbolsVersion = predicates.isType '"String",
                            TreatNotIndexedAsWarning = predicates.isType
                                '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^PublishSymbols@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "sshEndpoint" ],
                            predicates.records.record
                            {
                              cleanHiddenFilesInTarget = predicates.isType
                                  '"Bool",
                              cleanTargetFolder = predicates.isType '"Bool",
                              contents = predicates.isType '"String",
                              failOnEmptySource = predicates.isType '"Bool",
                              flattenFolders = predicates.isType '"Bool",
                              isWindowsOnTarget = predicates.isType '"Bool",
                              overwrite = predicates.isType '"Bool",
                              readyTimeout = predicates.isType '"String",
                              sourceFolder = predicates.isType '"String",
                              sshEndpoint = predicates.isType '"String",
                              targetFolder = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^CopyFilesOverSSH@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            checkStyleRunAnalysis = predicates.isType '"Bool",
                            codeCoverageClassFilesDirectories =
                              predicates.isType '"String",
                            codeCoverageClassFilter = predicates.isType
                                '"String",
                            codeCoverageFailIfEmpty = predicates.isType '"Bool",
                            codeCoverageGradle5xOrHigher = predicates.isType
                                '"Bool",
                            codeCoverageToolOption = predicates.enum
                                [ "None", "Cobertura", "JaCoCo" ],
                            findBugsRunAnalysis = predicates.isType '"Bool",
                            gradleOptions = predicates.isType '"String",
                            gradleWrapperFile = predicates.isType '"String",
                            javaHomeOption = predicates.enum
                                [ "JDKVersion", "Path" ],
                            jdkArchitectureOption = predicates.enum
                                [ "x86", "x64" ],
                            jdkDirectory = predicates.isType '"String",
                            jdkVersionOption = predicates.enum
                                [
                                  "default",
                                  "1.17",
                                  "1.11",
                                  "1.10",
                                  "1.9",
                                  "1.8",
                                  "1.7",
                                  "1.6"
                                ],
                            options = predicates.isType '"String",
                            pmdRunAnalysis = predicates.isType '"Bool",
                            publishJUnitResults = predicates.isType '"Bool",
                            sonarQubeGradlePluginVersion = predicates.isType
                                '"String",
                            sonarQubeRunAnalysis = predicates.isType '"Bool",
                            spotBugsAnalysis = predicates.isType '"Bool",
                            spotBugsGradlePluginVersionChoice = predicates.enum
                                [ "specify", "build" ],
                            spotbugsGradlePluginVersion = predicates.isType
                                '"String",
                            sqGradlePluginVersionChoice = predicates.enum
                                [ "specify", "build" ],
                            tasks = predicates.isType '"String",
                            testResultsFiles = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Gradle@3$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            checkStyleRunAnalysis = predicates.isType '"Bool",
                            codeCoverageClassFilesDirectories =
                              predicates.isType '"String",
                            codeCoverageClassFilter = predicates.isType
                                '"String",
                            codeCoverageFailIfEmpty = predicates.isType '"Bool",
                            codeCoverageToolOption = predicates.enum
                                [ "None", "Cobertura", "JaCoCo" ],
                            findBugsRunAnalysis = predicates.isType '"Bool",
                            gradleOptions = predicates.isType '"String",
                            gradleWrapperFile = predicates.isType '"String",
                            javaHomeOption = predicates.enum
                                [ "JDKVersion", "Path" ],
                            jdkArchitectureOption = predicates.enum
                                [ "x86", "x64" ],
                            jdkDirectory = predicates.isType '"String",
                            jdkVersionOption = predicates.enum
                                [ "default", "1.9", "1.8", "1.7", "1.6" ],
                            options = predicates.isType '"String",
                            pmdRunAnalysis = predicates.isType '"Bool",
                            publishJUnitResults = predicates.isType '"Bool",
                            sonarQubeDBPassword = predicates.isType '"String",
                            sonarQubeDBUrl = predicates.isType '"String",
                            sonarQubeDBUsername = predicates.isType '"String",
                            sonarQubeFailWhenQualityGateFails =
                              predicates.isType '"Bool",
                            sonarQubeGradlePluginVersion = predicates.isType
                                '"String",
                            sonarQubeIncludeFullReport = predicates.isType
                                '"Bool",
                            sonarQubeProjectKey = predicates.isType '"String",
                            sonarQubeProjectName = predicates.isType '"String",
                            sonarQubeProjectVersion = predicates.isType
                                '"String",
                            sonarQubeRunAnalysis = predicates.isType '"Bool",
                            sonarQubeServiceEndpoint = predicates.isType
                                '"String",
                            sonarQubeSpecifyDB = predicates.isType '"Bool",
                            tasks = predicates.isType '"String",
                            testResultsFiles = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Gradle@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            checkStyleRunAnalysis = predicates.isType '"Bool",
                            codeCoverageClassFilesDirectories =
                              predicates.isType '"String",
                            codeCoverageClassFilter = predicates.isType
                                '"String",
                            codeCoverageFailIfEmpty = predicates.isType '"Bool",
                            codeCoverageGradle5xOrHigher = predicates.isType
                                '"Bool",
                            codeCoverageToolOption = predicates.enum
                                [ "None", "Cobertura", "JaCoCo" ],
                            findBugsRunAnalysis = predicates.isType '"Bool",
                            gradleOptions = predicates.isType '"String",
                            gradleWrapperFile = predicates.isType '"String",
                            javaHomeOption = predicates.enum
                                [ "JDKVersion", "Path" ],
                            jdkArchitectureOption = predicates.enum
                                [ "x86", "x64" ],
                            jdkDirectory = predicates.isType '"String",
                            jdkVersionOption = predicates.enum
                                [
                                  "default",
                                  "1.17",
                                  "1.11",
                                  "1.10",
                                  "1.9",
                                  "1.8",
                                  "1.7",
                                  "1.6"
                                ],
                            options = predicates.isType '"String",
                            pmdRunAnalysis = predicates.isType '"Bool",
                            publishJUnitResults = predicates.isType '"Bool",
                            sonarQubeGradlePluginVersion = predicates.isType
                                '"String",
                            sonarQubeRunAnalysis = predicates.isType '"Bool",
                            spotBugsAnalysis = predicates.isType '"Bool",
                            spotBugsGradlePluginVersionChoice = predicates.enum
                                [ "specify", "build" ],
                            spotbugsGradlePluginVersion = predicates.isType
                                '"String",
                            sqGradlePluginVersionChoice = predicates.enum
                                [ "specify", "build" ],
                            tasks = predicates.isType '"String",
                            testResultsFiles = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Gradle@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "appFile", "appSlug", "serverEndpoint" ],
                            predicates.records.record
                            {
                              appFile = predicates.isType '"String",
                              appSlug = predicates.isType '"String",
                              appxsymPath = predicates.isType '"String",
                              buildVersion = predicates.isType '"String",
                              destinationStoreId = predicates.isType '"String",
                              destinationType = predicates.enum
                                  [ "groups", "store" ],
                              distributionGroupId = predicates.isType '"String",
                              isMandatory = predicates.isType '"Bool",
                              isSilent = predicates.isType '"Bool",
                              nativeLibrariesPath = predicates.isType '"String",
                              releaseNotesFile = predicates.isType '"String",
                              releaseNotesInput = predicates.isType '"String",
                              releaseNotesOption = predicates.enum
                                  [ "input", "file" ],
                              serverEndpoint = predicates.isType '"String",
                              symbolsDsymFiles = predicates.isType '"String",
                              symbolsIncludeParentDirectory = predicates.isType
                                  '"Bool",
                              symbolsMappingTxtFile = predicates.isType
                                  '"String",
                              symbolsOption = predicates.enum
                                  [ "Apple", "Android", "UWP" ],
                              symbolsPath = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AppCenterDistribute@3$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "appFile", "appSlug", "serverEndpoint" ],
                            predicates.records.record
                            {
                              appFile = predicates.isType '"String",
                              appSlug = predicates.isType '"String",
                              distributionGroupId = predicates.isType '"String",
                              isMandatory = predicates.isType '"Bool",
                              releaseNotesFile = predicates.isType '"String",
                              releaseNotesInput = predicates.isType '"String",
                              releaseNotesOption = predicates.enum
                                  [ "input", "file" ],
                              serverEndpoint = predicates.isType '"String",
                              symbolsDsymFiles = predicates.isType '"String",
                              symbolsIncludeParentDirectory = predicates.isType
                                  '"Bool",
                              symbolsMappingTxtFile = predicates.isType
                                  '"String",
                              symbolsOption = predicates.enum [ "Apple" ],
                              symbolsPath = predicates.isType '"String",
                              symbolsPdbFiles = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AppCenterDistribute@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "appFile", "appSlug", "serverEndpoint" ],
                            predicates.records.record
                            {
                              appFile = predicates.isType '"String",
                              appSlug = predicates.isType '"String",
                              distributionGroupId = predicates.isType '"String",
                              releaseNotesFile = predicates.isType '"String",
                              releaseNotesInput = predicates.isType '"String",
                              releaseNotesOption = predicates.enum
                                  [ "input", "file" ],
                              serverEndpoint = predicates.isType '"String",
                              symbolsDsymFiles = predicates.isType '"String",
                              symbolsIncludeParentDirectory = predicates.isType
                                  '"Bool",
                              symbolsMappingTxtFile = predicates.isType
                                  '"String",
                              symbolsOption = predicates.enum [ "Apple" ],
                              symbolsPath = predicates.isType '"String",
                              symbolsPdbFiles = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AppCenterDistribute@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "appFile", "appSlug", "serverEndpoint" ],
                            predicates.records.record
                            {
                              appFile = predicates.isType '"String",
                              appSlug = predicates.isType '"String",
                              distributionGroupId = predicates.isType '"String",
                              isMandatory = predicates.isType '"Bool",
                              releaseNotesFile = predicates.isType '"String",
                              releaseNotesInput = predicates.isType '"String",
                              releaseNotesOption = predicates.enum
                                  [ "input", "file" ],
                              serverEndpoint = predicates.isType '"String",
                              symbolsDsymFiles = predicates.isType '"String",
                              symbolsIncludeParentDirectory = predicates.isType
                                  '"Bool",
                              symbolsMappingTxtFile = predicates.isType
                                  '"String",
                              symbolsOption = predicates.enum [ "Apple" ],
                              symbolsPath = predicates.isType '"String",
                              symbolsPdbFiles = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AppCenterDistribute@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            checkLatest = predicates.isType '"Bool",
                            versionSpec = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^NuGetToolInstaller@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            checkLatest = predicates.isType '"Bool",
                            versionSpec = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^NuGetToolInstaller@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "jenkinsServerConnection", "jobName" ],
                            predicates.records.record
                            {
                              ConnectedServiceNameARM = predicates.isType
                                  '"String",
                              artifactDetailsFileNameSuffix = predicates.isType
                                  '"String",
                              artifactProvider = predicates.enum
                                  [ "azureStorage" ],
                              commonVirtualPath = predicates.isType '"String",
                              containerName = predicates.isType '"String",
                              downloadCommitsAndWorkItems = predicates.isType
                                  '"Bool",
                              itemPattern = predicates.isType '"String",
                              jenkinsBuild = predicates.enum
                                  [ "LastSuccessfulBuild", "BuildNumber" ],
                              jenkinsBuildNumber = predicates.isType '"String",
                              jenkinsJobType = predicates.isType '"String",
                              jenkinsServerConnection = predicates.isType
                                  '"String",
                              jobName = predicates.isType '"String",
                              propagatedArtifacts = predicates.isType '"Bool",
                              saveTo = predicates.isType '"String",
                              startJenkinsBuildNumber = predicates.isType
                                  '"String",
                              storageAccountName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^JenkinsDownloadArtifacts@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "appName", "azureSubscription", "imageName" ],
                            predicates.records.record
                            {
                              appName = predicates.isType '"String",
                              appSettings = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                              configurationStrings = predicates.isType
                                  '"String",
                              containerCommand = predicates.isType '"String",
                              deployToSlotOrASE = predicates.isType '"Bool",
                              imageName = predicates.isType '"String",
                              resourceGroupName = predicates.isType '"String",
                              slotName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureFunctionAppContainer@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "inFile", "passphrase" ],
                            predicates.records.record
                            {
                              cipher = predicates.isType '"String",
                              inFile = predicates.isType '"String",
                              outFile = predicates.isType '"String",
                              passphrase = predicates.isType '"String",
                              workingDirectory = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^DecryptFile@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "azureContainerRegistry",
                              "azureResourceGroupForACR",
                              "azureSubscriptionForACR"
                            ],
                            predicates.records.record
                            {
                              arguments = predicates.isType '"String",
                              azureContainerRegistry = predicates.isType
                                  '"String",
                              azureResourceGroup = predicates.isType '"String",
                              azureResourceGroupForACR = predicates.isType
                                  '"String",
                              azureSubscription = predicates.isType '"String",
                              azureSubscriptionForACR = predicates.isType
                                  '"String",
                              caCert = predicates.isType '"String",
                              canaryImage = predicates.isType '"Bool",
                              certificate = predicates.isType '"String",
                              chartName = predicates.isType '"String",
                              chartNameForACR = predicates.isType '"String",
                              chartPath = predicates.isType '"String",
                              chartPathForACR = predicates.isType '"String",
                              chartType = predicates.enum
                                  [ "Name", "FilePath" ],
                              chartVersion = predicates.isType '"String",
                              command = predicates.enum
                                  [
                                    "create",
                                    "delete",
                                    "expose",
                                    "get",
                                    "init",
                                    "install",
                                    "login",
                                    "logout",
                                    "ls",
                                    "package",
                                    "rollback",
                                    "save",
                                    "upgrade",
                                    "uninstall"
                                  ],
                              connectionType = predicates.enum
                                  [
                                    "Azure Resource Manager",
                                    "Kubernetes Service Connection",
                                    "None"
                                  ],
                              destination = predicates.isType '"String",
                              enableTls = predicates.isType '"Bool",
                              failOnStderr = predicates.isType '"Bool",
                              "force" = predicates.isType '"Bool",
                              install = predicates.isType '"Bool",
                              kubernetesCluster = predicates.isType '"String",
                              kubernetesServiceConnection = predicates.isType
                                  '"String",
                              namespace = predicates.isType '"String",
                              overrideValues = predicates.isType '"String",
                              privatekey = predicates.isType '"String",
                              publishPipelineMetadata = predicates.isType
                                  '"Bool",
                              recreate = predicates.isType '"Bool",
                              releaseName = predicates.isType '"String",
                              resetValues = predicates.isType '"Bool",
                              save = predicates.isType '"Bool",
                              tillerNamespace = predicates.isType '"String",
                              updateDependency = predicates.isType '"Bool",
                              upgradeTiller = predicates.isType '"Bool",
                              useClusterAdmin = predicates.isType '"Bool",
                              valueFile = predicates.isType '"String",
                              waitForExecution = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^HelmDeploy@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "certSecureFile" ],
                            predicates.records.record
                            {
                              certPwd = predicates.isType '"String",
                              certSecureFile = predicates.isType '"String",
                              customKeychainPath = predicates.isType '"String",
                              deleteCert = predicates.isType '"Bool",
                              deleteCustomKeychain = predicates.isType '"Bool",
                              keychain = predicates.enum
                                  [ "default", "temp", "custom" ],
                              keychainPassword = predicates.isType '"String",
                              opensslPkcsArgs = predicates.isType '"String",
                              setUpPartitionIdACLForPrivateKey =
                                predicates.isType '"Bool",
                              signingIdentity = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^InstallAppleCertificate@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "certSecureFile" ],
                            predicates.records.record
                            {
                              certPwd = predicates.isType '"String",
                              certSecureFile = predicates.isType '"String",
                              customKeychainPath = predicates.isType '"String",
                              deleteCert = predicates.isType '"Bool",
                              deleteCustomKeychain = predicates.isType '"Bool",
                              keychain = predicates.enum
                                  [ "default", "temp", "custom" ],
                              keychainPassword = predicates.isType '"String",
                              signingIdentity = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^InstallAppleCertificate@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "certSecureFile" ],
                            predicates.records.record
                            {
                              certPwd = predicates.isType '"String",
                              certSecureFile = predicates.isType '"String",
                              customKeychainPath = predicates.isType '"String",
                              deleteCert = predicates.isType '"Bool",
                              deleteCustomKeychain = predicates.isType '"Bool",
                              keychain = predicates.enum
                                  [ "default", "temp", "custom" ],
                              keychainPassword = predicates.isType '"String",
                              signingIdentity = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^InstallAppleCertificate@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "function", "key" ],
                            predicates.records.record
                            {
                              body = predicates.isType '"String",
                              function = predicates.isType '"String",
                              headers = predicates.isType '"String",
                              key = predicates.isType '"String",
                              method = predicates.enum
                                  [
                                    "OPTIONS",
                                    "GET",
                                    "HEAD",
                                    "POST",
                                    "PUT",
                                    "DELETE",
                                    "TRACE",
                                    "PATCH"
                                  ],
                              queryParameters = predicates.isType '"String",
                              successCriteria = predicates.isType '"String",
                              waitForCompletion = predicates.enum
                                  [ "true", "false" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureFunction@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "function", "key" ],
                            predicates.records.record
                            {
                              body = predicates.isType '"String",
                              function = predicates.isType '"String",
                              headers = predicates.isType '"String",
                              key = predicates.isType '"String",
                              method = predicates.enum
                                  [
                                    "OPTIONS",
                                    "GET",
                                    "HEAD",
                                    "POST",
                                    "PUT",
                                    "DELETE",
                                    "TRACE",
                                    "PATCH"
                                  ],
                              queryParameters = predicates.isType '"String",
                              successCriteria = predicates.isType '"String",
                              waitForCompletion = predicates.enum
                                  [ "true", "false" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureFunction@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          { opaVersion = predicates.isType '"String", }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^OpenPolicyAgentInstaller@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "connection", "userRepository" ],
                            predicates.records.record
                            {
                              connection = predicates.isType '"String",
                              defaultVersionType = predicates.enum
                                  [
                                    "latest",
                                    "specificVersion",
                                    "specificTag"
                                  ],
                              downloadPath = predicates.isType '"String",
                              itemPattern = predicates.isType '"String",
                              userRepository = predicates.isType '"String",
                              version = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^DownloadGitHubRelease@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "sshEndpoint" ],
                            predicates.records.record
                            {
                              args = predicates.isType '"String",
                              commands = predicates.isType '"String",
                              failOnStdErr = predicates.isType '"Bool",
                              inline = predicates.isType '"String",
                              interactiveKeyboardAuthentication =
                                predicates.isType '"Bool",
                              interactiveSession = predicates.isType '"Bool",
                              interpreterCommand = predicates.isType '"String",
                              readyTimeout = predicates.isType '"String",
                              runOptions = predicates.enum
                                  [ "commands", "script", "inline" ],
                              scriptPath = predicates.isType '"String",
                              sshEndpoint = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^SSH@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "targetPath" ],
                            predicates.records.record
                            {
                              artifactName = predicates.isType '"String",
                              properties = predicates.isType '"String",
                              targetPath = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^PublishPipelineArtifact@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            artifact = predicates.isType '"String",
                            fileSharePath = predicates.isType '"String",
                            parallel = predicates.isType '"Bool",
                            parallelCount = predicates.isType 'Integer,
                            properties = predicates.isType '"String",
                            publishLocation = predicates.enum
                                [ "pipeline", "filepath" ],
                            targetPath = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^PublishPipelineArtifact@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "connectedServiceName",
                              "projectKey",
                              "projectName"
                            ],
                            predicates.records.record
                            {
                              breakBuild = predicates.isType '"Bool",
                              cmdLineArgs = predicates.isType '"String",
                              configFile = predicates.isType '"String",
                              connectedServiceName = predicates.isType
                                  '"String",
                              dbPassword = predicates.isType '"String",
                              dbUrl = predicates.isType '"String",
                              dbUsername = predicates.isType '"String",
                              includeFullReport = predicates.isType '"Bool",
                              projectKey = predicates.isType '"String",
                              projectName = predicates.isType '"String",
                              projectVersion = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^SonarQubePreBuild@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "artifactName", "filesharePath" ],
                            predicates.records.record
                            {
                              artifactName = predicates.isType '"String",
                              downloadPath = predicates.isType '"String",
                              filesharePath = predicates.isType '"String",
                              itemPattern = predicates.isType '"String",
                              parallelizationLimit = predicates.isType
                                  '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^DownloadFileshareArtifacts@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            azureContainerRegistry = predicates.isType
                                '"String",
                            azureSubscription = predicates.isType '"String",
                            checkLatest = predicates.isType '"Bool",
                            command = predicates.enum
                                [
                                  "apply",
                                  "create",
                                  "delete",
                                  "exec",
                                  "expose",
                                  "get",
                                  "logs",
                                  "run",
                                  "set",
                                  "top"
                                ],
                            configMapArguments = predicates.isType '"String",
                            configMapFile = predicates.isType '"String",
                            configMapName = predicates.isType '"String",
                            configuration = predicates.isType '"String",
                            containerRegistryType = predicates.enum
                                [
                                  "Azure Container Registry",
                                  "Container Registry"
                                ],
                            dockerRegistryConnection = predicates.isType
                                '"String",
                            forceUpdate = predicates.isType '"Bool",
                            forceUpdateConfigMap = predicates.isType '"Bool",
                            kubectlOutput = predicates.isType '"String",
                            kubernetesServiceConnection = predicates.isType
                                '"String",
                            namespace = predicates.isType '"String",
                            outputFormat = predicates.enum [ "json", "yaml" ],
                            secretArguments = predicates.isType '"String",
                            secretName = predicates.isType '"String",
                            secretType = predicates.enum
                                [ "dockerRegistry", "generic" ],
                            specifyLocation = predicates.isType '"String",
                            useConfigMapFile = predicates.isType '"Bool",
                            useConfigurationFile = predicates.isType '"Bool",
                            versionOrLocation = predicates.enum
                                [ "version", "location" ],
                            versionSpec = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Kubernetes@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            azureContainerRegistry = predicates.isType
                                '"String",
                            azureResourceGroup = predicates.isType '"String",
                            azureSubscriptionEndpoint = predicates.isType
                                '"String",
                            azureSubscriptionEndpointForSecrets =
                              predicates.isType '"String",
                            checkLatest = predicates.isType '"Bool",
                            command = predicates.enum
                                [
                                  "apply",
                                  "create",
                                  "delete",
                                  "exec",
                                  "expose",
                                  "get",
                                  "login",
                                  "logout",
                                  "logs",
                                  "run",
                                  "set",
                                  "top"
                                ],
                            configMapArguments = predicates.isType '"String",
                            configMapFile = predicates.isType '"String",
                            configMapName = predicates.isType '"String",
                            configuration = predicates.isType '"String",
                            configurationType = predicates.enum
                                [ "configuration", "inline" ],
                            connectionType = predicates.enum
                                [
                                  "Azure Resource Manager",
                                  "Kubernetes Service Connection",
                                  "None"
                                ],
                            containerRegistryType = predicates.enum
                                [
                                  "Azure Container Registry",
                                  "Container Registry"
                                ],
                            dockerRegistryEndpoint = predicates.isType
                                '"String",
                            forceUpdate = predicates.isType '"Bool",
                            forceUpdateConfigMap = predicates.isType '"Bool",
                            inline = predicates.isType '"String",
                            kubernetesCluster = predicates.isType '"String",
                            kubernetesServiceEndpoint = predicates.isType
                                '"String",
                            namespace = predicates.isType '"String",
                            outputFormat = predicates.enum
                                [ "json", "yaml", "none" ],
                            secretArguments = predicates.isType '"String",
                            secretName = predicates.isType '"String",
                            secretType = predicates.enum
                                [ "dockerRegistry", "generic" ],
                            specifyLocation = predicates.isType '"String",
                            useClusterAdmin = predicates.isType '"Bool",
                            useConfigMapFile = predicates.isType '"Bool",
                            useConfigurationFile = predicates.isType '"Bool",
                            versionOrLocation = predicates.enum
                                [ "version", "location" ],
                            versionSpec = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Kubernetes@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            action = predicates.enum
                                [
                                  "Build module images",
                                  "Push module images",
                                  "Generate deployment manifest",
                                  "Deploy to IoT Edge devices"
                                ],
                            azureContainerRegistry = predicates.isType
                                '"String",
                            azureSubscription = predicates.isType '"String",
                            azureSubscriptionEndpoint = predicates.isType
                                '"String",
                            bypassModules = predicates.isType '"String",
                            containerregistrytype = predicates.enum
                                [
                                  "Azure Container Registry",
                                  "Generic Container Registry"
                                ],
                            defaultPlatform = predicates.enum
                                [
                                  "amd64",
                                  "windows-amd64",
                                  "arm32v7",
                                  "arm64v8"
                                ],
                            deploymentFilePath = predicates.isType '"String",
                            deploymentManifestOutputPath = predicates.isType
                                '"String",
                            deploymentid = predicates.isType '"String",
                            deviceId = predicates.isType '"String",
                            deviceOption = predicates.enum
                                [ "Single Device", "Multiple Devices" ],
                            dockerRegistryConnection = predicates.isType
                                '"String",
                            fillRegistryCredential = predicates.enum
                                [ "true", "false" ],
                            iothubname = predicates.isType '"String",
                            "priority" = predicates.isType '"String",
                            targetcondition = predicates.isType '"String",
                            templateFilePath = predicates.isType '"String",
                            validateGeneratedDeploymentManifest =
                              predicates.enum [ "true", "false" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^AzureIoTEdge@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "clusterConnection" ],
                            predicates.records.record
                            {
                              applicationName = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                              clusterConnection = predicates.isType '"String",
                              composeFilePath = predicates.isType '"String",
                              deployTimeoutSec = predicates.isType '"String",
                              dockerRegistryConnection = predicates.isType
                                  '"String",
                              getStatusTimeoutSec = predicates.isType '"String",
                              passwordEncrypted = predicates.isType '"Bool",
                              registryCredentials = predicates.enum
                                  [
                                    "AzureResourceManagerEndpoint",
                                    "ContainerRegistryEndpoint",
                                    "UsernamePassword",
                                    "None"
                                  ],
                              registryPassword = predicates.isType '"String",
                              registryUserName = predicates.isType '"String",
                              removeTimeoutSec = predicates.isType '"String",
                              upgrade = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^ServiceFabricComposeDeploy@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            apkFiles = predicates.isType '"String",
                            jarsign = predicates.isType '"Bool",
                            jarsignerArguments = predicates.isType '"String",
                            jarsignerKeyPassword = predicates.isType '"String",
                            jarsignerKeystoreAlias = predicates.isType
                                '"String",
                            jarsignerKeystoreFile = predicates.isType '"String",
                            jarsignerKeystorePassword = predicates.isType
                                '"String",
                            zipalign = predicates.isType '"Bool",
                            zipalignFile = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^AndroidSigning@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            apkFiles = predicates.isType '"String",
                            apksign = predicates.isType '"Bool",
                            apksignerArguments = predicates.isType '"String",
                            apksignerFile = predicates.isType '"String",
                            apksignerKeyPassword = predicates.isType '"String",
                            apksignerKeystoreAlias = predicates.isType
                                '"String",
                            apksignerKeystoreFile = predicates.isType '"String",
                            apksignerKeystorePassword = predicates.isType
                                '"String",
                            apksignerVersion = predicates.isType '"String",
                            zipalign = predicates.isType '"Bool",
                            zipalignFile = predicates.isType '"String",
                            zipalignVersion = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^AndroidSigning@3$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "files" ],
                            predicates.records.record
                            {
                              files = predicates.isType '"String",
                              jarsign = predicates.isType '"Bool",
                              jarsignerArguments = predicates.isType '"String",
                              keyPass = predicates.isType '"String",
                              keystoreAlias = predicates.isType '"String",
                              keystoreFile = predicates.isType '"String",
                              keystorePass = predicates.isType '"String",
                              zipalign = predicates.isType '"Bool",
                              zipalignLocation = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AndroidSigning@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            artifactName = predicates.isType '"String",
                            branchName = predicates.isType '"String",
                            buildType = predicates.enum
                                [ "current", "specific" ],
                            buildVersionToDownload = predicates.enum
                                [ "latest", "latestFromBranch", "specific" ],
                            itemPattern = predicates.isType '"String",
                            pipeline = predicates.isType '"String",
                            pipelineId = predicates.isType '"String",
                            project = predicates.isType '"String",
                            specificBuildWithTriggering = predicates.isType
                                '"Bool",
                            tags = predicates.isType '"String",
                            targetPath = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^DownloadPipelineArtifact@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "targetPath" ],
                            predicates.records.record
                            {
                              artifactName = predicates.isType '"String",
                              pipelineId = predicates.isType '"String",
                              targetPath = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^DownloadPipelineArtifact@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            allowFailedBuilds = predicates.isType '"Bool",
                            allowPartiallySucceededBuilds = predicates.isType
                                '"Bool",
                            artifactName = predicates.isType '"String",
                            branchName = predicates.isType '"String",
                            buildType = predicates.enum
                                [ "current", "specific" ],
                            buildVersionToDownload = predicates.enum
                                [ "latest", "latestFromBranch", "specific" ],
                            definition = predicates.isType '"String",
                            itemPattern = predicates.isType '"String",
                            pipelineId = predicates.isType '"String",
                            project = predicates.isType '"String",
                            specificBuildWithTriggering = predicates.isType
                                '"Bool",
                            tags = predicates.isType '"String",
                            targetPath = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^DownloadPipelineArtifact@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            addToPath = predicates.isType '"Bool",
                            allowUnstable = predicates.isType '"Bool",
                            architecture = predicates.enum [ "x86", "x64" ],
                            disableDownloadFromRegistry = predicates.isType
                                '"Bool",
                            githubToken = predicates.isType '"String",
                            versionSpec = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^UsePythonVersion@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "clusterConnection" ],
                            predicates.records.record
                            {
                              Inline = predicates.isType '"String",
                              ScriptArguments = predicates.isType '"String",
                              ScriptPath = predicates.isType '"String",
                              ScriptType = predicates.enum
                                  [ "FilePath", "InlineScript" ],
                              clusterConnection = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^ServiceFabricPowerShell@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            batchingBasedOnAgentsOption = predicates.enum
                                [ "autoBatchSize", "customBatchSize" ],
                            batchingBasedOnExecutionTimeOption = predicates.enum
                                [ "autoBatchSize", "customTimeBatchSize" ],
                            codeCoverageEnabled = predicates.isType '"Bool",
                            collectDumpOn = predicates.enum
                                [ "onAbortOnly", "always", "never" ],
                            configuration = predicates.isType '"String",
                            customBatchSizeValue = predicates.isType '"String",
                            customRunTimePerBatchValue = predicates.isType
                                '"String",
                            diagnosticsEnabled = predicates.isType '"Bool",
                            distributionBatchType = predicates.enum
                                [
                                  "basedOnTestCases",
                                  "basedOnExecutionTime",
                                  "basedOnAssembly"
                                ],
                            dontDistribute = predicates.isType '"Bool",
                            failOnMinTestsNotRun = predicates.isType '"Bool",
                            minimumExpectedTests = predicates.isType '"String",
                            otherConsoleOptions = predicates.isType '"String",
                            overrideTestrunParameters = predicates.isType
                                '"String",
                            pathtoCustomTestAdapters = predicates.isType
                                '"String",
                            platform = predicates.isType '"String",
                            publishRunAttachments = predicates.isType '"Bool",
                            rerunFailedTestCasesMaxLimit = predicates.isType
                                '"String",
                            rerunFailedTests = predicates.isType '"Bool",
                            rerunFailedThreshold = predicates.isType '"String",
                            rerunMaxAttempts = predicates.isType '"String",
                            rerunType = predicates.enum
                                [
                                  "basedOnTestFailurePercentage",
                                  "basedOnTestFailureCount"
                                ],
                            resultsFolder = predicates.isType '"String",
                            runAllTestsAfterXBuilds = predicates.isType
                                '"String",
                            runInParallel = predicates.isType '"Bool",
                            runOnlyImpactedTests = predicates.isType '"Bool",
                            runSettingsFile = predicates.isType '"String",
                            runTestsInIsolation = predicates.isType '"Bool",
                            searchFolder = predicates.isType '"String",
                            tcmTestRun = predicates.isType '"String",
                            testAssemblyVer2 = predicates.isType '"String",
                            testConfiguration = predicates.isType '"String",
                            testFiltercriteria = predicates.isType '"String",
                            testPlan = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                            testSelector = predicates.enum
                                [ "testAssemblies", "testPlan", "testRun" ],
                            testSuite = predicates.isType '"String",
                            uiTests = predicates.isType '"Bool",
                            vsTestVersion = predicates.enum
                                [
                                  "latest",
                                  "17.0",
                                  "16.0",
                                  "15.0",
                                  "14.0",
                                  "toolsInstaller"
                                ],
                            vstestLocation = predicates.isType '"String",
                            vstestLocationMethod = predicates.enum
                                [ "version", "location" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^VSTest@3$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            codeCoverageEnabled = predicates.isType '"Bool",
                            configuration = predicates.isType '"String",
                            otherConsoleOptions = predicates.isType '"String",
                            overrideTestrunParameters = predicates.isType
                                '"String",
                            pathtoCustomTestAdapters = predicates.isType
                                '"String",
                            platform = predicates.isType '"String",
                            publishRunAttachments = predicates.isType '"Bool",
                            runInParallel = predicates.isType '"Bool",
                            runSettingsFile = predicates.isType '"String",
                            testAssembly = predicates.isType '"String",
                            testFiltercriteria = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                            vsTestVersion = predicates.enum
                                [ "latest", "14.0", "12.0" ],
                            vstestLocation = predicates.isType '"String",
                            vstestLocationMethod = predicates.enum
                                [ "version", "location" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^VSTest@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            batchingBasedOnAgentsOption = predicates.enum
                                [ "autoBatchSize", "customBatchSize" ],
                            batchingBasedOnExecutionTimeOption = predicates.enum
                                [ "autoBatchSize", "customTimeBatchSize" ],
                            codeCoverageEnabled = predicates.isType '"Bool",
                            collectDumpOn = predicates.enum
                                [ "onAbortOnly", "always", "never" ],
                            configuration = predicates.isType '"String",
                            customBatchSizeValue = predicates.isType '"String",
                            customRunTimePerBatchValue = predicates.isType
                                '"String",
                            diagnosticsEnabled = predicates.isType '"Bool",
                            distributionBatchType = predicates.enum
                                [
                                  "basedOnTestCases",
                                  "basedOnExecutionTime",
                                  "basedOnAssembly"
                                ],
                            dontDistribute = predicates.isType '"Bool",
                            failOnMinTestsNotRun = predicates.isType '"Bool",
                            minimumExpectedTests = predicates.isType '"String",
                            otherConsoleOptions = predicates.isType '"String",
                            overrideTestrunParameters = predicates.isType
                                '"String",
                            pathtoCustomTestAdapters = predicates.isType
                                '"String",
                            platform = predicates.isType '"String",
                            publishRunAttachments = predicates.isType '"Bool",
                            rerunFailedTestCasesMaxLimit = predicates.isType
                                '"String",
                            rerunFailedTests = predicates.isType '"Bool",
                            rerunFailedThreshold = predicates.isType '"String",
                            rerunMaxAttempts = predicates.isType '"String",
                            rerunType = predicates.enum
                                [
                                  "basedOnTestFailurePercentage",
                                  "basedOnTestFailureCount"
                                ],
                            resultsFolder = predicates.isType '"String",
                            runAllTestsAfterXBuilds = predicates.isType
                                '"String",
                            runInParallel = predicates.isType '"Bool",
                            runOnlyImpactedTests = predicates.isType '"Bool",
                            runSettingsFile = predicates.isType '"String",
                            runTestsInIsolation = predicates.isType '"Bool",
                            searchFolder = predicates.isType '"String",
                            tcmTestRun = predicates.isType '"String",
                            testAssemblyVer2 = predicates.isType '"String",
                            testConfiguration = predicates.isType '"String",
                            testFiltercriteria = predicates.isType '"String",
                            testPlan = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                            testSelector = predicates.enum
                                [ "testAssemblies", "testPlan", "testRun" ],
                            testSuite = predicates.isType '"String",
                            uiTests = predicates.isType '"Bool",
                            vsTestVersion = predicates.enum
                                [
                                  "latest",
                                  "17.0",
                                  "16.0",
                                  "15.0",
                                  "14.0",
                                  "toolsInstaller"
                                ],
                            vstestLocation = predicates.isType '"String",
                            vstestLocationMethod = predicates.enum
                                [ "version", "location" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^VSTest@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "notifyUsers" ],
                            predicates.records.record
                            {
                              instructions = predicates.isType '"String",
                              notifyUsers = predicates.isType '"String",
                              onTimeout = predicates.enum
                                  [ "reject", "resume" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^ManualValidation@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            antHomeDirectory = predicates.isType '"String",
                            buildFile = predicates.isType '"String",
                            codeCoverageClassFilesDirectories =
                              predicates.isType '"String",
                            codeCoverageClassFilter = predicates.isType
                                '"String",
                            codeCoverageFailIfEmpty = predicates.isType '"Bool",
                            codeCoverageSourceDirectories = predicates.isType
                                '"String",
                            codeCoverageToolOptions = predicates.enum
                                [ "None", "Cobertura", "JaCoCo" ],
                            javaHomeOption = predicates.enum
                                [ "JDKVersion", "Path" ],
                            jdkArchitectureOption = predicates.enum
                                [ "x86", "x64" ],
                            jdkUserInputDirectory = predicates.isType '"String",
                            jdkVersionOption = predicates.enum
                                [
                                  "default",
                                  "1.11",
                                  "1.10",
                                  "1.9",
                                  "1.8",
                                  "1.7",
                                  "1.6"
                                ],
                            options = predicates.isType '"String",
                            publishJUnitResults = predicates.isType '"Bool",
                            targets = predicates.isType '"String",
                            testResultsFiles = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Ant@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "adminPassword",
                              "adminUserName",
                              "machinePassword",
                              "machineUserName",
                              "testMachines"
                            ],
                            predicates.records.record
                            {
                              adminPassword = predicates.isType '"String",
                              adminUserName = predicates.isType '"String",
                              agentLocation = predicates.isType '"String",
                              isDataCollectionOnly = predicates.isType '"Bool",
                              machinePassword = predicates.isType '"String",
                              machineUserName = predicates.isType '"String",
                              runAsProcess = predicates.isType '"Bool",
                              testCertificate = predicates.isType '"Bool",
                              testMachines = predicates.isType '"String",
                              testPlatform = predicates.enum [ "15.0", "14.0" ],
                              updateTestAgent = predicates.isType '"Bool",
                              winRmProtocol = predicates.enum
                                  [ "Http", "Https" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^DeployVisualStudioTestAgent@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "machinePassword",
                              "machineUserName",
                              "testMachineGroup"
                            ],
                            predicates.records.record
                            {
                              adminPassword = predicates.isType '"String",
                              adminUserName = predicates.isType '"String",
                              agentLocation = predicates.isType '"String",
                              isDataCollectionOnly = predicates.isType '"Bool",
                              machinePassword = predicates.isType '"String",
                              machineUserName = predicates.isType '"String",
                              resourceFilteringMethod = predicates.enum
                                  [ "machineNames", "tags" ],
                              runAsProcess = predicates.isType '"Bool",
                              testCertificate = predicates.isType '"Bool",
                              testMachineGroup = predicates.isType '"String",
                              testMachines = predicates.isType '"String",
                              updateTestAgent = predicates.isType '"Bool",
                              winRmProtocol = predicates.enum
                                  [ "Http", "Https" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^DeployVisualStudioTestAgent@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            cleanEnvironment = predicates.isType '"Bool",
                            createCustomEnvironment = predicates.isType '"Bool",
                            createOptions = predicates.isType '"String",
                            environmentName = predicates.isType '"String",
                            installOptions = predicates.isType '"String",
                            packageSpecs = predicates.isType '"String",
                            updateConda = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^CondaEnvironment@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "environmentName" ],
                            predicates.records.record
                            {
                              cleanEnvironment = predicates.isType '"Bool",
                              createOptions = predicates.isType '"String",
                              environmentName = predicates.isType '"String",
                              packageSpecs = predicates.isType '"String",
                              updateConda = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^CondaEnvironment@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "filename" ],
                            predicates.records.record
                            {
                              arguments = predicates.isType '"String",
                              failOnStandardError = predicates.isType '"Bool",
                              filename = predicates.isType '"String",
                              modifyEnvironment = predicates.isType '"Bool",
                              workingFolder = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^BatchScript@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "externalRegistryCredentials",
                              "packageName",
                              "version"
                            ],
                            predicates.records.record
                            {
                              externalRegistryCredentials = predicates.isType
                                  '"String",
                              installDirectory = predicates.isType '"String",
                              packageName = predicates.isType '"String",
                              version = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^DownloadGithubNpmPackage@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            clean = predicates.isType '"Bool",
                            configuration = predicates.isType '"String",
                            createLogFile = predicates.isType '"Bool",
                            customVersion = predicates.isType '"String",
                            enableDefaultLogger = predicates.isType '"Bool",
                            logFileVerbosity = predicates.enum
                                [
                                  "quiet",
                                  "minimal",
                                  "normal",
                                  "detailed",
                                  "diagnostic"
                                ],
                            logProjectEvents = predicates.isType '"Bool",
                            maximumCpuCount = predicates.isType '"Bool",
                            msbuildArchitecture = predicates.enum
                                [ "x86", "x64" ],
                            msbuildArgs = predicates.isType '"String",
                            platform = predicates.isType '"String",
                            restoreNugetPackages = predicates.isType '"Bool",
                            solution = predicates.isType '"String",
                            vsVersion = predicates.enum
                                [
                                  "latest",
                                  "17.0",
                                  "16.0",
                                  "15.0",
                                  "14.0",
                                  "12.0",
                                  "11.0"
                                ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^VSBuild@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "KeyVaultName", "azureSubscription" ],
                            predicates.records.record
                            {
                              KeyVaultName = predicates.isType '"String",
                              RunAsPreJob = predicates.isType '"Bool",
                              SecretsFilter = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureKeyVault@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "KeyVaultName", "azureSubscription" ],
                            predicates.records.record
                            {
                              KeyVaultName = predicates.isType '"String",
                              RunAsPreJob = predicates.isType '"Bool",
                              SecretsFilter = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureKeyVault@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            packageType = predicates.enum [ "runtime", "sdk" ],
                            version = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^DotNetCoreInstaller@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            includePreviewVersions = predicates.isType '"Bool",
                            installationPath = predicates.isType '"String",
                            packageType = predicates.enum [ "runtime", "sdk" ],
                            performMultiLevelLookup = predicates.isType '"Bool",
                            version = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^DotNetCoreInstaller@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            includePreviewVersions = predicates.isType '"Bool",
                            installationPath = predicates.isType '"String",
                            packageType = predicates.enum [ "runtime", "sdk" ],
                            performMultiLevelLookup = predicates.isType '"Bool",
                            useGlobalJson = predicates.isType '"Bool",
                            version = predicates.isType '"String",
                            vsVersion = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^UseDotNet@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "WebAppName", "azureSubscription" ],
                            predicates.records.record
                            {
                              Action = predicates.enum
                                  [
                                    "Swap Slots",
                                    "Start Azure App Service",
                                    "Stop Azure App Service",
                                    "Restart Azure App Service",
                                    "Start Swap With Preview",
                                    "Complete Swap",
                                    "Cancel Swap",
                                    "Delete Slot",
                                    "Install Extensions",
                                    "Enable Continuous Monitoring",
                                    "Start all continuous webjobs",
                                    "Stop all continuous webjobs"
                                  ],
                              AppInsightsResourceGroupName = predicates.isType
                                  '"String",
                              ApplicationInsightsResourceName =
                                predicates.isType '"String",
                              ApplicationInsightsWebTestName = predicates.isType
                                  '"String",
                              ExtensionsList = predicates.isType '"String",
                              OutputVariable = predicates.isType '"String",
                              PreserveVnet = predicates.isType '"Bool",
                              ResourceGroupName = predicates.isType '"String",
                              Slot = predicates.isType '"String",
                              SourceSlot = predicates.isType '"String",
                              SpecifySlotOrASE = predicates.isType '"Bool",
                              SwapWithProduction = predicates.isType '"Bool",
                              TargetSlot = predicates.isType '"String",
                              WebAppName = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureAppServiceManage@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          { kubeloginVersion = predicates.isType '"String", }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^KubeloginInstaller@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          { version = predicates.isType '"String", }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^FuncToolsInstaller@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            enableXmlTransform = predicates.isType '"Bool",
                            fileType = predicates.enum [ "xml", "json" ],
                            folderPath = predicates.isType '"String",
                            targetFiles = predicates.isType '"String",
                            xmlTransformationRules = predicates.isType
                                '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^FileTransform@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            folderPath = predicates.isType '"String",
                            jsonTargetFiles = predicates.isType '"String",
                            xmlTargetFiles = predicates.isType '"String",
                            xmlTransformationRules = predicates.isType
                                '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^FileTransform@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "destinationFolder" ],
                            predicates.records.record
                            {
                              archiveFilePatterns = predicates.isType '"String",
                              cleanDestinationFolder = predicates.isType
                                  '"Bool",
                              destinationFolder = predicates.isType '"String",
                              overwriteExistingFiles = predicates.isType
                                  '"Bool",
                              pathToSevenZipTool = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^ExtractFiles@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            clean = predicates.isType '"Bool",
                            configuration = predicates.isType '"String",
                            createAppPackage = predicates.isType '"Bool",
                            jdkArchitectureOption = predicates.enum
                                [ "x86", "x64" ],
                            jdkDirectory = predicates.isType '"String",
                            jdkOption = predicates.enum
                                [ "JDKVersion", "Path" ],
                            jdkVersionOption = predicates.enum
                                [
                                  "default",
                                  "1.11",
                                  "1.10",
                                  "1.9",
                                  "1.8",
                                  "1.7",
                                  "1.6"
                                ],
                            msbuildArchitectureOption = predicates.enum
                                [ "x86", "x64" ],
                            msbuildArguments = predicates.isType '"String",
                            msbuildFile = predicates.isType '"String",
                            msbuildLocationOption = predicates.enum
                                [ "version", "location" ],
                            msbuildVersionOption = predicates.enum
                                [
                                  "latest",
                                  "17.0",
                                  "16.0",
                                  "15.0",
                                  "14.0",
                                  "12.0",
                                  "4.0"
                                ],
                            outputDirectory = predicates.isType '"String",
                            projectFile = predicates.isType '"String",
                            target = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^XamarinAndroid@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "ArtifactName", "ArtifactType", "Contents" ],
                            predicates.records.record
                            {
                              ArtifactName = predicates.isType '"String",
                              ArtifactType = predicates.enum
                                  [ "Container", "FilePath" ],
                              Contents = predicates.isType '"String",
                              CopyRoot = predicates.isType '"String",
                              TargetPath = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^CopyPublishBuildArtifacts@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "definition", "feed", "version" ],
                            predicates.records.record
                            {
                              definition = predicates.isType '"String",
                              downloadPath = predicates.isType '"String",
                              feed = predicates.isType '"String",
                              version = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^DownloadPackage@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "definition", "feed", "version" ],
                            predicates.records.record
                            {
                              definition = predicates.isType '"String",
                              downloadPath = predicates.isType '"String",
                              extract = predicates.isType '"Bool",
                              feed = predicates.isType '"String",
                              files = predicates.isType '"String",
                              packageType = predicates.enum
                                  [
                                    "maven",
                                    "npm",
                                    "nuget",
                                    "pypi",
                                    "upack",
                                    "cargo"
                                  ],
                              version = predicates.isType '"String",
                              view = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^DownloadPackage@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "azureSubscription", "resourceGroupName" ],
                            predicates.records.record
                            {
                              action = predicates.enum
                                  [
                                    "Create Or Update Resource Group",
                                    "Select Resource Group",
                                    "Start",
                                    "Stop",
                                    "StopWithDeallocate",
                                    "Restart",
                                    "Delete",
                                    "DeleteRG"
                                  ],
                              addSpnToEnvironment = predicates.isType '"Bool",
                              azureSubscription = predicates.isType '"String",
                              copyAzureVMTags = predicates.isType '"Bool",
                              csmFile = predicates.isType '"String",
                              csmFileLink = predicates.isType '"String",
                              csmParametersFile = predicates.isType '"String",
                              csmParametersFileLink = predicates.isType
                                  '"String",
                              deploymentGroupName = predicates.isType '"String",
                              deploymentMode = predicates.enum
                                  [ "Incremental", "Complete", "Validation" ],
                              deploymentName = predicates.isType '"String",
                              deploymentOutputs = predicates.isType '"String",
                              enableDeploymentPrerequisites = predicates.enum
                                  [
                                    "None",
                                    "ConfigureVMwithWinRM",
                                    "ConfigureVMWithDGAgent"
                                  ],
                              location = predicates.isType '"String",
                              outputVariable = predicates.isType '"String",
                              overrideParameters = predicates.isType '"String",
                              password = predicates.isType '"String",
                              resourceGroupName = predicates.isType '"String",
                              runAgentServiceAsUser = predicates.isType '"Bool",
                              teamProject = predicates.isType '"String",
                              teamServicesConnection = predicates.isType
                                  '"String",
                              templateLocation = predicates.enum
                                  [ "Linked artifact", "URL of the file" ],
                              useWithoutJSON = predicates.isType '"Bool",
                              userName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureResourceGroupDeployment@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "azureResourceManagerConnection" ],
                            predicates.records.record
                            {
                              action = predicates.enum
                                  [
                                    "Create Or Update Resource Group",
                                    "DeleteRG"
                                  ],
                              addSpnToEnvironment = predicates.isType '"Bool",
                              azureResourceManagerConnection = predicates.isType
                                  '"String",
                              csmFile = predicates.isType '"String",
                              csmFileLink = predicates.isType '"String",
                              csmParametersFile = predicates.isType '"String",
                              csmParametersFileLink = predicates.isType
                                  '"String",
                              deploymentMode = predicates.enum
                                  [ "Incremental", "Complete", "Validation" ],
                              deploymentName = predicates.isType '"String",
                              deploymentOutputs = predicates.isType '"String",
                              deploymentScope = predicates.enum
                                  [
                                    "Management Group",
                                    "Subscription",
                                    "Resource Group"
                                  ],
                              location = predicates.isType '"String",
                              overrideParameters = predicates.isType '"String",
                              resourceGroupName = predicates.isType '"String",
                              subscriptionId = predicates.isType '"String",
                              templateLocation = predicates.enum
                                  [ "Linked artifact", "URL of the file" ],
                              useWithoutJSON = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureResourceManagerTemplateDeployment@3$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            ConnectedServiceName = predicates.isType '"String",
                            ConnectedServiceNameClassic = predicates.isType
                                '"String",
                            ConnectedServiceNameSelector = predicates.enum
                                [
                                  "ConnectedServiceName",
                                  "ConnectedServiceNameClassic"
                                ],
                            action = predicates.enum
                                [
                                  "Create Or Update Resource Group",
                                  "Select Resource Group",
                                  "Start",
                                  "Stop",
                                  "Restart",
                                  "Delete",
                                  "DeleteRG"
                                ],
                            actionClassic = predicates.enum
                                [ "Select Resource Group" ],
                            cloudService = predicates.isType '"String",
                            csmFile = predicates.isType '"String",
                            csmParametersFile = predicates.isType '"String",
                            deploymentMode = predicates.enum
                                [ "Validation", "Incremental", "Complete" ],
                            enableDeploymentPrerequisitesForCreate =
                              predicates.isType '"Bool",
                            enableDeploymentPrerequisitesForSelect =
                              predicates.isType '"Bool",
                            location = predicates.enum
                                [
                                  "Australia East",
                                  "Australia Southeast",
                                  "Brazil South",
                                  "Canada Central",
                                  "Canada East",
                                  "Central India",
                                  "Central US",
                                  "East Asia",
                                  "East US",
                                  "East US 2 ",
                                  "Japan East",
                                  "Japan West",
                                  "North Central US",
                                  "North Europe",
                                  "South Central US",
                                  "South India",
                                  "Southeast Asia",
                                  "UK South",
                                  "UK West",
                                  "West Central US",
                                  "West Europe",
                                  "West India",
                                  "West US",
                                  "West US 2"
                                ],
                            outputVariable = predicates.isType '"String",
                            overrideParameters = predicates.isType '"String",
                            resourceGroupName = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^AzureResourceGroupDeployment@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "serviceConnection" ],
                            predicates.records.record
                            {
                              body = predicates.isType '"String",
                              headers = predicates.isType '"String",
                              method = predicates.enum
                                  [
                                    "OPTIONS",
                                    "GET",
                                    "HEAD",
                                    "POST",
                                    "PUT",
                                    "DELETE",
                                    "TRACE",
                                    "PATCH"
                                  ],
                              serviceConnection = predicates.isType '"String",
                              successCriteria = predicates.isType '"String",
                              urlSuffix = predicates.isType '"String",
                              waitForCompletion = predicates.enum
                                  [ "true", "false" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^InvokeRESTAPI@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            azureServiceConnection = predicates.isType
                                '"String",
                            body = predicates.isType '"String",
                            connectionType = predicates.enum
                                [
                                  "connectedServiceName",
                                  "connectedServiceNameARM"
                                ],
                            headers = predicates.isType '"String",
                            method = predicates.enum
                                [
                                  "OPTIONS",
                                  "GET",
                                  "HEAD",
                                  "POST",
                                  "PUT",
                                  "DELETE",
                                  "TRACE",
                                  "PATCH"
                                ],
                            serviceConnection = predicates.isType '"String",
                            successCriteria = predicates.isType '"String",
                            urlSuffix = predicates.isType '"String",
                            waitForCompletion = predicates.enum
                                [ "true", "false" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^InvokeRESTAPI@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            archiveFile = predicates.isType '"String",
                            archiveType = predicates.enum
                                [ "default", "7z", "tar", "wim" ],
                            includeRootFolder = predicates.isType '"Bool",
                            replaceExistingArchive = predicates.isType '"Bool",
                            rootFolder = predicates.isType '"String",
                            tarCompression = predicates.enum
                                [ "gz", "bz2", "xz", "none" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^ArchiveFiles@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            archiveFile = predicates.isType '"String",
                            archiveType = predicates.enum
                                [ "zip", "7z", "tar", "wim" ],
                            includeRootFolder = predicates.isType '"Bool",
                            quiet = predicates.isType '"Bool",
                            replaceExistingArchive = predicates.isType '"Bool",
                            rootFolderOrFile = predicates.isType '"String",
                            sevenZipCompression = predicates.enum
                                [
                                  "ultra",
                                  "maximum",
                                  "normal",
                                  "fast",
                                  "fastest",
                                  "none"
                                ],
                            tarCompression = predicates.enum
                                [ "gz", "bz2", "xz", "none" ],
                            verbose = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^ArchiveFiles@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "gitHubConnection" ],
                            predicates.records.record
                            {
                              comment = predicates.isType '"String",
                              gitHubConnection = predicates.isType '"String",
                              id = predicates.isType '"String",
                              repositoryName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^GitHubComment@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "TargetFolder" ],
                            predicates.records.record
                            {
                              CleanTargetFolder = predicates.isType '"Bool",
                              Contents = predicates.isType '"String",
                              OverWrite = predicates.isType '"Bool",
                              SourceFolder = predicates.isType '"String",
                              TargetFolder = predicates.isType '"String",
                              flattenFolders = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^CopyFiles@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "TargetFolder" ],
                            predicates.records.record
                            {
                              CleanTargetFolder = predicates.isType '"Bool",
                              Contents = predicates.isType '"String",
                              OverWrite = predicates.isType '"Bool",
                              SourceFolder = predicates.isType '"String",
                              TargetFolder = predicates.isType '"String",
                              delayBetweenRetries = predicates.isType '"String",
                              flattenFolders = predicates.isType '"Bool",
                              ignoreMakeDirErrors = predicates.isType '"Bool",
                              preserveTimestamp = predicates.isType '"Bool",
                              retryCount = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^CopyFiles@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "ServerName",
                              "SqlPassword",
                              "SqlUsername",
                              "azureSubscription"
                            ],
                            predicates.records.record
                            {
                              DatabaseName = predicates.isType '"String",
                              DeleteFirewallRule = predicates.isType '"Bool",
                              EndIpAddress = predicates.isType '"String",
                              IpDetectionMethod = predicates.enum
                                  [ "AutoDetect", "IPAddressRange" ],
                              ServerName = predicates.isType '"String",
                              SqlAdditionalArguments = predicates.isType
                                  '"String",
                              SqlFile = predicates.isType '"String",
                              SqlInline = predicates.isType '"String",
                              SqlPassword = predicates.isType '"String",
                              SqlUsername = predicates.isType '"String",
                              StartIpAddress = predicates.isType '"String",
                              TaskNameSelector = predicates.enum
                                  [ "SqlTaskFile", "InlineSqlTask" ],
                              azureSubscription = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureMysqlDeployment@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            command = predicates.isType '"String",
                            cwd = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Npm@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            command = predicates.enum
                                [ "ci", "install", "publish", "custom" ],
                            customCommand = predicates.isType '"String",
                            customEndpoint = predicates.isType '"String",
                            customFeed = predicates.isType '"String",
                            customRegistry = predicates.enum
                                [ "useNpmrc", "useFeed" ],
                            publishEndpoint = predicates.isType '"String",
                            publishFeed = predicates.isType '"String",
                            publishPackageMetadata = predicates.isType '"Bool",
                            publishRegistry = predicates.enum
                                [ "useExternalRegistry", "useFeed" ],
                            verbose = predicates.isType '"Bool",
                            workingDir = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Npm@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            api_build_command = predicates.isType '"String",
                            api_location = predicates.isType '"String",
                            app_build_command = predicates.isType '"String",
                            app_location = predicates.isType '"String",
                            azure_static_web_apps_api_token = predicates.isType
                                '"String",
                            build_timeout_in_minutes = predicates.isType
                                'Integer,
                            config_file_location = predicates.isType '"String",
                            data_api_location = predicates.isType '"String",
                            deployment_environment = predicates.isType
                                '"String",
                            is_static_export = predicates.isType '"Bool",
                            output_location = predicates.isType '"String",
                            production_branch = predicates.isType '"String",
                            routes_location = predicates.isType '"String",
                            skip_api_build = predicates.isType '"Bool",
                            skip_app_build = predicates.isType '"Bool",
                            verbose = predicates.isType '"Bool",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^AzureStaticWebApp@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            checkLatest = predicates.isType '"Bool",
                            force32bit = predicates.isType '"Bool",
                            version = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^UseNode@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            checkLatest = predicates.isType '"Bool",
                            force32bit = predicates.isType '"Bool",
                            nodejsMirror = predicates.isType '"String",
                            versionFilePath = predicates.isType '"String",
                            versionSource = predicates.enum
                                [ "spec", "fromFile" ],
                            versionSpec = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^NodeTool@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "DacpacFile", "EnvironmentName" ],
                            predicates.records.record
                            {
                              AdditionalArguments = predicates.isType '"String",
                              AdminPassword = predicates.isType '"String",
                              AdminUserName = predicates.isType '"String",
                              ConnectionString = predicates.isType '"String",
                              DacpacFile = predicates.isType '"String",
                              DatabaseName = predicates.isType '"String",
                              DeployInParallel = predicates.isType '"Bool",
                              EnvironmentName = predicates.isType '"String",
                              MachineFilter = predicates.isType '"String",
                              Protocol = predicates.enum [ "Http", "Https" ],
                              PublishProfile = predicates.isType '"String",
                              ResourceFilteringMethod = predicates.enum
                                  [ "machineNames", "tags" ],
                              ServerName = predicates.isType '"String",
                              SqlPassword = predicates.isType '"String",
                              SqlUsername = predicates.isType '"String",
                              TargetMethod = predicates.enum
                                  [
                                    "server",
                                    "connectionString",
                                    "publishProfile"
                                  ],
                              TestCertificate = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^SqlServerDacpacDeployment@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            customFeed = predicates.isType '"String",
                            netShare = predicates.isType '"String",
                            packageFeedSelector = predicates.enum
                                [ "nugetOrg", "customFeed", "netShare" ],
                            password = predicates.isType '"String",
                            testPlatformVersion = predicates.isType '"String",
                            username = predicates.isType '"String",
                            versionSelector = predicates.enum
                                [
                                  "latestPreRelease",
                                  "latestStable",
                                  "specificVersion"
                                ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^VisualStudioTestPlatformInstaller@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "azureSubscription" ],
                            predicates.records.record
                            {
                              azureSubscription = predicates.isType '"String",
                              certificateString = predicates.isType '"String",
                              messageBody = predicates.isType '"String",
                              sessionId = predicates.isType '"String",
                              signPayload = predicates.isType '"Bool",
                              signatureKey = predicates.isType '"String",
                              useDataContractSerializer = predicates.isType
                                  '"Bool",
                              waitForCompletion = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^PublishToAzureServiceBus@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "azureSubscription" ],
                            predicates.records.record
                            {
                              azureSubscription = predicates.isType '"String",
                              messageBody = predicates.isType '"String",
                              waitForCompletion = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^PublishToAzureServiceBus@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            action = predicates.enum
                                [
                                  "bake",
                                  "createSecret",
                                  "delete",
                                  "deploy",
                                  "patch",
                                  "promote",
                                  "scale",
                                  "reject"
                                ],
                            arguments = predicates.isType '"String",
                            azureResourceGroup = predicates.isType '"String",
                            azureSubscriptionConnection = predicates.isType
                                '"String",
                            baselineAndCanaryReplicas = predicates.isType
                                '"String",
                            connectionType = predicates.enum
                                [
                                  "azureResourceManager",
                                  "kubernetesServiceConnection"
                                ],
                            containers = predicates.isType '"String",
                            dockerComposeFile = predicates.isType '"String",
                            dockerRegistryEndpoint = predicates.isType
                                '"String",
                            helmChart = predicates.isType '"String",
                            imagePullSecrets = predicates.isType '"String",
                            kind = predicates.enum
                                [ "deployment", "replicaset", "statefulset" ],
                            kubernetesCluster = predicates.isType '"String",
                            kubernetesServiceConnection = predicates.isType
                                '"String",
                            kustomizationPath = predicates.isType '"String",
                            manifests = predicates.isType '"String",
                            mergeStrategy = predicates.enum
                                [ "json", "merge", "strategic" ],
                            name = predicates.isType '"String",
                            namespace = predicates.isType '"String",
                            overrideFiles = predicates.isType '"String",
                            overrides = predicates.isType '"String",
                            patch = predicates.isType '"String",
                            percentage = predicates.isType '"String",
                            releaseName = predicates.isType '"String",
                            renderType = predicates.enum
                                [ "helm", "kompose", "kustomize" ],
                            replicas = predicates.isType '"String",
                            resourceFileToPatch = predicates.isType '"String",
                            resourceToPatch = predicates.enum
                                [ "file", "name" ],
                            rolloutStatusTimeout = predicates.isType '"String",
                            secretArguments = predicates.isType '"String",
                            secretName = predicates.isType '"String",
                            secretType = predicates.enum
                                [ "dockerRegistry", "generic" ],
                            strategy = predicates.enum [ "canary", "none" ],
                            trafficSplitMethod = predicates.enum
                                [ "pod", "smi" ],
                            useClusterAdmin = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^KubernetesManifest@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            action = predicates.enum
                                [
                                  "bake",
                                  "createSecret",
                                  "delete",
                                  "deploy",
                                  "patch",
                                  "promote",
                                  "scale",
                                  "reject"
                                ],
                            arguments = predicates.isType '"String",
                            baselineAndCanaryReplicas = predicates.isType
                                '"String",
                            containers = predicates.isType '"String",
                            dockerComposeFile = predicates.isType '"String",
                            dockerRegistryEndpoint = predicates.isType
                                '"String",
                            helmChart = predicates.isType '"String",
                            imagePullSecrets = predicates.isType '"String",
                            kind = predicates.enum
                                [ "deployment", "replicaset", "statefulset" ],
                            kubernetesServiceConnection = predicates.isType
                                '"String",
                            kustomizationPath = predicates.isType '"String",
                            manifests = predicates.isType '"String",
                            mergeStrategy = predicates.enum
                                [ "json", "merge", "strategic" ],
                            name = predicates.isType '"String",
                            namespace = predicates.isType '"String",
                            overrideFiles = predicates.isType '"String",
                            overrides = predicates.isType '"String",
                            patch = predicates.isType '"String",
                            percentage = predicates.isType '"String",
                            releaseName = predicates.isType '"String",
                            renderType = predicates.enum
                                [ "helm", "kompose", "kustomize" ],
                            replicas = predicates.isType '"String",
                            resourceFileToPatch = predicates.isType '"String",
                            resourceToPatch = predicates.enum
                                [ "file", "name" ],
                            rolloutStatusTimeout = predicates.isType '"String",
                            secretArguments = predicates.isType '"String",
                            secretName = predicates.isType '"String",
                            secretType = predicates.enum
                                [ "dockerRegistry", "generic" ],
                            strategy = predicates.enum [ "canary", "none" ],
                            trafficSplitMethod = predicates.enum
                                [ "pod", "smi" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^KubernetesManifest@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            allowPartiallySucceededBuilds = predicates.isType
                                '"Bool",
                            artifactName = predicates.isType '"String",
                            branchName = predicates.isType '"String",
                            buildId = predicates.isType '"String",
                            buildType = predicates.enum
                                [ "current", "specific" ],
                            buildVersionToDownload = predicates.enum
                                [ "latest", "latestFromBranch", "specific" ],
                            checkDownloadedFiles = predicates.isType '"Bool",
                            cleanDestinationFolder = predicates.isType '"Bool",
                            downloadPath = predicates.isType '"String",
                            downloadType = predicates.enum
                                [ "single", "specific" ],
                            extractTars = predicates.isType '"Bool",
                            itemPattern = predicates.isType '"String",
                            parallelizationLimit = predicates.isType '"String",
                            pipeline = predicates.isType '"String",
                            project = predicates.isType '"String",
                            retryDownloadCount = predicates.isType '"String",
                            specificBuildWithTriggering = predicates.isType
                                '"Bool",
                            tags = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^DownloadBuildArtifacts@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            allowPartiallySucceededBuilds = predicates.isType
                                '"Bool",
                            artifactName = predicates.isType '"String",
                            branchName = predicates.isType '"String",
                            buildId = predicates.isType '"String",
                            buildType = predicates.enum
                                [ "current", "specific" ],
                            buildVersionToDownload = predicates.enum
                                [ "latest", "latestFromBranch", "specific" ],
                            checkDownloadedFiles = predicates.isType '"Bool",
                            cleanDestinationFolder = predicates.isType '"Bool",
                            downloadPath = predicates.isType '"String",
                            downloadType = predicates.enum
                                [ "single", "specific" ],
                            extractTars = predicates.isType '"Bool",
                            itemPattern = predicates.isType '"String",
                            parallelizationLimit = predicates.isType '"String",
                            pipeline = predicates.isType '"String",
                            project = predicates.isType '"String",
                            retryDownloadCount = predicates.isType '"String",
                            specificBuildWithTriggering = predicates.isType
                                '"Bool",
                            tags = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^DownloadBuildArtifacts@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            forceRepoUpdate = predicates.isType '"Bool",
                            projectDirectory = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^CocoaPods@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "AppName",
                              "AzureSpringCloud",
                              "azureSubscription"
                            ],
                            predicates.records.record
                            {
                              Action = predicates.enum
                                  [
                                    "Deploy",
                                    "Set Production",
                                    "Delete Staging Deployment"
                                  ],
                              AppName = predicates.isType '"String",
                              AzureSpringCloud = predicates.isType '"String",
                              Builder = predicates.isType '"String",
                              CreateNewDeployment = predicates.isType '"Bool",
                              DeploymentName = predicates.isType '"String",
                              DeploymentType = predicates.enum
                                  [ "Artifacts", "CustomContainer" ],
                              DotNetCoreMainEntryPath = predicates.isType
                                  '"String",
                              EnvironmentVariables = predicates.isType
                                  '"String",
                              ImageArgs = predicates.isType '"String",
                              ImageCommand = predicates.isType '"String",
                              ImageLanguageFramework = predicates.enum
                                  [ "springboot", "" ],
                              ImageName = predicates.isType '"String",
                              JvmOptions = predicates.isType '"String",
                              Package = predicates.isType '"String",
                              RegistryPassword = predicates.isType '"String",
                              RegistryServer = predicates.isType '"String",
                              RegistryUsername = predicates.isType '"String",
                              RuntimeVersion = predicates.enum
                                  [ "Java_8", "Java_11", "NetCore_31" ],
                              UseStagingDeployment = predicates.isType '"Bool",
                              Version = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureSpringCloud@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "appName", "appType", "azureSubscription" ],
                            predicates.records.record
                            {
                              appName = predicates.isType '"String",
                              appSettings = predicates.isType '"String",
                              appType = predicates.enum
                                  [ "webApp", "webAppLinux" ],
                              azureSubscription = predicates.isType '"String",
                              configurationStrings = predicates.isType
                                  '"String",
                              customDeployFolder = predicates.isType '"String",
                              customWebConfig = predicates.isType '"String",
                              deployToSlotOrASE = predicates.isType '"Bool",
                              deploymentMethod = predicates.enum
                                  [ "auto", "zipDeploy", "runFromPackage" ],
                              package = predicates.isType '"String",
                              resourceGroupName = predicates.isType '"String",
                              runtimeStack = predicates.isType '"String",
                              slotName = predicates.isType '"String",
                              startUpCommand = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureWebApp@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "azureSubscription" ],
                            predicates.records.record
                            {
                              addSpnToEnvironment = predicates.isType '"Bool",
                              arguments = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                              failOnStandardError = predicates.isType '"Bool",
                              inlineScript = predicates.isType '"String",
                              scriptLocation = predicates.enum
                                  [ "inlineScript", "scriptPath" ],
                              scriptPath = predicates.isType '"String",
                              useGlobalConfig = predicates.isType '"Bool",
                              workingDirectory = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureCLI@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            args = predicates.isType '"String",
                            connectedServiceName = predicates.isType '"String",
                            connectedServiceNameARM = predicates.isType
                                '"String",
                            connectedServiceNameSelector = predicates.enum
                                [
                                  "connectedServiceName",
                                  "connectedServiceNameARM"
                                ],
                            cwd = predicates.isType '"String",
                            failOnStandardError = predicates.isType '"Bool",
                            inlineScript = predicates.isType '"String",
                            scriptLocation = predicates.enum
                                [ "inlineScript", "scriptPath" ],
                            scriptPath = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^AzureCLI@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "azureSubscription", "scriptType" ],
                            predicates.records.record
                            {
                              addSpnToEnvironment = predicates.isType '"Bool",
                              arguments = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                              failOnStandardError = predicates.isType '"Bool",
                              inlineScript = predicates.isType '"String",
                              powerShellErrorActionPreference = predicates.enum
                                  [ "stop", "continue", "silentlyContinue" ],
                              powerShellIgnoreLASTEXITCODE = predicates.isType
                                  '"Bool",
                              scriptLocation = predicates.enum
                                  [ "inlineScript", "scriptPath" ],
                              scriptPath = predicates.isType '"String",
                              scriptType = predicates.enum
                                  [ "ps", "pscore", "batch", "bash" ],
                              useGlobalConfig = predicates.isType '"Bool",
                              workingDirectory = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^AzureCLI@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "gitHubConnection" ],
                            predicates.records.record
                            {
                              action = predicates.enum
                                  [ "create", "edit", "delete" ],
                              addChangeLog = predicates.isType '"Bool",
                              assetUploadMode = predicates.enum
                                  [ "delete", "replace" ],
                              assets = predicates.isType '"String",
                              changeLogCompareToRelease = predicates.enum
                                  [
                                    "lastFullRelease",
                                    "lastNonDraftRelease",
                                    "lastNonDraftReleaseByTag"
                                  ],
                              changeLogCompareToReleaseTag = predicates.isType
                                  '"String",
                              changeLogLabels = predicates.isType '"String",
                              changeLogType = predicates.enum
                                  [ "commitBased", "issueBased" ],
                              gitHubConnection = predicates.isType '"String",
                              isDraft = predicates.isType '"Bool",
                              isPreRelease = predicates.isType '"Bool",
                              releaseNotes = predicates.isType '"String",
                              releaseNotesFile = predicates.isType '"String",
                              releaseNotesSource = predicates.enum
                                  [ "file", "input" ],
                              repositoryName = predicates.isType '"String",
                              tag = predicates.isType '"String",
                              tagPattern = predicates.isType '"String",
                              tagSource = predicates.enum [ "auto", "manual" ],
                              target = predicates.isType '"String",
                              title = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^GitHubRelease@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "gitHubConnection" ],
                            predicates.records.record
                            {
                              action = predicates.enum
                                  [ "create", "edit", "delete" ],
                              addChangeLog = predicates.isType '"Bool",
                              assetUploadMode = predicates.enum
                                  [ "delete", "replace" ],
                              assets = predicates.isType '"String",
                              changeLogCompareToRelease = predicates.enum
                                  [
                                    "lastFullRelease",
                                    "lastNonDraftRelease",
                                    "lastNonDraftReleaseByTag"
                                  ],
                              changeLogCompareToReleaseTag = predicates.isType
                                  '"String",
                              changeLogLabels = predicates.isType '"String",
                              changeLogType = predicates.enum
                                  [ "commitBased", "issueBased" ],
                              gitHubConnection = predicates.isType '"String",
                              isDraft = predicates.isType '"Bool",
                              isPreRelease = predicates.isType '"Bool",
                              releaseNotesFilePath = predicates.isType
                                  '"String",
                              releaseNotesInline = predicates.isType '"String",
                              releaseNotesSource = predicates.enum
                                  [ "filePath", "inline" ],
                              repositoryName = predicates.isType '"String",
                              tag = predicates.isType '"String",
                              tagPattern = predicates.isType '"String",
                              tagSource = predicates.enum
                                  [ "gitTag", "userSpecifiedTag" ],
                              target = predicates.isType '"String",
                              title = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^GitHubRelease@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "files", "url" ],
                            predicates.records.record
                            {
                              files = predicates.isType '"String",
                              options = predicates.isType '"String",
                              password = predicates.isType '"String",
                              redirectStderr = predicates.isType '"Bool",
                              url = predicates.isType '"String",
                              username = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^cURLUploader@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "files" ],
                            predicates.records.record
                            {
                              authType = predicates.enum
                                  [ "ServiceEndpoint", "UserAndPass" ],
                              files = predicates.isType '"String",
                              options = predicates.isType '"String",
                              password = predicates.isType '"String",
                              redirectStderr = predicates.isType '"Bool",
                              remotePath = predicates.isType '"String",
                              serviceEndpoint = predicates.isType '"String",
                              url = predicates.isType '"String",
                              username = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^cURLUploader@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "appName",
                              "azureSubscription",
                              "resourceGroupName"
                            ],
                            predicates.records.record
                            {
                              appName = predicates.isType '"String",
                              appSettings = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                              connectionStrings = predicates.isType '"String",
                              generalSettings = predicates.isType '"String",
                              resourceGroupName = predicates.isType '"String",
                              slotName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureAppServiceSettings@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            command = predicates.enum [ "download", "publish" ],
                            downloadDirectory = predicates.isType '"String",
                            externalFeedCredentials = predicates.isType
                                '"String",
                            feedDownloadExternal = predicates.isType '"String",
                            feedPublishExternal = predicates.isType '"String",
                            feedsToUse = predicates.enum
                                [ "internal", "external" ],
                            feedsToUsePublish = predicates.enum
                                [ "internal", "external" ],
                            packageDownloadExternal = predicates.isType
                                '"String",
                            packagePublishDescription = predicates.isType
                                '"String",
                            packagePublishExternal = predicates.isType
                                '"String",
                            publishDirectory = predicates.isType '"String",
                            publishFeedCredentials = predicates.isType
                                '"String",
                            publishPackageMetadata = predicates.isType '"Bool",
                            publishedPackageVar = predicates.isType '"String",
                            verbosity = predicates.enum
                                [
                                  "None",
                                  "Trace",
                                  "Debug",
                                  "Information",
                                  "Warning",
                                  "Error",
                                  "Critical"
                                ],
                            versionDownloadExternal = predicates.isType
                                '"String",
                            versionOption = predicates.enum
                                [ "major", "minor", "patch", "custom" ],
                            versionPublish = predicates.isType '"String",
                            vstsFeed = predicates.isType '"String",
                            vstsFeedPackage = predicates.isType '"String",
                            vstsFeedPackagePublish = predicates.isType
                                '"String",
                            vstsFeedPublish = predicates.isType '"String",
                            vstsPackageVersion = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^UniversalPackages@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "azureSubscription" ],
                            predicates.records.record
                            {
                              ResourceGroupName = predicates.isType '"String",
                              Resources = predicates.isType '"String",
                              RetryDuration = predicates.isType '"String",
                              azureSubscription = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzurePolicyCheckGate@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "appName", "dockerRegistryServiceConnection" ],
                            predicates.records.record
                            {
                              appName = predicates.isType '"String",
                              arguments = predicates.isType '"String",
                              azureResourceGroup = predicates.isType '"String",
                              azureSubscriptionConnection = predicates.isType
                                  '"String",
                              connectionType = predicates.enum
                                  [
                                    "Azure Resource Manager",
                                    "Kubernetes Service Connection"
                                  ],
                              dockerHubNamespace = predicates.isType '"String",
                              dockerRegistryServiceConnection =
                                predicates.isType '"String",
                              functionRootDirectory = predicates.isType
                                  '"String",
                              kubernetesCluster = predicates.isType '"String",
                              kubernetesServiceConnection = predicates.isType
                                  '"String",
                              namespace = predicates.isType '"String",
                              secretName = predicates.isType '"String",
                              waitForStability = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureFunctionOnKubernetes@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "appName",
                              "dockerRegistryServiceConnection",
                              "kubernetesServiceConnection"
                            ],
                            predicates.records.record
                            {
                              appName = predicates.isType '"String",
                              arguments = predicates.isType '"String",
                              dockerHubNamespace = predicates.isType '"String",
                              dockerRegistryServiceConnection =
                                predicates.isType '"String",
                              functionRootDirectory = predicates.isType
                                  '"String",
                              kubernetesServiceConnection = predicates.isType
                                  '"String",
                              namespace = predicates.isType '"String",
                              secretName = predicates.isType '"String",
                              waitForStability = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureFunctionOnKubernetes@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            bashEnvValue = predicates.isType '"String",
                            failOnStderr = predicates.isType '"Bool",
                            filePath = predicates.isType '"String",
                            script = predicates.isType '"String",
                            targetType = predicates.enum
                                [ "filePath", "inline" ],
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^Bash@3$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "scriptPath" ],
                            predicates.records.record
                            {
                              args = predicates.isType '"String",
                              cwd = predicates.isType '"String",
                              disableAutoCwd = predicates.isType '"Bool",
                              failOnStandardError = predicates.isType '"Bool",
                              scriptPath = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^ShellScript@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            ArtifactName = predicates.isType '"String",
                            MaxArtifactSize = predicates.isType 'Integer,
                            Parallel = predicates.isType '"Bool",
                            ParallelCount = predicates.isType 'Integer,
                            PathtoPublish = predicates.isType '"String",
                            StoreAsTar = predicates.isType '"Bool",
                            TargetPath = predicates.isType '"String",
                            publishLocation = predicates.enum
                                [ "Container", "FilePath" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern
                          "^PublishBuildArtifacts@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "knownHostsEntry", "sshKeySecureFile" ],
                            predicates.records.record
                            {
                              addEntryToConfig = predicates.isType '"Bool",
                              configHostAlias = predicates.isType '"String",
                              configHostname = predicates.isType '"String",
                              configPort = predicates.isType '"String",
                              configUser = predicates.isType '"String",
                              knownHostsEntry = predicates.isType '"String",
                              sshKeySecureFile = predicates.isType '"String",
                              sshPassphrase = predicates.isType '"String",
                              sshPublicKey = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^InstallSSHKey@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "azureSubscription",
                              "imageUrl",
                              "vmssName",
                              "vmssOsType"
                            ],
                            predicates.records.record
                            {
                              action = predicates.enum
                                  [
                                    "Update image",
                                    "Configure application startup"
                                  ],
                              azureSubscription = predicates.isType '"String",
                              customScript = predicates.isType '"String",
                              customScriptArguments = predicates.isType
                                  '"String",
                              customScriptsDirectory = predicates.isType
                                  '"String",
                              customScriptsStorageAccount = predicates.isType
                                  '"String",
                              imageUrl = predicates.isType '"String",
                              skipArchivingCustomScripts = predicates.isType
                                  '"Bool",
                              vmssName = predicates.isType '"String",
                              vmssOsType = predicates.enum
                                  [ "Windows", "Linux" ],
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureVmssDeployment@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "ConnectedServiceName",
                              "Package",
                              "WebSiteLocation",
                              "WebSiteName"
                            ],
                            predicates.records.record
                            {
                              AdditionalArguments = predicates.isType '"String",
                              ConnectedServiceName = predicates.isType
                                  '"String",
                              Package = predicates.isType '"String",
                              Slot = predicates.isType '"String",
                              WebSiteLocation = predicates.isType '"String",
                              WebSiteName = predicates.isType '"String",
                              doNotDelete = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureWebPowerShellDeployment@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record {  } {  } false
                          predicates.never,
                      task = predicates.strings.pattern "^CondaAuthenticate@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "ARMConnectedServiceName",
                              "ARMStorageAccount",
                              "CsCfg",
                              "CsDef",
                              "CsPkg",
                              "ResourceGroupName",
                              "ServiceLocation",
                              "ServiceName"
                            ],
                            predicates.records.record
                            {
                              ARMConnectedServiceName = predicates.isType
                                  '"String",
                              ARMStorageAccount = predicates.isType '"String",
                              AllowUpgrade = predicates.isType '"Bool",
                              AppendDateTimeToLabel = predicates.isType '"Bool",
                              CsCfg = predicates.isType '"String",
                              CsDef = predicates.isType '"String",
                              CsPkg = predicates.isType '"String",
                              DeploymentLabel = predicates.isType '"String",
                              DiagnosticStorageAccountKeys = predicates.isType
                                  '"String",
                              KeyVault = predicates.isType '"String",
                              ResourceGroupName = predicates.isType '"String",
                              ServiceLocation = predicates.isType '"String",
                              ServiceName = predicates.isType '"String",
                              UpgradeMode = predicates.isType '"String",
                              VerifyRoleInstanceStatus = predicates.isType
                                  '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureCloudPowerShellDeployment@2$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "CsCfg",
                              "CsPkg",
                              "ServiceLocation",
                              "ServiceName",
                              "azureClassicSubscription"
                            ],
                            predicates.records.record
                            {
                              ARMConnectedServiceName = predicates.isType
                                  '"String",
                              ARMStorageAccount = predicates.isType '"String",
                              AllowUpgrade = predicates.isType '"Bool",
                              AppendDateTimeToLabel = predicates.isType '"Bool",
                              CsCfg = predicates.isType '"String",
                              CsPkg = predicates.isType '"String",
                              DeploymentLabel = predicates.isType '"String",
                              DiagnosticStorageAccountKeys = predicates.isType
                                  '"String",
                              EnableAdvancedStorageOptions = predicates.isType
                                  '"Bool",
                              ForceUpgrade = predicates.isType '"Bool",
                              NewServiceAdditionalArguments = predicates.isType
                                  '"String",
                              NewServiceAffinityGroup = predicates.isType
                                  '"String",
                              NewServiceCustomCertificates = predicates.isType
                                  '"String",
                              ServiceLocation = predicates.isType '"String",
                              ServiceName = predicates.isType '"String",
                              SimultaneousUpgrade = predicates.isType '"Bool",
                              StorageAccount = predicates.isType '"String",
                              VerifyRoleInstanceStatus = predicates.isType
                                  '"Bool",
                              azureClassicSubscription = predicates.isType
                                  '"String",
                              slotName = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^AzureCloudPowerShellDeployment@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required [ "configFile" ],
                            predicates.records.record
                            {
                              cargoServiceConnections = predicates.isType
                                  '"String",
                              configFile = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^CargoAuthenticate@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            Contents = predicates.isType '"String",
                            RemoveDotFiles = predicates.isType '"Bool",
                            RemoveSourceFolder = predicates.isType '"Bool",
                            SourceFolder = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^DeleteFiles@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            enableCodeCoverage = predicates.isType '"Bool",
                            gulpFile = predicates.isType '"String",
                            gulpjs = predicates.isType '"String",
                            publishJUnitResults = predicates.isType '"Bool",
                            srcFiles = predicates.isType '"String",
                            targets = predicates.isType '"String",
                            testFiles = predicates.isType '"String",
                            testFramework = predicates.enum
                                [ "Mocha", "Jasmine" ],
                            testResultsFiles = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^gulp@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            arguments = predicates.isType '"String",
                            enableCodeCoverage = predicates.isType '"Bool",
                            gulpFile = predicates.isType '"String",
                            gulpjs = predicates.isType '"String",
                            publishJUnitResults = predicates.isType '"Bool",
                            srcFiles = predicates.isType '"String",
                            targets = predicates.isType '"String",
                            testFiles = predicates.isType '"String",
                            testFramework = predicates.enum
                                [ "Mocha", "Jasmine" ],
                            testResultsFiles = predicates.isType '"String",
                            testRunTitle = predicates.isType '"String",
                            workingDirectory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^gulp@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [ "testName", "websiteUrl" ],
                            predicates.records.record
                            {
                              avgResponseTimeThreshold = predicates.isType
                                  '"String",
                              connectedServiceName = predicates.isType
                                  '"String",
                              geoLocation = predicates.enum
                                  [
                                    "Default",
                                    "Australia East",
                                    "Australia Southeast",
                                    "Brazil South",
                                    "Central India",
                                    "Central US",
                                    "East Asia",
                                    "East US 2",
                                    "East US",
                                    "Japan East",
                                    "Japan West",
                                    "North Central US",
                                    "North Europe",
                                    "South Central US",
                                    "South India",
                                    "Southeast Asia",
                                    "West Europe",
                                    "West US"
                                  ],
                              machineType = predicates.enum [ "0", "2" ],
                              numOfSelfProvisionedAgents = predicates.isType
                                  'Integer,
                              resourceGroupName = predicates.isType '"String",
                              runDuration = predicates.enum
                                  [ "60", "120", "180", "240", "300" ],
                              testName = predicates.isType '"String",
                              vuLoad = predicates.enum
                                  [ "25", "50", "100", "250" ],
                              websiteUrl = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern "^QuickPerfTest@1$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "inputs", "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.allOf
                          [
                            predicates.records.required
                            [
                              "AppPoolName",
                              "AppPoolNameForApplication",
                              "AppPoolNameForWebsite",
                              "Bindings",
                              "ParentWebsiteNameForApplication",
                              "ParentWebsiteNameForVD",
                              "VirtualPathForApplication",
                              "VirtualPathForVD",
                              "WebsiteName"
                            ],
                            predicates.records.record
                            {
                              ActionIISApplicationPool = predicates.enum
                                  [
                                    "CreateOrUpdateAppPool",
                                    "StartAppPool",
                                    "StopAppPool",
                                    "RecycleAppPool"
                                  ],
                              ActionIISWebsite = predicates.enum
                                  [
                                    "CreateOrUpdateWebsite",
                                    "StartWebsite",
                                    "StopWebsite"
                                  ],
                              AddBinding = predicates.isType '"Bool",
                              AnonymousAuthenticationForWebsite =
                                predicates.isType '"Bool",
                              AppCmdCommands = predicates.isType '"String",
                              AppPoolIdentity = predicates.enum
                                  [
                                    "ApplicationPoolIdentity",
                                    "LocalService",
                                    "LocalSystem",
                                    "NetworkService",
                                    "SpecificUser"
                                  ],
                              AppPoolIdentityForApplication = predicates.enum
                                  [
                                    "ApplicationPoolIdentity",
                                    "LocalService",
                                    "LocalSystem",
                                    "NetworkService",
                                    "SpecificUser"
                                  ],
                              AppPoolIdentityForWebsite = predicates.enum
                                  [
                                    "ApplicationPoolIdentity",
                                    "LocalService",
                                    "LocalSystem",
                                    "NetworkService",
                                    "SpecificUser"
                                  ],
                              AppPoolName = predicates.isType '"String",
                              AppPoolNameForApplication = predicates.isType
                                  '"String",
                              AppPoolNameForWebsite = predicates.isType
                                  '"String",
                              AppPoolPassword = predicates.isType '"String",
                              AppPoolPasswordForApplication = predicates.isType
                                  '"String",
                              AppPoolPasswordForWebsite = predicates.isType
                                  '"String",
                              AppPoolUsername = predicates.isType '"String",
                              AppPoolUsernameForApplication = predicates.isType
                                  '"String",
                              AppPoolUsernameForWebsite = predicates.isType
                                  '"String",
                              ApplicationAuthUserName = predicates.isType
                                  '"String",
                              ApplicationAuthUserPassword = predicates.isType
                                  '"String",
                              ApplicationPhysicalPathAuth = predicates.enum
                                  [
                                    "ApplicationUserPassThrough",
                                    "ApplicationWindowsAuth"
                                  ],
                              BasicAuthenticationForWebsite = predicates.isType
                                  '"Bool",
                              Bindings = predicates.isType '"String",
                              ConfigureAuthenticationForWebsite =
                                predicates.isType '"Bool",
                              CreateOrUpdateAppPoolForApplication =
                                predicates.isType '"Bool",
                              CreateOrUpdateAppPoolForWebsite =
                                predicates.isType '"Bool",
                              DotNetVersion = predicates.enum
                                  [ "v4.0", "v2.0", "No Managed Code" ],
                              DotNetVersionForApplication = predicates.enum
                                  [ "v4.0", "v2.0", "No Managed Code" ],
                              DotNetVersionForWebsite = predicates.enum
                                  [ "v4.0", "v2.0", "No Managed Code" ],
                              EnableIIS = predicates.isType '"Bool",
                              HostNameWithHttp = predicates.isType '"String",
                              HostNameWithOutSNI = predicates.isType '"String",
                              HostNameWithSNI = predicates.isType '"String",
                              IISDeploymentType = predicates.enum
                                  [
                                    "IISWebsite",
                                    "IISWebApplication",
                                    "IISVirtualDirectory",
                                    "IISApplicationPool"
                                  ],
                              IPAddress = predicates.isType '"String",
                              ParentWebsiteNameForApplication =
                                predicates.isType '"String",
                              ParentWebsiteNameForVD = predicates.isType
                                  '"String",
                              PhysicalPathForApplication = predicates.isType
                                  '"String",
                              PhysicalPathForVD = predicates.isType '"String",
                              PipeLineMode = predicates.enum
                                  [ "Integrated", "Classic" ],
                              PipeLineModeForApplication = predicates.enum
                                  [ "Integrated", "Classic" ],
                              PipeLineModeForWebsite = predicates.enum
                                  [ "Integrated", "Classic" ],
                              Port = predicates.isType '"String",
                              Protocol = predicates.enum [ "https", "http" ],
                              SSLCertThumbPrint = predicates.isType '"String",
                              ServerNameIndication = predicates.isType '"Bool",
                              StartStopRecycleAppPoolName = predicates.isType
                                  '"String",
                              StartStopWebsiteName = predicates.isType
                                  '"String",
                              VDAuthUserName = predicates.isType '"String",
                              VDAuthUserPassword = predicates.isType '"String",
                              VDPhysicalPathAuth = predicates.enum
                                  [ "VDUserPassThrough", "VDWindowsAuth" ],
                              VirtualPathForApplication = predicates.isType
                                  '"String",
                              VirtualPathForVD = predicates.isType '"String",
                              WebsiteAuthUserName = predicates.isType '"String",
                              WebsiteAuthUserPassword = predicates.isType
                                  '"String",
                              WebsiteName = predicates.isType '"String",
                              WebsitePhysicalPath = predicates.isType '"String",
                              WebsitePhysicalPathAuth = predicates.enum
                                  [
                                    "WebsiteUserPassThrough",
                                    "WebsiteWindowsAuth"
                                  ],
                              WindowsAuthenticationForWebsite =
                                predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      task = predicates.strings.pattern
                          "^IISWebAppManagementOnMachineGroup@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "task" ],
                    predicates.records.record
                    {
                      inputs = predicates.records.record
                          {
                            dockerVersion = predicates.isType '"String",
                            releaseType = predicates.enum
                                [ "stable", "edge", "test", "nightly" ],
                          }
                          {  }
                          false
                          predicates.never,
                      task = predicates.strings.pattern "^DockerInstaller@0$",
                    }
                    {  }
                    true
                    predicates.always
                  ]
                ],
                predicates.records.record
                {
                  condition = predicates.isType '"String",
                  continueOnError = predicates.isType '"Bool",
                  displayName = predicates.isType '"String",
                  enabled = predicates.isType '"String",
                  env = predicates.isType 'Record,
                  inputs = predicates.isType 'Record,
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^[_A-Za-z0-9]*$"
                      ],
                  retryCountOnTaskFailure = predicates.isType 'Integer,
                  task = predicates.anyOf
                      [
                        predicates.enum [ "PowerShell@2" ],
                        predicates.enum [ "PowerShell@1" ],
                        predicates.enum [ "AzurePowerShell@2" ],
                        predicates.enum [ "AzurePowerShell@3" ],
                        predicates.enum [ "AzurePowerShell@4" ],
                        predicates.enum [ "AzurePowerShell@5" ],
                        predicates.enum [ "AzurePowerShell@1" ],
                        predicates.enum [ "MysqlDeploymentOnMachineGroup@1" ],
                        predicates.enum [ "PipAuthenticate@0" ],
                        predicates.enum [ "PipAuthenticate@1" ],
                        predicates.enum [ "Maven@3" ],
                        predicates.enum [ "Maven@4" ],
                        predicates.enum [ "Maven@1" ],
                        predicates.enum [ "Maven@2" ],
                        predicates.enum [ "DotNetCoreCLI@2" ],
                        predicates.enum [ "DotNetCoreCLI@0" ],
                        predicates.enum [ "DotNetCoreCLI@1" ],
                        predicates.enum [ "XamarinComponentRestore@0" ],
                        predicates.enum [ "AzureRmWebAppDeployment@2" ],
                        predicates.enum [ "AzureRmWebAppDeployment@4" ],
                        predicates.enum [ "AzureRmWebAppDeployment@3" ],
                        predicates.enum [ "PowerShellOnTargetMachines@3" ],
                        predicates.enum [ "PowerShellOnTargetMachines@1" ],
                        predicates.enum [ "PowerShellOnTargetMachines@2" ],
                        predicates.enum [ "PublishCodeCoverageResults@1" ],
                        predicates.enum [ "PublishCodeCoverageResults@2" ],
                        predicates.enum
                        [ "RunVisualStudioTestsusingTestAgent@1" ],
                        predicates.enum [ "ManualIntervention@8" ],
                        predicates.enum [ "InstallAppleProvisioningProfile@1" ],
                        predicates.enum [ "InstallAppleProvisioningProfile@0" ],
                        predicates.enum [ "SonarQubePostTest@1" ],
                        predicates.enum [ "PyPIPublisher@0" ],
                        predicates.enum [ "ChefKnife@1" ],
                        predicates.enum [ "GoTool@0" ],
                        predicates.enum [ "XcodePackageiOS@0" ],
                        predicates.enum [ "Go@0" ],
                        predicates.enum [ "PublishPipelineMetadata@0" ],
                        predicates.enum [ "Docker@0" ],
                        predicates.enum [ "Docker@1" ],
                        predicates.enum [ "Docker@2" ],
                        predicates.enum [ "JenkinsQueueJob@1" ],
                        predicates.enum [ "JenkinsQueueJob@2" ],
                        predicates.enum [ "FtpUpload@2" ],
                        predicates.enum [ "FtpUpload@1" ],
                        predicates.enum [ "WindowsMachineFileCopy@2" ],
                        predicates.enum [ "WindowsMachineFileCopy@1" ],
                        predicates.enum [ "AndroidBuild@1" ],
                        predicates.enum [ "TwineAuthenticate@1" ],
                        predicates.enum [ "TwineAuthenticate@0" ],
                        predicates.enum
                        [ "IISWebAppDeploymentOnMachineGroup@0" ],
                        predicates.enum [ "PythonScript@0" ],
                        predicates.enum [ "HelmInstaller@1" ],
                        predicates.enum [ "HelmInstaller@0" ],
                        predicates.enum [ "NodeTaskRunnerInstaller@0" ],
                        predicates.enum [ "XamarinLicense@1" ],
                        predicates.enum [ "NuGetAuthenticate@0" ],
                        predicates.enum [ "NuGetAuthenticate@1" ],
                        predicates.enum [ "DownloadGitHubNugetPackage@1" ],
                        predicates.enum [ "MavenAuthenticate@0" ],
                        predicates.enum [ "ReviewApp@0" ],
                        predicates.enum [ "JavaToolInstaller@0" ],
                        predicates.enum [ "Chef@1" ],
                        predicates.enum [ "AzureFunctionApp@2" ],
                        predicates.enum [ "AzureFunctionApp@1" ],
                        predicates.enum [ "npmAuthenticate@0" ],
                        predicates.enum [ "MSBuild@1" ],
                        predicates.enum [ "PackerBuild@1" ],
                        predicates.enum [ "PackerBuild@0" ],
                        predicates.enum [ "NuGetPackager@0" ],
                        predicates.enum [ "DuffleInstaller@0" ],
                        predicates.enum [ "ServiceFabricUpdateAppVersions@1" ],
                        predicates.enum [ "ServiceFabricUpdateManifests@2" ],
                        predicates.enum [ "AzureMonitor@1" ],
                        predicates.enum [ "AzureMonitor@0" ],
                        predicates.enum [ "AzureNLBManagement@1" ],
                        predicates.enum [ "ApacheJMeterLoadTest@1" ],
                        predicates.enum [ "DockerCompose@0" ],
                        predicates.enum [ "AzureMonitorAlerts@0" ],
                        predicates.enum [ "XamarinTestCloud@1" ],
                        predicates.enum [ "ServiceFabricDeploy@1" ],
                        predicates.enum [ "Xcode@5" ],
                        predicates.enum [ "Xcode@3" ],
                        predicates.enum [ "Xcode@4" ],
                        predicates.enum [ "Xcode@2" ],
                        predicates.enum [ "NuGetPublisher@0" ],
                        predicates.enum [ "queryWorkItems@0" ],
                        predicates.enum [ "AzureWebAppContainer@1" ],
                        predicates.enum
                        [ "SqlDacpacDeploymentOnMachineGroup@0" ],
                        predicates.enum [ "CacheBeta@1" ],
                        predicates.enum [ "Cache@2" ],
                        predicates.enum [ "CacheBeta@0" ],
                        predicates.enum [ "CMake@1" ],
                        predicates.enum [ "AppCenterTest@1" ],
                        predicates.enum [ "VSMobileCenterTest@0" ],
                        predicates.enum [ "DownloadSecureFile@1" ],
                        predicates.enum [ "AzureContainerApps@0" ],
                        predicates.enum [ "AzureContainerApps@1" ],
                        predicates.enum [ "UseRubyVersion@0" ],
                        predicates.enum [ "Grunt@0" ],
                        predicates.enum [ "SqlAzureDacpacDeployment@1" ],
                        predicates.enum [ "ContainerStructureTest@0" ],
                        predicates.enum [ "IISWebAppDeployment@1" ],
                        predicates.enum [ "CloudLoadTest@1" ],
                        predicates.enum [ "KubectlInstaller@0" ],
                        predicates.enum [ "CmdLine@1" ],
                        predicates.enum [ "CmdLine@2" ],
                        predicates.enum [ "NuGet@0" ],
                        predicates.enum [ "ContainerBuild@0" ],
                        predicates.enum [ "NuGetRestore@1" ],
                        predicates.enum [ "NuGetCommand@2" ],
                        predicates.enum [ "NuGetInstaller@0" ],
                        predicates.enum [ "Delay@1" ],
                        predicates.enum [ "XamariniOS@2" ],
                        predicates.enum [ "XamariniOS@1" ],
                        predicates.enum [ "PublishTestResults@1" ],
                        predicates.enum [ "PublishTestResults@2" ],
                        predicates.enum [ "AzureFileCopy@2" ],
                        predicates.enum [ "AzureFileCopy@4" ],
                        predicates.enum [ "AzureFileCopy@5" ],
                        predicates.enum [ "AzureFileCopy@1" ],
                        predicates.enum [ "AzureFileCopy@3" ],
                        predicates.enum [ "PublishSymbols@2" ],
                        predicates.enum [ "PublishSymbols@1" ],
                        predicates.enum [ "CopyFilesOverSSH@0" ],
                        predicates.enum [ "Gradle@3" ],
                        predicates.enum [ "Gradle@1" ],
                        predicates.enum [ "Gradle@2" ],
                        predicates.enum [ "AppCenterDistribute@3" ],
                        predicates.enum [ "AppCenterDistribute@2" ],
                        predicates.enum [ "AppCenterDistribute@0" ],
                        predicates.enum [ "AppCenterDistribute@1" ],
                        predicates.enum [ "NuGetToolInstaller@0" ],
                        predicates.enum [ "NuGetToolInstaller@1" ],
                        predicates.enum [ "JenkinsDownloadArtifacts@1" ],
                        predicates.enum [ "AzureFunctionAppContainer@1" ],
                        predicates.enum [ "DecryptFile@1" ],
                        predicates.enum [ "HelmDeploy@0" ],
                        predicates.enum [ "InstallAppleCertificate@2" ],
                        predicates.enum [ "InstallAppleCertificate@1" ],
                        predicates.enum [ "InstallAppleCertificate@0" ],
                        predicates.enum [ "AzureFunction@1" ],
                        predicates.enum [ "AzureFunction@0" ],
                        predicates.enum [ "OpenPolicyAgentInstaller@0" ],
                        predicates.enum [ "DownloadGitHubRelease@0" ],
                        predicates.enum [ "SSH@0" ],
                        predicates.enum [ "PublishPipelineArtifact@0" ],
                        predicates.enum [ "PublishPipelineArtifact@1" ],
                        predicates.enum [ "SonarQubePreBuild@1" ],
                        predicates.enum [ "DownloadFileshareArtifacts@1" ],
                        predicates.enum [ "Kubernetes@0" ],
                        predicates.enum [ "Kubernetes@1" ],
                        predicates.enum [ "AzureIoTEdge@2" ],
                        predicates.enum [ "ServiceFabricComposeDeploy@0" ],
                        predicates.enum [ "AndroidSigning@2" ],
                        predicates.enum [ "AndroidSigning@3" ],
                        predicates.enum [ "AndroidSigning@1" ],
                        predicates.enum [ "DownloadPipelineArtifact@1" ],
                        predicates.enum [ "DownloadPipelineArtifact@0" ],
                        predicates.enum [ "DownloadPipelineArtifact@2" ],
                        predicates.enum [ "UsePythonVersion@0" ],
                        predicates.enum [ "ServiceFabricPowerShell@1" ],
                        predicates.enum [ "VSTest@3" ],
                        predicates.enum [ "VSTest@1" ],
                        predicates.enum [ "VSTest@2" ],
                        predicates.enum [ "ManualValidation@0" ],
                        predicates.enum [ "Ant@1" ],
                        predicates.enum [ "DeployVisualStudioTestAgent@2" ],
                        predicates.enum [ "DeployVisualStudioTestAgent@1" ],
                        predicates.enum [ "CondaEnvironment@1" ],
                        predicates.enum [ "CondaEnvironment@0" ],
                        predicates.enum [ "BatchScript@1" ],
                        predicates.enum [ "DownloadGithubNpmPackage@1" ],
                        predicates.enum [ "VSBuild@1" ],
                        predicates.enum [ "AzureKeyVault@2" ],
                        predicates.enum [ "AzureKeyVault@1" ],
                        predicates.enum [ "DotNetCoreInstaller@0" ],
                        predicates.enum [ "DotNetCoreInstaller@1" ],
                        predicates.enum [ "UseDotNet@2" ],
                        predicates.enum [ "AzureAppServiceManage@0" ],
                        predicates.enum [ "KubeloginInstaller@0" ],
                        predicates.enum [ "FuncToolsInstaller@0" ],
                        predicates.enum [ "FileTransform@1" ],
                        predicates.enum [ "FileTransform@2" ],
                        predicates.enum [ "ExtractFiles@1" ],
                        predicates.enum [ "XamarinAndroid@1" ],
                        predicates.enum [ "CopyPublishBuildArtifacts@1" ],
                        predicates.enum [ "DownloadPackage@0" ],
                        predicates.enum [ "DownloadPackage@1" ],
                        predicates.enum [ "AzureResourceGroupDeployment@2" ],
                        predicates.enum
                        [ "AzureResourceManagerTemplateDeployment@3" ],
                        predicates.enum [ "AzureResourceGroupDeployment@1" ],
                        predicates.enum [ "InvokeRESTAPI@0" ],
                        predicates.enum [ "InvokeRESTAPI@1" ],
                        predicates.enum [ "ArchiveFiles@1" ],
                        predicates.enum [ "ArchiveFiles@2" ],
                        predicates.enum [ "GitHubComment@0" ],
                        predicates.enum [ "CopyFiles@1" ],
                        predicates.enum [ "CopyFiles@2" ],
                        predicates.enum [ "AzureMysqlDeployment@1" ],
                        predicates.enum [ "Npm@0" ],
                        predicates.enum [ "Npm@1" ],
                        predicates.enum [ "AzureStaticWebApp@0" ],
                        predicates.enum [ "UseNode@1" ],
                        predicates.enum [ "NodeTool@0" ],
                        predicates.enum [ "SqlServerDacpacDeployment@1" ],
                        predicates.enum
                        [ "VisualStudioTestPlatformInstaller@1" ],
                        predicates.enum [ "PublishToAzureServiceBus@1" ],
                        predicates.enum [ "PublishToAzureServiceBus@0" ],
                        predicates.enum [ "KubernetesManifest@1" ],
                        predicates.enum [ "KubernetesManifest@0" ],
                        predicates.enum [ "DownloadBuildArtifacts@1" ],
                        predicates.enum [ "DownloadBuildArtifacts@0" ],
                        predicates.enum [ "CocoaPods@0" ],
                        predicates.enum [ "AzureSpringCloud@0" ],
                        predicates.enum [ "AzureWebApp@1" ],
                        predicates.enum [ "AzureCLI@1" ],
                        predicates.enum [ "AzureCLI@0" ],
                        predicates.enum [ "AzureCLI@2" ],
                        predicates.enum [ "GitHubRelease@0" ],
                        predicates.enum [ "GitHubRelease@1" ],
                        predicates.enum [ "cURLUploader@1" ],
                        predicates.enum [ "cURLUploader@2" ],
                        predicates.enum [ "AzureAppServiceSettings@1" ],
                        predicates.enum [ "UniversalPackages@0" ],
                        predicates.enum [ "AzurePolicyCheckGate@0" ],
                        predicates.enum [ "AzureFunctionOnKubernetes@1" ],
                        predicates.enum [ "AzureFunctionOnKubernetes@0" ],
                        predicates.enum [ "Bash@3" ],
                        predicates.enum [ "ShellScript@2" ],
                        predicates.enum [ "PublishBuildArtifacts@1" ],
                        predicates.enum [ "InstallSSHKey@0" ],
                        predicates.enum [ "AzureVmssDeployment@0" ],
                        predicates.enum [ "AzureWebPowerShellDeployment@1" ],
                        predicates.enum [ "CondaAuthenticate@0" ],
                        predicates.enum [ "AzureCloudPowerShellDeployment@2" ],
                        predicates.enum [ "AzureCloudPowerShellDeployment@1" ],
                        predicates.enum [ "CargoAuthenticate@0" ],
                        predicates.enum [ "DeleteFiles@1" ],
                        predicates.enum [ "gulp@0" ],
                        predicates.enum [ "gulp@1" ],
                        predicates.enum [ "QuickPerfTest@1" ],
                        predicates.enum
                        [ "IISWebAppManagementOnMachineGroup@0" ],
                        predicates.enum [ "DockerInstaller@0" ]
                      ],
                  timeoutInMinutes = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          taskBase = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = definitions.predicate.string,
                  continueOnError = definitions.predicate.boolean,
                  displayName = definitions.predicate.string,
                  enabled = definitions.predicate.boolean,
                  env = definitions.predicate.mappingOfStringString,
                  name = definitions.predicate.referenceName,
                  retryCountOnTaskFailure = definitions.predicate.string,
                  target = definitions.predicate.stepTarget,
                  timeoutInMinutes = definitions.predicate.nonEmptyString,
                }
                {  }
                false
                predicates.never
              ],
          tasks = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.task
              ],
          templateContext = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true predicates.always
              ],
          templateParameter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "default" = definitions.predicate.any,
                  displayName = definitions.predicate.string,
                  name = definitions.predicate.nonEmptyString,
                  type = definitions.predicate.templateParameterType,
                  values = definitions.predicate.sequenceOfNonEmptyString,
                }
                {  }
                false
                predicates.never
              ],
          templateParameterType = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^boolean$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^container$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^containerList$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^deployment$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^deploymentList$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^job$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^jobList$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^legacyObject$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^number$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^object$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^stage$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^stageList$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^step$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^stepList$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^string$"
                ]
              ],
          templateParameters = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.templateParameter
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true predicates.always
                ]
              ],
          trigger = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^none$"
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.branchFilter
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    batch = definitions.predicate.boolean,
                    branches = definitions.predicate.includeExcludeFilters,
                    paths = definitions.predicate.includeExcludeFilters,
                    tags = definitions.predicate.includeExcludeFilters,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          triggerBranchFilter = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    exclude = definitions.predicate.branchFilterArray,
                    include = definitions.predicate.branchFilterArray,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.branchFilter
                ]
              ],
          variable = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    name = definitions.predicate.nonEmptyString,
                    readonly = definitions.predicate.boolean,
                    value = definitions.predicate.string,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { group = definitions.predicate.nonEmptyString, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    parameters = definitions.predicate.mapping,
                    template = definitions.predicate.nonEmptyString,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          variableRestrictions = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^none$"
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.nonEmptyString
                ]
              ],
          variables = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true predicates.always
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.variable
                ]
              ],
          variablesTemplate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  parameters = definitions.predicate.templateParameters,
                  variables = definitions.predicate.variables,
                }
                {  }
                false
                predicates.never
              ],
          webhookFilter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path", "value" ],
                predicates.records.record
                {
                  path = definitions.predicate.nonEmptyString,
                  value = definitions.predicate.nonEmptyString,
                }
                {  }
                false
                predicates.never
              ],
          webhookFilters = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.webhookFilter
              ],
          webhookResource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "connection", "webhook" ],
                predicates.records.record
                {
                  connection = definitions.predicate.nonEmptyString,
                  filters = definitions.predicate.webhookFilters,
                  type = definitions.predicate.nonEmptyString,
                  webhook = definitions.predicate.referenceName,
                }
                {  }
                false
                predicates.never
              ],
          webhookResources = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.webhookResource
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.oneOf
[
  definitions.predicate.pipeline,
  predicates.allOf
  [ predicates.isType '"String", predicates.strings.pattern "^$" ]
])