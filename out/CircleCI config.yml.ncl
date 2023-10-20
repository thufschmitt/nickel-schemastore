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
          builtinSteps = predicates.contract_from_predicate
              definitions.predicate.builtinSteps,
          commands
            | doc m%"
            https://circleci.com/docs/configuration-reference#commands-requires-version-21
            
            A command definition defines a sequence of steps as a map to be executed in a job, enabling you to reuse a single command definition across multiple jobs.
            "%
            = predicates.contract_from_predicate definitions.predicate.commands,
          dockerExecutor
            | doc m%"
            Options for the [docker executor](https://circleci.com/docs/configuration-reference#docker)
            "%
            = predicates.contract_from_predicate
              definitions.predicate.dockerExecutor,
          executorChoice = predicates.contract_from_predicate
              definitions.predicate.executorChoice,
          executors
            | doc m%"
            Executors define the environment in which the steps of a job will be run, allowing you to reuse a single executor definition across multiple jobs.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.executors,
          filter
            | doc m%"
            A map defining rules for execution on specific branches
            "%
            = {
                ignore
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  Either a single branch specifier, or a list of branch specifiers
                  "%
                  | optional,
                only
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  Either a single branch specifier, or a list of branch specifiers
                  "%
                  | optional,
              },
          jobRef
            | doc m%"
            Run a job as part of this workflow
            "%
            = {
                context
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  Either a single context name, or a list of contexts. The default name is `org-global`
                  "%
                  | optional,
                filters
                  | {
                    branches | definitions.contract.filter | optional,
                    tags | definitions.contract.filter | optional,
                  }
                  | doc m%"
                  A map defining rules for execution on specific branches
                  "%
                  | optional,
                matrix
                  | {
                    alias
                      | String
                      | doc m%"
                      An alias for the matrix, usable from another job's requires stanza. Defaults to the name of the job being executed
                      "%
                      | optional,
                    exclude
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType 'Record)
                      ])
                      | doc m%"
                      A list of argument maps that should be excluded from the matrix
                      "%
                      | optional,
                    parameters
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"Array")
                      ])
                      | doc m%"
                      A map of parameter names to every value the job should be called with
                      "%,
                  }
                  | doc m%"
                  https://circleci.com/docs/configuration-reference#matrix-requires-version-21
                  
                  The matrix stanza allows you to run a parameterized job multiple times with different arguments.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name key can be used to ensure build numbers are not appended when invoking the same job multiple times (e.g., sayhello-1, sayhello-2). The name assigned needs to be unique, otherwise numbers will still be appended to the job name
                  "%
                  | optional,
                requires
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Jobs are run in parallel by default, so you must explicitly require any dependencies by their job name.
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  (predicates.enum [ "approval" ])
                  | doc m%"
                  A job may have a `type` of `approval` indicating it must be manually approved before downstream jobs may proceed.
                  "%
                  | optional,
                ..
              },
          jobs
            | doc m%"
            Jobs are collections of steps. All of the steps in the job are executed in a single unit, either within a fresh container or VM.
            "%
            = predicates.contract_from_predicate definitions.predicate.jobs,
          logical
            | doc m%"
            https://circleci.com/docs/configuration-reference#logic-statements 
            
            A logical statement to be used in dynamic configuration
            "%
            = predicates.contract_from_predicate definitions.predicate.logical,
          machineExecutor
            | doc m%"
            Options for the [machine executor](https://circleci.com/docs/configuration-reference#machine)
            "%
            = {
                docker_layer_caching
                  | Bool
                  | doc m%"
                  Set to `true` to enable [Docker Layer Caching](https://circleci.com/docs/docker-layer-caching). Note: If you haven't already, you must open a support ticket to have a CircleCI Sales representative contact you about enabling this feature on your account for an additional fee.
                  "%
                  | optional,
                image
                  | String
                  | doc m%"
                  The VM image to use. View [available images](https://circleci.com/docs/configuration-reference#available-machine-images). **Note:** This key is **not** supported on the installable CircleCI. For information about customizing machine executor images on CircleCI installed on your servers, see our [VM Service documentation](https://circleci.com/docs/vm-service).
                  "%,
              },
          macosExecutor
            | doc m%"
            Options for the [macOS executor](https://circleci.com/docs/configuration-reference#macos)
            "%
            = {
                xcode
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"Number",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.numbers.minimum 0
                    ]
                  ])
                  | doc m%"
                  The version of Xcode that is installed on the virtual machine, see the [Supported Xcode Versions section of the Testing iOS](https://circleci.com/docs/testing-ios#supported-xcode-versions) document for the complete list.
                  "%,
              },
          orbs
            | doc m%"
            https://circleci.com/docs/configuration-reference#orbs-requires-version-21
            
            Orbs are reusable packages of CircleCI configuration that you may share across projects, enabling you to create encapsulated, parameterized commands, jobs, and executors that can be used across multiple projects.
            "%
            = predicates.contract_from_predicate definitions.predicate.orbs,
          step = predicates.contract_from_predicate definitions.predicate.step,
        },
    predicate = {
          builtinSteps = predicates.always,
          commands
            | doc m%"
            https://circleci.com/docs/configuration-reference#commands-requires-version-21
            
            A command definition defines a sequence of steps as a map to be executed in a job, enabling you to reuse a single command definition across multiple jobs.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "steps" ],
                  predicates.records.record
                  {
                    description = predicates.isType '"String",
                    parameters = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          {
                            "^[a-z][a-z0-9_-]+$" = predicates.oneOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "type" ],
                                    predicates.records.record
                                    {
                                      "default" = predicates.isType '"String",
                                      description = predicates.isType '"String",
                                      type = predicates.enum [ "string" ],
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ],
                                  predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "type" ],
                                    predicates.records.record
                                    {
                                      "default" = predicates.isType '"Bool",
                                      description = predicates.isType '"String",
                                      type = predicates.enum [ "boolean" ],
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ],
                                  predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "type" ],
                                    predicates.records.record
                                    {
                                      "default" = predicates.isType 'Integer,
                                      description = predicates.isType '"String",
                                      type = predicates.enum [ "integer" ],
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ],
                                  predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required
                                    [ "enum", "type" ],
                                    predicates.records.record
                                    {
                                      "default" = predicates.isType '"String",
                                      description = predicates.isType '"String",
                                      enum = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.isType '"String"),
                                            predicates.arrays.minItems 1
                                          ],
                                      type = predicates.enum [ "enum" ],
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ],
                                  predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "type" ],
                                    predicates.records.record
                                    {
                                      "default" = predicates.isType '"String",
                                      description = predicates.isType '"String",
                                      type = predicates.enum [ "executor" ],
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ],
                                  predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "type" ],
                                    predicates.records.record
                                    {
                                      "default" = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            definitions.predicate.step
                                          ],
                                      description = predicates.isType '"String",
                                      type = predicates.enum [ "steps" ],
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ],
                                  predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "type" ],
                                    predicates.records.record
                                    {
                                      "default" = predicates.allOf
                                          [
                                            predicates.isType '"String",
                                            predicates.strings.pattern
                                            "^[a-zA-Z][a-zA-Z0-9_-]+$"
                                          ],
                                      description = predicates.isType '"String",
                                      type = predicates.enum [ "env_var_name" ],
                                    }
                                    {  }
                                    true
                                    predicates.always
                                  ]
                                ],
                          }
                          true
                          predicates.always
                        ],
                    steps = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf definitions.predicate.step
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          dockerExecutor
            | doc m%"
            Options for the [docker executor](https://circleci.com/docs/configuration-reference#docker)
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "image" ],
                  predicates.records.record
                  {
                    auth = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            password = predicates.isType '"String",
                            username = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    aws_auth = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            aws_access_key_id = predicates.isType '"String",
                            aws_secret_access_key = predicates.isType '"String",
                            oidc_role_arn = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    command = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ]
                        ],
                    entrypoint = predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ]
                        ],
                    environment = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number",
                            predicates.isType '"Bool"
                          ])
                        ],
                    image = predicates.isType '"String",
                    name = predicates.isType '"String",
                    user = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          executorChoice = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "docker" ],
                  predicates.records.record
                  { docker = definitions.predicate.dockerExecutor, }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "machine" ],
                  predicates.records.record
                  { machine = definitions.predicate.machineExecutor, }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "machine" ],
                  predicates.records.record
                  { machine = predicates.isType '"Bool", }
                  {  }
                  true
                  predicates.always
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "macos" ],
                  predicates.records.record
                  { macos = definitions.predicate.macosExecutor, }
                  {  }
                  true
                  predicates.always
                ]
              ],
          executors
            | doc m%"
            Executors define the environment in which the steps of a job will be run, allowing you to reuse a single executor definition across multiple jobs.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    environment = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ])
                        ],
                    resource_class = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "small",
                            "medium+",
                            "large",
                            "xlarge",
                            "2xlarge",
                            "2xlarge+",
                            "arm.medium",
                            "arm.large",
                            "arm.xlarge",
                            "arm.2xlarge",
                            "gpu.nvidia.small",
                            "gpu.nvidia.medium",
                            "windows.gpu.nvidia.medium",
                            "macos.x86.medium.gen2",
                            "macos.m1.medium.gen1",
                            "macos.m1.large.gen1"
                          ]
                        ],
                    shell = predicates.isType '"String",
                    working_directory = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always,
                  definitions.predicate.executorChoice
                ])
              ],
          filter
            | doc m%"
            A map defining rules for execution on specific branches
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ignore = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  only = predicates.oneOf
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
          jobRef
            | doc m%"
            Run a job as part of this workflow
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  context = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  filters = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          branches = definitions.predicate.filter,
                          tags = definitions.predicate.filter,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  matrix = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "parameters" ],
                        predicates.records.record
                        {
                          alias = predicates.isType '"String",
                          exclude = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType 'Record)
                              ],
                          parameters = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  } {  } true
                                (predicates.isType '"Array")
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  name = predicates.isType '"String",
                  requires = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  type = predicates.enum [ "approval" ],
                }
                {  }
                true
                predicates.always
              ],
          jobs
            | doc m%"
            Jobs are collections of steps. All of the steps in the job are executed in a single unit, either within a fresh container or VM.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.oneOf
                  [
                    definitions.predicate.executorChoice,
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "executor" ],
                      predicates.records.record
                      { executor = predicates.isType '"String", }
                      {  }
                      true
                      predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "executor" ],
                      predicates.records.record
                      {
                        executor = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "name" ],
                              predicates.records.record
                              { name = predicates.isType '"String", }
                              {  }
                              true
                              predicates.always
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ]
                  ],
                  predicates.records.required [ "steps" ],
                  predicates.records.record
                  {
                    branches = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ],
                    environment = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number"
                          ])
                        ],
                    parallelism = predicates.oneOf
                        [
                          predicates.isType 'Integer,
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "^<<.+\\..+>>$"
                          ]
                        ],
                    shell = predicates.isType '"String",
                    steps = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf definitions.predicate.step
                        ],
                    working_directory = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          logical
            | doc m%"
            https://circleci.com/docs/configuration-reference#logic-statements 
            
            A logical statement to be used in dynamic configuration
            "%
            = predicates.oneOf
              [
                predicates.anyOf
                [
                  predicates.isType '"String",
                  predicates.isType '"Bool",
                  predicates.isType 'Integer,
                  predicates.isType '"Number"
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.maxProperties 1,
                  predicates.records.minProperties 1,
                  predicates.records.record
                  {
                    and = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.logical
                        ],
                    equal = predicates.isType '"Array",
                    matches = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            pattern = predicates.isType '"String",
                            value = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    not = definitions.predicate.logical,
                    or = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.logical
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          machineExecutor
            | doc m%"
            Options for the [machine executor](https://circleci.com/docs/configuration-reference#machine)
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image" ],
                predicates.records.record
                {
                  docker_layer_caching = predicates.isType '"Bool",
                  image = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          macosExecutor
            | doc m%"
            Options for the [macOS executor](https://circleci.com/docs/configuration-reference#macos)
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "xcode" ],
                predicates.records.record
                {
                  xcode = predicates.oneOf
                      [
                        predicates.isType '"Number",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.numbers.minimum 0
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          orbs
            | doc m%"
            https://circleci.com/docs/configuration-reference#orbs-requires-version-21
            
            Orbs are reusable packages of CircleCI configuration that you may share across projects, enabling you to create encapsulated, parameterized commands, jobs, and executors that can be used across multiple projects.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[a-z][a-z0-9_-]+/[a-z][a-z0-9_-]+@(dev:[\\.a-z0-9_-]+|\\d+|\\d+\\.\\d+|\\d+\\.\\d+\\.\\d+|volatile)$"
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      commands = definitions.predicate.commands,
                      executors = definitions.predicate.executors,
                      jobs = definitions.predicate.jobs,
                      orbs = definitions.predicate.orbs,
                    }
                    {  }
                    true
                    predicates.always
                  ]
                ])
              ],
          step = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.enum [ "checkout" ],
                  definitions.predicate."builtinSteps/documentation/checkout"
                ],
                predicates.allOf
                [
                  predicates.enum [ "setup_remote_docker" ],
                  definitions.predicate."builtinSteps/documentation/setup_remote_docker"
                ],
                predicates.allOf
                [
                  predicates.enum [ "add_ssh_keys" ],
                  definitions.predicate."builtinSteps/documentation/add_ssh_keys"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^[a-z][a-z0-9_-]+$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern
                  "^[a-z][a-z0-9_-]+/[a-z][a-z0-9_-]+$"
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.maxProperties 1,
                  predicates.records.minProperties 1,
                  predicates.records.record
                  {
                    add_ssh_keys =
                      definitions.predicate."builtinSteps/configuration/add_ssh_keys",
                    attach_workspace =
                      definitions.predicate."builtinSteps/configuration/attach_workspace",
                    checkout =
                      definitions.predicate."builtinSteps/configuration/checkout",
                    deploy =
                      definitions.predicate."builtinSteps/configuration/deploy",
                    persist_to_workspace =
                      definitions.predicate."builtinSteps/configuration/persist_to_workspace",
                    restore_cache =
                      definitions.predicate."builtinSteps/configuration/restore_cache",
                    run =
                      definitions.predicate."builtinSteps/configuration/run",
                    save_cache =
                      definitions.predicate."builtinSteps/configuration/save_cache",
                    setup_remote_docker =
                      definitions.predicate."builtinSteps/configuration/setup_remote_docker",
                    store_artifacts =
                      definitions.predicate."builtinSteps/configuration/store_artifacts",
                    store_test_results =
                      definitions.predicate."builtinSteps/configuration/store_test_results",
                    unless =
                      definitions.predicate."builtinSteps/configuration/unless",
                    when =
                      definitions.predicate."builtinSteps/configuration/when",
                  }
                  {
                    "^[a-z][a-z0-9_-]+$" = predicates.always,
                    "^[a-z][a-z0-9_-]+/[a-z][a-z0-9_-]+$" = predicates.always,
                  }
                  true
                  predicates.always
                ]
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.required [ "version" ],
  predicates.records.record
  {
    commands = definitions.predicate.commands,
    executors = definitions.predicate.executors,
    jobs = definitions.predicate.jobs,
    orbs = definitions.predicate.orbs,
    version = predicates.enum [ 2, 2.1 ],
    workflows = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record { version = predicates.enum [ 2 ], } {  }
          true
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              jobs = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.oneOf
                    [
                      predicates.isType '"String",
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          definitions.predicate.jobRef
                        ])
                      ]
                    ])
                  ],
              triggers = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        schedule = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                cron = predicates.isType '"String",
                                filters = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        branches = definitions.predicate.filter,
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                              }
                              {  }
                              true
                              predicates.always
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              unless = definitions.predicate.logical,
              when = definitions.predicate.logical,
            }
            {  }
            false
            predicates.never
          ])
        ],
  }
  {  }
  true
  predicates.always
])