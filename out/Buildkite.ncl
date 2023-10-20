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
          blockStep = {
                allow_dependency_failure
                  | definitions.contract."commonOptions/allowDependencyFailure"
                  | optional,
                block
                  | String
                  | doc m%"
                  The label of the block step
                  "%
                  | optional,
                blocked_state
                  | std.enum.TagOrString
                  | [| 'running, 'failed, 'passed |]
                  | doc m%"
                  The state that the build is set to when the build is blocked by this block step
                  "%
                  | optional,
                branches
                  | definitions.contract."commonOptions/branches"
                  | optional,
                depends_on
                  | definitions.contract."commonOptions/dependsOn"
                  | optional,
                fields | definitions.contract."commonOptions/fields" | optional,
                id | definitions.contract."commonOptions/identifier" | optional,
                identifier
                  | definitions.contract."commonOptions/identifier"
                  | optional,
                "if" | definitions.contract."commonOptions/if" | optional,
                key | definitions.contract."commonOptions/key" | optional,
                label | definitions.contract."commonOptions/label" | optional,
                name | definitions.contract."commonOptions/label" | optional,
                prompt | definitions.contract."commonOptions/prompt" | optional,
                type | std.enum.TagOrString | [| 'block |] | optional,
              },
          commandStep = {
                agents | definitions.contract."commonOptions/agents" | optional,
                allow_dependency_failure
                  | definitions.contract."commonOptions/allowDependencyFailure"
                  | optional,
                artifact_paths
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  The glob path/s of artifacts to upload once this step has finished running
                  "%
                  | optional,
                branches
                  | definitions.contract."commonOptions/branches"
                  | optional,
                cancel_on_build_failing
                  | definitions.contract."commonOptions/cancelOnBuildFailing"
                  | optional,
                command
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  The commands to run on the agent
                  "%
                  | optional,
                commands
                  | definitions.contract."commandStep/properties/command"
                  | doc m%"
                  The commands to run on the agent
                  "%
                  | optional,
                concurrency
                  | std.number.Integer
                  | doc m%"
                  The maximum number of jobs created from this step that are allowed to run at the same time. If you use this attribute, you must also define concurrency_group.
                  "%
                  | optional,
                concurrency_group
                  | String
                  | doc m%"
                  A unique name for the concurrency group that you are creating with the concurrency attribute
                  "%
                  | optional,
                concurrency_method
                  | std.enum.TagOrString
                  | [| 'eager, 'ordered |]
                  | doc m%"
                  Control command order, allowed values are 'ordered' (default) and 'eager'.  If you use this attribute, you must also define concurrency_group and concurrency.
                  "%
                  | optional,
                depends_on
                  | definitions.contract."commonOptions/dependsOn"
                  | optional,
                env | definitions.contract."commonOptions/env" | optional,
                id | definitions.contract."commonOptions/identifier" | optional,
                identifier
                  | definitions.contract."commonOptions/identifier"
                  | optional,
                "if" | definitions.contract."commonOptions/if" | optional,
                key | definitions.contract."commonOptions/key" | optional,
                label | definitions.contract."commonOptions/label" | optional,
                matrix
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."commonOptions/matrixElement"
                    ],
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "setup" ],
                      predicates.records.record
                      {
                        adjustments = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "with" ],
                                predicates.records.record
                                {
                                  skip =
                                    definitions.predicate."commonOptions/skip",
                                  soft_fail =
                                    definitions.predicate."commonOptions/softFail",
                                  with = predicates.oneOf
                                      [
                                        predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          definitions.predicate."commonOptions/matrixElement"
                                        ],
                                        predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.propertyNames
                                          (predicates.isType '"String"),
                                          predicates.records.record {  } {  }
                                          true
                                          (predicates.isType '"String")
                                        ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ])
                            ],
                        setup = predicates.oneOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate."commonOptions/matrixElement"
                              ],
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.propertyNames
                                (predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern "^[a-zA-Z0-9_]+$"
                                ]),
                                predicates.records.record {  } {  } true
                                (predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  definitions.predicate."commonOptions/matrixElement"
                                ])
                              ]
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ]
                  ])
                  | optional,
                name | definitions.contract."commonOptions/label" | optional,
                notify
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "github_check", "github_commit_status" ]
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          basecamp_campfire = predicates.isType '"String",
                          "if" = definitions.predicate."commonOptions/if",
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
                          "if" = definitions.predicate."commonOptions/if",
                          slack = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    channels = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    message = predicates.isType '"String",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ]
                              ],
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
                          github_commit_status = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                { context = predicates.isType '"String", }
                                {  }
                                true
                                predicates.always
                              ],
                          "if" = definitions.predicate."commonOptions/if",
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
                          github_check = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                { context = predicates.isType '"String", }
                                {  }
                                true
                                predicates.always
                              ],
                          "if" = definitions.predicate."commonOptions/if",
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ])
                  ])
                  | doc m%"
                  Array of notification options for this step
                  "%
                  | optional,
                parallelism
                  | std.number.Integer
                  | doc m%"
                  The number of parallel jobs that will be created based on this step
                  "%
                  | optional,
                plugins
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.maxProperties 1,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ]
                      ])
                    ],
                    predicates.isType 'Record
                  ])
                  | optional,
                "priority"
                  | std.number.Integer
                  | doc m%"
                  Priority of the job, higher priorities are assigned to agents
                  "%
                  | optional,
                retry
                  | {
                    automatic
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate."commonOptions/automaticRetry",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate."commonOptions/automaticRetry"
                        ]
                      ])
                      | doc m%"
                      Whether to allow a job to retry automatically. If set to true, the retry conditions are set to the default value.
                      "%
                      | optional,
                    manual
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            allowed = predicates.isType '"Bool",
                            permit_on_passed = predicates.isType '"Bool",
                            reason = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ])
                      | doc m%"
                      Whether to allow a job to be retried manually
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  The conditions for retrying this step.
                  "%
                  | optional,
                signature
                  | {
                    algorithm
                      | String
                      | doc m%"
                      The algorithm used to generate the signature
                      "%
                      | optional,
                    signed_fields
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ])
                      | doc m%"
                      The fields that were signed to form the signature value
                      "%
                      | optional,
                    value
                      | String
                      | doc m%"
                      The signature value, a JWS compact signature with a detached body
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  The signature of the command step, generally injected by agents at pipeline upload
                  "%
                  | optional,
                skip | definitions.contract."commonOptions/skip" | optional,
                soft_fail
                  | definitions.contract."commonOptions/softFail"
                  | optional,
                timeout_in_minutes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The number of minutes to time out a job
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'commands, 'command, 'script |]
                  | optional,
              },
          commonOptions = predicates.contract_from_predicate
              definitions.predicate.commonOptions,
          groupStep = predicates.contract_from_predicate
              definitions.predicate.groupStep,
          inputStep = {
                allow_dependency_failure
                  | definitions.contract."commonOptions/allowDependencyFailure"
                  | optional,
                branches
                  | definitions.contract."commonOptions/branches"
                  | optional,
                depends_on
                  | definitions.contract."commonOptions/dependsOn"
                  | optional,
                fields | definitions.contract."commonOptions/fields" | optional,
                id | definitions.contract."commonOptions/identifier" | optional,
                identifier
                  | definitions.contract."commonOptions/identifier"
                  | optional,
                "if" | definitions.contract."commonOptions/if" | optional,
                input
                  | String
                  | doc m%"
                  The label of the input step
                  "%
                  | optional,
                key | definitions.contract."commonOptions/key" | optional,
                label | definitions.contract."commonOptions/label" | optional,
                name | definitions.contract."commonOptions/label" | optional,
                prompt | definitions.contract."commonOptions/prompt" | optional,
                type | std.enum.TagOrString | [| 'input |] | optional,
              },
          nestedBlockStep = {
                block | definitions.contract.blockStep | optional,
              },
          nestedCommandStep = {
                command | definitions.contract.commandStep | optional,
                commands | definitions.contract.commandStep | optional,
                script | definitions.contract.commandStep | optional,
              },
          nestedInputStep = {
                input | definitions.contract.inputStep | optional,
              },
          nestedTriggerStep = {
                trigger | definitions.contract.triggerStep | optional,
              },
          nestedWaitStep = {
                wait
                  | definitions.contract.waitStep
                  | doc m%"
                  Waits for previous steps to pass before continuing
                  "%
                  | optional,
                waiter | definitions.contract.waitStep | optional,
              },
          stringBlockStep
            | doc m%"
            Pauses the execution of a build and waits on a user to unblock it
            "%
            = std.contract.Sequence [ std.enum.TagOrString, [| 'block |] ],
          stringInputStep
            | doc m%"
            Pauses the execution of a build and waits on a user to unblock it
            "%
            = std.contract.Sequence [ std.enum.TagOrString, [| 'input |] ],
          stringWaitStep
            | doc m%"
            Waits for previous steps to pass before continuing
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'waiter, 'wait |] ],
          triggerStep = {
                allow_dependency_failure
                  | definitions.contract."commonOptions/allowDependencyFailure"
                  | optional,
                async
                  | Bool
                  | doc m%"
                  Whether to continue the build without waiting for the triggered step to complete
                  "%
                  | optional,
                branches
                  | definitions.contract."commonOptions/branches"
                  | optional,
                build
                  | {
                    branch
                      | String
                      | doc m%"
                      The branch for the build
                      "%
                      | optional,
                    commit
                      | String
                      | doc m%"
                      The commit hash for the build
                      "%
                      | optional,
                    env | definitions.contract."commonOptions/env" | optional,
                    label
                      | definitions.contract."commonOptions/label"
                      | optional,
                    message
                      | String
                      | doc m%"
                      The message for the build (supports emoji)
                      "%
                      | optional,
                    meta_data
                      | {  .. }
                      | doc m%"
                      Meta-data for the build
                      "%
                      | optional,
                    name
                      | definitions.contract."commonOptions/label"
                      | optional,
                    trigger
                      | String
                      | doc m%"
                      The slug of the pipeline to create a build
                      "%
                      | optional,
                    type | std.enum.TagOrString | [| 'trigger |] | optional,
                  }
                  | doc m%"
                  Properties of the build that will be created when the step is triggered
                  "%
                  | optional,
                depends_on
                  | definitions.contract."commonOptions/dependsOn"
                  | optional,
                id | definitions.contract."commonOptions/identifier" | optional,
                identifier
                  | definitions.contract."commonOptions/identifier"
                  | optional,
                "if" | definitions.contract."commonOptions/if" | optional,
                key | definitions.contract."commonOptions/key" | optional,
                label | definitions.contract."commonOptions/label" | optional,
                name | definitions.contract."commonOptions/label" | optional,
                skip | definitions.contract."commonOptions/skip" | optional,
                soft_fail
                  | definitions.contract."commonOptions/softFail"
                  | optional,
                trigger
                  | String
                  | doc m%"
                  The slug of the pipeline to create a build
                  "%
                  | optional,
                type | std.enum.TagOrString | [| 'trigger |] | optional,
              },
          waitStep = {
                allow_dependency_failure
                  | definitions.contract."commonOptions/allowDependencyFailure"
                  | optional,
                continue_on_failure
                  | Bool
                  | doc m%"
                  Continue to the next steps, even if the previous group of steps fail
                  "%
                  | optional,
                depends_on
                  | definitions.contract."commonOptions/dependsOn"
                  | optional,
                id | definitions.contract."commonOptions/identifier" | optional,
                identifier
                  | definitions.contract."commonOptions/identifier"
                  | optional,
                "if" | definitions.contract."commonOptions/if" | optional,
                key | definitions.contract."commonOptions/key" | optional,
                type | std.enum.TagOrString | [| 'waiter, 'wait |] | optional,
                wait
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Null,
                    predicates.allOf
                    [ predicates.isType '"String", predicates.enum [ "" ] ]
                  ])
                  | doc m%"
                  Waits for previous steps to pass before continuing
                  "%
                  | optional,
                waiter
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Null,
                    predicates.allOf
                    [ predicates.isType '"String", predicates.enum [ "" ] ]
                  ])
                  | optional,
              },
        },
    predicate = {
          blockStep = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow_dependency_failure =
                    definitions.predicate."commonOptions/allowDependencyFailure",
                  block = predicates.isType '"String",
                  blocked_state = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "passed", "failed", "running" ]
                      ],
                  branches = definitions.predicate."commonOptions/branches",
                  depends_on = definitions.predicate."commonOptions/dependsOn",
                  fields = definitions.predicate."commonOptions/fields",
                  id = definitions.predicate."commonOptions/identifier",
                  identifier = definitions.predicate."commonOptions/identifier",
                  "if" = definitions.predicate."commonOptions/if",
                  key = definitions.predicate."commonOptions/key",
                  label = definitions.predicate."commonOptions/label",
                  name = definitions.predicate."commonOptions/label",
                  prompt = definitions.predicate."commonOptions/prompt",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "block" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          commandStep = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  agents = definitions.predicate."commonOptions/agents",
                  allow_dependency_failure =
                    definitions.predicate."commonOptions/allowDependencyFailure",
                  artifact_paths = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  branches = definitions.predicate."commonOptions/branches",
                  cancel_on_build_failing =
                    definitions.predicate."commonOptions/cancelOnBuildFailing",
                  command = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  commands =
                    definitions.predicate."commandStep/properties/command",
                  concurrency = predicates.isType 'Integer,
                  concurrency_group = predicates.isType '"String",
                  concurrency_method = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ordered", "eager" ]
                      ],
                  depends_on = definitions.predicate."commonOptions/dependsOn",
                  env = definitions.predicate."commonOptions/env",
                  id = definitions.predicate."commonOptions/identifier",
                  identifier = definitions.predicate."commonOptions/identifier",
                  "if" = definitions.predicate."commonOptions/if",
                  key = definitions.predicate."commonOptions/key",
                  label = definitions.predicate."commonOptions/label",
                  matrix = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate."commonOptions/matrixElement"
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "setup" ],
                          predicates.records.record
                          {
                            adjustments = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "with" ],
                                    predicates.records.record
                                    {
                                      skip =
                                        definitions.predicate."commonOptions/skip",
                                      soft_fail =
                                        definitions.predicate."commonOptions/softFail",
                                      with = predicates.oneOf
                                          [
                                            predicates.allOf
                                            [
                                              predicates.isType '"Array",
                                              predicates.arrays.arrayOf
                                              definitions.predicate."commonOptions/matrixElement"
                                            ],
                                            predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.propertyNames
                                              (predicates.isType '"String"),
                                              predicates.records.record {  }
                                              {  }
                                              true
                                              (predicates.isType '"String")
                                            ]
                                          ],
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ])
                                ],
                            setup = predicates.oneOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    definitions.predicate."commonOptions/matrixElement"
                                  ],
                                  predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.propertyNames
                                    (predicates.allOf
                                    [
                                      predicates.isType '"String",
                                      predicates.strings.pattern
                                      "^[a-zA-Z0-9_]+$"
                                    ]),
                                    predicates.records.record {  } {  } true
                                    (predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      definitions.predicate."commonOptions/matrixElement"
                                    ])
                                  ]
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ]
                      ],
                  name = definitions.predicate."commonOptions/label",
                  notify = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [ "github_check", "github_commit_status" ]
                          ],
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              basecamp_campfire = predicates.isType '"String",
                              "if" = definitions.predicate."commonOptions/if",
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
                              "if" = definitions.predicate."commonOptions/if",
                              slack = predicates.oneOf
                                  [
                                    predicates.isType '"String",
                                    predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        channels = predicates.allOf
                                            [
                                              predicates.isType '"Array",
                                              predicates.arrays.arrayOf
                                              (predicates.isType '"String")
                                            ],
                                        message = predicates.isType '"String",
                                      }
                                      {  }
                                      true
                                      predicates.always
                                    ]
                                  ],
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
                              github_commit_status = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    { context = predicates.isType '"String", }
                                    {  }
                                    true
                                    predicates.always
                                  ],
                              "if" = definitions.predicate."commonOptions/if",
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
                              github_check = predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    { context = predicates.isType '"String", }
                                    {  }
                                    true
                                    predicates.always
                                  ],
                              "if" = definitions.predicate."commonOptions/if",
                            }
                            {  }
                            false
                            predicates.never
                          ]
                        ])
                      ],
                  parallelism = predicates.isType 'Integer,
                  plugins = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.maxProperties 1,
                              predicates.records.record {  } {  } true
                              predicates.always
                            ]
                          ])
                        ],
                        predicates.isType 'Record
                      ],
                  "priority" = predicates.isType 'Integer,
                  retry = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          automatic = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                definitions.predicate."commonOptions/automaticRetry",
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  definitions.predicate."commonOptions/automaticRetry"
                                ]
                              ],
                          manual = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    allowed = predicates.isType '"Bool",
                                    permit_on_passed = predicates.isType
                                        '"Bool",
                                    reason = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  signature = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          algorithm = predicates.isType '"String",
                          signed_fields = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          value = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  skip = definitions.predicate."commonOptions/skip",
                  soft_fail = definitions.predicate."commonOptions/softFail",
                  timeout_in_minutes = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "script", "command", "commands" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          commonOptions = predicates.ifThenElse (predicates.isType '"String")
              predicates.always
              predicates.always,
          groupStep = predicates.records.record
              {
                allow_dependency_failure =
                  definitions.predicate."commonOptions/allowDependencyFailure",
                depends_on = definitions.predicate."commonOptions/dependsOn",
                group = predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                id = definitions.predicate."commonOptions/identifier",
                identifier = definitions.predicate."commonOptions/identifier",
                "if" = definitions.predicate."commonOptions/if",
                key = definitions.predicate."commonOptions/key",
                label = definitions.predicate."groupStep/properties/group",
                name = definitions.predicate."groupStep/properties/label",
                notify = definitions.predicate."commonOptions/buildNotify",
                steps = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.stringBlockStep,
                        definitions.predicate.blockStep,
                        definitions.predicate.commandStep,
                        definitions.predicate.nestedCommandStep,
                        definitions.predicate.triggerStep,
                        definitions.predicate.nestedTriggerStep,
                        definitions.predicate.stringInputStep,
                        definitions.predicate.inputStep,
                        definitions.predicate.nestedInputStep,
                        definitions.predicate.stringWaitStep,
                        definitions.predicate.waitStep,
                        definitions.predicate.nestedWaitStep
                      ])
                    ],
                type = predicates.allOf
                    [
                      predicates.anyOf [ predicates.isType '"String" ],
                      predicates.enum [ "group" ]
                    ],
              }
              {  }
              false
              predicates.never,
          inputStep = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow_dependency_failure =
                    definitions.predicate."commonOptions/allowDependencyFailure",
                  branches = definitions.predicate."commonOptions/branches",
                  depends_on = definitions.predicate."commonOptions/dependsOn",
                  fields = definitions.predicate."commonOptions/fields",
                  id = definitions.predicate."commonOptions/identifier",
                  identifier = definitions.predicate."commonOptions/identifier",
                  "if" = definitions.predicate."commonOptions/if",
                  input = predicates.isType '"String",
                  key = definitions.predicate."commonOptions/key",
                  label = definitions.predicate."commonOptions/label",
                  name = definitions.predicate."commonOptions/label",
                  prompt = definitions.predicate."commonOptions/prompt",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "input" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          nestedBlockStep = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { block = definitions.predicate.blockStep, }
                {  }
                false
                predicates.never
              ],
          nestedCommandStep = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  command = definitions.predicate.commandStep,
                  commands = definitions.predicate.commandStep,
                  script = definitions.predicate.commandStep,
                }
                {  }
                false
                predicates.never
              ],
          nestedInputStep = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { input = definitions.predicate.inputStep, }
                {  }
                false
                predicates.never
              ],
          nestedTriggerStep = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { trigger = definitions.predicate.triggerStep, }
                {  }
                false
                predicates.never
              ],
          nestedWaitStep = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  wait = definitions.predicate.waitStep,
                  waiter = definitions.predicate.waitStep,
                }
                {  }
                false
                predicates.never
              ],
          stringBlockStep
            | doc m%"
            Pauses the execution of a build and waits on a user to unblock it
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.enum [ "block" ] ],
          stringInputStep
            | doc m%"
            Pauses the execution of a build and waits on a user to unblock it
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.enum [ "input" ] ],
          stringWaitStep
            | doc m%"
            Waits for previous steps to pass before continuing
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "wait", "waiter" ]
              ],
          triggerStep = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow_dependency_failure =
                    definitions.predicate."commonOptions/allowDependencyFailure",
                  async = predicates.isType '"Bool",
                  branches = definitions.predicate."commonOptions/branches",
                  build = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          branch = predicates.isType '"String",
                          commit = predicates.isType '"String",
                          env = definitions.predicate."commonOptions/env",
                          label = definitions.predicate."commonOptions/label",
                          message = predicates.isType '"String",
                          meta_data = predicates.isType 'Record,
                          name = definitions.predicate."commonOptions/label",
                          trigger = predicates.isType '"String",
                          type = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "trigger" ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  depends_on = definitions.predicate."commonOptions/dependsOn",
                  id = definitions.predicate."commonOptions/identifier",
                  identifier = definitions.predicate."commonOptions/identifier",
                  "if" = definitions.predicate."commonOptions/if",
                  key = definitions.predicate."commonOptions/key",
                  label = definitions.predicate."commonOptions/label",
                  name = definitions.predicate."commonOptions/label",
                  skip = definitions.predicate."commonOptions/skip",
                  soft_fail = definitions.predicate."commonOptions/softFail",
                  trigger = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "trigger" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          waitStep = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow_dependency_failure =
                    definitions.predicate."commonOptions/allowDependencyFailure",
                  continue_on_failure = predicates.isType '"Bool",
                  depends_on = definitions.predicate."commonOptions/dependsOn",
                  id = definitions.predicate."commonOptions/identifier",
                  identifier = definitions.predicate."commonOptions/identifier",
                  "if" = definitions.predicate."commonOptions/if",
                  key = definitions.predicate."commonOptions/key",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "wait", "waiter" ]
                      ],
                  wait = predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [ predicates.isType '"String", predicates.enum [ "" ] ]
                      ],
                  waiter = predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.allOf
                        [ predicates.isType '"String", predicates.enum [ "" ] ]
                      ],
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
  predicates.records.required [ "steps" ],
  predicates.records.record
  {
    agents = definitions.predicate."commonOptions/agents",
    env = definitions.predicate."commonOptions/env",
    notify = definitions.predicate."commonOptions/buildNotify",
    steps = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.anyOf
          [
            definitions.predicate.blockStep,
            definitions.predicate.nestedBlockStep,
            definitions.predicate.stringBlockStep,
            definitions.predicate.inputStep,
            definitions.predicate.nestedInputStep,
            definitions.predicate.stringInputStep,
            definitions.predicate.commandStep,
            definitions.predicate.nestedCommandStep,
            definitions.predicate.stringWaitStep,
            definitions.predicate.waitStep,
            definitions.predicate.nestedWaitStep,
            definitions.predicate.triggerStep,
            definitions.predicate.nestedTriggerStep,
            definitions.predicate.groupStep
          ])
        ],
  }
  {  }
  true
  predicates.always
])