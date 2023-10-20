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
          binaryRepository
            | doc m%"
            Binary repository details
            "%
            = {
                address
                  | String
                  | doc m%"
                  Repository URL
                  "%,
                credentials
                  | definitions.contract.credentials
                  | doc m%"
                  Jenkins credentials ID for connecting to this repository
                  "%,
              },
          branchPattern
            | doc m%"
            Regular expression for validating branch names
            "%
            = String,
          cacheItem = {
                enabled
                  | Bool
                  | doc m%"
                  Sets whether this cache type is enabled
                  "%,
                source
                  | String
                  | doc m%"
                  Location of the cache in the Jenkins workspace
                  "%
                  | optional,
                target
                  | String
                  | doc m%"
                  Location of the cache directory inside the Docker container
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  (predicates.enum [ "maven", "npm", "local" ])
                  | doc m%"
                  Cache type
                  "%,
              },
          checkmarx = {
                branch_pattern
                  | definitions.contract.branchPattern
                  | doc m%"
                  Specifies in which branches this stage will be executed
                  "%
                  | optional,
                credentialsId
                  | String
                  | doc m%"
                  Jenkins credentials ID
                  "%
                  | optional,
                enabled
                  | Bool
                  | doc m%"
                  Sets whether the scan should be run
                  "%
                  | optional,
                excludeFolders
                  | String
                  | doc m%"
                  Comma separated list of folders to be excluded from the CxSAST scan
                  "%
                  | optional,
                exclusionsSetting
                  | predicates.contract_from_predicate
                  (predicates.enum [ "job", "global" ])
                  | doc m%"
                  Specifies which exclusions settings to use: global (Jenkins global settings) or job (current pipeline)
                  "%
                  | optional,
                filterPattern
                  | String
                  | doc m%"
                  Defines the include/exclude wildcard patterns. Does not have effect when "exclusionsSetting" is set to "global"
                  "%
                  | optional,
                groupId
                  | String
                  | doc m%"
                  Fully qualified team name for the project
                  "%
                  | optional,
                hideDebugLogs
                  | Bool
                  | doc m%"
                  Sets whether debug logs are visible in the job output
                  "%
                  | optional,
                highThreshold
                  | std.number.Integer
                  | doc m%"
                  Sets the maximum number of High vulnerabilities allowed
                  "%
                  | optional,
                isProxy | Bool | optional,
                lowThreshold
                  | std.number.Integer
                  | doc m%"
                  Sets the maximum number of Low vulnerabilities allowed
                  "%
                  | optional,
                mediumThreshold
                  | std.number.Integer
                  | doc m%"
                  Sets the maximum number of Medium vulnerabilities allowed
                  "%
                  | optional,
                preset
                  | String
                  | doc m%"
                  Scan preset for the project
                  "%
                  | optional,
                projectName
                  | String
                  | doc m%"
                  Unique project name. Will be inferred from the repository name if not provided
                  "%
                  | optional,
                serverUrl
                  | String
                  | doc m%"
                  Checkmarx Server URL or IP address
                  "%
                  | optional,
                sourceEncoding
                  | String
                  | doc m%"
                  Language encoding ID associated to the source code character encoding (5: Multi-Language Scan)
                  "%
                  | optional,
                useOwnServerCredentials
                  | Bool
                  | doc m%"
                  Enables the use of the default server credentials or disables and provides server and credentials that override the defaults
                  "%
                  | optional,
                vulnerabilityThresholdEnabled
                  | Bool
                  | doc m%"
                  Sets whether the scan should fail if the number of vulnerabilities is above the configured thresholds. This option is only available if the waitForResultsEnabled parameter is enabled
                  "%
                  | optional,
                waitForResultsEnabled
                  | Bool
                  | doc m%"
                  Sets whether the scan should be executed synchronously (default). The Synchronous mode allows viewing scan results in Jenkins
                  "%
                  | optional,
              },
          credentials
            | doc m%"
            Jenkins credentials ID
            "%
            = String,
          dockerReleaseChannel = {
                branch | definitions.contract.releaseChannelBranch,
                channel | definitions.contract.releaseChannel,
                credentials
                  | definitions.contract.credentials
                  | doc m%"
                  Jenkins credentials ID for publishing into the specified Docker registry
                  "%,
                registry
                  | String
                  | doc m%"
                  Docker registry. Must include protocol (http|https) and port
                  "%,
              },
          dockerfile
            | doc m%"
            Dockerfile path
            "%
            = String,
          failFast
            | doc m%"
            Forces parallel stages to all be aborted when one of them fails
            "%
            = Bool,
          helmReleaseChannel = {
                branch | definitions.contract.releaseChannelBranch,
                channel | definitions.contract.releaseChannel,
                credentials
                  | definitions.contract.credentials
                  | doc m%"
                  Jenkins credentials Id for this repository for uploading the chart
                  "%,
                repository
                  | String
                  | doc m%"
                  Helm chart repository. Must include protocol, host, port (if needed) and path
                  "%,
              },
          outputDocker = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.outputDockerBuildArgs
                  ])
                  | doc m%"
                  List of build args (--build-arg) to pass in docker build
                  "%
                  | optional,
                dockerfile
                  | definitions.contract.dockerfile
                  | doc m%"
                  Path to Dockerfile used to generate the docker image
                  "%,
                image_name
                  | String
                  | doc m%"
                  Image name for the generated docker image. Cannot include tag. Tag will be automatically generated based on project version.
                  "%,
                publish
                  | definitions.contract.outputDockerPublish
                  | doc m%"
                  Docker publishing information. If not present, no images will be published
                  "%
                  | optional,
                vulnerability_scan
                  | {
                    enabled
                      | Bool
                      | doc m%"
                      Whether the vulnerability scan step should be run
                      "%
                      | optional,
                  }
                  | doc m%"
                  Configuration for running vulnerability scans on published Docker images
                  "%
                  | optional,
              },
          outputDockerBuildArgs = predicates.contract_from_predicate
              definitions.predicate.outputDockerBuildArgs,
          outputDockerPublish = predicates.contract_from_predicate
              definitions.predicate.outputDockerPublish,
          outputHelm = {
                path
                  | String
                  | doc m%"
                  Path to the folder with all required chart config files
                  "%,
                publish
                  | definitions.contract.outputHelmPublish
                  | doc m%"
                  Helm chart publishing configuration. If not present, no charts will be published
                  "%,
                updates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.outputHelmUpdates
                  ])
                  | doc m%"
                  Updates that must be done before packing Helm chart. It's a list of objects that specifies which updates must be done on which files
                  "%,
              },
          outputHelmPublish = predicates.contract_from_predicate
              definitions.predicate.outputHelmPublish,
          outputHelmUpdates = {
                file
                  | String
                  | doc m%"
                  Name (including path from Helm object path) of the file to be updated. Only supports yaml files
                  "%,
                properties
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.outputHelmUpdatesProperties
                  ])
                  | doc m%"
                  A list of properties to update. It can be updated with a fixed value or environment variable
                  "%,
              },
          outputHelmUpdatesProperties = predicates.contract_from_predicate
              definitions.predicate.outputHelmUpdatesProperties,
          outputPackage = {
                publish
                  | definitions.contract.outputPackagePublish
                  | doc m%"
                  Package publish configuration.
                  "%,
              },
          outputPackagePublish = predicates.contract_from_predicate
              definitions.predicate.outputPackagePublish,
          packagePublishChannel = {
                branch | definitions.contract.releaseChannelBranch,
                channel | definitions.contract.releaseChannel,
                credentials
                  | definitions.contract.credentials
                  | doc m%"
                  Jenkins credentials ID for publishing into the specified Docker registry
                  "%
                  | optional,
                maven_releases_repo
                  | String
                  | doc m%"
                  Maven repository for deploying releases
                  "%
                  | optional,
                maven_snapshots_repo
                  | String
                  | doc m%"
                  Maven repository for deploying snapshots
                  "%
                  | optional,
                params
                  | String
                  | doc m%"
                  Optional params for npm publish or mvn deploy command.
                  "%
                  | optional,
                registry
                  | String
                  | doc m%"
                  NPM registry (env variable or registry URL)
                  "%
                  | optional,
              },
          parallelStage = {
                fail_fast | definitions.contract.failFast | optional,
                parallel
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { "^\\w+( \\w+)*$" = definitions.predicate.singleStage, }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  List of stages to be executed in parallel
                  "%,
                when | definitions.contract.when | optional,
              },
          releaseChannel
            | doc m%"
            Release channel name
            "%
            = String,
          releaseChannelBranch
            | doc m%"
            Indicates on which branches the artifact will be published
            "%
            = definitions.contract.branchPattern,
          singleStage = {
                steps | definitions.contract.steps,
                when | definitions.contract.when | optional,
              },
          sonar = {
                branch_analysis
                  | Bool
                  | doc m%"
                  Indicates whether sonnar server supports branch analysis, to provide dedicated parameters.
                  "%
                  | optional,
                branch_pattern
                  | String
                  | doc m%"
                  Indicates what branches static analysis will be performed.
                  "%
                  | optional,
                breaks_build
                  | Bool
                  | doc m%"
                  Waits for analysis result and breaks the build when the project fails for some quality gates
                  "%
                  | optional,
                enabled | Bool | optional,
                exclusions
                  | String
                  | doc m%"
                  Comma separated list of wildcard patterns defining files to be excluded from the SonarQube scan
                  "%
                  | optional,
                image
                  | String
                  | doc m%"
                  Prebuilt Docker image for running scan into it. If not specified, it will use the same image used for main build.
                  "%
                  | optional,
                timeout
                  | definitions.contract.timeout
                  | doc m%"
                  Seconds to wait for the result of the quality gate. Only applies when breaks_build is set to true
                  "%
                  | optional,
              },
          stage = predicates.contract_from_predicate
              definitions.predicate.stage,
          steps
            | doc m%"
            List of steps to run
            "%
            = Array Dyn,
          timeout
            | doc m%"
            Timeout in seconds
            "%
            = std.number.Integer,
          when
            | doc m%"
            Condition that should be met to run this step
            "%
            = { branch | definitions.contract.branchPattern | optional, .. },
        },
    predicate = {
          binaryRepository
            | doc m%"
            Binary repository details
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "address", "credentials" ],
                predicates.records.record
                {
                  address = predicates.isType '"String",
                  credentials = definitions.predicate.credentials,
                }
                {  }
                false
                predicates.never
              ],
          branchPattern
            | doc m%"
            Regular expression for validating branch names
            "%
            = predicates.isType '"String",
          cacheItem = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "enabled", "type" ],
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  source = predicates.isType '"String",
                  target = predicates.isType '"String",
                  type = predicates.enum [ "maven", "npm", "local" ],
                }
                {  }
                false
                predicates.never
              ],
          checkmarx = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  branch_pattern = definitions.predicate.branchPattern,
                  credentialsId = predicates.isType '"String",
                  enabled = predicates.isType '"Bool",
                  excludeFolders = predicates.isType '"String",
                  exclusionsSetting = predicates.enum [ "job", "global" ],
                  filterPattern = predicates.isType '"String",
                  groupId = predicates.isType '"String",
                  hideDebugLogs = predicates.isType '"Bool",
                  highThreshold = predicates.isType 'Integer,
                  isProxy = predicates.isType '"Bool",
                  lowThreshold = predicates.isType 'Integer,
                  mediumThreshold = predicates.isType 'Integer,
                  preset = predicates.isType '"String",
                  projectName = predicates.isType '"String",
                  serverUrl = predicates.isType '"String",
                  sourceEncoding = predicates.isType '"String",
                  useOwnServerCredentials = predicates.isType '"Bool",
                  vulnerabilityThresholdEnabled = predicates.isType '"Bool",
                  waitForResultsEnabled = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          credentials
            | doc m%"
            Jenkins credentials ID
            "%
            = predicates.isType '"String",
          dockerReleaseChannel = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "branch", "channel", "credentials", "registry" ],
                predicates.records.record
                {
                  branch = definitions.predicate.releaseChannelBranch,
                  channel = definitions.predicate.releaseChannel,
                  credentials = definitions.predicate.credentials,
                  registry = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          dockerfile
            | doc m%"
            Dockerfile path
            "%
            = predicates.isType '"String",
          failFast
            | doc m%"
            Forces parallel stages to all be aborted when one of them fails
            "%
            = predicates.isType '"Bool",
          helmReleaseChannel = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "branch", "channel", "credentials", "repository" ],
                predicates.records.record
                {
                  branch = definitions.predicate.releaseChannelBranch,
                  channel = definitions.predicate.releaseChannel,
                  credentials = definitions.predicate.credentials,
                  repository = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          outputDocker = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "dockerfile", "image_name" ],
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.outputDockerBuildArgs
                      ],
                  dockerfile = definitions.predicate.dockerfile,
                  image_name = predicates.isType '"String",
                  publish = definitions.predicate.outputDockerPublish,
                  vulnerability_scan = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { enabled = predicates.isType '"Bool", }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never
              ],
          outputDockerBuildArgs = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.not
                    (predicates.allOf
                    [
                      predicates.records.required [ "value" ],
                      predicates.records.record {  } {  } true predicates.always
                    ]),
                    predicates.records.required [ "env" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.not
                    (predicates.allOf
                    [
                      predicates.records.required [ "env" ],
                      predicates.records.record {  } {  } true predicates.always
                    ]),
                    predicates.records.required [ "value" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.required [ "key" ],
                predicates.records.record
                {
                  env = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^[A-Za-z_][A-Za-z0-9_]*$"
                      ],
                  key = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          outputDockerPublish = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.dockerReleaseChannel
              ],
          outputHelm = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path", "publish", "updates" ],
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  publish = definitions.predicate.outputHelmPublish,
                  updates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.outputHelmUpdates
                      ],
                }
                {  }
                false
                predicates.never
              ],
          outputHelmPublish = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.helmReleaseChannel
              ],
          outputHelmUpdates = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "file", "properties" ],
                predicates.records.record
                {
                  file = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.outputHelmUpdatesProperties
                      ],
                }
                {  }
                false
                predicates.never
              ],
          outputHelmUpdatesProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.not
                    (predicates.allOf
                    [
                      predicates.records.required [ "value" ],
                      predicates.records.record {  } {  } true predicates.always
                    ]),
                    predicates.records.required [ "env" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.not
                    (predicates.allOf
                    [
                      predicates.records.required [ "env" ],
                      predicates.records.record {  } {  } true predicates.always
                    ]),
                    predicates.records.required [ "value" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.required [ "key" ],
                predicates.records.record
                {
                  env = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^[A-Za-z_][A-Za-z0-9_]*$"
                      ],
                  key = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          outputPackage = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "publish" ],
                predicates.records.record
                { publish = definitions.predicate.outputPackagePublish, }
                {  }
                false
                predicates.never
              ],
          outputPackagePublish = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.packagePublishChannel
              ],
          packagePublishChannel = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "branch", "channel" ],
                predicates.records.record
                {
                  branch = definitions.predicate.releaseChannelBranch,
                  channel = definitions.predicate.releaseChannel,
                  credentials = definitions.predicate.credentials,
                  maven_releases_repo = predicates.isType '"String",
                  maven_snapshots_repo = predicates.isType '"String",
                  params = predicates.isType '"String",
                  registry = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          parallelStage = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "parallel" ],
                predicates.records.record
                {
                  fail_fast = definitions.predicate.failFast,
                  parallel = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^\\w+( \\w+)*$" = definitions.predicate.singleStage,
                        }
                        true
                        predicates.always
                      ],
                  when = definitions.predicate.when,
                }
                {  }
                false
                predicates.never
              ],
          releaseChannel
            | doc m%"
            Release channel name
            "%
            = predicates.isType '"String",
          releaseChannelBranch
            | doc m%"
            Indicates on which branches the artifact will be published
            "%
            = definitions.predicate.branchPattern,
          singleStage = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "steps" ],
                predicates.records.record
                {
                  steps = definitions.predicate.steps,
                  when = definitions.predicate.when,
                }
                {  }
                false
                predicates.never
              ],
          sonar = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  branch_analysis = predicates.isType '"Bool",
                  branch_pattern = predicates.isType '"String",
                  breaks_build = predicates.isType '"Bool",
                  enabled = predicates.isType '"Bool",
                  exclusions = predicates.isType '"String",
                  image = predicates.isType '"String",
                  timeout = definitions.predicate.timeout,
                }
                {  }
                false
                predicates.never
              ],
          stage = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  definitions.predicate.singleStage,
                  definitions.predicate.parallelStage
                ],
                predicates.records.record
                {
                  fail_fast = definitions.predicate.failFast,
                  parallel = predicates.records.record {  }
                      { "^\\w+( \\w+)*$" = definitions.predicate.singleStage, }
                      true
                      predicates.always,
                  steps = definitions.predicate.steps,
                  when = definitions.predicate.when,
                }
                {  }
                false
                predicates.never
              ],
          steps
            | doc m%"
            List of steps to run
            "%
            = predicates.isType '"Array",
          timeout
            | doc m%"
            Timeout in seconds
            "%
            = predicates.isType 'Integer,
          when
            | doc m%"
            Condition that should be met to run this step
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { branch = definitions.predicate.branchPattern, }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  archive
    | Array Dyn
    | doc m%"
    List of artifacts to archive (wildcards allowed). Check out https://www.jenkins.io/doc/pipeline/steps/core/#archiveartifacts-archive-the-artifacts
    "%
    | optional,
  config
    | {
      branch
        | {
          branch_pattern | definitions.contract.branchPattern | optional,
          disable_validation
            | Bool
            | doc m%"
            Disables branch name validation
            "%
            | optional,
        }
        | doc m%"
        Describes on which branch names a build will be run
        "%
        | optional,
      build
        | {
          checkmarx
            | definitions.contract.checkmarx
            | doc m%"
            Adds a Static Analysis stage for CheckMarx. See https://www.jenkins.io/doc/pipeline/steps/checkmarx/ for all the configuration options.
            "%
            | optional,
          clean_workspace_after_run
            | Bool
            | doc m%"
            Whether Jenkins workspace should be cleaned after the build
            "%
            | optional,
          commit_time_threshold
            | predicates.contract_from_predicate
            (predicates.oneOf
            [
              predicates.allOf
              [ predicates.isType 'Integer, predicates.const 0 ],
              predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^\\d+[mhd]$"
              ]
            ])
            | doc m%"
            Commit age threshold. Disables automated builds older than this parameter. When 0, this feature is disabled
            "%
            | optional,
          static_analysis
            | definitions.contract.sonar
            | doc m%"
            Adds a Static Analysis stage for Sonar.
            "%
            | optional,
        }
        | optional,
      cache
        | {
          items
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.cacheItem
            ])
            | doc m%"
            List of cache types
            "%
            | optional,
          repository | definitions.contract.binaryRepository | optional,
        }
        | doc m%"
        Cache configuration for projects built inside Docker containers
        "%
        | optional,
      jenkins_runtime
        | {
          docker
            | {
              dockerfile
                | definitions.contract.dockerfile
                | doc m%"
                Path to a local Dockerfile
                "%
                | optional,
              image
                | String
                | doc m%"
                Prebuilt Docker image (has precedence over dockerfile)
                "%
                | optional,
            }
            | doc m%"
            Specifies how to build the Docker container (from an existing image or from a local Dockerfile)
            "%,
        }
        | optional,
    }
    | optional,
  environment
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.propertyNames
      (predicates.strings.pattern "^[A-Za-z_][A-Za-z0-9_]*$"),
      predicates.records.record {  } {  } true predicates.always
    ])
    | doc m%"
    Custom environment variables to be added to the pipeline
    "%
    | optional,
  jenkinsEnvironment
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType '"String",
        predicates.strings.pattern "^[A-Za-z_][A-Za-z0-9_]*$"
      ]),
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    Jenkins environment variables that are passed to the Docker container
    "%
    | optional,
  output
    | {
      docker
        | definitions.contract.outputDocker
        | doc m%"
        Configuration for generating a Docker image
        "%
        | optional,
      helm
        | definitions.contract.outputHelm
        | doc m%"
        Configuration for generating a Helm chart
        "%
        | optional,
      package
        | definitions.contract.outputPackage
        | doc m%"
        Configuration for publishing NPM or Maven packages
        "%
        | optional,
    }
    | doc m%"
    Describes artifacts generated after all the stages have been run
    "%
    | optional,
  project
    | {
      name
        | String
        | doc m%"
        Project's name (used by Jenkins, Docker and Sonar)
        "%
        | optional,
      settings
        | String
        | doc m%"
        ID of a managed maven or npm Jenkins file
        "%
        | optional,
      type
        | predicates.contract_from_predicate
        (predicates.enum [ "npm", "maven", "mvn" ])
        | doc m%"
        Project type
        "%
        | optional,
    }
    | doc m%"
    Project properties
    "%,
  services
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.enum
      [
        "Postgres",
        "Postgis",
        "Redis",
        "Mssql",
        "Mysql",
        "Mongodb",
        "Elasticsearch"
      ]),
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    Additional services required by the project or application.
    "%
    | optional,
  stages
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      { "^\\w+( \\w+)*$" = definitions.predicate.stage, }
      true
      predicates.always
    ])
    | doc m%"
    Defines the stages and steps required to build the project.
    "%,
  timeout
    | definitions.contract.timeout
    | doc m%"
    Build timeout in seconds
    "%
    | optional,
  ..
}