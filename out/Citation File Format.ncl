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
          address
            | doc m%"
            An address.
            "%
            = predicates.contract_from_predicate definitions.predicate.address,
          alias
            | doc m%"
            An alias.
            "%
            = predicates.contract_from_predicate definitions.predicate.alias,
          city
            | doc m%"
            A city
            "%
            = predicates.contract_from_predicate definitions.predicate.city,
          commit
            | doc m%"
            The (e.g., Git) commit hash or (e.g., Subversion) revision number of the work.
            "%
            = predicates.contract_from_predicate definitions.predicate.commit,
          country
            | doc m%"
            The ISO 3166-1 alpha-2 country code for a country.
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'ZW,
                  'ZM,
                  'ZA,
                  'YT,
                  'YE,
                  'WS,
                  'WF,
                  'VU,
                  'VN,
                  'VI,
                  'VG,
                  'VE,
                  'VC,
                  'VA,
                  'UZ,
                  'UY,
                  'US,
                  'UM,
                  'UG,
                  'UA,
                  'TZ,
                  'TW,
                  'TV,
                  'TT,
                  'TR,
                  'TO,
                  'TN,
                  'TM,
                  'TL,
                  'TK,
                  'TJ,
                  'TH,
                  'TG,
                  'TF,
                  'TD,
                  'TC,
                  'SZ,
                  'SY,
                  'SX,
                  'SV,
                  'ST,
                  'SS,
                  'SR,
                  'SO,
                  'SN,
                  'SM,
                  'SL,
                  'SK,
                  'SJ,
                  'SI,
                  'SH,
                  'SG,
                  'SE,
                  'SD,
                  'SC,
                  'SB,
                  'SA,
                  'RW,
                  'RU,
                  'RS,
                  'RO,
                  'RE,
                  'QA,
                  'PY,
                  'PW,
                  'PT,
                  'PS,
                  'PR,
                  'PN,
                  'PM,
                  'PL,
                  'PK,
                  'PH,
                  'PG,
                  'PF,
                  'PE,
                  'PA,
                  'OM,
                  'NZ,
                  'NU,
                  'NR,
                  'NP,
                  'NO,
                  'NL,
                  'NI,
                  'NG,
                  'NF,
                  'NE,
                  'NC,
                  'NA,
                  'MZ,
                  'MY,
                  'MX,
                  'MW,
                  'MV,
                  'MU,
                  'MT,
                  'MS,
                  'MR,
                  'MQ,
                  'MP,
                  'MO,
                  'MN,
                  'MM,
                  'ML,
                  'MK,
                  'MH,
                  'MG,
                  'MF,
                  'ME,
                  'MD,
                  'MC,
                  'MA,
                  'LY,
                  'LV,
                  'LU,
                  'LT,
                  'LS,
                  'LR,
                  'LK,
                  'LI,
                  'LC,
                  'LB,
                  'LA,
                  'KZ,
                  'KY,
                  'KW,
                  'KR,
                  'KP,
                  'KN,
                  'KM,
                  'KI,
                  'KH,
                  'KG,
                  'KE,
                  'JP,
                  'JO,
                  'JM,
                  'JE,
                  'IT,
                  'IS,
                  'IR,
                  'IQ,
                  'IO,
                  'IN,
                  'IM,
                  'IL,
                  'IE,
                  'ID,
                  'HU,
                  'HT,
                  'HR,
                  'HN,
                  'HM,
                  'HK,
                  'GY,
                  'GW,
                  'GU,
                  'GT,
                  'GS,
                  'GR,
                  'GQ,
                  'GP,
                  'GN,
                  'GM,
                  'GL,
                  'GI,
                  'GH,
                  'GG,
                  'GF,
                  'GE,
                  'GD,
                  'GB,
                  'GA,
                  'FR,
                  'FO,
                  'FM,
                  'FK,
                  'FJ,
                  'FI,
                  'ET,
                  'ES,
                  'ER,
                  'EH,
                  'EG,
                  'EE,
                  'EC,
                  'DZ,
                  'DO,
                  'DM,
                  'DK,
                  'DJ,
                  'DE,
                  'CZ,
                  'CY,
                  'CX,
                  'CW,
                  'CV,
                  'CU,
                  'CR,
                  'CO,
                  'CN,
                  'CM,
                  'CL,
                  'CK,
                  'CI,
                  'CH,
                  'CG,
                  'CF,
                  'CD,
                  'CC,
                  'CA,
                  'BZ,
                  'BY,
                  'BW,
                  'BV,
                  'BT,
                  'BS,
                  'BR,
                  'BQ,
                  'BO,
                  'BN,
                  'BM,
                  'BL,
                  'BJ,
                  'BI,
                  'BH,
                  'BG,
                  'BF,
                  'BE,
                  'BD,
                  'BB,
                  'BA,
                  'AZ,
                  'AX,
                  'AW,
                  'AU,
                  'AT,
                  'AS,
                  'AR,
                  'AQ,
                  'AO,
                  'AM,
                  'AL,
                  'AI,
                  'AG,
                  'AF,
                  'AE,
                  'AD
                |]
              ],
          date = predicates.contract_from_predicate definitions.predicate.date,
          doi
            | doc m%"
            The DOI of the work (i.e., 10.5281/zenodo.1003150, not the resolver URL http://doi.org/10.5281/zenodo.1003150).
            "%
            = predicates.contract_from_predicate definitions.predicate.doi,
          email
            | doc m%"
            An email address.
            "%
            = predicates.contract_from_predicate definitions.predicate.email,
          entity
            | doc m%"
            An entity, i.e., an institution, team, research group, company, conference, etc., as opposed to a single natural person.
            "%
            = {
                address
                  | definitions.contract.address
                  | doc m%"
                  The entity's address.
                  "%
                  | optional,
                alias
                  | definitions.contract.alias
                  | doc m%"
                  The entity's alias.
                  "%
                  | optional,
                city
                  | definitions.contract.city
                  | doc m%"
                  The entity's city.
                  "%
                  | optional,
                country
                  | definitions.contract.country
                  | doc m%"
                  The entity's country.
                  "%
                  | optional,
                date-end
                  | definitions.contract.date
                  | doc m%"
                  The entity's ending date, e.g., when the entity is a conference.
                  "%
                  | optional,
                date-start
                  | definitions.contract.date
                  | doc m%"
                  The entity's starting date, e.g., when the entity is a conference.
                  "%
                  | optional,
                email
                  | definitions.contract.email
                  | doc m%"
                  The entity's email address.
                  "%
                  | optional,
                fax
                  | definitions.contract.fax
                  | doc m%"
                  The entity's fax number.
                  "%
                  | optional,
                location
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The entity's location, e.g., when the entity is a conference.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The entity's name.
                  "%,
                orcid
                  | definitions.contract.orcid
                  | doc m%"
                  The entity's orcid.
                  "%
                  | optional,
                post-code
                  | definitions.contract.post-code
                  | doc m%"
                  The entity's post code.
                  "%
                  | optional,
                region
                  | definitions.contract.region
                  | doc m%"
                  The entity's region.
                  "%
                  | optional,
                tel
                  | definitions.contract.tel
                  | doc m%"
                  The entity's telephone number.
                  "%
                  | optional,
                website
                  | definitions.contract.url
                  | doc m%"
                  The entity's website.
                  "%
                  | optional,
              },
          fax
            | doc m%"
            A fax number.
            "%
            = predicates.contract_from_predicate definitions.predicate.fax,
          identifier
            | doc m%"
            An identifier for a work.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.identifier,
          identifier-description
            | doc m%"
            A description for a specific identifier value.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.identifier-description,
          license
            | doc m%"
            An SPDX license identifier.
            "%
            = predicates.contract_from_predicate definitions.predicate.license,
          license-enum
            | doc m%"
            SPDX license list; releaseDate=2021-05-14; source=https://raw.githubusercontent.com/spdx/license-list-data/master/json/licenses.json
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  '"ZPL-2.1",
                  '"ZPL-2.0",
                  '"ZPL-1.1",
                  'zlib-acknowledgement,
                  'Zlib,
                  '"Zimbra-1.4",
                  '"Zimbra-1.3",
                  '"Zend-2.0",
                  'Zed,
                  '"YPL-1.1",
                  '"YPL-1.0",
                  'XSkat,
                  'xpp,
                  'Xnet,
                  'xinetd,
                  '"XFree86-1.1",
                  'Xerox,
                  'X11,
                  'wxWindows,
                  'WTFPL,
                  'Wsuipa,
                  '"Watcom-1.0",
                  'W3C-20150513,
                  'W3C-19980720,
                  'W3C,
                  '"VSL-1.0",
                  'VOSTROM,
                  'Vim,
                  '"UPL-1.0",
                  'Unlicense,
                  'Unicode-TOU,
                  'Unicode-DFS-2016,
                  'Unicode-DFS-2015,
                  '"UCL-1.0",
                  '"TU-Berlin-2.0",
                  '"TU-Berlin-1.0",
                  'TOSL,
                  '"TORQUE-1.1",
                  'TMate,
                  'TCP-wrappers,
                  'TCL,
                  '"TAPR-OHL-1.0",
                  'SWL,
                  '"SugarCRM-1.1.3",
                  'StandardML-NJ,
                  '"SSPL-1.0",
                  'SSH-short,
                  'SSH-OpenSSH,
                  '"SPL-1.0",
                  'Spencer-99,
                  'Spencer-94,
                  'Spencer-86,
                  'SNIA,
                  'SMPPL,
                  'SMLNJ,
                  'Sleepycat,
                  '"SISSL-1.2",
                  'SISSL,
                  '"SimPL-2.0",
                  '"SHL-0.51",
                  '"SHL-0.5",
                  '"SGI-B-2.0",
                  '"SGI-B-1.1",
                  '"SGI-B-1.0",
                  '"Sendmail-8.23",
                  'Sendmail,
                  'SCEA,
                  'Saxpath,
                  'SAX-PD,
                  'Ruby,
                  'RSCPL,
                  'RSA-MD,
                  '"RPSL-1.0",
                  '"RPL-1.5",
                  '"RPL-1.1",
                  '"RHeCos-1.1",
                  'Rdisc,
                  '"QPL-1.0",
                  'Qhull,
                  '"Python-2.0",
                  'psutils,
                  'psfrag,
                  '"PSF-2.0",
                  'PostgreSQL,
                  '"PolyForm-Small-Business-1.0.0",
                  '"PolyForm-Noncommercial-1.0.0",
                  'Plexus,
                  '"PHP-3.01",
                  '"PHP-3.0",
                  '"PDDL-1.0",
                  '"Parity-7.0.0",
                  '"Parity-6.0.0",
                  '"OSL-3.0",
                  '"OSL-2.1",
                  '"OSL-2.0",
                  '"OSL-1.1",
                  '"OSL-1.0",
                  '"OSET-PL-2.1",
                  '"OPL-1.0",
                  'OpenSSL,
                  'OML,
                  '"OLDAP-2.8",
                  '"OLDAP-2.7",
                  '"OLDAP-2.6",
                  '"OLDAP-2.5",
                  '"OLDAP-2.4",
                  '"OLDAP-2.3",
                  '"OLDAP-2.2.2",
                  '"OLDAP-2.2.1",
                  '"OLDAP-2.2",
                  '"OLDAP-2.1",
                  '"OLDAP-2.0.1",
                  '"OLDAP-2.0",
                  '"OLDAP-1.4",
                  '"OLDAP-1.3",
                  '"OLDAP-1.2",
                  '"OLDAP-1.1",
                  'OGTSL,
                  '"OGL-UK-3.0",
                  '"OGL-UK-2.0",
                  '"OGL-UK-1.0",
                  '"OGL-Canada-2.0",
                  '"OGDL-Taiwan-1.0",
                  '"OGC-1.0",
                  '"OFL-1.1-RFN",
                  '"OFL-1.1-no-RFN",
                  '"OFL-1.1",
                  '"OFL-1.0-RFN",
                  '"OFL-1.0-no-RFN",
                  '"OFL-1.0",
                  '"ODC-By-1.0",
                  '"ODbL-1.0",
                  '"OCLC-2.0",
                  'OCCT-PL,
                  '"O-UDA-1.0",
                  'Nunit,
                  'NTP-0,
                  'NTP,
                  'NRL,
                  '"NPOSL-3.0",
                  '"NPL-1.1",
                  '"NPL-1.0",
                  'Noweb,
                  'NOSL,
                  'Nokia,
                  'NLPL,
                  '"NLOD-1.0",
                  'NIST-PD-fallback,
                  'NIST-PD,
                  'NGPL,
                  'Newsletr,
                  'NetCDF,
                  'Net-SNMP,
                  'NCSA,
                  '"NCGL-UK-2.0",
                  '"NBPL-1.0",
                  'Naumen,
                  '"NASA-1.3",
                  'NAIST-2003,
                  'Mup,
                  'Multics,
                  '"MulanPSL-2.0",
                  '"MulanPSL-1.0",
                  'MTLL,
                  'MS-RL,
                  'MS-PL,
                  '"MPL-2.0-no-copyleft-exception",
                  '"MPL-2.0",
                  '"MPL-1.1",
                  '"MPL-1.0",
                  'mpich2,
                  'Motosoto,
                  'MITNFA,
                  'MIT-open-group,
                  'MIT-Modern-Variant,
                  'MIT-feh,
                  'MIT-enna,
                  'MIT-CMU,
                  'MIT-advertising,
                  'MIT-0,
                  'MIT,
                  'MirOS,
                  'MakeIndex,
                  '"LPPL-1.3c",
                  '"LPPL-1.3a",
                  '"LPPL-1.2",
                  '"LPPL-1.1",
                  '"LPPL-1.0",
                  '"LPL-1.02",
                  '"LPL-1.0",
                  'Linux-OpenIB,
                  '"LiLiQ-Rplus-1.1",
                  '"LiLiQ-R-1.1",
                  '"LiLiQ-P-1.1",
                  'libtiff,
                  '"libselinux-1.0",
                  '"libpng-2.0",
                  'Libpng,
                  'LGPLLR,
                  '"LGPL-3.0+",
                  '"LGPL-3.0-or-later",
                  '"LGPL-3.0-only",
                  '"LGPL-3.0",
                  '"LGPL-2.1+",
                  '"LGPL-2.1-or-later",
                  '"LGPL-2.1-only",
                  '"LGPL-2.1",
                  '"LGPL-2.0+",
                  '"LGPL-2.0-or-later",
                  '"LGPL-2.0-only",
                  '"LGPL-2.0",
                  'Leptonica,
                  'Latex2e,
                  '"LAL-1.3",
                  '"LAL-1.2",
                  'JSON,
                  'JPNIC,
                  '"JasPer-2.0",
                  'ISC,
                  '"IPL-1.0",
                  'IPA,
                  '"Interbase-1.0",
                  'Intel-ACPI,
                  'Intel,
                  'Info-ZIP,
                  'Imlib2,
                  'iMatix,
                  'ImageMagick,
                  'IJG,
                  'ICU,
                  'IBM-pibs,
                  'HTMLTIDY,
                  'HPND-sell-variant,
                  'HPND,
                  '"Hippocratic-2.1",
                  'HaskellReport,
                  '"gSOAP-1.3b",
                  '"GPL-3.0+",
                  '"GPL-3.0-with-GCC-exception",
                  '"GPL-3.0-with-autoconf-exception",
                  '"GPL-3.0-or-later",
                  '"GPL-3.0-only",
                  '"GPL-3.0",
                  '"GPL-2.0+",
                  '"GPL-2.0-with-GCC-exception",
                  '"GPL-2.0-with-font-exception",
                  '"GPL-2.0-with-classpath-exception",
                  '"GPL-2.0-with-bison-exception",
                  '"GPL-2.0-with-autoconf-exception",
                  '"GPL-2.0-or-later",
                  '"GPL-2.0-only",
                  '"GPL-2.0",
                  '"GPL-1.0+",
                  '"GPL-1.0-or-later",
                  '"GPL-1.0-only",
                  '"GPL-1.0",
                  'gnuplot,
                  'GLWTPL,
                  'Glulxe,
                  'Glide,
                  'GL2PS,
                  'Giftware,
                  '"GFDL-1.3-or-later",
                  '"GFDL-1.3-only",
                  '"GFDL-1.3-no-invariants-or-later",
                  '"GFDL-1.3-no-invariants-only",
                  '"GFDL-1.3-invariants-or-later",
                  '"GFDL-1.3-invariants-only",
                  '"GFDL-1.3",
                  '"GFDL-1.2-or-later",
                  '"GFDL-1.2-only",
                  '"GFDL-1.2-no-invariants-or-later",
                  '"GFDL-1.2-no-invariants-only",
                  '"GFDL-1.2-invariants-or-later",
                  '"GFDL-1.2-invariants-only",
                  '"GFDL-1.2",
                  '"GFDL-1.1-or-later",
                  '"GFDL-1.1-only",
                  '"GFDL-1.1-no-invariants-or-later",
                  '"GFDL-1.1-no-invariants-only",
                  '"GFDL-1.1-invariants-or-later",
                  '"GFDL-1.1-invariants-only",
                  '"GFDL-1.1",
                  'GD,
                  'FTL,
                  'FSFULLR,
                  'FSFUL,
                  'FSFAP,
                  'FreeImage,
                  'FreeBSD-DOC,
                  '"Frameworx-1.0",
                  'Fair,
                  'Eurosym,
                  '"EUPL-1.2",
                  '"EUPL-1.1",
                  '"EUPL-1.0",
                  'EUDatagrid,
                  '"etalab-2.0",
                  '"ErlPL-1.1",
                  '"EPL-2.0",
                  '"EPL-1.0",
                  'EPICS,
                  'Entessa,
                  'eGenix,
                  '"EFL-2.0",
                  '"EFL-1.0",
                  '"eCos-2.0",
                  '"ECL-2.0",
                  '"ECL-1.0",
                  'dvipdfm,
                  'DSDP,
                  '"DRL-1.0",
                  'Dotseqn,
                  'DOC,
                  'diffmark,
                  '"D-FSL-1.0",
                  'curl,
                  'Cube,
                  '"CUA-OPL-1.0",
                  'CrystalStacker,
                  'Crossword,
                  '"CPOL-1.02",
                  '"CPL-1.0",
                  '"CPAL-1.0",
                  '"copyleft-next-0.3.1",
                  '"copyleft-next-0.3.0",
                  '"Condor-1.1",
                  'CNRI-Python-GPL-Compatible,
                  'CNRI-Python,
                  'CNRI-Jython,
                  'ClArtistic,
                  '"CERN-OHL-W-2.0",
                  '"CERN-OHL-S-2.0",
                  '"CERN-OHL-P-2.0",
                  '"CERN-OHL-1.2",
                  '"CERN-OHL-1.1",
                  'CECILL-C,
                  'CECILL-B,
                  '"CECILL-2.1",
                  '"CECILL-2.0",
                  '"CECILL-1.1",
                  '"CECILL-1.0",
                  '"CDLA-Sharing-1.0",
                  '"CDLA-Permissive-1.0",
                  '"CDL-1.0",
                  '"CDDL-1.1",
                  '"CDDL-1.0",
                  '"CC0-1.0",
                  'CC-PDDC,
                  '"CC-BY-SA-4.0",
                  '"CC-BY-SA-3.0-AT",
                  '"CC-BY-SA-3.0",
                  '"CC-BY-SA-2.5",
                  '"CC-BY-SA-2.1-JP",
                  '"CC-BY-SA-2.0-UK",
                  '"CC-BY-SA-2.0",
                  '"CC-BY-SA-1.0",
                  '"CC-BY-ND-4.0",
                  '"CC-BY-ND-3.0",
                  '"CC-BY-ND-2.5",
                  '"CC-BY-ND-2.0",
                  '"CC-BY-ND-1.0",
                  '"CC-BY-NC-SA-4.0",
                  '"CC-BY-NC-SA-3.0",
                  '"CC-BY-NC-SA-2.5",
                  '"CC-BY-NC-SA-2.0",
                  '"CC-BY-NC-SA-1.0",
                  '"CC-BY-NC-ND-4.0",
                  '"CC-BY-NC-ND-3.0-IGO",
                  '"CC-BY-NC-ND-3.0",
                  '"CC-BY-NC-ND-2.5",
                  '"CC-BY-NC-ND-2.0",
                  '"CC-BY-NC-ND-1.0",
                  '"CC-BY-NC-4.0",
                  '"CC-BY-NC-3.0",
                  '"CC-BY-NC-2.5",
                  '"CC-BY-NC-2.0",
                  '"CC-BY-NC-1.0",
                  '"CC-BY-4.0",
                  '"CC-BY-3.0-US",
                  '"CC-BY-3.0-AT",
                  '"CC-BY-3.0",
                  '"CC-BY-2.5",
                  '"CC-BY-2.0",
                  '"CC-BY-1.0",
                  '"CATOSL-1.1",
                  'Caldera,
                  '"CAL-1.0-Combined-Work-Exception",
                  '"CAL-1.0",
                  '"C-UDA-1.0",
                  '"bzip2-1.0.6",
                  '"bzip2-1.0.5",
                  '"BUSL-1.1",
                  '"BSL-1.0",
                  'BSD-Source-Code,
                  'BSD-Protection,
                  'BSD-4-Clause-UC,
                  'BSD-4-Clause-Shortened,
                  'BSD-4-Clause,
                  'BSD-3-Clause-Open-MPI,
                  'BSD-3-Clause-No-Nuclear-Warranty,
                  'BSD-3-Clause-No-Nuclear-License-2014,
                  'BSD-3-Clause-No-Nuclear-License,
                  'BSD-3-Clause-Modification,
                  'BSD-3-Clause-LBNL,
                  'BSD-3-Clause-Clear,
                  'BSD-3-Clause-Attribution,
                  'BSD-3-Clause,
                  'BSD-2-Clause-Views,
                  'BSD-2-Clause-Patent,
                  'BSD-2-Clause-NetBSD,
                  'BSD-2-Clause-FreeBSD,
                  'BSD-2-Clause,
                  'BSD-1-Clause,
                  'Borceux,
                  '"BlueOak-1.0.0",
                  'blessing,
                  '"BitTorrent-1.1",
                  '"BitTorrent-1.0",
                  'Beerware,
                  'Barr,
                  'Bahyph,
                  '"Artistic-2.0",
                  '"Artistic-1.0-Perl",
                  '"Artistic-1.0-cl8",
                  '"Artistic-1.0",
                  '"APSL-2.0",
                  '"APSL-1.2",
                  '"APSL-1.1",
                  '"APSL-1.0",
                  '"APL-1.0",
                  'APAFML,
                  '"Apache-2.0",
                  '"Apache-1.1",
                  '"Apache-1.0",
                  'ANTLR-PD-fallback,
                  'ANTLR-PD,
                  'AMPAS,
                  'AML,
                  'AMDPLPA,
                  'Aladdin,
                  '"AGPL-3.0-or-later",
                  '"AGPL-3.0-only",
                  '"AGPL-3.0",
                  '"AGPL-1.0-or-later",
                  '"AGPL-1.0-only",
                  '"AGPL-1.0",
                  'Afmparse,
                  '"AFL-3.0",
                  '"AFL-2.1",
                  '"AFL-2.0",
                  '"AFL-1.2",
                  '"AFL-1.1",
                  'ADSL,
                  'Adobe-Glyph,
                  'Adobe-2006,
                  'Abstyles,
                  'AAL,
                  '"0BSD"
                |]
              ],
          orcid
            | doc m%"
            Identifier for an author, see https://orcid.org.
            "%
            = predicates.contract_from_predicate definitions.predicate.orcid,
          person
            | doc m%"
            A person.
            "%
            = {
                address
                  | definitions.contract.address
                  | doc m%"
                  The person's address.
                  "%
                  | optional,
                affiliation
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The person's affilitation.
                  "%
                  | optional,
                alias
                  | definitions.contract.alias
                  | doc m%"
                  The person's alias.
                  "%
                  | optional,
                city
                  | definitions.contract.city
                  | doc m%"
                  The person's city.
                  "%
                  | optional,
                country
                  | definitions.contract.country
                  | doc m%"
                  The person's country.
                  "%
                  | optional,
                email
                  | definitions.contract.email
                  | doc m%"
                  The person's email address.
                  "%
                  | optional,
                family-names
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The person's family names.
                  "%
                  | optional,
                fax
                  | definitions.contract.fax
                  | doc m%"
                  The person's fax number.
                  "%
                  | optional,
                given-names
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The person's given names.
                  "%
                  | optional,
                name-particle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The person's name particle, e.g., a nobiliary particle or a preposition meaning 'of' or 'from' (for example 'von' in 'Alexander von Humboldt').
                  "%
                  | optional,
                name-suffix
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The person's name-suffix, e.g. 'Jr.' for Sammy Davis Jr. or 'III' for Frank Edwin Wright III.
                  "%
                  | optional,
                orcid
                  | definitions.contract.orcid
                  | doc m%"
                  The person's ORCID.
                  "%
                  | optional,
                post-code
                  | definitions.contract.post-code
                  | doc m%"
                  The person's post-code.
                  "%
                  | optional,
                region
                  | definitions.contract.region
                  | doc m%"
                  The person's region.
                  "%
                  | optional,
                tel
                  | definitions.contract.tel
                  | doc m%"
                  The person's phone number.
                  "%
                  | optional,
                website
                  | definitions.contract.url
                  | doc m%"
                  The person's website.
                  "%
                  | optional,
              },
          post-code
            | doc m%"
            A post code.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.post-code,
          reference
            | doc m%"
            A reference to a work.
            "%
            = {
                abbreviation
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The abbreviation of a work.
                  "%
                  | optional,
                abstract
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The abstract of a work.
                  "%
                  | optional,
                authors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.person,
                      definitions.predicate.entity
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The author(s) of a work.
                  "%,
                collection-doi
                  | definitions.contract.doi
                  | doc m%"
                  The DOI of a collection containing the work.
                  "%
                  | optional,
                collection-title
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The title of a collection or proceedings.
                  "%
                  | optional,
                collection-type
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The type of a collection.
                  "%
                  | optional,
                commit | definitions.contract.commit | optional,
                conference
                  | definitions.contract.entity
                  | doc m%"
                  The conference where the work was presented.
                  "%
                  | optional,
                contact
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.person,
                      definitions.predicate.entity
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The contact person, group, company, etc. for a work.
                  "%
                  | optional,
                copyright
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The copyright information pertaining to the work.
                  "%
                  | optional,
                data-type
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The data type of a data set.
                  "%
                  | optional,
                database
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The name of the database where a work was accessed/is stored.
                  "%
                  | optional,
                database-provider
                  | definitions.contract.entity
                  | doc m%"
                  The provider of the database where a work was accessed/is stored.
                  "%
                  | optional,
                date-accessed
                  | definitions.contract.date
                  | doc m%"
                  The date the work was accessed.
                  "%
                  | optional,
                date-downloaded
                  | definitions.contract.date
                  | doc m%"
                  The date the work has been downloaded.
                  "%
                  | optional,
                date-published
                  | definitions.contract.date
                  | doc m%"
                  The date the work has been published.
                  "%
                  | optional,
                date-released
                  | definitions.contract.date
                  | doc m%"
                  The date the work has been released.
                  "%
                  | optional,
                department
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The department where a work has been produced.
                  "%
                  | optional,
                doi
                  | definitions.contract.doi
                  | doc m%"
                  The DOI of the work.
                  "%
                  | optional,
                edition
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The edition of the work.
                  "%
                  | optional,
                editors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.person,
                      definitions.predicate.entity
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The editor(s) of a work.
                  "%
                  | optional,
                editors-series
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.person,
                      definitions.predicate.entity
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The editor(s) of a series in which a work has been published.
                  "%
                  | optional,
                end
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Integer,
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  The end page of the work.
                  "%
                  | optional,
                entry
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  An entry in the collection that constitutes the work.
                  "%
                  | optional,
                filename
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The name of the electronic file containing the work.
                  "%
                  | optional,
                format
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The format in which a work is represented.
                  "%
                  | optional,
                identifiers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.identifier,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The identifier(s) of the work.
                  "%
                  | optional,
                institution
                  | definitions.contract.entity
                  | doc m%"
                  The institution where a work has been produced or published.
                  "%
                  | optional,
                isbn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[0-9\\- ]{10,17}X?$"
                  ])
                  | doc m%"
                  The ISBN of the work.
                  "%
                  | optional,
                issn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^\\d{4}-\\d{3}[\\dxX]$"
                  ])
                  | doc m%"
                  The ISSN of the work.
                  "%
                  | optional,
                issue
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType '"Number"
                  ])
                  | doc m%"
                  The issue of a periodical in which a work appeared.
                  "%
                  | optional,
                issue-date
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The publication date of the issue of a periodical in which a work appeared.
                  "%
                  | optional,
                issue-title
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The name of the issue of a periodical in which the work appeared.
                  "%
                  | optional,
                journal
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The name of the journal/magazine/newspaper/periodical where the work was published.
                  "%
                  | optional,
                keywords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Keywords pertaining to the work.
                  "%
                  | optional,
                languages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.maxLength 3,
                      predicates.strings.minLength 2,
                      predicates.strings.pattern "^[a-z]{2,3}$"
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The language identifier(s) of the work according to ISO 639 language strings.
                  "%
                  | optional,
                license | definitions.contract.license | optional,
                license-url
                  | definitions.contract.url
                  | doc m%"
                  The URL of the license text under which the work is licensed (only for non-standard licenses not included in the SPDX License List).
                  "%
                  | optional,
                loc-end
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Integer,
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  The line of code in the file where the work ends.
                  "%
                  | optional,
                loc-start
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Integer,
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  The line of code in the file where the work starts.
                  "%
                  | optional,
                location
                  | definitions.contract.entity
                  | doc m%"
                  The location of the work.
                  "%
                  | optional,
                medium
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The medium of the work.
                  "%
                  | optional,
                month
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Integer,
                      predicates.numbers.maximum 12,
                      predicates.numbers.minimum 1
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [
                        "1",
                        "2",
                        "3",
                        "4",
                        "5",
                        "6",
                        "7",
                        "8",
                        "9",
                        "10",
                        "11",
                        "12"
                      ]
                    ]
                  ])
                  | doc m%"
                  The month in which a work has been published.
                  "%
                  | optional,
                nihmsid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The NIHMSID of a work.
                  "%
                  | optional,
                notes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Notes pertaining to the work.
                  "%
                  | optional,
                number
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType '"Number"
                  ])
                  | doc m%"
                  The accession number for a work.
                  "%
                  | optional,
                number-volumes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Integer,
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  The number of volumes making up the collection in which the work has been published.
                  "%
                  | optional,
                pages
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Integer,
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  The number of pages of the work.
                  "%
                  | optional,
                patent-states
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The states for which a patent is granted.
                  "%
                  | optional,
                pmcid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^PMC[0-9]{7}$"
                  ])
                  | doc m%"
                  The PMCID of a work.
                  "%
                  | optional,
                publisher
                  | definitions.contract.entity
                  | doc m%"
                  The publisher who has published the work.
                  "%
                  | optional,
                recipients
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.entity,
                      definitions.predicate.person
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The recipient(s) of a personal communication.
                  "%
                  | optional,
                repository
                  | definitions.contract.url
                  | doc m%"
                  The URL of the work in a repository (when the repository is neither a source code repository nor a build artifact repository).
                  "%
                  | optional,
                repository-artifact
                  | definitions.contract.url
                  | doc m%"
                  The URL of the work in a build artifact/binary repository.
                  "%
                  | optional,
                repository-code
                  | definitions.contract.url
                  | doc m%"
                  The URL of the work in a source code repository.
                  "%
                  | optional,
                scope
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The scope of the reference, e.g., the section of the work it adheres to.
                  "%
                  | optional,
                section
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                    predicates.isType '"Number"
                  ])
                  | doc m%"
                  The section of a work that is referenced.
                  "%
                  | optional,
                senders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.entity,
                      definitions.predicate.person
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The sender(s) of a personal communication.
                  "%
                  | optional,
                start
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Integer,
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  The start page of the work.
                  "%
                  | optional,
                status
                  | std.enum.TagOrString
                  | [|
                    'submitted,
                    'preprint,
                    'in-press,
                    'in-preparation,
                    'advance-online,
                    'abstract
                  |]
                  | doc m%"
                  The publication status of the work.
                  "%
                  | optional,
                term
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The term being referenced if the work is a dictionary or encyclopedia.
                  "%
                  | optional,
                thesis-type
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The type of the thesis that is the work.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The title of the work.
                  "%,
                translators
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.entity,
                      definitions.predicate.person
                    ]),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The translator(s) of a work.
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [|
                    'website,
                    'video,
                    'unpublished,
                    'thesis,
                    'statute,
                    'standard,
                    'sound-recording,
                    'software,
                    'software-virtual-machine,
                    'software-executable,
                    'software-container,
                    'software-code,
                    'slides,
                    'serial,
                    'report,
                    'proceedings,
                    'personal-communication,
                    'patent,
                    'pamphlet,
                    'newspaper-article,
                    'music,
                    'multimedia,
                    'map,
                    'manual,
                    'magazine-article,
                    'legal-rule,
                    'legal-case,
                    'historical-work,
                    'hearing,
                    'grant,
                    'government-document,
                    'generic,
                    'film-broadcast,
                    'encyclopedia,
                    'edited-work,
                    'dictionary,
                    'database,
                    'data,
                    'conference,
                    'conference-paper,
                    'catalogue,
                    'book,
                    'blog,
                    'bill,
                    'audiovisual,
                    'article,
                    'art
                  |]
                  | doc m%"
                  The type of the work.
                  "%,
                url
                  | definitions.contract.url
                  | doc m%"
                  The URL of the work.
                  "%
                  | optional,
                version
                  | definitions.contract.version
                  | doc m%"
                  The version of the work.
                  "%
                  | optional,
                volume
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Integer,
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  The volume of the periodical in which a work appeared.
                  "%
                  | optional,
                volume-title
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  The title of the volume in which the work appeared.
                  "%
                  | optional,
                year
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Integer,
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  The year in which a work has been published.
                  "%
                  | optional,
                year-original
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Integer,
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  The year of the original publication.
                  "%
                  | optional,
              },
          region
            | doc m%"
            A region.
            "%
            = predicates.contract_from_predicate definitions.predicate.region,
          swh-identifier
            | doc m%"
            The Software Heritage identifier (without further qualifiers such as origin, visit, anchor, path).
            "%
            = predicates.contract_from_predicate
              definitions.predicate.swh-identifier,
          tel
            | doc m%"
            A phone number.
            "%
            = predicates.contract_from_predicate definitions.predicate.tel,
          url = predicates.contract_from_predicate definitions.predicate.url,
          version = predicates.contract_from_predicate
              definitions.predicate.version,
        },
    predicate = {
          address
            | doc m%"
            An address.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          alias
            | doc m%"
            An alias.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          city
            | doc m%"
            A city
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          commit
            | doc m%"
            The (e.g., Git) commit hash or (e.g., Subversion) revision number of the work.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          country
            | doc m%"
            The ISO 3166-1 alpha-2 country code for a country.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "AD",
                  "AE",
                  "AF",
                  "AG",
                  "AI",
                  "AL",
                  "AM",
                  "AO",
                  "AQ",
                  "AR",
                  "AS",
                  "AT",
                  "AU",
                  "AW",
                  "AX",
                  "AZ",
                  "BA",
                  "BB",
                  "BD",
                  "BE",
                  "BF",
                  "BG",
                  "BH",
                  "BI",
                  "BJ",
                  "BL",
                  "BM",
                  "BN",
                  "BO",
                  "BQ",
                  "BR",
                  "BS",
                  "BT",
                  "BV",
                  "BW",
                  "BY",
                  "BZ",
                  "CA",
                  "CC",
                  "CD",
                  "CF",
                  "CG",
                  "CH",
                  "CI",
                  "CK",
                  "CL",
                  "CM",
                  "CN",
                  "CO",
                  "CR",
                  "CU",
                  "CV",
                  "CW",
                  "CX",
                  "CY",
                  "CZ",
                  "DE",
                  "DJ",
                  "DK",
                  "DM",
                  "DO",
                  "DZ",
                  "EC",
                  "EE",
                  "EG",
                  "EH",
                  "ER",
                  "ES",
                  "ET",
                  "FI",
                  "FJ",
                  "FK",
                  "FM",
                  "FO",
                  "FR",
                  "GA",
                  "GB",
                  "GD",
                  "GE",
                  "GF",
                  "GG",
                  "GH",
                  "GI",
                  "GL",
                  "GM",
                  "GN",
                  "GP",
                  "GQ",
                  "GR",
                  "GS",
                  "GT",
                  "GU",
                  "GW",
                  "GY",
                  "HK",
                  "HM",
                  "HN",
                  "HR",
                  "HT",
                  "HU",
                  "ID",
                  "IE",
                  "IL",
                  "IM",
                  "IN",
                  "IO",
                  "IQ",
                  "IR",
                  "IS",
                  "IT",
                  "JE",
                  "JM",
                  "JO",
                  "JP",
                  "KE",
                  "KG",
                  "KH",
                  "KI",
                  "KM",
                  "KN",
                  "KP",
                  "KR",
                  "KW",
                  "KY",
                  "KZ",
                  "LA",
                  "LB",
                  "LC",
                  "LI",
                  "LK",
                  "LR",
                  "LS",
                  "LT",
                  "LU",
                  "LV",
                  "LY",
                  "MA",
                  "MC",
                  "MD",
                  "ME",
                  "MF",
                  "MG",
                  "MH",
                  "MK",
                  "ML",
                  "MM",
                  "MN",
                  "MO",
                  "MP",
                  "MQ",
                  "MR",
                  "MS",
                  "MT",
                  "MU",
                  "MV",
                  "MW",
                  "MX",
                  "MY",
                  "MZ",
                  "NA",
                  "NC",
                  "NE",
                  "NF",
                  "NG",
                  "NI",
                  "NL",
                  "NO",
                  "NP",
                  "NR",
                  "NU",
                  "NZ",
                  "OM",
                  "PA",
                  "PE",
                  "PF",
                  "PG",
                  "PH",
                  "PK",
                  "PL",
                  "PM",
                  "PN",
                  "PR",
                  "PS",
                  "PT",
                  "PW",
                  "PY",
                  "QA",
                  "RE",
                  "RO",
                  "RS",
                  "RU",
                  "RW",
                  "SA",
                  "SB",
                  "SC",
                  "SD",
                  "SE",
                  "SG",
                  "SH",
                  "SI",
                  "SJ",
                  "SK",
                  "SL",
                  "SM",
                  "SN",
                  "SO",
                  "SR",
                  "SS",
                  "ST",
                  "SV",
                  "SX",
                  "SY",
                  "SZ",
                  "TC",
                  "TD",
                  "TF",
                  "TG",
                  "TH",
                  "TJ",
                  "TK",
                  "TL",
                  "TM",
                  "TN",
                  "TO",
                  "TR",
                  "TT",
                  "TV",
                  "TW",
                  "TZ",
                  "UA",
                  "UG",
                  "UM",
                  "US",
                  "UY",
                  "UZ",
                  "VA",
                  "VC",
                  "VE",
                  "VG",
                  "VI",
                  "VN",
                  "VU",
                  "WF",
                  "WS",
                  "YE",
                  "YT",
                  "ZA",
                  "ZM",
                  "ZW"
                ]
              ],
          date = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^[0-9]{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$"
              ],
          doi
            | doc m%"
            The DOI of the work (i.e., 10.5281/zenodo.1003150, not the resolver URL http://doi.org/10.5281/zenodo.1003150).
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^10\\.\\d{4,9}(\\.\\d+)?/[A-Za-z0-9:/_;\\-\\.\\(\\)\\[\\]\\\\]+$"
              ],
          email
            | doc m%"
            An email address.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[\\S]+@[\\S]+\\.[\\S]{2,}$"
              ],
          entity
            | doc m%"
            An entity, i.e., an institution, team, research group, company, conference, etc., as opposed to a single natural person.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  address = definitions.predicate.address,
                  alias = definitions.predicate.alias,
                  city = definitions.predicate.city,
                  country = definitions.predicate.country,
                  date-end = definitions.predicate.date,
                  date-start = definitions.predicate.date,
                  email = definitions.predicate.email,
                  fax = definitions.predicate.fax,
                  location = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  orcid = definitions.predicate.orcid,
                  post-code = definitions.predicate.post-code,
                  region = definitions.predicate.region,
                  tel = definitions.predicate.tel,
                  website = definitions.predicate.url,
                }
                {  }
                false
                predicates.never
              ],
          fax
            | doc m%"
            A fax number.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          identifier
            | doc m%"
            An identifier for a work.
            "%
            = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type", "value" ],
                  predicates.records.record
                  {
                    description = definitions.predicate.identifier-description,
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "doi" ]
                        ],
                    value = definitions.predicate.doi,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type", "value" ],
                  predicates.records.record
                  {
                    description = definitions.predicate.identifier-description,
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "url" ]
                        ],
                    value = definitions.predicate.url,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type", "value" ],
                  predicates.records.record
                  {
                    description = definitions.predicate.identifier-description,
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "swh" ]
                        ],
                    value = definitions.predicate.swh-identifier,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "type", "value" ],
                  predicates.records.record
                  {
                    description = definitions.predicate.identifier-description,
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "other" ]
                        ],
                    value = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          identifier-description
            | doc m%"
            A description for a specific identifier value.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          license
            | doc m%"
            An SPDX license identifier.
            "%
            = predicates.oneOf
              [
                definitions.predicate.license-enum,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.license-enum,
                  predicates.arrays.minItems 1,
                  predicates.arrays.uniqueItems
                ]
              ],
          license-enum
            | doc m%"
            SPDX license list; releaseDate=2021-05-14; source=https://raw.githubusercontent.com/spdx/license-list-data/master/json/licenses.json
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "0BSD",
                  "AAL",
                  "Abstyles",
                  "Adobe-2006",
                  "Adobe-Glyph",
                  "ADSL",
                  "AFL-1.1",
                  "AFL-1.2",
                  "AFL-2.0",
                  "AFL-2.1",
                  "AFL-3.0",
                  "Afmparse",
                  "AGPL-1.0",
                  "AGPL-1.0-only",
                  "AGPL-1.0-or-later",
                  "AGPL-3.0",
                  "AGPL-3.0-only",
                  "AGPL-3.0-or-later",
                  "Aladdin",
                  "AMDPLPA",
                  "AML",
                  "AMPAS",
                  "ANTLR-PD",
                  "ANTLR-PD-fallback",
                  "Apache-1.0",
                  "Apache-1.1",
                  "Apache-2.0",
                  "APAFML",
                  "APL-1.0",
                  "APSL-1.0",
                  "APSL-1.1",
                  "APSL-1.2",
                  "APSL-2.0",
                  "Artistic-1.0",
                  "Artistic-1.0-cl8",
                  "Artistic-1.0-Perl",
                  "Artistic-2.0",
                  "Bahyph",
                  "Barr",
                  "Beerware",
                  "BitTorrent-1.0",
                  "BitTorrent-1.1",
                  "blessing",
                  "BlueOak-1.0.0",
                  "Borceux",
                  "BSD-1-Clause",
                  "BSD-2-Clause",
                  "BSD-2-Clause-FreeBSD",
                  "BSD-2-Clause-NetBSD",
                  "BSD-2-Clause-Patent",
                  "BSD-2-Clause-Views",
                  "BSD-3-Clause",
                  "BSD-3-Clause-Attribution",
                  "BSD-3-Clause-Clear",
                  "BSD-3-Clause-LBNL",
                  "BSD-3-Clause-Modification",
                  "BSD-3-Clause-No-Nuclear-License",
                  "BSD-3-Clause-No-Nuclear-License-2014",
                  "BSD-3-Clause-No-Nuclear-Warranty",
                  "BSD-3-Clause-Open-MPI",
                  "BSD-4-Clause",
                  "BSD-4-Clause-Shortened",
                  "BSD-4-Clause-UC",
                  "BSD-Protection",
                  "BSD-Source-Code",
                  "BSL-1.0",
                  "BUSL-1.1",
                  "bzip2-1.0.5",
                  "bzip2-1.0.6",
                  "C-UDA-1.0",
                  "CAL-1.0",
                  "CAL-1.0-Combined-Work-Exception",
                  "Caldera",
                  "CATOSL-1.1",
                  "CC-BY-1.0",
                  "CC-BY-2.0",
                  "CC-BY-2.5",
                  "CC-BY-3.0",
                  "CC-BY-3.0-AT",
                  "CC-BY-3.0-US",
                  "CC-BY-4.0",
                  "CC-BY-NC-1.0",
                  "CC-BY-NC-2.0",
                  "CC-BY-NC-2.5",
                  "CC-BY-NC-3.0",
                  "CC-BY-NC-4.0",
                  "CC-BY-NC-ND-1.0",
                  "CC-BY-NC-ND-2.0",
                  "CC-BY-NC-ND-2.5",
                  "CC-BY-NC-ND-3.0",
                  "CC-BY-NC-ND-3.0-IGO",
                  "CC-BY-NC-ND-4.0",
                  "CC-BY-NC-SA-1.0",
                  "CC-BY-NC-SA-2.0",
                  "CC-BY-NC-SA-2.5",
                  "CC-BY-NC-SA-3.0",
                  "CC-BY-NC-SA-4.0",
                  "CC-BY-ND-1.0",
                  "CC-BY-ND-2.0",
                  "CC-BY-ND-2.5",
                  "CC-BY-ND-3.0",
                  "CC-BY-ND-4.0",
                  "CC-BY-SA-1.0",
                  "CC-BY-SA-2.0",
                  "CC-BY-SA-2.0-UK",
                  "CC-BY-SA-2.1-JP",
                  "CC-BY-SA-2.5",
                  "CC-BY-SA-3.0",
                  "CC-BY-SA-3.0-AT",
                  "CC-BY-SA-4.0",
                  "CC-PDDC",
                  "CC0-1.0",
                  "CDDL-1.0",
                  "CDDL-1.1",
                  "CDL-1.0",
                  "CDLA-Permissive-1.0",
                  "CDLA-Sharing-1.0",
                  "CECILL-1.0",
                  "CECILL-1.1",
                  "CECILL-2.0",
                  "CECILL-2.1",
                  "CECILL-B",
                  "CECILL-C",
                  "CERN-OHL-1.1",
                  "CERN-OHL-1.2",
                  "CERN-OHL-P-2.0",
                  "CERN-OHL-S-2.0",
                  "CERN-OHL-W-2.0",
                  "ClArtistic",
                  "CNRI-Jython",
                  "CNRI-Python",
                  "CNRI-Python-GPL-Compatible",
                  "Condor-1.1",
                  "copyleft-next-0.3.0",
                  "copyleft-next-0.3.1",
                  "CPAL-1.0",
                  "CPL-1.0",
                  "CPOL-1.02",
                  "Crossword",
                  "CrystalStacker",
                  "CUA-OPL-1.0",
                  "Cube",
                  "curl",
                  "D-FSL-1.0",
                  "diffmark",
                  "DOC",
                  "Dotseqn",
                  "DRL-1.0",
                  "DSDP",
                  "dvipdfm",
                  "ECL-1.0",
                  "ECL-2.0",
                  "eCos-2.0",
                  "EFL-1.0",
                  "EFL-2.0",
                  "eGenix",
                  "Entessa",
                  "EPICS",
                  "EPL-1.0",
                  "EPL-2.0",
                  "ErlPL-1.1",
                  "etalab-2.0",
                  "EUDatagrid",
                  "EUPL-1.0",
                  "EUPL-1.1",
                  "EUPL-1.2",
                  "Eurosym",
                  "Fair",
                  "Frameworx-1.0",
                  "FreeBSD-DOC",
                  "FreeImage",
                  "FSFAP",
                  "FSFUL",
                  "FSFULLR",
                  "FTL",
                  "GD",
                  "GFDL-1.1",
                  "GFDL-1.1-invariants-only",
                  "GFDL-1.1-invariants-or-later",
                  "GFDL-1.1-no-invariants-only",
                  "GFDL-1.1-no-invariants-or-later",
                  "GFDL-1.1-only",
                  "GFDL-1.1-or-later",
                  "GFDL-1.2",
                  "GFDL-1.2-invariants-only",
                  "GFDL-1.2-invariants-or-later",
                  "GFDL-1.2-no-invariants-only",
                  "GFDL-1.2-no-invariants-or-later",
                  "GFDL-1.2-only",
                  "GFDL-1.2-or-later",
                  "GFDL-1.3",
                  "GFDL-1.3-invariants-only",
                  "GFDL-1.3-invariants-or-later",
                  "GFDL-1.3-no-invariants-only",
                  "GFDL-1.3-no-invariants-or-later",
                  "GFDL-1.3-only",
                  "GFDL-1.3-or-later",
                  "Giftware",
                  "GL2PS",
                  "Glide",
                  "Glulxe",
                  "GLWTPL",
                  "gnuplot",
                  "GPL-1.0",
                  "GPL-1.0-only",
                  "GPL-1.0-or-later",
                  "GPL-1.0+",
                  "GPL-2.0",
                  "GPL-2.0-only",
                  "GPL-2.0-or-later",
                  "GPL-2.0-with-autoconf-exception",
                  "GPL-2.0-with-bison-exception",
                  "GPL-2.0-with-classpath-exception",
                  "GPL-2.0-with-font-exception",
                  "GPL-2.0-with-GCC-exception",
                  "GPL-2.0+",
                  "GPL-3.0",
                  "GPL-3.0-only",
                  "GPL-3.0-or-later",
                  "GPL-3.0-with-autoconf-exception",
                  "GPL-3.0-with-GCC-exception",
                  "GPL-3.0+",
                  "gSOAP-1.3b",
                  "HaskellReport",
                  "Hippocratic-2.1",
                  "HPND",
                  "HPND-sell-variant",
                  "HTMLTIDY",
                  "IBM-pibs",
                  "ICU",
                  "IJG",
                  "ImageMagick",
                  "iMatix",
                  "Imlib2",
                  "Info-ZIP",
                  "Intel",
                  "Intel-ACPI",
                  "Interbase-1.0",
                  "IPA",
                  "IPL-1.0",
                  "ISC",
                  "JasPer-2.0",
                  "JPNIC",
                  "JSON",
                  "LAL-1.2",
                  "LAL-1.3",
                  "Latex2e",
                  "Leptonica",
                  "LGPL-2.0",
                  "LGPL-2.0-only",
                  "LGPL-2.0-or-later",
                  "LGPL-2.0+",
                  "LGPL-2.1",
                  "LGPL-2.1-only",
                  "LGPL-2.1-or-later",
                  "LGPL-2.1+",
                  "LGPL-3.0",
                  "LGPL-3.0-only",
                  "LGPL-3.0-or-later",
                  "LGPL-3.0+",
                  "LGPLLR",
                  "Libpng",
                  "libpng-2.0",
                  "libselinux-1.0",
                  "libtiff",
                  "LiLiQ-P-1.1",
                  "LiLiQ-R-1.1",
                  "LiLiQ-Rplus-1.1",
                  "Linux-OpenIB",
                  "LPL-1.0",
                  "LPL-1.02",
                  "LPPL-1.0",
                  "LPPL-1.1",
                  "LPPL-1.2",
                  "LPPL-1.3a",
                  "LPPL-1.3c",
                  "MakeIndex",
                  "MirOS",
                  "MIT",
                  "MIT-0",
                  "MIT-advertising",
                  "MIT-CMU",
                  "MIT-enna",
                  "MIT-feh",
                  "MIT-Modern-Variant",
                  "MIT-open-group",
                  "MITNFA",
                  "Motosoto",
                  "mpich2",
                  "MPL-1.0",
                  "MPL-1.1",
                  "MPL-2.0",
                  "MPL-2.0-no-copyleft-exception",
                  "MS-PL",
                  "MS-RL",
                  "MTLL",
                  "MulanPSL-1.0",
                  "MulanPSL-2.0",
                  "Multics",
                  "Mup",
                  "NAIST-2003",
                  "NASA-1.3",
                  "Naumen",
                  "NBPL-1.0",
                  "NCGL-UK-2.0",
                  "NCSA",
                  "Net-SNMP",
                  "NetCDF",
                  "Newsletr",
                  "NGPL",
                  "NIST-PD",
                  "NIST-PD-fallback",
                  "NLOD-1.0",
                  "NLPL",
                  "Nokia",
                  "NOSL",
                  "Noweb",
                  "NPL-1.0",
                  "NPL-1.1",
                  "NPOSL-3.0",
                  "NRL",
                  "NTP",
                  "NTP-0",
                  "Nunit",
                  "O-UDA-1.0",
                  "OCCT-PL",
                  "OCLC-2.0",
                  "ODbL-1.0",
                  "ODC-By-1.0",
                  "OFL-1.0",
                  "OFL-1.0-no-RFN",
                  "OFL-1.0-RFN",
                  "OFL-1.1",
                  "OFL-1.1-no-RFN",
                  "OFL-1.1-RFN",
                  "OGC-1.0",
                  "OGDL-Taiwan-1.0",
                  "OGL-Canada-2.0",
                  "OGL-UK-1.0",
                  "OGL-UK-2.0",
                  "OGL-UK-3.0",
                  "OGTSL",
                  "OLDAP-1.1",
                  "OLDAP-1.2",
                  "OLDAP-1.3",
                  "OLDAP-1.4",
                  "OLDAP-2.0",
                  "OLDAP-2.0.1",
                  "OLDAP-2.1",
                  "OLDAP-2.2",
                  "OLDAP-2.2.1",
                  "OLDAP-2.2.2",
                  "OLDAP-2.3",
                  "OLDAP-2.4",
                  "OLDAP-2.5",
                  "OLDAP-2.6",
                  "OLDAP-2.7",
                  "OLDAP-2.8",
                  "OML",
                  "OpenSSL",
                  "OPL-1.0",
                  "OSET-PL-2.1",
                  "OSL-1.0",
                  "OSL-1.1",
                  "OSL-2.0",
                  "OSL-2.1",
                  "OSL-3.0",
                  "Parity-6.0.0",
                  "Parity-7.0.0",
                  "PDDL-1.0",
                  "PHP-3.0",
                  "PHP-3.01",
                  "Plexus",
                  "PolyForm-Noncommercial-1.0.0",
                  "PolyForm-Small-Business-1.0.0",
                  "PostgreSQL",
                  "PSF-2.0",
                  "psfrag",
                  "psutils",
                  "Python-2.0",
                  "Qhull",
                  "QPL-1.0",
                  "Rdisc",
                  "RHeCos-1.1",
                  "RPL-1.1",
                  "RPL-1.5",
                  "RPSL-1.0",
                  "RSA-MD",
                  "RSCPL",
                  "Ruby",
                  "SAX-PD",
                  "Saxpath",
                  "SCEA",
                  "Sendmail",
                  "Sendmail-8.23",
                  "SGI-B-1.0",
                  "SGI-B-1.1",
                  "SGI-B-2.0",
                  "SHL-0.5",
                  "SHL-0.51",
                  "SimPL-2.0",
                  "SISSL",
                  "SISSL-1.2",
                  "Sleepycat",
                  "SMLNJ",
                  "SMPPL",
                  "SNIA",
                  "Spencer-86",
                  "Spencer-94",
                  "Spencer-99",
                  "SPL-1.0",
                  "SSH-OpenSSH",
                  "SSH-short",
                  "SSPL-1.0",
                  "StandardML-NJ",
                  "SugarCRM-1.1.3",
                  "SWL",
                  "TAPR-OHL-1.0",
                  "TCL",
                  "TCP-wrappers",
                  "TMate",
                  "TORQUE-1.1",
                  "TOSL",
                  "TU-Berlin-1.0",
                  "TU-Berlin-2.0",
                  "UCL-1.0",
                  "Unicode-DFS-2015",
                  "Unicode-DFS-2016",
                  "Unicode-TOU",
                  "Unlicense",
                  "UPL-1.0",
                  "Vim",
                  "VOSTROM",
                  "VSL-1.0",
                  "W3C",
                  "W3C-19980720",
                  "W3C-20150513",
                  "Watcom-1.0",
                  "Wsuipa",
                  "WTFPL",
                  "wxWindows",
                  "X11",
                  "Xerox",
                  "XFree86-1.1",
                  "xinetd",
                  "Xnet",
                  "xpp",
                  "XSkat",
                  "YPL-1.0",
                  "YPL-1.1",
                  "Zed",
                  "Zend-2.0",
                  "Zimbra-1.3",
                  "Zimbra-1.4",
                  "Zlib",
                  "zlib-acknowledgement",
                  "ZPL-1.1",
                  "ZPL-2.0",
                  "ZPL-2.1"
                ]
              ],
          orcid
            | doc m%"
            Identifier for an author, see https://orcid.org.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "https://orcid\\.org/[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{3}[0-9X]{1}"
              ],
          person
            | doc m%"
            A person.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  address = definitions.predicate.address,
                  affiliation = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  alias = definitions.predicate.alias,
                  city = definitions.predicate.city,
                  country = definitions.predicate.country,
                  email = definitions.predicate.email,
                  family-names = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  fax = definitions.predicate.fax,
                  given-names = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  name-particle = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  name-suffix = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  orcid = definitions.predicate.orcid,
                  post-code = definitions.predicate.post-code,
                  region = definitions.predicate.region,
                  tel = definitions.predicate.tel,
                  website = definitions.predicate.url,
                }
                {  }
                false
                predicates.never
              ],
          post-code
            | doc m%"
            A post code.
            "%
            = predicates.anyOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ],
                predicates.isType '"Number"
              ],
          reference
            | doc m%"
            A reference to a work.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "authors", "title", "type" ],
                predicates.records.record
                {
                  abbreviation = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  abstract = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  authors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.person,
                          definitions.predicate.entity
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  collection-doi = definitions.predicate.doi,
                  collection-title = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  collection-type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  commit = definitions.predicate.commit,
                  conference = definitions.predicate.entity,
                  contact = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.person,
                          definitions.predicate.entity
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  copyright = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  data-type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  database = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  database-provider = definitions.predicate.entity,
                  date-accessed = definitions.predicate.date,
                  date-downloaded = definitions.predicate.date,
                  date-published = definitions.predicate.date,
                  date-released = definitions.predicate.date,
                  department = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  doi = definitions.predicate.doi,
                  edition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  editors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.person,
                          definitions.predicate.entity
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  editors-series = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.person,
                          definitions.predicate.entity
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  end = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                  entry = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  filename = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  format = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  identifiers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.identifier,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  institution = definitions.predicate.entity,
                  isbn = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^[0-9\\- ]{10,17}X?$"
                      ],
                  issn = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^\\d{4}-\\d{3}[\\dxX]$"
                      ],
                  issue = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType '"Number"
                      ],
                  issue-date = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  issue-title = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  journal = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  keywords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  languages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 3,
                          predicates.strings.minLength 2,
                          predicates.strings.pattern "^[a-z]{2,3}$"
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  license = definitions.predicate.license,
                  license-url = definitions.predicate.url,
                  loc-end = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                  loc-start = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                  location = definitions.predicate.entity,
                  medium = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  month = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.maximum 12,
                          predicates.numbers.minimum 1
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "1",
                            "2",
                            "3",
                            "4",
                            "5",
                            "6",
                            "7",
                            "8",
                            "9",
                            "10",
                            "11",
                            "12"
                          ]
                        ]
                      ],
                  nihmsid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  notes = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  number = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType '"Number"
                      ],
                  number-volumes = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                  pages = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                  patent-states = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  pmcid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^PMC[0-9]{7}$"
                      ],
                  publisher = definitions.predicate.entity,
                  recipients = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.entity,
                          definitions.predicate.person
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  repository = definitions.predicate.url,
                  repository-artifact = definitions.predicate.url,
                  repository-code = definitions.predicate.url,
                  scope = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  section = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.isType '"Number"
                      ],
                  senders = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.entity,
                          definitions.predicate.person
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  start = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                  status = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "abstract",
                          "advance-online",
                          "in-preparation",
                          "in-press",
                          "preprint",
                          "submitted"
                        ]
                      ],
                  term = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  thesis-type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  title = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  translators = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.entity,
                          definitions.predicate.person
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "art",
                          "article",
                          "audiovisual",
                          "bill",
                          "blog",
                          "book",
                          "catalogue",
                          "conference-paper",
                          "conference",
                          "data",
                          "database",
                          "dictionary",
                          "edited-work",
                          "encyclopedia",
                          "film-broadcast",
                          "generic",
                          "government-document",
                          "grant",
                          "hearing",
                          "historical-work",
                          "legal-case",
                          "legal-rule",
                          "magazine-article",
                          "manual",
                          "map",
                          "multimedia",
                          "music",
                          "newspaper-article",
                          "pamphlet",
                          "patent",
                          "personal-communication",
                          "proceedings",
                          "report",
                          "serial",
                          "slides",
                          "software-code",
                          "software-container",
                          "software-executable",
                          "software-virtual-machine",
                          "software",
                          "sound-recording",
                          "standard",
                          "statute",
                          "thesis",
                          "unpublished",
                          "video",
                          "website"
                        ]
                      ],
                  url = definitions.predicate.url,
                  version = definitions.predicate.version,
                  volume = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                  volume-title = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  year = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                  year-original = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          region
            | doc m%"
            A region.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          swh-identifier
            | doc m%"
            The Software Heritage identifier (without further qualifiers such as origin, visit, anchor, path).
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^swh:1:(snp|rel|rev|dir|cnt):[0-9a-fA-F]{40}$"
              ],
          tel
            | doc m%"
            A phone number.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          url = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^(https|http|ftp|sftp)://.+"
              ],
          version = predicates.anyOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ],
                predicates.isType '"Number"
              ],
        },
  }
