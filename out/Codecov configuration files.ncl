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
          "default" = predicates.contract_from_predicate
              definitions.predicate."default",
          flag = {
                assume
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Bool", predicates.isType '"Array" ],
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                ignore
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                joined | Bool | optional,
                paths
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                required | Bool | optional,
                ..
              },
          layout = predicates.contract_from_predicate
              definitions.predicate.layout,
          notification = {
                base
                  | predicates.contract_from_predicate
                  (predicates.enum [ "parent", "pr", "auto" ])
                  | optional,
                branches | String | optional,
                flags | String | optional,
                message | String | optional,
                only_pulls | Bool | optional,
                paths
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                threshold | String | optional,
                url | String | optional,
                ..
              },
        },
    predicate = {
          "default" = predicates.records.record
              {
                base = predicates.isType '"String",
                branches = predicates.isType '"Array",
                flag_coverage_not_uploaded_behavior = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "include", "exclude", "pass" ]
                    ],
                flags = predicates.isType '"Array",
                if_ci_failed = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "error", "success" ]
                    ],
                if_not_found = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "failure", "success" ]
                    ],
                informational = predicates.isType '"Bool",
                only_pulls = predicates.isType '"Bool",
                paths = predicates.anyOf
                    [ predicates.isType '"Array", predicates.isType '"String" ],
                target = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                      predicates.strings.pattern
                      "^(([0-9]+\\.?[0-9]*|\\.[0-9]+)%?|auto)$"
                    ],
                threshold = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "^([0-9]+\\.?[0-9]*|\\.[0-9]+)%?$"
                    ],
              }
              {  }
              true
              predicates.always,
          flag = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  assume = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Bool",
                          predicates.isType '"Array"
                        ],
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ignore = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  joined = predicates.isType '"Bool",
                  paths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  required = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          layout = predicates.anyOf
              [
                predicates.always,
                predicates.enum
                [
                  "header",
                  "footer",
                  "diff",
                  "file",
                  "files",
                  "flag",
                  "flags",
                  "reach",
                  "sunburst",
                  "uncovered"
                ]
              ],
          notification = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  base = predicates.enum [ "parent", "pr", "auto" ],
                  branches = predicates.isType '"String",
                  flags = predicates.isType '"String",
                  message = predicates.isType '"String",
                  only_pulls = predicates.isType '"Bool",
                  paths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  threshold = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  codecov
    | {
      allow_pseudo_compare | Bool | optional,
      archive | { uploads | Bool | optional, .. } | optional,
      assume_all_flags | Bool | optional,
      bot
        | String
        | doc m%"
        Team bot. See https://docs.codecov.io/docs/team-bot for details
        "%
        | optional,
      branch | String | optional,
      ci
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        Detecting CI services. See https://docs.codecov.io/docs/detecting-ci-services for details.
        "%
        | optional,
      disable_default_path_fixes | Bool | optional,
      max_report_age
        | predicates.contract_from_predicate
        (predicates.anyOf
        [
          predicates.isType '"String",
          predicates.isType 'Integer,
          predicates.isType '"Bool"
        ])
        | optional,
      notify
        | {
          after_n_builds | std.number.Integer | optional,
          countdown | std.number.Integer | optional,
          delay | std.number.Integer | optional,
          wait_for_ci | Bool | optional,
          ..
        }
        | optional,
      require_ci_to_pass | Bool | optional,
      slug | String | optional,
      strict_yaml_branch | String | optional,
      ui
        | {
          hide_complexity
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"Array" ],
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | optional,
          hide_contextual | Bool | optional,
          hide_density
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType '"Array" ],
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | optional,
          hide_search | Bool | optional,
          hide_sunburst | Bool | optional,
          ..
        }
        | optional,
      url | String | optional,
      ..
    }
    | doc m%"
    See https://docs.codecov.io/docs/codecov-yaml for details
    "%
    | optional,
  comment
    | predicates.contract_from_predicate
    (predicates.oneOf
    [
      predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          behavior = predicates.enum [ "default", "once", "new", "spammy" ],
          branches = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          flags = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.flag
              ],
          layout = definitions.predicate.layout,
          paths = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          require_base = predicates.isType '"Bool",
          require_changes = predicates.isType '"Bool",
          require_head = predicates.isType '"Bool",
        }
        {  }
        true
        predicates.always
      ],
      predicates.const false
    ])
    | doc m%"
    Pull request comments. See https://docs.codecov.io/docs/pull-request-comments for details.
    "%
    | optional,
  coverage
    | {
      notify
        | {
          email
            | {
              "+to"
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ])
                | optional,
              base
                | predicates.contract_from_predicate
                (predicates.enum [ "parent", "pr", "auto" ])
                | optional,
              branches | String | optional,
              flags | String | optional,
              layout | definitions.contract.layout | optional,
              message | String | optional,
              only_pulls | Bool | optional,
              paths
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ])
                | optional,
              threshold | String | optional,
              url | String | optional,
              ..
            }
            | optional,
          gitter
            | {
              base
                | predicates.contract_from_predicate
                (predicates.enum [ "parent", "pr", "auto" ])
                | optional,
              branches | String | optional,
              flags | String | optional,
              message | String | optional,
              only_pulls | Bool | optional,
              paths
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ])
                | optional,
              threshold | String | optional,
              url | String | optional,
              ..
            }
            | doc m%"
            Gitter. See https://docs.codecov.io/docs/notifications#section-gitter for details.
            "%
            | optional,
          hipchat
            | {
              base
                | predicates.contract_from_predicate
                (predicates.enum [ "parent", "pr", "auto" ])
                | optional,
              branches | String | optional,
              card | Bool | optional,
              flags | String | optional,
              message | String | optional,
              notify | Bool | optional,
              only_pulls | Bool | optional,
              paths
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ])
                | optional,
              threshold | String | optional,
              url | String | optional,
              ..
            }
            | doc m%"
            Hipchat. See https://docs.codecov.io/docs/notifications#section-hipchat for details.
            "%
            | optional,
          irc
            | {
              base
                | predicates.contract_from_predicate
                (predicates.enum [ "parent", "pr", "auto" ])
                | optional,
              branches | String | optional,
              channel | String | optional,
              flags | String | optional,
              message | String | optional,
              nickserv_password | String | optional,
              notice | Bool | optional,
              only_pulls | Bool | optional,
              password | String | optional,
              paths
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ])
                | optional,
              threshold | String | optional,
              url | String | optional,
              ..
            }
            | optional,
          slack
            | {
              attachments | definitions.contract.layout | optional,
              base
                | predicates.contract_from_predicate
                (predicates.enum [ "parent", "pr", "auto" ])
                | optional,
              branches | String | optional,
              flags | String | optional,
              message | String | optional,
              only_pulls | Bool | optional,
              paths
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ])
                | optional,
              threshold | String | optional,
              url | String | optional,
              ..
            }
            | doc m%"
            Slack. See https://docs.codecov.io/docs/notifications#section-slack for details.
            "%
            | optional,
          webhook
            | {
              base
                | predicates.contract_from_predicate
                (predicates.enum [ "parent", "pr", "auto" ])
                | optional,
              branches | String | optional,
              flags | String | optional,
              message | String | optional,
              only_pulls | Bool | optional,
              paths
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ])
                | optional,
              threshold | String | optional,
              url | String | optional,
              ..
            }
            | optional,
          ..
        }
        | doc m%"
        Notifications. See https://docs.codecov.io/docs/notifications for details.
        "%
        | optional,
      precision
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Integer,
          predicates.numbers.maximum 5,
          predicates.numbers.minimum 0
        ])
        | optional,
      range | String | optional,
      round
        | predicates.contract_from_predicate
        (predicates.enum [ "down", "up", "nearest" ])
        | optional,
      status
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Bool", predicates.isType 'Record ],
          predicates.records.record
          {
            changes = predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType 'Record, predicates.isType '"Bool" ],
                  definitions.predicate."default"
                ],
            default_rules = predicates.isType 'Record,
            patch = predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate."default"
                  ],
                  predicates.allOf
                  [ predicates.isType '"String", predicates.enum [ "off" ] ],
                  predicates.isType '"Bool"
                ],
            project = predicates.records.record
                {
                  "default" = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Record,
                          predicates.isType '"Bool"
                        ],
                        definitions.predicate."default"
                      ],
                }
                {  }
                true
                (predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType 'Record, predicates.isType '"Bool" ],
                  definitions.predicate."default"
                ]),
          }
          {  }
          false
          predicates.never
        ])
        | doc m%"
        Commit status. See https://docs.codecov.io/docs/commit-status for details.
        "%
        | optional,
      ..
    }
    | doc m%"
    Coverage configuration. See https://docs.codecov.io/docs/coverage-configuration for details.
    "%
    | optional,
  fixes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Fixing paths. See https://docs.codecov.io/docs/fixing-paths for details.
    "%
    | optional,
  flags
    | predicates.contract_from_predicate
    (predicates.oneOf
    [
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf definitions.predicate.flag
      ],
      predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record {  } {  } true definitions.predicate.flag
      ]
    ])
    | doc m%"
    Flags. See https://docs.codecov.io/docs/flags for details.
    "%
    | optional,
  github_checks
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record { annotations = predicates.isType '"Bool", }
        {  }
        true
        predicates.always
      ],
      predicates.isType '"Bool",
      predicates.allOf
      [ predicates.isType '"String", predicates.enum [ "off" ] ]
    ])
    | doc m%"
    GitHub Checks. See https://docs.codecov.com/docs/github-checks for details.
    "%
    | optional,
  ignore
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Ignoring paths. see https://docs.codecov.io/docs/ignoring-paths for details.
    "%
    | optional,
  ..
}