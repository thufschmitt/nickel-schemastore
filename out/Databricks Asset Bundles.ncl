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

let rec definitions = { contract = {  }, predicate = {  }, } in
{
  artifacts
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "build", "files", "path", "type" ],
        predicates.records.record
        {
          build = predicates.isType '"String",
          files = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "source" ],
                  predicates.records.record
                  { source = predicates.isType '"String", }
                  {  }
                  false
                  predicates.never
                ])
              ],
          path = predicates.isType '"String",
          type = predicates.isType '"String",
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    A description of all code artifacts in this bundle.
    "%
    | optional,
  bundle
    | {
      compute_id | String | optional,
      git
        | { branch | String | optional, origin_url | String | optional, }
        | optional,
      name
        | String
        | doc m%"
        The name of the bundle.
        "%,
    }
    | doc m%"
    The details for this bundle.
    "%
    | optional,
  environments
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          artifacts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "build", "files", "path", "type" ],
                  predicates.records.record
                  {
                    build = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "source" ],
                            predicates.records.record
                            { source = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    path = predicates.isType '"String",
                    type = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          bundle = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  compute_id = predicates.isType '"String",
                  git = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          branch = predicates.isType '"String",
                          origin_url = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          compute_id = predicates.isType '"String",
          "default" = predicates.isType '"Bool",
          git = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  branch = predicates.isType '"String",
                  origin_url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          mode = predicates.isType '"String",
          resources = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  experiments = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            artifact_location = predicates.isType '"String",
                            creation_time = predicates.isType '"Number",
                            experiment_id = predicates.isType '"String",
                            last_update_time = predicates.isType '"Number",
                            lifecycle_stage = predicates.isType '"String",
                            name = predicates.isType '"String",
                            permissions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "level" ],
                                    predicates.records.record
                                    {
                                      group_name = predicates.isType '"String",
                                      level = predicates.isType '"String",
                                      service_principal_name = predicates.isType
                                          '"String",
                                      user_name = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            tags = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      key = predicates.isType '"String",
                                      value = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                  jobs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            compute = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required
                                    [ "compute_key", "spec" ],
                                    predicates.records.record
                                    {
                                      compute_key = predicates.isType '"String",
                                      spec = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              kind = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            continuous = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    pause_status = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            email_notifications = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    no_alert_for_skipped_runs =
                                      predicates.isType '"Bool",
                                    on_duration_warning_threshold_exceeded =
                                      predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    on_failure = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    on_start = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    on_success = predicates.allOf
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
                            format = predicates.isType '"String",
                            git_source = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "git_provider", "git_url" ],
                                  predicates.records.record
                                  {
                                    git_branch = predicates.isType '"String",
                                    git_commit = predicates.isType '"String",
                                    git_provider = predicates.isType '"String",
                                    git_snapshot = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            used_commit = predicates.isType
                                                '"String",
                                          }
                                          {  }
                                          false
                                          predicates.never
                                        ],
                                    git_tag = predicates.isType '"String",
                                    git_url = predicates.isType '"String",
                                    job_source = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.required
                                          [
                                            "import_from_git_branch",
                                            "job_config_path"
                                          ],
                                          predicates.records.record
                                          {
                                            dirty_state = predicates.isType
                                                '"String",
                                            import_from_git_branch =
                                              predicates.isType '"String",
                                            job_config_path = predicates.isType
                                                '"String",
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
                            health = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    rules = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              metric = predicates.isType
                                                  '"String",
                                              op = predicates.isType '"String",
                                              value = predicates.isType
                                                  '"Number",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            job_clusters = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required
                                    [ "job_cluster_key" ],
                                    predicates.records.record
                                    {
                                      job_cluster_key = predicates.isType
                                          '"String",
                                      new_cluster = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              autoscale = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [
                                                      "max_workers",
                                                      "min_workers"
                                                    ],
                                                    predicates.records.record
                                                    {
                                                      max_workers =
                                                        predicates.isType
                                                          '"Number",
                                                      min_workers =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              autotermination_minutes =
                                                predicates.isType '"Number",
                                              aws_attributes = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      availability =
                                                        predicates.isType
                                                          '"String",
                                                      ebs_volume_count =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_iops =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_size =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_throughput =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_type =
                                                        predicates.isType
                                                          '"String",
                                                      first_on_demand =
                                                        predicates.isType
                                                          '"Number",
                                                      instance_profile_arn =
                                                        predicates.isType
                                                          '"String",
                                                      spot_bid_price_percent =
                                                        predicates.isType
                                                          '"Number",
                                                      zone_id =
                                                        predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              azure_attributes =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      availability =
                                                        predicates.isType
                                                          '"String",
                                                      first_on_demand =
                                                        predicates.isType
                                                          '"Number",
                                                      log_analytics_info =
                                                        predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              log_analytics_primary_key =
                                                                predicates.isType
                                                                  '"String",
                                                              log_analytics_workspace_id =
                                                                predicates.isType
                                                                  '"String",
                                                            }
                                                            {  }
                                                            false
                                                            predicates.never
                                                          ],
                                                      spot_bid_max_price =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              cluster_log_conf =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      dbfs = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              destination =
                                                                predicates.isType
                                                                  '"String",
                                                            }
                                                            {  }
                                                            false
                                                            predicates.never
                                                          ],
                                                      s3 = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              canned_acl =
                                                                predicates.isType
                                                                  '"String",
                                                              destination =
                                                                predicates.isType
                                                                  '"String",
                                                              enable_encryption =
                                                                predicates.isType
                                                                  '"Bool",
                                                              encryption_type =
                                                                predicates.isType
                                                                  '"String",
                                                              endpoint =
                                                                predicates.isType
                                                                  '"String",
                                                              kms_key =
                                                                predicates.isType
                                                                  '"String",
                                                              region =
                                                                predicates.isType
                                                                  '"String",
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
                                              cluster_name = predicates.isType
                                                  '"String",
                                              cluster_source = predicates.isType
                                                  '"String",
                                              custom_tags = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              data_security_mode =
                                                predicates.isType '"String",
                                              docker_image = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      basic_auth =
                                                        predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              password =
                                                                predicates.isType
                                                                  '"String",
                                                              username =
                                                                predicates.isType
                                                                  '"String",
                                                            }
                                                            {  }
                                                            false
                                                            predicates.never
                                                          ],
                                                      url = predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              driver_instance_pool_id =
                                                predicates.isType '"String",
                                              driver_node_type_id =
                                                predicates.isType '"String",
                                              enable_elastic_disk =
                                                predicates.isType '"Bool",
                                              enable_local_disk_encryption =
                                                predicates.isType '"Bool",
                                              gcp_attributes = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      availability =
                                                        predicates.isType
                                                          '"String",
                                                      boot_disk_size =
                                                        predicates.isType
                                                          '"Number",
                                                      google_service_account =
                                                        predicates.isType
                                                          '"String",
                                                      local_ssd_count =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              init_scripts = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.record
                                                      {
                                                        dbfs = predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                        s3 = predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                canned_acl =
                                                                  predicates.isType
                                                                    '"String",
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                                enable_encryption =
                                                                  predicates.isType
                                                                    '"Bool",
                                                                encryption_type =
                                                                  predicates.isType
                                                                    '"String",
                                                                endpoint =
                                                                  predicates.isType
                                                                    '"String",
                                                                kms_key =
                                                                  predicates.isType
                                                                    '"String",
                                                                region =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                        volumes =
                                                          predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                        workspace =
                                                          predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                      }
                                                      {  }
                                                      false
                                                      predicates.never
                                                    ])
                                                  ],
                                              instance_pool_id =
                                                predicates.isType '"String",
                                              node_type_id = predicates.isType
                                                  '"String",
                                              num_workers = predicates.isType
                                                  '"Number",
                                              policy_id = predicates.isType
                                                  '"String",
                                              runtime_engine = predicates.isType
                                                  '"String",
                                              single_user_name =
                                                predicates.isType '"String",
                                              spark_conf = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              spark_env_vars = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              spark_version = predicates.isType
                                                  '"String",
                                              ssh_public_keys = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              workload_type = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      clients = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              jobs =
                                                                predicates.isType
                                                                  '"Bool",
                                                              notebooks =
                                                                predicates.isType
                                                                  '"Bool",
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
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            max_concurrent_runs = predicates.isType '"Number",
                            name = predicates.isType '"String",
                            notification_settings = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    no_alert_for_canceled_runs =
                                      predicates.isType '"Bool",
                                    no_alert_for_skipped_runs =
                                      predicates.isType '"Bool",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            parameters = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required
                                    [ "default", "name" ],
                                    predicates.records.record
                                    {
                                      "default" = predicates.isType '"String",
                                      name = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            permissions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "level" ],
                                    predicates.records.record
                                    {
                                      group_name = predicates.isType '"String",
                                      level = predicates.isType '"String",
                                      service_principal_name = predicates.isType
                                          '"String",
                                      user_name = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            run_as = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    service_principal_name = predicates.isType
                                        '"String",
                                    user_name = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            schedule = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "quartz_cron_expression", "timezone_id" ],
                                  predicates.records.record
                                  {
                                    pause_status = predicates.isType '"String",
                                    quartz_cron_expression = predicates.isType
                                        '"String",
                                    timezone_id = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            tags = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record {  } {  } true
                                  (predicates.isType '"String")
                                ],
                            tasks = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "task_key" ],
                                    predicates.records.record
                                    {
                                      compute_key = predicates.isType '"String",
                                      condition_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              left = predicates.isType
                                                  '"String",
                                              op = predicates.isType '"String",
                                              right = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      dbt_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "commands" ],
                                            predicates.records.record
                                            {
                                              catalog = predicates.isType
                                                  '"String",
                                              commands = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              profiles_directory =
                                                predicates.isType '"String",
                                              project_directory =
                                                predicates.isType '"String",
                                              schema = predicates.isType
                                                  '"String",
                                              warehouse_id = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      depends_on = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.required
                                              [ "task_key" ],
                                              predicates.records.record
                                              {
                                                outcome = predicates.isType
                                                    '"String",
                                                task_key = predicates.isType
                                                    '"String",
                                              }
                                              {  }
                                              false
                                              predicates.never
                                            ])
                                          ],
                                      description = predicates.isType '"String",
                                      email_notifications = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              on_duration_warning_threshold_exceeded =
                                                predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              on_failure = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              on_start = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              on_success = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      existing_cluster_id = predicates.isType
                                          '"String",
                                      health = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              rules = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.record
                                                      {
                                                        metric =
                                                          predicates.isType
                                                            '"String",
                                                        op = predicates.isType
                                                            '"String",
                                                        value =
                                                          predicates.isType
                                                            '"Number",
                                                      }
                                                      {  }
                                                      false
                                                      predicates.never
                                                    ])
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      job_cluster_key = predicates.isType
                                          '"String",
                                      libraries = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                cran = predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.required
                                                      [ "package" ],
                                                      predicates.records.record
                                                      {
                                                        package =
                                                          predicates.isType
                                                            '"String",
                                                        repo = predicates.isType
                                                            '"String",
                                                      }
                                                      {  }
                                                      false
                                                      predicates.never
                                                    ],
                                                egg = predicates.isType
                                                    '"String",
                                                jar = predicates.isType
                                                    '"String",
                                                maven = predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.required
                                                      [ "coordinates" ],
                                                      predicates.records.record
                                                      {
                                                        coordinates =
                                                          predicates.isType
                                                            '"String",
                                                        exclusions =
                                                          predicates.allOf
                                                            [
                                                              predicates.isType
                                                              '"Array",
                                                              predicates.arrays.arrayOf
                                                              (predicates.isType
                                                              '"String")
                                                            ],
                                                        repo = predicates.isType
                                                            '"String",
                                                      }
                                                      {  }
                                                      false
                                                      predicates.never
                                                    ],
                                                pypi = predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.required
                                                      [ "package" ],
                                                      predicates.records.record
                                                      {
                                                        package =
                                                          predicates.isType
                                                            '"String",
                                                        repo = predicates.isType
                                                            '"String",
                                                      }
                                                      {  }
                                                      false
                                                      predicates.never
                                                    ],
                                                whl = predicates.isType
                                                    '"String",
                                              }
                                              {  }
                                              false
                                              predicates.never
                                            ])
                                          ],
                                      max_retries = predicates.isType '"Number",
                                      min_retry_interval_millis =
                                        predicates.isType '"Number",
                                      new_cluster = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              autoscale = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [
                                                      "max_workers",
                                                      "min_workers"
                                                    ],
                                                    predicates.records.record
                                                    {
                                                      max_workers =
                                                        predicates.isType
                                                          '"Number",
                                                      min_workers =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              autotermination_minutes =
                                                predicates.isType '"Number",
                                              aws_attributes = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      availability =
                                                        predicates.isType
                                                          '"String",
                                                      ebs_volume_count =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_iops =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_size =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_throughput =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_type =
                                                        predicates.isType
                                                          '"String",
                                                      first_on_demand =
                                                        predicates.isType
                                                          '"Number",
                                                      instance_profile_arn =
                                                        predicates.isType
                                                          '"String",
                                                      spot_bid_price_percent =
                                                        predicates.isType
                                                          '"Number",
                                                      zone_id =
                                                        predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              azure_attributes =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      availability =
                                                        predicates.isType
                                                          '"String",
                                                      first_on_demand =
                                                        predicates.isType
                                                          '"Number",
                                                      log_analytics_info =
                                                        predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              log_analytics_primary_key =
                                                                predicates.isType
                                                                  '"String",
                                                              log_analytics_workspace_id =
                                                                predicates.isType
                                                                  '"String",
                                                            }
                                                            {  }
                                                            false
                                                            predicates.never
                                                          ],
                                                      spot_bid_max_price =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              cluster_log_conf =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      dbfs = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              destination =
                                                                predicates.isType
                                                                  '"String",
                                                            }
                                                            {  }
                                                            false
                                                            predicates.never
                                                          ],
                                                      s3 = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              canned_acl =
                                                                predicates.isType
                                                                  '"String",
                                                              destination =
                                                                predicates.isType
                                                                  '"String",
                                                              enable_encryption =
                                                                predicates.isType
                                                                  '"Bool",
                                                              encryption_type =
                                                                predicates.isType
                                                                  '"String",
                                                              endpoint =
                                                                predicates.isType
                                                                  '"String",
                                                              kms_key =
                                                                predicates.isType
                                                                  '"String",
                                                              region =
                                                                predicates.isType
                                                                  '"String",
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
                                              cluster_name = predicates.isType
                                                  '"String",
                                              cluster_source = predicates.isType
                                                  '"String",
                                              custom_tags = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              data_security_mode =
                                                predicates.isType '"String",
                                              docker_image = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      basic_auth =
                                                        predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              password =
                                                                predicates.isType
                                                                  '"String",
                                                              username =
                                                                predicates.isType
                                                                  '"String",
                                                            }
                                                            {  }
                                                            false
                                                            predicates.never
                                                          ],
                                                      url = predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              driver_instance_pool_id =
                                                predicates.isType '"String",
                                              driver_node_type_id =
                                                predicates.isType '"String",
                                              enable_elastic_disk =
                                                predicates.isType '"Bool",
                                              enable_local_disk_encryption =
                                                predicates.isType '"Bool",
                                              gcp_attributes = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      availability =
                                                        predicates.isType
                                                          '"String",
                                                      boot_disk_size =
                                                        predicates.isType
                                                          '"Number",
                                                      google_service_account =
                                                        predicates.isType
                                                          '"String",
                                                      local_ssd_count =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              init_scripts = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.record
                                                      {
                                                        dbfs = predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                        s3 = predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                canned_acl =
                                                                  predicates.isType
                                                                    '"String",
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                                enable_encryption =
                                                                  predicates.isType
                                                                    '"Bool",
                                                                encryption_type =
                                                                  predicates.isType
                                                                    '"String",
                                                                endpoint =
                                                                  predicates.isType
                                                                    '"String",
                                                                kms_key =
                                                                  predicates.isType
                                                                    '"String",
                                                                region =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                        volumes =
                                                          predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                        workspace =
                                                          predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                      }
                                                      {  }
                                                      false
                                                      predicates.never
                                                    ])
                                                  ],
                                              instance_pool_id =
                                                predicates.isType '"String",
                                              node_type_id = predicates.isType
                                                  '"String",
                                              num_workers = predicates.isType
                                                  '"Number",
                                              policy_id = predicates.isType
                                                  '"String",
                                              runtime_engine = predicates.isType
                                                  '"String",
                                              single_user_name =
                                                predicates.isType '"String",
                                              spark_conf = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              spark_env_vars = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              spark_version = predicates.isType
                                                  '"String",
                                              ssh_public_keys = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              workload_type = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      clients = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              jobs =
                                                                predicates.isType
                                                                  '"Bool",
                                                              notebooks =
                                                                predicates.isType
                                                                  '"Bool",
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
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      notebook_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "notebook_path" ],
                                            predicates.records.record
                                            {
                                              base_parameters = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              notebook_path = predicates.isType
                                                  '"String",
                                              source = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      notification_settings = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              alert_on_last_attempt =
                                                predicates.isType '"Bool",
                                              no_alert_for_canceled_runs =
                                                predicates.isType '"Bool",
                                              no_alert_for_skipped_runs =
                                                predicates.isType '"Bool",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      pipeline_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              full_refresh = predicates.isType
                                                  '"Bool",
                                              pipeline_id = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      python_wheel_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              entry_point = predicates.isType
                                                  '"String",
                                              named_parameters =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              package_name = predicates.isType
                                                  '"String",
                                              parameters = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      retry_on_timeout = predicates.isType
                                          '"Bool",
                                      run_if = predicates.isType '"String",
                                      run_job_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "job_id" ],
                                            predicates.records.record
                                            {
                                              job_id = predicates.isType
                                                  '"Number",
                                              job_parameters =
                                                predicates.always,
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      spark_jar_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              jar_uri = predicates.isType
                                                  '"String",
                                              main_class_name =
                                                predicates.isType '"String",
                                              parameters = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      spark_python_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "python_file" ],
                                            predicates.records.record
                                            {
                                              parameters = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              python_file = predicates.isType
                                                  '"String",
                                              source = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      spark_submit_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              parameters = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      sql_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "warehouse_id" ],
                                            predicates.records.record
                                            {
                                              alert = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [ "alert_id" ],
                                                    predicates.records.record
                                                    {
                                                      alert_id =
                                                        predicates.isType
                                                          '"String",
                                                      pause_subscriptions =
                                                        predicates.isType
                                                          '"Bool",
                                                      subscriptions =
                                                        predicates.allOf
                                                          [
                                                            predicates.isType
                                                            '"Array",
                                                            predicates.arrays.arrayOf
                                                            (predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination_id =
                                                                  predicates.isType
                                                                    '"String",
                                                                user_name =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ])
                                                          ],
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              dashboard = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [ "dashboard_id" ],
                                                    predicates.records.record
                                                    {
                                                      custom_subject =
                                                        predicates.isType
                                                          '"String",
                                                      dashboard_id =
                                                        predicates.isType
                                                          '"String",
                                                      pause_subscriptions =
                                                        predicates.isType
                                                          '"Bool",
                                                      subscriptions =
                                                        predicates.allOf
                                                          [
                                                            predicates.isType
                                                            '"Array",
                                                            predicates.arrays.arrayOf
                                                            (predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination_id =
                                                                  predicates.isType
                                                                    '"String",
                                                                user_name =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ])
                                                          ],
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              file = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [ "path" ],
                                                    predicates.records.record
                                                    {
                                                      path = predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              parameters = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              query = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [ "query_id" ],
                                                    predicates.records.record
                                                    {
                                                      query_id =
                                                        predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              warehouse_id = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      task_key = predicates.isType '"String",
                                      timeout_seconds = predicates.isType
                                          '"Number",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            timeout_seconds = predicates.isType '"Number",
                            trigger = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    file_arrival = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            min_time_between_triggers_seconds =
                                              predicates.isType '"Number",
                                            url = predicates.isType '"String",
                                            wait_after_last_change_seconds =
                                              predicates.isType '"Number",
                                          }
                                          {  }
                                          false
                                          predicates.never
                                        ],
                                    pause_status = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            webhook_notifications = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    on_duration_warning_threshold_exceeded =
                                      predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              id = predicates.isType '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                    on_failure = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              id = predicates.isType '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                    on_start = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              id = predicates.isType '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                    on_success = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              id = predicates.isType '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                  model_serving_endpoints = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "config", "name" ],
                          predicates.records.record
                          {
                            config = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "served_models" ],
                                  predicates.records.record
                                  {
                                    served_models = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [
                                              "model_name",
                                              "model_version",
                                              "scale_to_zero_enabled",
                                              "workload_size"
                                            ],
                                            predicates.records.record
                                            {
                                              environment_vars =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              instance_profile_arn =
                                                predicates.isType '"String",
                                              model_name = predicates.isType
                                                  '"String",
                                              model_version = predicates.isType
                                                  '"String",
                                              name = predicates.isType
                                                  '"String",
                                              scale_to_zero_enabled =
                                                predicates.isType '"Bool",
                                              workload_size = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                    traffic_config = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            routes = predicates.allOf
                                                [
                                                  predicates.isType '"Array",
                                                  predicates.arrays.arrayOf
                                                  (predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [
                                                      "served_model_name",
                                                      "traffic_percentage"
                                                    ],
                                                    predicates.records.record
                                                    {
                                                      served_model_name =
                                                        predicates.isType
                                                          '"String",
                                                      traffic_percentage =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ])
                                                ],
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
                            name = predicates.isType '"String",
                            permissions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "level" ],
                                    predicates.records.record
                                    {
                                      group_name = predicates.isType '"String",
                                      level = predicates.isType '"String",
                                      service_principal_name = predicates.isType
                                          '"String",
                                      user_name = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                  models = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            creation_timestamp = predicates.isType '"Number",
                            description = predicates.isType '"String",
                            last_updated_timestamp = predicates.isType
                                '"Number",
                            latest_versions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      creation_timestamp = predicates.isType
                                          '"Number",
                                      current_stage = predicates.isType
                                          '"String",
                                      description = predicates.isType '"String",
                                      last_updated_timestamp = predicates.isType
                                          '"Number",
                                      name = predicates.isType '"String",
                                      run_id = predicates.isType '"String",
                                      run_link = predicates.isType '"String",
                                      source = predicates.isType '"String",
                                      status = predicates.isType '"String",
                                      status_message = predicates.isType
                                          '"String",
                                      tags = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                key = predicates.isType
                                                    '"String",
                                                value = predicates.isType
                                                    '"String",
                                              }
                                              {  }
                                              false
                                              predicates.never
                                            ])
                                          ],
                                      user_id = predicates.isType '"String",
                                      version = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            name = predicates.isType '"String",
                            permissions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "level" ],
                                    predicates.records.record
                                    {
                                      group_name = predicates.isType '"String",
                                      level = predicates.isType '"String",
                                      service_principal_name = predicates.isType
                                          '"String",
                                      user_name = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            tags = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      key = predicates.isType '"String",
                                      value = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            user_id = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                  pipelines = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            catalog = predicates.isType '"String",
                            channel = predicates.isType '"String",
                            clusters = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      apply_policy_default_values =
                                        predicates.isType '"Bool",
                                      autoscale = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "max_workers", "min_workers" ],
                                            predicates.records.record
                                            {
                                              max_workers = predicates.isType
                                                  '"Number",
                                              min_workers = predicates.isType
                                                  '"Number",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      aws_attributes = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              availability = predicates.isType
                                                  '"String",
                                              ebs_volume_count =
                                                predicates.isType '"Number",
                                              ebs_volume_iops =
                                                predicates.isType '"Number",
                                              ebs_volume_size =
                                                predicates.isType '"Number",
                                              ebs_volume_throughput =
                                                predicates.isType '"Number",
                                              ebs_volume_type =
                                                predicates.isType '"String",
                                              first_on_demand =
                                                predicates.isType '"Number",
                                              instance_profile_arn =
                                                predicates.isType '"String",
                                              spot_bid_price_percent =
                                                predicates.isType '"Number",
                                              zone_id = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      azure_attributes = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              availability = predicates.isType
                                                  '"String",
                                              first_on_demand =
                                                predicates.isType '"Number",
                                              log_analytics_info =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      log_analytics_primary_key =
                                                        predicates.isType
                                                          '"String",
                                                      log_analytics_workspace_id =
                                                        predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              spot_bid_max_price =
                                                predicates.isType '"Number",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      cluster_log_conf = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              dbfs = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      destination =
                                                        predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              s3 = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      canned_acl =
                                                        predicates.isType
                                                          '"String",
                                                      destination =
                                                        predicates.isType
                                                          '"String",
                                                      enable_encryption =
                                                        predicates.isType
                                                          '"Bool",
                                                      encryption_type =
                                                        predicates.isType
                                                          '"String",
                                                      endpoint =
                                                        predicates.isType
                                                          '"String",
                                                      kms_key =
                                                        predicates.isType
                                                          '"String",
                                                      region = predicates.isType
                                                          '"String",
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
                                      custom_tags = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record {  } {  }
                                            true
                                            (predicates.isType '"String")
                                          ],
                                      driver_instance_pool_id =
                                        predicates.isType '"String",
                                      driver_node_type_id = predicates.isType
                                          '"String",
                                      gcp_attributes = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              availability = predicates.isType
                                                  '"String",
                                              boot_disk_size = predicates.isType
                                                  '"Number",
                                              google_service_account =
                                                predicates.isType '"String",
                                              local_ssd_count =
                                                predicates.isType '"Number",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      instance_pool_id = predicates.isType
                                          '"String",
                                      label = predicates.isType '"String",
                                      node_type_id = predicates.isType
                                          '"String",
                                      num_workers = predicates.isType '"Number",
                                      policy_id = predicates.isType '"String",
                                      spark_conf = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record {  } {  }
                                            true
                                            (predicates.isType '"String")
                                          ],
                                      spark_env_vars = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record {  } {  }
                                            true
                                            (predicates.isType '"String")
                                          ],
                                      ssh_public_keys = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.isType '"String")
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            configuration = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record {  } {  } true
                                  (predicates.isType '"String")
                                ],
                            continuous = predicates.isType '"Bool",
                            development = predicates.isType '"Bool",
                            edition = predicates.isType '"String",
                            filters = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    exclude = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    include = predicates.allOf
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
                            id = predicates.isType '"String",
                            libraries = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      file = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              path = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      jar = predicates.isType '"String",
                                      maven = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "coordinates" ],
                                            predicates.records.record
                                            {
                                              coordinates = predicates.isType
                                                  '"String",
                                              exclusions = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              repo = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      notebook = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              path = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            name = predicates.isType '"String",
                            permissions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "level" ],
                                    predicates.records.record
                                    {
                                      group_name = predicates.isType '"String",
                                      level = predicates.isType '"String",
                                      service_principal_name = predicates.isType
                                          '"String",
                                      user_name = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            photon = predicates.isType '"Bool",
                            serverless = predicates.isType '"Bool",
                            storage = predicates.isType '"String",
                            target = predicates.isType '"String",
                            trigger = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    cron = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            quartz_cron_schedule =
                                              predicates.isType '"String",
                                            timezone_id = predicates.isType
                                                '"String",
                                          }
                                          {  }
                                          false
                                          predicates.never
                                        ],
                                    manual = predicates.always,
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          run_as = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  service_principal_name = predicates.isType '"String",
                  user_name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          variables = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          workspace = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifact_path = predicates.isType '"String",
                  auth_type = predicates.isType '"String",
                  azure_client_id = predicates.isType '"String",
                  azure_environment = predicates.isType '"String",
                  azure_login_app_id = predicates.isType '"String",
                  azure_tenant_id = predicates.isType '"String",
                  azure_use_msi = predicates.isType '"Bool",
                  azure_workspace_resource_id = predicates.isType '"String",
                  client_id = predicates.isType '"String",
                  file_path = predicates.isType '"String",
                  google_service_account = predicates.isType '"String",
                  host = predicates.isType '"String",
                  profile = predicates.isType '"String",
                  root_path = predicates.isType '"String",
                  state_path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        }
        {  }
        false
        predicates.never
      ])
    ])
    | optional,
  include
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of glob patterns of files to load and merge into the this configuration. Defaults to no files being included.
    "%
    | optional,
  resources
    | {
      experiments
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              artifact_location = predicates.isType '"String",
              creation_time = predicates.isType '"Number",
              experiment_id = predicates.isType '"String",
              last_update_time = predicates.isType '"Number",
              lifecycle_stage = predicates.isType '"String",
              name = predicates.isType '"String",
              permissions = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "level" ],
                      predicates.records.record
                      {
                        group_name = predicates.isType '"String",
                        level = predicates.isType '"String",
                        service_principal_name = predicates.isType '"String",
                        user_name = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              tags = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        key = predicates.isType '"String",
                        value = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
            }
            {  }
            false
            predicates.never
          ])
        ])
        | doc m%"
        List of MLflow experiments
        "%
        | optional,
      jobs
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              compute = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "compute_key", "spec" ],
                      predicates.records.record
                      {
                        compute_key = predicates.isType '"String",
                        spec = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              { kind = predicates.isType '"String", }
                              {  }
                              false
                              predicates.never
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              continuous = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    { pause_status = predicates.isType '"String", }
                    {  }
                    false
                    predicates.never
                  ],
              email_notifications = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      no_alert_for_skipped_runs = predicates.isType '"Bool",
                      on_duration_warning_threshold_exceeded = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                      on_failure = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                      on_start = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                      on_success = predicates.allOf
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
              format = predicates.isType '"String",
              git_source = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "git_provider", "git_url" ],
                    predicates.records.record
                    {
                      git_branch = predicates.isType '"String",
                      git_commit = predicates.isType '"String",
                      git_provider = predicates.isType '"String",
                      git_snapshot = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { used_commit = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ],
                      git_tag = predicates.isType '"String",
                      git_url = predicates.isType '"String",
                      job_source = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required
                            [ "import_from_git_branch", "job_config_path" ],
                            predicates.records.record
                            {
                              dirty_state = predicates.isType '"String",
                              import_from_git_branch = predicates.isType
                                  '"String",
                              job_config_path = predicates.isType '"String",
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
              health = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      rules = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                metric = predicates.isType '"String",
                                op = predicates.isType '"String",
                                value = predicates.isType '"Number",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ],
              job_clusters = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "job_cluster_key" ],
                      predicates.records.record
                      {
                        job_cluster_key = predicates.isType '"String",
                        new_cluster = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                autoscale = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.required
                                      [ "max_workers", "min_workers" ],
                                      predicates.records.record
                                      {
                                        max_workers = predicates.isType
                                            '"Number",
                                        min_workers = predicates.isType
                                            '"Number",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                autotermination_minutes = predicates.isType
                                    '"Number",
                                aws_attributes = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        availability = predicates.isType
                                            '"String",
                                        ebs_volume_count = predicates.isType
                                            '"Number",
                                        ebs_volume_iops = predicates.isType
                                            '"Number",
                                        ebs_volume_size = predicates.isType
                                            '"Number",
                                        ebs_volume_throughput =
                                          predicates.isType '"Number",
                                        ebs_volume_type = predicates.isType
                                            '"String",
                                        first_on_demand = predicates.isType
                                            '"Number",
                                        instance_profile_arn = predicates.isType
                                            '"String",
                                        spot_bid_price_percent =
                                          predicates.isType '"Number",
                                        zone_id = predicates.isType '"String",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                azure_attributes = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        availability = predicates.isType
                                            '"String",
                                        first_on_demand = predicates.isType
                                            '"Number",
                                        log_analytics_info = predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                log_analytics_primary_key =
                                                  predicates.isType '"String",
                                                log_analytics_workspace_id =
                                                  predicates.isType '"String",
                                              }
                                              {  }
                                              false
                                              predicates.never
                                            ],
                                        spot_bid_max_price = predicates.isType
                                            '"Number",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                cluster_log_conf = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        dbfs = predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                destination = predicates.isType
                                                    '"String",
                                              }
                                              {  }
                                              false
                                              predicates.never
                                            ],
                                        s3 = predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                canned_acl = predicates.isType
                                                    '"String",
                                                destination = predicates.isType
                                                    '"String",
                                                enable_encryption =
                                                  predicates.isType '"Bool",
                                                encryption_type =
                                                  predicates.isType '"String",
                                                endpoint = predicates.isType
                                                    '"String",
                                                kms_key = predicates.isType
                                                    '"String",
                                                region = predicates.isType
                                                    '"String",
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
                                cluster_name = predicates.isType '"String",
                                cluster_source = predicates.isType '"String",
                                custom_tags = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record {  } {  } true
                                      (predicates.isType '"String")
                                    ],
                                data_security_mode = predicates.isType
                                    '"String",
                                docker_image = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        basic_auth = predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                password = predicates.isType
                                                    '"String",
                                                username = predicates.isType
                                                    '"String",
                                              }
                                              {  }
                                              false
                                              predicates.never
                                            ],
                                        url = predicates.isType '"String",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                driver_instance_pool_id = predicates.isType
                                    '"String",
                                driver_node_type_id = predicates.isType
                                    '"String",
                                enable_elastic_disk = predicates.isType '"Bool",
                                enable_local_disk_encryption = predicates.isType
                                    '"Bool",
                                gcp_attributes = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        availability = predicates.isType
                                            '"String",
                                        boot_disk_size = predicates.isType
                                            '"Number",
                                        google_service_account =
                                          predicates.isType '"String",
                                        local_ssd_count = predicates.isType
                                            '"Number",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                init_scripts = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          dbfs = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record
                                                {
                                                  destination =
                                                    predicates.isType '"String",
                                                }
                                                {  }
                                                false
                                                predicates.never
                                              ],
                                          s3 = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record
                                                {
                                                  canned_acl = predicates.isType
                                                      '"String",
                                                  destination =
                                                    predicates.isType '"String",
                                                  enable_encryption =
                                                    predicates.isType '"Bool",
                                                  encryption_type =
                                                    predicates.isType '"String",
                                                  endpoint = predicates.isType
                                                      '"String",
                                                  kms_key = predicates.isType
                                                      '"String",
                                                  region = predicates.isType
                                                      '"String",
                                                }
                                                {  }
                                                false
                                                predicates.never
                                              ],
                                          volumes = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record
                                                {
                                                  destination =
                                                    predicates.isType '"String",
                                                }
                                                {  }
                                                false
                                                predicates.never
                                              ],
                                          workspace = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record
                                                {
                                                  destination =
                                                    predicates.isType '"String",
                                                }
                                                {  }
                                                false
                                                predicates.never
                                              ],
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ])
                                    ],
                                instance_pool_id = predicates.isType '"String",
                                node_type_id = predicates.isType '"String",
                                num_workers = predicates.isType '"Number",
                                policy_id = predicates.isType '"String",
                                runtime_engine = predicates.isType '"String",
                                single_user_name = predicates.isType '"String",
                                spark_conf = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record {  } {  } true
                                      (predicates.isType '"String")
                                    ],
                                spark_env_vars = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record {  } {  } true
                                      (predicates.isType '"String")
                                    ],
                                spark_version = predicates.isType '"String",
                                ssh_public_keys = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.isType '"String")
                                    ],
                                workload_type = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        clients = predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                jobs = predicates.isType
                                                    '"Bool",
                                                notebooks = predicates.isType
                                                    '"Bool",
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
                              }
                              {  }
                              false
                              predicates.never
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              max_concurrent_runs = predicates.isType '"Number",
              name = predicates.isType '"String",
              notification_settings = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      no_alert_for_canceled_runs = predicates.isType '"Bool",
                      no_alert_for_skipped_runs = predicates.isType '"Bool",
                    }
                    {  }
                    false
                    predicates.never
                  ],
              parameters = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "default", "name" ],
                      predicates.records.record
                      {
                        "default" = predicates.isType '"String",
                        name = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              permissions = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "level" ],
                      predicates.records.record
                      {
                        group_name = predicates.isType '"String",
                        level = predicates.isType '"String",
                        service_principal_name = predicates.isType '"String",
                        user_name = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              run_as = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      service_principal_name = predicates.isType '"String",
                      user_name = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
              schedule = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required
                    [ "quartz_cron_expression", "timezone_id" ],
                    predicates.records.record
                    {
                      pause_status = predicates.isType '"String",
                      quartz_cron_expression = predicates.isType '"String",
                      timezone_id = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
              tags = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ],
              tasks = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "task_key" ],
                      predicates.records.record
                      {
                        compute_key = predicates.isType '"String",
                        condition_task = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                left = predicates.isType '"String",
                                op = predicates.isType '"String",
                                right = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        dbt_task = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "commands" ],
                              predicates.records.record
                              {
                                catalog = predicates.isType '"String",
                                commands = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.isType '"String")
                                    ],
                                profiles_directory = predicates.isType
                                    '"String",
                                project_directory = predicates.isType '"String",
                                schema = predicates.isType '"String",
                                warehouse_id = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        depends_on = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "task_key" ],
                                predicates.records.record
                                {
                                  outcome = predicates.isType '"String",
                                  task_key = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ])
                            ],
                        description = predicates.isType '"String",
                        email_notifications = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                on_duration_warning_threshold_exceeded =
                                  predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.isType '"String")
                                    ],
                                on_failure = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.isType '"String")
                                    ],
                                on_start = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.isType '"String")
                                    ],
                                on_success = predicates.allOf
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
                        existing_cluster_id = predicates.isType '"String",
                        health = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                rules = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          metric = predicates.isType '"String",
                                          op = predicates.isType '"String",
                                          value = predicates.isType '"Number",
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ])
                                    ],
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        job_cluster_key = predicates.isType '"String",
                        libraries = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  cran = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.required
                                        [ "package" ],
                                        predicates.records.record
                                        {
                                          package = predicates.isType '"String",
                                          repo = predicates.isType '"String",
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                  egg = predicates.isType '"String",
                                  jar = predicates.isType '"String",
                                  maven = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.required
                                        [ "coordinates" ],
                                        predicates.records.record
                                        {
                                          coordinates = predicates.isType
                                              '"String",
                                          exclusions = predicates.allOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.arrays.arrayOf
                                                (predicates.isType '"String")
                                              ],
                                          repo = predicates.isType '"String",
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                  pypi = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.required
                                        [ "package" ],
                                        predicates.records.record
                                        {
                                          package = predicates.isType '"String",
                                          repo = predicates.isType '"String",
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                  whl = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ])
                            ],
                        max_retries = predicates.isType '"Number",
                        min_retry_interval_millis = predicates.isType '"Number",
                        new_cluster = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                autoscale = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.required
                                      [ "max_workers", "min_workers" ],
                                      predicates.records.record
                                      {
                                        max_workers = predicates.isType
                                            '"Number",
                                        min_workers = predicates.isType
                                            '"Number",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                autotermination_minutes = predicates.isType
                                    '"Number",
                                aws_attributes = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        availability = predicates.isType
                                            '"String",
                                        ebs_volume_count = predicates.isType
                                            '"Number",
                                        ebs_volume_iops = predicates.isType
                                            '"Number",
                                        ebs_volume_size = predicates.isType
                                            '"Number",
                                        ebs_volume_throughput =
                                          predicates.isType '"Number",
                                        ebs_volume_type = predicates.isType
                                            '"String",
                                        first_on_demand = predicates.isType
                                            '"Number",
                                        instance_profile_arn = predicates.isType
                                            '"String",
                                        spot_bid_price_percent =
                                          predicates.isType '"Number",
                                        zone_id = predicates.isType '"String",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                azure_attributes = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        availability = predicates.isType
                                            '"String",
                                        first_on_demand = predicates.isType
                                            '"Number",
                                        log_analytics_info = predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                log_analytics_primary_key =
                                                  predicates.isType '"String",
                                                log_analytics_workspace_id =
                                                  predicates.isType '"String",
                                              }
                                              {  }
                                              false
                                              predicates.never
                                            ],
                                        spot_bid_max_price = predicates.isType
                                            '"Number",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                cluster_log_conf = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        dbfs = predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                destination = predicates.isType
                                                    '"String",
                                              }
                                              {  }
                                              false
                                              predicates.never
                                            ],
                                        s3 = predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                canned_acl = predicates.isType
                                                    '"String",
                                                destination = predicates.isType
                                                    '"String",
                                                enable_encryption =
                                                  predicates.isType '"Bool",
                                                encryption_type =
                                                  predicates.isType '"String",
                                                endpoint = predicates.isType
                                                    '"String",
                                                kms_key = predicates.isType
                                                    '"String",
                                                region = predicates.isType
                                                    '"String",
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
                                cluster_name = predicates.isType '"String",
                                cluster_source = predicates.isType '"String",
                                custom_tags = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record {  } {  } true
                                      (predicates.isType '"String")
                                    ],
                                data_security_mode = predicates.isType
                                    '"String",
                                docker_image = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        basic_auth = predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                password = predicates.isType
                                                    '"String",
                                                username = predicates.isType
                                                    '"String",
                                              }
                                              {  }
                                              false
                                              predicates.never
                                            ],
                                        url = predicates.isType '"String",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                driver_instance_pool_id = predicates.isType
                                    '"String",
                                driver_node_type_id = predicates.isType
                                    '"String",
                                enable_elastic_disk = predicates.isType '"Bool",
                                enable_local_disk_encryption = predicates.isType
                                    '"Bool",
                                gcp_attributes = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        availability = predicates.isType
                                            '"String",
                                        boot_disk_size = predicates.isType
                                            '"Number",
                                        google_service_account =
                                          predicates.isType '"String",
                                        local_ssd_count = predicates.isType
                                            '"Number",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                init_scripts = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          dbfs = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record
                                                {
                                                  destination =
                                                    predicates.isType '"String",
                                                }
                                                {  }
                                                false
                                                predicates.never
                                              ],
                                          s3 = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record
                                                {
                                                  canned_acl = predicates.isType
                                                      '"String",
                                                  destination =
                                                    predicates.isType '"String",
                                                  enable_encryption =
                                                    predicates.isType '"Bool",
                                                  encryption_type =
                                                    predicates.isType '"String",
                                                  endpoint = predicates.isType
                                                      '"String",
                                                  kms_key = predicates.isType
                                                      '"String",
                                                  region = predicates.isType
                                                      '"String",
                                                }
                                                {  }
                                                false
                                                predicates.never
                                              ],
                                          volumes = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record
                                                {
                                                  destination =
                                                    predicates.isType '"String",
                                                }
                                                {  }
                                                false
                                                predicates.never
                                              ],
                                          workspace = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record
                                                {
                                                  destination =
                                                    predicates.isType '"String",
                                                }
                                                {  }
                                                false
                                                predicates.never
                                              ],
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ])
                                    ],
                                instance_pool_id = predicates.isType '"String",
                                node_type_id = predicates.isType '"String",
                                num_workers = predicates.isType '"Number",
                                policy_id = predicates.isType '"String",
                                runtime_engine = predicates.isType '"String",
                                single_user_name = predicates.isType '"String",
                                spark_conf = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record {  } {  } true
                                      (predicates.isType '"String")
                                    ],
                                spark_env_vars = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record {  } {  } true
                                      (predicates.isType '"String")
                                    ],
                                spark_version = predicates.isType '"String",
                                ssh_public_keys = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.isType '"String")
                                    ],
                                workload_type = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        clients = predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                jobs = predicates.isType
                                                    '"Bool",
                                                notebooks = predicates.isType
                                                    '"Bool",
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
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        notebook_task = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "notebook_path" ],
                              predicates.records.record
                              {
                                base_parameters = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record {  } {  } true
                                      (predicates.isType '"String")
                                    ],
                                notebook_path = predicates.isType '"String",
                                source = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        notification_settings = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                alert_on_last_attempt = predicates.isType
                                    '"Bool",
                                no_alert_for_canceled_runs = predicates.isType
                                    '"Bool",
                                no_alert_for_skipped_runs = predicates.isType
                                    '"Bool",
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        pipeline_task = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                full_refresh = predicates.isType '"Bool",
                                pipeline_id = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        python_wheel_task = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                entry_point = predicates.isType '"String",
                                named_parameters = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record {  } {  } true
                                      (predicates.isType '"String")
                                    ],
                                package_name = predicates.isType '"String",
                                parameters = predicates.allOf
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
                        retry_on_timeout = predicates.isType '"Bool",
                        run_if = predicates.isType '"String",
                        run_job_task = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "job_id" ],
                              predicates.records.record
                              {
                                job_id = predicates.isType '"Number",
                                job_parameters = predicates.always,
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        spark_jar_task = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                jar_uri = predicates.isType '"String",
                                main_class_name = predicates.isType '"String",
                                parameters = predicates.allOf
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
                        spark_python_task = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "python_file" ],
                              predicates.records.record
                              {
                                parameters = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.isType '"String")
                                    ],
                                python_file = predicates.isType '"String",
                                source = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        spark_submit_task = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                parameters = predicates.allOf
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
                        sql_task = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "warehouse_id" ],
                              predicates.records.record
                              {
                                alert = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.required
                                      [ "alert_id" ],
                                      predicates.records.record
                                      {
                                        alert_id = predicates.isType '"String",
                                        pause_subscriptions = predicates.isType
                                            '"Bool",
                                        subscriptions = predicates.allOf
                                            [
                                              predicates.isType '"Array",
                                              predicates.arrays.arrayOf
                                              (predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record
                                                {
                                                  destination_id =
                                                    predicates.isType '"String",
                                                  user_name = predicates.isType
                                                      '"String",
                                                }
                                                {  }
                                                false
                                                predicates.never
                                              ])
                                            ],
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                dashboard = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.required
                                      [ "dashboard_id" ],
                                      predicates.records.record
                                      {
                                        custom_subject = predicates.isType
                                            '"String",
                                        dashboard_id = predicates.isType
                                            '"String",
                                        pause_subscriptions = predicates.isType
                                            '"Bool",
                                        subscriptions = predicates.allOf
                                            [
                                              predicates.isType '"Array",
                                              predicates.arrays.arrayOf
                                              (predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record
                                                {
                                                  destination_id =
                                                    predicates.isType '"String",
                                                  user_name = predicates.isType
                                                      '"String",
                                                }
                                                {  }
                                                false
                                                predicates.never
                                              ])
                                            ],
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                file = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.required [ "path" ],
                                      predicates.records.record
                                      { path = predicates.isType '"String", }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                parameters = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record {  } {  } true
                                      (predicates.isType '"String")
                                    ],
                                query = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.required
                                      [ "query_id" ],
                                      predicates.records.record
                                      {
                                        query_id = predicates.isType '"String",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                warehouse_id = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        task_key = predicates.isType '"String",
                        timeout_seconds = predicates.isType '"Number",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              timeout_seconds = predicates.isType '"Number",
              trigger = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      file_arrival = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              min_time_between_triggers_seconds =
                                predicates.isType '"Number",
                              url = predicates.isType '"String",
                              wait_after_last_change_seconds = predicates.isType
                                  '"Number",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      pause_status = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
              webhook_notifications = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      on_duration_warning_threshold_exceeded = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              { id = predicates.isType '"String", }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      on_failure = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              { id = predicates.isType '"String", }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      on_start = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              { id = predicates.isType '"String", }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      on_success = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              { id = predicates.isType '"String", }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ],
            }
            {  }
            false
            predicates.never
          ])
        ])
        | doc m%"
        List of Databricks jobs
        "%
        | optional,
      model_serving_endpoints
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "config", "name" ],
            predicates.records.record
            {
              config = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "served_models" ],
                    predicates.records.record
                    {
                      served_models = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required
                              [
                                "model_name",
                                "model_version",
                                "scale_to_zero_enabled",
                                "workload_size"
                              ],
                              predicates.records.record
                              {
                                environment_vars = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record {  } {  } true
                                      (predicates.isType '"String")
                                    ],
                                instance_profile_arn = predicates.isType
                                    '"String",
                                model_name = predicates.isType '"String",
                                model_version = predicates.isType '"String",
                                name = predicates.isType '"String",
                                scale_to_zero_enabled = predicates.isType
                                    '"Bool",
                                workload_size = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ])
                          ],
                      traffic_config = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              routes = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.required
                                      [
                                        "served_model_name",
                                        "traffic_percentage"
                                      ],
                                      predicates.records.record
                                      {
                                        served_model_name = predicates.isType
                                            '"String",
                                        traffic_percentage = predicates.isType
                                            '"Number",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ])
                                  ],
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
              name = predicates.isType '"String",
              permissions = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "level" ],
                      predicates.records.record
                      {
                        group_name = predicates.isType '"String",
                        level = predicates.isType '"String",
                        service_principal_name = predicates.isType '"String",
                        user_name = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
            }
            {  }
            false
            predicates.never
          ])
        ])
        | optional,
      models
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              creation_timestamp = predicates.isType '"Number",
              description = predicates.isType '"String",
              last_updated_timestamp = predicates.isType '"Number",
              latest_versions = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        creation_timestamp = predicates.isType '"Number",
                        current_stage = predicates.isType '"String",
                        description = predicates.isType '"String",
                        last_updated_timestamp = predicates.isType '"Number",
                        name = predicates.isType '"String",
                        run_id = predicates.isType '"String",
                        run_link = predicates.isType '"String",
                        source = predicates.isType '"String",
                        status = predicates.isType '"String",
                        status_message = predicates.isType '"String",
                        tags = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  key = predicates.isType '"String",
                                  value = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ])
                            ],
                        user_id = predicates.isType '"String",
                        version = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              name = predicates.isType '"String",
              permissions = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "level" ],
                      predicates.records.record
                      {
                        group_name = predicates.isType '"String",
                        level = predicates.isType '"String",
                        service_principal_name = predicates.isType '"String",
                        user_name = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              tags = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        key = predicates.isType '"String",
                        value = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              user_id = predicates.isType '"String",
            }
            {  }
            false
            predicates.never
          ])
        ])
        | doc m%"
        List of MLflow models
        "%
        | optional,
      pipelines
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } {  } true
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              catalog = predicates.isType '"String",
              channel = predicates.isType '"String",
              clusters = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        apply_policy_default_values = predicates.isType '"Bool",
                        autoscale = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required
                              [ "max_workers", "min_workers" ],
                              predicates.records.record
                              {
                                max_workers = predicates.isType '"Number",
                                min_workers = predicates.isType '"Number",
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        aws_attributes = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                availability = predicates.isType '"String",
                                ebs_volume_count = predicates.isType '"Number",
                                ebs_volume_iops = predicates.isType '"Number",
                                ebs_volume_size = predicates.isType '"Number",
                                ebs_volume_throughput = predicates.isType
                                    '"Number",
                                ebs_volume_type = predicates.isType '"String",
                                first_on_demand = predicates.isType '"Number",
                                instance_profile_arn = predicates.isType
                                    '"String",
                                spot_bid_price_percent = predicates.isType
                                    '"Number",
                                zone_id = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        azure_attributes = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                availability = predicates.isType '"String",
                                first_on_demand = predicates.isType '"Number",
                                log_analytics_info = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        log_analytics_primary_key =
                                          predicates.isType '"String",
                                        log_analytics_workspace_id =
                                          predicates.isType '"String",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                spot_bid_max_price = predicates.isType
                                    '"Number",
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        cluster_log_conf = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                dbfs = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        destination = predicates.isType
                                            '"String",
                                      }
                                      {  }
                                      false
                                      predicates.never
                                    ],
                                s3 = predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record
                                      {
                                        canned_acl = predicates.isType
                                            '"String",
                                        destination = predicates.isType
                                            '"String",
                                        enable_encryption = predicates.isType
                                            '"Bool",
                                        encryption_type = predicates.isType
                                            '"String",
                                        endpoint = predicates.isType '"String",
                                        kms_key = predicates.isType '"String",
                                        region = predicates.isType '"String",
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
                        custom_tags = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record {  } {  } true
                              (predicates.isType '"String")
                            ],
                        driver_instance_pool_id = predicates.isType '"String",
                        driver_node_type_id = predicates.isType '"String",
                        gcp_attributes = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                availability = predicates.isType '"String",
                                boot_disk_size = predicates.isType '"Number",
                                google_service_account = predicates.isType
                                    '"String",
                                local_ssd_count = predicates.isType '"Number",
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        instance_pool_id = predicates.isType '"String",
                        label = predicates.isType '"String",
                        node_type_id = predicates.isType '"String",
                        num_workers = predicates.isType '"Number",
                        policy_id = predicates.isType '"String",
                        spark_conf = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record {  } {  } true
                              (predicates.isType '"String")
                            ],
                        spark_env_vars = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record {  } {  } true
                              (predicates.isType '"String")
                            ],
                        ssh_public_keys = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              configuration = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ],
              continuous = predicates.isType '"Bool",
              development = predicates.isType '"Bool",
              edition = predicates.isType '"String",
              filters = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      exclude = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                      include = predicates.allOf
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
              id = predicates.isType '"String",
              libraries = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        file = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              { path = predicates.isType '"String", }
                              {  }
                              false
                              predicates.never
                            ],
                        jar = predicates.isType '"String",
                        maven = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "coordinates" ],
                              predicates.records.record
                              {
                                coordinates = predicates.isType '"String",
                                exclusions = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.isType '"String")
                                    ],
                                repo = predicates.isType '"String",
                              }
                              {  }
                              false
                              predicates.never
                            ],
                        notebook = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              { path = predicates.isType '"String", }
                              {  }
                              false
                              predicates.never
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              name = predicates.isType '"String",
              permissions = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "level" ],
                      predicates.records.record
                      {
                        group_name = predicates.isType '"String",
                        level = predicates.isType '"String",
                        service_principal_name = predicates.isType '"String",
                        user_name = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ],
              photon = predicates.isType '"Bool",
              serverless = predicates.isType '"Bool",
              storage = predicates.isType '"String",
              target = predicates.isType '"String",
              trigger = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      cron = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              quartz_cron_schedule = predicates.isType
                                  '"String",
                              timezone_id = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      manual = predicates.always,
                    }
                    {  }
                    false
                    predicates.never
                  ],
            }
            {  }
            false
            predicates.never
          ])
        ])
        | doc m%"
        List of DLT pipelines
        "%
        | optional,
    }
    | doc m%"
    Collection of Databricks resources to deploy.
    "%
    | optional,
  run_as
    | {
      service_principal_name | String | optional,
      user_name | String | optional,
    }
    | optional,
  sync
    | {
      exclude
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | optional,
      include
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | optional,
    }
    | optional,
  targets
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          artifacts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [ "build", "files", "path", "type" ],
                  predicates.records.record
                  {
                    build = predicates.isType '"String",
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "source" ],
                            predicates.records.record
                            { source = predicates.isType '"String", }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    path = predicates.isType '"String",
                    type = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          bundle = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  compute_id = predicates.isType '"String",
                  git = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          branch = predicates.isType '"String",
                          origin_url = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          compute_id = predicates.isType '"String",
          "default" = predicates.isType '"Bool",
          git = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  branch = predicates.isType '"String",
                  origin_url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          mode = predicates.isType '"String",
          resources = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  experiments = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            artifact_location = predicates.isType '"String",
                            creation_time = predicates.isType '"Number",
                            experiment_id = predicates.isType '"String",
                            last_update_time = predicates.isType '"Number",
                            lifecycle_stage = predicates.isType '"String",
                            name = predicates.isType '"String",
                            permissions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "level" ],
                                    predicates.records.record
                                    {
                                      group_name = predicates.isType '"String",
                                      level = predicates.isType '"String",
                                      service_principal_name = predicates.isType
                                          '"String",
                                      user_name = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            tags = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      key = predicates.isType '"String",
                                      value = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                  jobs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            compute = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required
                                    [ "compute_key", "spec" ],
                                    predicates.records.record
                                    {
                                      compute_key = predicates.isType '"String",
                                      spec = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              kind = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            continuous = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    pause_status = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            email_notifications = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    no_alert_for_skipped_runs =
                                      predicates.isType '"Bool",
                                    on_duration_warning_threshold_exceeded =
                                      predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    on_failure = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    on_start = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    on_success = predicates.allOf
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
                            format = predicates.isType '"String",
                            git_source = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "git_provider", "git_url" ],
                                  predicates.records.record
                                  {
                                    git_branch = predicates.isType '"String",
                                    git_commit = predicates.isType '"String",
                                    git_provider = predicates.isType '"String",
                                    git_snapshot = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            used_commit = predicates.isType
                                                '"String",
                                          }
                                          {  }
                                          false
                                          predicates.never
                                        ],
                                    git_tag = predicates.isType '"String",
                                    git_url = predicates.isType '"String",
                                    job_source = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.required
                                          [
                                            "import_from_git_branch",
                                            "job_config_path"
                                          ],
                                          predicates.records.record
                                          {
                                            dirty_state = predicates.isType
                                                '"String",
                                            import_from_git_branch =
                                              predicates.isType '"String",
                                            job_config_path = predicates.isType
                                                '"String",
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
                            health = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    rules = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              metric = predicates.isType
                                                  '"String",
                                              op = predicates.isType '"String",
                                              value = predicates.isType
                                                  '"Number",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            job_clusters = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required
                                    [ "job_cluster_key" ],
                                    predicates.records.record
                                    {
                                      job_cluster_key = predicates.isType
                                          '"String",
                                      new_cluster = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              autoscale = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [
                                                      "max_workers",
                                                      "min_workers"
                                                    ],
                                                    predicates.records.record
                                                    {
                                                      max_workers =
                                                        predicates.isType
                                                          '"Number",
                                                      min_workers =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              autotermination_minutes =
                                                predicates.isType '"Number",
                                              aws_attributes = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      availability =
                                                        predicates.isType
                                                          '"String",
                                                      ebs_volume_count =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_iops =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_size =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_throughput =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_type =
                                                        predicates.isType
                                                          '"String",
                                                      first_on_demand =
                                                        predicates.isType
                                                          '"Number",
                                                      instance_profile_arn =
                                                        predicates.isType
                                                          '"String",
                                                      spot_bid_price_percent =
                                                        predicates.isType
                                                          '"Number",
                                                      zone_id =
                                                        predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              azure_attributes =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      availability =
                                                        predicates.isType
                                                          '"String",
                                                      first_on_demand =
                                                        predicates.isType
                                                          '"Number",
                                                      log_analytics_info =
                                                        predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              log_analytics_primary_key =
                                                                predicates.isType
                                                                  '"String",
                                                              log_analytics_workspace_id =
                                                                predicates.isType
                                                                  '"String",
                                                            }
                                                            {  }
                                                            false
                                                            predicates.never
                                                          ],
                                                      spot_bid_max_price =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              cluster_log_conf =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      dbfs = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              destination =
                                                                predicates.isType
                                                                  '"String",
                                                            }
                                                            {  }
                                                            false
                                                            predicates.never
                                                          ],
                                                      s3 = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              canned_acl =
                                                                predicates.isType
                                                                  '"String",
                                                              destination =
                                                                predicates.isType
                                                                  '"String",
                                                              enable_encryption =
                                                                predicates.isType
                                                                  '"Bool",
                                                              encryption_type =
                                                                predicates.isType
                                                                  '"String",
                                                              endpoint =
                                                                predicates.isType
                                                                  '"String",
                                                              kms_key =
                                                                predicates.isType
                                                                  '"String",
                                                              region =
                                                                predicates.isType
                                                                  '"String",
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
                                              cluster_name = predicates.isType
                                                  '"String",
                                              cluster_source = predicates.isType
                                                  '"String",
                                              custom_tags = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              data_security_mode =
                                                predicates.isType '"String",
                                              docker_image = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      basic_auth =
                                                        predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              password =
                                                                predicates.isType
                                                                  '"String",
                                                              username =
                                                                predicates.isType
                                                                  '"String",
                                                            }
                                                            {  }
                                                            false
                                                            predicates.never
                                                          ],
                                                      url = predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              driver_instance_pool_id =
                                                predicates.isType '"String",
                                              driver_node_type_id =
                                                predicates.isType '"String",
                                              enable_elastic_disk =
                                                predicates.isType '"Bool",
                                              enable_local_disk_encryption =
                                                predicates.isType '"Bool",
                                              gcp_attributes = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      availability =
                                                        predicates.isType
                                                          '"String",
                                                      boot_disk_size =
                                                        predicates.isType
                                                          '"Number",
                                                      google_service_account =
                                                        predicates.isType
                                                          '"String",
                                                      local_ssd_count =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              init_scripts = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.record
                                                      {
                                                        dbfs = predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                        s3 = predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                canned_acl =
                                                                  predicates.isType
                                                                    '"String",
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                                enable_encryption =
                                                                  predicates.isType
                                                                    '"Bool",
                                                                encryption_type =
                                                                  predicates.isType
                                                                    '"String",
                                                                endpoint =
                                                                  predicates.isType
                                                                    '"String",
                                                                kms_key =
                                                                  predicates.isType
                                                                    '"String",
                                                                region =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                        volumes =
                                                          predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                        workspace =
                                                          predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                      }
                                                      {  }
                                                      false
                                                      predicates.never
                                                    ])
                                                  ],
                                              instance_pool_id =
                                                predicates.isType '"String",
                                              node_type_id = predicates.isType
                                                  '"String",
                                              num_workers = predicates.isType
                                                  '"Number",
                                              policy_id = predicates.isType
                                                  '"String",
                                              runtime_engine = predicates.isType
                                                  '"String",
                                              single_user_name =
                                                predicates.isType '"String",
                                              spark_conf = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              spark_env_vars = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              spark_version = predicates.isType
                                                  '"String",
                                              ssh_public_keys = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              workload_type = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      clients = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              jobs =
                                                                predicates.isType
                                                                  '"Bool",
                                                              notebooks =
                                                                predicates.isType
                                                                  '"Bool",
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
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            max_concurrent_runs = predicates.isType '"Number",
                            name = predicates.isType '"String",
                            notification_settings = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    no_alert_for_canceled_runs =
                                      predicates.isType '"Bool",
                                    no_alert_for_skipped_runs =
                                      predicates.isType '"Bool",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            parameters = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required
                                    [ "default", "name" ],
                                    predicates.records.record
                                    {
                                      "default" = predicates.isType '"String",
                                      name = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            permissions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "level" ],
                                    predicates.records.record
                                    {
                                      group_name = predicates.isType '"String",
                                      level = predicates.isType '"String",
                                      service_principal_name = predicates.isType
                                          '"String",
                                      user_name = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            run_as = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    service_principal_name = predicates.isType
                                        '"String",
                                    user_name = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            schedule = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "quartz_cron_expression", "timezone_id" ],
                                  predicates.records.record
                                  {
                                    pause_status = predicates.isType '"String",
                                    quartz_cron_expression = predicates.isType
                                        '"String",
                                    timezone_id = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            tags = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record {  } {  } true
                                  (predicates.isType '"String")
                                ],
                            tasks = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "task_key" ],
                                    predicates.records.record
                                    {
                                      compute_key = predicates.isType '"String",
                                      condition_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              left = predicates.isType
                                                  '"String",
                                              op = predicates.isType '"String",
                                              right = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      dbt_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "commands" ],
                                            predicates.records.record
                                            {
                                              catalog = predicates.isType
                                                  '"String",
                                              commands = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              profiles_directory =
                                                predicates.isType '"String",
                                              project_directory =
                                                predicates.isType '"String",
                                              schema = predicates.isType
                                                  '"String",
                                              warehouse_id = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      depends_on = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.required
                                              [ "task_key" ],
                                              predicates.records.record
                                              {
                                                outcome = predicates.isType
                                                    '"String",
                                                task_key = predicates.isType
                                                    '"String",
                                              }
                                              {  }
                                              false
                                              predicates.never
                                            ])
                                          ],
                                      description = predicates.isType '"String",
                                      email_notifications = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              on_duration_warning_threshold_exceeded =
                                                predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              on_failure = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              on_start = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              on_success = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      existing_cluster_id = predicates.isType
                                          '"String",
                                      health = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              rules = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.record
                                                      {
                                                        metric =
                                                          predicates.isType
                                                            '"String",
                                                        op = predicates.isType
                                                            '"String",
                                                        value =
                                                          predicates.isType
                                                            '"Number",
                                                      }
                                                      {  }
                                                      false
                                                      predicates.never
                                                    ])
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      job_cluster_key = predicates.isType
                                          '"String",
                                      libraries = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                cran = predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.required
                                                      [ "package" ],
                                                      predicates.records.record
                                                      {
                                                        package =
                                                          predicates.isType
                                                            '"String",
                                                        repo = predicates.isType
                                                            '"String",
                                                      }
                                                      {  }
                                                      false
                                                      predicates.never
                                                    ],
                                                egg = predicates.isType
                                                    '"String",
                                                jar = predicates.isType
                                                    '"String",
                                                maven = predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.required
                                                      [ "coordinates" ],
                                                      predicates.records.record
                                                      {
                                                        coordinates =
                                                          predicates.isType
                                                            '"String",
                                                        exclusions =
                                                          predicates.allOf
                                                            [
                                                              predicates.isType
                                                              '"Array",
                                                              predicates.arrays.arrayOf
                                                              (predicates.isType
                                                              '"String")
                                                            ],
                                                        repo = predicates.isType
                                                            '"String",
                                                      }
                                                      {  }
                                                      false
                                                      predicates.never
                                                    ],
                                                pypi = predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.required
                                                      [ "package" ],
                                                      predicates.records.record
                                                      {
                                                        package =
                                                          predicates.isType
                                                            '"String",
                                                        repo = predicates.isType
                                                            '"String",
                                                      }
                                                      {  }
                                                      false
                                                      predicates.never
                                                    ],
                                                whl = predicates.isType
                                                    '"String",
                                              }
                                              {  }
                                              false
                                              predicates.never
                                            ])
                                          ],
                                      max_retries = predicates.isType '"Number",
                                      min_retry_interval_millis =
                                        predicates.isType '"Number",
                                      new_cluster = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              autoscale = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [
                                                      "max_workers",
                                                      "min_workers"
                                                    ],
                                                    predicates.records.record
                                                    {
                                                      max_workers =
                                                        predicates.isType
                                                          '"Number",
                                                      min_workers =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              autotermination_minutes =
                                                predicates.isType '"Number",
                                              aws_attributes = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      availability =
                                                        predicates.isType
                                                          '"String",
                                                      ebs_volume_count =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_iops =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_size =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_throughput =
                                                        predicates.isType
                                                          '"Number",
                                                      ebs_volume_type =
                                                        predicates.isType
                                                          '"String",
                                                      first_on_demand =
                                                        predicates.isType
                                                          '"Number",
                                                      instance_profile_arn =
                                                        predicates.isType
                                                          '"String",
                                                      spot_bid_price_percent =
                                                        predicates.isType
                                                          '"Number",
                                                      zone_id =
                                                        predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              azure_attributes =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      availability =
                                                        predicates.isType
                                                          '"String",
                                                      first_on_demand =
                                                        predicates.isType
                                                          '"Number",
                                                      log_analytics_info =
                                                        predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              log_analytics_primary_key =
                                                                predicates.isType
                                                                  '"String",
                                                              log_analytics_workspace_id =
                                                                predicates.isType
                                                                  '"String",
                                                            }
                                                            {  }
                                                            false
                                                            predicates.never
                                                          ],
                                                      spot_bid_max_price =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              cluster_log_conf =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      dbfs = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              destination =
                                                                predicates.isType
                                                                  '"String",
                                                            }
                                                            {  }
                                                            false
                                                            predicates.never
                                                          ],
                                                      s3 = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              canned_acl =
                                                                predicates.isType
                                                                  '"String",
                                                              destination =
                                                                predicates.isType
                                                                  '"String",
                                                              enable_encryption =
                                                                predicates.isType
                                                                  '"Bool",
                                                              encryption_type =
                                                                predicates.isType
                                                                  '"String",
                                                              endpoint =
                                                                predicates.isType
                                                                  '"String",
                                                              kms_key =
                                                                predicates.isType
                                                                  '"String",
                                                              region =
                                                                predicates.isType
                                                                  '"String",
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
                                              cluster_name = predicates.isType
                                                  '"String",
                                              cluster_source = predicates.isType
                                                  '"String",
                                              custom_tags = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              data_security_mode =
                                                predicates.isType '"String",
                                              docker_image = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      basic_auth =
                                                        predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              password =
                                                                predicates.isType
                                                                  '"String",
                                                              username =
                                                                predicates.isType
                                                                  '"String",
                                                            }
                                                            {  }
                                                            false
                                                            predicates.never
                                                          ],
                                                      url = predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              driver_instance_pool_id =
                                                predicates.isType '"String",
                                              driver_node_type_id =
                                                predicates.isType '"String",
                                              enable_elastic_disk =
                                                predicates.isType '"Bool",
                                              enable_local_disk_encryption =
                                                predicates.isType '"Bool",
                                              gcp_attributes = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      availability =
                                                        predicates.isType
                                                          '"String",
                                                      boot_disk_size =
                                                        predicates.isType
                                                          '"Number",
                                                      google_service_account =
                                                        predicates.isType
                                                          '"String",
                                                      local_ssd_count =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              init_scripts = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.allOf
                                                    [
                                                      predicates.isType 'Record,
                                                      predicates.records.record
                                                      {
                                                        dbfs = predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                        s3 = predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                canned_acl =
                                                                  predicates.isType
                                                                    '"String",
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                                enable_encryption =
                                                                  predicates.isType
                                                                    '"Bool",
                                                                encryption_type =
                                                                  predicates.isType
                                                                    '"String",
                                                                endpoint =
                                                                  predicates.isType
                                                                    '"String",
                                                                kms_key =
                                                                  predicates.isType
                                                                    '"String",
                                                                region =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                        volumes =
                                                          predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                        workspace =
                                                          predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ],
                                                      }
                                                      {  }
                                                      false
                                                      predicates.never
                                                    ])
                                                  ],
                                              instance_pool_id =
                                                predicates.isType '"String",
                                              node_type_id = predicates.isType
                                                  '"String",
                                              num_workers = predicates.isType
                                                  '"Number",
                                              policy_id = predicates.isType
                                                  '"String",
                                              runtime_engine = predicates.isType
                                                  '"String",
                                              single_user_name =
                                                predicates.isType '"String",
                                              spark_conf = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              spark_env_vars = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              spark_version = predicates.isType
                                                  '"String",
                                              ssh_public_keys = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              workload_type = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      clients = predicates.allOf
                                                          [
                                                            predicates.isType
                                                            'Record,
                                                            predicates.records.record
                                                            {
                                                              jobs =
                                                                predicates.isType
                                                                  '"Bool",
                                                              notebooks =
                                                                predicates.isType
                                                                  '"Bool",
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
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      notebook_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "notebook_path" ],
                                            predicates.records.record
                                            {
                                              base_parameters = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              notebook_path = predicates.isType
                                                  '"String",
                                              source = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      notification_settings = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              alert_on_last_attempt =
                                                predicates.isType '"Bool",
                                              no_alert_for_canceled_runs =
                                                predicates.isType '"Bool",
                                              no_alert_for_skipped_runs =
                                                predicates.isType '"Bool",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      pipeline_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              full_refresh = predicates.isType
                                                  '"Bool",
                                              pipeline_id = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      python_wheel_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              entry_point = predicates.isType
                                                  '"String",
                                              named_parameters =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              package_name = predicates.isType
                                                  '"String",
                                              parameters = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      retry_on_timeout = predicates.isType
                                          '"Bool",
                                      run_if = predicates.isType '"String",
                                      run_job_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "job_id" ],
                                            predicates.records.record
                                            {
                                              job_id = predicates.isType
                                                  '"Number",
                                              job_parameters =
                                                predicates.always,
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      spark_jar_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              jar_uri = predicates.isType
                                                  '"String",
                                              main_class_name =
                                                predicates.isType '"String",
                                              parameters = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      spark_python_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "python_file" ],
                                            predicates.records.record
                                            {
                                              parameters = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              python_file = predicates.isType
                                                  '"String",
                                              source = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      spark_submit_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              parameters = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      sql_task = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "warehouse_id" ],
                                            predicates.records.record
                                            {
                                              alert = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [ "alert_id" ],
                                                    predicates.records.record
                                                    {
                                                      alert_id =
                                                        predicates.isType
                                                          '"String",
                                                      pause_subscriptions =
                                                        predicates.isType
                                                          '"Bool",
                                                      subscriptions =
                                                        predicates.allOf
                                                          [
                                                            predicates.isType
                                                            '"Array",
                                                            predicates.arrays.arrayOf
                                                            (predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination_id =
                                                                  predicates.isType
                                                                    '"String",
                                                                user_name =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ])
                                                          ],
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              dashboard = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [ "dashboard_id" ],
                                                    predicates.records.record
                                                    {
                                                      custom_subject =
                                                        predicates.isType
                                                          '"String",
                                                      dashboard_id =
                                                        predicates.isType
                                                          '"String",
                                                      pause_subscriptions =
                                                        predicates.isType
                                                          '"Bool",
                                                      subscriptions =
                                                        predicates.allOf
                                                          [
                                                            predicates.isType
                                                            '"Array",
                                                            predicates.arrays.arrayOf
                                                            (predicates.allOf
                                                            [
                                                              predicates.isType
                                                              'Record,
                                                              predicates.records.record
                                                              {
                                                                destination_id =
                                                                  predicates.isType
                                                                    '"String",
                                                                user_name =
                                                                  predicates.isType
                                                                    '"String",
                                                              }
                                                              {  }
                                                              false
                                                              predicates.never
                                                            ])
                                                          ],
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              file = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [ "path" ],
                                                    predicates.records.record
                                                    {
                                                      path = predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              parameters = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              query = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [ "query_id" ],
                                                    predicates.records.record
                                                    {
                                                      query_id =
                                                        predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              warehouse_id = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      task_key = predicates.isType '"String",
                                      timeout_seconds = predicates.isType
                                          '"Number",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            timeout_seconds = predicates.isType '"Number",
                            trigger = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    file_arrival = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            min_time_between_triggers_seconds =
                                              predicates.isType '"Number",
                                            url = predicates.isType '"String",
                                            wait_after_last_change_seconds =
                                              predicates.isType '"Number",
                                          }
                                          {  }
                                          false
                                          predicates.never
                                        ],
                                    pause_status = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            webhook_notifications = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    on_duration_warning_threshold_exceeded =
                                      predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              id = predicates.isType '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                    on_failure = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              id = predicates.isType '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                    on_start = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              id = predicates.isType '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                    on_success = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              id = predicates.isType '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                  model_serving_endpoints = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "config", "name" ],
                          predicates.records.record
                          {
                            config = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "served_models" ],
                                  predicates.records.record
                                  {
                                    served_models = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [
                                              "model_name",
                                              "model_version",
                                              "scale_to_zero_enabled",
                                              "workload_size"
                                            ],
                                            predicates.records.record
                                            {
                                              environment_vars =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {  }
                                                    {  }
                                                    true
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              instance_profile_arn =
                                                predicates.isType '"String",
                                              model_name = predicates.isType
                                                  '"String",
                                              model_version = predicates.isType
                                                  '"String",
                                              name = predicates.isType
                                                  '"String",
                                              scale_to_zero_enabled =
                                                predicates.isType '"Bool",
                                              workload_size = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                    traffic_config = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            routes = predicates.allOf
                                                [
                                                  predicates.isType '"Array",
                                                  predicates.arrays.arrayOf
                                                  (predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.required
                                                    [
                                                      "served_model_name",
                                                      "traffic_percentage"
                                                    ],
                                                    predicates.records.record
                                                    {
                                                      served_model_name =
                                                        predicates.isType
                                                          '"String",
                                                      traffic_percentage =
                                                        predicates.isType
                                                          '"Number",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ])
                                                ],
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
                            name = predicates.isType '"String",
                            permissions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "level" ],
                                    predicates.records.record
                                    {
                                      group_name = predicates.isType '"String",
                                      level = predicates.isType '"String",
                                      service_principal_name = predicates.isType
                                          '"String",
                                      user_name = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                  models = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            creation_timestamp = predicates.isType '"Number",
                            description = predicates.isType '"String",
                            last_updated_timestamp = predicates.isType
                                '"Number",
                            latest_versions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      creation_timestamp = predicates.isType
                                          '"Number",
                                      current_stage = predicates.isType
                                          '"String",
                                      description = predicates.isType '"String",
                                      last_updated_timestamp = predicates.isType
                                          '"Number",
                                      name = predicates.isType '"String",
                                      run_id = predicates.isType '"String",
                                      run_link = predicates.isType '"String",
                                      source = predicates.isType '"String",
                                      status = predicates.isType '"String",
                                      status_message = predicates.isType
                                          '"String",
                                      tags = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record
                                              {
                                                key = predicates.isType
                                                    '"String",
                                                value = predicates.isType
                                                    '"String",
                                              }
                                              {  }
                                              false
                                              predicates.never
                                            ])
                                          ],
                                      user_id = predicates.isType '"String",
                                      version = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            name = predicates.isType '"String",
                            permissions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "level" ],
                                    predicates.records.record
                                    {
                                      group_name = predicates.isType '"String",
                                      level = predicates.isType '"String",
                                      service_principal_name = predicates.isType
                                          '"String",
                                      user_name = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            tags = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      key = predicates.isType '"String",
                                      value = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            user_id = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                  pipelines = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            catalog = predicates.isType '"String",
                            channel = predicates.isType '"String",
                            clusters = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      apply_policy_default_values =
                                        predicates.isType '"Bool",
                                      autoscale = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "max_workers", "min_workers" ],
                                            predicates.records.record
                                            {
                                              max_workers = predicates.isType
                                                  '"Number",
                                              min_workers = predicates.isType
                                                  '"Number",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      aws_attributes = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              availability = predicates.isType
                                                  '"String",
                                              ebs_volume_count =
                                                predicates.isType '"Number",
                                              ebs_volume_iops =
                                                predicates.isType '"Number",
                                              ebs_volume_size =
                                                predicates.isType '"Number",
                                              ebs_volume_throughput =
                                                predicates.isType '"Number",
                                              ebs_volume_type =
                                                predicates.isType '"String",
                                              first_on_demand =
                                                predicates.isType '"Number",
                                              instance_profile_arn =
                                                predicates.isType '"String",
                                              spot_bid_price_percent =
                                                predicates.isType '"Number",
                                              zone_id = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      azure_attributes = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              availability = predicates.isType
                                                  '"String",
                                              first_on_demand =
                                                predicates.isType '"Number",
                                              log_analytics_info =
                                                predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      log_analytics_primary_key =
                                                        predicates.isType
                                                          '"String",
                                                      log_analytics_workspace_id =
                                                        predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              spot_bid_max_price =
                                                predicates.isType '"Number",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      cluster_log_conf = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              dbfs = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      destination =
                                                        predicates.isType
                                                          '"String",
                                                    }
                                                    {  }
                                                    false
                                                    predicates.never
                                                  ],
                                              s3 = predicates.allOf
                                                  [
                                                    predicates.isType 'Record,
                                                    predicates.records.record
                                                    {
                                                      canned_acl =
                                                        predicates.isType
                                                          '"String",
                                                      destination =
                                                        predicates.isType
                                                          '"String",
                                                      enable_encryption =
                                                        predicates.isType
                                                          '"Bool",
                                                      encryption_type =
                                                        predicates.isType
                                                          '"String",
                                                      endpoint =
                                                        predicates.isType
                                                          '"String",
                                                      kms_key =
                                                        predicates.isType
                                                          '"String",
                                                      region = predicates.isType
                                                          '"String",
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
                                      custom_tags = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record {  } {  }
                                            true
                                            (predicates.isType '"String")
                                          ],
                                      driver_instance_pool_id =
                                        predicates.isType '"String",
                                      driver_node_type_id = predicates.isType
                                          '"String",
                                      gcp_attributes = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              availability = predicates.isType
                                                  '"String",
                                              boot_disk_size = predicates.isType
                                                  '"Number",
                                              google_service_account =
                                                predicates.isType '"String",
                                              local_ssd_count =
                                                predicates.isType '"Number",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      instance_pool_id = predicates.isType
                                          '"String",
                                      label = predicates.isType '"String",
                                      node_type_id = predicates.isType
                                          '"String",
                                      num_workers = predicates.isType '"Number",
                                      policy_id = predicates.isType '"String",
                                      spark_conf = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record {  } {  }
                                            true
                                            (predicates.isType '"String")
                                          ],
                                      spark_env_vars = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record {  } {  }
                                            true
                                            (predicates.isType '"String")
                                          ],
                                      ssh_public_keys = predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.isType '"String")
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            configuration = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record {  } {  } true
                                  (predicates.isType '"String")
                                ],
                            continuous = predicates.isType '"Bool",
                            development = predicates.isType '"Bool",
                            edition = predicates.isType '"String",
                            filters = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    exclude = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    include = predicates.allOf
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
                            id = predicates.isType '"String",
                            libraries = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      file = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              path = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      jar = predicates.isType '"String",
                                      maven = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "coordinates" ],
                                            predicates.records.record
                                            {
                                              coordinates = predicates.isType
                                                  '"String",
                                              exclusions = predicates.allOf
                                                  [
                                                    predicates.isType '"Array",
                                                    predicates.arrays.arrayOf
                                                    (predicates.isType
                                                    '"String")
                                                  ],
                                              repo = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                      notebook = predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              path = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            name = predicates.isType '"String",
                            permissions = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required [ "level" ],
                                    predicates.records.record
                                    {
                                      group_name = predicates.isType '"String",
                                      level = predicates.isType '"String",
                                      service_principal_name = predicates.isType
                                          '"String",
                                      user_name = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            photon = predicates.isType '"Bool",
                            serverless = predicates.isType '"Bool",
                            storage = predicates.isType '"String",
                            target = predicates.isType '"String",
                            trigger = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    cron = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.record
                                          {
                                            quartz_cron_schedule =
                                              predicates.isType '"String",
                                            timezone_id = predicates.isType
                                                '"String",
                                          }
                                          {  }
                                          false
                                          predicates.never
                                        ],
                                    manual = predicates.always,
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          run_as = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  service_principal_name = predicates.isType '"String",
                  user_name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          variables = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          workspace = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifact_path = predicates.isType '"String",
                  auth_type = predicates.isType '"String",
                  azure_client_id = predicates.isType '"String",
                  azure_environment = predicates.isType '"String",
                  azure_login_app_id = predicates.isType '"String",
                  azure_tenant_id = predicates.isType '"String",
                  azure_use_msi = predicates.isType '"Bool",
                  azure_workspace_resource_id = predicates.isType '"String",
                  client_id = predicates.isType '"String",
                  file_path = predicates.isType '"String",
                  google_service_account = predicates.isType '"String",
                  host = predicates.isType '"String",
                  profile = predicates.isType '"String",
                  root_path = predicates.isType '"String",
                  state_path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        }
        {  }
        false
        predicates.never
      ])
    ])
    | optional,
  variables
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          "default" = predicates.isType '"String",
          description = predicates.isType '"String",
        }
        {  }
        false
        predicates.never
      ])
    ])
    | optional,
  workspace
    | {
      artifact_path
        | String
        | doc m%"
        The remote path to synchronize build artifacts to. This defaults to `${workspace.root}/artifacts`
        "%
        | optional,
      auth_type | String | optional,
      azure_client_id | String | optional,
      azure_environment
        | String
        | doc m%"
        Azure environment, one of (Public, UsGov, China, Germany).
        "%
        | optional,
      azure_login_app_id
        | String
        | doc m%"
        Azure Login Application ID.
        "%
        | optional,
      azure_tenant_id | String | optional,
      azure_use_msi | Bool | optional,
      azure_workspace_resource_id
        | String
        | doc m%"
        Azure Resource Manager ID for Azure Databricks workspace.
        "%
        | optional,
      client_id | String | optional,
      file_path
        | String
        | doc m%"
        The remote path to synchronize local files artifacts to. This defaults to `${workspace.root}/files`
        "%
        | optional,
      google_service_account | String | optional,
      host
        | String
        | doc m%"
        Host url of the workspace.
        "%
        | optional,
      profile
        | String
        | doc m%"
        Connection profile to use. By default profiles are specified in ~/.databrickscfg.
        "%
        | optional,
      root_path
        | String
        | doc m%"
        The base location for synchronizing files, artifacts and state. Defaults to `/Users/jane@doe.com/.bundle/${bundle.name}/${bundle.target}`
        "%
        | optional,
      state_path
        | String
        | doc m%"
        The remote path to synchronize bundle state to. This defaults to `${workspace.root}/state`
        "%
        | optional,
    }
    | doc m%"
    Configures which workspace to connect to and locations for files, state, and similar locations within the workspace file tree.
    "%
    | optional,
}