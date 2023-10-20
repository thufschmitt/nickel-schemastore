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
          certificate-authority-config
            | doc m%"
            Certificate Authority
            "%
            = predicates.contract_from_predicate
              definitions.predicate.certificate-authority-config,
          certificate-config
            | doc m%"
            Node's Certificate configuration option
            "%
            = predicates.contract_from_predicate
              definitions.predicate.certificate-config,
          config-config
            | doc m%"
            containerlab config engine parameters
            "%
            = {
                vars
                  | predicates.contract_from_predicate
                  (predicates.isType 'Record)
                  | doc m%"
                  config variables passed to config engine
                  "%
                  | optional,
                ..
              },
          dns-config
            | doc m%"
            Node's DNS configuration option
            "%
            = predicates.contract_from_predicate
              definitions.predicate.dns-config,
          extras-config
            | doc m%"
            node's extra configurations
            "%
            = {
                mysocket-proxy
                  | String
                  | doc m%"
                  http/s proxy to be used by mysocketctl
                  "%
                  | optional,
                srl-agents
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  list of SR Linux agent's config files to be copied to the NOS filesystem
                  "%
                  | optional,
                ..
              },
          link-config
            | doc m%"
            link configuration container
            "%
            = predicates.contract_from_predicate
              definitions.predicate.link-config,
          node-config
            | doc m%"
            topology node configuration container
            "%
            = predicates.contract_from_predicate
              definitions.predicate.node-config,
        },
    predicate = {
          certificate-authority-config
            | doc m%"
            Certificate Authority
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.not
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.records.required [ "key-size" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                      predicates.allOf
                      [
                        predicates.records.required [ "validity-duration" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]
                    ]),
                    predicates.records.required [ "cert", "key" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.records.required [ "key-size" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                      predicates.allOf
                      [
                        predicates.records.required [ "validity-duration" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]
                    ],
                    predicates.not
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.records.required [ "cert" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                      predicates.allOf
                      [
                        predicates.records.required [ "key" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]
                    ])
                  ]
                ],
                predicates.records.record
                {
                  cert = predicates.isType '"String",
                  key = predicates.isType '"String",
                  key-size = predicates.isType 'Integer,
                  validity-duration = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          certificate-config
            | doc m%"
            Node's Certificate configuration option
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record { issue = predicates.always, } {  }
                true
                predicates.always
              ],
          config-config
            | doc m%"
            containerlab config engine parameters
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record { vars = predicates.isType 'Record, }
                {  }
                true
                predicates.always
              ],
          dns-config
            | doc m%"
            Node's DNS configuration option
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  options = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  search = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  servers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                true
                predicates.always
              ],
          extras-config
            | doc m%"
            node's extra configurations
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  mysocket-proxy = predicates.isType '"String",
                  srl-agents = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                true
                predicates.always
              ],
          link-config
            | doc m%"
            link configuration container
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  endpoints = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^\\S+:\\S+$"
                        ]),
                        predicates.arrays.minItems 2,
                        predicates.arrays.uniqueItems
                      ],
                  vars = predicates.isType 'Record,
                }
                {  }
                true
                predicates.always
              ],
          node-config
            | doc m%"
            topology node configuration container
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  predicates.records.record
                  { type = predicates.isType '"String", }
                  {  }
                  true
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.allOf
                  [
                    predicates.records.required [ "kind" ],
                    predicates.records.record
                    { kind = predicates.strings.pattern "(srl|nokia_srlinux)", }
                    {  }
                    true
                    predicates.always
                  ])
                  (predicates.records.record
                  {
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "ixrd1",
                            "ixrd2",
                            "ixrd3",
                            "ixrd2l",
                            "ixrd3l",
                            "ixrd4",
                            "ixrd5",
                            "ixrd5t",
                            "ixrh2",
                            "ixrh3",
                            "ixrh4",
                            "ixr6",
                            "ixr6e",
                            "ixr10",
                            "ixr10e",
                            "sxr1x44s",
                            "sxr1d32d"
                          ]
                        ],
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.allOf
                  [
                    predicates.records.required [ "kind" ],
                    predicates.records.record
                    {
                      kind = predicates.strings.pattern
                          "(vr-sros|vr-nokia_sros)",
                    }
                    {  }
                    true
                    predicates.always
                  ])
                  (predicates.records.record
                  {
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.anyOf
                          [
                            predicates.enum
                            [
                              "sr-1",
                              "sr-1e",
                              "sr-1e-sec",
                              "sr-1s",
                              "sr-1s-macsec",
                              "sr-2s",
                              "sr-7s",
                              "sr-7s-fp4",
                              "sr-14s",
                              "sr-a4",
                              "ixr-e-small",
                              "ixr-e-big",
                              "ixr-e2",
                              "ixr-ec",
                              "ixr-r6",
                              "ixr-s"
                            ],
                            predicates.strings.pattern "cp:.+"
                          ]
                        ],
                  }
                  {  }
                  true
                  predicates.always)
                  predicates.always
                ],
                predicates.records.record
                {
                  SANs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  auto-remove = predicates.isType '"Bool",
                  binds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  certificate = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.certificate-config
                      ],
                  cmd = predicates.isType '"String",
                  config = definitions.predicate.config-config,
                  cpu = predicates.isType 'Integer,
                  cpu-set = predicates.isType '"String",
                  dns = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.dns-config
                      ],
                  enforce-startup-config = predicates.isType '"Bool",
                  entrypoint = predicates.isType '"String",
                  env = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".+" = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.arrays.minItems 1
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"Number",
                                  predicates.arrays.minItems 1
                                ]
                              ],
                        }
                        true
                        predicates.always
                      ],
                  exec = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 1
                      ],
                  extras = predicates.allOf
                      [
                        predicates.isType 'Record,
                        definitions.predicate.extras-config
                      ],
                  group = predicates.isType '"String",
                  image = predicates.isType '"String",
                  image-pull-policy = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "always",
                          "Always",
                          "never",
                          "Never",
                          "ifnotpresent",
                          "IfNotPresent"
                        ]
                      ],
                  kernel = predicates.isType '"String",
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "srl",
                          "nokia_srlinux",
                          "ceos",
                          "arista_ceos",
                          "crpd",
                          "juniper_crpd",
                          "sonic-vs",
                          "vr-sros",
                          "vr-nokia_sros",
                          "vr-vmx",
                          "vr-juniper_vmx",
                          "vr-vqfx",
                          "vr-juniper_vqfx",
                          "vr-vsrx",
                          "vr-juniper_vsrx",
                          "vr-vjunosswitch",
                          "vr-juniper_vjunosswitch",
                          "vr-xrv",
                          "vr-cisco_xrv",
                          "vr-xrv9k",
                          "vr-cisco_xrv9k",
                          "vr-nxos",
                          "vr-cisco_nxos",
                          "vr-veos",
                          "vr-arista_veos",
                          "vr-csr",
                          "vr-cisco_csr",
                          "vr-pan",
                          "vr-paloalto_panos",
                          "vr-ros",
                          "vr-mikrotik_ros",
                          "vr-n9kv",
                          "vr-cisco_n9kv",
                          "vr-ftosv",
                          "vr-dell_ftosv",
                          "vr-aoscx",
                          "vr-aruba_aoscx",
                          "linux",
                          "bridge",
                          "ovs-bridge",
                          "border0",
                          "host",
                          "keysight_ixia-c-one",
                          "ipinfusion_ocnos",
                          "checkpoint_cloudguard",
                          "ext-container",
                          "xrd",
                          "rare",
                          "cisco_xrd",
                          "c8000",
                          "cisco_c8000",
                          "cvx",
                          "cumulus_cvx"
                        ]
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".+" = predicates.anyOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.arrays.minItems 1
                                ],
                                predicates.allOf
                                [
                                  predicates.isType '"Number",
                                  predicates.arrays.minItems 1
                                ]
                              ],
                        }
                        true
                        predicates.always
                      ],
                  license = predicates.isType '"String",
                  memory = predicates.isType '"String",
                  mgmt-ipv4 = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(%[\\p{N}\\p{L}]+)?$"
                      ],
                  mgmt-ipv6 = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^((:|[0-9a-fA-F]{0,4}):)([0-9a-fA-F]{0,4}:){0,5}((([0-9a-fA-F]{0,4}:)?(:|[0-9a-fA-F]{0,4}))|(((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])))(%[\\p{N}\\p{L}]+)?$"
                      ],
                  network-mode = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(host)|(container:\\S+)|(none)$"
                      ],
                  ports = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(%[\\p{N}\\p{L}]+)?:([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]):([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$|^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(%[\\p{N}\\p{L}]+)?:([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]):([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])+(/tcp|/udp|/sctp)$|^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]):([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$|^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]):([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])+(/tcp|/udp|/sctp)$|^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$|^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])-([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]):([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])+(/tcp|/udp|/sctp)?$"
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  publish = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "(^http|^https|^tcp|^tls)/(([0-9]+$)|([0-9]+/.+$))"
                        ]),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  runtime = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "docker", "ignite" ]
                      ],
                  sandbox = predicates.isType '"String",
                  startup-config = predicates.isType '"String",
                  startup-delay = predicates.isType 'Integer,
                  type = predicates.isType '"String",
                  user = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.arrays.minItems 1
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Number",
                          predicates.arrays.minItems 1
                        ]
                      ],
                  wait-for = predicates.allOf
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
        },
  }
