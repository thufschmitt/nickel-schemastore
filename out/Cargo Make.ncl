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
          env
            | doc m%"
            Setup environment variables
            "%
            = predicates.contract_from_predicate definitions.predicate.env,
          env_files
            | doc m%"
            Load environment files
            "%
            = predicates.contract_from_predicate
              definitions.predicate.env_files,
          env_value
            | doc m%"
            An environment variable value
            "%
            = predicates.contract_from_predicate
              definitions.predicate.env_value,
          env_value_conditioned
            | doc m%"
            Environment variable value set if condition is met
            "%
            = predicates.contract_from_predicate
              definitions.predicate.env_value_conditioned,
          env_value_decode
            | doc m%"
            Environment variable value provided by decoding other values
            "%
            = predicates.contract_from_predicate
              definitions.predicate.env_value_decode,
          env_value_path_glob
            | doc m%"
            Environment value holding a list of paths based on given glob definitions
            "%
            = {
                glob
                  | String
                  | doc m%"
                  The glob used to fetch all paths
                  "%,
                ignore_type
                  | std.enum.TagOrString
                  | [| 'git |]
                  | doc m%"
                  An ignore source that enables respecting ignore files from that source
                  "%
                  | optional,
                include_dirs
                  | Bool
                  | doc m%"
                  If true, include directories in glob
                  "%
                  | optional,
                include_files
                  | Bool
                  | doc m%"
                  If true, include files in glob
                  "%
                  | optional,
              },
          env_value_script
            | doc m%"
            Provide environment variable via script
            "%
            = {
                multi_line
                  | Bool
                  | doc m%"
                  Enable multi-line values
                  "%
                  | optional,
                script
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
              },
          env_value_unset
            | doc m%"
            Unsets environment variable
            "%
            = {
                unset
                  | Bool
                  | doc m%"
                  If true, the env variable will be unset, else ignored
                  "%,
              },
          envfile
            | doc m%"
            File containing environment variables and their values
            "%
            = predicates.contract_from_predicate definitions.predicate.envfile,
          extend
            | doc m%"
            A potentially optional external makefile to extend
            "%
            = predicates.contract_from_predicate definitions.predicate.extend,
          script = predicates.contract_from_predicate
              definitions.predicate.script,
          semver = predicates.contract_from_predicate
              definitions.predicate.semver,
          task
            | doc m%"
            A task is a command, script, rust code or other sub tasks to execute. Tasks can have dependencies which are also tasks that will be executed before the task itself.
            "%
            = {
                alias
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  If defined, task points to another task and all other properties are ignored
                  "%
                  | optional,
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The args for the executed command
                  "%
                  | optional,
                category
                  | String
                  | doc m%"
                  Category name used to document the task
                  "%
                  | optional,
                clear
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  If true, it should ignore all data in the base task
                  "%
                  | optional,
                command
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  The command to execute for this task
                  "%
                  | optional,
                condition
                  | definitions.contract.task_condition
                  | doc m%"
                  If provided all condition values must be met in order for the task to be invoked (will not stop dependencies)
                  "%
                  | optional,
                condition_script
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  If script exit code is not 0, the command/script of this task will not be invoked, dependencies however will be
                  "%
                  | optional,
                cwd
                  | String
                  | doc m%"
                  The working directory for the task to execute its command/script
                  "%
                  | optional,
                dependencies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.oneOf
                    [
                      predicates.isType '"String",
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "name" ],
                        predicates.records.record
                        {
                          name = predicates.isType '"String",
                          path = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ])
                  ])
                  | doc m%"
                  A list of tasks to execute before this task
                  "%
                  | optional,
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  If set, this task is documented as deprecated. This can be a boolean or a string deprecation message.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A description used to document the task
                  "%
                  | optional,
                disabled
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  If true, the command/script of this task will not be invoked, but dependencies will be
                  "%
                  | optional,
                env
                  | definitions.contract.env
                  | doc m%"
                  The env vars to setup before running the task commands
                  "%
                  | optional,
                env_files
                  | definitions.contract.env_files
                  | doc m%"
                  The env files to setup before running the task commands
                  "%
                  | optional,
                extend
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Extends the specified task as a base task
                  "%
                  | optional,
                "force"
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  DEPRECATED, replaced with `ignore_errors`
                  "%
                  | optional,
                ignore_errors
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  If true, any error while executing the task will be printed but will not break the build
                  "%
                  | optional,
                install_crate
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"Bool",
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required
                      [ "binary", "crate_name", "test_arg" ],
                      predicates.records.record
                      {
                        binary = predicates.isType '"String",
                        crate_name = predicates.isType '"String",
                        install_command = predicates.isType '"String",
                        min_version = definitions.predicate.semver,
                        rustup_component_name = predicates.isType '"String",
                        test_arg = predicates.oneOf
                            [
                              predicates.isType '"String",
                              predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ]
                            ],
                        version = definitions.predicate.semver,
                      }
                      {  }
                      false
                      predicates.never
                    ],
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "rustup_component_name" ],
                      predicates.records.record
                      {
                        binary = predicates.isType '"String",
                        rustup_component_name = predicates.isType '"String",
                        test_arg = predicates.oneOf
                            [
                              predicates.isType '"String",
                              predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
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
                      predicates.records.required
                      [ "crate_name", "min_version" ],
                      predicates.records.record
                      {
                        crate_name = predicates.isType '"String",
                        min_version = definitions.predicate.semver,
                      }
                      {  }
                      false
                      predicates.never
                    ]
                  ])
                  | doc m%"
                  Indicates the provided crate needs to be installed (if needed) before running the task
                  "%
                  | optional,
                install_crate_args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Additional cargo install args
                  "%
                  | optional,
                install_script
                  | definitions.contract.script
                  | doc m%"
                  Provided script will be executed before running the task
                  "%
                  | optional,
                linux
                  | definitions.contract.task
                  | doc m%"
                  Override task if runtime OS is Linux (takes precedence over alias)
                  "%
                  | optional,
                linux_alias
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  If defined and this platform is Linux, task points to another task and all other properties are ignored (takes precedence over `alias` on Linux)
                  "%
                  | optional,
                mac
                  | definitions.contract.task
                  | doc m%"
                  Override task if runtime OS is Mac (takes precedence over alias)
                  "%
                  | optional,
                mac_alias
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  If defined and this platform is Mac, task points to another task and all other properties are ignored (takes precedence over `alias` on Mac)
                  "%
                  | optional,
                private
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  If true, the task is hidden from the list of available tasks and also cannot be invoked directly from CLI
                  "%
                  | optional,
                run_task
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "name" ],
                      predicates.records.record
                      {
                        cleanup_task = predicates.isType '"String",
                        fork = predicates.isType '"Bool",
                        name = predicates.oneOf
                            [
                              predicates.isType '"String",
                              predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ]
                            ],
                        parallel = predicates.isType '"Bool",
                      }
                      {  }
                      false
                      predicates.never
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "name" ],
                        predicates.records.record
                        {
                          cleanup_task = predicates.isType '"String",
                          condition = definitions.predicate.task_condition,
                          condition_script = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          fork = predicates.isType '"Bool",
                          name = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ]
                              ],
                          parallel = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ])
                    ]
                  ])
                  | doc m%"
                  Run a task as a sub-task at the end of executing this task
                  "%
                  | optional,
                script
                  | predicates.contract_from_predicate
                  definitions.predicate.script
                  | doc m%"
                  If `command` is not defined, but `script` is defined, the provided script will be executed
                  "%
                  | optional,
                script_extension
                  | String
                  | doc m%"
                  The file extension to use for the script
                  "%
                  | optional,
                script_runner
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  The script attribute may hold non OS scripts, for example rust code to be compiled and executed. In order to use non OS script runners, you must define the special script_runner with the @ prefix.
                  "%
                  | optional,
                script_runner_args
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  The script runner arguments before the script file path
                  "%
                  | optional,
                toolchain
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  The rust toolchain used to invoke the command or install the needed crates/components
                  "%
                  | optional,
                watch
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"Bool",
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        ignore_pattern = predicates.isType '"String",
                        no_git_ignore = predicates.isType '"Bool",
                        postpone = predicates.isType '"Bool",
                        version = definitions.predicate.semver,
                        watch = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ]
                  ])
                  | doc m%"
                  Watch for file changes and invoke the task operation
                  "%
                  | optional,
                windows
                  | definitions.contract.task
                  | doc m%"
                  Override task if runtime OS is Windows (takes precedence over alias)
                  "%
                  | optional,
                windows_alias
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  If defined and this platform is Windows, task points to another task and all other properties are ignored (takes precedence over `alias` on Windows)
                  "%
                  | optional,
                workspace
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Set to false to specify that this is not a workspace and should not call the task for every member (same as --no-workspace CLI flag)
                  "%
                  | optional,
                x-taplo
                  | predicates.contract_from_predicate predicates.always
                  | optional,
              },
          task_condition
            | doc m%"
            Conditions allow you to evaluate at runtime if to run a specific task or not
            "%
            = predicates.contract_from_predicate
              definitions.predicate.task_condition,
        },
    predicate = {
          env
            | doc m%"
            Setup environment variables
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                definitions.predicate.env_value
              ],
          env_files
            | doc m%"
            Load environment files
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.envfile,
                predicates.arrays.uniqueItems
              ],
          env_value
            | doc m%"
            An environment variable value
            "%
            = predicates.anyOf
              [
                predicates.isType '"Bool",
                predicates.isType 'Integer,
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                definitions.predicate.env_value_unset,
                definitions.predicate.env_value_script,
                definitions.predicate.env_value_decode,
                definitions.predicate.env_value_conditioned,
                definitions.predicate.env_value_path_glob,
                definitions.predicate.env
              ],
          env_value_conditioned
            | doc m%"
            Environment variable value set if condition is met
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "value" ],
                predicates.records.record
                {
                  condition = definitions.predicate.task_condition,
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          env_value_decode
            | doc m%"
            Environment variable value provided by decoding other values
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "mapping", "source" ],
                predicates.records.record
                {
                  default_value = predicates.isType '"String",
                  mapping = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  source = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          env_value_path_glob
            | doc m%"
            Environment value holding a list of paths based on given glob definitions
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "glob" ],
                predicates.records.record
                {
                  glob = predicates.isType '"String",
                  ignore_type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "git" ]
                      ],
                  include_dirs = predicates.isType '"Bool",
                  include_files = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          env_value_script
            | doc m%"
            Provide environment variable via script
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "script" ],
                predicates.records.record
                {
                  multi_line = predicates.isType '"Bool",
                  script = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          env_value_unset
            | doc m%"
            Unsets environment variable
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "unset" ],
                predicates.records.record { unset = predicates.isType '"Bool", }
                {  }
                false
                predicates.never
              ],
          envfile
            | doc m%"
            File containing environment variables and their values
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "path" ],
                  predicates.records.record
                  {
                    base_path = predicates.isType '"String",
                    path = predicates.isType '"String",
                    profile = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          extend
            | doc m%"
            A potentially optional external makefile to extend
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  "optional" = predicates.isType '"Bool",
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          script = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "file" ],
                  predicates.records.record
                  {
                    absolute_path = predicates.isType '"Bool",
                    file = predicates.isType '"String",
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
                    main = predicates.isType '"String",
                    post = predicates.isType '"String",
                    pre = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          semver = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)(?:-((?:0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$"
              ],
          task
            | doc m%"
            A task is a command, script, rust code or other sub tasks to execute. Tasks can have dependencies which are also tasks that will be executed before the task itself.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  alias = predicates.isType '"String",
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  category = predicates.isType '"String",
                  clear = predicates.isType '"Bool",
                  command = predicates.isType '"String",
                  condition = definitions.predicate.task_condition,
                  condition_script = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  cwd = predicates.isType '"String",
                  dependencies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "name" ],
                            predicates.records.record
                            {
                              name = predicates.isType '"String",
                              path = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ]
                        ])
                      ],
                  deprecated = predicates.oneOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  description = predicates.isType '"String",
                  disabled = predicates.isType '"Bool",
                  env = definitions.predicate.env,
                  env_files = definitions.predicate.env_files,
                  extend = predicates.isType '"String",
                  "force" = predicates.isType '"Bool",
                  ignore_errors = predicates.isType '"Bool",
                  install_crate = predicates.oneOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "binary", "crate_name", "test_arg" ],
                          predicates.records.record
                          {
                            binary = predicates.isType '"String",
                            crate_name = predicates.isType '"String",
                            install_command = predicates.isType '"String",
                            min_version = definitions.predicate.semver,
                            rustup_component_name = predicates.isType '"String",
                            test_arg = predicates.oneOf
                                [
                                  predicates.isType '"String",
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ]
                                ],
                            version = definitions.predicate.semver,
                          }
                          {  }
                          false
                          predicates.never
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "rustup_component_name" ],
                          predicates.records.record
                          {
                            binary = predicates.isType '"String",
                            rustup_component_name = predicates.isType '"String",
                            test_arg = predicates.oneOf
                                [
                                  predicates.isType '"String",
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
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
                          predicates.records.required
                          [ "crate_name", "min_version" ],
                          predicates.records.record
                          {
                            crate_name = predicates.isType '"String",
                            min_version = definitions.predicate.semver,
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                  install_crate_args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  install_script = definitions.predicate.script,
                  linux = definitions.predicate.task,
                  linux_alias = predicates.isType '"String",
                  mac = definitions.predicate.task,
                  mac_alias = predicates.isType '"String",
                  private = predicates.isType '"Bool",
                  run_task = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "name" ],
                          predicates.records.record
                          {
                            cleanup_task = predicates.isType '"String",
                            fork = predicates.isType '"Bool",
                            name = predicates.oneOf
                                [
                                  predicates.isType '"String",
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ]
                                ],
                            parallel = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "name" ],
                            predicates.records.record
                            {
                              cleanup_task = predicates.isType '"String",
                              condition = definitions.predicate.task_condition,
                              condition_script = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                              fork = predicates.isType '"Bool",
                              name = predicates.oneOf
                                  [
                                    predicates.isType '"String",
                                    predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.isType '"String")
                                    ]
                                  ],
                              parallel = predicates.isType '"Bool",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ]
                      ],
                  script = definitions.predicate.script,
                  script_extension = predicates.isType '"String",
                  script_runner = predicates.isType '"String",
                  script_runner_args = predicates.isType '"String",
                  toolchain = predicates.isType '"String",
                  watch = predicates.oneOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            ignore_pattern = predicates.isType '"String",
                            no_git_ignore = predicates.isType '"Bool",
                            postpone = predicates.isType '"Bool",
                            version = definitions.predicate.semver,
                            watch = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                  windows = definitions.predicate.task,
                  windows_alias = predicates.isType '"String",
                  workspace = predicates.isType '"Bool",
                  x-taplo = predicates.always,
                }
                {  }
                false
                predicates.never
              ],
          task_condition
            | doc m%"
            Conditions allow you to evaluate at runtime if to run a specific task or not
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  channels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "stable", "beta", "nightly" ]
                        ])
                      ],
                  env = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  env_contains = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  env_false = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  env_not_set = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  env_set = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  env_true = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  fail_message = predicates.isType '"String",
                  files_exist = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  files_modified = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          input = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          output = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  files_not_exist = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  platforms = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "linux", "windows", "mac" ]
                        ])
                      ],
                  profiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  rust_version = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          equal = definitions.predicate.semver,
                          max = definitions.predicate.semver,
                          min = definitions.predicate.semver,
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
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.record
  {
    config = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            additional_profiles = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String"),
                  predicates.arrays.uniqueItems
                ],
            default_to_workspace = predicates.isType '"Bool",
            end_task = predicates.isType '"String",
            init_task = predicates.isType '"String",
            legacy_migration_task = predicates.isType '"String",
            linux_load_script = definitions.predicate.script,
            load_cargo_aliases = predicates.isType '"Bool",
            load_script = definitions.predicate.script,
            mac_load_script = definitions.predicate.script,
            main_project_member = predicates.isType '"String",
            min_version = definitions.predicate.semver,
            modify_core_tasks = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    namespace = predicates.isType '"String",
                    private = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ],
            on_error_task = predicates.isType '"String",
            reduce_output = predicates.isType '"Bool",
            skip_core_tasks = predicates.isType '"Bool",
            skip_crate_env_info = predicates.isType '"Bool",
            skip_git_env_info = predicates.isType '"Bool",
            skip_rust_env_info = predicates.isType '"Bool",
            time_summary = predicates.isType '"Bool",
            windows_load_script = definitions.predicate.script,
          }
          {  }
          false
          predicates.never
        ],
    env = definitions.predicate.env,
    env_files = definitions.predicate.env_files,
    env_scripts = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", definitions.predicate.script ])
        ],
    extend = predicates.oneOf
        [
          predicates.isType '"String",
          definitions.predicate.extend,
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf definitions.predicate.extend,
            predicates.arrays.uniqueItems
          ]
        ],
    tasks = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true definitions.predicate.task
        ],
  }
  {  }
  false
  predicates.never
])