in

{
  abstract
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    A description of the software or dataset.
    "%
    | optional,
  authors
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.anyOf
      [ definitions.predicate.person, definitions.predicate.entity ]),
      predicates.arrays.minItems 1,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    The author(s) of the software or dataset.
    "%,
  cff-version
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.pattern "^1\\.2\\.0$" ])
    | doc m%"
    The version of CFF used for providing the citation metadata.
    "%,
  commit | definitions.contract.commit | optional,
  contact
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.anyOf
      [ definitions.predicate.person, definitions.predicate.entity ]),
      predicates.arrays.minItems 1,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    The contact person, group, company, etc. for the software or dataset.
    "%
    | optional,
  date-released
    | definitions.contract.date
    | doc m%"
    The date the work has been released.
    "%
    | optional,
  doi | definitions.contract.doi | optional,
  identifiers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.identifier,
      predicates.arrays.minItems 1,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    The identifiers of the software or dataset.
    "%
    | optional,
  keywords
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [ predicates.isType '"String", predicates.strings.minLength 1 ]),
      predicates.arrays.minItems 1,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    Keywords that describe the work.
    "%
    | optional,
  license | definitions.contract.license | optional,
  license-url
    | definitions.contract.url
    | doc m%"
    The URL of the license text under which the software or dataset is licensed (only for non-standard licenses not included in the SPDX License List).
    "%
    | optional,
  message
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    A message to the human reader of the file to let them know what to do with the citation metadata.
    "%,
  preferred-citation
    | definitions.contract.reference
    | doc m%"
    A reference to another work that should be cited instead of the software or dataset itself.
    "%
    | optional,
  references
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.reference,
      predicates.arrays.minItems 1,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    Reference(s) to other creative works.
    "%
    | optional,
  repository
    | definitions.contract.url
    | doc m%"
    The URL of the software or dataset in a repository (when the repository is neither a source code repository nor a build artifact repository).
    "%
    | optional,
  repository-artifact
    | definitions.contract.url
    | doc m%"
    The URL of the software in a build artifact/binary repository.
    "%
    | optional,
  repository-code
    | definitions.contract.url
    | doc m%"
    The URL of the software or dataset in a source code repository.
    "%
    | optional,
  title
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The name of the software or dataset.
    "%,
  type
    | std.enum.TagOrString
    | [| 'software, 'dataset |]
    | doc m%"
    The type of the work.
    "%
    | optional,
  url
    | definitions.contract.url
    | doc m%"
    The URL of a landing page/website for the software or dataset.
    "%
    | optional,
  version
    | definitions.contract.version
    | doc m%"
    The version of the software or dataset.
    "%
    | optional,
}