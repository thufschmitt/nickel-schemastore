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
          action_v2 = predicates.contract_from_predicate
              definitions.predicate.action_v2,
          action_v3 = predicates.contract_from_predicate
              definitions.predicate.action_v3,
          command = predicates.contract_from_predicate
              definitions.predicate.command,
          content_security_policy
            | doc m%"
            This introduces some fairly strict policies that will make extensions more secure by default, and provides you with the ability to create and enforce rules governing the types of content that can be loaded and executed by your extensions and applications.
            "%
            = String,
          glob_pattern = String,
          icon = definitions.contract.uri,
          match_pattern = predicates.contract_from_predicate
              definitions.predicate.match_pattern,
          mime_type = predicates.contract_from_predicate
              definitions.predicate.mime_type,
          page = definitions.contract.uri,
          permissions = predicates.contract_from_predicate
              definitions.predicate.permissions,
          scripts = predicates.contract_from_predicate
              definitions.predicate.scripts,
          uri = String,
          version_string = predicates.contract_from_predicate
              definitions.predicate.version_string,
          web_resource = {
                extension_ids
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of extension IDs, specifying which extensions can access the resources.
                  "%
                  | optional,
                matches
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.match_pattern
                  ])
                  | doc m%"
                  A list of URL match patterns specifying which pages can access the resources. Only the origin is used to match URLs; subdomains patterns (*.google.com) and paths are ignored.
                  "%
                  | optional,
                resources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.glob_pattern
                  ])
                  | doc m%"
                  An array of resources to be exposed. Resources are specified as strings and may contain * for wildcard matches. For example, "/images/*" exposes everything in the extension's /images directory recursively while "*.png" exposes all PNG files.
                  "%,
                use_dynamic_url
                  | Bool
                  | doc m%"
                  If true, only allow resources to be accessible through dynamic ID. The dynamic ID is generated per session. It's regenerated on browser restart or extension reload.
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          action_v2 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  default_icon = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            "19" = definitions.predicate.icon,
                            "38" = definitions.predicate.icon,
                          }
                          {  }
                          true
                          predicates.always
                        ]
                      ],
                  default_popup = definitions.predicate.uri,
                  default_title = predicates.isType '"String",
                }
                {  }
                true
                predicates.always,
                predicates.records.dependencies
                {
                  icons = predicates.not
                      (predicates.allOf
                      [
                        predicates.records.required [ "icons" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]),
                  name = predicates.not
                      (predicates.allOf
                      [
                        predicates.records.required [ "name" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]),
                  popup = predicates.not
                      (predicates.allOf
                      [
                        predicates.records.required [ "popup" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]),
                }
              ],
          action_v3 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  default_icon = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          "16" = definitions.predicate.icon,
                          "24" = definitions.predicate.icon,
                          "32" = definitions.predicate.icon,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  default_popup = definitions.predicate.uri,
                  default_title = predicates.isType '"String",
                }
                {  }
                true
                predicates.always,
                predicates.records.dependencies
                {
                  icons = predicates.not
                      (predicates.allOf
                      [
                        predicates.records.required [ "icons" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]),
                  name = predicates.not
                      (predicates.allOf
                      [
                        predicates.records.required [ "name" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]),
                  popup = predicates.not
                      (predicates.allOf
                      [
                        predicates.records.required [ "popup" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]),
                }
              ],
          command = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.ifThenElse
                (predicates.allOf
                [
                  predicates.records.required [ "global" ],
                  predicates.records.record { global = predicates.const true, }
                  {  }
                  true
                  predicates.always
                ])
                (predicates.records.record
                {
                  description = predicates.isType '"String",
                  global = predicates.isType '"Bool",
                  suggested_key = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(default|mac|windows|linux|chromeos)$" =
                            predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(Ctrl|Command|MacCtrl)\\+Shift\\+[0-9]"
                              ],
                        }
                        false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never)
                (predicates.records.record
                {
                  description = predicates.isType '"String",
                  global = predicates.isType '"Bool",
                  suggested_key = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^(default|mac|windows|linux|chromeos)$" =
                            predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(Ctrl|Command|MacCtrl|Alt|Option)\\+(Shift\\+)?[A-Z]"
                              ],
                        }
                        false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never)
              ],
          content_security_policy
            | doc m%"
            This introduces some fairly strict policies that will make extensions more secure by default, and provides you with the ability to create and enforce rules governing the types of content that can be loaded and executed by your extensions and applications.
            "%
            = predicates.isType '"String",
          glob_pattern = predicates.isType '"String",
          icon = definitions.predicate.uri,
          match_pattern = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^((\\*|http|https|file|ftp|chrome-extension):\\/\\/(\\*|\\*\\.[^\\/\\*]+|[^\\/\\*]+)?(\\/.*))|urn:(\\*|.*)|<all_urls>$"
              ],
          mime_type = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(?:application|audio|image|message|model|multipart|text|video)\\/[-+.\\w]+$"
              ],
          page = definitions.predicate.uri,
          permissions = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String"),
                predicates.arrays.uniqueItems
              ],
          scripts = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.uri,
                predicates.arrays.minItems 1,
                predicates.arrays.uniqueItems
              ],
          uri = predicates.isType '"String",
          version_string = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^(?:\\d{1,5}\\.){0,3}\\d{1,5}$"
              ],
          web_resource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "resources" ],
                predicates.records.record
                {
                  extension_ids = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  matches = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.match_pattern
                      ],
                  resources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.glob_pattern
                      ],
                  use_dynamic_url = predicates.isType '"Bool",
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
  predicates.ifThenElse
  (predicates.records.record { manifest_version = predicates.const 3, } {  }
  true
  predicates.always)
  (predicates.allOf
  [
    predicates.records.record
    {
      action = definitions.predicate.action_v3,
      background = predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              service_worker = predicates.isType '"String",
              type = predicates.allOf
                  [ predicates.isType '"String", predicates.enum [ "module" ] ],
            }
            {  }
            true
            predicates.always,
            predicates.records.dependencies
            {
              page = predicates.not
                  (predicates.allOf
                  [
                    predicates.records.required [ "scripts" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]),
              scripts = predicates.not
                  (predicates.allOf
                  [
                    predicates.records.required [ "page" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]),
            }
          ],
      content_security_policy = predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              extension_pages = definitions.predicate.content_security_policy,
              sandbox = definitions.predicate.content_security_policy,
            }
            {  }
            true
            predicates.always
          ],
      host_permissions = definitions.predicate.permissions,
      web_accessible_resources = predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf definitions.predicate.web_resource,
            predicates.arrays.minItems 1,
            predicates.arrays.uniqueItems
          ],
    }
    {  }
    true
    predicates.always,
    predicates.records.dependencies
    {
      browser_action = predicates.not
          (predicates.allOf
          [
            predicates.records.required [ "browser_action" ],
            predicates.records.record {  } {  } true predicates.always
          ]),
      page_action = predicates.not
          (predicates.allOf
          [
            predicates.records.required [ "page_action" ],
            predicates.records.record {  } {  } true predicates.always
          ]),
    }
  ])
  (predicates.allOf
  [
    predicates.records.record
    {
      background = predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              page = definitions.predicate.page,
              persistent = predicates.isType '"Bool",
              scripts = definitions.predicate.scripts,
            }
            {  }
            true
            predicates.always,
            predicates.records.dependencies
            {
              page = predicates.not
                  (predicates.allOf
                  [
                    predicates.records.required [ "scripts" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]),
              scripts = predicates.not
                  (predicates.allOf
                  [
                    predicates.records.required [ "page" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]),
            }
          ],
      browser_action = definitions.predicate.action_v2,
      content_security_policy = definitions.predicate.content_security_policy,
      page_action = definitions.predicate.action_v2,
      web_accessible_resources = predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf definitions.predicate.uri,
            predicates.arrays.minItems 1,
            predicates.arrays.uniqueItems
          ],
    }
    {  }
    true
    predicates.always,
    predicates.records.dependencies
    {
      browser_action = predicates.not
          (predicates.allOf
          [
            predicates.records.required [ "page_action" ],
            predicates.records.record {  } {  } true predicates.always
          ]),
      page_action = predicates.not
          (predicates.allOf
          [
            predicates.records.required [ "browser_action" ],
            predicates.records.record {  } {  } true predicates.always
          ]),
    }
  ]),
  predicates.records.required [ "manifest_version", "name", "version" ],
  predicates.records.record
  {
    chrome_settings_overrides = predicates.always,
    chrome_url_overrides = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.maxProperties 1,
          predicates.records.record
          {
            bookmarks = definitions.predicate.page,
            history = definitions.predicate.page,
            newtab = definitions.predicate.page,
          }
          {  }
          false
          predicates.never
        ],
    commands = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            ".*" = definitions.predicate.command,
            "^_execute_browser_action$" = definitions.predicate.command,
            "^_execute_page_action$" = definitions.predicate.command,
          }
          true
          predicates.always
        ],
    content_pack = predicates.always,
    content_scripts = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "matches" ],
            predicates.records.record
            {
              all_frames = predicates.isType '"Bool",
              css = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.uri,
                    predicates.arrays.uniqueItems
                  ],
              exclude_globs = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.glob_pattern,
                    predicates.arrays.uniqueItems
                  ],
              exclude_matches = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.match_pattern,
                    predicates.arrays.uniqueItems
                  ],
              include_globs = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.glob_pattern,
                    predicates.arrays.uniqueItems
                  ],
              js = definitions.predicate.scripts,
              match_about_blank = predicates.isType '"Bool",
              matches = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.match_pattern,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ],
              run_at = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [ "document_start", "document_end", "document_idle" ]
                  ],
              world = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "ISOLATED", "MAIN" ]
                  ],
            }
            {  }
            false
            predicates.never
          ]),
          predicates.arrays.minItems 1,
          predicates.arrays.uniqueItems
        ],
    current_locale = predicates.always,
    default_locale = predicates.isType '"String",
    description = predicates.allOf
        [ predicates.isType '"String", predicates.strings.maxLength 132 ],
    devtools_page = definitions.predicate.page,
    externally_connectable = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            accepts_tls_channel_id = predicates.isType '"Bool",
            ids = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            matches = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
          }
          {  }
          false
          predicates.never
        ],
    file_browser_handlers = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required
            [ "default_title", "file_filters", "id" ],
            predicates.records.record
            {
              default_title = predicates.isType '"String",
              file_filters = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 1
                  ],
              id = predicates.isType '"String",
            }
            {  }
            false
            predicates.never
          ]),
          predicates.arrays.minItems 1
        ],
    homepage_url = definitions.predicate.uri,
    icons = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.minProperties 1,
          predicates.records.record
          {
            "128" = definitions.predicate.icon,
            "16" = definitions.predicate.icon,
            "256" = definitions.predicate.icon,
            "48" = definitions.predicate.icon,
          }
          {  }
          true
          predicates.always
        ],
    "import" = predicates.always,
    incognito = predicates.allOf
        [
          predicates.isType '"String",
          predicates.enum [ "spanning", "split", "not_allowed" ]
        ],
    input_components = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required
            [ "description", "id", "language", "layouts", "name", "type" ],
            predicates.records.record
            {
              description = predicates.isType '"String",
              id = predicates.isType '"String",
              language = predicates.isType '"String",
              layouts = predicates.isType '"Array",
              name = predicates.isType '"String",
              type = predicates.isType '"String",
            }
            {  }
            false
            predicates.never
          ])
        ],
    key = predicates.isType '"String",
    manifest_version = predicates.allOf
        [ predicates.isType '"Number", predicates.enum [ 2, 3 ] ],
    minimum_chrome_version = definitions.predicate.version_string,
    nacl_modules = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "mime_type", "path" ],
            predicates.records.record
            {
              mime_type = definitions.predicate.mime_type,
              path = definitions.predicate.uri,
            }
            {  }
            false
            predicates.never
          ]),
          predicates.arrays.minItems 1,
          predicates.arrays.uniqueItems
        ],
    name = predicates.allOf
        [ predicates.isType '"String", predicates.strings.maxLength 45 ],
    oauth2 = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "client_id", "scopes" ],
          predicates.records.record
          {
            client_id = predicates.isType '"String",
            scopes = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String"),
                  predicates.arrays.minItems 1
                ],
          }
          {  }
          false
          predicates.never
        ],
    offline_enabled = predicates.isType '"Bool",
    omnibox = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "keyword" ],
          predicates.records.record { keyword = predicates.isType '"String", }
          {  }
          false
          predicates.never
        ],
    optional_permissions = definitions.predicate.permissions,
    options_page = definitions.predicate.page,
    options_ui = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "page" ],
          predicates.records.record
          {
            chrome_style = predicates.isType '"Bool",
            open_in_tab = predicates.isType '"Bool",
            page = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    permissions = definitions.predicate.permissions,
    platforms = predicates.always,
    requirements = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            "3D" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "features" ],
                  predicates.records.record
                  {
                    features = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "webgl" ]
                          ]),
                          predicates.arrays.minItems 1,
                          predicates.arrays.uniqueItems
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
            plugins = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "npapi" ],
                  predicates.records.record
                  { npapi = predicates.isType '"Bool", }
                  {  }
                  false
                  predicates.never
                ],
          }
          {  }
          false
          predicates.never
        ],
    sandbox = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "pages" ],
          predicates.records.record
          {
            content_security_policy =
              definitions.predicate.content_security_policy,
            pages = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.page,
                  predicates.arrays.minItems 1,
                  predicates.arrays.uniqueItems
                ],
          }
          {  }
          false
          predicates.never
        ],
    short_name = predicates.allOf
        [ predicates.isType '"String", predicates.strings.maxLength 12 ],
    signature = predicates.always,
    spellcheck = predicates.always,
    storage = predicates.always,
    system_indicator = predicates.always,
    tts_engine = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "voices" ],
          predicates.records.record
          {
            voices = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "event_types", "voice_name" ],
                    predicates.records.record
                    {
                      event_types = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [
                                "start",
                                "word",
                                "sentence",
                                "marker",
                                "end",
                                "error"
                              ]
                            ]),
                            predicates.arrays.minItems 1,
                            predicates.arrays.uniqueItems
                          ],
                      gender = predicates.isType '"String",
                      lang = predicates.isType '"String",
                      voice_name = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ]),
                  predicates.arrays.minItems 1,
                  predicates.arrays.uniqueItems
                ],
          }
          {  }
          false
          predicates.never
        ],
    update_url = definitions.predicate.uri,
    version = definitions.predicate.version_string,
    version_name = predicates.isType '"String",
  }
  {  }
  true
  predicates.always,
  predicates.records.dependencies
  {
    content_scripts = predicates.not
        (predicates.allOf
        [
          predicates.records.required [ "script_badge" ],
          predicates.records.record {  } {  } true predicates.always
        ]),
    script_badge = predicates.not
        (predicates.allOf
        [
          predicates.records.required [ "content_scripts" ],
          predicates.records.record {  } {  } true predicates.always
        ]),
  }
])