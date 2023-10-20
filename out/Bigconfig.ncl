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
          ColumnMetricDeployment = {
                column_name | String,
                metrics
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SimpleMetricDefinition
                  ]),
                ..
              },
          ColumnSelector = {
                exclude | String | optional,
                name | String | optional,
                regex | String | optional,
                type | definitions.contract.SimpleFieldType | optional,
                ..
              },
          MetricParameters = {
                column_name | String | optional,
                key | String | optional,
                number_value | Number | optional,
                string_value | String | optional,
                ..
              },
          NotificationChannels = {
                email | String | optional,
                slack | String | optional,
                webhook | String | optional,
                webhook_header_key | String | optional,
                webhook_header_value | String | optional,
                ..
              },
          RowCreationTimes = {
                column_selectors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ColumnSelector
                  ])
                  | optional,
                tag_ids
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                ..
              },
          SavedMetricDefinitions = {
                metrics
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SimpleMetricDefinition
                  ]),
                ..
              },
          SimpleCollection = {
                description | String,
                name | String,
                notification_channels
                  | definitions.contract.NotificationChannels
                  | optional,
                ..
              },
          SimpleFieldType = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'STRUCT,
                  'ARRAY,
                  'UNKNOWN,
                  'BOOLEAN,
                  'ANY,
                  'TIMESTAMP_LIKE,
                  'DATE_LIKE,
                  'NUMERIC,
                  'BINARY,
                  'UUID,
                  'STRING,
                  'UNSPECIFIED
                |]
              ],
          SimpleMetricDefinition = {
                conditions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                description | String | optional,
                group_by
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                lookback
                  | {
                    bucket_size
                      | predicates.contract_from_predicate
                      (predicates.enum [ "DAY", "HOUR" ])
                      | doc m%"
                      Only valid for data time window metrics
                      "%
                      | optional,
                    lookback_type
                      | predicates.contract_from_predicate
                      (predicates.enum
                      [ "DATA_TIME", "METRIC_TIME", "CLOCK_TIME" ]),
                    lookback_window
                      | {
                        interval_type
                          | predicates.contract_from_predicate
                          (predicates.enum [ "DAYS" ]),
                        interval_value | Number,
                        ..
                      },
                    ..
                  }
                  | optional,
                metric_name | String | optional,
                metric_schedule
                  | {
                    named_schedule
                      | {
                        cron | String | optional,
                        id | Number | optional,
                        name | String,
                        ..
                      },
                    ..
                  }
                  | optional,
                metric_type
                  | {
                    aggregation_type
                      | std.enum.TagOrString
                      | [| 'PERCENT, 'COUNT |]
                      | optional,
                    predefined_metric
                      | predicates.contract_from_predicate
                      (predicates.enum
                      [
                        "PERCENT_NULL",
                        "COUNT_NULL",
                        "PERCENT_EMPTY_STRING",
                        "COUNT_EMPTY_STRING",
                        "PERCENT_UNIQUE",
                        "PERCENT_VALUE_IN_LIST",
                        "AVERAGE",
                        "MIN",
                        "MAX",
                        "SUM",
                        "COUNT_ROWS",
                        "COUNT_DISTINCT",
                        "HOURS_SINCE_MAX_DATE",
                        "HOURS_SINCE_MAX_TIMESTAMP",
                        "COUNT_TRUE",
                        "PERCENT_TRUE",
                        "COUNT_FALSE",
                        "PERCENT_FALSE",
                        "COUNT_USA_PHONE",
                        "PERCENT_USA_PHONE",
                        "COUNT_USA_ZIP_CODE",
                        "PERCENT_USA_ZIP_CODE",
                        "PERCENT_UUID",
                        "COUNT_TIMESTAMP_STRING",
                        "PERCENT_TIMESTAMP_STRING",
                        "COUNT_DUPLICATES",
                        "COUNT_USA_STATE_CODE",
                        "PERCENT_USA_STATE_CODE",
                        "VARIANCE",
                        "SKEW",
                        "KURTOSIS",
                        "GEOMETRIC_MEAN",
                        "HARMONIC_MEAN",
                        "COUNT_UUID",
                        "COUNT_CUSIP",
                        "PERCENT_CUSIP",
                        "COUNT_SEDOL",
                        "PERCENT_SEDOL",
                        "COUNT_ISIN",
                        "PERCENT_ISIN",
                        "COUNT_LEI",
                        "PERCENT_LEI",
                        "COUNT_FIGI",
                        "PERCENT_FIGI",
                        "COUNT_PERM_ID",
                        "PERCENT_PERM_ID",
                        "COUNT_NAN",
                        "PERCENT_NAN",
                        "COUNT_LONGITUDE",
                        "PERCENT_LONGITUDE",
                        "COUNT_LATITUDE",
                        "PERCENT_LATITUDE",
                        "COUNT_NOT_IN_FUTURE",
                        "PERCENT_NOT_IN_FUTURE",
                        "COUNT_DATE_NOT_IN_FUTURE",
                        "PERCENT_DATE_NOT_IN_FUTURE",
                        "MEDIAN",
                        "PERCENTILE",
                        "COUNT_NOT_NULL",
                        "STRING_LENGTH_AVERAGE",
                        "STRING_LENGTH_MIN",
                        "STRING_LENGTH_MAX",
                        "COUNT_SSN",
                        "PERCENT_SSN",
                        "COUNT_EMAIL",
                        "PERCENT_EMAIL",
                        "ROWS_INSERTED",
                        "HOURS_SINCE_LAST_LOAD",
                        "COUNT_READ_QUERIES",
                        "PERCENT_NOT_NULL",
                        "FRESHNESS",
                        "VOLUME"
                      ]),
                    template_id | Number | optional,
                    type
                      | std.enum.TagOrString
                      | [| 'TEMPLATE, 'PREDEFINED |]
                      | optional,
                    ..
                  }
                  | optional,
                notification_channels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.NotificationChannels
                  ])
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.MetricParameters
                  ])
                  | optional,
                saved_metric_id | String | optional,
                schedule_frequency
                  | {
                    interval_type
                      | predicates.contract_from_predicate
                      (predicates.enum [ "HOURS", "MINUTES" ]),
                    interval_value | Number,
                    ..
                  }
                  | optional,
                threshold
                  | {
                    lower_bound
                      | Number
                      | doc m%"
                      Only valid for constant, relative, and standard deviation metrics
                      "%
                      | optional,
                    lower_bound_only
                      | Bool
                      | doc m%"
                      Only valid for autothreshold metrics
                      "%
                      | optional,
                    reference_point
                      | {
                        interval_type
                          | predicates.contract_from_predicate
                          (predicates.enum [ "DAYS" ]),
                        interval_value | Number,
                        ..
                      }
                      | doc m%"
                      Only valid for relative and standard deviation metrics
                      "%
                      | optional,
                    sensitivity
                      | predicates.contract_from_predicate
                      (predicates.enum [ "NARROW", "MEDIUM", "WIDE", "XWIDE" ])
                      | doc m%"
                      Only valid for autothreshold metrics
                      "%
                      | optional,
                    type
                      | predicates.contract_from_predicate
                      (predicates.enum
                      [ "AUTO", "RELATIVE", "STDDEV", "CONSTANT" ]),
                    upper_bound
                      | Number
                      | doc m%"
                      Only valid for constant, relative, and standard deviation metrics
                      "%
                      | optional,
                    upper_bound_only
                      | Bool
                      | doc m%"
                      Only valid for autothreshold metrics
                      "%
                      | optional,
                    ..
                  }
                  | optional,
                ..
              },
          TableDeployment = {
                columns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ColumnMetricDeployment
                  ])
                  | optional,
                fq_table_name | String,
                row_creation_time | String | optional,
                table_metrics
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SimpleMetricDefinition
                  ])
                  | optional,
                ..
              },
          TableDeploymentSuite = {
                collection
                  | definitions.contract.SimpleMetricDefinition
                  | optional,
                deployments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.TableDeployment
                  ]),
                ..
              },
          TagDefinition = {
                column_selectors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ColumnSelector
                  ]),
                tag_id | String,
                ..
              },
          TagDeployment = {
                column_selectors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ColumnSelector
                  ])
                  | optional,
                metrics
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SimpleMetricDefinition
                  ]),
                tag_id | String | optional,
                ..
              },
          TagDeploymentSuite = {
                collection | definitions.contract.SimpleCollection | optional,
                deployments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.TagDeployment
                  ])
                  | optional,
                ..
              },
        },
    predicate = {
          ColumnMetricDeployment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "column_name", "metrics" ],
                predicates.records.record
                {
                  column_name = predicates.isType '"String",
                  metrics = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SimpleMetricDefinition
                      ],
                }
                {  }
                true
                predicates.always
              ],
          ColumnSelector = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  exclude = predicates.isType '"String",
                  name = predicates.isType '"String",
                  regex = predicates.isType '"String",
                  type = definitions.predicate.SimpleFieldType,
                }
                {  }
                true
                predicates.always
              ],
          MetricParameters = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  column_name = predicates.isType '"String",
                  key = predicates.isType '"String",
                  number_value = predicates.isType '"Number",
                  string_value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          NotificationChannels = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  email = predicates.isType '"String",
                  slack = predicates.isType '"String",
                  webhook = predicates.isType '"String",
                  webhook_header_key = predicates.isType '"String",
                  webhook_header_value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          RowCreationTimes = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  column_selectors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ColumnSelector
                      ],
                  tag_ids = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          SavedMetricDefinitions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "metrics" ],
                predicates.records.record
                {
                  metrics = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SimpleMetricDefinition
                      ],
                }
                {  }
                true
                predicates.always
              ],
          SimpleCollection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "description", "name" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  notification_channels =
                    definitions.predicate.NotificationChannels,
                }
                {  }
                true
                predicates.always
              ],
          SimpleFieldType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "UNSPECIFIED",
                  "STRING",
                  "UUID",
                  "BINARY",
                  "NUMERIC",
                  "DATE_LIKE",
                  "TIMESTAMP_LIKE",
                  "ANY",
                  "BOOLEAN",
                  "UNKNOWN",
                  "ARRAY",
                  "STRUCT"
                ]
              ],
          SimpleMetricDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  conditions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  description = predicates.isType '"String",
                  group_by = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  lookback = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [ "lookback_type", "lookback_window" ],
                        predicates.records.record
                        {
                          bucket_size = predicates.enum [ "DAY", "HOUR" ],
                          lookback_type = predicates.enum
                              [ "DATA_TIME", "METRIC_TIME", "CLOCK_TIME" ],
                          lookback_window = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required
                                [ "interval_type", "interval_value" ],
                                predicates.records.record
                                {
                                  interval_type = predicates.enum [ "DAYS" ],
                                  interval_value = predicates.isType '"Number",
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
                  metric_name = predicates.isType '"String",
                  metric_schedule = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "named_schedule" ],
                        predicates.records.record
                        {
                          named_schedule = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "name" ],
                                predicates.records.record
                                {
                                  cron = predicates.isType '"String",
                                  id = predicates.isType '"Number",
                                  name = predicates.isType '"String",
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
                  metric_type = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "predefined_metric" ],
                        predicates.records.record
                        {
                          aggregation_type = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "COUNT", "PERCENT" ]
                              ],
                          predefined_metric = predicates.enum
                              [
                                "PERCENT_NULL",
                                "COUNT_NULL",
                                "PERCENT_EMPTY_STRING",
                                "COUNT_EMPTY_STRING",
                                "PERCENT_UNIQUE",
                                "PERCENT_VALUE_IN_LIST",
                                "AVERAGE",
                                "MIN",
                                "MAX",
                                "SUM",
                                "COUNT_ROWS",
                                "COUNT_DISTINCT",
                                "HOURS_SINCE_MAX_DATE",
                                "HOURS_SINCE_MAX_TIMESTAMP",
                                "COUNT_TRUE",
                                "PERCENT_TRUE",
                                "COUNT_FALSE",
                                "PERCENT_FALSE",
                                "COUNT_USA_PHONE",
                                "PERCENT_USA_PHONE",
                                "COUNT_USA_ZIP_CODE",
                                "PERCENT_USA_ZIP_CODE",
                                "PERCENT_UUID",
                                "COUNT_TIMESTAMP_STRING",
                                "PERCENT_TIMESTAMP_STRING",
                                "COUNT_DUPLICATES",
                                "COUNT_USA_STATE_CODE",
                                "PERCENT_USA_STATE_CODE",
                                "VARIANCE",
                                "SKEW",
                                "KURTOSIS",
                                "GEOMETRIC_MEAN",
                                "HARMONIC_MEAN",
                                "COUNT_UUID",
                                "COUNT_CUSIP",
                                "PERCENT_CUSIP",
                                "COUNT_SEDOL",
                                "PERCENT_SEDOL",
                                "COUNT_ISIN",
                                "PERCENT_ISIN",
                                "COUNT_LEI",
                                "PERCENT_LEI",
                                "COUNT_FIGI",
                                "PERCENT_FIGI",
                                "COUNT_PERM_ID",
                                "PERCENT_PERM_ID",
                                "COUNT_NAN",
                                "PERCENT_NAN",
                                "COUNT_LONGITUDE",
                                "PERCENT_LONGITUDE",
                                "COUNT_LATITUDE",
                                "PERCENT_LATITUDE",
                                "COUNT_NOT_IN_FUTURE",
                                "PERCENT_NOT_IN_FUTURE",
                                "COUNT_DATE_NOT_IN_FUTURE",
                                "PERCENT_DATE_NOT_IN_FUTURE",
                                "MEDIAN",
                                "PERCENTILE",
                                "COUNT_NOT_NULL",
                                "STRING_LENGTH_AVERAGE",
                                "STRING_LENGTH_MIN",
                                "STRING_LENGTH_MAX",
                                "COUNT_SSN",
                                "PERCENT_SSN",
                                "COUNT_EMAIL",
                                "PERCENT_EMAIL",
                                "ROWS_INSERTED",
                                "HOURS_SINCE_LAST_LOAD",
                                "COUNT_READ_QUERIES",
                                "PERCENT_NOT_NULL",
                                "FRESHNESS",
                                "VOLUME"
                              ],
                          template_id = predicates.isType '"Number",
                          type = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "PREDEFINED", "TEMPLATE" ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  notification_channels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.NotificationChannels
                      ],
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.MetricParameters
                      ],
                  saved_metric_id = predicates.isType '"String",
                  schedule_frequency = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [ "interval_type", "interval_value" ],
                        predicates.records.record
                        {
                          interval_type = predicates.enum
                              [ "HOURS", "MINUTES" ],
                          interval_value = predicates.isType '"Number",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  threshold = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "type" ],
                        predicates.records.record
                        {
                          lower_bound = predicates.isType '"Number",
                          lower_bound_only = predicates.isType '"Bool",
                          reference_point = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required
                                [ "interval_type", "interval_value" ],
                                predicates.records.record
                                {
                                  interval_type = predicates.enum [ "DAYS" ],
                                  interval_value = predicates.isType '"Number",
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          sensitivity = predicates.enum
                              [ "NARROW", "MEDIUM", "WIDE", "XWIDE" ],
                          type = predicates.enum
                              [ "AUTO", "RELATIVE", "STDDEV", "CONSTANT" ],
                          upper_bound = predicates.isType '"Number",
                          upper_bound_only = predicates.isType '"Bool",
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
          TableDeployment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fq_table_name" ],
                predicates.records.record
                {
                  columns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ColumnMetricDeployment
                      ],
                  fq_table_name = predicates.isType '"String",
                  row_creation_time = predicates.isType '"String",
                  table_metrics = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SimpleMetricDefinition
                      ],
                }
                {  }
                true
                predicates.always
              ],
          TableDeploymentSuite = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "deployments" ],
                predicates.records.record
                {
                  collection = definitions.predicate.SimpleMetricDefinition,
                  deployments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TableDeployment
                      ],
                }
                {  }
                true
                predicates.always
              ],
          TagDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "column_selectors", "tag_id" ],
                predicates.records.record
                {
                  column_selectors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ColumnSelector
                      ],
                  tag_id = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          TagDeployment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "metrics" ],
                predicates.records.record
                {
                  column_selectors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ColumnSelector
                      ],
                  metrics = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SimpleMetricDefinition
                      ],
                  tag_id = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          TagDeploymentSuite = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  collection = definitions.predicate.SimpleCollection,
                  deployments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TagDeployment
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
  auto_apply_on_indexing | Bool | optional,
  row_creation_times
    | predicates.contract_from_predicate definitions.predicate.RowCreationTimes
    | optional,
  saved_metric_definitions
    | definitions.contract.SavedMetricDefinitions
    | optional,
  table_deployments
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.TableDeploymentSuite
    ])
    | optional,
  tag_definitions
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.TagDefinition
    ])
    | optional,
  tag_deployments
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.TagDeploymentSuite
    ])
    | optional,
  type
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.const "BIGCONFIG_FILE" ]),
  ..
}