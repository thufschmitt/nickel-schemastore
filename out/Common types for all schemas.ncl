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
          editor = predicates.contract_from_predicate
              definitions.predicate.editor,
          nullable-array = predicates.contract_from_predicate
              definitions.predicate.nullable-array,
          nullable-boolean = predicates.contract_from_predicate
              definitions.predicate.nullable-boolean,
          nullable-editor = predicates.contract_from_predicate
              definitions.predicate.nullable-editor,
          nullable-integer = predicates.contract_from_predicate
              definitions.predicate.nullable-integer,
          nullable-number = predicates.contract_from_predicate
              definitions.predicate.nullable-number,
          nullable-object = predicates.contract_from_predicate
              definitions.predicate.nullable-object,
          nullable-path = predicates.contract_from_predicate
              definitions.predicate.nullable-path,
          nullable-string = predicates.contract_from_predicate
              definitions.predicate.nullable-string,
          nullable-timezone = predicates.contract_from_predicate
              definitions.predicate.nullable-timezone,
          path = predicates.contract_from_predicate definitions.predicate.path,
          timezone = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  '"US/Samoa",
                  '"US/Pacific",
                  '"US/Mountain",
                  '"US/Michigan",
                  '"US/Indiana-Starke",
                  '"US/Hawaii",
                  '"US/Eastern",
                  '"US/East-Indiana",
                  '"US/Central",
                  '"US/Arizona",
                  '"US/Aleutian",
                  '"US/Alaska",
                  'Singapore,
                  'ROC,
                  'PRC,
                  'Portugal,
                  'Poland,
                  '"Pacific/Yap",
                  '"Pacific/Wallis",
                  '"Pacific/Wake",
                  '"Pacific/Truk",
                  '"Pacific/Tongatapu",
                  '"Pacific/Tarawa",
                  '"Pacific/Tahiti",
                  '"Pacific/Samoa",
                  '"Pacific/Saipan",
                  '"Pacific/Rarotonga",
                  '"Pacific/Port_Moresby",
                  '"Pacific/Ponape",
                  '"Pacific/Pohnpei",
                  '"Pacific/Pitcairn",
                  '"Pacific/Palau",
                  '"Pacific/Pago_Pago",
                  '"Pacific/Noumea",
                  '"Pacific/Norfolk",
                  '"Pacific/Niue",
                  '"Pacific/Nauru",
                  '"Pacific/Midway",
                  '"Pacific/Marquesas",
                  '"Pacific/Majuro",
                  '"Pacific/Kwajalein",
                  '"Pacific/Kosrae",
                  '"Pacific/Kiritimati",
                  '"Pacific/Kanton",
                  '"Pacific/Johnston",
                  '"Pacific/Honolulu",
                  '"Pacific/Guam",
                  '"Pacific/Guadalcanal",
                  '"Pacific/Gambier",
                  '"Pacific/Galapagos",
                  '"Pacific/Funafuti",
                  '"Pacific/Fiji",
                  '"Pacific/Fakaofo",
                  '"Pacific/Enderbury",
                  '"Pacific/Efate",
                  '"Pacific/Easter",
                  '"Pacific/Chuuk",
                  '"Pacific/Chatham",
                  '"Pacific/Bougainville",
                  '"Pacific/Auckland",
                  '"Pacific/Apia",
                  'NZ-CHAT,
                  'NZ,
                  'Navajo,
                  '"Mexico/General",
                  '"Mexico/BajaSur",
                  '"Mexico/BajaNorte",
                  'Libya,
                  'Kwajalein,
                  'Japan,
                  'Jamaica,
                  'Israel,
                  'Iran,
                  '"Indian/Reunion",
                  '"Indian/Mayotte",
                  '"Indian/Mauritius",
                  '"Indian/Maldives",
                  '"Indian/Mahe",
                  '"Indian/Kerguelen",
                  '"Indian/Comoro",
                  '"Indian/Cocos",
                  '"Indian/Christmas",
                  '"Indian/Chagos",
                  '"Indian/Antananarivo",
                  'Iceland,
                  'Hongkong,
                  'GB-Eire,
                  'GB,
                  '"Europe/Zurich",
                  '"Europe/Zaporozhye",
                  '"Europe/Zagreb",
                  '"Europe/Warsaw",
                  '"Europe/Volgograd",
                  '"Europe/Vilnius",
                  '"Europe/Vienna",
                  '"Europe/Vatican",
                  '"Europe/Vaduz",
                  '"Europe/Uzhgorod",
                  '"Europe/Ulyanovsk",
                  '"Europe/Tiraspol",
                  '"Europe/Tirane",
                  '"Europe/Tallinn",
                  '"Europe/Stockholm",
                  '"Europe/Sofia",
                  '"Europe/Skopje",
                  '"Europe/Simferopol",
                  '"Europe/Saratov",
                  '"Europe/Sarajevo",
                  '"Europe/San_Marino",
                  '"Europe/Samara",
                  '"Europe/Rome",
                  '"Europe/Riga",
                  '"Europe/Prague",
                  '"Europe/Podgorica",
                  '"Europe/Paris",
                  '"Europe/Oslo",
                  '"Europe/Nicosia",
                  '"Europe/Moscow",
                  '"Europe/Monaco",
                  '"Europe/Minsk",
                  '"Europe/Mariehamn",
                  '"Europe/Malta",
                  '"Europe/Madrid",
                  '"Europe/Luxembourg",
                  '"Europe/London",
                  '"Europe/Ljubljana",
                  '"Europe/Lisbon",
                  '"Europe/Kirov",
                  '"Europe/Kiev",
                  '"Europe/Kaliningrad",
                  '"Europe/Jersey",
                  '"Europe/Istanbul",
                  '"Europe/Isle_of_Man",
                  '"Europe/Helsinki",
                  '"Europe/Guernsey",
                  '"Europe/Gibraltar",
                  '"Europe/Dublin",
                  '"Europe/Copenhagen",
                  '"Europe/Chisinau",
                  '"Europe/Busingen",
                  '"Europe/Budapest",
                  '"Europe/Bucharest",
                  '"Europe/Brussels",
                  '"Europe/Bratislava",
                  '"Europe/Berlin",
                  '"Europe/Belgrade",
                  '"Europe/Belfast",
                  '"Europe/Athens",
                  '"Europe/Astrakhan",
                  '"Europe/Andorra",
                  '"Europe/Amsterdam",
                  '"Etc/Zulu",
                  '"Etc/UTC",
                  '"Etc/Universal",
                  '"Etc/UCT",
                  '"Etc/Greenwich",
                  '"Etc/GMT0",
                  '"Etc/GMT-9",
                  '"Etc/GMT-8",
                  '"Etc/GMT-7",
                  '"Etc/GMT-6",
                  '"Etc/GMT-5",
                  '"Etc/GMT-4",
                  '"Etc/GMT-3",
                  '"Etc/GMT-2",
                  '"Etc/GMT-14",
                  '"Etc/GMT-13",
                  '"Etc/GMT-12",
                  '"Etc/GMT-11",
                  '"Etc/GMT-10",
                  '"Etc/GMT-1",
                  '"Etc/GMT-0",
                  '"Etc/GMT+9",
                  '"Etc/GMT+8",
                  '"Etc/GMT+7",
                  '"Etc/GMT+6",
                  '"Etc/GMT+5",
                  '"Etc/GMT+4",
                  '"Etc/GMT+3",
                  '"Etc/GMT+2",
                  '"Etc/GMT+12",
                  '"Etc/GMT+11",
                  '"Etc/GMT+10",
                  '"Etc/GMT+1",
                  '"Etc/GMT+0",
                  '"Etc/GMT",
                  'Eire,
                  'Egypt,
                  'Cuba,
                  '"Chile/EasterIsland",
                  '"Chile/Continental",
                  '"Canada/Yukon",
                  '"Canada/Saskatchewan",
                  '"Canada/Pacific",
                  '"Canada/Newfoundland",
                  '"Canada/Mountain",
                  '"Canada/Eastern",
                  '"Canada/Central",
                  '"Canada/Atlantic",
                  '"Brazil/West",
                  '"Brazil/East",
                  '"Brazil/DeNoronha",
                  '"Brazil/Acre",
                  '"Australia/Yancowinna",
                  '"Australia/West",
                  '"Australia/Victoria",
                  '"Australia/Tasmania",
                  '"Australia/Sydney",
                  '"Australia/South",
                  '"Australia/Queensland",
                  '"Australia/Perth",
                  '"Australia/NSW",
                  '"Australia/North",
                  '"Australia/Melbourne",
                  '"Australia/Lord_Howe",
                  '"Australia/Lindeman",
                  '"Australia/LHI",
                  '"Australia/Hobart",
                  '"Australia/Eucla",
                  '"Australia/Darwin",
                  '"Australia/Currie",
                  '"Australia/Canberra",
                  '"Australia/Broken_Hill",
                  '"Australia/Brisbane",
                  '"Australia/Adelaide",
                  '"Australia/ACT",
                  '"Atlantic/Stanley",
                  '"Atlantic/St_Helena",
                  '"Atlantic/South_Georgia",
                  '"Atlantic/Reykjavik",
                  '"Atlantic/Madeira",
                  '"Atlantic/Jan_Mayen",
                  '"Atlantic/Faroe",
                  '"Atlantic/Faeroe",
                  '"Atlantic/Cape_Verde",
                  '"Atlantic/Canary",
                  '"Atlantic/Bermuda",
                  '"Atlantic/Azores",
                  '"Asia/Yerevan",
                  '"Asia/Yekaterinburg",
                  '"Asia/Yangon",
                  '"Asia/Yakutsk",
                  '"Asia/Vladivostok",
                  '"Asia/Vientiane",
                  '"Asia/Ust-Nera",
                  '"Asia/Urumqi",
                  '"Asia/Ulan_Bator",
                  '"Asia/Ulaanbaatar",
                  '"Asia/Ujung_Pandang",
                  '"Asia/Tomsk",
                  '"Asia/Tokyo",
                  '"Asia/Thimphu",
                  '"Asia/Thimbu",
                  '"Asia/Tel_Aviv",
                  '"Asia/Tehran",
                  '"Asia/Tbilisi",
                  '"Asia/Tashkent",
                  '"Asia/Taipei",
                  '"Asia/Srednekolymsk",
                  '"Asia/Singapore",
                  '"Asia/Shanghai",
                  '"Asia/Seoul",
                  '"Asia/Samarkand",
                  '"Asia/Sakhalin",
                  '"Asia/Saigon",
                  '"Asia/Riyadh",
                  '"Asia/Rangoon",
                  '"Asia/Qyzylorda",
                  '"Asia/Qostanay",
                  '"Asia/Qatar",
                  '"Asia/Pyongyang",
                  '"Asia/Pontianak",
                  '"Asia/Phnom_Penh",
                  '"Asia/Oral",
                  '"Asia/Omsk",
                  '"Asia/Novosibirsk",
                  '"Asia/Novokuznetsk",
                  '"Asia/Nicosia",
                  '"Asia/Muscat",
                  '"Asia/Manila",
                  '"Asia/Makassar",
                  '"Asia/Magadan",
                  '"Asia/Macau",
                  '"Asia/Macao",
                  '"Asia/Kuwait",
                  '"Asia/Kuching",
                  '"Asia/Kuala_Lumpur",
                  '"Asia/Krasnoyarsk",
                  '"Asia/Kolkata",
                  '"Asia/Khandyga",
                  '"Asia/Katmandu",
                  '"Asia/Kathmandu",
                  '"Asia/Kashgar",
                  '"Asia/Karachi",
                  '"Asia/Kamchatka",
                  '"Asia/Kabul",
                  '"Asia/Jerusalem",
                  '"Asia/Jayapura",
                  '"Asia/Jakarta",
                  '"Asia/Istanbul",
                  '"Asia/Irkutsk",
                  '"Asia/Hovd",
                  '"Asia/Hong_Kong",
                  '"Asia/Ho_Chi_Minh",
                  '"Asia/Hebron",
                  '"Asia/Harbin",
                  '"Asia/Gaza",
                  '"Asia/Famagusta",
                  '"Asia/Dushanbe",
                  '"Asia/Dubai",
                  '"Asia/Dili",
                  '"Asia/Dhaka",
                  '"Asia/Damascus",
                  '"Asia/Dacca",
                  '"Asia/Colombo",
                  '"Asia/Chungking",
                  '"Asia/Chongqing",
                  '"Asia/Choibalsan",
                  '"Asia/Chita",
                  '"Asia/Calcutta",
                  '"Asia/Brunei",
                  '"Asia/Bishkek",
                  '"Asia/Beirut",
                  '"Asia/Barnaul",
                  '"Asia/Bangkok",
                  '"Asia/Baku",
                  '"Asia/Bahrain",
                  '"Asia/Baghdad",
                  '"Asia/Atyrau",
                  '"Asia/Ashkhabad",
                  '"Asia/Ashgabat",
                  '"Asia/Aqtobe",
                  '"Asia/Aqtau",
                  '"Asia/Anadyr",
                  '"Asia/Amman",
                  '"Asia/Almaty",
                  '"Asia/Aden",
                  '"Arctic/Longyearbyen",
                  '"Antarctica/Vostok",
                  '"Antarctica/Troll",
                  '"Antarctica/Syowa",
                  '"Antarctica/South_Pole",
                  '"Antarctica/Rothera",
                  '"Antarctica/Palmer",
                  '"Antarctica/McMurdo",
                  '"Antarctica/Mawson",
                  '"Antarctica/Macquarie",
                  '"Antarctica/DumontDUrville",
                  '"Antarctica/Davis",
                  '"Antarctica/Casey",
                  '"America/Yellowknife",
                  '"America/Yakutat",
                  '"America/Winnipeg",
                  '"America/Whitehorse",
                  '"America/Virgin",
                  '"America/Vancouver",
                  '"America/Tortola",
                  '"America/Toronto",
                  '"America/Tijuana",
                  '"America/Thunder_Bay",
                  '"America/Thule",
                  '"America/Tegucigalpa",
                  '"America/Swift_Current",
                  '"America/St_Vincent",
                  '"America/St_Thomas",
                  '"America/St_Lucia",
                  '"America/St_Kitts",
                  '"America/St_Johns",
                  '"America/St_Barthelemy",
                  '"America/Sitka",
                  '"America/Shiprock",
                  '"America/Scoresbysund",
                  '"America/Sao_Paulo",
                  '"America/Santo_Domingo",
                  '"America/Santiago",
                  '"America/Santarem",
                  '"America/Santa_Isabel",
                  '"America/Rosario",
                  '"America/Rio_Branco",
                  '"America/Resolute",
                  '"America/Regina",
                  '"America/Recife",
                  '"America/Rankin_Inlet",
                  '"America/Rainy_River",
                  '"America/Punta_Arenas",
                  '"America/Puerto_Rico",
                  '"America/Porto_Velho",
                  '"America/Porto_Acre",
                  '"America/Port_of_Spain",
                  '"America/Port-au-Prince",
                  '"America/Phoenix",
                  '"America/Paramaribo",
                  '"America/Pangnirtung",
                  '"America/Panama",
                  '"America/Ojinaga",
                  '"America/Nuuk",
                  '"America/North_Dakota/New_Salem",
                  '"America/North_Dakota/Center",
                  '"America/North_Dakota/Beulah",
                  '"America/Noronha",
                  '"America/Nome",
                  '"America/Nipigon",
                  '"America/New_York",
                  '"America/Nassau",
                  '"America/Montserrat",
                  '"America/Montreal",
                  '"America/Montevideo",
                  '"America/Monterrey",
                  '"America/Moncton",
                  '"America/Miquelon",
                  '"America/Mexico_City",
                  '"America/Metlakatla",
                  '"America/Merida",
                  '"America/Menominee",
                  '"America/Mendoza",
                  '"America/Mazatlan",
                  '"America/Matamoros",
                  '"America/Martinique",
                  '"America/Marigot",
                  '"America/Manaus",
                  '"America/Managua",
                  '"America/Maceio",
                  '"America/Lower_Princes",
                  '"America/Louisville",
                  '"America/Los_Angeles",
                  '"America/Lima",
                  '"America/La_Paz",
                  '"America/Kralendijk",
                  '"America/Knox_IN",
                  '"America/Kentucky/Monticello",
                  '"America/Kentucky/Louisville",
                  '"America/Juneau",
                  '"America/Jujuy",
                  '"America/Jamaica",
                  '"America/Iqaluit",
                  '"America/Inuvik",
                  '"America/Indianapolis",
                  '"America/Indiana/Winamac",
                  '"America/Indiana/Vincennes",
                  '"America/Indiana/Vevay",
                  '"America/Indiana/Tell_City",
                  '"America/Indiana/Petersburg",
                  '"America/Indiana/Marengo",
                  '"America/Indiana/Knox",
                  '"America/Indiana/Indianapolis",
                  '"America/Hermosillo",
                  '"America/Havana",
                  '"America/Halifax",
                  '"America/Guyana",
                  '"America/Guayaquil",
                  '"America/Guatemala",
                  '"America/Guadeloupe",
                  '"America/Grenada",
                  '"America/Grand_Turk",
                  '"America/Goose_Bay",
                  '"America/Godthab",
                  '"America/Glace_Bay",
                  '"America/Fortaleza",
                  '"America/Fort_Wayne",
                  '"America/Fort_Nelson",
                  '"America/Ensenada",
                  '"America/El_Salvador",
                  '"America/Eirunepe",
                  '"America/Edmonton",
                  '"America/Dominica",
                  '"America/Detroit",
                  '"America/Denver",
                  '"America/Dawson_Creek",
                  '"America/Dawson",
                  '"America/Danmarkshavn",
                  '"America/Curacao",
                  '"America/Cuiaba",
                  '"America/Creston",
                  '"America/Costa_Rica",
                  '"America/Cordoba",
                  '"America/Coral_Harbour",
                  '"America/Chihuahua",
                  '"America/Chicago",
                  '"America/Cayman",
                  '"America/Cayenne",
                  '"America/Catamarca",
                  '"America/Caracas",
                  '"America/Cancun",
                  '"America/Campo_Grande",
                  '"America/Cambridge_Bay",
                  '"America/Buenos_Aires",
                  '"America/Boise",
                  '"America/Bogota",
                  '"America/Boa_Vista",
                  '"America/Blanc-Sablon",
                  '"America/Belize",
                  '"America/Belem",
                  '"America/Barbados",
                  '"America/Bahia_Banderas",
                  '"America/Bahia",
                  '"America/Atka",
                  '"America/Atikokan",
                  '"America/Asuncion",
                  '"America/Aruba",
                  '"America/Argentina/Ushuaia",
                  '"America/Argentina/Tucuman",
                  '"America/Argentina/San_Luis",
                  '"America/Argentina/San_Juan",
                  '"America/Argentina/Salta",
                  '"America/Argentina/Rio_Gallegos",
                  '"America/Argentina/Mendoza",
                  '"America/Argentina/La_Rioja",
                  '"America/Argentina/Jujuy",
                  '"America/Argentina/Cordoba",
                  '"America/Argentina/ComodRivadavia",
                  '"America/Argentina/Catamarca",
                  '"America/Argentina/Buenos_Aires",
                  '"America/Araguaina",
                  '"America/Antigua",
                  '"America/Anguilla",
                  '"America/Anchorage",
                  '"America/Adak",
                  '"Africa/Windhoek",
                  '"Africa/Tunis",
                  '"Africa/Tripoli",
                  '"Africa/Timbuktu",
                  '"Africa/Sao_Tome",
                  '"Africa/Porto-Novo",
                  '"Africa/Ouagadougou",
                  '"Africa/Nouakchott",
                  '"Africa/Niamey",
                  '"Africa/Ndjamena",
                  '"Africa/Nairobi",
                  '"Africa/Monrovia",
                  '"Africa/Mogadishu",
                  '"Africa/Mbabane",
                  '"Africa/Maseru",
                  '"Africa/Maputo",
                  '"Africa/Malabo",
                  '"Africa/Lusaka",
                  '"Africa/Lubumbashi",
                  '"Africa/Luanda",
                  '"Africa/Lome",
                  '"Africa/Libreville",
                  '"Africa/Lagos",
                  '"Africa/Kinshasa",
                  '"Africa/Kigali",
                  '"Africa/Khartoum",
                  '"Africa/Kampala",
                  '"Africa/Juba",
                  '"Africa/Johannesburg",
                  '"Africa/Harare",
                  '"Africa/Gaborone",
                  '"Africa/Freetown",
                  '"Africa/El_Aaiun",
                  '"Africa/Douala",
                  '"Africa/Djibouti",
                  '"Africa/Dar_es_Salaam",
                  '"Africa/Dakar",
                  '"Africa/Conakry",
                  '"Africa/Ceuta",
                  '"Africa/Casablanca",
                  '"Africa/Cairo",
                  '"Africa/Bujumbura",
                  '"Africa/Brazzaville",
                  '"Africa/Blantyre",
                  '"Africa/Bissau",
                  '"Africa/Banjul",
                  '"Africa/Bangui",
                  '"Africa/Bamako",
                  '"Africa/Asmera",
                  '"Africa/Asmara",
                  '"Africa/Algiers",
                  '"Africa/Addis_Ababa",
                  '"Africa/Accra",
                  '"Africa/Abidjan"
                |]
              ],
        },
    predicate = {
          editor = predicates.allOf
              [
                predicates.isType '"String",
                predicates.oneOf
                [
                  predicates.enum
                  [ "/usr/bin/nano", "/usr/bin/vim", "/usr/bin/emacs" ],
                  predicates.always
                ]
              ],
          nullable-array = predicates.anyOf
              [ predicates.isType '"Array", predicates.isType 'Null ],
          nullable-boolean = predicates.anyOf
              [ predicates.isType '"Bool", predicates.isType 'Null ],
          nullable-editor = predicates.oneOf
              [ definitions.predicate.editor, predicates.isType 'Null ],
          nullable-integer = predicates.anyOf
              [ predicates.isType 'Integer, predicates.isType 'Null ],
          nullable-number = predicates.anyOf
              [ predicates.isType '"Number", predicates.isType 'Null ],
          nullable-object = predicates.anyOf
              [ predicates.isType 'Record, predicates.isType 'Null ],
          nullable-path = predicates.oneOf
              [ definitions.predicate.path, predicates.isType 'Null ],
          nullable-string = predicates.anyOf
              [ predicates.isType '"String", predicates.isType 'Null ],
          nullable-timezone = predicates.oneOf
              [ definitions.predicate.timezone, predicates.isType 'Null ],
          path = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          timezone = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "Africa/Abidjan",
                  "Africa/Accra",
                  "Africa/Addis_Ababa",
                  "Africa/Algiers",
                  "Africa/Asmara",
                  "Africa/Asmera",
                  "Africa/Bamako",
                  "Africa/Bangui",
                  "Africa/Banjul",
                  "Africa/Bissau",
                  "Africa/Blantyre",
                  "Africa/Brazzaville",
                  "Africa/Bujumbura",
                  "Africa/Cairo",
                  "Africa/Casablanca",
                  "Africa/Ceuta",
                  "Africa/Conakry",
                  "Africa/Dakar",
                  "Africa/Dar_es_Salaam",
                  "Africa/Djibouti",
                  "Africa/Douala",
                  "Africa/El_Aaiun",
                  "Africa/Freetown",
                  "Africa/Gaborone",
                  "Africa/Harare",
                  "Africa/Johannesburg",
                  "Africa/Juba",
                  "Africa/Kampala",
                  "Africa/Khartoum",
                  "Africa/Kigali",
                  "Africa/Kinshasa",
                  "Africa/Lagos",
                  "Africa/Libreville",
                  "Africa/Lome",
                  "Africa/Luanda",
                  "Africa/Lubumbashi",
                  "Africa/Lusaka",
                  "Africa/Malabo",
                  "Africa/Maputo",
                  "Africa/Maseru",
                  "Africa/Mbabane",
                  "Africa/Mogadishu",
                  "Africa/Monrovia",
                  "Africa/Nairobi",
                  "Africa/Ndjamena",
                  "Africa/Niamey",
                  "Africa/Nouakchott",
                  "Africa/Ouagadougou",
                  "Africa/Porto-Novo",
                  "Africa/Sao_Tome",
                  "Africa/Timbuktu",
                  "Africa/Tripoli",
                  "Africa/Tunis",
                  "Africa/Windhoek",
                  "America/Adak",
                  "America/Anchorage",
                  "America/Anguilla",
                  "America/Antigua",
                  "America/Araguaina",
                  "America/Argentina/Buenos_Aires",
                  "America/Argentina/Catamarca",
                  "America/Argentina/ComodRivadavia",
                  "America/Argentina/Cordoba",
                  "America/Argentina/Jujuy",
                  "America/Argentina/La_Rioja",
                  "America/Argentina/Mendoza",
                  "America/Argentina/Rio_Gallegos",
                  "America/Argentina/Salta",
                  "America/Argentina/San_Juan",
                  "America/Argentina/San_Luis",
                  "America/Argentina/Tucuman",
                  "America/Argentina/Ushuaia",
                  "America/Aruba",
                  "America/Asuncion",
                  "America/Atikokan",
                  "America/Atka",
                  "America/Bahia",
                  "America/Bahia_Banderas",
                  "America/Barbados",
                  "America/Belem",
                  "America/Belize",
                  "America/Blanc-Sablon",
                  "America/Boa_Vista",
                  "America/Bogota",
                  "America/Boise",
                  "America/Buenos_Aires",
                  "America/Cambridge_Bay",
                  "America/Campo_Grande",
                  "America/Cancun",
                  "America/Caracas",
                  "America/Catamarca",
                  "America/Cayenne",
                  "America/Cayman",
                  "America/Chicago",
                  "America/Chihuahua",
                  "America/Coral_Harbour",
                  "America/Cordoba",
                  "America/Costa_Rica",
                  "America/Creston",
                  "America/Cuiaba",
                  "America/Curacao",
                  "America/Danmarkshavn",
                  "America/Dawson",
                  "America/Dawson_Creek",
                  "America/Denver",
                  "America/Detroit",
                  "America/Dominica",
                  "America/Edmonton",
                  "America/Eirunepe",
                  "America/El_Salvador",
                  "America/Ensenada",
                  "America/Fort_Nelson",
                  "America/Fort_Wayne",
                  "America/Fortaleza",
                  "America/Glace_Bay",
                  "America/Godthab",
                  "America/Goose_Bay",
                  "America/Grand_Turk",
                  "America/Grenada",
                  "America/Guadeloupe",
                  "America/Guatemala",
                  "America/Guayaquil",
                  "America/Guyana",
                  "America/Halifax",
                  "America/Havana",
                  "America/Hermosillo",
                  "America/Indiana/Indianapolis",
                  "America/Indiana/Knox",
                  "America/Indiana/Marengo",
                  "America/Indiana/Petersburg",
                  "America/Indiana/Tell_City",
                  "America/Indiana/Vevay",
                  "America/Indiana/Vincennes",
                  "America/Indiana/Winamac",
                  "America/Indianapolis",
                  "America/Inuvik",
                  "America/Iqaluit",
                  "America/Jamaica",
                  "America/Jujuy",
                  "America/Juneau",
                  "America/Kentucky/Louisville",
                  "America/Kentucky/Monticello",
                  "America/Knox_IN",
                  "America/Kralendijk",
                  "America/La_Paz",
                  "America/Lima",
                  "America/Los_Angeles",
                  "America/Louisville",
                  "America/Lower_Princes",
                  "America/Maceio",
                  "America/Managua",
                  "America/Manaus",
                  "America/Marigot",
                  "America/Martinique",
                  "America/Matamoros",
                  "America/Mazatlan",
                  "America/Mendoza",
                  "America/Menominee",
                  "America/Merida",
                  "America/Metlakatla",
                  "America/Mexico_City",
                  "America/Miquelon",
                  "America/Moncton",
                  "America/Monterrey",
                  "America/Montevideo",
                  "America/Montreal",
                  "America/Montserrat",
                  "America/Nassau",
                  "America/New_York",
                  "America/Nipigon",
                  "America/Nome",
                  "America/Noronha",
                  "America/North_Dakota/Beulah",
                  "America/North_Dakota/Center",
                  "America/North_Dakota/New_Salem",
                  "America/Nuuk",
                  "America/Ojinaga",
                  "America/Panama",
                  "America/Pangnirtung",
                  "America/Paramaribo",
                  "America/Phoenix",
                  "America/Port-au-Prince",
                  "America/Port_of_Spain",
                  "America/Porto_Acre",
                  "America/Porto_Velho",
                  "America/Puerto_Rico",
                  "America/Punta_Arenas",
                  "America/Rainy_River",
                  "America/Rankin_Inlet",
                  "America/Recife",
                  "America/Regina",
                  "America/Resolute",
                  "America/Rio_Branco",
                  "America/Rosario",
                  "America/Santa_Isabel",
                  "America/Santarem",
                  "America/Santiago",
                  "America/Santo_Domingo",
                  "America/Sao_Paulo",
                  "America/Scoresbysund",
                  "America/Shiprock",
                  "America/Sitka",
                  "America/St_Barthelemy",
                  "America/St_Johns",
                  "America/St_Kitts",
                  "America/St_Lucia",
                  "America/St_Thomas",
                  "America/St_Vincent",
                  "America/Swift_Current",
                  "America/Tegucigalpa",
                  "America/Thule",
                  "America/Thunder_Bay",
                  "America/Tijuana",
                  "America/Toronto",
                  "America/Tortola",
                  "America/Vancouver",
                  "America/Virgin",
                  "America/Whitehorse",
                  "America/Winnipeg",
                  "America/Yakutat",
                  "America/Yellowknife",
                  "Antarctica/Casey",
                  "Antarctica/Davis",
                  "Antarctica/DumontDUrville",
                  "Antarctica/Macquarie",
                  "Antarctica/Mawson",
                  "Antarctica/McMurdo",
                  "Antarctica/Palmer",
                  "Antarctica/Rothera",
                  "Antarctica/South_Pole",
                  "Antarctica/Syowa",
                  "Antarctica/Troll",
                  "Antarctica/Vostok",
                  "Arctic/Longyearbyen",
                  "Asia/Aden",
                  "Asia/Almaty",
                  "Asia/Amman",
                  "Asia/Anadyr",
                  "Asia/Aqtau",
                  "Asia/Aqtobe",
                  "Asia/Ashgabat",
                  "Asia/Ashkhabad",
                  "Asia/Atyrau",
                  "Asia/Baghdad",
                  "Asia/Bahrain",
                  "Asia/Baku",
                  "Asia/Bangkok",
                  "Asia/Barnaul",
                  "Asia/Beirut",
                  "Asia/Bishkek",
                  "Asia/Brunei",
                  "Asia/Calcutta",
                  "Asia/Chita",
                  "Asia/Choibalsan",
                  "Asia/Chongqing",
                  "Asia/Chungking",
                  "Asia/Colombo",
                  "Asia/Dacca",
                  "Asia/Damascus",
                  "Asia/Dhaka",
                  "Asia/Dili",
                  "Asia/Dubai",
                  "Asia/Dushanbe",
                  "Asia/Famagusta",
                  "Asia/Gaza",
                  "Asia/Harbin",
                  "Asia/Hebron",
                  "Asia/Ho_Chi_Minh",
                  "Asia/Hong_Kong",
                  "Asia/Hovd",
                  "Asia/Irkutsk",
                  "Asia/Istanbul",
                  "Asia/Jakarta",
                  "Asia/Jayapura",
                  "Asia/Jerusalem",
                  "Asia/Kabul",
                  "Asia/Kamchatka",
                  "Asia/Karachi",
                  "Asia/Kashgar",
                  "Asia/Kathmandu",
                  "Asia/Katmandu",
                  "Asia/Khandyga",
                  "Asia/Kolkata",
                  "Asia/Krasnoyarsk",
                  "Asia/Kuala_Lumpur",
                  "Asia/Kuching",
                  "Asia/Kuwait",
                  "Asia/Macao",
                  "Asia/Macau",
                  "Asia/Magadan",
                  "Asia/Makassar",
                  "Asia/Manila",
                  "Asia/Muscat",
                  "Asia/Nicosia",
                  "Asia/Novokuznetsk",
                  "Asia/Novosibirsk",
                  "Asia/Omsk",
                  "Asia/Oral",
                  "Asia/Phnom_Penh",
                  "Asia/Pontianak",
                  "Asia/Pyongyang",
                  "Asia/Qatar",
                  "Asia/Qostanay",
                  "Asia/Qyzylorda",
                  "Asia/Rangoon",
                  "Asia/Riyadh",
                  "Asia/Saigon",
                  "Asia/Sakhalin",
                  "Asia/Samarkand",
                  "Asia/Seoul",
                  "Asia/Shanghai",
                  "Asia/Singapore",
                  "Asia/Srednekolymsk",
                  "Asia/Taipei",
                  "Asia/Tashkent",
                  "Asia/Tbilisi",
                  "Asia/Tehran",
                  "Asia/Tel_Aviv",
                  "Asia/Thimbu",
                  "Asia/Thimphu",
                  "Asia/Tokyo",
                  "Asia/Tomsk",
                  "Asia/Ujung_Pandang",
                  "Asia/Ulaanbaatar",
                  "Asia/Ulan_Bator",
                  "Asia/Urumqi",
                  "Asia/Ust-Nera",
                  "Asia/Vientiane",
                  "Asia/Vladivostok",
                  "Asia/Yakutsk",
                  "Asia/Yangon",
                  "Asia/Yekaterinburg",
                  "Asia/Yerevan",
                  "Atlantic/Azores",
                  "Atlantic/Bermuda",
                  "Atlantic/Canary",
                  "Atlantic/Cape_Verde",
                  "Atlantic/Faeroe",
                  "Atlantic/Faroe",
                  "Atlantic/Jan_Mayen",
                  "Atlantic/Madeira",
                  "Atlantic/Reykjavik",
                  "Atlantic/South_Georgia",
                  "Atlantic/St_Helena",
                  "Atlantic/Stanley",
                  "Australia/ACT",
                  "Australia/Adelaide",
                  "Australia/Brisbane",
                  "Australia/Broken_Hill",
                  "Australia/Canberra",
                  "Australia/Currie",
                  "Australia/Darwin",
                  "Australia/Eucla",
                  "Australia/Hobart",
                  "Australia/LHI",
                  "Australia/Lindeman",
                  "Australia/Lord_Howe",
                  "Australia/Melbourne",
                  "Australia/North",
                  "Australia/NSW",
                  "Australia/Perth",
                  "Australia/Queensland",
                  "Australia/South",
                  "Australia/Sydney",
                  "Australia/Tasmania",
                  "Australia/Victoria",
                  "Australia/West",
                  "Australia/Yancowinna",
                  "Brazil/Acre",
                  "Brazil/DeNoronha",
                  "Brazil/East",
                  "Brazil/West",
                  "Canada/Atlantic",
                  "Canada/Central",
                  "Canada/Eastern",
                  "Canada/Mountain",
                  "Canada/Newfoundland",
                  "Canada/Pacific",
                  "Canada/Saskatchewan",
                  "Canada/Yukon",
                  "Chile/Continental",
                  "Chile/EasterIsland",
                  "Cuba",
                  "Egypt",
                  "Eire",
                  "Etc/GMT",
                  "Etc/GMT+0",
                  "Etc/GMT+1",
                  "Etc/GMT+10",
                  "Etc/GMT+11",
                  "Etc/GMT+12",
                  "Etc/GMT+2",
                  "Etc/GMT+3",
                  "Etc/GMT+4",
                  "Etc/GMT+5",
                  "Etc/GMT+6",
                  "Etc/GMT+7",
                  "Etc/GMT+8",
                  "Etc/GMT+9",
                  "Etc/GMT-0",
                  "Etc/GMT-1",
                  "Etc/GMT-10",
                  "Etc/GMT-11",
                  "Etc/GMT-12",
                  "Etc/GMT-13",
                  "Etc/GMT-14",
                  "Etc/GMT-2",
                  "Etc/GMT-3",
                  "Etc/GMT-4",
                  "Etc/GMT-5",
                  "Etc/GMT-6",
                  "Etc/GMT-7",
                  "Etc/GMT-8",
                  "Etc/GMT-9",
                  "Etc/GMT0",
                  "Etc/Greenwich",
                  "Etc/UCT",
                  "Etc/Universal",
                  "Etc/UTC",
                  "Etc/Zulu",
                  "Europe/Amsterdam",
                  "Europe/Andorra",
                  "Europe/Astrakhan",
                  "Europe/Athens",
                  "Europe/Belfast",
                  "Europe/Belgrade",
                  "Europe/Berlin",
                  "Europe/Bratislava",
                  "Europe/Brussels",
                  "Europe/Bucharest",
                  "Europe/Budapest",
                  "Europe/Busingen",
                  "Europe/Chisinau",
                  "Europe/Copenhagen",
                  "Europe/Dublin",
                  "Europe/Gibraltar",
                  "Europe/Guernsey",
                  "Europe/Helsinki",
                  "Europe/Isle_of_Man",
                  "Europe/Istanbul",
                  "Europe/Jersey",
                  "Europe/Kaliningrad",
                  "Europe/Kiev",
                  "Europe/Kirov",
                  "Europe/Lisbon",
                  "Europe/Ljubljana",
                  "Europe/London",
                  "Europe/Luxembourg",
                  "Europe/Madrid",
                  "Europe/Malta",
                  "Europe/Mariehamn",
                  "Europe/Minsk",
                  "Europe/Monaco",
                  "Europe/Moscow",
                  "Europe/Nicosia",
                  "Europe/Oslo",
                  "Europe/Paris",
                  "Europe/Podgorica",
                  "Europe/Prague",
                  "Europe/Riga",
                  "Europe/Rome",
                  "Europe/Samara",
                  "Europe/San_Marino",
                  "Europe/Sarajevo",
                  "Europe/Saratov",
                  "Europe/Simferopol",
                  "Europe/Skopje",
                  "Europe/Sofia",
                  "Europe/Stockholm",
                  "Europe/Tallinn",
                  "Europe/Tirane",
                  "Europe/Tiraspol",
                  "Europe/Ulyanovsk",
                  "Europe/Uzhgorod",
                  "Europe/Vaduz",
                  "Europe/Vatican",
                  "Europe/Vienna",
                  "Europe/Vilnius",
                  "Europe/Volgograd",
                  "Europe/Warsaw",
                  "Europe/Zagreb",
                  "Europe/Zaporozhye",
                  "Europe/Zurich",
                  "GB",
                  "GB-Eire",
                  "Hongkong",
                  "Iceland",
                  "Indian/Antananarivo",
                  "Indian/Chagos",
                  "Indian/Christmas",
                  "Indian/Cocos",
                  "Indian/Comoro",
                  "Indian/Kerguelen",
                  "Indian/Mahe",
                  "Indian/Maldives",
                  "Indian/Mauritius",
                  "Indian/Mayotte",
                  "Indian/Reunion",
                  "Iran",
                  "Israel",
                  "Jamaica",
                  "Japan",
                  "Kwajalein",
                  "Libya",
                  "Mexico/BajaNorte",
                  "Mexico/BajaSur",
                  "Mexico/General",
                  "Navajo",
                  "NZ",
                  "NZ-CHAT",
                  "Pacific/Apia",
                  "Pacific/Auckland",
                  "Pacific/Bougainville",
                  "Pacific/Chatham",
                  "Pacific/Chuuk",
                  "Pacific/Easter",
                  "Pacific/Efate",
                  "Pacific/Enderbury",
                  "Pacific/Fakaofo",
                  "Pacific/Fiji",
                  "Pacific/Funafuti",
                  "Pacific/Galapagos",
                  "Pacific/Gambier",
                  "Pacific/Guadalcanal",
                  "Pacific/Guam",
                  "Pacific/Honolulu",
                  "Pacific/Johnston",
                  "Pacific/Kanton",
                  "Pacific/Kiritimati",
                  "Pacific/Kosrae",
                  "Pacific/Kwajalein",
                  "Pacific/Majuro",
                  "Pacific/Marquesas",
                  "Pacific/Midway",
                  "Pacific/Nauru",
                  "Pacific/Niue",
                  "Pacific/Norfolk",
                  "Pacific/Noumea",
                  "Pacific/Pago_Pago",
                  "Pacific/Palau",
                  "Pacific/Pitcairn",
                  "Pacific/Pohnpei",
                  "Pacific/Ponape",
                  "Pacific/Port_Moresby",
                  "Pacific/Rarotonga",
                  "Pacific/Saipan",
                  "Pacific/Samoa",
                  "Pacific/Tahiti",
                  "Pacific/Tarawa",
                  "Pacific/Tongatapu",
                  "Pacific/Truk",
                  "Pacific/Wake",
                  "Pacific/Wallis",
                  "Pacific/Yap",
                  "Poland",
                  "Portugal",
                  "PRC",
                  "ROC",
                  "Singapore",
                  "US/Alaska",
                  "US/Aleutian",
                  "US/Arizona",
                  "US/Central",
                  "US/East-Indiana",
                  "US/Eastern",
                  "US/Hawaii",
                  "US/Indiana-Starke",
                  "US/Michigan",
                  "US/Mountain",
                  "US/Pacific",
                  "US/Samoa"
                ]
              ],
        },
  }
in

predicates.contract_from_predicate predicates.always