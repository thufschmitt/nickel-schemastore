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
          Authors
            | doc m%"
            The `authors` field lists people or organizations that are considered the
            "authors" of the package. The exact meaning is open to interpretation — it may
            list the original or primary authors, current maintainers, or owners of the
            package. These names will be listed on the crate's page on
            [crates.io](https://crates.io). An optional email address may be included within angled
            brackets at the end of each author.
            
            > **Note**: [crates.io](https://crates.io) requires at least one author to be listed.
            "%
            = predicates.contract_from_predicate definitions.predicate.Authors,
          Build
            | doc m%"
            The `build` field specifies a file in the package root which is a [build script](https://doc.rust-lang.org/cargo/reference/build-scripts.html) for building native code. More information can be found in the [build script guide](https://doc.rust-lang.org/cargo/reference/build-scripts.html).
            
            
            ```toml
            [package]
            # ...
            build = "build.rs"
            ```
            
            The default is `"build.rs"`, which loads the script from a file named
            `build.rs` in the root of the package. Use `build = "custom_build_name.rs"` to
            specify a path to a different file or `build = false` to disable automatic
            detection of the build script.
            "%
            = predicates.contract_from_predicate definitions.predicate.Build,
          BuildOverride
            | doc m%"
            Profile settings can be overridden for specific packages and build-time
            crates. To override the settings for a specific package, use the `package`
            table to change the settings for the named package:
            
            ```toml
            # The `foo` package will use the -Copt-level=3 flag.
            [profile.dev.package.foo]
            opt-level = 3
            ```
            
            The package name is actually a [Package ID Spec](https://doc.rust-lang.org/cargo/reference/pkgid-spec.html), so you can
            target individual versions of a package with syntax such as
            `[profile.dev.package."foo:2.1.0"]`.
            
            To override the settings for all dependencies (but not any workspace member),
            use the `"*"` package name:
            
            ```toml
            # Set the default for dependencies.
            [profile.dev.package."*"]
            opt-level = 2
            ```
            
            To override the settings for build scripts, proc macros, and their
            dependencies, use the `build-override` table:
            
            ```toml
            # Set the settings for build scripts and proc-macros.
            [profile.dev.build-override]
            opt-level = 3
            ```
            
            > Note: When a dependency is both a normal dependency and a build dependency,
            > Cargo will try to only build it once when `--target` is not specified. When
            > using `build-override`, the dependency may need to be built twice, once as a
            > normal dependency and once with the overridden build settings. This may
            > increase initial build times.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BuildOverride,
          Categories
            | doc m%"
            The `categories` field is an array of strings of the categories this package
            belongs to.
            
            ```toml
            categories = ["command-line-utilities", "development-tools::cargo-plugins"]
            ```
            
            > **Note**: [crates.io](https://crates.io) has a maximum of 5 categories. Each category should
            > match one of the strings available at https://crates.io/category_slugs, and
            > must match exactly.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Categories,
          DebugLevel
            | doc m%"
            The `debug` setting controls the [`-C debuginfo` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#debuginfo) which controls the
            amount of debug information included in the compiled binary.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DebugLevel,
          Dependency = predicates.contract_from_predicate
              definitions.predicate.Dependency,
          Description
            | doc m%"
            The description is a short blurb about the package. [crates.io](https://crates.io) will display
            this with your package. This should be plain text (not Markdown).
            
            ```toml
            [package]
            # ...
            description = "A short description of my package"
            ```
            
            > **Note**: [crates.io](https://crates.io) requires the `description` to be set.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Description,
          DetailedDependency = predicates.contract_from_predicate
              definitions.predicate.DetailedDependency,
          Documentation
            | doc m%"
            
            The `documentation` field specifies a URL to a website hosting the crate's
            documentation. If no URL is specified in the manifest file, [crates.io](https://crates.io) will
            automatically link your crate to the corresponding [docs.rs](https://docs.rs) page.
            
            ```toml
            [package]
            # ...
            documentation = "https://docs.rs/bitflags"
            ```
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Documentation,
          Edition
            | doc m%"
            The `edition` key affects which edition your package is compiled with. Cargo
            will always generate packages via [`cargo new`](https://doc.rust-lang.org/cargo/commands/cargo-new.html) with the `edition` key set to the
            latest edition. Setting the `edition` key in `[package]` will affect all
            targets/crates in the package, including test suites, benchmarks, binaries,
            examples, etc.
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| '"2021", '"2018", '"2015" |] ],
          Exclude
            | doc m%"
            You can explicitly specify that a set of file patterns should be ignored or
            included for the purposes of packaging. The patterns specified in the
            `exclude` field identify a set of files that are not included, and the
            patterns in `include` specify files that are explicitly included.
            
            The patterns should be [gitignore](https://git-scm.com/docs/gitignore)-style patterns. Briefly:
            
            - `foo` matches any file or directory with the name `foo` anywhere in the
              package. This is equivalent to the pattern `**/foo`.
            - `/foo` matches any file or directory with the name `foo` only in the root of
              the package.
            - `foo/` matches any *directory* with the name `foo` anywhere in the package.
            - Common glob patterns like `*`, `?`, and `[]` are supported:
              - `*` matches zero or more characters except `/`.  For example, `*.html`
                matches any file or directory with the `.html` extension anywhere in the
                package.
              - `?` matches any character except `/`. For example, `foo?` matches `food`,
                but not `foo`.
              - `[]` allows for matching a range of characters. For example, `[ab]`
                matches either `a` or `b`. `[a-z]` matches letters a through z.
            - `**/` prefix matches in any directory. For example, `**/foo/bar` matches the
              file or directory `bar` anywhere that is directly under directory `foo`.
            - `/**` suffix matches everything inside. For example, `foo/**` matches all
              files inside directory `foo`, including all files in subdirectories below
              `foo`.
            - `/**/` matches zero or more directories. For example, `a/**/b` matches
              `a/b`, `a/x/b`, `a/x/y/b`, and so on.
            - `!` prefix negates a pattern. For example, a pattern of `src/**.rs` and
              `!foo.rs` would match all files with the `.rs` extension inside the `src`
              directory, except for any file named `foo.rs`.
            
            If git is being used for a package, the `exclude` field will be seeded with
            the `gitignore` settings from the repository.
            
            ```toml
            [package]
            # ...
            exclude = ["build/**/*.o", "doc/**/*.html"]
            ```
            
            ```toml
            [package]
            # ...
            include = ["src/**/*", "Cargo.toml"]
            ```
            
            The options are mutually exclusive: setting `include` will override an
            `exclude`. Note that `include` must be an exhaustive list of files as otherwise
            necessary source files may not be included. The package's `Cargo.toml` is
            automatically included.
            
            The include/exclude list is also used for change tracking in some situations.
            For targets built with `rustdoc`, it is used to determine the list of files to
            track to determine if the target should be rebuilt. If the package has a
            [build script](https://doc.rust-lang.org/cargo/reference/build-scripts.html) that does not emit any `rerun-if-*` directives, then the
            include/exclude list is used for tracking if the build script should be re-run
            if any of those files change.
            "%
            = predicates.contract_from_predicate definitions.predicate.Exclude,
          Homepage
            | doc m%"
            The `homepage` field should be a URL to a site that is the home page for your
            package.
            
            ```toml
            [package]
            # ...
            homepage = "https://serde.rs/"
            ```
            "%
            = predicates.contract_from_predicate definitions.predicate.Homepage,
          Include
            | doc m%"
            You can explicitly specify that a set of file patterns should be ignored or
            included for the purposes of packaging. The patterns specified in the
            `exclude` field identify a set of files that are not included, and the
            patterns in `include` specify files that are explicitly included.
            
            The patterns should be [gitignore](https://git-scm.com/docs/gitignore)-style patterns. Briefly:
            
            - `foo` matches any file or directory with the name `foo` anywhere in the
              package. This is equivalent to the pattern `**/foo`.
            - `/foo` matches any file or directory with the name `foo` only in the root of
              the package.
            - `foo/` matches any *directory* with the name `foo` anywhere in the package.
            - Common glob patterns like `*`, `?`, and `[]` are supported:
              - `*` matches zero or more characters except `/`.  For example, `*.html`
                matches any file or directory with the `.html` extension anywhere in the
                package.
              - `?` matches any character except `/`. For example, `foo?` matches `food`,
                but not `foo`.
              - `[]` allows for matching a range of characters. For example, `[ab]`
                matches either `a` or `b`. `[a-z]` matches letters a through z.
            - `**/` prefix matches in any directory. For example, `**/foo/bar` matches the
              file or directory `bar` anywhere that is directly under directory `foo`.
            - `/**` suffix matches everything inside. For example, `foo/**` matches all
              files inside directory `foo`, including all files in subdirectories below
              `foo`.
            - `/**/` matches zero or more directories. For example, `a/**/b` matches
              `a/b`, `a/x/b`, `a/x/y/b`, and so on.
            - `!` prefix negates a pattern. For example, a pattern of `src/**.rs` and
              `!foo.rs` would match all files with the `.rs` extension inside the `src`
              directory, except for any file named `foo.rs`.
            
            If git is being used for a package, the `exclude` field will be seeded with
            the `gitignore` settings from the repository.
            
            ```toml
            [package]
            # ...
            exclude = ["build/**/*.o", "doc/**/*.html"]
            ```
            
            ```toml
            [package]
            # ...
            include = ["src/**/*", "Cargo.toml"]
            ```
            
            The options are mutually exclusive: setting `include` will override an
            `exclude`. Note that `include` must be an exhaustive list of files as otherwise
            necessary source files may not be included. The package's `Cargo.toml` is
            automatically included.
            
            The include/exclude list is also used for change tracking in some situations.
            For targets built with `rustdoc`, it is used to determine the list of files to
            track to determine if the target should be rebuilt. If the package has a
            [build script](https://doc.rust-lang.org/cargo/reference/build-scripts.html) that does not emit any `rerun-if-*` directives, then the
            include/exclude list is used for tracking if the build script should be re-run
            if any of those files change.
            "%
            = predicates.contract_from_predicate definitions.predicate.Include,
          Keywords
            | doc m%"
            The `keywords` field is an array of strings that describe this package. This
            can help when searching for the package on a registry, and you may choose any
            words that would help someone find this crate.
            
            ```toml
            [package]
            # ...
            keywords = ["gamedev", "graphics"]
            ```
            
            > **Note**: [crates.io](https://crates.io) has a maximum of 5 keywords. Each keyword must be
            > ASCII text, start with a letter, and only contain letters, numbers, `_` or
            > `-`, and have at most 20 characters.
            "%
            = predicates.contract_from_predicate definitions.predicate.Keywords,
          License
            | doc m%"
            The `license` field contains the name of the software license that the package
            is released under.
            
            [crates.io](https://crates.io/) interprets the `license` field as an [SPDX 2.1 license
            expression](https://spdx.org/spdx-specification-21-web-version#h.jxpfx0ykyb60). The name must be a known license
            from the [SPDX license list 3.6](https://github.com/spdx/license-list-data/tree/v3.6). Parentheses are not
            currently supported. See the [SPDX site](https://spdx.org/license-list) for more information.
            
            SPDX license expressions support AND and OR operators to combine multiple
            licenses.
            
            ```toml
            [package]
            # ...
            license = "MIT OR Apache-2.0"
            ```
            
            Using `OR` indicates the user may choose either license. Using `AND` indicates
            the user must comply with both licenses simultaneously. The `WITH` operator
            indicates a license with a special exception. Some examples:
            
            * `MIT OR Apache-2.0`
            * `LGPL-2.1 AND MIT AND BSD-2-Clause`
            * `GPL-2.0+ WITH Bison-exception-2.2`
            
            If a package is using a nonstandard license, then the `license-file` field may
            be specified in lieu of the `license` field.
            "%
            = predicates.contract_from_predicate definitions.predicate.License,
          LicenseFile
            | doc m%"
            The `license-file` field contains the path to a file
            containing the text of the license (relative to this `Cargo.toml`).
            
            ```toml
            [package]
            # ...
            license-file = "LICENSE.txt"
            ```
            
            > **Note**: [crates.io](https://crates.io) requires either `license` or `license-file` to be set.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.LicenseFile,
          Lto
            | doc m%"
            The `lto` setting controls the [`-C lto` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#lto) which controls LLVM's [link time optimizations](https://llvm.org/docs/LinkTimeOptimization.html). LTO can produce better optimized code, using
            whole-program analysis, at the cost of longer linking time.
                                
            See also the [`-C linker-plugin-lto`](https://doc.rust-lang.org/rustc/codegen-options/index.html#linker-plugin-lto) `rustc` flag for cross-language LTO.
            "%
            = predicates.contract_from_predicate definitions.predicate.Lto,
          MetaBuild = predicates.contract_from_predicate
              definitions.predicate.MetaBuild,
          OptLevel
            | doc m%"
            The `opt-level` setting controls the [`-C opt-level` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#opt-level) which controls the level
            of optimization. Higher optimization levels may produce faster runtime code at
            the expense of longer compiler times. Higher levels may also change and
            rearrange the compiled code which may make it harder to use with a debugger.
            
            It is recommended to experiment with different levels to find the right
            balance for your project. There may be surprising results, such as level `3`
            being slower than `2`, or the `"s"` and `"z"` levels not being necessarily
            smaller. You may also want to reevaluate your settings over time as newer
            versions of `rustc` changes optimization behavior.
            
            See also [Profile Guided Optimization](https://doc.rust-lang.org/rustc/profile-guided-optimization.html) for more advanced optimization
            techniques.
            "%
            = predicates.contract_from_predicate definitions.predicate.OptLevel,
          Package
            | doc m%"
            The only fields required by Cargo are [`name`](https://doc.rust-lang.org/cargo/reference/manifest.html#the-name-field) and
            [`version`](https://doc.rust-lang.org/cargo/reference/manifest.html#the-version-field). If publishing to a registry, the registry may
            require additional fields. See the notes below and [the publishing chapter](https://doc.rust-lang.org/cargo/reference/publishing.html) for requirements for publishing to [crates.io](https://crates.io/).
            "%
            = predicates.contract_from_predicate definitions.predicate.Package,
          Panic
            | doc m%"
            The `panic` setting controls the [`-C panic` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#panic) which controls which panic
            strategy to use.
            
            When set to `"unwind"`, the actual value depends on the default of the target
            platform. For example, the NVPTX platform does not support unwinding, so it
            always uses `"abort"`.
            
            Tests, benchmarks, build scripts, and proc macros ignore the `panic` setting.
            The `rustc` test harness currently requires `unwind` behavior. See the
            [`panic-abort-tests`](https://doc.rust-lang.org/cargo/reference/unstable.html#panic-abort-tests) unstable flag which enables `abort` behavior.
            
            Additionally, when using the `abort` strategy and building a test, all of the
            dependencies will also be forced to built with the `unwind` strategy.
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'abort, 'unwind |] ],
          Platform = {
                build-dependencies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.Dependency
                  ])
                  | doc m%"
                  You can depend on other Cargo-based crates for use in your build scripts.
                  Dependencies are declared through the `build-dependencies` section of the
                  manifest:
                  
                  ```toml
                  [build-dependencies]
                  cc = "1.0.3"
                  ```
                  
                  The build script **does not** have access to the dependencies listed
                  in the `dependencies` or `dev-dependencies` section. Build
                  dependencies will likewise not be available to the package itself
                  unless listed under the `dependencies` section as well. A package
                  itself and its build script are built separately, so their
                  dependencies need not coincide. Cargo is kept simpler and cleaner by
                  using independent dependencies for independent purposes.
                  "%
                  | optional,
                build_dependencies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.Dependency
                  ])
                  | optional,
                dependencies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.Dependency
                  ])
                  | doc m%"
                  Cargo is configured to look for dependencies on [crates.io](https://crates.io) by default. Only
                  the name and a version string are required in this case. In [the cargo
                  guide](https://doc.rust-lang.org/cargo/guide/index.html), we specified a dependency on the `time` crate:
                  
                  ```toml
                  [dependencies]
                  time = "0.1.12"
                  ```
                  
                  The string `"0.1.12"` is a [semver](https://github.com/steveklabnik/semver#requirements) version requirement. Since this
                  string does not have any operators in it, it is interpreted the same way as
                  if we had specified `"^0.1.12"`, which is called a caret requirement.
                  
                  A dependency can also be defined by a table with additional options:
                  
                  ```toml
                  [dependencies]
                  time = { path = "../time", version = "0.1.12" }
                  ```
                  "%
                  | optional,
                dev-dependencies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.Dependency
                  ])
                  | doc m%"
                  The format of `[dev-dependencies]` is equivalent to `[dependencies]`:
                  
                  ```toml
                  [dev-dependencies]
                  tempdir = "0.3"
                  ```
                  
                  Dev-dependencies are not used when compiling
                  a package for building, but are used for compiling tests, examples, and
                  benchmarks.
                  
                  These dependencies are *not* propagated to other packages which depend on this
                  package.
                  
                  You can also have target-specific development dependencies by using
                  `dev-dependencies` in the target section header instead of `dependencies`. For
                  example:
                  
                  ```toml
                  [target.'cfg(unix)'.dev-dependencies]
                  mio = "0.0.1"
                  ```
                  
                  > **Note**: When a package is published, only dev-dependencies that specify a
                  > `version` will be included in the published crate. For most use cases,
                  > dev-dependencies are not needed when published, though some users (like OS
                  > packagers) may want to run tests within a crate, so providing a `version` if
                  > possible can still be beneficial.
                  "%
                  | optional,
                dev_dependencies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.Dependency
                  ])
                  | optional,
                ..
              },
          PlaydateMetadata
            | doc m%"
            Metadata and build configuration.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PlaydateMetadata,
          PlaydateMetadataAssetsArray
            | doc m%"
            List of paths to include.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PlaydateMetadataAssetsArray,
          PlaydateMetadataAssetsMap
            | doc m%"
            Rules used to resolve paths to include.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PlaydateMetadataAssetsMap,
          PlaydateMetadataAssetsOptions
            | doc m%"
            Options for assets paths resolution and how to build assets collection
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PlaydateMetadataAssetsOptions,
          PlaydateMetadataOptions
            | doc m%"
            Package build options.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PlaydateMetadataOptions,
          Profile = {
                codegen-units
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The `codegen-units` setting controls the [`-C codegen-units` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#codegen-units) which
                  controls how many "code generation units" a crate will be split into. More
                  code generation units allows more of a crate to be processed in parallel
                  possibly reducing compile time, but may produce slower code.
                  
                  This option takes an integer greater than 0.
                  
                  The default is 256 for [incremental](https://doc.rust-lang.org/cargo/reference/profiles.html#incremental) builds, and 16 for
                  non-incremental builds.
                  "%
                  | optional,
                debug | definitions.contract.DebugLevel | optional,
                debug-assertions
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  The `debug-assertions` setting controls the [`-C debug-assertions` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#debug-assertions) which
                  turns `cfg(debug_assertions)` [conditional compilation](https://doc.rust-lang.org/reference/conditional-compilation.html#debug_assertions) on or off. Debug
                  assertions are intended to include runtime validation which is only available
                  in debug/development builds. These may be things that are too expensive or
                  otherwise undesirable in a release build. Debug assertions enables the
                  [`debug_assert!` macro](https://doc.rust-lang.org/std/macro.debug_assert.html) in the standard library.
                  "%
                  | optional,
                dir-name
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | optional,
                incremental
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  The `incremental` setting controls the [`-C incremental` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#incremental) which controls
                  whether or not incremental compilation is enabled. Incremental compilation
                  causes `rustc` to to save additional information to disk which will be reused
                  when recompiling the crate, improving re-compile times. The additional
                  information is stored in the `target` directory.
                  
                  The valid options are:
                  
                  * `true`: enabled
                  * `false`: disabled
                  
                  Incremental compilation is only used for workspace members and "path"
                  dependencies.
                  
                  The incremental value can be overridden globally with the `CARGO_INCREMENTAL`
                  [environment variable](https://doc.rust-lang.org/cargo/reference/environment-variables.html) or the [`build.incremental`](https://doc.rust-lang.org/cargo/reference/config.html#buildincremental) config variable.
                  "%
                  | optional,
                inherits
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | optional,
                lto | definitions.contract.Lto | optional,
                opt-level | definitions.contract.OptLevel | optional,
                overflow-checks
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  The `overflow-checks` setting controls the [`-C overflow-checks` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#overflow-checks) which
                  controls the behavior of [runtime integer overflow](https://doc.rust-lang.org/reference/expressions/operator-expr.html#overflow). When overflow-checks are
                  enabled, a panic will occur on overflow.
                  "%
                  | optional,
                package
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.Profile
                  ])
                  | doc m%"
                  Package-specific overrides.
                  
                  The package name is a [Package ID Spec](https://doc.rust-lang.org/cargo/reference/pkgid-spec.html), so you can
                  target individual versions of a package with syntax such as `[profile.dev.package."foo:2.1.0"]`.
                  "%
                  | optional,
                panic | definitions.contract.Panic | optional,
                rpath
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  The `rpath` setting controls the [`-C rpath` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#rpath) which controls
                  whether or not [`rpath`](https://en.wikipedia.org/wiki/Rpath) is enabled.
                  "%
                  | optional,
                ..
              },
          ProfileWithBuildOverride = predicates.contract_from_predicate
              definitions.predicate.ProfileWithBuildOverride,
          Profiles
            | doc m%"
            Profiles provide a way to alter the compiler settings, influencing things like optimizations and debugging symbols.
            
            Cargo has 4 built-in profiles: dev, release, test, and bench. It automatically chooses the profile based on which command is being run, the package and target that is being built, and command-line flags like --release.
            "%
            = predicates.contract_from_predicate definitions.predicate.Profiles,
          Publish
            | doc m%"
            The `publish` field can be used to prevent a package from being published to a package registry (like *crates.io*) by mistake, for instance to keep a package
            private in a company.
            
            ```toml
            [package]
            # ...
            publish = false
            ```
            
            The value may also be an array of strings which are registry names that are
            allowed to be published to.
            
            ```toml
            [package]
            # ...
            publish = ["some-registry-name"]
            ```
            "%
            = predicates.contract_from_predicate definitions.predicate.Publish,
          Readme
            | doc m%"
            The `readme` field should be the path to a file in the package root (relative
            to this `Cargo.toml`) that contains general information about the package.
            This file will be transferred to the registry when you publish. [crates.io](https://crates.io)
            will interpret it as Markdown and render it on the crate's page.
            
            ```toml
            [package]
            # ...
            readme = "README.md"
            ```
            
            If no value is specified for this field, and a file named `README.md`,
            `README.txt` or `README` exists in the package root, then the name of that
            file will be used. You can suppress this behavior by setting this field to
            `false`. If the field is set to `true`, a default value of `README.md` will
            be assumed.
            "%
            = predicates.contract_from_predicate definitions.predicate.Readme,
          Repository
            | doc m%"
            The `repository` field should be a URL to the source repository for your
            package.
            
            ```toml
            [package]
            # ...
            repository = "https://github.com/rust-lang/cargo/"
            ```
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Repository,
          Resolver
            | doc m%"
            A different feature resolver algorithm can be used by specifying the resolver version in Cargo.toml like this:
            
            [package]
            name = "my-package"
            version = "1.0.0"
            resolver = "2"
            
            The version "1" resolver is the original resolver that shipped with Cargo up to version 1.50. The default is "2" if the root package specifies edition = "2021" or a newer edition. Otherwise the default is "1".
            
            The version "2" resolver introduces changes in feature unification. See the features chapter for more details.
            
            The resolver is a global option that affects the entire workspace. The resolver version in dependencies is ignored, only the value in the top-level package will be used. If using a virtual workspace, the version should be specified in the [workspace] table, for example:
            
            [workspace]
            members = ["member1", "member2"]
            resolver = "2"
            "%
            = std.contract.Sequence [ std.enum.TagOrString, [| '"2", '"1" |] ],
          RustVersion
            | doc m%"
            The `rust-version` field is an optional key that tells cargo what version of the
            Rust language and compiler your package can be compiled with. If the currently
            selected version of the Rust compiler is older than the stated version, cargo
            will exit with an error, telling the user what version is required.
            
            The first version of Cargo that supports this field was released with Rust 1.56.0.
            In older releases, the field will be ignored, and Cargo will display a warning.
            
            ```toml
            [package]
            # ...
            rust-version = "1.56"
            ```
            
            The Rust version must be a bare version number with two or three components; it
            cannot include semver operators or pre-release identifiers. Compiler pre-release
            identifiers such as -nightly will be ignored while checking the Rust version.
            The `rust-version` must be equal to or newer than the version that first
            introduced the configured `edition`.
            
            The `rust-version` may be ignored using the `--ignore-rust-version` option.
            
            Setting the `rust-version` key in `[package]` will affect all targets/crates in
            the package, including test suites, benchmarks, binaries, examples, etc.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.RustVersion,
          SemVer
            | doc m%"
            Cargo bakes in the concept of [Semantic Versioning](https://semver.org/), so make sure you follow some basic rules:
            
            * Before you reach 1.0.0, anything goes, but if you make breaking changes,
                increment the minor version. In Rust, breaking changes include adding fields to
                structs or variants to enums.
            * After 1.0.0, only make breaking changes when you increment the major version.
                Don't break the build.
            * After 1.0.0, don't add any new public API (no new `pub` anything) in patch-level
                versions. Always increment the minor version if you add any new `pub` structs,
                traits, fields, types, functions, methods or anything else.
            * Use version numbers with three numeric parts such as 1.0.0 rather than 1.0.
            "%
            = predicates.contract_from_predicate definitions.predicate.SemVer,
          SemVerRequirement
            | doc m%"
            The [version requirement](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html) of the target dependency.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SemVerRequirement,
          Target = {
                bench
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  The `bench` field indicates whether or not the target is benchmarked by
                  default by [`cargo bench`](https://doc.rust-lang.org/cargo/commands/cargo-bench.html). The default is `true` for lib, bins, and
                  benchmarks.
                  "%
                  | optional,
                crate-type
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The `crate-type` field defines the [crate types](https://doc.rust-lang.org/reference/linkage.html) that will be generated by the
                  target. It is an array of strings, allowing you to specify multiple crate
                  types for a single target. This can only be specified for libraries and
                  examples. Binaries, tests, and benchmarks are always the "bin" crate type.
                  
                  The available options are `bin`, `lib`, `rlib`, `dylib`, `cdylib`,
                  `staticlib`, and `proc-macro`. You can read more about the different crate
                  types in the [Rust Reference Manual](https://doc.rust-lang.org/reference/linkage.html).
                  "%
                  | optional,
                crate_type
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                "doc"
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  The `doc` field indicates whether or not the target is included in the
                  documentation generated by [`cargo doc`](https://doc.rust-lang.org/cargo/commands/cargo-doc.html) by default. The default is `true` for
                  libraries and binaries.
                  
                  > **Note**: The binary will be skipped if its name is the same as the lib
                  > target.
                  "%
                  | optional,
                doctest
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  The `doctest` field indicates whether or not [documentation examples](https://doc.rust-lang.org/rustdoc/documentation-tests.html) are
                  tested by default by [`cargo test`](https://doc.rust-lang.org/cargo/commands/cargo-test.html). This is only relevant for libraries, it
                  has no effect on other sections. The default is `true` for the library.
                  "%
                  | optional,
                edition | definitions.contract.Edition | optional,
                harness
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  The `harness` field indicates that the [`--test` flag](https://doc.rust-lang.org/rustc/command-line-arguments.html#option-test) will be passed to
                  `rustc` which will automatically include the libtest library which is the
                  driver for collecting and running tests marked with the [`#[test]` attribute](https://doc.rust-lang.org/reference/attributes/testing.html#the-test-attribute) or benchmarks with the `#[bench]` attribute. The
                  default is `true` for all targets.
                  
                  If set to `false`, then you are responsible for defining a `main()` function
                  to run tests and benchmarks.
                  
                  Tests have the [`cfg(test)` conditional expression](https://doc.rust-lang.org/reference/conditional-compilation.html#test) enabled whether
                  or not the harness is enabled.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  The `name` field specifies the name of the target, which corresponds to the
                  filename of the artifact that will be generated. For a library, this is the
                  crate name that dependencies will use to reference it.
                  
                  For the `[lib]` and the default binary (`src/main.rs`), this defaults to the
                  name of the package, with any dashes replaced with underscores. For other
                  [auto discovered](https://doc.rust-lang.org/cargo/reference/cargo-targets.html#target-auto-discovery) targets, it defaults to the
                  directory or file name.
                  
                  This is required for all targets except `[lib]`.
                  "%
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  The `path` field specifies where the source for the crate is located, relative
                  to the `Cargo.toml` file.
                  
                  If not specified, the [inferred path](https://doc.rust-lang.org/cargo/reference/cargo-targets.html#target-auto-discovery) is used based on
                  the target name.
                  "%
                  | optional,
                plugin
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | optional,
                proc-macro
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  The `proc-macro` field indicates that the library is a [procedural macro](https://doc.rust-lang.org/book/ch19-06-macros.html)
                  ([reference](https://doc.rust-lang.org/reference/procedural-macros.html)). This is only valid for the `[lib]`
                  target.
                  "%
                  | optional,
                proc_macro
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | optional,
                required-features
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The `required-features` field specifies which [features](https://doc.rust-lang.org/cargo/reference/features.html) the target needs in
                  order to be built. If any of the required features are not enabled, the
                  target will be skipped. This is only relevant for the `[[bin]]`, `[[bench]]`,
                  `[[test]]`, and `[[example]]` sections, it has no effect on `[lib]`.
                  
                  ```toml
                  [features]
                  # ...
                  postgres = []
                  sqlite = []
                  tools = []
                  
                  [[bin]]
                  name = "my-pg-tool"
                  required-features = ["postgres", "tools"]
                  ```
                  "%
                  | optional,
                test
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  The `test` field indicates whether or not the target is tested by default by
                  [`cargo test`](https://doc.rust-lang.org/cargo/commands/cargo-test.html). The default is `true` for lib, bins, and tests.
                  
                  > **Note**: Examples are built by [`cargo test`](https://doc.rust-lang.org/cargo/commands/cargo-test.html) by default to ensure they
                  > continue to compile, but they are not *tested* by default. Setting `test =
                  > true` for an example will also build it as a test and run any
                  > [`#[test]`](https://doc.rust-lang.org/reference/attributes/testing.html#the-test-attribute) functions defined in the example.
                  "%
                  | optional,
                ..
              },
          Workspace
            | doc m%"
            The `[workspace]` table in `Cargo.toml` defines which packages are members of
            the workspace:
            
            ```toml
            [workspace]
            members = ["member1", "path/to/member2", "crates/*"]
            exclude = ["crates/foo", "path/to/other"]
            ```
            
            An empty `[workspace]` table can be used with a `[package]` to conveniently
            create a workspace with the package and all of its path dependencies.
            
            All [`path` dependencies](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html#specifying-path-dependencies) residing in the workspace directory automatically
            become members. Additional members can be listed with the `members` key, which
            should be an array of strings containing directories with `Cargo.toml` files.
            
            The `members` list also supports [globs](https://docs.rs/glob/0.3.0/glob/struct.Pattern.html) to match multiple paths, using
            typical filename glob patterns like `*` and `?`.
            
            The `exclude` key can be used to prevent paths from being included in a
            workspace. This can be useful if some path dependencies aren't desired to be
            in the workspace at all, or using a glob pattern and you want to remove a
            directory.
            
            An empty `[workspace]` table can be used with a `[package]` to conveniently
            create a workspace with the package and all of its path dependencies.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Workspace,
          WorkspaceInheritance
            | doc m%"
            The `workspace` field allow keys to be inherited by defining them in the member package with `{key}.workspace = true`
            "%
            = {
                workspace
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Bool", predicates.enum [ true ] ])
                  | optional,
                ..
              },
        },
    predicate = {
          Authors
            | doc m%"
            The `authors` field lists people or organizations that are considered the
            "authors" of the package. The exact meaning is open to interpretation — it may
            list the original or primary authors, current maintainers, or owners of the
            package. These names will be listed on the crate's page on
            [crates.io](https://crates.io). An optional email address may be included within angled
            brackets at the end of each author.
            
            > **Note**: [crates.io](https://crates.io) requires at least one author to be listed.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          Build
            | doc m%"
            The `build` field specifies a file in the package root which is a [build script](https://doc.rust-lang.org/cargo/reference/build-scripts.html) for building native code. More information can be found in the [build script guide](https://doc.rust-lang.org/cargo/reference/build-scripts.html).
            
            
            ```toml
            [package]
            # ...
            build = "build.rs"
            ```
            
            The default is `"build.rs"`, which loads the script from a file named
            `build.rs` in the root of the package. Use `build = "custom_build_name.rs"` to
            specify a path to a different file or `build = false` to disable automatic
            detection of the build script.
            "%
            = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [ predicates.isType '"Bool", predicates.enum [ true, false ] ]
              ],
          BuildOverride
            | doc m%"
            Profile settings can be overridden for specific packages and build-time
            crates. To override the settings for a specific package, use the `package`
            table to change the settings for the named package:
            
            ```toml
            # The `foo` package will use the -Copt-level=3 flag.
            [profile.dev.package.foo]
            opt-level = 3
            ```
            
            The package name is actually a [Package ID Spec](https://doc.rust-lang.org/cargo/reference/pkgid-spec.html), so you can
            target individual versions of a package with syntax such as
            `[profile.dev.package."foo:2.1.0"]`.
            
            To override the settings for all dependencies (but not any workspace member),
            use the `"*"` package name:
            
            ```toml
            # Set the default for dependencies.
            [profile.dev.package."*"]
            opt-level = 2
            ```
            
            To override the settings for build scripts, proc macros, and their
            dependencies, use the `build-override` table:
            
            ```toml
            # Set the settings for build scripts and proc-macros.
            [profile.dev.build-override]
            opt-level = 3
            ```
            
            > Note: When a dependency is both a normal dependency and a build dependency,
            > Cargo will try to only build it once when `--target` is not specified. When
            > using `build-override`, the dependency may need to be built twice, once as a
            > normal dependency and once with the overridden build settings. This may
            > increase initial build times.
            "%
            = predicates.allOf
              [ predicates.isType 'Record, definitions.predicate.Profile ],
          Categories
            | doc m%"
            The `categories` field is an array of strings of the categories this package
            belongs to.
            
            ```toml
            categories = ["command-line-utilities", "development-tools::cargo-plugins"]
            ```
            
            > **Note**: [crates.io](https://crates.io) has a maximum of 5 categories. Each category should
            > match one of the strings available at https://crates.io/category_slugs, and
            > must match exactly.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          DebugLevel
            | doc m%"
            The `debug` setting controls the [`-C debuginfo` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#debuginfo) which controls the
            amount of debug information included in the compiled binary.
            "%
            = predicates.enum
              [
                0,
                1,
                2,
                true,
                false,
                "none",
                "line-directives-only",
                "line-tables-only",
                "limited",
                "full"
              ],
          Dependency = predicates.anyOf
              [
                definitions.predicate.SemVerRequirement,
                definitions.predicate.DetailedDependency
              ],
          Description
            | doc m%"
            The description is a short blurb about the package. [crates.io](https://crates.io) will display
            this with your package. This should be plain text (not Markdown).
            
            ```toml
            [package]
            # ...
            description = "A short description of my package"
            ```
            
            > **Note**: [crates.io](https://crates.io) requires the `description` to be set.
            "%
            = predicates.isType '"String",
          DetailedDependency = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  branch = predicates.isType '"String",
                  default-features = predicates.isType '"Bool",
                  default_features = predicates.isType '"Bool",
                  features = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  git = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                  package = predicates.isType '"String",
                  path = predicates.isType '"String",
                  public = predicates.isType '"Bool",
                  registry = predicates.isType '"String",
                  registry-index = predicates.isType '"String",
                  rev = predicates.isType '"String",
                  tag = predicates.isType '"String",
                  version = definitions.predicate.SemVerRequirement,
                }
                {  }
                true
                predicates.always
              ],
          Documentation
            | doc m%"
            
            The `documentation` field specifies a URL to a website hosting the crate's
            documentation. If no URL is specified in the manifest file, [crates.io](https://crates.io) will
            automatically link your crate to the corresponding [docs.rs](https://docs.rs) page.
            
            ```toml
            [package]
            # ...
            documentation = "https://docs.rs/bitflags"
            ```
            "%
            = predicates.isType '"String",
          Edition
            | doc m%"
            The `edition` key affects which edition your package is compiled with. Cargo
            will always generate packages via [`cargo new`](https://doc.rust-lang.org/cargo/commands/cargo-new.html) with the `edition` key set to the
            latest edition. Setting the `edition` key in `[package]` will affect all
            targets/crates in the package, including test suites, benchmarks, binaries,
            examples, etc.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "2015", "2018", "2021" ]
              ],
          Exclude
            | doc m%"
            You can explicitly specify that a set of file patterns should be ignored or
            included for the purposes of packaging. The patterns specified in the
            `exclude` field identify a set of files that are not included, and the
            patterns in `include` specify files that are explicitly included.
            
            The patterns should be [gitignore](https://git-scm.com/docs/gitignore)-style patterns. Briefly:
            
            - `foo` matches any file or directory with the name `foo` anywhere in the
              package. This is equivalent to the pattern `**/foo`.
            - `/foo` matches any file or directory with the name `foo` only in the root of
              the package.
            - `foo/` matches any *directory* with the name `foo` anywhere in the package.
            - Common glob patterns like `*`, `?`, and `[]` are supported:
              - `*` matches zero or more characters except `/`.  For example, `*.html`
                matches any file or directory with the `.html` extension anywhere in the
                package.
              - `?` matches any character except `/`. For example, `foo?` matches `food`,
                but not `foo`.
              - `[]` allows for matching a range of characters. For example, `[ab]`
                matches either `a` or `b`. `[a-z]` matches letters a through z.
            - `**/` prefix matches in any directory. For example, `**/foo/bar` matches the
              file or directory `bar` anywhere that is directly under directory `foo`.
            - `/**` suffix matches everything inside. For example, `foo/**` matches all
              files inside directory `foo`, including all files in subdirectories below
              `foo`.
            - `/**/` matches zero or more directories. For example, `a/**/b` matches
              `a/b`, `a/x/b`, `a/x/y/b`, and so on.
            - `!` prefix negates a pattern. For example, a pattern of `src/**.rs` and
              `!foo.rs` would match all files with the `.rs` extension inside the `src`
              directory, except for any file named `foo.rs`.
            
            If git is being used for a package, the `exclude` field will be seeded with
            the `gitignore` settings from the repository.
            
            ```toml
            [package]
            # ...
            exclude = ["build/**/*.o", "doc/**/*.html"]
            ```
            
            ```toml
            [package]
            # ...
            include = ["src/**/*", "Cargo.toml"]
            ```
            
            The options are mutually exclusive: setting `include` will override an
            `exclude`. Note that `include` must be an exhaustive list of files as otherwise
            necessary source files may not be included. The package's `Cargo.toml` is
            automatically included.
            
            The include/exclude list is also used for change tracking in some situations.
            For targets built with `rustdoc`, it is used to determine the list of files to
            track to determine if the target should be rebuilt. If the package has a
            [build script](https://doc.rust-lang.org/cargo/reference/build-scripts.html) that does not emit any `rerun-if-*` directives, then the
            include/exclude list is used for tracking if the build script should be re-run
            if any of those files change.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          Homepage
            | doc m%"
            The `homepage` field should be a URL to a site that is the home page for your
            package.
            
            ```toml
            [package]
            # ...
            homepage = "https://serde.rs/"
            ```
            "%
            = predicates.isType '"String",
          Include
            | doc m%"
            You can explicitly specify that a set of file patterns should be ignored or
            included for the purposes of packaging. The patterns specified in the
            `exclude` field identify a set of files that are not included, and the
            patterns in `include` specify files that are explicitly included.
            
            The patterns should be [gitignore](https://git-scm.com/docs/gitignore)-style patterns. Briefly:
            
            - `foo` matches any file or directory with the name `foo` anywhere in the
              package. This is equivalent to the pattern `**/foo`.
            - `/foo` matches any file or directory with the name `foo` only in the root of
              the package.
            - `foo/` matches any *directory* with the name `foo` anywhere in the package.
            - Common glob patterns like `*`, `?`, and `[]` are supported:
              - `*` matches zero or more characters except `/`.  For example, `*.html`
                matches any file or directory with the `.html` extension anywhere in the
                package.
              - `?` matches any character except `/`. For example, `foo?` matches `food`,
                but not `foo`.
              - `[]` allows for matching a range of characters. For example, `[ab]`
                matches either `a` or `b`. `[a-z]` matches letters a through z.
            - `**/` prefix matches in any directory. For example, `**/foo/bar` matches the
              file or directory `bar` anywhere that is directly under directory `foo`.
            - `/**` suffix matches everything inside. For example, `foo/**` matches all
              files inside directory `foo`, including all files in subdirectories below
              `foo`.
            - `/**/` matches zero or more directories. For example, `a/**/b` matches
              `a/b`, `a/x/b`, `a/x/y/b`, and so on.
            - `!` prefix negates a pattern. For example, a pattern of `src/**.rs` and
              `!foo.rs` would match all files with the `.rs` extension inside the `src`
              directory, except for any file named `foo.rs`.
            
            If git is being used for a package, the `exclude` field will be seeded with
            the `gitignore` settings from the repository.
            
            ```toml
            [package]
            # ...
            exclude = ["build/**/*.o", "doc/**/*.html"]
            ```
            
            ```toml
            [package]
            # ...
            include = ["src/**/*", "Cargo.toml"]
            ```
            
            The options are mutually exclusive: setting `include` will override an
            `exclude`. Note that `include` must be an exhaustive list of files as otherwise
            necessary source files may not be included. The package's `Cargo.toml` is
            automatically included.
            
            The include/exclude list is also used for change tracking in some situations.
            For targets built with `rustdoc`, it is used to determine the list of files to
            track to determine if the target should be rebuilt. If the package has a
            [build script](https://doc.rust-lang.org/cargo/reference/build-scripts.html) that does not emit any `rerun-if-*` directives, then the
            include/exclude list is used for tracking if the build script should be re-run
            if any of those files change.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          Keywords
            | doc m%"
            The `keywords` field is an array of strings that describe this package. This
            can help when searching for the package on a registry, and you may choose any
            words that would help someone find this crate.
            
            ```toml
            [package]
            # ...
            keywords = ["gamedev", "graphics"]
            ```
            
            > **Note**: [crates.io](https://crates.io) has a maximum of 5 keywords. Each keyword must be
            > ASCII text, start with a letter, and only contain letters, numbers, `_` or
            > `-`, and have at most 20 characters.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          License
            | doc m%"
            The `license` field contains the name of the software license that the package
            is released under.
            
            [crates.io](https://crates.io/) interprets the `license` field as an [SPDX 2.1 license
            expression](https://spdx.org/spdx-specification-21-web-version#h.jxpfx0ykyb60). The name must be a known license
            from the [SPDX license list 3.6](https://github.com/spdx/license-list-data/tree/v3.6). Parentheses are not
            currently supported. See the [SPDX site](https://spdx.org/license-list) for more information.
            
            SPDX license expressions support AND and OR operators to combine multiple
            licenses.
            
            ```toml
            [package]
            # ...
            license = "MIT OR Apache-2.0"
            ```
            
            Using `OR` indicates the user may choose either license. Using `AND` indicates
            the user must comply with both licenses simultaneously. The `WITH` operator
            indicates a license with a special exception. Some examples:
            
            * `MIT OR Apache-2.0`
            * `LGPL-2.1 AND MIT AND BSD-2-Clause`
            * `GPL-2.0+ WITH Bison-exception-2.2`
            
            If a package is using a nonstandard license, then the `license-file` field may
            be specified in lieu of the `license` field.
            "%
            = predicates.isType '"String",
          LicenseFile
            | doc m%"
            The `license-file` field contains the path to a file
            containing the text of the license (relative to this `Cargo.toml`).
            
            ```toml
            [package]
            # ...
            license-file = "LICENSE.txt"
            ```
            
            > **Note**: [crates.io](https://crates.io) requires either `license` or `license-file` to be set.
            "%
            = predicates.isType '"String",
          Lto
            | doc m%"
            The `lto` setting controls the [`-C lto` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#lto) which controls LLVM's [link time optimizations](https://llvm.org/docs/LinkTimeOptimization.html). LTO can produce better optimized code, using
            whole-program analysis, at the cost of longer linking time.
                                
            See also the [`-C linker-plugin-lto`](https://doc.rust-lang.org/rustc/codegen-options/index.html#linker-plugin-lto) `rustc` flag for cross-language LTO.
            "%
            = predicates.enum [ "fat", "thin", "off", true, false ],
          MetaBuild = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          OptLevel
            | doc m%"
            The `opt-level` setting controls the [`-C opt-level` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#opt-level) which controls the level
            of optimization. Higher optimization levels may produce faster runtime code at
            the expense of longer compiler times. Higher levels may also change and
            rearrange the compiled code which may make it harder to use with a debugger.
            
            It is recommended to experiment with different levels to find the right
            balance for your project. There may be surprising results, such as level `3`
            being slower than `2`, or the `"s"` and `"z"` levels not being necessarily
            smaller. You may also want to reevaluate your settings over time as newer
            versions of `rustc` changes optimization behavior.
            
            See also [Profile Guided Optimization](https://doc.rust-lang.org/rustc/profile-guided-optimization.html) for more advanced optimization
            techniques.
            "%
            = predicates.enum [ 0, 1, 2, 3, "s", "z" ],
          Package
            | doc m%"
            The only fields required by Cargo are [`name`](https://doc.rust-lang.org/cargo/reference/manifest.html#the-name-field) and
            [`version`](https://doc.rust-lang.org/cargo/reference/manifest.html#the-version-field). If publishing to a registry, the registry may
            require additional fields. See the notes below and [the publishing chapter](https://doc.rust-lang.org/cargo/reference/publishing.html) for requirements for publishing to [crates.io](https://crates.io/).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "version" ],
                predicates.records.record
                {
                  authors = predicates.anyOf
                      [
                        definitions.predicate.Authors,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  autobenches = predicates.isType '"Bool",
                  autobins = predicates.isType '"Bool",
                  autoexamples = predicates.isType '"Bool",
                  autotests = predicates.isType '"Bool",
                  build = definitions.predicate.Build,
                  categories = predicates.anyOf
                      [
                        definitions.predicate.Categories,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  default-run = predicates.isType '"String",
                  description = predicates.anyOf
                      [
                        definitions.predicate.Description,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  documentation = predicates.anyOf
                      [
                        definitions.predicate.Documentation,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  edition = predicates.anyOf
                      [
                        definitions.predicate.Edition,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  exclude = predicates.anyOf
                      [
                        definitions.predicate.Exclude,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  homepage = predicates.anyOf
                      [
                        definitions.predicate.Homepage,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  im-a-teapot = predicates.isType '"Bool",
                  include = predicates.anyOf
                      [
                        definitions.predicate.Include,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  keywords = predicates.anyOf
                      [
                        definitions.predicate.Keywords,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  license = predicates.anyOf
                      [
                        definitions.predicate.License,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  license-file = predicates.anyOf
                      [
                        definitions.predicate.LicenseFile,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  links = predicates.isType '"String",
                  metabuild = definitions.predicate.MetaBuild,
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { playdate = definitions.predicate.PlaydateMetadata, }
                        {  }
                        true
                        predicates.always
                      ],
                  name = predicates.isType '"String",
                  namespaced-features = predicates.isType '"Bool",
                  publish = predicates.anyOf
                      [
                        definitions.predicate.Publish,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  publish-lockfile = predicates.isType '"Bool",
                  readme = predicates.anyOf
                      [
                        definitions.predicate.Readme,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  repository = predicates.anyOf
                      [
                        definitions.predicate.Repository,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  resolver = definitions.predicate.Resolver,
                  rust-version = predicates.anyOf
                      [
                        definitions.predicate.RustVersion,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  version = predicates.anyOf
                      [
                        definitions.predicate.SemVer,
                        definitions.predicate.WorkspaceInheritance
                      ],
                  workspace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Panic
            | doc m%"
            The `panic` setting controls the [`-C panic` flag](https://doc.rust-lang.org/rustc/codegen-options/index.html#panic) which controls which panic
            strategy to use.
            
            When set to `"unwind"`, the actual value depends on the default of the target
            platform. For example, the NVPTX platform does not support unwinding, so it
            always uses `"abort"`.
            
            Tests, benchmarks, build scripts, and proc macros ignore the `panic` setting.
            The `rustc` test harness currently requires `unwind` behavior. See the
            [`panic-abort-tests`](https://doc.rust-lang.org/cargo/reference/unstable.html#panic-abort-tests) unstable flag which enables `abort` behavior.
            
            Additionally, when using the `abort` strategy and building a test, all of the
            dependencies will also be forced to built with the `unwind` strategy.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "unwind", "abort" ]
              ],
          Platform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  build-dependencies = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.Dependency
                      ],
                  build_dependencies = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.Dependency
                      ],
                  dependencies = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.Dependency
                      ],
                  dev-dependencies = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.Dependency
                      ],
                  dev_dependencies = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.Dependency
                      ],
                }
                {  }
                true
                predicates.always
              ],
          PlaydateMetadata
            | doc m%"
            Metadata and build configuration.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "bundle-id" ],
                predicates.records.record
                {
                  assets = predicates.anyOf
                      [
                        definitions.predicate.PlaydateMetadataAssetsMap,
                        definitions.predicate.PlaydateMetadataAssetsArray
                      ],
                  author = predicates.isType '"String",
                  build-number = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  bundle-id = predicates.isType '"String",
                  content-warning = predicates.isType '"String",
                  content-warning2 = predicates.isType '"String",
                  description = predicates.isType '"String",
                  dev-assets = predicates.anyOf
                      [
                        definitions.predicate.PlaydateMetadataAssetsMap,
                        definitions.predicate.PlaydateMetadataAssetsArray
                      ],
                  image-path = predicates.isType '"String",
                  launch-sound-path = predicates.isType '"String",
                  name = predicates.isType '"String",
                  options = definitions.predicate.PlaydateMetadataOptions,
                  support = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PlaydateMetadataAssetsArray
            | doc m%"
            List of paths to include.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String"),
                predicates.arrays.uniqueItems
              ],
          PlaydateMetadataAssetsMap
            | doc m%"
            Rules used to resolve paths to include.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  options = definitions.predicate.PlaydateMetadataAssetsOptions,
                }
                {  }
                true
                (predicates.anyOf
                [ predicates.isType '"String", predicates.isType '"Bool" ])
              ],
          PlaydateMetadataAssetsOptions
            | doc m%"
            Options for assets paths resolution and how to build assets collection
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  dependencies = predicates.isType '"Bool",
                  follow-symlinks = predicates.isType '"Bool",
                  method = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "copy", "link" ]
                      ],
                  overwrite = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          PlaydateMetadataOptions
            | doc m%"
            Package build options.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  assets = definitions.predicate.PlaydateMetadataAssetsOptions,
                }
                {  }
                true
                predicates.always
              ],
          Profile = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  codegen-units = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  debug = definitions.predicate.DebugLevel,
                  debug-assertions = predicates.isType '"Bool",
                  dir-name = predicates.isType '"String",
                  incremental = predicates.isType '"Bool",
                  inherits = predicates.isType '"String",
                  lto = definitions.predicate.Lto,
                  opt-level = definitions.predicate.OptLevel,
                  overflow-checks = predicates.isType '"Bool",
                  package = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.Profile
                      ],
                  panic = definitions.predicate.Panic,
                  rpath = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          ProfileWithBuildOverride = predicates.allOf
              [
                definitions.predicate.Profile,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  { build-override = definitions.predicate.Profile, }
                  {  }
                  true
                  predicates.always
                ]
              ],
          Profiles
            | doc m%"
            Profiles provide a way to alter the compiler settings, influencing things like optimizations and debugging symbols.
            
            Cargo has 4 built-in profiles: dev, release, test, and bench. It automatically chooses the profile based on which command is being run, the package and target that is being built, and command-line flags like --release.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bench = definitions.predicate.ProfileWithBuildOverride,
                  dev = definitions.predicate.ProfileWithBuildOverride,
                  release = definitions.predicate.ProfileWithBuildOverride,
                  test = definitions.predicate.ProfileWithBuildOverride,
                }
                {  }
                true
                definitions.predicate.ProfileWithBuildOverride
              ],
          Publish
            | doc m%"
            The `publish` field can be used to prevent a package from being published to a package registry (like *crates.io*) by mistake, for instance to keep a package
            private in a company.
            
            ```toml
            [package]
            # ...
            publish = false
            ```
            
            The value may also be an array of strings which are registry names that are
            allowed to be published to.
            
            ```toml
            [package]
            # ...
            publish = ["some-registry-name"]
            ```
            "%
            = predicates.anyOf
              [
                predicates.allOf
                [ predicates.isType '"Bool", predicates.enum [ true, false ] ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          Readme
            | doc m%"
            The `readme` field should be the path to a file in the package root (relative
            to this `Cargo.toml`) that contains general information about the package.
            This file will be transferred to the registry when you publish. [crates.io](https://crates.io)
            will interpret it as Markdown and render it on the crate's page.
            
            ```toml
            [package]
            # ...
            readme = "README.md"
            ```
            
            If no value is specified for this field, and a file named `README.md`,
            `README.txt` or `README` exists in the package root, then the name of that
            file will be used. You can suppress this behavior by setting this field to
            `false`. If the field is set to `true`, a default value of `README.md` will
            be assumed.
            "%
            = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [ predicates.isType '"Bool", predicates.enum [ true, false ] ]
              ],
          Repository
            | doc m%"
            The `repository` field should be a URL to the source repository for your
            package.
            
            ```toml
            [package]
            # ...
            repository = "https://github.com/rust-lang/cargo/"
            ```
            "%
            = predicates.isType '"String",
          Resolver
            | doc m%"
            A different feature resolver algorithm can be used by specifying the resolver version in Cargo.toml like this:
            
            [package]
            name = "my-package"
            version = "1.0.0"
            resolver = "2"
            
            The version "1" resolver is the original resolver that shipped with Cargo up to version 1.50. The default is "2" if the root package specifies edition = "2021" or a newer edition. Otherwise the default is "1".
            
            The version "2" resolver introduces changes in feature unification. See the features chapter for more details.
            
            The resolver is a global option that affects the entire workspace. The resolver version in dependencies is ignored, only the value in the top-level package will be used. If using a virtual workspace, the version should be specified in the [workspace] table, for example:
            
            [workspace]
            members = ["member1", "member2"]
            resolver = "2"
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.enum [ "1", "2" ] ],
          RustVersion
            | doc m%"
            The `rust-version` field is an optional key that tells cargo what version of the
            Rust language and compiler your package can be compiled with. If the currently
            selected version of the Rust compiler is older than the stated version, cargo
            will exit with an error, telling the user what version is required.
            
            The first version of Cargo that supports this field was released with Rust 1.56.0.
            In older releases, the field will be ignored, and Cargo will display a warning.
            
            ```toml
            [package]
            # ...
            rust-version = "1.56"
            ```
            
            The Rust version must be a bare version number with two or three components; it
            cannot include semver operators or pre-release identifiers. Compiler pre-release
            identifiers such as -nightly will be ignored while checking the Rust version.
            The `rust-version` must be equal to or newer than the version that first
            introduced the configured `edition`.
            
            The `rust-version` may be ignored using the `--ignore-rust-version` option.
            
            Setting the `rust-version` key in `[package]` will affect all targets/crates in
            the package, including test suites, benchmarks, binaries, examples, etc.
            "%
            = predicates.isType '"String",
          SemVer
            | doc m%"
            Cargo bakes in the concept of [Semantic Versioning](https://semver.org/), so make sure you follow some basic rules:
            
            * Before you reach 1.0.0, anything goes, but if you make breaking changes,
                increment the minor version. In Rust, breaking changes include adding fields to
                structs or variants to enums.
            * After 1.0.0, only make breaking changes when you increment the major version.
                Don't break the build.
            * After 1.0.0, don't add any new public API (no new `pub` anything) in patch-level
                versions. Always increment the minor version if you add any new `pub` structs,
                traits, fields, types, functions, methods or anything else.
            * Use version numbers with three numeric parts such as 1.0.0 rather than 1.0.
            "%
            = predicates.isType '"String",
          SemVerRequirement
            | doc m%"
            The [version requirement](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html) of the target dependency.
            "%
            = predicates.isType '"String",
          Target = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bench = predicates.isType '"Bool",
                  crate-type = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  crate_type = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  "doc" = predicates.isType '"Bool",
                  doctest = predicates.isType '"Bool",
                  edition = definitions.predicate.Edition,
                  harness = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  path = predicates.isType '"String",
                  plugin = predicates.isType '"Bool",
                  proc-macro = predicates.isType '"Bool",
                  proc_macro = predicates.isType '"Bool",
                  required-features = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  test = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          Workspace
            | doc m%"
            The `[workspace]` table in `Cargo.toml` defines which packages are members of
            the workspace:
            
            ```toml
            [workspace]
            members = ["member1", "path/to/member2", "crates/*"]
            exclude = ["crates/foo", "path/to/other"]
            ```
            
            An empty `[workspace]` table can be used with a `[package]` to conveniently
            create a workspace with the package and all of its path dependencies.
            
            All [`path` dependencies](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html#specifying-path-dependencies) residing in the workspace directory automatically
            become members. Additional members can be listed with the `members` key, which
            should be an array of strings containing directories with `Cargo.toml` files.
            
            The `members` list also supports [globs](https://docs.rs/glob/0.3.0/glob/struct.Pattern.html) to match multiple paths, using
            typical filename glob patterns like `*` and `?`.
            
            The `exclude` key can be used to prevent paths from being included in a
            workspace. This can be useful if some path dependencies aren't desired to be
            in the workspace at all, or using a glob pattern and you want to remove a
            directory.
            
            An empty `[workspace]` table can be used with a `[package]` to conveniently
            create a workspace with the package and all of its path dependencies.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  default-members = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  dependencies = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.Dependency
                      ],
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  members = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  package = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          authors = definitions.predicate.Authors,
                          categories = definitions.predicate.Categories,
                          description = definitions.predicate.Description,
                          documentation = definitions.predicate.Documentation,
                          edition = definitions.predicate.Edition,
                          exclude = definitions.predicate.Exclude,
                          homepage = definitions.predicate.Homepage,
                          include = definitions.predicate.Include,
                          keywords = definitions.predicate.Keywords,
                          license = definitions.predicate.License,
                          license-file = definitions.predicate.LicenseFile,
                          publish = definitions.predicate.Publish,
                          readme = definitions.predicate.Readme,
                          repository = definitions.predicate.Repository,
                          rust-version = definitions.predicate.RustVersion,
                          version = definitions.predicate.SemVer,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  resolver = definitions.predicate.Resolver,
                }
                {  }
                true
                predicates.always
              ],
          WorkspaceInheritance
            | doc m%"
            The `workspace` field allow keys to be inherited by defining them in the member package with `{key}.workspace = true`
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  workspace = predicates.allOf
                      [ predicates.isType '"Bool", predicates.enum [ true ] ],
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
  predicates.records.record
  {
    badges = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record {  } {  } true
            (predicates.isType '"String")
          ])
        ],
    bench = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.Target
        ],
    bin = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.Target
        ],
    build-dependencies = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          definitions.predicate.Dependency
        ],
    build_dependencies = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          definitions.predicate.Dependency
        ],
    cargo-features = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ],
    dependencies = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          definitions.predicate.Dependency
        ],
    dev-dependencies = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          definitions.predicate.Dependency
        ],
    dev_dependencies = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          definitions.predicate.Dependency
        ],
    example = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.Target
        ],
    features = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf (predicates.isType '"String")
          ])
        ],
    lib = definitions.predicate.Target,
    package = definitions.predicate.Package,
    patch = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record {  } {  } true
            definitions.predicate.Dependency
          ])
        ],
    profile = definitions.predicate.Profiles,
    project = definitions.predicate.Package,
    replace = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          definitions.predicate.Dependency
        ],
    target = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          definitions.predicate.Platform
        ],
    test = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.Target
        ],
    workspace = definitions.predicate.Workspace,
  }
  {  }
  true
  predicates.always
])