in

{
  mgmt
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.minProperties 1,
      predicates.records.record
      {
        bridge = predicates.isType '"String",
        ipv4-gw = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern
              "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(%[\\p{N}\\p{L}]+)?$"
            ],
        ipv4-range = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern "^.+/[0-9]{1,2}$"
            ],
        ipv4-subnet = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern "^.+/[0-9]{1,2}$"
            ],
        ipv6-gw = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern
              "^((:|[0-9a-fA-F]{0,4}):)([0-9a-fA-F]{0,4}:){0,5}((([0-9a-fA-F]{0,4}:)?(:|[0-9a-fA-F]{0,4}))|(((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])))(%[\\p{N}\\p{L}]+)?$"
            ],
        ipv6-range = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern
              "^((:|[0-9a-fA-F]{0,4}):)([0-9a-fA-F]{0,4}:){0,5}((([0-9a-fA-F]{0,4}:)?(:|[0-9a-fA-F]{0,4}))|(((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])))(%[\\p{N}\\p{L}]+)?$"
            ],
        ipv6-subnet = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern "^.+/[0-9]{1,3}$"
            ],
        mtu = predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.maximum 65535,
              predicates.numbers.minimum 1
            ],
        network = predicates.isType '"String",
      }
      {  }
      true
      predicates.always
    ])
    | doc m%"
    configuration container for management network
    "%
    | optional,
  name
    | String
    | doc m%"
    topology name
    "%,
  prefix
    | predicates.contract_from_predicate (predicates.isType '"String")
    | doc m%"
    lab prefix
    "%
    | optional,
  settings
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record
      {
        certificate-authority =
          definitions.predicate.certificate-authority-config,
      }
      {  }
      true
      predicates.always
    ])
    | doc m%"
    Global containerlab settings
    "%
    | optional,
  topology
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.required [ "nodes" ],
      predicates.records.record
      {
        defaults = definitions.predicate.node-config,
        kinds = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                arista_ceos = definitions.predicate.node-config,
                bridge = definitions.predicate.node-config,
                c8000 = definitions.predicate.node-config,
                ceos = definitions.predicate.node-config,
                checkpoint_cloudguard = definitions.predicate.node-config,
                crpd = definitions.predicate.node-config,
                cumulus_cvx = definitions.predicate.node-config,
                cvx = definitions.predicate.node-config,
                ext-container = definitions.predicate.node-config,
                host = definitions.predicate.node-config,
                ipinfusion_ocnos = definitions.predicate.node-config,
                juniper_crpd = definitions.predicate.node-config,
                keysight_ixia-c-one = definitions.predicate.node-config,
                linux = definitions.predicate.node-config,
                mysocketio = definitions.predicate.node-config,
                nokia_srlinux = definitions.predicate.node-config,
                ovs-bridge = definitions.predicate.node-config,
                rare = definitions.predicate.node-config,
                sonic-vs = definitions.predicate.node-config,
                srl = definitions.predicate.node-config,
                vr-aoscx = definitions.predicate.node-config,
                vr-arista_veos = definitions.predicate.node-config,
                vr-aruba_aoscx = definitions.predicate.node-config,
                vr-cisco_csr = definitions.predicate.node-config,
                vr-cisco_nxos = definitions.predicate.node-config,
                vr-cisco_xrv = definitions.predicate.node-config,
                vr-cisco_xrv9k = definitions.predicate.node-config,
                vr-csr = definitions.predicate.node-config,
                vr-juniper_vjunosswitch = definitions.predicate.node-config,
                vr-juniper_vmx = definitions.predicate.node-config,
                vr-juniper_vsrx = definitions.predicate.node-config,
                vr-nokia_sros = definitions.predicate.node-config,
                vr-nxos = definitions.predicate.node-config,
                vr-sros = definitions.predicate.node-config,
                vr-vjunosswitch = definitions.predicate.node-config,
                vr-vmx = definitions.predicate.node-config,
                vr-vsrx = definitions.predicate.node-config,
                vr-xrv = definitions.predicate.node-config,
                vr-xrv9k = definitions.predicate.node-config,
                xrd = definitions.predicate.node-config,
              }
              {  }
              true
              predicates.always
            ],
        links = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.link-config,
              predicates.arrays.minItems 1
            ],
        nodes = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record {  }
              {
                ".*" = predicates.oneOf
                    [
                      predicates.isType 'Null,
                      definitions.predicate.node-config
                    ],
              }
              true
              predicates.always
            ],
      }
      {  }
      true
      predicates.always
    ])
    | doc m%"
    topology configuration container
    "%,
}