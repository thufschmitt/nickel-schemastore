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
          AliasDefinition = {
                alias
                  | definitions.contract.ConjureType
                  | doc m%"
                  The Conjure type to be aliased.
                  "%,
                docs | definitions.contract.DocString | optional,
                package | String | optional,
                safety | definitions.contract.LogSafety | optional,
              },
          ArgumentDefinition = {
                docs | definitions.contract.DocString | optional,
                markers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | optional,
                param-id | String | optional,
                param-type
                  | definitions.contract.ArgumentDefinitionParamType
                  | optional,
                safety | definitions.contract.LogSafety | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | optional,
                type | definitions.contract.ConjureType,
              },
          ArgumentDefinitionParamType = predicates.contract_from_predicate
              definitions.predicate.ArgumentDefinitionParamType,
          AuthDefinition = predicates.contract_from_predicate
              definitions.predicate.AuthDefinition,
          BuiltIn = predicates.contract_from_predicate
              definitions.predicate.BuiltIn,
          ConjureType = predicates.contract_from_predicate
              definitions.predicate.ConjureType,
          ContainerType
            | doc m%"
            Container types like optional<T>, list<T>, set<T> and map<K, V> can be referenced using their lowercase names, where variables like T, K and V can be substituted for a Conjure named type, a built-in or more container types:
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ContainerType,
          DocString = String,
          EndpointDefinition = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.oneOf
                    [
                      definitions.predicate.ArgumentDefinition,
                      definitions.predicate.ConjureType
                    ])
                  ])
                  | optional,
                auth | definitions.contract.AuthDefinition | optional,
                deprecated | definitions.contract.DocString | optional,
                docs | definitions.contract.DocString | optional,
                http
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^(GET|DELETE|POST|PUT) .*$"
                  ]),
                returns | definitions.contract.ConjureType | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | optional,
              },
          EnumTypeDefinition = {
                docs | definitions.contract.DocString | optional,
                package | String | optional,
                values
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.UpperCase,
                      definitions.predicate.EnumValueDefinition
                    ]),
                    predicates.arrays.uniqueItems
                  ]),
              },
          EnumValueDefinition = {
                deprecated | definitions.contract.DocString | optional,
                docs | definitions.contract.DocString | optional,
                package | String | optional,
                value | definitions.contract.UpperCase,
              },
          ErrorCode = predicates.contract_from_predicate
              definitions.predicate.ErrorCode,
          ErrorDefinition = {
                code | definitions.contract.ErrorCode,
                docs | definitions.contract.DocString | optional,
                namespace | definitions.contract.PascalCase,
                package | String | optional,
                safe-args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.oneOf
                    [
                      definitions.predicate.FieldDefinition,
                      definitions.predicate.ConjureType
                    ])
                  ])
                  | optional,
                unsafe-args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.oneOf
                    [
                      definitions.predicate.FieldDefinition,
                      definitions.predicate.ConjureType
                    ])
                  ])
                  | optional,
              },
          ExternalImportDefinition
            | doc m%"
            References to types that are not defined within Conjure.
            "%
            = {
                java
                  | String
                  | doc m%"
                  The fully qualified Java type.
                  "%
                  | optional,
              },
          ExternalTypeDefinition = {
                base-type
                  | definitions.contract.ConjureType
                  | doc m%"
                  A base-type is provided as a hint to generators for how to handle this type when no external type reference is provided. Note that the serialization format of the base-type fallback should match the format of the imported type. If the imported type is a non-primitive JSON object, then a base-type of any should be used.
                  "%
                  | optional,
                external
                  | definitions.contract.ExternalImportDefinition
                  | doc m%"
                  The external types to reference.
                  "%
                  | optional,
              },
          FieldDefinition = {
                deprecated | definitions.contract.DocString | optional,
                docs | definitions.contract.DocString | optional,
                package | String | optional,
                safety | definitions.contract.LogSafety | optional,
                type | definitions.contract.ConjureType,
              },
          LogSafety = predicates.contract_from_predicate
              definitions.predicate.LogSafety,
          NamedTypesDefinition = {
                default-package | String | optional,
                errors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.propertyNames
                    definitions.predicate.TypeName,
                    predicates.records.record {  }
                    { "" = definitions.predicate.ErrorDefinition, }
                    false
                    predicates.never
                  ])
                  | optional,
                objects
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.propertyNames
                    definitions.predicate.TypeName,
                    predicates.records.record {  }
                    {
                      "" = predicates.oneOf
                          [
                            definitions.predicate.AliasDefinition,
                            definitions.predicate.ObjectTypeDefinition,
                            definitions.predicate.UnionTypeDefinition,
                            definitions.predicate.EnumTypeDefinition
                          ],
                    }
                    false
                    predicates.never
                  ])
                  | optional,
              },
          ObjectTypeDefinition = {
                docs | definitions.contract.DocString | optional,
                fields
                  | predicates.contract_from_predicate
                  (predicates.records.record {  } {  } true
                  (predicates.anyOf
                  [
                    definitions.predicate.FieldDefinition,
                    definitions.predicate.ConjureType
                  ])),
                package | String | optional,
              },
          PascalCase = predicates.contract_from_predicate
              definitions.predicate.PascalCase,
          PathString = String,
          ServiceDefinition = {
                base-path | definitions.contract.PathString | optional,
                default-auth | definitions.contract.AuthDefinition | optional,
                docs | definitions.contract.DocString | optional,
                endpoints
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.EndpointDefinition
                  ]),
                name | String,
                package | String,
              },
          TypeName
            | doc m%"
            Named types must be in PascalCase and be unique within a package.
            "%
            = predicates.contract_from_predicate definitions.predicate.TypeName,
          TypesDefinition = {
                conjure-imports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      "^[_a-zA-Z][_a-zA-Z0-9]*$" = predicates.isType '"String",
                    }
                    false
                    predicates.never
                  ])
                  | doc m%"
                  A map between a namespace and a relative path to a Conjure definition file.
                  "%
                  | optional,
                definitions
                  | definitions.contract.NamedTypesDefinition
                  | doc m%"
                  The types specified in this definition.
                  "%
                  | optional,
                imports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.ExternalTypeDefinition
                  ])
                  | doc m%"
                  A map between a type alias and its external definition. Type aliases MUST be in PascalCase.
                  "%
                  | optional,
              },
          UnionTypeDefinition = {
                docs | definitions.contract.DocString | optional,
                package | String | optional,
                union
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.oneOf
                    [
                      definitions.predicate.FieldDefinition,
                      definitions.predicate.ConjureType
                    ])
                  ]),
              },
          UpperCase = predicates.contract_from_predicate
              definitions.predicate.UpperCase,
        },
    predicate = {
          AliasDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "alias" ],
                predicates.records.record
                {
                  alias = definitions.predicate.ConjureType,
                  docs = definitions.predicate.DocString,
                  package = predicates.isType '"String",
                  safety = definitions.predicate.LogSafety,
                }
                {  }
                false
                predicates.never
              ],
          ArgumentDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  docs = definitions.predicate.DocString,
                  markers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  param-id = predicates.isType '"String",
                  param-type =
                    definitions.predicate.ArgumentDefinitionParamType,
                  safety = definitions.predicate.LogSafety,
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  type = definitions.predicate.ConjureType,
                }
                {  }
                false
                predicates.never
              ],
          ArgumentDefinitionParamType = predicates.enum
              [ "auto", "path", "body", "header", "query" ],
          AuthDefinition = predicates.oneOf
              [
                predicates.enum [ "none", "header" ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^cookie:[a-zA-Z0-9]+$"
                ]
              ],
          BuiltIn = predicates.enum
              [
                "any",
                "bearertoken",
                "binary",
                "boolean",
                "datetime",
                "double",
                "integer",
                "rid",
                "safelong",
                "string",
                "uuid"
              ],
          ConjureType = predicates.anyOf
              [
                definitions.predicate.TypeName,
                definitions.predicate.ContainerType,
                definitions.predicate.BuiltIn
              ],
          ContainerType
            | doc m%"
            Container types like optional<T>, list<T>, set<T> and map<K, V> can be referenced using their lowercase names, where variables like T, K and V can be substituted for a Conjure named type, a built-in or more container types:
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^(optional|list|set|map)<.*>$"
              ],
          DocString = predicates.isType '"String",
          EndpointDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "http" ],
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.oneOf
                        [
                          definitions.predicate.ArgumentDefinition,
                          definitions.predicate.ConjureType
                        ])
                      ],
                  auth = definitions.predicate.AuthDefinition,
                  deprecated = definitions.predicate.DocString,
                  docs = definitions.predicate.DocString,
                  http = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^(GET|DELETE|POST|PUT) .*$"
                      ],
                  returns = definitions.predicate.ConjureType,
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          EnumTypeDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "values" ],
                predicates.records.record
                {
                  docs = definitions.predicate.DocString,
                  package = predicates.isType '"String",
                  values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.UpperCase,
                          definitions.predicate.EnumValueDefinition
                        ]),
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          EnumValueDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "value" ],
                predicates.records.record
                {
                  deprecated = definitions.predicate.DocString,
                  docs = definitions.predicate.DocString,
                  package = predicates.isType '"String",
                  value = definitions.predicate.UpperCase,
                }
                {  }
                false
                predicates.never
              ],
          ErrorCode = predicates.enum
              [
                "PERMISSION_DENIED",
                "INVALID_ARGUMENT",
                "NOT_FOUND",
                "CONFLICT",
                "REQUEST_ENTITY_TOO_LARGE",
                "FAILED_PRECONDITION",
                "INTERNAL",
                "TIMEOUT",
                "CUSTOM_CLIENT",
                "CUSTOM_SERVER"
              ],
          ErrorDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "code", "namespace" ],
                predicates.records.record
                {
                  code = definitions.predicate.ErrorCode,
                  docs = definitions.predicate.DocString,
                  namespace = definitions.predicate.PascalCase,
                  package = predicates.isType '"String",
                  safe-args = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.oneOf
                        [
                          definitions.predicate.FieldDefinition,
                          definitions.predicate.ConjureType
                        ])
                      ],
                  unsafe-args = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.oneOf
                        [
                          definitions.predicate.FieldDefinition,
                          definitions.predicate.ConjureType
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ExternalImportDefinition
            | doc m%"
            References to types that are not defined within Conjure.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { java = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          ExternalTypeDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  base-type = definitions.predicate.ConjureType,
                  external = definitions.predicate.ExternalImportDefinition,
                }
                {  }
                false
                predicates.never
              ],
          FieldDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  deprecated = definitions.predicate.DocString,
                  docs = definitions.predicate.DocString,
                  package = predicates.isType '"String",
                  safety = definitions.predicate.LogSafety,
                  type = definitions.predicate.ConjureType,
                }
                {  }
                false
                predicates.never
              ],
          LogSafety = predicates.enum [ "safe", "unsafe", "do-not-log" ],
          NamedTypesDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  default-package = predicates.isType '"String",
                  errors = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.propertyNames
                        definitions.predicate.TypeName,
                        predicates.records.record {  }
                        { "" = definitions.predicate.ErrorDefinition, }
                        false
                        predicates.never
                      ],
                  objects = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.propertyNames
                        definitions.predicate.TypeName,
                        predicates.records.record {  }
                        {
                          "" = predicates.oneOf
                              [
                                definitions.predicate.AliasDefinition,
                                definitions.predicate.ObjectTypeDefinition,
                                definitions.predicate.UnionTypeDefinition,
                                definitions.predicate.EnumTypeDefinition
                              ],
                        }
                        false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ObjectTypeDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fields" ],
                predicates.records.record
                {
                  docs = definitions.predicate.DocString,
                  fields = predicates.records.record {  } {  } true
                      (predicates.anyOf
                      [
                        definitions.predicate.FieldDefinition,
                        definitions.predicate.ConjureType
                      ]),
                  package = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PascalCase = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[A-Z][a-z0-9]+([A-Z][a-z0-9]+)*$"
              ],
          PathString = predicates.isType '"String",
          ServiceDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "endpoints", "name", "package" ],
                predicates.records.record
                {
                  base-path = definitions.predicate.PathString,
                  default-auth = definitions.predicate.AuthDefinition,
                  docs = definitions.predicate.DocString,
                  endpoints = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.EndpointDefinition
                      ],
                  name = predicates.isType '"String",
                  package = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TypeName
            | doc m%"
            Named types must be in PascalCase and be unique within a package.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^([a-zA-Z]+[.])?[A-Z][a-z0-9]+([A-Z][a-z0-9]+)*$"
              ],
          TypesDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  conjure-imports = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^[_a-zA-Z][_a-zA-Z0-9]*$" = predicates.isType
                              '"String",
                        }
                        false
                        predicates.never
                      ],
                  definitions = definitions.predicate.NamedTypesDefinition,
                  imports = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.ExternalTypeDefinition
                      ],
                }
                {  }
                false
                predicates.never
              ],
          UnionTypeDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "union" ],
                predicates.records.record
                {
                  docs = definitions.predicate.DocString,
                  package = predicates.isType '"String",
                  union = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.oneOf
                        [
                          definitions.predicate.FieldDefinition,
                          definitions.predicate.ConjureType
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          UpperCase = predicates.strings.pattern
              "^[A-Z][A-Z0-9]*(_[A-Z0-9]+)*$",
        },
  }
in

{
  services
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      definitions.predicate.ServiceDefinition
    ])
    | optional,
  types | definitions.contract.TypesDefinition | optional,
}