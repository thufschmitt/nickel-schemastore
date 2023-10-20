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
          "$schema"
            | doc m%"
            The schema against which to verify this document.
            "%
            = String,
          buildPresetsItemsV2
            | doc m%"
            An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 2 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.buildPresetsItemsV2,
          buildPresetsItemsV3
            | doc m%"
            An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 3 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.buildPresetsItemsV3,
          buildPresetsItemsV4
            | doc m%"
            An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 4 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.buildPresetsItemsV4,
          buildPresetsV2
            | doc m%"
            An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 2 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.buildPresetsV2,
          buildPresetsV3
            | doc m%"
            An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 3 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.buildPresetsV3,
          buildPresetsV4
            | doc m%"
            An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 4 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.buildPresetsV4,
          cmakeMinimumRequired
            | doc m%"
            An optional object representing the minimum version of CMake needed to build this project.
            "%
            = {
                major
                  | std.number.Integer
                  | doc m%"
                  An optional integer representing the major version.
                  "%
                  | optional,
                minor
                  | std.number.Integer
                  | doc m%"
                  An optional integer representing the minor version.
                  "%
                  | optional,
                patch
                  | std.number.Integer
                  | doc m%"
                  An optional integer representing the patch version.
                  "%
                  | optional,
              },
          condition = predicates.contract_from_predicate
              definitions.predicate.condition,
          configurePresetsItemsV1
            | doc m%"
            An optional array of configure preset objects.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.configurePresetsItemsV1,
          configurePresetsItemsV3
            | doc m%"
            A configure preset object.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.configurePresetsItemsV3,
          configurePresetsItemsV7
            | doc m%"
            A configure preset object.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.configurePresetsItemsV7,
          configurePresetsV1
            | doc m%"
            An optional array of configure preset objects.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.configurePresetsV1,
          configurePresetsV3
            | doc m%"
            An optional array of configure preset objects.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.configurePresetsV3,
          configurePresetsV7
            | doc m%"
            An optional array of configure preset objects.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.configurePresetsV7,
          include
            | doc m%"
            An optional array of strings representing files to include. If the filenames are not absolute, they are considered relative to the current file.
            "%
            = predicates.contract_from_predicate definitions.predicate.include,
          packagePresetsItemsV6
            | doc m%"
            An optional array of package preset objects. Used to specify arguments to cpack. Available in version 6 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.packagePresetsItemsV6,
          packagePresetsV6
            | doc m%"
            An optional array of package preset objects. Used to specify arguments to cpack. Available in version 6 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.packagePresetsV6,
          testPresetsItemsV2
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 2 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.testPresetsItemsV2,
          testPresetsItemsV3
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 3 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.testPresetsItemsV3,
          testPresetsItemsV5
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 5 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.testPresetsItemsV5,
          testPresetsItemsV6
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 6 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.testPresetsItemsV6,
          testPresetsV2
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 2 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.testPresetsV2,
          testPresetsV3
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 3 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.testPresetsV3,
          testPresetsV5
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 5 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.testPresetsV5,
          testPresetsV6
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 6 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.testPresetsV6,
          topCondition = predicates.contract_from_predicate
              definitions.predicate.topCondition,
          vendor
            | doc m%"
            An optional map containing vendor-specific information. CMake does not interpret the contents of this field except to verify that it is a map if it does exist. However, the keys should be a vendor-specific domain name followed by a /-separated path. For example, the Example IDE 1.0 could use example.com/ExampleIDE/1.0. The value of each field can be anything desired by the vendor, though will typically be a map.
            "%
            = {  .. },
          workflowPresetsItemsV6
            | doc m%"
            An optional array of workflow preset objects. Used to execute configure, build, test, and package presets in order. Available in version 6 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.workflowPresetsItemsV6,
          workflowPresetsV6
            | doc m%"
            An optional array of workflow preset objects. Used to execute configure, build, test, and package presets in order. Available in version 6 and higher.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.workflowPresetsV6,
        },
    predicate = {
          "$schema"
            | doc m%"
            The schema against which to verify this document.
            "%
            = predicates.isType '"String",
          buildPresetsItemsV2
            | doc m%"
            An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 2 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    cleanFirst = predicates.isType '"Bool",
                    configuration = predicates.isType '"String",
                    configurePreset = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    description = predicates.isType '"String",
                    displayName = predicates.isType '"String",
                    environment = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.propertyNames
                          (predicates.strings.pattern "^.+$"),
                          predicates.records.record {  } {  } true
                          (predicates.anyOf
                          [
                            predicates.isType 'Null,
                            predicates.isType '"String"
                          ])
                        ],
                    hidden = predicates.isType '"Bool",
                    inheritConfigureEnvironment = predicates.isType '"Bool",
                    inherits = predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.minLength 1
                            ])
                          ]
                        ],
                    jobs = predicates.isType 'Integer,
                    name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    nativeToolOptions = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    targets = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ]
                        ],
                    vendor = predicates.isType 'Record,
                    verbose = predicates.isType '"Bool",
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          buildPresetsItemsV3
            | doc m%"
            An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 3 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { condition = definitions.predicate.topCondition, }
                  {  }
                  true
                  predicates.always
                ])
              ],
          buildPresetsItemsV4
            | doc m%"
            An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 4 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    resolvePackageReferences = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "on", "off", "only" ]
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          buildPresetsV2
            | doc m%"
            An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 2 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                definitions.predicate.buildPresetsItemsV2,
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    cleanFirst = predicates.always,
                    configuration = predicates.always,
                    configurePreset = predicates.always,
                    description = predicates.always,
                    displayName = predicates.always,
                    environment = predicates.always,
                    hidden = predicates.always,
                    inheritConfigureEnvironment = predicates.always,
                    inherits = predicates.always,
                    jobs = predicates.always,
                    name = predicates.always,
                    nativeToolOptions = predicates.always,
                    targets = predicates.always,
                    vendor = predicates.always,
                    verbose = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          buildPresetsV3
            | doc m%"
            An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 3 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.allOf
                [
                  definitions.predicate.buildPresetsItemsV3,
                  definitions.predicate.buildPresetsItemsV2
                ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    cleanFirst = predicates.always,
                    condition = predicates.always,
                    configuration = predicates.always,
                    configurePreset = predicates.always,
                    description = predicates.always,
                    displayName = predicates.always,
                    environment = predicates.always,
                    hidden = predicates.always,
                    inheritConfigureEnvironment = predicates.always,
                    inherits = predicates.always,
                    jobs = predicates.always,
                    name = predicates.always,
                    nativeToolOptions = predicates.always,
                    targets = predicates.always,
                    vendor = predicates.always,
                    verbose = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          buildPresetsV4
            | doc m%"
            An optional array of build preset objects. Used to specify arguments to cmake --build. Available in version 4 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.allOf
                [
                  definitions.predicate.buildPresetsItemsV4,
                  definitions.predicate.buildPresetsItemsV3,
                  definitions.predicate.buildPresetsItemsV2
                ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    cleanFirst = predicates.always,
                    condition = predicates.always,
                    configuration = predicates.always,
                    configurePreset = predicates.always,
                    description = predicates.always,
                    displayName = predicates.always,
                    environment = predicates.always,
                    hidden = predicates.always,
                    inheritConfigureEnvironment = predicates.always,
                    inherits = predicates.always,
                    jobs = predicates.always,
                    name = predicates.always,
                    nativeToolOptions = predicates.always,
                    resolvePackageReferences = predicates.always,
                    targets = predicates.always,
                    vendor = predicates.always,
                    verbose = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          cmakeMinimumRequired
            | doc m%"
            An optional object representing the minimum version of CMake needed to build this project.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  major = predicates.isType 'Integer,
                  minor = predicates.isType 'Integer,
                  patch = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          condition = predicates.anyOf
              [
                predicates.isType '"Bool",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type", "value" ],
                  predicates.records.record
                  {
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.const "const"
                        ],
                    value = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "lhs", "rhs", "type" ],
                  predicates.records.record
                  {
                    lhs = predicates.isType '"String",
                    rhs = predicates.isType '"String",
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.const "equals"
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "lhs", "rhs", "type" ],
                  predicates.records.record
                  {
                    lhs = predicates.isType '"String",
                    rhs = predicates.isType '"String",
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.const "notEquals"
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "list", "string", "type" ],
                  predicates.records.record
                  {
                    list = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    string = predicates.isType '"String",
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.const "inList"
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "list", "string", "type" ],
                  predicates.records.record
                  {
                    list = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    string = predicates.isType '"String",
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.const "notInList"
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "regex", "string", "type" ],
                  predicates.records.record
                  {
                    regex = predicates.isType '"String",
                    string = predicates.isType '"String",
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.const "matches"
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "regex", "string", "type" ],
                  predicates.records.record
                  {
                    regex = predicates.isType '"String",
                    string = predicates.isType '"String",
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.const "notMatches"
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "conditions", "type" ],
                  predicates.records.record
                  {
                    conditions = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.condition
                        ],
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.const "anyOf"
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "conditions", "type" ],
                  predicates.records.record
                  {
                    conditions = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.condition
                        ],
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.const "allOf"
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "condition", "type" ],
                  predicates.records.record
                  {
                    condition = definitions.predicate.condition,
                    type = predicates.allOf
                        [ predicates.isType '"String", predicates.const "not" ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          configurePresetsItemsV1
            | doc m%"
            An optional array of configure preset objects.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    architecture = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              strategy = predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.enum [ "set", "external" ]
                                  ],
                              value = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ]
                        ],
                    binaryDir = predicates.isType '"String",
                    cacheVariables = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.propertyNames
                          (predicates.strings.pattern "^.+$"),
                          predicates.records.record {  } {  } true
                          (predicates.anyOf
                          [
                            predicates.isType 'Null,
                            predicates.isType '"Bool",
                            predicates.isType '"String",
                            predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "value" ],
                              predicates.records.record
                              {
                                type = predicates.isType '"String",
                                value = predicates.anyOf
                                    [
                                      predicates.isType '"Bool",
                                      predicates.isType '"String"
                                    ],
                              }
                              {  }
                              false
                              predicates.never
                            ]
                          ])
                        ],
                    cmakeExecutable = predicates.isType '"String",
                    debug = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            find = predicates.isType '"Bool",
                            output = predicates.isType '"Bool",
                            tryCompile = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    description = predicates.isType '"String",
                    displayName = predicates.isType '"String",
                    environment = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.propertyNames
                          (predicates.strings.pattern "^.+$"),
                          predicates.records.record {  } {  } true
                          (predicates.anyOf
                          [
                            predicates.isType 'Null,
                            predicates.isType '"String"
                          ])
                        ],
                    errors = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            deprecated = predicates.isType '"Bool",
                            dev = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    generator = predicates.isType '"String",
                    hidden = predicates.isType '"Bool",
                    inherits = predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.minLength 1
                            ])
                          ]
                        ],
                    name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    toolset = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              strategy = predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.enum [ "set", "external" ]
                                  ],
                              value = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ]
                        ],
                    vendor = predicates.isType 'Record,
                    warnings = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            deprecated = predicates.isType '"Bool",
                            dev = predicates.isType '"Bool",
                            systemVars = predicates.isType '"Bool",
                            uninitialized = predicates.isType '"Bool",
                            unusedCli = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          configurePresetsItemsV3
            | doc m%"
            A configure preset object.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    binaryDir = predicates.isType '"String",
                    condition = definitions.predicate.topCondition,
                    generator = predicates.isType '"String",
                    installDir = predicates.isType '"String",
                    toolchainFile = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          configurePresetsItemsV7
            | doc m%"
            A configure preset object.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    trace = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            format = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "human", "json-v1" ]
                                ],
                            mode = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "on", "off", "expand" ]
                                ],
                            redirect = predicates.isType '"String",
                            source = predicates.anyOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.minLength 1
                                  ],
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.allOf
                                    [
                                      predicates.isType '"String",
                                      predicates.strings.minLength 1
                                    ])
                                  ]
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          configurePresetsV1
            | doc m%"
            An optional array of configure preset objects.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                definitions.predicate.configurePresetsItemsV1,
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    architecture = predicates.always,
                    binaryDir = predicates.always,
                    cacheVariables = predicates.always,
                    cmakeExecutable = predicates.always,
                    debug = predicates.always,
                    description = predicates.always,
                    displayName = predicates.always,
                    environment = predicates.always,
                    errors = predicates.always,
                    generator = predicates.always,
                    hidden = predicates.always,
                    inherits = predicates.always,
                    name = predicates.always,
                    toolset = predicates.always,
                    vendor = predicates.always,
                    warnings = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          configurePresetsV3
            | doc m%"
            An optional array of configure preset objects.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.allOf
                [
                  definitions.predicate.configurePresetsItemsV1,
                  definitions.predicate.configurePresetsItemsV3
                ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    architecture = predicates.always,
                    binaryDir = predicates.always,
                    cacheVariables = predicates.always,
                    cmakeExecutable = predicates.always,
                    condition = predicates.always,
                    debug = predicates.always,
                    description = predicates.always,
                    displayName = predicates.always,
                    environment = predicates.always,
                    errors = predicates.always,
                    generator = predicates.always,
                    hidden = predicates.always,
                    inherits = predicates.always,
                    installDir = predicates.always,
                    name = predicates.always,
                    toolchainFile = predicates.always,
                    toolset = predicates.always,
                    vendor = predicates.always,
                    warnings = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          configurePresetsV7
            | doc m%"
            An optional array of configure preset objects.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.allOf
                [
                  definitions.predicate.configurePresetsItemsV1,
                  definitions.predicate.configurePresetsItemsV3,
                  definitions.predicate.configurePresetsItemsV7
                ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    architecture = predicates.always,
                    binaryDir = predicates.always,
                    cacheVariables = predicates.always,
                    cmakeExecutable = predicates.always,
                    condition = predicates.always,
                    debug = predicates.always,
                    description = predicates.always,
                    displayName = predicates.always,
                    environment = predicates.always,
                    errors = predicates.always,
                    generator = predicates.always,
                    hidden = predicates.always,
                    inherits = predicates.always,
                    installDir = predicates.always,
                    name = predicates.always,
                    toolchainFile = predicates.always,
                    toolset = predicates.always,
                    trace = predicates.always,
                    vendor = predicates.always,
                    warnings = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          include
            | doc m%"
            An optional array of strings representing files to include. If the filenames are not absolute, they are considered relative to the current file.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          packagePresetsItemsV6
            | doc m%"
            An optional array of package preset objects. Used to specify arguments to cpack. Available in version 6 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    condition = definitions.predicate.topCondition,
                    configFile = predicates.isType '"String",
                    configurations = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    configurePreset = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    description = predicates.isType '"String",
                    displayName = predicates.isType '"String",
                    environment = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.propertyNames
                          (predicates.strings.pattern "^.+$"),
                          predicates.records.record {  } {  } true
                          (predicates.anyOf
                          [
                            predicates.isType 'Null,
                            predicates.isType '"String"
                          ])
                        ],
                    generators = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    hidden = predicates.isType '"Bool",
                    inheritConfigureEnvironment = predicates.isType '"Bool",
                    inherits = predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.minLength 1
                            ])
                          ]
                        ],
                    name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    output = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            debug = predicates.isType '"Bool",
                            verbose = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    packageDirectory = predicates.isType '"String",
                    packageName = predicates.isType '"String",
                    packageVersion = predicates.isType '"String",
                    variables = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    vendor = predicates.isType 'Record,
                    vendorName = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          packagePresetsV6
            | doc m%"
            An optional array of package preset objects. Used to specify arguments to cpack. Available in version 6 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                definitions.predicate.packagePresetsItemsV6,
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    condition = predicates.always,
                    configFile = predicates.always,
                    configurations = predicates.always,
                    configurePreset = predicates.always,
                    description = predicates.always,
                    displayName = predicates.always,
                    environment = predicates.always,
                    generators = predicates.always,
                    hidden = predicates.always,
                    inheritConfigureEnvironment = predicates.always,
                    inherits = predicates.always,
                    name = predicates.always,
                    output = predicates.always,
                    packageDirectory = predicates.always,
                    packageName = predicates.always,
                    packageVersion = predicates.always,
                    variables = predicates.always,
                    vendor = predicates.always,
                    vendorName = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          testPresetsItemsV2
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 2 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    configuration = predicates.isType '"String",
                    configurePreset = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    description = predicates.isType '"String",
                    displayName = predicates.isType '"String",
                    environment = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.propertyNames
                          (predicates.strings.pattern "^.+$"),
                          predicates.records.record {  } {  } true
                          (predicates.anyOf
                          [
                            predicates.isType 'Null,
                            predicates.isType '"String"
                          ])
                        ],
                    execution = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            enableFailover = predicates.isType '"Bool",
                            interactiveDebugging = predicates.isType '"Bool",
                            jobs = predicates.isType 'Integer,
                            noTestsAction = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [ "default", "error", "ignore" ]
                                ],
                            repeat = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "count", "mode" ],
                                  predicates.records.record
                                  {
                                    count = predicates.isType 'Integer,
                                    mode = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.enum
                                          [
                                            "until-fail",
                                            "until-pass",
                                            "after-timeout"
                                          ]
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            resourceSpecFile = predicates.isType '"String",
                            scheduleRandom = predicates.isType '"Bool",
                            showOnly = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "human", "json-v1" ]
                                ],
                            stopOnFailure = predicates.isType '"Bool",
                            testLoad = predicates.isType 'Integer,
                            timeout = predicates.isType 'Integer,
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    filter = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            exclude = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    fixtures = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            any = predicates.isType '"String",
                                            cleanup = predicates.isType
                                                '"String",
                                            setup = predicates.isType '"String",
                                          }
                                          {  }
                                          false
                                          predicates.never
                                        ],
                                    label = predicates.isType '"String",
                                    name = predicates.isType '"String",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            include = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    index = predicates.anyOf
                                        [
                                          predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              end = predicates.isType 'Integer,
                                              specificTests = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType 'Integer)
                                                  ],
                                              start = predicates.isType
                                                  'Integer,
                                              stride = predicates.isType
                                                  'Integer,
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                          predicates.isType '"String"
                                        ],
                                    label = predicates.isType '"String",
                                    name = predicates.isType '"String",
                                    useUnion = predicates.isType '"Bool",
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
                    hidden = predicates.isType '"Bool",
                    inheritConfigureEnvironment = predicates.isType '"Bool",
                    inherits = predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.minLength 1
                            ])
                          ]
                        ],
                    name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    output = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            debug = predicates.isType '"Bool",
                            labelSummary = predicates.isType '"Bool",
                            maxFailedTestOutputSize = predicates.isType
                                'Integer,
                            maxPassedTestOutputSize = predicates.isType
                                'Integer,
                            maxTestNameWidth = predicates.isType 'Integer,
                            outputLogFile = predicates.isType '"String",
                            outputOnFailure = predicates.isType '"Bool",
                            quiet = predicates.isType '"Bool",
                            shortProgress = predicates.isType '"Bool",
                            subprojectSummary = predicates.isType '"Bool",
                            verbosity = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [ "default", "verbose", "extra" ]
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    overwriteConfigurationFile = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    vendor = predicates.isType 'Record,
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          testPresetsItemsV3
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 3 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { condition = definitions.predicate.topCondition, }
                  {  }
                  true
                  predicates.always
                ])
              ],
          testPresetsItemsV5
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 5 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    output = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            testOutputTruncation = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "tail", "middle", "head" ]
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          testPresetsItemsV6
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 6 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    output = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { outputJUnitFile = predicates.isType '"String", }
                          {  }
                          true
                          predicates.always
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          testPresetsV2
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 2 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                definitions.predicate.testPresetsItemsV2,
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    configuration = predicates.always,
                    configurePreset = predicates.always,
                    description = predicates.always,
                    displayName = predicates.always,
                    environment = predicates.always,
                    execution = predicates.always,
                    filter = predicates.always,
                    hidden = predicates.always,
                    inheritConfigureEnvironment = predicates.always,
                    inherits = predicates.always,
                    name = predicates.always,
                    output = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            debug = predicates.always,
                            labelSummary = predicates.always,
                            maxFailedTestOutputSize = predicates.always,
                            maxPassedTestOutputSize = predicates.always,
                            maxTestNameWidth = predicates.always,
                            outputLogFile = predicates.always,
                            outputOnFailure = predicates.always,
                            quiet = predicates.always,
                            shortProgress = predicates.always,
                            subprojectSummary = predicates.always,
                            verbosity = predicates.always,
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    overwriteConfigurationFile = predicates.always,
                    vendor = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          testPresetsV3
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 3 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.allOf
                [
                  definitions.predicate.testPresetsItemsV2,
                  definitions.predicate.testPresetsItemsV3
                ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    condition = predicates.always,
                    configuration = predicates.always,
                    configurePreset = predicates.always,
                    description = predicates.always,
                    displayName = predicates.always,
                    environment = predicates.always,
                    execution = predicates.always,
                    filter = predicates.always,
                    hidden = predicates.always,
                    inheritConfigureEnvironment = predicates.always,
                    inherits = predicates.always,
                    name = predicates.always,
                    output = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            debug = predicates.always,
                            labelSummary = predicates.always,
                            maxFailedTestOutputSize = predicates.always,
                            maxPassedTestOutputSize = predicates.always,
                            maxTestNameWidth = predicates.always,
                            outputLogFile = predicates.always,
                            outputOnFailure = predicates.always,
                            quiet = predicates.always,
                            shortProgress = predicates.always,
                            subprojectSummary = predicates.always,
                            verbosity = predicates.always,
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    overwriteConfigurationFile = predicates.always,
                    vendor = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          testPresetsV5
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 5 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.allOf
                [
                  definitions.predicate.testPresetsItemsV2,
                  definitions.predicate.testPresetsItemsV3,
                  definitions.predicate.testPresetsItemsV5
                ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    condition = predicates.always,
                    configuration = predicates.always,
                    configurePreset = predicates.always,
                    description = predicates.always,
                    displayName = predicates.always,
                    environment = predicates.always,
                    execution = predicates.always,
                    filter = predicates.always,
                    hidden = predicates.always,
                    inheritConfigureEnvironment = predicates.always,
                    inherits = predicates.always,
                    name = predicates.always,
                    output = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            debug = predicates.always,
                            labelSummary = predicates.always,
                            maxFailedTestOutputSize = predicates.always,
                            maxPassedTestOutputSize = predicates.always,
                            maxTestNameWidth = predicates.always,
                            outputLogFile = predicates.always,
                            outputOnFailure = predicates.always,
                            quiet = predicates.always,
                            shortProgress = predicates.always,
                            subprojectSummary = predicates.always,
                            testOutputTruncation = predicates.always,
                            verbosity = predicates.always,
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    overwriteConfigurationFile = predicates.always,
                    vendor = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          testPresetsV6
            | doc m%"
            An optional array of test preset objects. Used to specify arguments to ctest. Available in version 6 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.allOf
                [
                  definitions.predicate.testPresetsItemsV2,
                  definitions.predicate.testPresetsItemsV3,
                  definitions.predicate.testPresetsItemsV5,
                  definitions.predicate.testPresetsItemsV6
                ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    condition = predicates.always,
                    configuration = predicates.always,
                    configurePreset = predicates.always,
                    description = predicates.always,
                    displayName = predicates.always,
                    environment = predicates.always,
                    execution = predicates.always,
                    filter = predicates.always,
                    hidden = predicates.always,
                    inheritConfigureEnvironment = predicates.always,
                    inherits = predicates.always,
                    name = predicates.always,
                    output = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            debug = predicates.always,
                            labelSummary = predicates.always,
                            maxFailedTestOutputSize = predicates.always,
                            maxPassedTestOutputSize = predicates.always,
                            maxTestNameWidth = predicates.always,
                            outputJUnitFile = predicates.always,
                            outputLogFile = predicates.always,
                            outputOnFailure = predicates.always,
                            quiet = predicates.always,
                            shortProgress = predicates.always,
                            subprojectSummary = predicates.always,
                            testOutputTruncation = predicates.always,
                            verbosity = predicates.always,
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    overwriteConfigurationFile = predicates.always,
                    vendor = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          topCondition = predicates.anyOf
              [ definitions.predicate.condition, predicates.isType 'Null ],
          vendor
            | doc m%"
            An optional map containing vendor-specific information. CMake does not interpret the contents of this field except to verify that it is a map if it does exist. However, the keys should be a vendor-specific domain name followed by a /-separated path. For example, the Example IDE 1.0 could use example.com/ExampleIDE/1.0. The value of each field can be anything desired by the vendor, though will typically be a map.
            "%
            = predicates.isType 'Record,
          workflowPresetsItemsV6
            | doc m%"
            An optional array of workflow preset objects. Used to execute configure, build, test, and package presets in order. Available in version 6 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name", "steps" ],
                  predicates.records.record
                  {
                    description = predicates.isType '"String",
                    displayName = predicates.isType '"String",
                    name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    steps = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "name", "type" ],
                            predicates.records.record
                            {
                              name = predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.minLength 1
                                  ],
                              type = predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.enum
                                    [ "configure", "build", "test", "package" ]
                                  ],
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    vendor = predicates.isType 'Record,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          workflowPresetsV6
            | doc m%"
            An optional array of workflow preset objects. Used to execute configure, build, test, and package presets in order. Available in version 6 and higher.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                definitions.predicate.workflowPresetsItemsV6,
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name", "steps" ],
                  predicates.records.record
                  {
                    description = predicates.always,
                    displayName = predicates.always,
                    name = predicates.always,
                    steps = predicates.always,
                    vendor = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ])
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
    predicates.records.record
    {
      cmakeMinimumRequired = definitions.predicate.cmakeMinimumRequired,
      configurePresets = definitions.predicate.configurePresetsV1,
      vendor = definitions.predicate.vendor,
      version = predicates.const 1,
    }
    {  }
    false
    predicates.never,
    predicates.records.record
    {
      buildPresets = definitions.predicate.buildPresetsV2,
      cmakeMinimumRequired = definitions.predicate.cmakeMinimumRequired,
      configurePresets = definitions.predicate.configurePresetsV1,
      testPresets = definitions.predicate.testPresetsV2,
      vendor = definitions.predicate.vendor,
      version = predicates.const 2,
    }
    {  }
    false
    predicates.never,
    predicates.records.record
    {
      buildPresets = definitions.predicate.buildPresetsV3,
      cmakeMinimumRequired = definitions.predicate.cmakeMinimumRequired,
      configurePresets = definitions.predicate.configurePresetsV3,
      testPresets = definitions.predicate.testPresetsV3,
      vendor = definitions.predicate.vendor,
      version = predicates.const 3,
    }
    {  }
    false
    predicates.never,
    predicates.records.record
    {
      buildPresets = definitions.predicate.buildPresetsV4,
      cmakeMinimumRequired = definitions.predicate.cmakeMinimumRequired,
      configurePresets = definitions.predicate.configurePresetsV3,
      include = definitions.predicate.include,
      testPresets = definitions.predicate.testPresetsV3,
      vendor = definitions.predicate.vendor,
      version = predicates.const 4,
    }
    {  }
    false
    predicates.never,
    predicates.records.record
    {
      buildPresets = definitions.predicate.buildPresetsV4,
      cmakeMinimumRequired = definitions.predicate.cmakeMinimumRequired,
      configurePresets = definitions.predicate.configurePresetsV3,
      include = definitions.predicate.include,
      testPresets = definitions.predicate.testPresetsV5,
      vendor = definitions.predicate.vendor,
      version = predicates.const 5,
    }
    {  }
    false
    predicates.never,
    predicates.records.record
    {
      buildPresets = definitions.predicate.buildPresetsV4,
      cmakeMinimumRequired = definitions.predicate.cmakeMinimumRequired,
      configurePresets = definitions.predicate.configurePresetsV3,
      include = definitions.predicate.include,
      packagePresets = definitions.predicate.packagePresetsV6,
      testPresets = definitions.predicate.testPresetsV6,
      vendor = definitions.predicate.vendor,
      version = predicates.const 6,
      workflowPresets = definitions.predicate.workflowPresetsV6,
    }
    {  }
    false
    predicates.never,
    predicates.records.record
    {
      buildPresets = definitions.predicate.buildPresetsV4,
      cmakeMinimumRequired = definitions.predicate.cmakeMinimumRequired,
      configurePresets = definitions.predicate.configurePresetsV7,
      include = definitions.predicate.include,
      packagePresets = definitions.predicate.packagePresetsV6,
      testPresets = definitions.predicate.testPresetsV6,
      vendor = definitions.predicate.vendor,
      version = predicates.const 7,
      workflowPresets = definitions.predicate.workflowPresetsV6,
    }
    {  }
    false
    predicates.never,
    predicates.records.record
    {
      "$schema" = definitions.predicate."$schema",
      buildPresets = definitions.predicate.buildPresetsV4,
      cmakeMinimumRequired = definitions.predicate.cmakeMinimumRequired,
      configurePresets = definitions.predicate.configurePresetsV7,
      include = definitions.predicate.include,
      packagePresets = definitions.predicate.packagePresetsV6,
      testPresets = definitions.predicate.testPresetsV6,
      vendor = definitions.predicate.vendor,
      version = predicates.const 8,
      workflowPresets = definitions.predicate.workflowPresetsV6,
    }
    {  }
    false
    predicates.never
  ],
  predicates.records.required [ "version" ],
  predicates.records.record {  } {  } true predicates.always
])