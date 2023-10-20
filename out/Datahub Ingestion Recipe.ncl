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
          AllowDenyPattern
            | doc m%"
            A class to store allow deny regexes
            "%
            = {
                allow
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of regex patterns to include in ingestion
                  "%
                  | optional,
                deny
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of regex patterns to exclude from ingestion.
                  "%
                  | optional,
                ignoreCase
                  | Bool
                  | doc m%"
                  Whether to ignore case sensitivity during pattern matching.
                  "%
                  | optional,
              },
          AwsAssumeRoleConfig = {
                ExternalId
                  | String
                  | doc m%"
                  External ID to use when assuming the role.
                  "%
                  | optional,
                RoleArn
                  | String
                  | doc m%"
                  ARN of the role to assume.
                  "%,
                ..
              },
          AwsConnectionConfig
            | doc m%"
            Common AWS credentials config.
            
            Currently used by:
                - Glue source
                - SageMaker source
                - dbt source
            "%
            = {
                aws_access_key_id
                  | String
                  | doc m%"
                  AWS access key ID. Can be auto-detected, see [the AWS boto3 docs](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html) for details.
                  "%
                  | optional,
                aws_endpoint_url
                  | String
                  | doc m%"
                  The AWS service endpoint. This is normally [constructed automatically](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/core/session.html), but can be overridden here.
                  "%
                  | optional,
                aws_profile
                  | String
                  | doc m%"
                  Named AWS profile to use. Only used if access key / secret are unset. If not set the default will be used
                  "%
                  | optional,
                aws_proxy
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A set of proxy configs to use with AWS. See the [botocore.config](https://botocore.amazonaws.com/v1/documentation/api/latest/reference/config.html) docs for details.
                  "%
                  | optional,
                aws_region
                  | String
                  | doc m%"
                  AWS region code.
                  "%,
                aws_role
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.AwsAssumeRoleConfig
                      ])
                    ]
                  ])
                  | doc m%"
                  AWS roles to assume. If using the string format, the role ARN can be specified directly. If using the object format, the role can be specified in the RoleArn field and additional available arguments are documented at https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sts.html?highlight=assume_role#STS.Client.assume_role
                  "%
                  | optional,
                aws_secret_access_key
                  | String
                  | doc m%"
                  AWS secret access key. Can be auto-detected, see [the AWS boto3 docs](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html) for details.
                  "%
                  | optional,
                aws_session_token
                  | String
                  | doc m%"
                  AWS session token. Can be auto-detected, see [the AWS boto3 docs](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html) for details.
                  "%
                  | optional,
              },
          BaseUsageConfig = {
                bucket_duration
                  | predicates.contract_from_predicate
                  definitions.predicate.BucketDuration
                  | doc m%"
                  Size of the time window to aggregate usage stats.
                  "%
                  | optional,
                end_time
                  | String
                  | doc m%"
                  Latest date of lineage/usage to consider. Default: Current time in UTC
                  "%
                  | optional,
                format_sql_queries
                  | Bool
                  | doc m%"
                  Whether to format sql queries
                  "%
                  | optional,
                include_operational_stats
                  | Bool
                  | doc m%"
                  Whether to display operational stats.
                  "%
                  | optional,
                include_read_operational_stats
                  | Bool
                  | doc m%"
                  Whether to report read operational stats. Experimental.
                  "%
                  | optional,
                include_top_n_queries
                  | Bool
                  | doc m%"
                  Whether to ingest the top_n_queries.
                  "%
                  | optional,
                start_time
                  | String
                  | doc m%"
                  Earliest date of lineage/usage to consider. Default: Last full day in UTC (or hour, depending on `bucket_duration`). You can also specify relative time with respect to end_time such as '-7 days' Or '-7d'.
                  "%
                  | optional,
                top_n_queries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  Number of top queries to save to each table.
                  "%
                  | optional,
                user_email_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for user emails to filter in usage.
                  "%
                  | optional,
              },
          BigQueryCredential = {
                auth_provider_x509_cert_url
                  | String
                  | doc m%"
                  Auth provider x509 certificate url
                  "%
                  | optional,
                auth_uri
                  | String
                  | doc m%"
                  Authentication uri
                  "%
                  | optional,
                client_email
                  | String
                  | doc m%"
                  Client email
                  "%,
                client_id
                  | String
                  | doc m%"
                  Client Id
                  "%,
                client_x509_cert_url
                  | String
                  | doc m%"
                  If not set it will be default to https://www.googleapis.com/robot/v1/metadata/x509/client_email
                  "%
                  | optional,
                private_key
                  | String
                  | doc m%"
                  Private key in a form of '-----BEGIN PRIVATE KEY-----\nprivate-key\n-----END PRIVATE KEY-----\n'
                  "%,
                private_key_id
                  | String
                  | doc m%"
                  Private key id
                  "%,
                project_id
                  | String
                  | doc m%"
                  Project id to set the credentials
                  "%,
                token_uri
                  | String
                  | doc m%"
                  Token uri
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Authentication type
                  "%
                  | optional,
              },
          BigQueryUsageConfig = {
                apply_view_usage_to_tables
                  | Bool
                  | doc m%"
                  Whether to apply view's usage to its base tables. If set to False, uses sql parser and applies usage to views / tables mentioned in the query. If set to True, usage is applied to base tables only.
                  "%
                  | optional,
                bucket_duration
                  | predicates.contract_from_predicate
                  definitions.predicate.BucketDuration
                  | doc m%"
                  Size of the time window to aggregate usage stats.
                  "%
                  | optional,
                end_time
                  | String
                  | doc m%"
                  Latest date of lineage/usage to consider. Default: Current time in UTC
                  "%
                  | optional,
                format_sql_queries
                  | Bool
                  | doc m%"
                  Whether to format sql queries
                  "%
                  | optional,
                include_operational_stats
                  | Bool
                  | doc m%"
                  Whether to display operational stats.
                  "%
                  | optional,
                include_read_operational_stats
                  | Bool
                  | doc m%"
                  Whether to report read operational stats. Experimental.
                  "%
                  | optional,
                include_top_n_queries
                  | Bool
                  | doc m%"
                  Whether to ingest the top_n_queries.
                  "%
                  | optional,
                max_query_duration
                  | Number
                  | doc m%"
                  Correction to pad start_time and end_time with. For handling the case where the read happens within our time range but the query completion event is delayed and happens after the configured end time.
                  "%
                  | optional,
                start_time
                  | String
                  | doc m%"
                  Earliest date of lineage/usage to consider. Default: Last full day in UTC (or hour, depending on `bucket_duration`). You can also specify relative time with respect to end_time such as '-7 days' Or '-7d'.
                  "%
                  | optional,
                top_n_queries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  Number of top queries to save to each table.
                  "%
                  | optional,
                user_email_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for user emails to filter in usage.
                  "%
                  | optional,
              },
          BucketDuration
            | doc m%"
            An enumeration.
            "%
            = std.contract.Sequence [ std.enum.TagOrString, [| 'HOUR, 'DAY |] ],
          ClassificationConfig = {
                classifiers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DynamicTypedClassifierConfig
                  ])
                  | doc m%"
                  Classifiers to use to auto-detect glossary terms. If more than one classifier, infotype predictions from the classifier defined later in sequence take precedance.
                  "%
                  | optional,
                column_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter columns for classification. This is used in combination with other patterns in parent config. Specify regex to match the column name in `database.schema.table.column` format.
                  "%
                  | optional,
                enabled
                  | Bool
                  | doc m%"
                  Whether classification should be used to auto-detect glossary terms
                  "%
                  | optional,
                info_type_to_term
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Optional mapping to provide glossary term identifier for info type
                  "%
                  | optional,
                max_workers
                  | std.number.Integer
                  | doc m%"
                  Number of worker threads to use for classification. Set to 1 to disable.
                  "%
                  | optional,
                sample_size
                  | std.number.Integer
                  | doc m%"
                  Number of sample values used for classification.
                  "%
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables for classification. This is used in combination with other patterns in parent config. Specify regex to match the entire table name in `database.schema.table` format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          CollapseUrns = {
                urns_suffix_regex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of regex patterns to remove from the name of the URN. All of the indices before removal of URNs are considered as the same dataset. These are applied in order for each URN.
                          The main case where you would want to have multiple of these if the name where you are trying to remove suffix from have different formats.
                          e.g. ending with -YYYY-MM-DD as well as ending -epochtime would require you to have 2 regex patterns to remove the suffixes across all URNs.
                  "%
                  | optional,
              },
          DBTEntitiesEnabled
            | doc m%"
            Controls which dbt entities are going to be emitted by this source
            "%
            = {
                models
                  | predicates.contract_from_predicate
                  definitions.predicate.EmitDirective
                  | doc m%"
                  Emit metadata for dbt models when set to Yes or Only
                  "%
                  | optional,
                seeds
                  | predicates.contract_from_predicate
                  definitions.predicate.EmitDirective
                  | doc m%"
                  Emit metadata for dbt seeds when set to Yes or Only
                  "%
                  | optional,
                snapshots
                  | predicates.contract_from_predicate
                  definitions.predicate.EmitDirective
                  | doc m%"
                  Emit metadata for dbt snapshots when set to Yes or Only
                  "%
                  | optional,
                sources
                  | predicates.contract_from_predicate
                  definitions.predicate.EmitDirective
                  | doc m%"
                  Emit metadata for dbt sources when set to Yes or Only
                  "%
                  | optional,
                test_definitions
                  | predicates.contract_from_predicate
                  definitions.predicate.EmitDirective
                  | doc m%"
                  Emit metadata for test definitions when enabled when set to Yes or Only
                  "%
                  | optional,
                test_results
                  | predicates.contract_from_predicate
                  definitions.predicate.EmitDirective
                  | doc m%"
                  Emit metadata for test results when set to Yes or Only
                  "%
                  | optional,
              },
          DataLakeProfilerConfig = {
                enabled
                  | Bool
                  | doc m%"
                  Whether profiling should be done.
                  "%
                  | optional,
                include_field_distinct_value_frequencies
                  | Bool
                  | doc m%"
                  Whether to profile for distinct value frequencies.
                  "%
                  | optional,
                include_field_histogram
                  | Bool
                  | doc m%"
                  Whether to profile for the histogram for numeric fields.
                  "%
                  | optional,
                include_field_max_value
                  | Bool
                  | doc m%"
                  Whether to profile for the max value of numeric columns.
                  "%
                  | optional,
                include_field_mean_value
                  | Bool
                  | doc m%"
                  Whether to profile for the mean value of numeric columns.
                  "%
                  | optional,
                include_field_median_value
                  | Bool
                  | doc m%"
                  Whether to profile for the median value of numeric columns.
                  "%
                  | optional,
                include_field_min_value
                  | Bool
                  | doc m%"
                  Whether to profile for the min value of numeric columns.
                  "%
                  | optional,
                include_field_null_count
                  | Bool
                  | doc m%"
                  Whether to profile for the number of nulls for each column.
                  "%
                  | optional,
                include_field_quantiles
                  | Bool
                  | doc m%"
                  Whether to profile for the quantiles of numeric columns.
                  "%
                  | optional,
                include_field_sample_values
                  | Bool
                  | doc m%"
                  Whether to profile for the sample values for all columns.
                  "%
                  | optional,
                include_field_stddev_value
                  | Bool
                  | doc m%"
                  Whether to profile for the standard deviation of numeric columns.
                  "%
                  | optional,
                max_number_of_fields_to_profile
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  A positive integer that specifies the maximum number of columns to profile for any table. `None` implies all columns. The cost of profiling goes up significantly as the number of columns to profile goes up.
                  "%
                  | optional,
                operation_config
                  | predicates.contract_from_predicate
                  definitions.predicate.OperationConfig
                  | doc m%"
                  Experimental feature. To specify operation configs.
                  "%
                  | optional,
                profile_table_level_only
                  | Bool
                  | doc m%"
                  Whether to perform profiling at table-level only or include column-level profiling as well.
                  "%
                  | optional,
              },
          DatabaseId = {
                database
                  | String
                  | doc m%"
                  Database created from share in consumer account.
                  "%,
                platform_instance
                  | String
                  | doc m%"
                  Platform instance of consumer snowflake account.
                  "%
                  | optional,
              },
          DynamicTypedClassifierConfig = {
                config
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  The configuration required for initializing the classifier. If not specified, uses defaults for classifer type.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  The type of the classifier to use. For DataHub,  use `datahub`
                  "%,
              },
          DynamicTypedStateProviderConfig = {
                config
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  The configuration required for initializing the state provider. Default: The datahub_api config if set at pipeline level. Otherwise, the default DatahubClientConfig. See the defaults (https://github.com/datahub-project/datahub/blob/master/metadata-ingestion/src/datahub/ingestion/graph/client.py#L19).
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  The type of the state provider to use. For DataHub use `datahub`
                  "%,
              },
          ElasticProfiling = {
                enabled
                  | Bool
                  | doc m%"
                  Whether to enable profiling for the elastic search source.
                  "%
                  | optional,
                operation_config
                  | predicates.contract_from_predicate
                  definitions.predicate.OperationConfig
                  | doc m%"
                  Experimental feature. To specify operation configs.
                  "%
                  | optional,
              },
          EmitDirective
            | doc m%"
            A holder for directives for emission for specific types of entities
            "%
            = predicates.contract_from_predicate
              definitions.predicate.EmitDirective,
          FileReadMode
            | doc m%"
            An enumeration.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.FileReadMode,
          GEProfilingConfig = {
                catch_exceptions | Bool | optional,
                enabled
                  | Bool
                  | doc m%"
                  Whether profiling should be done.
                  "%
                  | optional,
                field_sample_values_limit
                  | std.number.Integer
                  | doc m%"
                  Upper limit for number of sample values to collect for all columns.
                  "%
                  | optional,
                include_field_distinct_count
                  | Bool
                  | doc m%"
                  Whether to profile for the number of distinct values for each column.
                  "%
                  | optional,
                include_field_distinct_value_frequencies
                  | Bool
                  | doc m%"
                  Whether to profile for distinct value frequencies.
                  "%
                  | optional,
                include_field_histogram
                  | Bool
                  | doc m%"
                  Whether to profile for the histogram for numeric fields.
                  "%
                  | optional,
                include_field_max_value
                  | Bool
                  | doc m%"
                  Whether to profile for the max value of numeric columns.
                  "%
                  | optional,
                include_field_mean_value
                  | Bool
                  | doc m%"
                  Whether to profile for the mean value of numeric columns.
                  "%
                  | optional,
                include_field_median_value
                  | Bool
                  | doc m%"
                  Whether to profile for the median value of numeric columns.
                  "%
                  | optional,
                include_field_min_value
                  | Bool
                  | doc m%"
                  Whether to profile for the min value of numeric columns.
                  "%
                  | optional,
                include_field_null_count
                  | Bool
                  | doc m%"
                  Whether to profile for the number of nulls for each column.
                  "%
                  | optional,
                include_field_quantiles
                  | Bool
                  | doc m%"
                  Whether to profile for the quantiles of numeric columns.
                  "%
                  | optional,
                include_field_sample_values
                  | Bool
                  | doc m%"
                  Whether to profile for the sample values for all columns.
                  "%
                  | optional,
                include_field_stddev_value
                  | Bool
                  | doc m%"
                  Whether to profile for the standard deviation of numeric columns.
                  "%
                  | optional,
                limit
                  | std.number.Integer
                  | doc m%"
                  Max number of documents to profile. By default, profiles all documents.
                  "%
                  | optional,
                max_number_of_fields_to_profile
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  A positive integer that specifies the maximum number of columns to profile for any table. `None` implies all columns. The cost of profiling goes up significantly as the number of columns to profile goes up.
                  "%
                  | optional,
                max_workers
                  | std.number.Integer
                  | doc m%"
                  Number of worker threads to use for profiling. Set to 1 to disable.
                  "%
                  | optional,
                offset
                  | std.number.Integer
                  | doc m%"
                  Offset in documents to profile. By default, uses no offset.
                  "%
                  | optional,
                operation_config
                  | predicates.contract_from_predicate
                  definitions.predicate.OperationConfig
                  | doc m%"
                  Experimental feature. To specify operation configs.
                  "%
                  | optional,
                partition_datetime
                  | String
                  | doc m%"
                  If specified, profile only the partition which matches this datetime. If not specified, profile the latest partition. Only Bigquery supports this.
                  "%
                  | optional,
                partition_profiling_enabled
                  | Bool
                  | doc m%"
                  Whether to profile partitioned tables. Only BigQuery supports this. If enabled, latest partition data is used for profiling.
                  "%
                  | optional,
                profile_if_updated_since_days
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  Profile table only if it has been updated since these many number of days. If set to `null`, no constraint of last modified time for tables to profile. Supported only in `snowflake` and `BigQuery`.
                  "%
                  | optional,
                profile_table_level_only
                  | Bool
                  | doc m%"
                  Whether to perform profiling at table-level only, or include column-level profiling as well.
                  "%
                  | optional,
                profile_table_row_count_estimate_only
                  | Bool
                  | doc m%"
                  Use an approximate query for row count. This will be much faster but slightly less accurate. Only supported for Postgres and MySQL. 
                  "%
                  | optional,
                profile_table_row_limit
                  | std.number.Integer
                  | doc m%"
                  Profile tables only if their row count is less then specified count. If set to `null`, no limit on the row count of tables to profile. Supported only in `snowflake` and `BigQuery`
                  "%
                  | optional,
                profile_table_size_limit
                  | std.number.Integer
                  | doc m%"
                  Profile tables only if their size is less then specified GBs. If set to `null`, no limit on the size of tables to profile. Supported only in `snowflake` and `BigQuery`
                  "%
                  | optional,
                query_combiner_enabled
                  | Bool
                  | doc m%"
                  *This feature is still experimental and can be disabled if it causes issues.* Reduces the total number of queries issued and speeds up profiling by dynamically combining SQL queries where possible.
                  "%
                  | optional,
                report_dropped_profiles
                  | Bool
                  | doc m%"
                  Whether to report datasets or dataset columns which were not profiled. Set to `True` for debugging purposes.
                  "%
                  | optional,
                sample_size
                  | std.number.Integer
                  | doc m%"
                  Number of rows to be sampled from table for column level profiling.Applicable only if `use_sampling` is set to True.
                  "%
                  | optional,
                turn_off_expensive_profiling_metrics
                  | Bool
                  | doc m%"
                  Whether to turn off expensive profiling or not. This turns off profiling for quantiles, distinct_value_frequencies, histogram & sample_values. This also limits maximum number of fields being profiled to 10.
                  "%
                  | optional,
                use_sampling
                  | Bool
                  | doc m%"
                  Whether to profile column level stats on sample of table. Only BigQuery and Snowflake support this. If enabled, profiling is done on rows sampled from table. Sampling is not done for smaller tables. 
                  "%
                  | optional,
              },
          GenericConnectorConfig = {
                connector_name | String,
                source_dataset | String,
                source_platform | String,
              },
          GitInfo
            | doc m%"
            A reference to a Git repository, including a deploy key that can be used to clone it.
            "%
            = {
                branch
                  | String
                  | doc m%"
                  Branch on which your files live by default. Typically main or master. This can also be a commit hash.
                  "%
                  | optional,
                deploy_key
                  | String
                  | doc m%"
                  A private key that contains an ssh key that has been configured as a deploy key for this repository. See deploy_key_file if you want to use a file that contains this key.
                  "%
                  | optional,
                deploy_key_file
                  | String
                  | doc m%"
                  A private key file that contains an ssh key that has been configured as a deploy key for this repository. Use a file where possible, else see deploy_key for a config field that accepts a raw string.
                  "%
                  | optional,
                repo
                  | String
                  | doc m%"
                  Name of your Git repo e.g. https://github.com/datahub-project/datahub or https://gitlab.com/gitlab-org/gitlab. If organization/repo is provided, we assume it is a GitHub repo.
                  "%,
                repo_ssh_locator
                  | String
                  | doc m%"
                  The url to call `git clone` on. We infer this for github and gitlab repos, but it is required for other hosts.
                  "%
                  | optional,
                url_template
                  | String
                  | doc m%"
                  Template for generating a URL to a file in the repo e.g. '{repo_url}/blob/{branch}/{file_path}'. We can infer this for GitHub and GitLab repos, and it is otherwise required.It supports the following variables: {repo_url}, {branch}, {file_path}
                  "%
                  | optional,
              },
          GitReference
            | doc m%"
            Reference to a hosted Git repository. Used to generate "view source" links.
            "%
            = {
                branch
                  | String
                  | doc m%"
                  Branch on which your files live by default. Typically main or master. This can also be a commit hash.
                  "%
                  | optional,
                repo
                  | String
                  | doc m%"
                  Name of your Git repo e.g. https://github.com/datahub-project/datahub or https://gitlab.com/gitlab-org/gitlab. If organization/repo is provided, we assume it is a GitHub repo.
                  "%,
                url_template
                  | String
                  | doc m%"
                  Template for generating a URL to a file in the repo e.g. '{repo_url}/blob/{branch}/{file_path}'. We can infer this for GitHub and GitLab repos, and it is otherwise required.It supports the following variables: {repo_url}, {branch}, {file_path}
                  "%
                  | optional,
              },
          GlueProfilingConfig = {
                column_count
                  | String
                  | doc m%"
                  The parameter name for column count in glue table.
                  "%
                  | optional,
                max
                  | String
                  | doc m%"
                  The parameter name for the max value of a column.
                  "%
                  | optional,
                mean
                  | String
                  | doc m%"
                  The parameter name for the mean value of a column.
                  "%
                  | optional,
                median
                  | String
                  | doc m%"
                  The parameter name for the median value of a column.
                  "%
                  | optional,
                min
                  | String
                  | doc m%"
                  The parameter name for the min value of a column.
                  "%
                  | optional,
                null_count
                  | String
                  | doc m%"
                  The parameter name for the count of null values in a column.
                  "%
                  | optional,
                null_proportion
                  | String
                  | doc m%"
                  The parameter name for the proportion of null values in a column.
                  "%
                  | optional,
                operation_config
                  | predicates.contract_from_predicate
                  definitions.predicate.OperationConfig
                  | doc m%"
                  Experimental feature. To specify operation configs.
                  "%
                  | optional,
                partition_patterns
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for filtering partitions for profile. The pattern should be a string like: "{'key':'value'}".
                  "%
                  | optional,
                row_count
                  | String
                  | doc m%"
                  The parameter name for row count in glue table.
                  "%
                  | optional,
                stdev
                  | String
                  | doc m%"
                  The parameter name for the standard deviation of a column.
                  "%
                  | optional,
                unique_count
                  | String
                  | doc m%"
                  The parameter name for the count of unique value in a column.
                  "%
                  | optional,
                unique_proportion
                  | String
                  | doc m%"
                  The parameter name for the proportion of unique values in a column.
                  "%
                  | optional,
              },
          HMACKey = {
                hmac_access_id
                  | String
                  | doc m%"
                  Access ID
                  "%,
                hmac_access_secret
                  | String
                  | doc m%"
                  Secret
                  "%,
              },
          IcebergCatalogConfig
            | doc m%"
            Iceberg catalog config.
            
            https://py.iceberg.apache.org/configuration/
            "%
            = {
                config
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Catalog specific configuration.  See [PyIceberg documentation](https://py.iceberg.apache.org/configuration/) for details.
                  "%,
                name
                  | String
                  | doc m%"
                  Name of catalog
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  Type of catalog.  See [PyIceberg](https://py.iceberg.apache.org/configuration/) for list of possible values.
                  "%,
              },
          IcebergProfilingConfig = {
                enabled
                  | Bool
                  | doc m%"
                  Whether profiling should be done.
                  "%
                  | optional,
                include_field_max_value
                  | Bool
                  | doc m%"
                  Whether to profile for the max value of numeric columns.
                  "%
                  | optional,
                include_field_min_value
                  | Bool
                  | doc m%"
                  Whether to profile for the min value of numeric columns.
                  "%
                  | optional,
                include_field_null_count
                  | Bool
                  | doc m%"
                  Whether to profile for the number of nulls for each column.
                  "%
                  | optional,
                operation_config
                  | predicates.contract_from_predicate
                  definitions.predicate.OperationConfig
                  | doc m%"
                  Experimental feature. To specify operation configs.
                  "%
                  | optional,
              },
          KafkaConsumerConnectionConfig
            | doc m%"
            Configuration class for holding connectivity information for Kafka consumers
            "%
            = {
                bootstrap | String | optional,
                client_timeout_seconds
                  | std.number.Integer
                  | doc m%"
                  The request timeout used when interacting with the Kafka APIs.
                  "%
                  | optional,
                consumer_config
                  | {  .. }
                  | doc m%"
                  Extra consumer config serialized as JSON. These options will be passed into Kafka's DeserializingConsumer. See https://docs.confluent.io/platform/current/clients/confluent-kafka-python/html/index.html#deserializingconsumer and https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md .
                  "%
                  | optional,
                schema_registry_config
                  | {  .. }
                  | doc m%"
                  Extra schema registry config serialized as JSON. These options will be passed into Kafka's SchemaRegistryClient. https://docs.confluent.io/platform/current/clients/confluent-kafka-python/html/index.html?#schemaregistryclient
                  "%
                  | optional,
                schema_registry_url | String | optional,
              },
          LineageMode
            | doc m%"
            An enumeration.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.LineageMode,
          LookerAPIConfig = {
                base_url
                  | String
                  | doc m%"
                  Url to your Looker instance: `https://company.looker.com:19999` or `https://looker.company.com`, or similar. Used for making API calls to Looker and constructing clickable dashboard and chart urls.
                  "%,
                client_id
                  | String
                  | doc m%"
                  Looker API client id.
                  "%,
                client_secret
                  | String
                  | doc m%"
                  Looker API client secret.
                  "%,
                transport_options
                  | predicates.contract_from_predicate
                  definitions.predicate.TransportOptionsConfig
                  | doc m%"
                  Populates the [TransportOptions](https://github.com/looker-open-source/sdk-codegen/blob/94d6047a0d52912ac082eb91616c1e7c379ab262/python/looker_sdk/rtl/transport.py#L70) struct for looker client
                  "%
                  | optional,
              },
          LookerConnectionDefinition = {
                default_db | String,
                default_schema | String | optional,
                platform | String,
                platform_env
                  | String
                  | doc m%"
                  The environment that the platform is located in. Leaving this empty will inherit defaults from the top level Looker configuration
                  "%
                  | optional,
                platform_instance | String | optional,
              },
          LookerNamingPattern = { pattern | String, },
          LookerViewNamingPattern = { pattern | String, },
          ModeAPIConfig = {
                max_attempts
                  | std.number.Integer
                  | doc m%"
                  Maximum number of attempts to retry before failing
                  "%
                  | optional,
                max_retry_interval
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType '"Number" ])
                  | doc m%"
                  Maximum interval to wait when retrying
                  "%
                  | optional,
                retry_backoff_multiplier
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType '"Number" ])
                  | doc m%"
                  Multiplier for exponential backoff when waiting to retry
                  "%
                  | optional,
              },
          NifiAuthType
            | doc m%"
            An enumeration.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.NifiAuthType,
          OAuthConfiguration = {
                authority_url
                  | String
                  | doc m%"
                  Authority url of your identity provider
                  "%,
                client_id
                  | String
                  | doc m%"
                  client id of your registered application
                  "%,
                client_secret
                  | String
                  | doc m%"
                  client secret of the application if use_certificate = false
                  "%
                  | optional,
                encoded_oauth_private_key
                  | String
                  | doc m%"
                  base64 encoded private key content if use_certificate = true
                  "%
                  | optional,
                encoded_oauth_public_key
                  | String
                  | doc m%"
                  base64 encoded certificate content if use_certificate = true
                  "%
                  | optional,
                provider
                  | predicates.contract_from_predicate
                  definitions.predicate.OAuthIdentityProvider
                  | doc m%"
                  Identity provider for oauth.Supported providers are microsoft and okta.
                  "%,
                scopes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  scopes required to connect to snowflake
                  "%,
                use_certificate
                  | Bool
                  | doc m%"
                  Do you want to use certificate and private key to authenticate using oauth
                  "%
                  | optional,
              },
          OAuthIdentityProvider
            | doc m%"
            An enumeration.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.OAuthIdentityProvider,
          OperationConfig = {
                lower_freq_profile_enabled
                  | Bool
                  | doc m%"
                  Whether to do profiling at lower freq or not. This does not do any scheduling just adds additional checks to when not to run profiling.
                  "%
                  | optional,
                profile_date_of_month
                  | std.number.Integer
                  | doc m%"
                  Number between 1 to 31 for date of month (both inclusive). If not specified, defaults to Nothing and this field does not take affect.
                  "%
                  | optional,
                profile_day_of_week
                  | std.number.Integer
                  | doc m%"
                  Number between 0 to 6 for day of week (both inclusive). 0 is Monday and 6 is Sunday. If not specified, defaults to Nothing and this field does not take affect.
                  "%
                  | optional,
              },
          OwnershipMapping = {
                create_corp_user
                  | Bool
                  | doc m%"
                  Whether ingest PowerBI user as Datahub Corpuser
                  "%
                  | optional,
                dataset_configured_by_as_owner
                  | Bool
                  | doc m%"
                  Take PBI dataset configuredBy as dataset owner if exist
                  "%
                  | optional,
                owner_criteria
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Need to have certain authority to qualify as owner for example ['ReadWriteReshareExplore','Owner','Admin']
                  "%
                  | optional,
                remove_email_suffix
                  | Bool
                  | doc m%"
                  Remove PowerBI User email suffix for example, @acryl.io
                  "%
                  | optional,
                use_powerbi_email
                  | Bool
                  | doc m%"
                  Use PowerBI User email to ingest as corpuser, default is powerbi user identifier
                  "%
                  | optional,
              },
          PathSpec = {
                default_extension
                  | String
                  | doc m%"
                  For files without extension it will assume the specified file type. If it is not set the files without extensions will be skipped.
                  "%
                  | optional,
                enable_compression
                  | Bool
                  | doc m%"
                  Enable or disable processing compressed files. Currently .gz and .bz files are supported.
                  "%
                  | optional,
                exclude
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  list of paths in glob pattern which will be excluded while scanning for the datasets
                  "%
                  | optional,
                file_types
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Files with extenstions specified here (subset of default value) only will be scanned to create dataset. Other files will be omitted.
                  "%
                  | optional,
                include
                  | String
                  | doc m%"
                  Path to table. Name variable `{table}` is used to mark the folder with dataset. In absence of `{table}`, file level dataset will be created. Check below examples for more details.
                  "%,
                sample_files
                  | Bool
                  | doc m%"
                  Not listing all the files but only taking a handful amount of sample file to infer the schema. File count and file size calculation will be disabled. This can affect performance significantly if enabled
                  "%
                  | optional,
                table_name
                  | String
                  | doc m%"
                  Display name of the dataset.Combination of named variables from include path and strings
                  "%
                  | optional,
              },
          PlatformDetail = {
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by DataHub platform ingestion source belong to
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  DataHub platform instance name. To generate correct urn for upstream dataset, this should match with platform instance name used in ingestion recipe of other datahub sources.
                  "%
                  | optional,
              },
          PrestoOnHiveConfigMode
            | doc m%"
            An enumeration.
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'trino, 'presto-on-hive, 'presto, 'hive |]
              ],
          ProvidedConfig = {
                path_key | String,
                provider | String,
                value | String,
              },
          S3 = {
                aws_config
                  | predicates.contract_from_predicate
                  definitions.predicate.AwsConnectionConfig
                  | doc m%"
                  AWS configuration
                  "%
                  | optional,
                use_s3_bucket_tags
                  | Bool
                  | doc m%"
                  Whether or not to create tags in datahub from the s3 bucket
                  "%
                  | optional,
                use_s3_object_tags
                  | Bool
                  | doc m%"
                  # Whether or not to create tags in datahub from the s3 object
                  "%
                  | optional,
              },
          S3LineageProviderConfig
            | doc m%"
            Any source that produces s3 lineage from/to Datasets should inherit this class.
            "%
            = {
                path_specs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.PathSpec
                  ])
                  | doc m%"
                  List of PathSpec. See below the details about PathSpec
                  "%,
              },
          SQLAlchemyConnectionConfig = {
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                scheme
                  | String
                  | doc m%"
                  scheme
                  "%,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
              },
          SalesforceAuthType
            | doc m%"
            An enumeration.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SalesforceAuthType,
          SalesforceProfilingConfig = {
                enabled
                  | Bool
                  | doc m%"
                  Whether profiling should be done. Supports only table-level profiling at this stage
                  "%
                  | optional,
                operation_config
                  | predicates.contract_from_predicate
                  definitions.predicate.OperationConfig
                  | doc m%"
                  Experimental feature. To specify operation configs.
                  "%
                  | optional,
              },
          SnowflakeShareConfig = {
                consumers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.DatabaseId,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  List of databases created in consumer accounts.
                  "%,
                database
                  | String
                  | doc m%"
                  Database from which share is created.
                  "%,
                platform_instance
                  | String
                  | doc m%"
                  Platform instance for snowflake account in which share is created.
                  "%
                  | optional,
              },
          StatefulIngestionConfig
            | doc m%"
            Basic Stateful Ingestion Specific Configuration for any source.
            "%
            = {
                enabled
                  | Bool
                  | doc m%"
                  The type of the ingestion state provider registered with datahub.
                  "%
                  | optional,
              },
          StatefulStaleMetadataRemovalConfig
            | doc m%"
            Base specialized config for Stateful Ingestion with stale metadata removal capability.
            "%
            = {
                enabled
                  | Bool
                  | doc m%"
                  The type of the ingestion state provider registered with datahub.
                  "%
                  | optional,
                remove_stale_metadata
                  | Bool
                  | doc m%"
                  Soft-deletes the entities present in the last successful run but missing in the current run with stateful_ingestion enabled.
                  "%
                  | optional,
              },
          TableauLineageOverrides = {
                database_override_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A holder for database -> database mappings to generate correct dataset urns
                  "%
                  | optional,
                platform_override_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A holder for platform -> platform mappings to generate correct dataset urns
                  "%
                  | optional,
              },
          TagOption
            | doc m%"
            An enumeration.
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'skip, 'without_lineage, 'with_lineage |]
              ],
          TransportOptionsConfig = {
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ]),
                timeout | std.number.Integer,
              },
          URIReplacePattern = {
                "match"
                  | String
                  | doc m%"
                  Pattern to match on uri-s as part of reference resolution. See replace field
                  "%,
                replace
                  | String
                  | doc m%"
                  Pattern to replace with as part of reference resolution. See match field
                  "%,
              },
          UnityCatalogProfilerConfig = {
                call_analyze
                  | Bool
                  | doc m%"
                  Whether to call ANALYZE TABLE as part of profile ingestion.If false, will ingest the results of the most recent ANALYZE TABLE call, if any.
                  "%
                  | optional,
                enabled
                  | Bool
                  | doc m%"
                  Whether profiling should be done.
                  "%
                  | optional,
                max_wait_secs
                  | std.number.Integer
                  | doc m%"
                  Maximum time to wait for an ANALYZE TABLE query to complete.
                  "%
                  | optional,
                max_workers
                  | std.number.Integer
                  | doc m%"
                  Number of worker threads to use for profiling. Set to 1 to disable.
                  "%
                  | optional,
                operation_config
                  | predicates.contract_from_predicate
                  definitions.predicate.OperationConfig
                  | doc m%"
                  Experimental feature. To specify operation configs.
                  "%
                  | optional,
                pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables for profiling during ingestion. Specify regex to match the `catalog.schema.table` format. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profile_table_level_only
                  | Bool
                  | doc m%"
                  Whether to perform profiling at table-level only or include column-level profiling as well.
                  "%
                  | optional,
                warehouse_id
                  | String
                  | doc m%"
                  SQL Warehouse id, for running profiling queries.
                  "%
                  | optional,
              },
          athena = {
                config | definitions.contract.athena_config,
                type | std.enum.TagOrString | [| 'athena |],
                ..
              },
          athena_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                aws_region
                  | String
                  | doc m%"
                  Aws region where your Athena database is located
                  "%,
                aws_role_arn
                  | String
                  | doc m%"
                  AWS Role arn for Pyathena to assume in its connection
                  "%
                  | optional,
                aws_role_assumption_duration
                  | std.number.Integer
                  | doc m%"
                  Duration to assume the AWS Role for. Maximum of 43200 (12 hours)
                  "%
                  | optional,
                catalog_name
                  | String
                  | doc m%"
                  Athena Catalog Name
                  "%
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  The athena database to ingest from. If not set it will be autodetected
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  Same detection scheme as username
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                query_result_location
                  | String
                  | doc m%"
                  S3 path to the [query result bucket](https://docs.aws.amazon.com/athena/latest/ug/querying.html#query-results-specify-location) which should be used by AWS Athena to store results of thequeries executed by DataHub.
                  "%,
                s3_staging_dir
                  | String
                  | doc m%"
                  [deprecated in favor of `query_result_location`] S3 query location
                  "%
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                scheme | String | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  Username credential. If not specified, detected with boto3 rules. See https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                work_group
                  | String
                  | doc m%"
                  The name of your Amazon Athena Workgroups
                  "%,
              },
          azure-ad = {
                config | definitions.contract.azure-ad_config,
                type | std.enum.TagOrString | [| 'azure-ad |],
                ..
              },
          azure-ad_config
            | doc m%"
            Config to create a token and connect to Azure AD instance
            "%
            = {
                authority
                  | String
                  | doc m%"
                  The authority (https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-client-application-configuration) is a URL that indicates a directory that MSAL can request tokens from.
                  "%,
                azure_ad_response_to_groupname_attr
                  | String
                  | doc m%"
                  Which Azure AD Group Response attribute to use as input to DataHub group name mapping.
                  "%
                  | optional,
                azure_ad_response_to_groupname_regex
                  | String
                  | doc m%"
                  A regex used to parse the DataHub group name from the attribute specified in `azure_ad_response_to_groupname_attr`.
                  "%
                  | optional,
                azure_ad_response_to_username_attr
                  | String
                  | doc m%"
                  Which Azure AD User Response attribute to use as input to DataHub username mapping.
                  "%
                  | optional,
                azure_ad_response_to_username_regex
                  | String
                  | doc m%"
                  A regex used to parse the DataHub username from the attribute specified in `azure_ad_response_to_username_attr`.
                  "%
                  | optional,
                client_id
                  | String
                  | doc m%"
                  Application ID. Found in your app registration on Azure AD Portal
                  "%,
                client_secret
                  | String
                  | doc m%"
                  Client secret. Found in your app registration on Azure AD Portal
                  "%,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                filtered_tracking
                  | Bool
                  | doc m%"
                  If enabled, report will contain names of filtered users and groups.
                  "%
                  | optional,
                graph_url
                  | String
                  | doc m%"
                  [Microsoft Graph API endpoint](https://docs.microsoft.com/en-us/graph/use-the-api)
                  "%
                  | optional,
                groups_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for groups to include in ingestion.
                  "%
                  | optional,
                ingest_group_membership
                  | Bool
                  | doc m%"
                  Whether group membership should be ingested into DataHub. ingest_groups must be True if this is True.
                  "%
                  | optional,
                ingest_groups
                  | Bool
                  | doc m%"
                  Whether groups should be ingested into DataHub.
                  "%
                  | optional,
                ingest_groups_users
                  | Bool
                  | doc m%"
                  This option is useful only when `ingest_users` is set to False and `ingest_group_membership` to True. As effect, only the users which belongs to the selected groups will be ingested.
                  "%
                  | optional,
                ingest_users
                  | Bool
                  | doc m%"
                  Whether users should be ingested into DataHub.
                  "%
                  | optional,
                mask_group_id
                  | Bool
                  | doc m%"
                  Whether workunit ID's for groups should be masked to avoid leaking sensitive information.
                  "%
                  | optional,
                mask_user_id
                  | Bool
                  | doc m%"
                  Whether workunit ID's for users should be masked to avoid leaking sensitive information.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                redirect
                  | String
                  | doc m%"
                  Redirect URI.  Found in your app registration on Azure AD Portal.
                  "%
                  | optional,
                stateful_ingestion
                  | predicates.contract_from_predicate
                  definitions.predicate.StatefulStaleMetadataRemovalConfig
                  | doc m%"
                  Azure AD Stateful Ingestion Config.
                  "%
                  | optional,
                tenant_id
                  | String
                  | doc m%"
                  Directory ID. Found in your app registration on Azure AD Portal
                  "%,
                token_url
                  | String
                  | doc m%"
                  The token URL that acquires a token from Azure AD for authorizing requests.  This source will only work with v1.0 endpoint.
                  "%,
                users_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for users to filter in ingestion.
                  "%
                  | optional,
              },
          bigquery = {
                config | definitions.contract.bigquery_config,
                type | std.enum.TagOrString | [| 'bigquery |],
                ..
              },
          bigquery_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                bigquery_audit_metadata_datasets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of datasets that contain a table named cloudaudit_googleapis_com_data_access which contain BigQuery audit logs, specifically, those containing BigQueryAuditMetadata. It is recommended that the project of the dataset is also specified, for example, projectA.datasetB.
                  "%
                  | optional,
                bucket_duration
                  | predicates.contract_from_predicate
                  definitions.predicate.BucketDuration
                  | doc m%"
                  Size of the time window to aggregate usage stats.
                  "%
                  | optional,
                capture_dataset_label_as_tag
                  | Bool
                  | doc m%"
                  Capture BigQuery dataset labels as DataHub tag
                  "%
                  | optional,
                capture_table_label_as_tag
                  | Bool
                  | doc m%"
                  Capture BigQuery table labels as DataHub tag
                  "%
                  | optional,
                column_limit
                  | std.number.Integer
                  | doc m%"
                  Maximum number of columns to process in a table. This is a low level config property which should be touched with care. This restriction is needed because excessively wide tables can result in failure to ingest the schema.
                  "%
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                credential
                  | predicates.contract_from_predicate
                  definitions.predicate.BigQueryCredential
                  | doc m%"
                  BigQuery credential informations
                  "%
                  | optional,
                dataset_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for dataset to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                debug_include_full_payloads
                  | Bool
                  | doc m%"
                  Include full payload into events. It is only for debugging and internal use.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                enable_legacy_sharded_table_support
                  | Bool
                  | doc m%"
                  Use the legacy sharded table urn suffix added.
                  "%
                  | optional,
                enable_stateful_lineage_ingestion
                  | Bool
                  | doc m%"
                  Enable stateful lineage ingestion. This will store lineage window timestamps after successful lineage ingestion. and will not run lineage ingestion for same timestamps in subsequent run. 
                  "%
                  | optional,
                enable_stateful_profiling
                  | Bool
                  | doc m%"
                  Enable stateful profiling. This will store profiling timestamps per dataset after successful profiling. and will not run profiling again in subsequent run if table has not been updated. 
                  "%
                  | optional,
                enable_stateful_usage_ingestion
                  | Bool
                  | doc m%"
                  Enable stateful lineage ingestion. This will store usage window timestamps after successful usage ingestion. and will not run usage ingestion for same timestamps in subsequent run. 
                  "%
                  | optional,
                end_time
                  | String
                  | doc m%"
                  Latest date of lineage/usage to consider. Default: Current time in UTC
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                exclude_empty_projects
                  | Bool
                  | doc m%"
                  Option to exclude empty projects from being ingested.
                  "%
                  | optional,
                extra_client_options
                  | {  .. }
                  | doc m%"
                  Additional options to pass to google.cloud.logging_v2.client.Client.
                  "%
                  | optional,
                extract_column_lineage
                  | Bool
                  | doc m%"
                  If enabled, generate column level lineage. Requires lineage_use_sql_parser to be enabled. This and `incremental_lineage` cannot both be enabled.
                  "%
                  | optional,
                extract_lineage_from_catalog
                  | Bool
                  | doc m%"
                  This flag enables the data lineage extraction from Data Lineage API exposed by Google Data Catalog. NOTE: This extractor can't build views lineage. It's recommended to enable the view's DDL parsing. Read the docs to have more information about: https://cloud.google.com/data-catalog/docs/concepts/about-data-lineage
                  "%
                  | optional,
                include_data_platform_instance
                  | Bool
                  | doc m%"
                  Whether to create a DataPlatformInstance aspect, equal to the BigQuery project id. If enabled, will cause redundancy in the browse path for BigQuery entities in the UI, because the project id is represented as the top-level container.
                  "%
                  | optional,
                include_external_url
                  | Bool
                  | doc m%"
                  Whether to populate BigQuery Console url to Datasets/Tables
                  "%
                  | optional,
                include_table_lineage
                  | Bool
                  | doc m%"
                  Option to enable/disable lineage generation. Is enabled by default.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_usage_statistics
                  | Bool
                  | doc m%"
                  Generate usage statistic
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                incremental_lineage
                  | Bool
                  | doc m%"
                  When enabled, emits lineage as incremental to existing lineage already in DataHub. When disabled, re-states lineage on each run.
                  "%
                  | optional,
                lineage_parse_view_ddl
                  | Bool
                  | doc m%"
                  Sql parse view ddl to get lineage.
                  "%
                  | optional,
                lineage_sql_parser_use_raw_names
                  | Bool
                  | doc m%"
                  This parameter ignores the lowercase pattern stipulated in the SQLParser. NOTE: Ignored if lineage_use_sql_parser is False.
                  "%
                  | optional,
                lineage_use_sql_parser
                  | Bool
                  | doc m%"
                  Use sql parser to resolve view/table lineage.
                  "%
                  | optional,
                log_page_size
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  The number of log item will be queried per page for lineage collection
                  "%
                  | optional,
                match_fully_qualified_names
                  | Bool
                  | doc m%"
                  Whether `dataset_pattern` is matched against fully qualified dataset name `<project_id>.<dataset_name>`.
                  "%
                  | optional,
                max_query_duration
                  | Number
                  | doc m%"
                  Correction to pad start_time and end_time with. For handling the case where the read happens within our time range but the query completion event is delayed and happens after the configured end time.
                  "%
                  | optional,
                number_of_datasets_process_in_batch_if_profiling_enabled
                  | std.number.Integer
                  | doc m%"
                  Number of partitioned table queried in batch when getting metadata. This is a low level config property which should be touched with care. This restriction is needed because we query partitions system view which throws error if we try to touch too many tables.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                project_id
                  | String
                  | doc m%"
                  [deprecated] Use project_id_pattern or project_ids instead.
                  "%
                  | optional,
                project_id_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for project_id to filter in ingestion.
                  "%
                  | optional,
                project_ids
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Ingests specified project_ids. Use this property if you want to specify what projects to ingest or don't want to give project resourcemanager.projects.list to your service account. Overrides `project_id_pattern`.
                  "%
                  | optional,
                project_on_behalf
                  | String
                  | doc m%"
                  [Advanced] The BigQuery project in which queries are executed. Will be passed when creating a job. If not passed, falls back to the project associated with the service account.
                  "%
                  | optional,
                rate_limit
                  | Bool
                  | doc m%"
                  Should we rate limit requests made to API.
                  "%
                  | optional,
                requests_per_min
                  | std.number.Integer
                  | doc m%"
                  Used to control number of API calls made per min. Only used when `rate_limit` is set to `True`.
                  "%
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                scheme | String | optional,
                sharded_table_pattern
                  | String
                  | doc m%"
                  The regex pattern to match sharded tables and group as one table. This is a very low level config parameter, only change if you know what you are doing, 
                  "%
                  | optional,
                sql_parser_use_external_process
                  | Bool
                  | doc m%"
                  When enabled, sql parser will run in isolated in a separate process. This can affect processing time but can protect from sql parser's mem leak.
                  "%
                  | optional,
                start_time
                  | String
                  | doc m%"
                  Earliest date of lineage/usage to consider. Default: Last full day in UTC (or hour, depending on `bucket_duration`). You can also specify relative time with respect to end_time such as '-7 days' Or '-7d'.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                temp_table_dataset_prefix
                  | String
                  | doc m%"
                  If you are creating temp tables in a dataset with a particular prefix you can use this config to set the prefix for the dataset. This is to support workflows from before bigquery's introduction of temp tables. By default we use `_` because of datasets that begin with an underscore are hidden by default https://cloud.google.com/bigquery/docs/datasets#dataset-naming.
                  "%
                  | optional,
                upstream_lineage_in_report
                  | Bool
                  | doc m%"
                  Useful for debugging lineage information. Set to True to see the raw lineage created internally.
                  "%
                  | optional,
                usage
                  | predicates.contract_from_predicate
                  definitions.predicate.BigQueryUsageConfig
                  | doc m%"
                  Usage related configs
                  "%
                  | optional,
                use_date_sharded_audit_log_tables
                  | Bool
                  | doc m%"
                  Whether to read date sharded tables or time partitioned tables when extracting usage from exported audit logs.
                  "%
                  | optional,
                use_exported_bigquery_audit_metadata
                  | Bool
                  | doc m%"
                  When configured, use BigQueryAuditMetadata in bigquery_audit_metadata_datasets to compute lineage information.
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          clickhouse = {
                config | definitions.contract.clickhouse_config,
                type | std.enum.TagOrString | [| 'clickhouse |],
                ..
              },
          clickhouse-usage = {
                config | definitions.contract.clickhouse-usage_config,
                type | std.enum.TagOrString | [| 'clickhouse-usage |],
                ..
              },
          clickhouse-usage_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                bucket_duration
                  | predicates.contract_from_predicate
                  definitions.predicate.BucketDuration
                  | doc m%"
                  Size of the time window to aggregate usage stats.
                  "%
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for databases to filter in ingestion.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                email_domain | String,
                end_time
                  | String
                  | doc m%"
                  Latest date of lineage/usage to consider. Default: Current time in UTC
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                format_sql_queries
                  | Bool
                  | doc m%"
                  Whether to format sql queries
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  ClickHouse host URL.
                  "%
                  | optional,
                include_materialized_views | Bool | optional,
                include_operational_stats
                  | Bool
                  | doc m%"
                  Whether to display operational stats.
                  "%
                  | optional,
                include_read_operational_stats
                  | Bool
                  | doc m%"
                  Whether to report read operational stats. Experimental.
                  "%
                  | optional,
                include_table_lineage
                  | Bool
                  | doc m%"
                  Whether table lineage should be ingested.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_top_n_queries
                  | Bool
                  | doc m%"
                  Whether to ingest the top_n_queries.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options | {  .. } | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                platform_instance_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A holder for platform -> platform_instance mappings to generate correct dataset urns
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                protocol | String | optional,
                query_log_table | String | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Deprecated in favour of database_pattern.
                  "%
                  | optional,
                secure | Bool | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                start_time
                  | String
                  | doc m%"
                  Earliest date of lineage/usage to consider. Default: Last full day in UTC (or hour, depending on `bucket_duration`). You can also specify relative time with respect to end_time such as '-7 days' Or '-7d'.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                top_n_queries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  Number of top queries to save to each table.
                  "%
                  | optional,
                uri_opts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The part of the URI and it's used to provide additional configuration options or parameters for the database connection.
                  "%
                  | optional,
                user_email_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for user emails to filter in usage.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          clickhouse_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                bucket_duration
                  | predicates.contract_from_predicate
                  definitions.predicate.BucketDuration
                  | doc m%"
                  Size of the time window to aggregate usage stats.
                  "%
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for databases to filter in ingestion.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                end_time
                  | String
                  | doc m%"
                  Latest date of lineage/usage to consider. Default: Current time in UTC
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  ClickHouse host URL.
                  "%
                  | optional,
                include_materialized_views | Bool | optional,
                include_table_lineage
                  | Bool
                  | doc m%"
                  Whether table lineage should be ingested.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                platform_instance_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A holder for platform -> platform_instance mappings to generate correct dataset urns
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                protocol | String | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Deprecated in favour of database_pattern.
                  "%
                  | optional,
                secure | Bool | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                start_time
                  | String
                  | doc m%"
                  Earliest date of lineage/usage to consider. Default: Last full day in UTC (or hour, depending on `bucket_duration`). You can also specify relative time with respect to end_time such as '-7 days' Or '-7d'.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                uri_opts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The part of the URI and it's used to provide additional configuration options or parameters for the database connection.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          console_sink = { type | std.enum.TagOrString | [| 'console |], .. },
          csv-enricher = {
                config | definitions.contract.csv-enricher_config,
                type | std.enum.TagOrString | [| 'csv-enricher |],
                ..
              },
          csv-enricher_config = {
                array_delimiter
                  | String
                  | doc m%"
                  Delimiter to use when parsing array fields (tags, terms and owners)
                  "%
                  | optional,
                delimiter
                  | String
                  | doc m%"
                  Delimiter to use when parsing CSV
                  "%
                  | optional,
                filename
                  | String
                  | doc m%"
                  File path or URL of CSV file to ingest.
                  "%,
                write_semantics
                  | String
                  | doc m%"
                  Whether the new tags, terms and owners to be added will override the existing ones added only by this source or not. Value for this config can be "PATCH" or "OVERRIDE"
                  "%
                  | optional,
              },
          datahub = {
                config | definitions.contract.datahub_config,
                type | std.enum.TagOrString | [| 'datahub |],
                ..
              },
          datahub-business-glossary = {
                config | definitions.contract.datahub-business-glossary_config,
                type | std.enum.TagOrString | [| 'datahub-business-glossary |],
                ..
              },
          datahub-business-glossary_config = {
                enable_auto_id
                  | Bool
                  | doc m%"
                  Generate guid urns instead of a plaintext path urn with the node/term's hierarchy.
                  "%
                  | optional,
                file
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"String" ])
                  | doc m%"
                  File path or URL to business glossary file to ingest.
                  "%,
              },
          datahub-lineage-file = {
                config | definitions.contract.datahub-lineage-file_config,
                type | std.enum.TagOrString | [| 'datahub-lineage-file |],
                ..
              },
          datahub-lineage-file_config = {
                file
                  | String
                  | doc m%"
                  File path or URL to lineage file to ingest.
                  "%,
                preserve_upstream
                  | Bool
                  | doc m%"
                  Whether we want to query datahub-gms for upstream data. False means it will hard replace upstream data for a given entity. True means it will query the backend for existing upstreams and include it in the ingestion run
                  "%
                  | optional,
              },
          datahub_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                commit_state_interval
                  | std.number.Integer
                  | doc m%"
                  Number of records to process before committing state
                  "%
                  | optional,
                commit_with_parse_errors
                  | Bool
                  | doc m%"
                  Whether to update createdon timestamp and kafka offset despite parse errors. Enable if you want to ignore the errors.
                  "%
                  | optional,
                database_connection
                  | predicates.contract_from_predicate
                  definitions.predicate.SQLAlchemyConnectionConfig
                  | doc m%"
                  Database connection config
                  "%
                  | optional,
                database_query_batch_size
                  | std.number.Integer
                  | doc m%"
                  Number of records to fetch from the database at a time
                  "%
                  | optional,
                database_table_name
                  | String
                  | doc m%"
                  Name of database table containing all versioned aspects
                  "%
                  | optional,
                include_all_versions
                  | Bool
                  | doc m%"
                  If enabled, include all versions of each aspect. Otherwise, only include the latest version of each aspect. 
                  "%
                  | optional,
                kafka_connection
                  | predicates.contract_from_predicate
                  definitions.predicate.KafkaConsumerConnectionConfig
                  | doc m%"
                  Kafka connection config
                  "%
                  | optional,
                kafka_topic_name
                  | String
                  | doc m%"
                  Name of kafka topic containing timeseries MCLs
                  "%
                  | optional,
                stateful_ingestion
                  | predicates.contract_from_predicate
                  definitions.predicate.StatefulIngestionConfig
                  | doc m%"
                  Stateful Ingestion Config
                  "%
                  | optional,
                ..
              },
          datahub_kafka_sink = {
                config | definitions.contract.datahub_kafka_sink_config,
                type | std.enum.TagOrString | [| 'datahub-kafka |],
              },
          datahub_kafka_sink_config = {
                connection
                  | {
                    bootstrap
                      | String
                      | doc m%"
                      Kafka bootstrap URL.
                      "%,
                    producer_config
                      | {  .. }
                      | doc m%"
                      Passed to https://docs.confluent.io/platform/current/clients/confluent-kafka-python/html/index.html#confluent_kafka.SerializingProducer
                      "%
                      | optional,
                    schema_registry_config
                      | {  .. }
                      | doc m%"
                      Passed to https://docs.confluent.io/platform/current/clients/confluent-kafka-python/html/index.html#confluent_kafka.schema_registry.SchemaRegistryClient
                      "%
                      | optional,
                    schema_registry_url
                      | String
                      | doc m%"
                      URL of schema registry being used.
                      "%,
                  },
                topic_routes
                  | {
                    MetadataChangeEvent
                      | String
                      | doc m%"
                      Overridden Kafka topic name for the MetadataChangeEvent
                      "%
                      | optional,
                    MetadataChangeProposal
                      | String
                      | doc m%"
                      Overridden Kafka topic name for the MetadataChangeProposal
                      "%
                      | optional,
                  }
                  | optional,
              },
          datahub_rest_sink = {
                config | definitions.contract.datahub_rest_sink_config,
                type | std.enum.TagOrString | [| 'datahub-rest |],
              },
          datahub_rest_sink_config = {
                ca_certificate_path
                  | String
                  | doc m%"
                  Path to server's CA certificate for verification of HTTPS communications
                  "%
                  | optional,
                client_certificate_path
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | optional,
                disable_ssl_verification
                  | Bool
                  | doc m%"
                  Disable SSL verification for HTTPS communications.
                  "%
                  | optional,
                extra_headers
                  | String
                  | doc m%"
                  Extra headers which will be added to the request.
                  "%
                  | optional,
                max_threads
                  | Number
                  | doc m%"
                  Experimental: Max parallelism for REST API calls
                  "%
                  | optional,
                retry_status_codes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  Retry HTTP request also on these status codes
                  "%
                  | optional,
                server
                  | String
                  | doc m%"
                  URL of DataHub GMS endpoint.
                  "%,
                timeout_sec
                  | Number
                  | doc m%"
                  Per-HTTP request timeout.
                  "%
                  | optional,
                token
                  | String
                  | doc m%"
                  Bearer token used for authentication.
                  "%
                  | optional,
              },
          dbt = {
                config | definitions.contract.dbt_config,
                type | std.enum.TagOrString | [| 'dbt |],
                ..
              },
          dbt-cloud = {
                config | definitions.contract.dbt-cloud_config,
                type | std.enum.TagOrString | [| 'dbt-cloud |],
                ..
              },
          dbt-cloud_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                account_id
                  | std.number.Integer
                  | doc m%"
                  The DBT Cloud account ID to use.
                  "%,
                column_meta_mapping
                  | {  .. }
                  | doc m%"
                  mapping rules that will be executed against dbt column meta properties. Refer to the section below on dbt meta automated mappings.
                  "%
                  | optional,
                convert_column_urns_to_lowercase
                  | Bool
                  | doc m%"
                  When enabled, converts column URNs to lowercase to ensure cross-platform compatibility. If `target_platform` is Snowflake, the default is True.
                  "%
                  | optional,
                enable_meta_mapping
                  | Bool
                  | doc m%"
                  When enabled, applies the mappings that are defined through the meta_mapping directives.
                  "%
                  | optional,
                enable_owner_extraction
                  | Bool
                  | doc m%"
                  When enabled, ownership info will be extracted from the dbt meta
                  "%
                  | optional,
                enable_query_tag_mapping
                  | Bool
                  | doc m%"
                  When enabled, applies the mappings that are defined through the `query_tag_mapping` directives.
                  "%
                  | optional,
                entities_enabled
                  | predicates.contract_from_predicate
                  definitions.predicate.DBTEntitiesEnabled
                  | doc m%"
                  Controls for enabling / disabling metadata emission for different dbt entities (models, test definitions, test results, etc.)
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  Environment to use in namespace when constructing URNs.
                  "%
                  | optional,
                include_env_in_assertion_guid
                  | Bool
                  | doc m%"
                  Prior to version 0.9.4.2, the assertion GUIDs did not include the environment. If you're using multiple dbt ingestion that are only distinguished by env, then you should set this flag to True.
                  "%
                  | optional,
                incremental_lineage
                  | Bool
                  | doc m%"
                  When enabled, emits lineage as incremental to existing lineage already in DataHub. When disabled, re-states lineage on each run.
                  "%
                  | optional,
                job_id
                  | std.number.Integer
                  | doc m%"
                  The ID of the job to ingest metadata from.
                  "%,
                meta_mapping
                  | {  .. }
                  | doc m%"
                  mapping rules that will be executed against dbt meta properties. Refer to the section below on dbt meta automated mappings.
                  "%
                  | optional,
                metadata_endpoint
                  | String
                  | doc m%"
                  The dbt Cloud metadata API endpoint.
                  "%
                  | optional,
                node_name_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for dbt model names to filter in ingestion.
                  "%
                  | optional,
                owner_extraction_pattern
                  | String
                  | doc m%"
                  Regex string to extract owner from the dbt node using the `(?P<name>...) syntax` of the [match object](https://docs.python.org/3/library/re.html#match-objects), where the group name must be `owner`. Examples: (1)`r"(?P<owner>(.*)): (\w+) (\w+)"` will extract `jdoe` as the owner from `"jdoe: John Doe"` (2) `r"@(?P<owner>(.*))"` will extract `alice` as the owner from `"@alice"`.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                project_id
                  | std.number.Integer
                  | doc m%"
                  The dbt Cloud project ID to use.
                  "%,
                query_tag_mapping
                  | {  .. }
                  | doc m%"
                  mapping rules that will be executed against dbt query_tag meta properties. Refer to the section below on dbt meta automated mappings.
                  "%
                  | optional,
                run_id
                  | std.number.Integer
                  | doc m%"
                  The ID of the run to ingest metadata from. If not specified, we'll default to the latest run.
                  "%
                  | optional,
                sql_parser_use_external_process
                  | Bool
                  | doc m%"
                  When enabled, sql parser will run in isolated in a separate process. This can affect processing time but can protect from sql parser's mem leak.
                  "%
                  | optional,
                stateful_ingestion
                  | predicates.contract_from_predicate
                  definitions.predicate.StatefulStaleMetadataRemovalConfig
                  | doc m%"
                  DBT Stateful Ingestion Config.
                  "%
                  | optional,
                strip_user_ids_from_email
                  | Bool
                  | doc m%"
                  Whether or not to strip email id while adding owners using dbt meta actions.
                  "%
                  | optional,
                tag_prefix
                  | String
                  | doc m%"
                  Prefix added to tags during ingestion.
                  "%
                  | optional,
                target_platform
                  | String
                  | doc m%"
                  The platform that dbt is loading onto. (e.g. bigquery / redshift / postgres etc.)
                  "%,
                target_platform_instance
                  | String
                  | doc m%"
                  The platform instance for the platform that dbt is operating on. Use this if you have multiple instances of the same platform (e.g. redshift) and need to distinguish between them.
                  "%
                  | optional,
                test_warnings_are_errors
                  | Bool
                  | doc m%"
                  When enabled, dbt test warnings will be treated as failures.
                  "%
                  | optional,
                token
                  | String
                  | doc m%"
                  The API token to use to authenticate with DBT Cloud.
                  "%,
                use_compiled_code
                  | Bool
                  | doc m%"
                  When enabled, uses the compiled dbt code instead of the raw dbt node definition.
                  "%
                  | optional,
                use_identifiers
                  | Bool
                  | doc m%"
                  Use model identifier instead of model name if defined (if not, default to model name).
                  "%
                  | optional,
                write_semantics
                  | String
                  | doc m%"
                  Whether the new tags, terms and owners to be added will override the existing ones added only by this source or not. Value for this config can be "PATCH" or "OVERRIDE"
                  "%
                  | optional,
              },
          dbt_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                aws_connection
                  | predicates.contract_from_predicate
                  definitions.predicate.AwsConnectionConfig
                  | doc m%"
                  When fetching manifest files from s3, configuration for aws connection details
                  "%
                  | optional,
                catalog_path
                  | String
                  | doc m%"
                  Path to dbt catalog JSON. See https://docs.getdbt.com/reference/artifacts/catalog-json Note this can be a local file or a URI.
                  "%,
                column_meta_mapping
                  | {  .. }
                  | doc m%"
                  mapping rules that will be executed against dbt column meta properties. Refer to the section below on dbt meta automated mappings.
                  "%
                  | optional,
                convert_column_urns_to_lowercase
                  | Bool
                  | doc m%"
                  When enabled, converts column URNs to lowercase to ensure cross-platform compatibility. If `target_platform` is Snowflake, the default is True.
                  "%
                  | optional,
                enable_meta_mapping
                  | Bool
                  | doc m%"
                  When enabled, applies the mappings that are defined through the meta_mapping directives.
                  "%
                  | optional,
                enable_owner_extraction
                  | Bool
                  | doc m%"
                  When enabled, ownership info will be extracted from the dbt meta
                  "%
                  | optional,
                enable_query_tag_mapping
                  | Bool
                  | doc m%"
                  When enabled, applies the mappings that are defined through the `query_tag_mapping` directives.
                  "%
                  | optional,
                entities_enabled
                  | predicates.contract_from_predicate
                  definitions.predicate.DBTEntitiesEnabled
                  | doc m%"
                  Controls for enabling / disabling metadata emission for different dbt entities (models, test definitions, test results, etc.)
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  Environment to use in namespace when constructing URNs.
                  "%
                  | optional,
                git_info
                  | predicates.contract_from_predicate
                  definitions.predicate.GitReference
                  | doc m%"
                  Reference to your git location to enable easy navigation from DataHub to your dbt files.
                  "%
                  | optional,
                include_env_in_assertion_guid
                  | Bool
                  | doc m%"
                  Prior to version 0.9.4.2, the assertion GUIDs did not include the environment. If you're using multiple dbt ingestion that are only distinguished by env, then you should set this flag to True.
                  "%
                  | optional,
                incremental_lineage
                  | Bool
                  | doc m%"
                  When enabled, emits lineage as incremental to existing lineage already in DataHub. When disabled, re-states lineage on each run.
                  "%
                  | optional,
                manifest_path
                  | String
                  | doc m%"
                  Path to dbt manifest JSON. See https://docs.getdbt.com/reference/artifacts/manifest-json Note this can be a local file or a URI.
                  "%,
                meta_mapping
                  | {  .. }
                  | doc m%"
                  mapping rules that will be executed against dbt meta properties. Refer to the section below on dbt meta automated mappings.
                  "%
                  | optional,
                node_name_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for dbt model names to filter in ingestion.
                  "%
                  | optional,
                owner_extraction_pattern
                  | String
                  | doc m%"
                  Regex string to extract owner from the dbt node using the `(?P<name>...) syntax` of the [match object](https://docs.python.org/3/library/re.html#match-objects), where the group name must be `owner`. Examples: (1)`r"(?P<owner>(.*)): (\w+) (\w+)"` will extract `jdoe` as the owner from `"jdoe: John Doe"` (2) `r"@(?P<owner>(.*))"` will extract `alice` as the owner from `"@alice"`.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                query_tag_mapping
                  | {  .. }
                  | doc m%"
                  mapping rules that will be executed against dbt query_tag meta properties. Refer to the section below on dbt meta automated mappings.
                  "%
                  | optional,
                sources_path
                  | String
                  | doc m%"
                  Path to dbt sources JSON. See https://docs.getdbt.com/reference/artifacts/sources-json. If not specified, last-modified fields will not be populated. Note this can be a local file or a URI.
                  "%
                  | optional,
                sql_parser_use_external_process
                  | Bool
                  | doc m%"
                  When enabled, sql parser will run in isolated in a separate process. This can affect processing time but can protect from sql parser's mem leak.
                  "%
                  | optional,
                stateful_ingestion
                  | predicates.contract_from_predicate
                  definitions.predicate.StatefulStaleMetadataRemovalConfig
                  | doc m%"
                  DBT Stateful Ingestion Config.
                  "%
                  | optional,
                strip_user_ids_from_email
                  | Bool
                  | doc m%"
                  Whether or not to strip email id while adding owners using dbt meta actions.
                  "%
                  | optional,
                tag_prefix
                  | String
                  | doc m%"
                  Prefix added to tags during ingestion.
                  "%
                  | optional,
                target_platform
                  | String
                  | doc m%"
                  The platform that dbt is loading onto. (e.g. bigquery / redshift / postgres etc.)
                  "%,
                target_platform_instance
                  | String
                  | doc m%"
                  The platform instance for the platform that dbt is operating on. Use this if you have multiple instances of the same platform (e.g. redshift) and need to distinguish between them.
                  "%
                  | optional,
                test_results_path
                  | String
                  | doc m%"
                  Path to output of dbt test run as run_results file in JSON format. See https://docs.getdbt.com/reference/artifacts/run-results-json. If not specified, test execution results will not be populated in DataHub.
                  "%
                  | optional,
                test_warnings_are_errors
                  | Bool
                  | doc m%"
                  When enabled, dbt test warnings will be treated as failures.
                  "%
                  | optional,
                use_compiled_code
                  | Bool
                  | doc m%"
                  When enabled, uses the compiled dbt code instead of the raw dbt node definition.
                  "%
                  | optional,
                use_identifiers
                  | Bool
                  | doc m%"
                  Use model identifier instead of model name if defined (if not, default to model name).
                  "%
                  | optional,
                write_semantics
                  | String
                  | doc m%"
                  Whether the new tags, terms and owners to be added will override the existing ones added only by this source or not. Value for this config can be "PATCH" or "OVERRIDE"
                  "%
                  | optional,
              },
          delta-lake = {
                config | definitions.contract.delta-lake_config,
                type | std.enum.TagOrString | [| 'delta-lake |],
                ..
              },
          delta-lake_config
            | doc m%"
            Any source that connects to a platform should inherit this class
            "%
            = {
                base_path
                  | String
                  | doc m%"
                  Path to table (s3 or local file system). If path is not a delta table path then all subfolders will be scanned to detect and ingest delta tables.
                  "%,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                platform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.const "delta-lake"
                  ])
                  | doc m%"
                  The platform that this source connects to
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                relative_path
                  | String
                  | doc m%"
                  If set, delta-tables will be searched at location '<base_path>/<relative_path>' and URNs will be created using relative_path only.
                  "%
                  | optional,
                require_files
                  | Bool
                  | doc m%"
                  Whether DeltaTable should track files. Consider setting this to `False` for large delta tables, resulting in significant memory reduction for ingestion process.When set to `False`, number_of_files in delta table can not be reported.
                  "%
                  | optional,
                s3 | definitions.contract.S3 | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for tables to filter in ingestion.
                  "%
                  | optional,
                version_history_lookback
                  | std.number.Integer
                  | doc m%"
                  Number of previous version histories to be ingested. Defaults to 1. If set to -1 all version history will be ingested.
                  "%
                  | optional,
              },
          demo-data = {
                config | definitions.contract.demo-data_config,
                type | std.enum.TagOrString | [| 'demo-data |],
                ..
              },
          demo-data_config = {  },
          druid = {
                config | definitions.contract.druid_config,
                type | std.enum.TagOrString | [| 'druid |],
                ..
              },
          druid_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for schemas to filter in ingestion.
                  "%
                  | optional,
                scheme | String | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          dynamodb = {
                config | definitions.contract.dynamodb_config,
                type | std.enum.TagOrString | [| 'dynamodb |],
                ..
              },
          dynamodb_config
            | doc m%"
            Any source that is a primary producer of Dataset metadata should inherit this class
            "%
            = {
                aws_access_key_id
                  | String
                  | doc m%"
                  AWS Access Key ID.
                  "%,
                aws_secret_access_key
                  | String
                  | doc m%"
                  AWS Secret Key.
                  "%,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                include_table_item
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType 'Record)
                    ])
                  ])
                  | doc m%"
                  [Advanced] The primary keys of items of a table in dynamodb format the user would like to include in schema. Refer "Advanced Configurations" section for more details
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. The table name format is 'region.table'
                  "%
                  | optional,
              },
          elasticsearch = {
                config | definitions.contract.elasticsearch_config,
                type | std.enum.TagOrString | [| 'elasticsearch |],
                ..
              },
          elasticsearch_config
            | doc m%"
            Any source that connects to a platform should inherit this class
            "%
            = {
                ca_certs
                  | String
                  | doc m%"
                  Path to a certificate authority (CA) certificate.
                  "%
                  | optional,
                client_cert
                  | String
                  | doc m%"
                  Path to the file containing the private key and the certificate, or cert only if using client_key.
                  "%
                  | optional,
                client_key
                  | String
                  | doc m%"
                  Path to the file containing the private key if using separate cert and key files.
                  "%
                  | optional,
                collapse_urns | definitions.contract.CollapseUrns | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host
                  | String
                  | doc m%"
                  The elastic search host URI.
                  "%
                  | optional,
                index_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for indexes to filter in ingestion.
                  "%
                  | optional,
                index_template_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  The regex patterns for filtering index templates to ingest.
                  "%
                  | optional,
                ingest_index_templates
                  | Bool
                  | doc m%"
                  Ingests ES index templates if enabled.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  The password credential.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profiling | definitions.contract.ElasticProfiling | optional,
                ssl_assert_fingerprint
                  | String
                  | doc m%"
                  Verify the supplied certificate fingerprint if not None.
                  "%
                  | optional,
                ssl_assert_hostname
                  | Bool
                  | doc m%"
                  Use hostname verification if not False.
                  "%
                  | optional,
                url_prefix
                  | String
                  | doc m%"
                  There are cases where an enterprise would have multiple elastic search clusters. One way for them to manage is to have a single endpoint for all the elastic search clusters and use url_prefix for routing requests to different clusters.
                  "%
                  | optional,
                use_ssl
                  | Bool
                  | doc m%"
                  Whether to use SSL for the connection or not.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  The username credential.
                  "%
                  | optional,
                verify_certs
                  | Bool
                  | doc m%"
                  Whether to verify SSL certificates.
                  "%
                  | optional,
              },
          feast = {
                config | definitions.contract.feast_config,
                type | std.enum.TagOrString | [| 'feast |],
                ..
              },
          feast_config = {
                environment
                  | String
                  | doc m%"
                  Environment to use when constructing URNs
                  "%
                  | optional,
                fs_yaml_file
                  | String
                  | doc m%"
                  Path to the `feature_store.yaml` file used to configure the feature store
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path to Feast repository
                  "%,
              },
          file = {
                config | definitions.contract.file_config,
                type | std.enum.TagOrString | [| 'file |],
                ..
              },
          file_config = {
                aspect
                  | String
                  | doc m%"
                  Set to an aspect to only read this aspect for ingestion.
                  "%
                  | optional,
                count_all_before_starting
                  | Bool
                  | doc m%"
                  When enabled, counts total number of records in the file before starting. Used for accurate estimation of completion time. Turn it off if startup time is too high.
                  "%
                  | optional,
                file_extension
                  | String
                  | doc m%"
                  When providing a folder to use to read files, set this field to control file extensions that you want the source to process. * is a special value that means process every file regardless of extension
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  File path to folder or file to ingest, or URL to a remote file. If pointed to a folder, all files with extension {file_extension} (default json) within that folder will be processed.
                  "%,
                read_mode
                  | predicates.contract_from_predicate
                  definitions.predicate.FileReadMode
                  | optional,
              },
          file_sink = {
                config | definitions.contract.file_sink_config,
                type | std.enum.TagOrString | [| 'file |],
                ..
              },
          file_sink_config = {
                filename
                  | String
                  | doc m%"
                  Path to file to write to.
                  "%,
              },
          gcs = {
                config | definitions.contract.gcs_config,
                type | std.enum.TagOrString | [| 'gcs |],
                ..
              },
          gcs_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                credential
                  | predicates.contract_from_predicate
                  definitions.predicate.HMACKey
                  | doc m%"
                  Google cloud storage [HMAC keys](https://cloud.google.com/storage/docs/authentication/hmackeys)
                  "%,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                max_rows
                  | std.number.Integer
                  | doc m%"
                  Maximum number of rows to use when inferring schemas for TSV and CSV files.
                  "%
                  | optional,
                number_of_files_to_sample
                  | std.number.Integer
                  | doc m%"
                  Number of files to list to sample for schema inference. This will be ignored if sample_files is set to False in the pathspec.
                  "%
                  | optional,
                path_specs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.PathSpec
                  ])
                  | doc m%"
                  List of PathSpec. See [below](#path-spec) the details about PathSpec
                  "%,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
              },
          glue = {
                config | definitions.contract.glue_config,
                type | std.enum.TagOrString | [| 'glue |],
                ..
              },
          glue_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                aws_access_key_id
                  | String
                  | doc m%"
                  AWS access key ID. Can be auto-detected, see [the AWS boto3 docs](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html) for details.
                  "%
                  | optional,
                aws_endpoint_url
                  | String
                  | doc m%"
                  The AWS service endpoint. This is normally [constructed automatically](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/core/session.html), but can be overridden here.
                  "%
                  | optional,
                aws_profile
                  | String
                  | doc m%"
                  Named AWS profile to use. Only used if access key / secret are unset. If not set the default will be used
                  "%
                  | optional,
                aws_proxy
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A set of proxy configs to use with AWS. See the [botocore.config](https://botocore.amazonaws.com/v1/documentation/api/latest/reference/config.html) docs for details.
                  "%
                  | optional,
                aws_region
                  | String
                  | doc m%"
                  AWS region code.
                  "%,
                aws_role
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.AwsAssumeRoleConfig
                      ])
                    ]
                  ])
                  | doc m%"
                  AWS roles to assume. If using the string format, the role ARN can be specified directly. If using the object format, the role can be specified in the RoleArn field and additional available arguments are documented at https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sts.html?highlight=assume_role#STS.Client.assume_role
                  "%
                  | optional,
                aws_secret_access_key
                  | String
                  | doc m%"
                  AWS secret access key. Can be auto-detected, see [the AWS boto3 docs](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html) for details.
                  "%
                  | optional,
                aws_session_token
                  | String
                  | doc m%"
                  AWS session token. Can be auto-detected, see [the AWS boto3 docs](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html) for details.
                  "%
                  | optional,
                catalog_id
                  | String
                  | doc m%"
                  The aws account id where the target glue catalog lives. If None, datahub will ingest glue in aws caller's account.
                  "%
                  | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for databases to filter in ingestion.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  regex patterns for tables to filter to assign domain_key. 
                  "%
                  | optional,
                emit_s3_lineage
                  | Bool
                  | doc m%"
                  Whether to emit S3-to-Glue lineage.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                extract_owners
                  | Bool
                  | doc m%"
                  When enabled, extracts ownership from Glue directly and overwrites existing owners. When disabled, ownership is left empty for datasets.
                  "%
                  | optional,
                extract_transforms
                  | Bool
                  | doc m%"
                  Whether to extract Glue transform jobs.
                  "%
                  | optional,
                glue_s3_lineage_direction
                  | String
                  | doc m%"
                  If `upstream`, S3 is upstream to Glue. If `downstream` S3 is downstream to Glue.
                  "%
                  | optional,
                ignore_resource_links
                  | Bool
                  | doc m%"
                  If set to True, ignore database resource links.
                  "%
                  | optional,
                ignore_unsupported_connectors
                  | Bool
                  | doc m%"
                  Whether to ignore unsupported connectors. If disabled, an error will be raised.
                  "%
                  | optional,
                platform
                  | String
                  | doc m%"
                  The platform to use for the dataset URNs. Must be one of ['glue', 'athena'].
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GlueProfilingConfig
                  | doc m%"
                  Configs to ingest data profiles from glue table
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for tables to filter in ingestion.
                  "%
                  | optional,
                use_s3_bucket_tags
                  | Bool
                  | doc m%"
                  If an S3 Buckets Tags should be created for the Tables ingested by Glue. Please Note that this will not apply tags to any folders ingested, only the files.
                  "%
                  | optional,
                use_s3_object_tags
                  | Bool
                  | doc m%"
                  If an S3 Objects Tags should be created for the Tables ingested by Glue.
                  "%
                  | optional,
              },
          hana = {
                config | definitions.contract.hana_config,
                type | std.enum.TagOrString | [| 'hana |],
                ..
              },
          hana_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port | String | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                scheme | String | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          hive = {
                config | definitions.contract.hive_config,
                type | std.enum.TagOrString | [| 'hive |],
                ..
              },
          hive_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for databases to filter in ingestion.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Deprecated in favour of database_pattern.
                  "%
                  | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          iceberg = {
                config | definitions.contract.iceberg_config,
                type | std.enum.TagOrString | [| 'iceberg |],
                ..
              },
          iceberg_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                catalog
                  | predicates.contract_from_predicate
                  definitions.predicate.IcebergCatalogConfig
                  | doc m%"
                  Catalog configuration where to find Iceberg tables.  See [pyiceberg's catalog configuration details](https://py.iceberg.apache.org/configuration/).
                  "%,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                group_ownership_property
                  | String
                  | doc m%"
                  Iceberg table property to look for a `CorpGroup` owner.  Can only hold a single group value.  If property has no value, no owner information will be emitted.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.IcebergProfilingConfig
                  | optional,
                stateful_ingestion
                  | predicates.contract_from_predicate
                  definitions.predicate.StatefulStaleMetadataRemovalConfig
                  | doc m%"
                  Iceberg Stateful Ingestion Config.
                  "%
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion.
                  "%
                  | optional,
                user_ownership_property
                  | String
                  | doc m%"
                  Iceberg table property to look for a `CorpUser` owner.  Can only hold a single user value.  If property has no value, no owner information will be emitted.
                  "%
                  | optional,
              },
          json-schema = {
                config | definitions.contract.json-schema_config,
                type | std.enum.TagOrString | [| 'json-schema |],
                ..
              },
          json-schema_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.maxLength 65536,
                      predicates.strings.minLength 1
                    ]
                  ])
                  | doc m%"
                  Set this to a single file-path or a directory-path (for recursive traversal) or a remote url. e.g. https://json.schemastore.org/petstore-v1.0.json
                  "%,
                platform
                  | String
                  | doc m%"
                  Set this to a platform that you want all schemas to live under. e.g. schemaregistry / schemarepo etc.
                  "%,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                uri_replace_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.URIReplacePattern
                  | doc m%"
                  Use this if URI-s need to be modified during reference resolution. Simple string match - replace capabilities are supported.
                  "%
                  | optional,
                use_id_as_base_uri
                  | Bool
                  | doc m%"
                  When enabled, uses the `$id` field in the json schema as the base uri for following references.
                  "%
                  | optional,
              },
          kafka = {
                config | definitions.contract.kafka_config,
                type | std.enum.TagOrString | [| 'kafka |],
                ..
              },
          kafka-connect = {
                config | definitions.contract.kafka-connect_config,
                type | std.enum.TagOrString | [| 'kafka-connect |],
                ..
              },
          kafka-connect_config
            | doc m%"
            Any source that connects to a platform should inherit this class
            "%
            = {
                cluster_name
                  | String
                  | doc m%"
                  Cluster to ingest from.
                  "%
                  | optional,
                connect_to_platform_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ])
                  ])
                  | doc m%"
                  Platform instance mapping when multiple instances for a platform is available. Entry for a platform should be in either `platform_instance_map` or `connect_to_platform_map`. e.g.`connect_to_platform_map: { "postgres-connector-finance-db": "postgres": "core_finance_instance" }`
                  "%
                  | optional,
                connect_uri
                  | String
                  | doc m%"
                  URI to connect to.
                  "%
                  | optional,
                connector_patterns
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for connectors to filter for ingestion.
                  "%
                  | optional,
                convert_lineage_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert the urns of ingested lineage dataset to lowercase
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                generic_connectors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.GenericConnectorConfig
                  ])
                  | doc m%"
                  Provide lineage graph for sources connectors other than Confluent JDBC Source Connector, Debezium Source Connector, and Mongo Source Connector
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  Kafka Connect password.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                platform_instance_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Platform instance mapping to use when constructing URNs. e.g.`platform_instance_map: { "hive": "warehouse" }`
                  "%
                  | optional,
                provided_configs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ProvidedConfig
                  ])
                  | doc m%"
                  Provided Configurations
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                username
                  | String
                  | doc m%"
                  Kafka Connect username.
                  "%
                  | optional,
              },
          kafka_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                connection
                  | predicates.contract_from_predicate
                  definitions.predicate.KafkaConsumerConnectionConfig
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                disable_topic_record_naming_strategy
                  | Bool
                  | doc m%"
                  Disables the utilization of the TopicRecordNameStrategy for Schema Registry subjects. For more information, visit: https://docs.confluent.io/platform/current/schema-registry/serdes-develop/index.html#handling-differences-between-preregistered-and-client-derived-schemas:~:text=io.confluent.kafka.serializers.subject.TopicRecordNameStrategy
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  A map of domain names to allow deny patterns. Domains can be urn-based (`urn:li:domain:13ae4d85-d955-49fc-8474-9004c663a810`) or bare (`13ae4d85-d955-49fc-8474-9004c663a810`).
                  "%
                  | optional,
                enable_meta_mapping
                  | Bool
                  | doc m%"
                  When enabled, applies the mappings that are defined through the meta_mapping directives.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                field_meta_mapping
                  | {  .. }
                  | doc m%"
                  mapping rules that will be executed against field-level schema properties. Refer to the section below on meta automated mappings.
                  "%
                  | optional,
                ignore_warnings_on_schema_type
                  | Bool
                  | doc m%"
                  Disables warnings reported for non-AVRO/Protobuf value or key schemas if set.
                  "%
                  | optional,
                meta_mapping
                  | {  .. }
                  | doc m%"
                  mapping rules that will be executed against top-level schema properties. Refer to the section below on meta automated mappings.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                schema_registry_class
                  | String
                  | doc m%"
                  The fully qualified implementation class(custom) that implements the KafkaSchemaRegistryBase interface.
                  "%
                  | optional,
                schema_tags_field
                  | String
                  | doc m%"
                  The field name in the schema metadata that contains the tags to be added to the dataset.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                strip_user_ids_from_email
                  | Bool
                  | doc m%"
                  Whether or not to strip email id while adding owners using meta mappings.
                  "%
                  | optional,
                tag_prefix
                  | String
                  | doc m%"
                  Prefix added to tags during ingestion.
                  "%
                  | optional,
                topic_patterns
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | optional,
                topic_subject_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Provides the mapping for the `key` and the `value` schemas of a topic to the corresponding schema registry subject name. Each entry of this map has the form `<topic_name>-key`:`<schema_registry_subject_name_for_key_schema>` and `<topic_name>-value`:`<schema_registry_subject_name_for_value_schema>` for the key and the value schemas associated with the topic, respectively. This parameter is mandatory when the [RecordNameStrategy](https://docs.confluent.io/platform/current/schema-registry/serdes-develop/index.html#how-the-naming-strategies-work) is used as the subject naming strategy in the kafka schema registry. NOTE: When provided, this overrides the default subject name resolution even when the `TopicNameStrategy` or the `TopicRecordNameStrategy` are used.
                  "%
                  | optional,
              },
          ldap = {
                config | definitions.contract.ldap_config,
                type | std.enum.TagOrString | [| 'ldap |],
                ..
              },
          ldap_config
            | doc m%"
            Config used by the LDAP Source.
            "%
            = {
                attrs_list
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Retrieved attributes list
                  "%
                  | optional,
                base_dn
                  | String
                  | doc m%"
                  LDAP DN.
                  "%,
                custom_props_list
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of custom attributes to extract from the LDAP provider.
                  "%
                  | optional,
                drop_missing_first_last_name
                  | Bool
                  | doc m%"
                  If set to true, any users without first and last names will be dropped.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                filter
                  | String
                  | doc m%"
                  LDAP extractor filter.
                  "%
                  | optional,
                group_attrs_map | {  .. } | optional,
                ldap_password
                  | String
                  | doc m%"
                  LDAP password.
                  "%,
                ldap_server
                  | String
                  | doc m%"
                  LDAP server URL.
                  "%,
                ldap_user
                  | String
                  | doc m%"
                  LDAP user.
                  "%,
                manager_filter_enabled
                  | Bool
                  | doc m%"
                  Use LDAP extractor filter to search managers.
                  "%
                  | optional,
                manager_pagination_enabled
                  | Bool
                  | doc m%"
                  [deprecated] Use pagination_enabled 
                  "%
                  | optional,
                page_size
                  | std.number.Integer
                  | doc m%"
                  Size of each page to fetch when extracting metadata.
                  "%
                  | optional,
                pagination_enabled
                  | Bool
                  | doc m%"
                  Use pagination while do search query (enabled by default).
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                use_email_as_username
                  | Bool
                  | doc m%"
                  Use email for users' usernames instead of username (disabled by default).             If enabled, the user and group urn would be having email as the id part of the urn.
                  "%
                  | optional,
                user_attrs_map | {  .. } | optional,
              },
          looker = {
                config | definitions.contract.looker_config,
                type | std.enum.TagOrString | [| 'looker |],
                ..
              },
          looker_config
            | doc m%"
            Any source that is a primary producer of Dataset metadata should inherit this class
            "%
            = {
                actor
                  | String
                  | doc m%"
                  This config is deprecated in favor of `extract_owners`. Previously, was the actor to use in ownership properties of ingested metadata.
                  "%
                  | optional,
                base_url
                  | String
                  | doc m%"
                  Url to your Looker instance: `https://company.looker.com:19999` or `https://looker.company.com`, or similar. Used for making API calls to Looker and constructing clickable dashboard and chart urls.
                  "%,
                chart_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Patterns for selecting chart ids that are to be included
                  "%
                  | optional,
                client_id
                  | String
                  | doc m%"
                  Looker API client id.
                  "%,
                client_secret
                  | String
                  | doc m%"
                  Looker API client secret.
                  "%,
                dashboard_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Patterns for selecting dashboard ids that are to be included
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                explore_browse_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.LookerNamingPattern
                  | doc m%"
                  Pattern for providing browse paths to explores. Allowed variables are ['platform', 'env', 'project', 'model', 'name']
                  "%
                  | optional,
                explore_naming_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.LookerNamingPattern
                  | doc m%"
                  Pattern for providing dataset names to explores. Allowed variables are ['platform', 'env', 'project', 'model', 'name']
                  "%
                  | optional,
                external_base_url
                  | String
                  | doc m%"
                  Optional URL to use when constructing external URLs to Looker if the `base_url` is not the correct one to use. For example, `https://looker-public.company.com`. If not provided, the external base URL will default to `base_url`.
                  "%
                  | optional,
                extract_column_level_lineage
                  | Bool
                  | doc m%"
                  When enabled, extracts column-level lineage from Views and Explores
                  "%
                  | optional,
                extract_embed_urls
                  | Bool
                  | doc m%"
                  Produce URLs used to render Looker Explores as Previews inside of DataHub UI. Embeds must be enabled inside of Looker to use this feature.
                  "%
                  | optional,
                extract_independent_looks
                  | Bool
                  | doc m%"
                  Extract looks which are not part of any Dashboard. To enable this flag the stateful_ingestion should also be enabled.
                  "%
                  | optional,
                extract_owners
                  | Bool
                  | doc m%"
                  When enabled, extracts ownership from Looker directly. When disabled, ownership is left empty for dashboards and charts.
                  "%
                  | optional,
                extract_usage_history
                  | Bool
                  | doc m%"
                  Whether to ingest usage statistics for dashboards. Setting this to True will query looker system activity explores to fetch historical dashboard usage.
                  "%
                  | optional,
                extract_usage_history_for_interval
                  | String
                  | doc m%"
                  Used only if extract_usage_history is set to True. Interval to extract looker dashboard usage history for. See https://docs.looker.com/reference/filter-expressions#date_and_time.
                  "%
                  | optional,
                include_deleted
                  | Bool
                  | doc m%"
                  Whether to include deleted dashboards and looks.
                  "%
                  | optional,
                max_threads
                  | std.number.Integer
                  | doc m%"
                  Max parallelism for Looker API calls. Defaults to cpuCount or 40
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                platform_name
                  | String
                  | doc m%"
                  Default platform name. Don't change.
                  "%
                  | optional,
                skip_personal_folders
                  | Bool
                  | doc m%"
                  Whether to skip ingestion of dashboards in personal folders. Setting this to True will only ingest dashboards in the Shared folder space.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                strip_user_ids_from_email
                  | Bool
                  | doc m%"
                  When enabled, converts Looker user emails of the form name@domain.com to urn:li:corpuser:name when assigning ownership
                  "%
                  | optional,
                tag_measures_and_dimensions
                  | Bool
                  | doc m%"
                  When enabled, attaches tags to measures, dimensions and dimension groups to make them more discoverable. When disabled, adds this information to the description of the column.
                  "%
                  | optional,
                transport_options
                  | predicates.contract_from_predicate
                  definitions.predicate.TransportOptionsConfig
                  | doc m%"
                  Populates the [TransportOptions](https://github.com/looker-open-source/sdk-codegen/blob/94d6047a0d52912ac082eb91616c1e7c379ab262/python/looker_sdk/rtl/transport.py#L70) struct for looker client
                  "%
                  | optional,
                view_browse_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.LookerViewNamingPattern
                  | doc m%"
                  Pattern for providing browse paths to views. Allowed variables are ['platform', 'env', 'project', 'model', 'name', 'file_path']
                  "%
                  | optional,
                view_naming_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.LookerViewNamingPattern
                  | doc m%"
                  Pattern for providing dataset names to views. Allowed variables are ['platform', 'env', 'project', 'model', 'name', 'file_path']
                  "%
                  | optional,
              },
          lookml = {
                config | definitions.contract.lookml_config,
                type | std.enum.TagOrString | [| 'lookml |],
                ..
              },
          lookml_config
            | doc m%"
            Any source that is a primary producer of Dataset metadata should inherit this class
            "%
            = {
                api | definitions.contract.LookerAPIConfig | optional,
                base_folder
                  | String
                  | doc m%"
                  Required if not providing github configuration and deploy keys. A pointer to a local directory (accessible to the ingestion system) where the root of the LookML repo has been checked out (typically via a git clone). This is typically the root folder where the `*.model.lkml` and `*.view.lkml` files are stored. e.g. If you have checked out your LookML repo under `/Users/jdoe/workspace/my-lookml-repo`, then set `base_folder` to `/Users/jdoe/workspace/my-lookml-repo`.
                  "%
                  | optional,
                connection_to_platform_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.LookerConnectionDefinition
                  ])
                  | doc m%"
                  A mapping of [Looker connection names](https://docs.looker.com/reference/model-params/connection-for-model) to DataHub platform, database, and schema values.
                  "%
                  | optional,
                emit_reachable_views_only
                  | Bool
                  | doc m%"
                  When enabled, only views that are reachable from explores defined in the model files are emitted
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                explore_browse_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.LookerNamingPattern
                  | doc m%"
                  Pattern for providing browse paths to explores. Allowed variables are ['platform', 'env', 'project', 'model', 'name']
                  "%
                  | optional,
                explore_naming_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.LookerNamingPattern
                  | doc m%"
                  Pattern for providing dataset names to explores. Allowed variables are ['platform', 'env', 'project', 'model', 'name']
                  "%
                  | optional,
                extract_column_level_lineage
                  | Bool
                  | doc m%"
                  When enabled, extracts column-level lineage from Views and Explores
                  "%
                  | optional,
                git_info
                  | predicates.contract_from_predicate
                  definitions.predicate.GitInfo
                  | doc m%"
                  Reference to your git location. If present, supplies handy links to your lookml on the dataset entity page.
                  "%
                  | optional,
                max_file_snippet_length
                  | std.number.Integer
                  | doc m%"
                  When extracting the view definition from a lookml file, the maximum number of characters to extract.
                  "%
                  | optional,
                model_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  List of regex patterns for LookML models to include in the extraction.
                  "%
                  | optional,
                parse_table_names_from_sql
                  | Bool
                  | doc m%"
                  See note below.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                platform_name
                  | String
                  | doc m%"
                  Default platform name. Don't change.
                  "%
                  | optional,
                populate_sql_logic_for_missing_descriptions
                  | Bool
                  | doc m%"
                  When enabled, field descriptions will include the sql logic for computed fields if descriptions are missing
                  "%
                  | optional,
                process_isolation_for_sql_parsing
                  | Bool
                  | doc m%"
                  When enabled, sql parsing will be executed in a separate process to prevent memory leaks.
                  "%
                  | optional,
                process_refinements
                  | Bool
                  | doc m%"
                  When enabled, looker refinement will be processed to adapt an existing view.
                  "%
                  | optional,
                project_dependencies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      definitions.predicate.GitInfo
                    ])
                  ])
                  | doc m%"
                  A map of project_name to local directory (accessible to the ingestion system) or Git credentials. Every local_dependencies or private remote_dependency listed in the main project's manifest.lkml file should have a corresponding entry here. If a deploy key is not provided, the ingestion system will use the same deploy key as the main project. 
                  "%
                  | optional,
                project_name
                  | String
                  | doc m%"
                  Required if you don't specify the `api` section. The project name within which all the model files live. See (https://docs.looker.com/data-modeling/getting-started/how-project-works) to understand what the Looker project name should be. The simplest way to see your projects is to click on `Develop` followed by `Manage LookML Projects` in the Looker application.
                  "%
                  | optional,
                sql_parser
                  | String
                  | doc m%"
                  See note below.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                tag_measures_and_dimensions
                  | Bool
                  | doc m%"
                  When enabled, attaches tags to measures, dimensions and dimension groups to make them more discoverable. When disabled, adds this information to the description of the column.
                  "%
                  | optional,
                transport_options
                  | predicates.contract_from_predicate
                  definitions.predicate.TransportOptionsConfig
                  | doc m%"
                  Populates the [TransportOptions](https://github.com/looker-open-source/sdk-codegen/blob/94d6047a0d52912ac082eb91616c1e7c379ab262/python/looker_sdk/rtl/transport.py#L70) struct for looker client
                  "%
                  | optional,
                view_browse_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.LookerViewNamingPattern
                  | doc m%"
                  Pattern for providing browse paths to views. Allowed variables are ['platform', 'env', 'project', 'model', 'name', 'file_path']
                  "%
                  | optional,
                view_naming_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.LookerViewNamingPattern
                  | doc m%"
                  Pattern for providing dataset names to views. Allowed variables are ['platform', 'env', 'project', 'model', 'name', 'file_path']
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  List of regex patterns for LookML views to include in the extraction.
                  "%
                  | optional,
              },
          mariadb = {
                config | definitions.contract.mariadb_config,
                type | std.enum.TagOrString | [| 'mariadb |],
                ..
              },
          mariadb_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for databases to filter in ingestion.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  MySQL host URL.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Deprecated in favour of database_pattern.
                  "%
                  | optional,
                scheme | String | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          metabase = {
                config | definitions.contract.metabase_config,
                type | std.enum.TagOrString | [| 'metabase |],
                ..
              },
          metabase_config
            | doc m%"
            Any non-Dataset source that produces lineage to Datasets should inherit this class.
            e.g. Orchestrators, Pipelines, BI Tools etc.
            "%
            = {
                connect_uri
                  | String
                  | doc m%"
                  Metabase host URL.
                  "%
                  | optional,
                database_alias_map
                  | {  .. }
                  | doc m%"
                  Database name map to use when constructing dataset URN.
                  "%
                  | optional,
                database_id_to_instance_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Custom mappings between metabase database id and DataHub platform instance
                  "%
                  | optional,
                default_schema
                  | String
                  | doc m%"
                  Default schema name to use when schema is not provided in an SQL query
                  "%
                  | optional,
                engine_platform_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Custom mappings between metabase database engines and DataHub platforms
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  Metabase password.
                  "%
                  | optional,
                platform_instance_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A holder for platform -> platform_instance mappings to generate correct dataset urns
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  Metabase username.
                  "%
                  | optional,
              },
          mlflow = {
                config | definitions.contract.mlflow_config,
                type | std.enum.TagOrString | [| 'mlflow |],
                ..
              },
          mlflow_config
            | doc m%"
            Any source that produces dataset urns in a single environment should inherit this class
            "%
            = {
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                model_name_separator
                  | String
                  | doc m%"
                  A string which separates model name from its version (e.g. model_1 or model-1)
                  "%
                  | optional,
                registry_uri
                  | String
                  | doc m%"
                  Registry server URI. If not set, an MLflow default registry_uri is used (value of tracking_uri or `MLFLOW_REGISTRY_URI` environment variable)
                  "%
                  | optional,
                tracking_uri
                  | String
                  | doc m%"
                  Tracking server URI. If not set, an MLflow default tracking_uri is used (local `mlruns/` directory or `MLFLOW_TRACKING_URI` environment variable)
                  "%
                  | optional,
              },
          mode = {
                config | definitions.contract.mode_config,
                type | std.enum.TagOrString | [| 'mode |],
                ..
              },
          mode_config
            | doc m%"
            Any non-Dataset source that produces lineage to Datasets should inherit this class.
            e.g. Orchestrators, Pipelines, BI Tools etc.
            "%
            = {
                api_options
                  | predicates.contract_from_predicate
                  definitions.predicate.ModeAPIConfig
                  | doc m%"
                  Retry/Wait settings for Mode API to avoid "Too many Requests" error. See Mode API Options below
                  "%
                  | optional,
                connect_uri
                  | String
                  | doc m%"
                  Mode host URL.
                  "%
                  | optional,
                default_schema
                  | String
                  | doc m%"
                  Default schema to use when schema is not provided in an SQL query
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                owner_username_instead_of_email
                  | Bool
                  | doc m%"
                  Use username for owner URN instead of Email
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  Mode password for authentication.
                  "%,
                platform_instance_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A holder for platform -> platform_instance mappings to generate correct dataset urns
                  "%
                  | optional,
                token
                  | String
                  | doc m%"
                  Mode user token.
                  "%,
                workspace | String | optional,
              },
          mongodb = {
                config | definitions.contract.mongodb_config,
                type | std.enum.TagOrString | [| 'mongodb |],
                ..
              },
          mongodb_config
            | doc m%"
            Any source that produces dataset urns in a single environment should inherit this class
            "%
            = {
                authMechanism
                  | String
                  | doc m%"
                  MongoDB authentication mechanism.
                  "%
                  | optional,
                collection_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for collections to filter in ingestion.
                  "%
                  | optional,
                connect_uri
                  | String
                  | doc m%"
                  MongoDB connection URI.
                  "%
                  | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for databases to filter in ingestion.
                  "%
                  | optional,
                enableSchemaInference
                  | Bool
                  | doc m%"
                  Whether to infer schemas. 
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                maxDocumentSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | optional,
                maxSchemaSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  Maximum number of fields to include in the schema.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Additional options to pass to `pymongo.MongoClient()`.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  MongoDB password.
                  "%
                  | optional,
                schemaSamplingSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  Number of documents to use when inferring schema size. If set to `0`, all documents will be scanned.
                  "%
                  | optional,
                useRandomSampling
                  | Bool
                  | doc m%"
                  If documents for schema inference should be randomly selected. If `False`, documents will be selected from start.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  MongoDB username.
                  "%
                  | optional,
              },
          mssql = {
                config | definitions.contract.mssql_config,
                type | std.enum.TagOrString | [| 'mssql |],
                ..
              },
          mssql_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Enable to convert the SQL Server assets urns to lowercase
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog). If set to Null, all databases will be considered for ingestion.
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for databases to filter in ingestion.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  MSSQL host URL.
                  "%
                  | optional,
                include_descriptions
                  | Bool
                  | doc m%"
                  Include table descriptions information.
                  "%
                  | optional,
                include_jobs
                  | Bool
                  | doc m%"
                  Include ingest of MSSQL Jobs. Requires access to the 'msdb' and 'sys' schema.
                  "%
                  | optional,
                include_stored_procedures
                  | Bool
                  | doc m%"
                  Include ingest of stored procedures. Requires access to the 'sys' schema.
                  "%
                  | optional,
                include_stored_procedures_code
                  | Bool
                  | doc m%"
                  Include information about object code.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                uri_args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Arguments to URL-encode when connecting. See https://docs.microsoft.com/en-us/sql/connect/odbc/dsn-connection-string-attribute?view=sql-server-ver15.
                  "%
                  | optional,
                use_odbc
                  | Bool
                  | doc m%"
                  See https://docs.sqlalchemy.org/en/14/dialects/mssql.html#module-sqlalchemy.dialects.mssql.pyodbc.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          mysql = {
                config | definitions.contract.mysql_config,
                type | std.enum.TagOrString | [| 'mysql |],
                ..
              },
          mysql_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for databases to filter in ingestion.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  MySQL host URL.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Deprecated in favour of database_pattern.
                  "%
                  | optional,
                scheme | String | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          nifi = {
                config | definitions.contract.nifi_config,
                type | std.enum.TagOrString | [| 'nifi |],
                ..
              },
          nifi_config
            | doc m%"
            Any source that produces dataset urns in a single environment should inherit this class
            "%
            = {
                auth
                  | predicates.contract_from_predicate
                  definitions.predicate.NifiAuthType
                  | doc m%"
                  Nifi authentication. must be one of : NO_AUTH, SINGLE_USER, CLIENT_CERT, KERBEROS
                  "%
                  | optional,
                ca_file
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Path to PEM file containing certs for the root CA(s) for the NiFi
                  "%
                  | optional,
                client_cert_file
                  | String
                  | doc m%"
                  Path to PEM file containing the public certificates for the user/client identity, must be set for auth = "CLIENT_CERT"
                  "%
                  | optional,
                client_key_file
                  | String
                  | doc m%"
                  Path to PEM file containing the client’s secret key
                  "%
                  | optional,
                client_key_password
                  | String
                  | doc m%"
                  The password to decrypt the client_key_file
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  Nifi password, must be set for auth = "SINGLE_USER"
                  "%
                  | optional,
                process_group_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for filtering process groups
                  "%
                  | optional,
                provenance_days
                  | std.number.Integer
                  | doc m%"
                  time window to analyze provenance events for external datasets
                  "%
                  | optional,
                site_name
                  | String
                  | doc m%"
                  Site name to identify this site with, useful when using input and output ports receiving remote connections
                  "%
                  | optional,
                site_url
                  | String
                  | doc m%"
                  URL for Nifi, ending with /nifi/. e.g. https://mynifi.domain/nifi/
                  "%,
                site_url_to_site_name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Lookup to find site_name for site_url ending with /nifi/, required if using remote process groups in nifi flow
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  Nifi username, must be set for auth = "SINGLE_USER"
                  "%
                  | optional,
              },
          okta = {
                config | definitions.contract.okta_config,
                type | std.enum.TagOrString | [| 'okta |],
                ..
              },
          okta_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                delay_seconds
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Number", predicates.isType 'Integer ])
                  | doc m%"
                  Number of seconds to wait between calls to Okta's REST APIs. (Okta rate limits). Defaults to 10ms.
                  "%
                  | optional,
                include_deprovisioned_users
                  | Bool
                  | doc m%"
                  Whether to ingest users in the DEPROVISIONED state from Okta.
                  "%
                  | optional,
                include_suspended_users
                  | Bool
                  | doc m%"
                  Whether to ingest users in the SUSPENDED state from Okta.
                  "%
                  | optional,
                ingest_group_membership
                  | Bool
                  | doc m%"
                  Whether group membership should be ingested into DataHub. ingest_groups must be True if this is True.
                  "%
                  | optional,
                ingest_groups
                  | Bool
                  | doc m%"
                  Whether groups should be ingested into DataHub.
                  "%
                  | optional,
                ingest_users
                  | Bool
                  | doc m%"
                  Whether users should be ingested into DataHub.
                  "%
                  | optional,
                mask_group_id | Bool | optional,
                mask_user_id | Bool | optional,
                okta_api_token
                  | String
                  | doc m%"
                  An API token generated for the DataHub application inside your Okta Developer Console. e.g. 00be4R_M2MzDqXawbWgfKGpKee0kuEOfX1RCQSRx00
                  "%,
                okta_domain
                  | String
                  | doc m%"
                  The location of your Okta Domain, without a protocol. Can be found in Okta Developer console. e.g. dev-33231928.okta.com
                  "%,
                okta_groups_filter
                  | String
                  | doc m%"
                  Okta filter expression (not regex) for ingesting groups. Only one of `okta_groups_filter` and `okta_groups_search` can be set. See (https://developer.okta.com/docs/reference/api/groups/#filters) for more info.
                  "%
                  | optional,
                okta_groups_search
                  | String
                  | doc m%"
                  Okta search expression (not regex) for ingesting groups. Only one of `okta_groups_filter` and `okta_groups_search` can be set. See (https://developer.okta.com/docs/reference/api/groups/#list-groups-with-search) for more info.
                  "%
                  | optional,
                okta_profile_to_group_name_attr
                  | String
                  | doc m%"
                  Which Okta Group Profile attribute to use as input to DataHub group name mapping.
                  "%
                  | optional,
                okta_profile_to_group_name_regex
                  | String
                  | doc m%"
                  A regex used to parse the DataHub group name from the attribute specified in `okta_profile_to_group_name_attr`.
                  "%
                  | optional,
                okta_profile_to_username_attr
                  | String
                  | doc m%"
                  Which Okta User Profile attribute to use as input to DataHub username mapping. Common values used are - login, email.
                  "%
                  | optional,
                okta_profile_to_username_regex
                  | String
                  | doc m%"
                  A regex used to parse the DataHub username from the attribute specified in `okta_profile_to_username_attr`.
                  "%
                  | optional,
                okta_users_filter
                  | String
                  | doc m%"
                  Okta filter expression (not regex) for ingesting users. Only one of `okta_users_filter` and `okta_users_search` can be set. See (https://developer.okta.com/docs/reference/api/users/#list-users-with-a-filter) for more info.
                  "%
                  | optional,
                okta_users_search
                  | String
                  | doc m%"
                  Okta search expression (not regex) for ingesting users. Only one of `okta_users_filter` and `okta_users_search` can be set. See (https://developer.okta.com/docs/reference/api/users/#list-users-with-search) for more info.
                  "%
                  | optional,
                page_size
                  | std.number.Integer
                  | doc m%"
                  The number of entities requested from Okta's REST APIs in one request.
                  "%
                  | optional,
                stateful_ingestion
                  | predicates.contract_from_predicate
                  definitions.predicate.StatefulStaleMetadataRemovalConfig
                  | doc m%"
                  Okta Stateful Ingestion Config.
                  "%
                  | optional,
              },
          openapi = {
                config | definitions.contract.openapi_config,
                type | std.enum.TagOrString | [| 'openapi |],
                ..
              },
          openapi_config = {
                forced_examples | {  .. } | optional,
                get_token | {  .. } | optional,
                ignore_endpoints
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf predicates.always
                  ])
                  | optional,
                name | String,
                password | String | optional,
                swagger_file | String,
                token | String | optional,
                url | String,
                username | String | optional,
              },
          oracle = {
                config | definitions.contract.oracle_config,
                type | std.enum.TagOrString | [| 'oracle |],
                ..
              },
          oracle_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                add_database_name_to_urn
                  | Bool
                  | doc m%"
                  Add oracle database name to urn, default urn is schema.table
                  "%
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  If using, omit `service_name`.
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                scheme
                  | String
                  | doc m%"
                  Will be set automatically to default value.
                  "%
                  | optional,
                service_name
                  | String
                  | doc m%"
                  Oracle service name. If using, omit `database`.
                  "%
                  | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          postgres = {
                config | definitions.contract.postgres_config,
                type | std.enum.TagOrString | [| 'postgres |],
                ..
              },
          postgres_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog). If set to Null, all databases will be considered for ingestion.
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for databases to filter in ingestion. Note: this is not used if `database` or `sqlalchemy_uri` are provided.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_view_lineage
                  | Bool
                  | doc m%"
                  Include table lineage for views
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                initial_database
                  | String
                  | doc m%"
                  Initial database used to query for the list of databases, when ingesting multiple databases. Note: this is not used if `database` or `sqlalchemy_uri` are provided.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | optional,
                scheme
                  | String
                  | doc m%"
                  database scheme
                  "%
                  | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          powerbi = {
                config | definitions.contract.powerbi_config,
                type | std.enum.TagOrString | [| 'powerbi |],
                ..
              },
          powerbi-report-server = {
                config | definitions.contract.powerbi-report-server_config,
                type | std.enum.TagOrString | [| 'powerbi-report-server |],
                ..
              },
          powerbi-report-server_config
            | doc m%"
            Any source that produces dataset urns in a single environment should inherit this class
            "%
            = {
                chart_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                extract_ownership
                  | Bool
                  | doc m%"
                  Whether ownership should be ingested
                  "%
                  | optional,
                graphql_url
                  | String
                  | doc m%"
                  [deprecated] Not used
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  Power BI Report Server host URL
                  "%,
                ownership_type
                  | String
                  | doc m%"
                  Ownership type of owner
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  Windows account password
                  "%,
                platform_name | String | optional,
                platform_urn | String | optional,
                report_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | optional,
                report_server_virtual_directory_name
                  | String
                  | doc m%"
                  Report Server Virtual Directory URL name
                  "%,
                report_virtual_directory_name
                  | String
                  | doc m%"
                  Report Virtual Directory URL name
                  "%,
                server_alias
                  | String
                  | doc m%"
                  Alias for Power BI Report Server host URL
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  Windows account username
                  "%,
                workstation_name
                  | String
                  | doc m%"
                  Workstation name
                  "%
                  | optional,
              },
          powerbi_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                admin_apis_only
                  | Bool
                  | doc m%"
                  Retrieve metadata using PowerBI Admin API only. If this is enabled, then Report Pages will not be extracted. Admin API access is required if this setting is enabled
                  "%
                  | optional,
                client_id
                  | String
                  | doc m%"
                  Azure app client identifier
                  "%,
                client_secret
                  | String
                  | doc m%"
                  Azure app client secret
                  "%,
                convert_lineage_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert the urns of ingested lineage dataset to lowercase
                  "%
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert the PowerBI assets urns to lowercase
                  "%
                  | optional,
                enable_advance_lineage_sql_construct
                  | Bool
                  | doc m%"
                  Whether to enable advance native sql construct for parsing like join, sub-queries. along this flag , the native_query_parsing should be enabled. By default convert_lineage_urns_to_lowercase is enabled, in-case if you have disabled it in previous ingestion execution then it may break lineage as this option generates the upstream datasets URN in lowercase.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                extract_column_level_lineage
                  | Bool
                  | doc m%"
                  Whether to extract column level lineage. Works only if configs `native_query_parsing`, `enable_advance_lineage_sql_construct` & `extract_lineage` are enabled.  Works for M-Query where native SQL is used for transformation.
                  "%
                  | optional,
                extract_dashboards
                  | Bool
                  | doc m%"
                  Whether to ingest PBI Dashboard and Tiles as Datahub Dashboard and Chart
                  "%
                  | optional,
                extract_dataset_schema
                  | Bool
                  | doc m%"
                  Whether to ingest PBI Dataset Table columns and measures
                  "%
                  | optional,
                extract_datasets_to_containers
                  | Bool
                  | doc m%"
                  PBI tables will be grouped under a Datahub Container, the container reflect a PBI Dataset
                  "%
                  | optional,
                extract_endorsements_to_tags
                  | Bool
                  | doc m%"
                  Whether to extract endorsements to tags, note that this may overwrite existing tags. Admin API access is required is this setting is enabled
                  "%
                  | optional,
                extract_independent_datasets
                  | Bool
                  | doc m%"
                  Whether to extract datasets not used in any PowerBI visualization
                  "%
                  | optional,
                extract_lineage
                  | Bool
                  | doc m%"
                  Whether lineage should be ingested between X and Y. Admin API access is required if this setting is enabled
                  "%
                  | optional,
                extract_ownership
                  | Bool
                  | doc m%"
                  Whether ownership should be ingested. Admin API access is required if this setting is enabled. Note that enabling this may overwrite owners that you've added inside DataHub's web application.
                  "%
                  | optional,
                extract_reports
                  | Bool
                  | doc m%"
                  Whether reports should be ingested
                  "%
                  | optional,
                extract_workspaces_to_containers
                  | Bool
                  | doc m%"
                  Extract workspaces to DataHub containers
                  "%
                  | optional,
                filter_dataset_endorsements
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Filter and ingest datasets which are 'Certified' or 'Promoted' endorsement. If both are added, dataset which are 'Certified' or 'Promoted' will be ingested . Default setting allows all dataset to be ingested
                  "%
                  | optional,
                modified_since
                  | String
                  | doc m%"
                  Get only recently modified workspaces based on modified_since datetime '2023-02-10T00:00:00.0000000Z', excludePersonalWorkspaces and excludeInActiveWorkspaces limit to last 30 days
                  "%
                  | optional,
                native_query_parsing
                  | Bool
                  | doc m%"
                  Whether PowerBI native query should be parsed to extract lineage
                  "%
                  | optional,
                ownership
                  | predicates.contract_from_predicate
                  definitions.predicate.OwnershipMapping
                  | doc m%"
                  Configure how is ownership ingested
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                scan_batch_size
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 100,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  batch size for sending workspace_ids to PBI, 100 is the limit
                  "%
                  | optional,
                scan_timeout
                  | std.number.Integer
                  | doc m%"
                  timeout for PowerBI metadata scanning
                  "%
                  | optional,
                server_to_platform_instance
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.PlatformDetail
                  ])
                  | doc m%"
                  A mapping of PowerBI datasource's server i.e host[:port] to Data platform instance. :port is optional and only needed if your datasource server is running on non-standard port.For Google BigQuery the datasource's server is google bigquery project name
                  "%
                  | optional,
                stateful_ingestion
                  | predicates.contract_from_predicate
                  definitions.predicate.StatefulStaleMetadataRemovalConfig
                  | doc m%"
                  PowerBI Stateful Ingestion Config.
                  "%
                  | optional,
                tenant_id
                  | String
                  | doc m%"
                  PowerBI tenant identifier
                  "%,
                workspace_id_as_urn_part
                  | Bool
                  | doc m%"
                  Highly recommend changing this to True, as you can have the same workspace nameTo maintain backward compatability, this is set to False which uses workspace name
                  "%
                  | optional,
                workspace_id_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter PowerBI workspaces in ingestion
                  "%
                  | optional,
              },
          presto = {
                config | definitions.contract.presto_config,
                type | std.enum.TagOrString | [| 'presto |],
                ..
              },
          presto-on-hive = {
                config | definitions.contract.presto-on-hive_config,
                type | std.enum.TagOrString | [| 'presto-on-hive |],
                ..
              },
          presto-on-hive_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for hive/presto database to filter in ingestion. Specify regex to only match the database name. e.g. to match all tables in database analytics, use the regex 'analytics'
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                enable_properties_merge
                  | Bool
                  | doc m%"
                  By default, the connector overwrites properties every time. Set this to True to enable merging of properties with what exists on the server.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  Host URL and port to connect to. Example: localhost:3306
                  "%
                  | optional,
                include_catalog_name_in_ids
                  | Bool
                  | doc m%"
                  Add the Presto catalog name (e.g. hive) to the generated dataset urns. `urn:li:dataset:(urn:li:dataPlatform:hive,hive.user.logging_events,PROD)` versus `urn:li:dataset:(urn:li:dataPlatform:hive,user.logging_events,PROD)`
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                ingestion_job_id | String | optional,
                metastore_db_name
                  | String
                  | doc m%"
                  Name of the Hive metastore's database (usually: metastore). For backward compatibility, if this field is not provided, the database field will be used. If both the 'database' and 'metastore_db_name' fields are set then the 'database' field will be used to filter the hive/presto/trino database
                  "%
                  | optional,
                mode
                  | predicates.contract_from_predicate
                  definitions.predicate.PrestoOnHiveConfigMode
                  | doc m%"
                  The ingested data will be stored under this platform. Valid options: ['hive', 'presto', 'presto-on-hive', 'trino']
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                schemas_where_clause_suffix
                  | String
                  | doc m%"
                  Where clause to specify what Hive schemas should be ingested.
                  "%
                  | optional,
                simplify_nested_field_paths
                  | Bool
                  | doc m%"
                  Simplify v2 field paths to v1 by default. If the schema has Union or Array types, still falls back to v2
                  "%
                  | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                tables_where_clause_suffix
                  | String
                  | doc m%"
                  Where clause to specify what Hive tables should be ingested.
                  "%
                  | optional,
                use_catalog_subtype
                  | Bool
                  | doc m%"
                  Container Subtype name to be 'Database' or 'Catalog' Valid options: ['True', 'False']
                  "%
                  | optional,
                use_dataset_pascalcase_subtype
                  | Bool
                  | doc m%"
                  Dataset Subtype name to be 'Table' or 'View' Valid options: ['True', 'False']
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                views_where_clause_suffix
                  | String
                  | doc m%"
                  Where clause to specify what Presto views should be ingested.
                  "%
                  | optional,
              },
          presto_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          pulsar = {
                config | definitions.contract.pulsar_config,
                type | std.enum.TagOrString | [| 'pulsar |],
                ..
              },
          pulsar_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                client_id
                  | String
                  | doc m%"
                  The application's client ID
                  "%
                  | optional,
                client_secret
                  | String
                  | doc m%"
                  The application's client secret
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Domain patterns
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                exclude_individual_partitions
                  | Bool
                  | doc m%"
                  Extract each individual partitioned topic. e.g. when turned off a topic with 100 partitions will result in 100 Datasets.
                  "%
                  | optional,
                issuer_url
                  | String
                  | doc m%"
                  The complete URL for a Custom Authorization Server. Mandatory for OAuth based authentication.
                  "%
                  | optional,
                namespace_patterns
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  List of regex patterns for namespaces to include/exclude from ingestion. By default the functions namespace is denied.
                  "%
                  | optional,
                oid_config
                  | {  .. }
                  | doc m%"
                  Placeholder for OpenId discovery document
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                stateful_ingestion
                  | predicates.contract_from_predicate
                  definitions.predicate.StatefulStaleMetadataRemovalConfig
                  | doc m%"
                  see Stateful Ingestion
                  "%
                  | optional,
                tenant_patterns
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  List of regex patterns for tenants to include/exclude from ingestion. By default all tenants are allowed.
                  "%
                  | optional,
                tenants
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Listing all tenants requires superUser role, alternative you can set a list of tenants you want to scrape using the tenant admin role
                  "%
                  | optional,
                timeout
                  | std.number.Integer
                  | doc m%"
                  Timout setting, how long to wait for the Pulsar rest api to send data before giving up
                  "%
                  | optional,
                token
                  | String
                  | doc m%"
                  The access token for the application. Mandatory for token based authentication.
                  "%
                  | optional,
                topic_patterns
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  List of regex patterns for topics to include/exclude from ingestion. By default the Pulsar system topics are denied.
                  "%
                  | optional,
                verify_ssl
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Either a boolean, in which case it controls whether we verify the server's TLS certificate, or a string, in which case it must be a path to a CA bundle to use.
                  "%
                  | optional,
                web_service_url
                  | String
                  | doc m%"
                  The web URL for the cluster.
                  "%
                  | optional,
              },
          redash = {
                config | definitions.contract.redash_config,
                type | std.enum.TagOrString | [| 'redash |],
                ..
              },
          redash_config = {
                api_key
                  | String
                  | doc m%"
                  Redash user API key.
                  "%
                  | optional,
                api_page_limit
                  | std.number.Integer
                  | doc m%"
                  Limit on number of pages queried for ingesting dashboards and charts API during pagination.
                  "%
                  | optional,
                chart_patterns
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for charts to filter for ingestion.
                  "%
                  | optional,
                connect_uri
                  | String
                  | doc m%"
                  Redash base URL.
                  "%
                  | optional,
                dashboard_patterns
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for dashboards to filter for ingestion.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  Environment to use in namespace when constructing URNs.
                  "%
                  | optional,
                page_size
                  | std.number.Integer
                  | doc m%"
                  Limit on number of items to be queried at once.
                  "%
                  | optional,
                parallelism
                  | std.number.Integer
                  | doc m%"
                  Parallelism to use while processing.
                  "%
                  | optional,
                parse_table_names_from_sql
                  | Bool
                  | doc m%"
                  See note below.
                  "%
                  | optional,
                skip_draft
                  | Bool
                  | doc m%"
                  Only ingest published dashboards and charts.
                  "%
                  | optional,
                sql_parser
                  | String
                  | doc m%"
                  custom SQL parser. See note below for details.
                  "%
                  | optional,
              },
          redshift = {
                config | definitions.contract.redshift_config,
                type | std.enum.TagOrString | [| 'redshift |],
                ..
              },
          redshift-legacy = {
                config | definitions.contract.redshift-legacy_config,
                type | std.enum.TagOrString | [| 'redshift-legacy |],
                ..
              },
          redshift-legacy_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                bucket_duration
                  | predicates.contract_from_predicate
                  definitions.predicate.BucketDuration
                  | doc m%"
                  Size of the time window to aggregate usage stats.
                  "%
                  | optional,
                capture_lineage_query_parser_failures
                  | Bool
                  | doc m%"
                  Whether to capture lineage query parser errors with dataset properties for debuggings
                  "%
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                default_schema
                  | String
                  | doc m%"
                  The default schema to use if the sql parser fails to parse the schema with `sql_based` lineage collector
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                end_time
                  | String
                  | doc m%"
                  Latest date of lineage/usage to consider. Default: Current time in UTC
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                include_copy_lineage
                  | Bool
                  | doc m%"
                  Whether lineage should be collected from copy commands
                  "%
                  | optional,
                include_table_lineage
                  | Bool
                  | doc m%"
                  Whether table lineage should be ingested.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_unload_lineage
                  | Bool
                  | doc m%"
                  Whether lineage should be collected from unload commands
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                platform_instance_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A holder for platform -> platform_instance mappings to generate correct dataset urns
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                s3_lineage_config
                  | predicates.contract_from_predicate
                  definitions.predicate.S3LineageProviderConfig
                  | doc m%"
                  Common config for S3 lineage generation
                  "%
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                start_time
                  | String
                  | doc m%"
                  Earliest date of lineage/usage to consider. Default: Last full day in UTC (or hour, depending on `bucket_duration`). You can also specify relative time with respect to end_time such as '-7 days' Or '-7d'.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_lineage_mode
                  | predicates.contract_from_predicate
                  definitions.predicate.LineageMode
                  | doc m%"
                  Which table lineage collector mode to use. Available modes are: [stl_scan_based, sql_based, mixed]
                  "%
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          redshift-usage-legacy = {
                config | definitions.contract.redshift-usage-legacy_config,
                type | std.enum.TagOrString | [| 'redshift-usage-legacy |],
                ..
              },
          redshift-usage-legacy_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                bucket_duration
                  | predicates.contract_from_predicate
                  definitions.predicate.BucketDuration
                  | doc m%"
                  Size of the time window to aggregate usage stats.
                  "%
                  | optional,
                capture_lineage_query_parser_failures
                  | Bool
                  | doc m%"
                  Whether to capture lineage query parser errors with dataset properties for debuggings
                  "%
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                default_schema
                  | String
                  | doc m%"
                  The default schema to use if the sql parser fails to parse the schema with `sql_based` lineage collector
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                email_domain
                  | String
                  | doc m%"
                  Email domain of your organisation so users can be displayed on UI appropriately.
                  "%,
                end_time
                  | String
                  | doc m%"
                  Latest date of lineage/usage to consider. Default: Current time in UTC
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                format_sql_queries
                  | Bool
                  | doc m%"
                  Whether to format sql queries
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                include_copy_lineage
                  | Bool
                  | doc m%"
                  Whether lineage should be collected from copy commands
                  "%
                  | optional,
                include_operational_stats
                  | Bool
                  | doc m%"
                  Whether to display operational stats.
                  "%
                  | optional,
                include_read_operational_stats
                  | Bool
                  | doc m%"
                  Whether to report read operational stats. Experimental.
                  "%
                  | optional,
                include_table_lineage
                  | Bool
                  | doc m%"
                  Whether table lineage should be ingested.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_top_n_queries
                  | Bool
                  | doc m%"
                  Whether to ingest the top_n_queries.
                  "%
                  | optional,
                include_unload_lineage
                  | Bool
                  | doc m%"
                  Whether lineage should be collected from unload commands
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to SQLAlchemy's create_engine as kwargs.See https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine for details.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                platform_instance_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A holder for platform -> platform_instance mappings to generate correct dataset urns
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                s3_lineage_config
                  | predicates.contract_from_predicate
                  definitions.predicate.S3LineageProviderConfig
                  | doc m%"
                  Common config for S3 lineage generation
                  "%
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                start_time
                  | String
                  | doc m%"
                  Earliest date of lineage/usage to consider. Default: Last full day in UTC (or hour, depending on `bucket_duration`). You can also specify relative time with respect to end_time such as '-7 days' Or '-7d'.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_lineage_mode
                  | predicates.contract_from_predicate
                  definitions.predicate.LineageMode
                  | doc m%"
                  Which table lineage collector mode to use. Available modes are: [stl_scan_based, sql_based, mixed]
                  "%
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                top_n_queries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  Number of top queries to save to each table.
                  "%
                  | optional,
                user_email_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for user emails to filter in usage.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          redshift_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                bucket_duration
                  | predicates.contract_from_predicate
                  definitions.predicate.BucketDuration
                  | doc m%"
                  Size of the time window to aggregate usage stats.
                  "%
                  | optional,
                capture_lineage_query_parser_failures
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Whether to capture lineage query parser errors with dataset properties for debugging
                  "%
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                default_schema
                  | String
                  | doc m%"
                  The default schema to use if the sql parser fails to parse the schema with `sql_based` lineage collector
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                email_domain
                  | String
                  | doc m%"
                  Email domain of your organisation so users can be displayed on UI appropriately.
                  "%
                  | optional,
                enable_stateful_lineage_ingestion
                  | Bool
                  | doc m%"
                  Enable stateful lineage ingestion. This will store lineage window timestamps after successful lineage ingestion. and will not run lineage ingestion for same timestamps in subsequent run. 
                  "%
                  | optional,
                enable_stateful_profiling
                  | Bool
                  | doc m%"
                  Enable stateful profiling. This will store profiling timestamps per dataset after successful profiling. and will not run profiling again in subsequent run if table has not been updated. 
                  "%
                  | optional,
                enable_stateful_usage_ingestion
                  | Bool
                  | doc m%"
                  Enable stateful lineage ingestion. This will store usage window timestamps after successful usage ingestion. and will not run usage ingestion for same timestamps in subsequent run. 
                  "%
                  | optional,
                end_time
                  | String
                  | doc m%"
                  Latest date of lineage/usage to consider. Default: Current time in UTC
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                extra_client_options | {  .. } | optional,
                extract_column_level_lineage
                  | Bool
                  | doc m%"
                  Whether to extract column level lineage.
                  "%
                  | optional,
                format_sql_queries
                  | Bool
                  | doc m%"
                  Whether to format sql queries
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                include_copy_lineage
                  | Bool
                  | doc m%"
                  Whether lineage should be collected from copy commands
                  "%
                  | optional,
                include_operational_stats
                  | Bool
                  | doc m%"
                  Whether to display operational stats.
                  "%
                  | optional,
                include_read_operational_stats
                  | Bool
                  | doc m%"
                  Whether to report read operational stats. Experimental.
                  "%
                  | optional,
                include_table_lineage
                  | Bool
                  | doc m%"
                  Whether table lineage should be ingested.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_top_n_queries
                  | Bool
                  | doc m%"
                  Whether to ingest the top_n_queries.
                  "%
                  | optional,
                include_unload_lineage
                  | Bool
                  | doc m%"
                  Whether lineage should be collected from unload commands
                  "%
                  | optional,
                include_usage_statistics
                  | Bool
                  | doc m%"
                  Generate usage statistic. email_domain config parameter needs to be set if enabled
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                incremental_lineage
                  | Bool
                  | doc m%"
                  When enabled, emits lineage as incremental to existing lineage already in DataHub. When disabled, re-states lineage on each run.
                  "%
                  | optional,
                match_fully_qualified_names
                  | Bool
                  | doc m%"
                  Whether `schema_pattern` is matched against fully qualified schema name `<database>.<schema>`.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                platform_instance_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A holder for platform -> platform_instance mappings to generate correct dataset urns
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                s3_lineage_config
                  | predicates.contract_from_predicate
                  definitions.predicate.S3LineageProviderConfig
                  | doc m%"
                  Common config for S3 lineage generation
                  "%
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | optional,
                scheme
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | optional,
                sql_parser_use_external_process
                  | Bool
                  | doc m%"
                  When enabled, sql parser will run in isolated in a separate process. This can affect processing time but can protect from sql parser's mem leak.
                  "%
                  | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                start_time
                  | String
                  | doc m%"
                  Earliest date of lineage/usage to consider. Default: Last full day in UTC (or hour, depending on `bucket_duration`). You can also specify relative time with respect to end_time such as '-7 days' Or '-7d'.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_lineage_mode
                  | predicates.contract_from_predicate
                  definitions.predicate.LineageMode
                  | doc m%"
                  Which table lineage collector mode to use. Available modes are: [stl_scan_based, sql_based, mixed]
                  "%
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                top_n_queries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  Number of top queries to save to each table.
                  "%
                  | optional,
                user_email_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for user emails to filter in usage.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          s3 = {
                config | definitions.contract.s3_config,
                type | std.enum.TagOrString | [| 's3 |],
                ..
              },
          s3_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                aws_config
                  | predicates.contract_from_predicate
                  definitions.predicate.AwsConnectionConfig
                  | doc m%"
                  AWS configuration
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                max_rows
                  | std.number.Integer
                  | doc m%"
                  Maximum number of rows to use when inferring schemas for TSV and CSV files.
                  "%
                  | optional,
                number_of_files_to_sample
                  | std.number.Integer
                  | doc m%"
                  Number of files to list to sample for schema inference. This will be ignored if sample_files is set to False in the pathspec.
                  "%
                  | optional,
                path_specs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.PathSpec
                  ])
                  | doc m%"
                  List of PathSpec. See [below](#path-spec) the details about PathSpec
                  "%,
                platform
                  | String
                  | doc m%"
                  The platform that this source connects to (either 's3' or 'file'). If not specified, the platform will be inferred from the path_specs.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_patterns
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for tables to profile 
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.DataLakeProfilerConfig
                  | doc m%"
                  Data profiling configuration
                  "%
                  | optional,
                spark_config
                  | {  .. }
                  | doc m%"
                  Spark configuration properties to set on the SparkSession. Put config property names into quotes. For example: '"spark.executor.memory": "2g"'
                  "%
                  | optional,
                spark_driver_memory
                  | String
                  | doc m%"
                  Max amount of memory to grant Spark.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                use_s3_bucket_tags
                  | Bool
                  | doc m%"
                  Whether or not to create tags in datahub from the s3 bucket
                  "%
                  | optional,
                use_s3_object_tags
                  | Bool
                  | doc m%"
                  Whether or not to create tags in datahub from the s3 object
                  "%
                  | optional,
                verify_ssl
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Either a boolean, in which case it controls whether we verify the server's TLS certificate, or a string, in which case it must be a path to a CA bundle to use.
                  "%
                  | optional,
              },
          sagemaker = {
                config | definitions.contract.sagemaker_config,
                type | std.enum.TagOrString | [| 'sagemaker |],
                ..
              },
          sagemaker_config
            | doc m%"
            Common AWS credentials config.
            
            Currently used by:
                - Glue source
                - SageMaker source
            "%
            = {
                aws_access_key_id
                  | String
                  | doc m%"
                  AWS access key ID. Can be auto-detected, see [the AWS boto3 docs](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html) for details.
                  "%
                  | optional,
                aws_endpoint_url
                  | String
                  | doc m%"
                  The AWS service endpoint. This is normally [constructed automatically](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/core/session.html), but can be overridden here.
                  "%
                  | optional,
                aws_profile
                  | String
                  | doc m%"
                  Named AWS profile to use. Only used if access key / secret are unset. If not set the default will be used
                  "%
                  | optional,
                aws_proxy
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A set of proxy configs to use with AWS. See the [botocore.config](https://botocore.amazonaws.com/v1/documentation/api/latest/reference/config.html) docs for details.
                  "%
                  | optional,
                aws_region
                  | String
                  | doc m%"
                  AWS region code.
                  "%,
                aws_role
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.AwsAssumeRoleConfig
                      ])
                    ]
                  ])
                  | doc m%"
                  AWS roles to assume. If using the string format, the role ARN can be specified directly. If using the object format, the role can be specified in the RoleArn field and additional available arguments are documented at https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sts.html?highlight=assume_role#STS.Client.assume_role
                  "%
                  | optional,
                aws_secret_access_key
                  | String
                  | doc m%"
                  AWS secret access key. Can be auto-detected, see [the AWS boto3 docs](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html) for details.
                  "%
                  | optional,
                aws_session_token
                  | String
                  | doc m%"
                  AWS session token. Can be auto-detected, see [the AWS boto3 docs](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html) for details.
                  "%
                  | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for databases to filter in ingestion.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                extract_feature_groups
                  | Bool
                  | doc m%"
                  Whether to extract feature groups.
                  "%
                  | optional,
                extract_jobs
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ],
                    predicates.isType '"Bool"
                  ])
                  | doc m%"
                  Whether to extract AutoML jobs.
                  "%
                  | optional,
                extract_models
                  | Bool
                  | doc m%"
                  Whether to extract models.
                  "%
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for tables to filter in ingestion.
                  "%
                  | optional,
              },
          salesforce = {
                config | definitions.contract.salesforce_config,
                type | std.enum.TagOrString | [| 'salesforce |],
                ..
              },
          salesforce_config
            | doc m%"
            Any source that is a primary producer of Dataset metadata should inherit this class
            "%
            = {
                access_token
                  | String
                  | doc m%"
                  Access token for instance url
                  "%
                  | optional,
                auth
                  | predicates.contract_from_predicate
                  definitions.predicate.SalesforceAuthType
                  | optional,
                consumer_key
                  | String
                  | doc m%"
                  Consumer key for Salesforce JSON web token access
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Regex patterns for tables/schemas to describe domain_key domain key (domain_key can be any string like "sales".) There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                ingest_tags
                  | Bool
                  | doc m%"
                  Ingest Tags from source. This will override Tags entered from UI
                  "%
                  | optional,
                instance_url
                  | String
                  | doc m%"
                  Salesforce instance url. e.g. https://MyDomainName.my.salesforce.com
                  "%
                  | optional,
                is_sandbox
                  | Bool
                  | doc m%"
                  Connect to Sandbox instance of your Salesforce
                  "%
                  | optional,
                object_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for Salesforce objects to filter in ingestion.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  Password for Salesforce user
                  "%
                  | optional,
                platform | String | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                private_key
                  | String
                  | doc m%"
                  Private key as a string for Salesforce JSON web token access
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for profiles to filter in ingestion, allowed by the `object_pattern`.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.SalesforceProfilingConfig
                  | optional,
                security_token
                  | String
                  | doc m%"
                  Security token for Salesforce username
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  Salesforce username
                  "%
                  | optional,
              },
          snowflake = {
                config | definitions.contract.snowflake_config,
                type | std.enum.TagOrString | [| 'snowflake |],
                ..
              },
          snowflake_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                account_id
                  | String
                  | doc m%"
                  Snowflake account identifier. e.g. xy12345,  xy12345.us-east-2.aws, xy12345.us-central1.gcp, xy12345.central-us.azure, xy12345.us-west-2.privatelink. Refer [Account Identifiers](https://docs.snowflake.com/en/user-guide/admin-account-identifier.html#format-2-legacy-account-locator-in-a-region) for more details.
                  "%,
                apply_view_usage_to_tables
                  | Bool
                  | doc m%"
                  Whether to apply view's usage to its base tables. If set to True, usage is applied to base tables only.
                  "%
                  | optional,
                authentication_type
                  | String
                  | doc m%"
                  The type of authenticator to use when connecting to Snowflake. Supports "DEFAULT_AUTHENTICATOR", "OAUTH_AUTHENTICATOR", "EXTERNAL_BROWSER_AUTHENTICATOR" and "KEY_PAIR_AUTHENTICATOR".
                  "%
                  | optional,
                bucket_duration
                  | predicates.contract_from_predicate
                  definitions.predicate.BucketDuration
                  | doc m%"
                  Size of the time window to aggregate usage stats.
                  "%
                  | optional,
                classification
                  | predicates.contract_from_predicate
                  definitions.predicate.ClassificationConfig
                  | doc m%"
                  For details, refer [Classification](../../../../metadata-ingestion/docs/dev_guides/classification.md).
                  "%
                  | optional,
                connect_args
                  | {  .. }
                  | doc m%"
                  Connect args to pass to Snowflake SqlAlchemy driver
                  "%
                  | optional,
                convert_urns_to_lowercase | Bool | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                email_as_user_identifier
                  | Bool
                  | doc m%"
                  Format user urns as an email, if the snowflake user's email is set. If `email_domain` is provided, generates email addresses for snowflake users with unset emails, based on their username.
                  "%
                  | optional,
                email_domain
                  | String
                  | doc m%"
                  Email domain of your organisation so users can be displayed on UI appropriately.
                  "%
                  | optional,
                enable_stateful_lineage_ingestion
                  | Bool
                  | doc m%"
                  Enable stateful lineage ingestion. This will store lineage window timestamps after successful lineage ingestion. and will not run lineage ingestion for same timestamps in subsequent run. 
                  "%
                  | optional,
                enable_stateful_profiling
                  | Bool
                  | doc m%"
                  Enable stateful profiling. This will store profiling timestamps per dataset after successful profiling. and will not run profiling again in subsequent run if table has not been updated. 
                  "%
                  | optional,
                enable_stateful_usage_ingestion
                  | Bool
                  | doc m%"
                  Enable stateful lineage ingestion. This will store usage window timestamps after successful usage ingestion. and will not run usage ingestion for same timestamps in subsequent run. 
                  "%
                  | optional,
                end_time
                  | String
                  | doc m%"
                  Latest date of lineage/usage to consider. Default: Current time in UTC
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                extract_tags
                  | predicates.contract_from_predicate
                  definitions.predicate.TagOption
                  | doc m%"
                  Optional. Allowed values are `without_lineage`, `with_lineage`, and `skip` (default). `without_lineage` only extracts tags that have been applied directly to the given entity. `with_lineage` extracts both directly applied and propagated tags, but will be significantly slower. See the [Snowflake documentation](https://docs.snowflake.com/en/user-guide/object-tagging.html#tag-lineage) for information about tag lineage/propagation. 
                  "%
                  | optional,
                format_sql_queries
                  | Bool
                  | doc m%"
                  Whether to format sql queries
                  "%
                  | optional,
                ignore_start_time_lineage | Bool | optional,
                include_column_lineage
                  | Bool
                  | doc m%"
                  Populates table->table and view->table column lineage. Requires appropriate grants given to the role and the Snowflake Enterprise Edition or above.
                  "%
                  | optional,
                include_external_url
                  | Bool
                  | doc m%"
                  Whether to populate Snowsight url for Snowflake Objects
                  "%
                  | optional,
                include_operational_stats
                  | Bool
                  | doc m%"
                  Whether to display operational stats.
                  "%
                  | optional,
                include_read_operational_stats
                  | Bool
                  | doc m%"
                  Whether to report read operational stats. Experimental.
                  "%
                  | optional,
                include_table_lineage
                  | Bool
                  | doc m%"
                  If enabled, populates the snowflake table-to-table and s3-to-snowflake table lineage. Requires appropriate grants given to the role and Snowflake Enterprise Edition or above.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_technical_schema
                  | Bool
                  | doc m%"
                  If enabled, populates the snowflake technical schema and descriptions.
                  "%
                  | optional,
                include_top_n_queries
                  | Bool
                  | doc m%"
                  Whether to ingest the top_n_queries.
                  "%
                  | optional,
                include_usage_stats
                  | Bool
                  | doc m%"
                  If enabled, populates the snowflake usage statistics. Requires appropriate grants given to the role.
                  "%
                  | optional,
                include_view_column_lineage
                  | Bool
                  | doc m%"
                  Populates view->view and table->view column lineage using DataHub's sql parser.
                  "%
                  | optional,
                include_view_lineage
                  | Bool
                  | doc m%"
                  If enabled, populates the snowflake view->table and table->view lineages. Requires appropriate grants given to the role, and include_table_lineage to be True. view->table lineage requires Snowflake Enterprise Edition or above.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                incremental_lineage
                  | Bool
                  | doc m%"
                  When enabled, emits lineage as incremental to existing lineage already in DataHub. When disabled, re-states lineage on each run.
                  "%
                  | optional,
                match_fully_qualified_names
                  | Bool
                  | doc m%"
                  Whether `schema_pattern` is matched against fully qualified schema name `<catalog>.<schema>`.
                  "%
                  | optional,
                oauth_config
                  | predicates.contract_from_predicate
                  definitions.predicate.OAuthConfiguration
                  | doc m%"
                  oauth configuration - https://docs.snowflake.com/en/user-guide/python-connector-example.html#connecting-with-oauth
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  Snowflake password.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                private_key
                  | String
                  | doc m%"
                  Private key in a form of '-----BEGIN PRIVATE KEY-----\nprivate-key\n-----END PRIVATE KEY-----\n' if using key pair authentication. Encrypted version of private key will be in a form of '-----BEGIN ENCRYPTED PRIVATE KEY-----\nencrypted-private-key\n-----END ECNCRYPTED PRIVATE KEY-----\n' See: https://docs.snowflake.com/en/user-guide/key-pair-auth.html
                  "%
                  | optional,
                private_key_password
                  | String
                  | doc m%"
                  Password for your private key. Required if using key pair authentication with encrypted private key.
                  "%
                  | optional,
                private_key_path
                  | String
                  | doc m%"
                  The path to the private key if using key pair authentication. Ignored if `private_key` is set. See: https://docs.snowflake.com/en/user-guide/key-pair-auth.html
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                role
                  | String
                  | doc m%"
                  Snowflake role.
                  "%
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                scheme | String | optional,
                shares
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.SnowflakeShareConfig
                  ])
                  | doc m%"
                  Required if current account owns or consumes snowflake share. If specified, connector creates lineage and siblings relationship between current account's database tables and consumer/producer account's database tables. Map of share name -> details of share.
                  "%
                  | optional,
                sql_parser_use_external_process
                  | Bool
                  | doc m%"
                  When enabled, sql parser will run in isolated in a separate process. This can affect processing time but can protect from sql parser's mem leak.
                  "%
                  | optional,
                start_time
                  | String
                  | doc m%"
                  Earliest date of lineage/usage to consider. Default: Last full day in UTC (or hour, depending on `bucket_duration`). You can also specify relative time with respect to end_time such as '-7 days' Or '-7d'.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                tag_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  List of regex patterns for tags to include in ingestion. Only used if `extract_tags` is enabled.
                  "%
                  | optional,
                temporary_tables_pattern
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  [Advanced] Regex patterns for temporary tables to filter in lineage ingestion. Specify regex to match the entire table name in database.schema.table format. Defaults are to set in such a way to ignore the temporary staging tables created by known ETL tools.
                  "%
                  | optional,
                top_n_queries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  Number of top queries to save to each table.
                  "%
                  | optional,
                upstream_lineage_in_report | Bool | optional,
                user_email_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for user emails to filter in usage.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  Snowflake username.
                  "%
                  | optional,
                validate_upstreams_against_patterns
                  | Bool
                  | doc m%"
                  Whether to validate upstream snowflake tables against allow-deny patterns
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                warehouse
                  | String
                  | doc m%"
                  Snowflake warehouse.
                  "%
                  | optional,
              },
          sql-queries = {
                config | definitions.contract.sql-queries_config,
                type | std.enum.TagOrString | [| 'sql-queries |],
                ..
              },
          sql-queries_config
            | doc m%"
            Any source that connects to a platform should inherit this class
            "%
            = {
                default_db
                  | String
                  | doc m%"
                  The default database to use for unqualified table names
                  "%
                  | optional,
                default_schema
                  | String
                  | doc m%"
                  The default schema to use for unqualified table names
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                platform
                  | String
                  | doc m%"
                  The platform for which to generate data, e.g. snowflake
                  "%,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                query_file
                  | String
                  | doc m%"
                  Path to file to ingest
                  "%,
                usage
                  | predicates.contract_from_predicate
                  definitions.predicate.BaseUsageConfig
                  | doc m%"
                  The usage config to use when generating usage statistics
                  "%
                  | optional,
              },
          sqlalchemy = {
                config | definitions.contract.sqlalchemy_config,
                type | std.enum.TagOrString | [| 'sqlalchemy |],
                ..
              },
          sqlalchemy_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                connect_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls
                  "%,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                platform
                  | String
                  | doc m%"
                  Name of platform being ingested, used in constructing URNs.
                  "%,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          starburst-trino-usage = {
                config | definitions.contract.starburst-trino-usage_config,
                type | std.enum.TagOrString | [| 'starburst-trino-usage |],
                ..
              },
          starburst-trino-usage_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                audit_catalog
                  | String
                  | doc m%"
                  The catalog name where the audit table can be found 
                  "%,
                audit_schema
                  | String
                  | doc m%"
                  The schema name where the audit table can be found
                  "%,
                bucket_duration
                  | predicates.contract_from_predicate
                  definitions.predicate.BucketDuration
                  | doc m%"
                  Size of the time window to aggregate usage stats.
                  "%
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  The name of the catalog from getting the usage
                  "%,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                email_domain
                  | String
                  | doc m%"
                  The email domain which will be appended to the users 
                  "%,
                end_time
                  | String
                  | doc m%"
                  Latest date of lineage/usage to consider. Default: Current time in UTC
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                format_sql_queries
                  | Bool
                  | doc m%"
                  Whether to format sql queries
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                include_operational_stats
                  | Bool
                  | doc m%"
                  Whether to display operational stats.
                  "%
                  | optional,
                include_read_operational_stats
                  | Bool
                  | doc m%"
                  Whether to report read operational stats. Experimental.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_top_n_queries
                  | Bool
                  | doc m%"
                  Whether to ingest the top_n_queries.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options | {  .. } | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                start_time
                  | String
                  | doc m%"
                  Earliest date of lineage/usage to consider. Default: Last full day in UTC (or hour, depending on `bucket_duration`). You can also specify relative time with respect to end_time such as '-7 days' Or '-7d'.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                top_n_queries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  Number of top queries to save to each table.
                  "%
                  | optional,
                user_email_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for user emails to filter in usage.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          superset = {
                config | definitions.contract.superset_config,
                type | std.enum.TagOrString | [| 'superset |],
                ..
              },
          superset_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                connect_uri
                  | String
                  | doc m%"
                  Superset host URL.
                  "%
                  | optional,
                database_alias
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Can be used to change mapping for database names in superset to what you have in datahub
                  "%
                  | optional,
                display_uri
                  | String
                  | doc m%"
                  optional URL to use in links (if `connect_uri` is only for ingestion)
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  Environment to use in namespace when constructing URNs
                  "%
                  | optional,
                options | {  .. } | optional,
                password
                  | String
                  | doc m%"
                  Superset password.
                  "%
                  | optional,
                provider
                  | String
                  | doc m%"
                  Superset provider.
                  "%
                  | optional,
                stateful_ingestion
                  | predicates.contract_from_predicate
                  definitions.predicate.StatefulStaleMetadataRemovalConfig
                  | doc m%"
                  Superset Stateful Ingestion Config.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  Superset username.
                  "%
                  | optional,
              },
          tableau = {
                config | definitions.contract.tableau_config,
                type | std.enum.TagOrString | [| 'tableau |],
                ..
              },
          tableau_config
            | doc m%"
            Any non-Dataset source that produces lineage to Datasets should inherit this class.
            e.g. Orchestrators, Pipelines, BI Tools etc.
            "%
            = {
                connect_uri
                  | String
                  | doc m%"
                  Tableau host URL.
                  "%,
                default_schema_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  Default schema to use when schema is not found.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  Environment to use in namespace when constructing URNs.
                  "%
                  | optional,
                extract_column_level_lineage
                  | Bool
                  | doc m%"
                  When enabled, extracts column-level lineage from Tableau Datasources
                  "%
                  | optional,
                extract_lineage_from_unsupported_custom_sql_queries
                  | Bool
                  | doc m%"
                  [Experimental] Whether to extract lineage from unsupported custom sql queries using SQL parsing
                  "%
                  | optional,
                extract_project_hierarchy
                  | Bool
                  | doc m%"
                  Whether to extract entire project hierarchy for nested projects.
                  "%
                  | optional,
                extract_usage_stats
                  | Bool
                  | doc m%"
                  [experimental] Extract usage statistics for dashboards and charts.
                  "%
                  | optional,
                ingest_embed_url
                  | Bool
                  | doc m%"
                  Ingest a URL to render an embedded Preview of assets within Tableau.
                  "%
                  | optional,
                ingest_external_links_for_charts
                  | Bool
                  | doc m%"
                  Ingest a URL to link out to from charts.
                  "%
                  | optional,
                ingest_external_links_for_dashboards
                  | Bool
                  | doc m%"
                  Ingest a URL to link out to from dashboards.
                  "%
                  | optional,
                ingest_owner
                  | Bool
                  | doc m%"
                  Ingest Owner from source. This will override Owner info entered from UI
                  "%
                  | optional,
                ingest_tables_external
                  | Bool
                  | doc m%"
                  Ingest details for tables external to (not embedded in) tableau as entities.
                  "%
                  | optional,
                ingest_tags
                  | Bool
                  | doc m%"
                  Ingest Tags from source. This will override Tags entered from UI
                  "%
                  | optional,
                lineage_overrides
                  | predicates.contract_from_predicate
                  definitions.predicate.TableauLineageOverrides
                  | doc m%"
                  Mappings to change generated dataset urns. Use only if you really know what you are doing.
                  "%
                  | optional,
                page_size
                  | std.number.Integer
                  | doc m%"
                  [advanced] Number of metadata objects (e.g. CustomSQLTable, PublishedDatasource, etc) to query at a time using the Tableau API.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  Tableau password, must be set if authenticating using username/password.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                platform_instance_map
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A holder for platform -> platform_instance mappings to generate correct dataset urns
                  "%
                  | optional,
                project_path_separator
                  | String
                  | doc m%"
                  The separator used for the project_pattern field between project names. By default, we use a slash. You can change this if your Tableau projects contain slashes in their names, and you'd like to filter by project.
                  "%
                  | optional,
                project_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Filter for specific Tableau projects. For example, use 'My Project' to ingest a root-level Project with name 'My Project', or 'My Project/Nested Project' to ingest a nested Project with name 'Nested Project'. By default, all Projects nested inside a matching Project will be included in ingestion. You can both allow and deny projects based on their name using their name, or a Regex pattern. Deny patterns always take precedence over allow patterns. By default, all projects will be ingested.
                  "%
                  | optional,
                projects
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  [deprecated] Use project_pattern instead. List of tableau projects 
                  "%
                  | optional,
                site
                  | String
                  | doc m%"
                  Tableau Site. Always required for Tableau Online. Use emptystring to connect with Default site on Tableau Server.
                  "%
                  | optional,
                ssl_verify
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Whether to verify SSL certificates. If using self-signed certificates, set to false or provide the path to the .pem certificate bundle.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                token_name
                  | String
                  | doc m%"
                  Tableau token name, must be set if authenticating using a personal access token.
                  "%
                  | optional,
                token_value
                  | String
                  | doc m%"
                  Tableau token value, must be set if authenticating using a personal access token.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  Tableau username, must be set if authenticating using username/password.
                  "%
                  | optional,
                workbook_page_size
                  | std.number.Integer
                  | doc m%"
                  [advanced] Number of workbooks to query at a time using the Tableau API.
                  "%
                  | optional,
              },
          teradata = {
                config | definitions.contract.teradata_config,
                type | std.enum.TagOrString | [| 'teradata |],
                ..
              },
          teradata_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                bucket_duration
                  | predicates.contract_from_predicate
                  definitions.predicate.BucketDuration
                  | doc m%"
                  Size of the time window to aggregate usage stats.
                  "%
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                database_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for databases to filter in ingestion.
                  "%
                  | optional,
                default_db
                  | String
                  | doc m%"
                  The default database to use for unqualified table names
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                end_time
                  | String
                  | doc m%"
                  Latest date of lineage/usage to consider. Default: Current time in UTC
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                include_table_lineage
                  | Bool
                  | doc m%"
                  Whether to include table lineage in the ingestion. This requires to have the table lineage feature enabled.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_usage_statistics
                  | Bool
                  | doc m%"
                  Generate usage statistic.
                  "%
                  | optional,
                include_view_lineage
                  | Bool
                  | doc m%"
                  Whether to include view lineage in the ingestion. This requires to have the view lineage feature enabled.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Deprecated in favour of database_pattern.
                  "%
                  | optional,
                scheme
                  | String
                  | doc m%"
                  database scheme
                  "%
                  | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                start_time
                  | String
                  | doc m%"
                  Earliest date of lineage/usage to consider. Default: Last full day in UTC (or hour, depending on `bucket_duration`). You can also specify relative time with respect to end_time such as '-7 days' Or '-7d'.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                usage
                  | predicates.contract_from_predicate
                  definitions.predicate.BaseUsageConfig
                  | doc m%"
                  The usage config to use when generating usage statistics
                  "%
                  | optional,
                use_file_backed_cache
                  | Bool
                  | doc m%"
                  Whether to use a file backed cache for the view definitions.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          trino = {
                config | definitions.contract.trino_config,
                type | std.enum.TagOrString | [| 'trino |],
                ..
              },
          trino_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
          unity-catalog = {
                config | definitions.contract.unity-catalog_config,
                type | std.enum.TagOrString | [| 'unity-catalog |],
                ..
              },
          unity-catalog_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                bucket_duration
                  | predicates.contract_from_predicate
                  definitions.predicate.BucketDuration
                  | doc m%"
                  Size of the time window to aggregate usage stats.
                  "%
                  | optional,
                catalog_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for catalogs to filter in ingestion. Specify regex to match the full `metastore.catalog` name.
                  "%
                  | optional,
                column_lineage_column_limit
                  | std.number.Integer
                  | doc m%"
                  Limit the number of columns to get column level lineage. 
                  "%
                  | optional,
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to catalogs, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                enable_stateful_profiling
                  | Bool
                  | doc m%"
                  Enable stateful profiling. This will store profiling timestamps per dataset after successful profiling. and will not run profiling again in subsequent run if table has not been updated. 
                  "%
                  | optional,
                end_time
                  | String
                  | doc m%"
                  Latest date of lineage/usage to consider. Default: Current time in UTC
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                format_sql_queries
                  | Bool
                  | doc m%"
                  Whether to format sql queries
                  "%
                  | optional,
                include_column_lineage
                  | Bool
                  | doc m%"
                  Option to enable/disable lineage generation. Currently we have to call a rest call per column to get column level lineage due to the Databrick api which can slow down ingestion. 
                  "%
                  | optional,
                include_metastore
                  | Bool
                  | doc m%"
                  Whether to ingest the workspace's metastore as a container and include it in all urns. Changing this will affect the urns of all entities in the workspace. This will be disabled by default in the future, so it is recommended to set this to `False` for new ingestions. If you have an existing unity catalog ingestion, you'll want to avoid duplicates by soft deleting existing data. If stateful ingestion is enabled, running with `include_metastore: false` should be sufficient. Otherwise, we recommend deleting via the cli: `datahub delete --platform databricks` and re-ingesting with `include_metastore: false`.
                  "%
                  | optional,
                include_notebooks
                  | Bool
                  | doc m%"
                  Ingest notebooks, represented as DataHub datasets.
                  "%
                  | optional,
                include_operational_stats
                  | Bool
                  | doc m%"
                  Whether to display operational stats.
                  "%
                  | optional,
                include_ownership
                  | Bool
                  | doc m%"
                  Option to enable/disable ownership generation for metastores, catalogs, schemas, and tables.
                  "%
                  | optional,
                include_read_operational_stats
                  | Bool
                  | doc m%"
                  Whether to report read operational stats. Experimental.
                  "%
                  | optional,
                include_table_lineage
                  | Bool
                  | doc m%"
                  Option to enable/disable lineage generation.
                  "%
                  | optional,
                include_top_n_queries
                  | Bool
                  | doc m%"
                  Whether to ingest the top_n_queries.
                  "%
                  | optional,
                include_usage_statistics
                  | Bool
                  | doc m%"
                  Generate usage statistics.
                  "%
                  | optional,
                ingest_data_platform_instance_aspect
                  | Bool
                  | doc m%"
                  Option to enable/disable ingestion of the data platform instance aspect. The default data platform instance id for a dataset is workspace_name
                  "%
                  | optional,
                notebook_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for notebooks to filter in ingestion, based on notebook *path*. Specify regex to match the entire notebook path in `/<dir>/.../<name>` format. e.g. to match all notebooks in the root Shared directory, use the regex `/Shared/.*`.
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.UnityCatalogProfilerConfig
                  | doc m%"
                  Data profiling configuration
                  "%
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to the full `metastore.catalog.schema` name. e.g. to match all tables in schema analytics, use the regex `^mymetastore\.mycatalog\.analytics$`.
                  "%
                  | optional,
                start_time
                  | String
                  | doc m%"
                  Earliest date of lineage/usage to consider. Default: Last full day in UTC (or hour, depending on `bucket_duration`). You can also specify relative time with respect to end_time such as '-7 days' Or '-7d'.
                  "%
                  | optional,
                stateful_ingestion
                  | predicates.contract_from_predicate
                  definitions.predicate.StatefulStaleMetadataRemovalConfig
                  | doc m%"
                  Unity Catalog Stateful Ingestion Config.
                  "%
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in `catalog.schema.table` format. e.g. to match all tables starting with customer in Customer catalog and public schema, use the regex `Customer\.public\.customer.*`.
                  "%
                  | optional,
                token
                  | String
                  | doc m%"
                  Databricks personal access token
                  "%,
                top_n_queries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.exclusiveMinimum 0
                  ])
                  | doc m%"
                  Number of top queries to save to each table.
                  "%
                  | optional,
                user_email_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  regex patterns for user emails to filter in usage.
                  "%
                  | optional,
                workspace_name
                  | String
                  | doc m%"
                  Name of the workspace. Default to deployment name present in workspace_url
                  "%
                  | optional,
                workspace_url
                  | String
                  | doc m%"
                  Databricks workspace url. e.g. https://my-workspace.cloud.databricks.com
                  "%,
              },
          vertica = {
                config | definitions.contract.vertica_config,
                type | std.enum.TagOrString | [| 'vertica |],
                ..
              },
          vertica_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = {
                convert_urns_to_lowercase
                  | Bool
                  | doc m%"
                  Whether to convert dataset urns to lowercase.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  database (catalog)
                  "%
                  | optional,
                database_alias
                  | String
                  | doc m%"
                  [Deprecated] Alias to apply to database when ingesting.
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.AllowDenyPattern
                  ])
                  | doc m%"
                  Attach domains to databases, schemas or tables during ingestion using regex patterns. Domain key can be a guid like *urn:li:domain:ec428203-ce86-4db3-985d-5a8ee6df32ba* or a string like "Marketing".) If you provide strings, then datahub will attempt to resolve this name to a guid, and will error out if this fails. There can be multiple domain keys specified.
                  "%
                  | optional,
                env
                  | String
                  | doc m%"
                  The environment that all assets produced by this connector belong to
                  "%
                  | optional,
                host_port
                  | String
                  | doc m%"
                  host URL
                  "%,
                include_models
                  | Bool
                  | doc m%"
                  Whether Models should be ingested.
                  "%
                  | optional,
                include_projection_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include view lineage to the underlying storage location.
                  "%
                  | optional,
                include_projections
                  | Bool
                  | doc m%"
                  Whether projections should be ingested.
                  "%
                  | optional,
                include_table_location_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include table lineage to the underlying storage location.
                  "%
                  | optional,
                include_tables
                  | Bool
                  | doc m%"
                  Whether tables should be ingested.
                  "%
                  | optional,
                include_view_lineage
                  | Bool
                  | doc m%"
                  If the source supports it, include view lineage to the underlying storage location.
                  "%
                  | optional,
                include_views
                  | Bool
                  | doc m%"
                  Whether views should be ingested.
                  "%
                  | optional,
                models_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for ml models to filter in ingestion. 
                  "%
                  | optional,
                options
                  | {  .. }
                  | doc m%"
                  Any options specified here will be passed to [SQLAlchemy.create_engine](https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine) as kwargs.
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  password
                  "%
                  | optional,
                platform_instance
                  | String
                  | doc m%"
                  The instance of the platform that all assets produced by this recipe belong to
                  "%
                  | optional,
                profile_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns to filter tables (or specific columns) for profiling during ingestion. Note that only tables allowed by the `table_pattern` will be considered.
                  "%
                  | optional,
                profiling
                  | predicates.contract_from_predicate
                  definitions.predicate.GEProfilingConfig
                  | optional,
                schema_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for schemas to filter in ingestion. Specify regex to only match the schema name. e.g. to match all tables in schema analytics, use the regex 'analytics'
                  "%
                  | optional,
                scheme | String | optional,
                sqlalchemy_uri
                  | String
                  | doc m%"
                  URI of database to connect to. See https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls. Takes precedence over other connection parameters.
                  "%
                  | optional,
                stateful_ingestion
                  | definitions.contract.StatefulStaleMetadataRemovalConfig
                  | optional,
                table_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for tables to filter in ingestion. Specify regex to match the entire table name in database.schema.table format. e.g. to match all tables starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  username
                  "%
                  | optional,
                view_pattern
                  | predicates.contract_from_predicate
                  definitions.predicate.AllowDenyPattern
                  | doc m%"
                  Regex patterns for views to filter in ingestion. Note: Defaults to table_pattern if not specified. Specify regex to match the entire view name in database.schema.view format. e.g. to match all views starting with customer in Customer database and public schema, use the regex 'Customer.public.customer.*'
                  "%
                  | optional,
              },
        },
    predicate = {
          AllowDenyPattern
            | doc m%"
            A class to store allow deny regexes
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  deny = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ignoreCase = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          AwsAssumeRoleConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "RoleArn" ],
                predicates.records.record
                {
                  ExternalId = predicates.isType '"String",
                  RoleArn = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          AwsConnectionConfig
            | doc m%"
            Common AWS credentials config.
            
            Currently used by:
                - Glue source
                - SageMaker source
                - dbt source
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "aws_region" ],
                predicates.records.record
                {
                  aws_access_key_id = predicates.isType '"String",
                  aws_endpoint_url = predicates.isType '"String",
                  aws_profile = predicates.isType '"String",
                  aws_proxy = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  aws_region = predicates.isType '"String",
                  aws_role = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.AwsAssumeRoleConfig
                          ])
                        ]
                      ],
                  aws_secret_access_key = predicates.isType '"String",
                  aws_session_token = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          BaseUsageConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bucket_duration = definitions.predicate.BucketDuration,
                  end_time = predicates.isType '"String",
                  format_sql_queries = predicates.isType '"Bool",
                  include_operational_stats = predicates.isType '"Bool",
                  include_read_operational_stats = predicates.isType '"Bool",
                  include_top_n_queries = predicates.isType '"Bool",
                  start_time = predicates.isType '"String",
                  top_n_queries = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  user_email_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          BigQueryCredential = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "client_email",
                  "client_id",
                  "private_key",
                  "private_key_id",
                  "project_id"
                ],
                predicates.records.record
                {
                  auth_provider_x509_cert_url = predicates.isType '"String",
                  auth_uri = predicates.isType '"String",
                  client_email = predicates.isType '"String",
                  client_id = predicates.isType '"String",
                  client_x509_cert_url = predicates.isType '"String",
                  private_key = predicates.isType '"String",
                  private_key_id = predicates.isType '"String",
                  project_id = predicates.isType '"String",
                  token_uri = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          BigQueryUsageConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apply_view_usage_to_tables = predicates.isType '"Bool",
                  bucket_duration = definitions.predicate.BucketDuration,
                  end_time = predicates.isType '"String",
                  format_sql_queries = predicates.isType '"Bool",
                  include_operational_stats = predicates.isType '"Bool",
                  include_read_operational_stats = predicates.isType '"Bool",
                  include_top_n_queries = predicates.isType '"Bool",
                  max_query_duration = predicates.isType '"Number",
                  start_time = predicates.isType '"String",
                  top_n_queries = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  user_email_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          BucketDuration
            | doc m%"
            An enumeration.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "DAY", "HOUR" ]
              ],
          ClassificationConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  classifiers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DynamicTypedClassifierConfig
                      ],
                  column_pattern = definitions.predicate.AllowDenyPattern,
                  enabled = predicates.isType '"Bool",
                  info_type_to_term = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  max_workers = predicates.isType 'Integer,
                  sample_size = predicates.isType 'Integer,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          CollapseUrns = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  urns_suffix_regex = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          DBTEntitiesEnabled
            | doc m%"
            Controls which dbt entities are going to be emitted by this source
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  models = definitions.predicate.EmitDirective,
                  seeds = definitions.predicate.EmitDirective,
                  snapshots = definitions.predicate.EmitDirective,
                  sources = definitions.predicate.EmitDirective,
                  test_definitions = definitions.predicate.EmitDirective,
                  test_results = definitions.predicate.EmitDirective,
                }
                {  }
                false
                predicates.never
              ],
          DataLakeProfilerConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  include_field_distinct_value_frequencies = predicates.isType
                      '"Bool",
                  include_field_histogram = predicates.isType '"Bool",
                  include_field_max_value = predicates.isType '"Bool",
                  include_field_mean_value = predicates.isType '"Bool",
                  include_field_median_value = predicates.isType '"Bool",
                  include_field_min_value = predicates.isType '"Bool",
                  include_field_null_count = predicates.isType '"Bool",
                  include_field_quantiles = predicates.isType '"Bool",
                  include_field_sample_values = predicates.isType '"Bool",
                  include_field_stddev_value = predicates.isType '"Bool",
                  max_number_of_fields_to_profile = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  operation_config = definitions.predicate.OperationConfig,
                  profile_table_level_only = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          DatabaseId = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "database" ],
                predicates.records.record
                {
                  database = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          DynamicTypedClassifierConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  config = predicates.always,
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          DynamicTypedStateProviderConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  config = predicates.always,
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ElasticProfiling = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  operation_config = definitions.predicate.OperationConfig,
                }
                {  }
                false
                predicates.never
              ],
          EmitDirective
            | doc m%"
            A holder for directives for emission for specific types of entities
            "%
            = predicates.enum [ "YES", "NO", "ONLY" ],
          FileReadMode
            | doc m%"
            An enumeration.
            "%
            = predicates.enum [ "STREAM", "BATCH", "AUTO" ],
          GEProfilingConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  catch_exceptions = predicates.isType '"Bool",
                  enabled = predicates.isType '"Bool",
                  field_sample_values_limit = predicates.isType 'Integer,
                  include_field_distinct_count = predicates.isType '"Bool",
                  include_field_distinct_value_frequencies = predicates.isType
                      '"Bool",
                  include_field_histogram = predicates.isType '"Bool",
                  include_field_max_value = predicates.isType '"Bool",
                  include_field_mean_value = predicates.isType '"Bool",
                  include_field_median_value = predicates.isType '"Bool",
                  include_field_min_value = predicates.isType '"Bool",
                  include_field_null_count = predicates.isType '"Bool",
                  include_field_quantiles = predicates.isType '"Bool",
                  include_field_sample_values = predicates.isType '"Bool",
                  include_field_stddev_value = predicates.isType '"Bool",
                  limit = predicates.isType 'Integer,
                  max_number_of_fields_to_profile = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  max_workers = predicates.isType 'Integer,
                  offset = predicates.isType 'Integer,
                  operation_config = definitions.predicate.OperationConfig,
                  partition_datetime = predicates.isType '"String",
                  partition_profiling_enabled = predicates.isType '"Bool",
                  profile_if_updated_since_days = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  profile_table_level_only = predicates.isType '"Bool",
                  profile_table_row_count_estimate_only = predicates.isType
                      '"Bool",
                  profile_table_row_limit = predicates.isType 'Integer,
                  profile_table_size_limit = predicates.isType 'Integer,
                  query_combiner_enabled = predicates.isType '"Bool",
                  report_dropped_profiles = predicates.isType '"Bool",
                  sample_size = predicates.isType 'Integer,
                  turn_off_expensive_profiling_metrics = predicates.isType
                      '"Bool",
                  use_sampling = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          GenericConnectorConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "connector_name", "source_dataset", "source_platform" ],
                predicates.records.record
                {
                  connector_name = predicates.isType '"String",
                  source_dataset = predicates.isType '"String",
                  source_platform = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GitInfo
            | doc m%"
            A reference to a Git repository, including a deploy key that can be used to clone it.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "repo" ],
                predicates.records.record
                {
                  branch = predicates.isType '"String",
                  deploy_key = predicates.isType '"String",
                  deploy_key_file = predicates.isType '"String",
                  repo = predicates.isType '"String",
                  repo_ssh_locator = predicates.isType '"String",
                  url_template = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GitReference
            | doc m%"
            Reference to a hosted Git repository. Used to generate "view source" links.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "repo" ],
                predicates.records.record
                {
                  branch = predicates.isType '"String",
                  repo = predicates.isType '"String",
                  url_template = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GlueProfilingConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  column_count = predicates.isType '"String",
                  max = predicates.isType '"String",
                  mean = predicates.isType '"String",
                  median = predicates.isType '"String",
                  min = predicates.isType '"String",
                  null_count = predicates.isType '"String",
                  null_proportion = predicates.isType '"String",
                  operation_config = definitions.predicate.OperationConfig,
                  partition_patterns = definitions.predicate.AllowDenyPattern,
                  row_count = predicates.isType '"String",
                  stdev = predicates.isType '"String",
                  unique_count = predicates.isType '"String",
                  unique_proportion = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          HMACKey = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "hmac_access_id", "hmac_access_secret" ],
                predicates.records.record
                {
                  hmac_access_id = predicates.isType '"String",
                  hmac_access_secret = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          IcebergCatalogConfig
            | doc m%"
            Iceberg catalog config.
            
            https://py.iceberg.apache.org/configuration/
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          IcebergProfilingConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  include_field_max_value = predicates.isType '"Bool",
                  include_field_min_value = predicates.isType '"Bool",
                  include_field_null_count = predicates.isType '"Bool",
                  operation_config = definitions.predicate.OperationConfig,
                }
                {  }
                false
                predicates.never
              ],
          KafkaConsumerConnectionConfig
            | doc m%"
            Configuration class for holding connectivity information for Kafka consumers
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bootstrap = predicates.isType '"String",
                  client_timeout_seconds = predicates.isType 'Integer,
                  consumer_config = predicates.isType 'Record,
                  schema_registry_config = predicates.isType 'Record,
                  schema_registry_url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          LineageMode
            | doc m%"
            An enumeration.
            "%
            = predicates.enum [ "sql_based", "stl_scan_based", "mixed" ],
          LookerAPIConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "base_url", "client_id", "client_secret" ],
                predicates.records.record
                {
                  base_url = predicates.isType '"String",
                  client_id = predicates.isType '"String",
                  client_secret = predicates.isType '"String",
                  transport_options =
                    definitions.predicate.TransportOptionsConfig,
                }
                {  }
                false
                predicates.never
              ],
          LookerConnectionDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "default_db", "platform" ],
                predicates.records.record
                {
                  default_db = predicates.isType '"String",
                  default_schema = predicates.isType '"String",
                  platform = predicates.isType '"String",
                  platform_env = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          LookerNamingPattern = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "pattern" ],
                predicates.records.record
                { pattern = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          LookerViewNamingPattern = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "pattern" ],
                predicates.records.record
                { pattern = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          ModeAPIConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  max_attempts = predicates.isType 'Integer,
                  max_retry_interval = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.isType '"Number"
                      ],
                  retry_backoff_multiplier = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.isType '"Number"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          NifiAuthType
            | doc m%"
            An enumeration.
            "%
            = predicates.enum
              [
                "NO_AUTH",
                "SINGLE_USER",
                "CLIENT_CERT",
                "KERBEROS",
                "BASIC_AUTH"
              ],
          OAuthConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "authority_url", "client_id", "provider", "scopes" ],
                predicates.records.record
                {
                  authority_url = predicates.isType '"String",
                  client_id = predicates.isType '"String",
                  client_secret = predicates.isType '"String",
                  encoded_oauth_private_key = predicates.isType '"String",
                  encoded_oauth_public_key = predicates.isType '"String",
                  provider = definitions.predicate.OAuthIdentityProvider,
                  scopes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  use_certificate = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          OAuthIdentityProvider
            | doc m%"
            An enumeration.
            "%
            = predicates.enum [ "microsoft", "okta" ],
          OperationConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  lower_freq_profile_enabled = predicates.isType '"Bool",
                  profile_date_of_month = predicates.isType 'Integer,
                  profile_day_of_week = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          OwnershipMapping = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  create_corp_user = predicates.isType '"Bool",
                  dataset_configured_by_as_owner = predicates.isType '"Bool",
                  owner_criteria = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  remove_email_suffix = predicates.isType '"Bool",
                  use_powerbi_email = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          PathSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "include" ],
                predicates.records.record
                {
                  default_extension = predicates.isType '"String",
                  enable_compression = predicates.isType '"Bool",
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  file_types = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  include = predicates.isType '"String",
                  sample_files = predicates.isType '"Bool",
                  table_name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PlatformDetail = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  env = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PrestoOnHiveConfigMode
            | doc m%"
            An enumeration.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "hive", "presto", "presto-on-hive", "trino" ]
              ],
          ProvidedConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path_key", "provider", "value" ],
                predicates.records.record
                {
                  path_key = predicates.isType '"String",
                  provider = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          S3 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  aws_config = definitions.predicate.AwsConnectionConfig,
                  use_s3_bucket_tags = predicates.isType '"Bool",
                  use_s3_object_tags = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          S3LineageProviderConfig
            | doc m%"
            Any source that produces s3 lineage from/to Datasets should inherit this class.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path_specs" ],
                predicates.records.record
                {
                  path_specs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.PathSpec
                      ],
                }
                {  }
                false
                predicates.never
              ],
          SQLAlchemyConnectionConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "host_port", "scheme" ],
                predicates.records.record
                {
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  scheme = predicates.isType '"String",
                  sqlalchemy_uri = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SalesforceAuthType
            | doc m%"
            An enumeration.
            "%
            = predicates.enum
              [ "USERNAME_PASSWORD", "DIRECT_ACCESS_TOKEN", "JSON_WEB_TOKEN" ],
          SalesforceProfilingConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  operation_config = definitions.predicate.OperationConfig,
                }
                {  }
                false
                predicates.never
              ],
          SnowflakeShareConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "consumers", "database" ],
                predicates.records.record
                {
                  consumers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DatabaseId,
                        predicates.arrays.uniqueItems
                      ],
                  database = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          StatefulIngestionConfig
            | doc m%"
            Basic Stateful Ingestion Specific Configuration for any source.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { enabled = predicates.isType '"Bool", }
                {  }
                false
                predicates.never
              ],
          StatefulStaleMetadataRemovalConfig
            | doc m%"
            Base specialized config for Stateful Ingestion with stale metadata removal capability.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  remove_stale_metadata = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          TableauLineageOverrides = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  database_override_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  platform_override_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          TagOption
            | doc m%"
            An enumeration.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "with_lineage", "without_lineage", "skip" ]
              ],
          TransportOptionsConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "headers", "timeout" ],
                predicates.records.record
                {
                  headers = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  timeout = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          URIReplacePattern = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "match", "replace" ],
                predicates.records.record
                {
                  "match" = predicates.isType '"String",
                  replace = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          UnityCatalogProfilerConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  call_analyze = predicates.isType '"Bool",
                  enabled = predicates.isType '"Bool",
                  max_wait_secs = predicates.isType 'Integer,
                  max_workers = predicates.isType 'Integer,
                  operation_config = definitions.predicate.OperationConfig,
                  pattern = definitions.predicate.AllowDenyPattern,
                  profile_table_level_only = predicates.isType '"Bool",
                  warehouse_id = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          athena = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.athena_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "athena" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          athena_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "aws_region", "query_result_location", "work_group" ],
                predicates.records.record
                {
                  aws_region = predicates.isType '"String",
                  aws_role_arn = predicates.isType '"String",
                  aws_role_assumption_duration = predicates.isType 'Integer,
                  catalog_name = predicates.isType '"String",
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  query_result_location = predicates.isType '"String",
                  s3_staging_dir = predicates.isType '"String",
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  scheme = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                  work_group = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          azure-ad = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.azure-ad_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "azure-ad" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          azure-ad_config
            | doc m%"
            Config to create a token and connect to Azure AD instance
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "authority",
                  "client_id",
                  "client_secret",
                  "tenant_id",
                  "token_url"
                ],
                predicates.records.record
                {
                  authority = predicates.isType '"String",
                  azure_ad_response_to_groupname_attr = predicates.isType
                      '"String",
                  azure_ad_response_to_groupname_regex = predicates.isType
                      '"String",
                  azure_ad_response_to_username_attr = predicates.isType
                      '"String",
                  azure_ad_response_to_username_regex = predicates.isType
                      '"String",
                  client_id = predicates.isType '"String",
                  client_secret = predicates.isType '"String",
                  env = predicates.isType '"String",
                  filtered_tracking = predicates.isType '"Bool",
                  graph_url = predicates.isType '"String",
                  groups_pattern = definitions.predicate.AllowDenyPattern,
                  ingest_group_membership = predicates.isType '"Bool",
                  ingest_groups = predicates.isType '"Bool",
                  ingest_groups_users = predicates.isType '"Bool",
                  ingest_users = predicates.isType '"Bool",
                  mask_group_id = predicates.isType '"Bool",
                  mask_user_id = predicates.isType '"Bool",
                  platform_instance = predicates.isType '"String",
                  redirect = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  tenant_id = predicates.isType '"String",
                  token_url = predicates.isType '"String",
                  users_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          bigquery = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.bigquery_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "bigquery" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          bigquery_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bigquery_audit_metadata_datasets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  bucket_duration = definitions.predicate.BucketDuration,
                  capture_dataset_label_as_tag = predicates.isType '"Bool",
                  capture_table_label_as_tag = predicates.isType '"Bool",
                  column_limit = predicates.isType 'Integer,
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  credential = definitions.predicate.BigQueryCredential,
                  dataset_pattern = definitions.predicate.AllowDenyPattern,
                  debug_include_full_payloads = predicates.isType '"Bool",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  enable_legacy_sharded_table_support = predicates.isType
                      '"Bool",
                  enable_stateful_lineage_ingestion = predicates.isType '"Bool",
                  enable_stateful_profiling = predicates.isType '"Bool",
                  enable_stateful_usage_ingestion = predicates.isType '"Bool",
                  end_time = predicates.isType '"String",
                  env = predicates.isType '"String",
                  exclude_empty_projects = predicates.isType '"Bool",
                  extra_client_options = predicates.isType 'Record,
                  extract_column_lineage = predicates.isType '"Bool",
                  extract_lineage_from_catalog = predicates.isType '"Bool",
                  include_data_platform_instance = predicates.isType '"Bool",
                  include_external_url = predicates.isType '"Bool",
                  include_table_lineage = predicates.isType '"Bool",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_usage_statistics = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  incremental_lineage = predicates.isType '"Bool",
                  lineage_parse_view_ddl = predicates.isType '"Bool",
                  lineage_sql_parser_use_raw_names = predicates.isType '"Bool",
                  lineage_use_sql_parser = predicates.isType '"Bool",
                  log_page_size = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  match_fully_qualified_names = predicates.isType '"Bool",
                  max_query_duration = predicates.isType '"Number",
                  number_of_datasets_process_in_batch_if_profiling_enabled =
                    predicates.isType 'Integer,
                  options = predicates.isType 'Record,
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  project_id = predicates.isType '"String",
                  project_id_pattern = definitions.predicate.AllowDenyPattern,
                  project_ids = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  project_on_behalf = predicates.isType '"String",
                  rate_limit = predicates.isType '"Bool",
                  requests_per_min = predicates.isType 'Integer,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  scheme = predicates.isType '"String",
                  sharded_table_pattern = predicates.isType '"String",
                  sql_parser_use_external_process = predicates.isType '"Bool",
                  start_time = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  temp_table_dataset_prefix = predicates.isType '"String",
                  upstream_lineage_in_report = predicates.isType '"Bool",
                  usage = definitions.predicate.BigQueryUsageConfig,
                  use_date_sharded_audit_log_tables = predicates.isType '"Bool",
                  use_exported_bigquery_audit_metadata = predicates.isType
                      '"Bool",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          clickhouse = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.clickhouse_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "clickhouse" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          clickhouse-usage = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.clickhouse-usage_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "clickhouse-usage" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          clickhouse-usage_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "email_domain" ],
                predicates.records.record
                {
                  bucket_duration = definitions.predicate.BucketDuration,
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  email_domain = predicates.isType '"String",
                  end_time = predicates.isType '"String",
                  env = predicates.isType '"String",
                  format_sql_queries = predicates.isType '"Bool",
                  host_port = predicates.isType '"String",
                  include_materialized_views = predicates.isType '"Bool",
                  include_operational_stats = predicates.isType '"Bool",
                  include_read_operational_stats = predicates.isType '"Bool",
                  include_table_lineage = predicates.isType '"Bool",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_top_n_queries = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  platform_instance_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  protocol = predicates.isType '"String",
                  query_log_table = predicates.isType '"String",
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  secure = predicates.isType '"Bool",
                  sqlalchemy_uri = predicates.isType '"String",
                  start_time = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  top_n_queries = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  uri_opts = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  user_email_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          clickhouse_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bucket_duration = definitions.predicate.BucketDuration,
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  end_time = predicates.isType '"String",
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_materialized_views = predicates.isType '"Bool",
                  include_table_lineage = predicates.isType '"Bool",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  platform_instance_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  protocol = predicates.isType '"String",
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  secure = predicates.isType '"Bool",
                  sqlalchemy_uri = predicates.isType '"String",
                  start_time = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  uri_opts = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          console_sink = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "console" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          csv-enricher = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.csv-enricher_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "csv-enricher" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          csv-enricher_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "filename" ],
                predicates.records.record
                {
                  array_delimiter = predicates.isType '"String",
                  delimiter = predicates.isType '"String",
                  filename = predicates.isType '"String",
                  write_semantics = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          datahub = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.datahub_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "datahub" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          datahub-business-glossary = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config =
                    definitions.predicate.datahub-business-glossary_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "datahub-business-glossary" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          datahub-business-glossary_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "file" ],
                predicates.records.record
                {
                  enable_auto_id = predicates.isType '"Bool",
                  file = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"String"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          datahub-lineage-file = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.datahub-lineage-file_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "datahub-lineage-file" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          datahub-lineage-file_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "file" ],
                predicates.records.record
                {
                  file = predicates.isType '"String",
                  preserve_upstream = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          datahub_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  commit_state_interval = predicates.isType 'Integer,
                  commit_with_parse_errors = predicates.isType '"Bool",
                  database_connection =
                    definitions.predicate.SQLAlchemyConnectionConfig,
                  database_query_batch_size = predicates.isType 'Integer,
                  database_table_name = predicates.isType '"String",
                  include_all_versions = predicates.isType '"Bool",
                  kafka_connection =
                    definitions.predicate.KafkaConsumerConnectionConfig,
                  kafka_topic_name = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulIngestionConfig,
                }
                {  }
                true
                predicates.always
              ],
          datahub_kafka_sink = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.datahub_kafka_sink_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "datahub-kafka" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          datahub_kafka_sink_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "connection" ],
                predicates.records.record
                {
                  connection = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [ "bootstrap", "schema_registry_url" ],
                        predicates.records.record
                        {
                          bootstrap = predicates.isType '"String",
                          producer_config = predicates.isType 'Record,
                          schema_registry_config = predicates.isType 'Record,
                          schema_registry_url = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  topic_routes = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          MetadataChangeEvent = predicates.isType '"String",
                          MetadataChangeProposal = predicates.isType '"String",
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
          datahub_rest_sink = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.datahub_rest_sink_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "datahub-rest" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          datahub_rest_sink_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "server" ],
                predicates.records.record
                {
                  ca_certificate_path = predicates.isType '"String",
                  client_certificate_path = predicates.isType '"String",
                  disable_ssl_verification = predicates.isType '"Bool",
                  extra_headers = predicates.isType '"String",
                  max_threads = predicates.isType '"Number",
                  retry_status_codes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  server = predicates.isType '"String",
                  timeout_sec = predicates.isType '"Number",
                  token = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          dbt = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.dbt_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "dbt" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dbt-cloud = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.dbt-cloud_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "dbt-cloud" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dbt-cloud_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "account_id",
                  "job_id",
                  "project_id",
                  "target_platform",
                  "token"
                ],
                predicates.records.record
                {
                  account_id = predicates.isType 'Integer,
                  column_meta_mapping = predicates.isType 'Record,
                  convert_column_urns_to_lowercase = predicates.isType '"Bool",
                  enable_meta_mapping = predicates.isType '"Bool",
                  enable_owner_extraction = predicates.isType '"Bool",
                  enable_query_tag_mapping = predicates.isType '"Bool",
                  entities_enabled = definitions.predicate.DBTEntitiesEnabled,
                  env = predicates.isType '"String",
                  include_env_in_assertion_guid = predicates.isType '"Bool",
                  incremental_lineage = predicates.isType '"Bool",
                  job_id = predicates.isType 'Integer,
                  meta_mapping = predicates.isType 'Record,
                  metadata_endpoint = predicates.isType '"String",
                  node_name_pattern = definitions.predicate.AllowDenyPattern,
                  owner_extraction_pattern = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  project_id = predicates.isType 'Integer,
                  query_tag_mapping = predicates.isType 'Record,
                  run_id = predicates.isType 'Integer,
                  sql_parser_use_external_process = predicates.isType '"Bool",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  strip_user_ids_from_email = predicates.isType '"Bool",
                  tag_prefix = predicates.isType '"String",
                  target_platform = predicates.isType '"String",
                  target_platform_instance = predicates.isType '"String",
                  test_warnings_are_errors = predicates.isType '"Bool",
                  token = predicates.isType '"String",
                  use_compiled_code = predicates.isType '"Bool",
                  use_identifiers = predicates.isType '"Bool",
                  write_semantics = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          dbt_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "catalog_path", "manifest_path", "target_platform" ],
                predicates.records.record
                {
                  aws_connection = definitions.predicate.AwsConnectionConfig,
                  catalog_path = predicates.isType '"String",
                  column_meta_mapping = predicates.isType 'Record,
                  convert_column_urns_to_lowercase = predicates.isType '"Bool",
                  enable_meta_mapping = predicates.isType '"Bool",
                  enable_owner_extraction = predicates.isType '"Bool",
                  enable_query_tag_mapping = predicates.isType '"Bool",
                  entities_enabled = definitions.predicate.DBTEntitiesEnabled,
                  env = predicates.isType '"String",
                  git_info = definitions.predicate.GitReference,
                  include_env_in_assertion_guid = predicates.isType '"Bool",
                  incremental_lineage = predicates.isType '"Bool",
                  manifest_path = predicates.isType '"String",
                  meta_mapping = predicates.isType 'Record,
                  node_name_pattern = definitions.predicate.AllowDenyPattern,
                  owner_extraction_pattern = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  query_tag_mapping = predicates.isType 'Record,
                  sources_path = predicates.isType '"String",
                  sql_parser_use_external_process = predicates.isType '"Bool",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  strip_user_ids_from_email = predicates.isType '"Bool",
                  tag_prefix = predicates.isType '"String",
                  target_platform = predicates.isType '"String",
                  target_platform_instance = predicates.isType '"String",
                  test_results_path = predicates.isType '"String",
                  test_warnings_are_errors = predicates.isType '"Bool",
                  use_compiled_code = predicates.isType '"Bool",
                  use_identifiers = predicates.isType '"Bool",
                  write_semantics = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          delta-lake = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.delta-lake_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "delta-lake" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          delta-lake_config
            | doc m%"
            Any source that connects to a platform should inherit this class
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "base_path" ],
                predicates.records.record
                {
                  base_path = predicates.isType '"String",
                  env = predicates.isType '"String",
                  platform = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.const "delta-lake"
                      ],
                  platform_instance = predicates.isType '"String",
                  relative_path = predicates.isType '"String",
                  require_files = predicates.isType '"Bool",
                  s3 = definitions.predicate.S3,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  version_history_lookback = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          demo-data = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.demo-data_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "demo-data" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          demo-data_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } false predicates.never
              ],
          druid = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.druid_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "druid" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          druid_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "host_port" ],
                predicates.records.record
                {
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  scheme = predicates.isType '"String",
                  sqlalchemy_uri = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          dynamodb = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.dynamodb_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "dynamodb" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dynamodb_config
            | doc m%"
            Any source that is a primary producer of Dataset metadata should inherit this class
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "aws_access_key_id", "aws_secret_access_key" ],
                predicates.records.record
                {
                  aws_access_key_id = predicates.isType '"String",
                  aws_secret_access_key = predicates.isType '"String",
                  env = predicates.isType '"String",
                  include_table_item = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.isType 'Record)
                        ])
                      ],
                  platform_instance = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          elasticsearch = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.elasticsearch_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "elasticsearch" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          elasticsearch_config
            | doc m%"
            Any source that connects to a platform should inherit this class
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ca_certs = predicates.isType '"String",
                  client_cert = predicates.isType '"String",
                  client_key = predicates.isType '"String",
                  collapse_urns = definitions.predicate.CollapseUrns,
                  env = predicates.isType '"String",
                  host = predicates.isType '"String",
                  index_pattern = definitions.predicate.AllowDenyPattern,
                  index_template_pattern =
                    definitions.predicate.AllowDenyPattern,
                  ingest_index_templates = predicates.isType '"Bool",
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profiling = definitions.predicate.ElasticProfiling,
                  ssl_assert_fingerprint = predicates.isType '"String",
                  ssl_assert_hostname = predicates.isType '"Bool",
                  url_prefix = predicates.isType '"String",
                  use_ssl = predicates.isType '"Bool",
                  username = predicates.isType '"String",
                  verify_certs = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          feast = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.feast_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "feast" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          feast_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  environment = predicates.isType '"String",
                  fs_yaml_file = predicates.isType '"String",
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          file = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.file_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "file" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          file_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  aspect = predicates.isType '"String",
                  count_all_before_starting = predicates.isType '"Bool",
                  file_extension = predicates.isType '"String",
                  path = predicates.isType '"String",
                  read_mode = definitions.predicate.FileReadMode,
                }
                {  }
                false
                predicates.never
              ],
          file_sink = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.file_sink_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "file" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          file_sink_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "filename" ],
                predicates.records.record
                { filename = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          gcs = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.gcs_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "gcs" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          gcs_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "credential", "path_specs" ],
                predicates.records.record
                {
                  credential = definitions.predicate.HMACKey,
                  env = predicates.isType '"String",
                  max_rows = predicates.isType 'Integer,
                  number_of_files_to_sample = predicates.isType 'Integer,
                  path_specs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.PathSpec
                      ],
                  platform_instance = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                }
                {  }
                false
                predicates.never
              ],
          glue = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.glue_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "glue" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          glue_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "aws_region" ],
                predicates.records.record
                {
                  aws_access_key_id = predicates.isType '"String",
                  aws_endpoint_url = predicates.isType '"String",
                  aws_profile = predicates.isType '"String",
                  aws_proxy = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  aws_region = predicates.isType '"String",
                  aws_role = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.AwsAssumeRoleConfig
                          ])
                        ]
                      ],
                  aws_secret_access_key = predicates.isType '"String",
                  aws_session_token = predicates.isType '"String",
                  catalog_id = predicates.isType '"String",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  emit_s3_lineage = predicates.isType '"Bool",
                  env = predicates.isType '"String",
                  extract_owners = predicates.isType '"Bool",
                  extract_transforms = predicates.isType '"Bool",
                  glue_s3_lineage_direction = predicates.isType '"String",
                  ignore_resource_links = predicates.isType '"Bool",
                  ignore_unsupported_connectors = predicates.isType '"Bool",
                  platform = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profiling = definitions.predicate.GlueProfilingConfig,
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  use_s3_bucket_tags = predicates.isType '"Bool",
                  use_s3_object_tags = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          hana = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.hana_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "hana" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          hana_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  scheme = predicates.isType '"String",
                  sqlalchemy_uri = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          hive = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.hive_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "hive" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          hive_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "host_port" ],
                predicates.records.record
                {
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  sqlalchemy_uri = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          iceberg = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.iceberg_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "iceberg" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          iceberg_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "catalog" ],
                predicates.records.record
                {
                  catalog = definitions.predicate.IcebergCatalogConfig,
                  env = predicates.isType '"String",
                  group_ownership_property = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profiling = definitions.predicate.IcebergProfilingConfig,
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  user_ownership_property = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          json-schema = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.json-schema_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "json-schema" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          json-schema_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path", "platform" ],
                predicates.records.record
                {
                  env = predicates.isType '"String",
                  path = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.maxLength 65536,
                          predicates.strings.minLength 1
                        ]
                      ],
                  platform = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  uri_replace_pattern = definitions.predicate.URIReplacePattern,
                  use_id_as_base_uri = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          kafka = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.kafka_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "kafka" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          kafka-connect = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.kafka-connect_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "kafka-connect" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          kafka-connect_config
            | doc m%"
            Any source that connects to a platform should inherit this class
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cluster_name = predicates.isType '"String",
                  connect_to_platform_map = predicates.allOf
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
                  connect_uri = predicates.isType '"String",
                  connector_patterns = definitions.predicate.AllowDenyPattern,
                  convert_lineage_urns_to_lowercase = predicates.isType '"Bool",
                  env = predicates.isType '"String",
                  generic_connectors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.GenericConnectorConfig
                      ],
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  platform_instance_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  provided_configs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ProvidedConfig
                      ],
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          kafka_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  connection =
                    definitions.predicate.KafkaConsumerConnectionConfig,
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  disable_topic_record_naming_strategy = predicates.isType
                      '"Bool",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  enable_meta_mapping = predicates.isType '"Bool",
                  env = predicates.isType '"String",
                  field_meta_mapping = predicates.isType 'Record,
                  ignore_warnings_on_schema_type = predicates.isType '"Bool",
                  meta_mapping = predicates.isType 'Record,
                  platform_instance = predicates.isType '"String",
                  schema_registry_class = predicates.isType '"String",
                  schema_tags_field = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  strip_user_ids_from_email = predicates.isType '"Bool",
                  tag_prefix = predicates.isType '"String",
                  topic_patterns = definitions.predicate.AllowDenyPattern,
                  topic_subject_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ldap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.ldap_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ldap" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          ldap_config
            | doc m%"
            Config used by the LDAP Source.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "base_dn", "ldap_password", "ldap_server", "ldap_user" ],
                predicates.records.record
                {
                  attrs_list = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  base_dn = predicates.isType '"String",
                  custom_props_list = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  drop_missing_first_last_name = predicates.isType '"Bool",
                  env = predicates.isType '"String",
                  filter = predicates.isType '"String",
                  group_attrs_map = predicates.isType 'Record,
                  ldap_password = predicates.isType '"String",
                  ldap_server = predicates.isType '"String",
                  ldap_user = predicates.isType '"String",
                  manager_filter_enabled = predicates.isType '"Bool",
                  manager_pagination_enabled = predicates.isType '"Bool",
                  page_size = predicates.isType 'Integer,
                  pagination_enabled = predicates.isType '"Bool",
                  platform_instance = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  use_email_as_username = predicates.isType '"Bool",
                  user_attrs_map = predicates.isType 'Record,
                }
                {  }
                false
                predicates.never
              ],
          looker = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.looker_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "looker" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          looker_config
            | doc m%"
            Any source that is a primary producer of Dataset metadata should inherit this class
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "base_url", "client_id", "client_secret" ],
                predicates.records.record
                {
                  actor = predicates.isType '"String",
                  base_url = predicates.isType '"String",
                  chart_pattern = definitions.predicate.AllowDenyPattern,
                  client_id = predicates.isType '"String",
                  client_secret = predicates.isType '"String",
                  dashboard_pattern = definitions.predicate.AllowDenyPattern,
                  env = predicates.isType '"String",
                  explore_browse_pattern =
                    definitions.predicate.LookerNamingPattern,
                  explore_naming_pattern =
                    definitions.predicate.LookerNamingPattern,
                  external_base_url = predicates.isType '"String",
                  extract_column_level_lineage = predicates.isType '"Bool",
                  extract_embed_urls = predicates.isType '"Bool",
                  extract_independent_looks = predicates.isType '"Bool",
                  extract_owners = predicates.isType '"Bool",
                  extract_usage_history = predicates.isType '"Bool",
                  extract_usage_history_for_interval = predicates.isType
                      '"String",
                  include_deleted = predicates.isType '"Bool",
                  max_threads = predicates.isType 'Integer,
                  platform_instance = predicates.isType '"String",
                  platform_name = predicates.isType '"String",
                  skip_personal_folders = predicates.isType '"Bool",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  strip_user_ids_from_email = predicates.isType '"Bool",
                  tag_measures_and_dimensions = predicates.isType '"Bool",
                  transport_options =
                    definitions.predicate.TransportOptionsConfig,
                  view_browse_pattern =
                    definitions.predicate.LookerViewNamingPattern,
                  view_naming_pattern =
                    definitions.predicate.LookerViewNamingPattern,
                }
                {  }
                false
                predicates.never
              ],
          lookml = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.lookml_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "lookml" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          lookml_config
            | doc m%"
            Any source that is a primary producer of Dataset metadata should inherit this class
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api = definitions.predicate.LookerAPIConfig,
                  base_folder = predicates.isType '"String",
                  connection_to_platform_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.LookerConnectionDefinition
                      ],
                  emit_reachable_views_only = predicates.isType '"Bool",
                  env = predicates.isType '"String",
                  explore_browse_pattern =
                    definitions.predicate.LookerNamingPattern,
                  explore_naming_pattern =
                    definitions.predicate.LookerNamingPattern,
                  extract_column_level_lineage = predicates.isType '"Bool",
                  git_info = definitions.predicate.GitInfo,
                  max_file_snippet_length = predicates.isType 'Integer,
                  model_pattern = definitions.predicate.AllowDenyPattern,
                  parse_table_names_from_sql = predicates.isType '"Bool",
                  platform_instance = predicates.isType '"String",
                  platform_name = predicates.isType '"String",
                  populate_sql_logic_for_missing_descriptions =
                    predicates.isType '"Bool",
                  process_isolation_for_sql_parsing = predicates.isType '"Bool",
                  process_refinements = predicates.isType '"Bool",
                  project_dependencies = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.anyOf
                        [
                          predicates.isType '"String",
                          definitions.predicate.GitInfo
                        ])
                      ],
                  project_name = predicates.isType '"String",
                  sql_parser = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  tag_measures_and_dimensions = predicates.isType '"Bool",
                  transport_options =
                    definitions.predicate.TransportOptionsConfig,
                  view_browse_pattern =
                    definitions.predicate.LookerViewNamingPattern,
                  view_naming_pattern =
                    definitions.predicate.LookerViewNamingPattern,
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          mariadb = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.mariadb_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "mariadb" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          mariadb_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  scheme = predicates.isType '"String",
                  sqlalchemy_uri = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          metabase = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.metabase_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "metabase" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          metabase_config
            | doc m%"
            Any non-Dataset source that produces lineage to Datasets should inherit this class.
            e.g. Orchestrators, Pipelines, BI Tools etc.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  connect_uri = predicates.isType '"String",
                  database_alias_map = predicates.isType 'Record,
                  database_id_to_instance_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  default_schema = predicates.isType '"String",
                  engine_platform_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  env = predicates.isType '"String",
                  password = predicates.isType '"String",
                  platform_instance_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          mlflow = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.mlflow_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "mlflow" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          mlflow_config
            | doc m%"
            Any source that produces dataset urns in a single environment should inherit this class
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  env = predicates.isType '"String",
                  model_name_separator = predicates.isType '"String",
                  registry_uri = predicates.isType '"String",
                  tracking_uri = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          mode = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.mode_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "mode" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          mode_config
            | doc m%"
            Any non-Dataset source that produces lineage to Datasets should inherit this class.
            e.g. Orchestrators, Pipelines, BI Tools etc.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "password", "token" ],
                predicates.records.record
                {
                  api_options = definitions.predicate.ModeAPIConfig,
                  connect_uri = predicates.isType '"String",
                  default_schema = predicates.isType '"String",
                  env = predicates.isType '"String",
                  owner_username_instead_of_email = predicates.isType '"Bool",
                  password = predicates.isType '"String",
                  platform_instance_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  token = predicates.isType '"String",
                  workspace = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          mongodb = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.mongodb_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "mongodb" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          mongodb_config
            | doc m%"
            Any source that produces dataset urns in a single environment should inherit this class
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  authMechanism = predicates.isType '"String",
                  collection_pattern = definitions.predicate.AllowDenyPattern,
                  connect_uri = predicates.isType '"String",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  enableSchemaInference = predicates.isType '"Bool",
                  env = predicates.isType '"String",
                  maxDocumentSize = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  maxSchemaSize = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  schemaSamplingSize = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  useRandomSampling = predicates.isType '"Bool",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          mssql = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.mssql_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "mssql" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          mssql_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_descriptions = predicates.isType '"Bool",
                  include_jobs = predicates.isType '"Bool",
                  include_stored_procedures = predicates.isType '"Bool",
                  include_stored_procedures_code = predicates.isType '"Bool",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  sqlalchemy_uri = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  uri_args = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  use_odbc = predicates.isType '"Bool",
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          mysql = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.mysql_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "mysql" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          mysql_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  scheme = predicates.isType '"String",
                  sqlalchemy_uri = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          nifi = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.nifi_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "nifi" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          nifi_config
            | doc m%"
            Any source that produces dataset urns in a single environment should inherit this class
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "site_url" ],
                predicates.records.record
                {
                  auth = definitions.predicate.NifiAuthType,
                  ca_file = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  client_cert_file = predicates.isType '"String",
                  client_key_file = predicates.isType '"String",
                  client_key_password = predicates.isType '"String",
                  env = predicates.isType '"String",
                  password = predicates.isType '"String",
                  process_group_pattern =
                    definitions.predicate.AllowDenyPattern,
                  provenance_days = predicates.isType 'Integer,
                  site_name = predicates.isType '"String",
                  site_url = predicates.isType '"String",
                  site_url_to_site_name = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          okta = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.okta_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "okta" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          okta_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "okta_api_token", "okta_domain" ],
                predicates.records.record
                {
                  delay_seconds = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType 'Integer
                      ],
                  include_deprovisioned_users = predicates.isType '"Bool",
                  include_suspended_users = predicates.isType '"Bool",
                  ingest_group_membership = predicates.isType '"Bool",
                  ingest_groups = predicates.isType '"Bool",
                  ingest_users = predicates.isType '"Bool",
                  mask_group_id = predicates.isType '"Bool",
                  mask_user_id = predicates.isType '"Bool",
                  okta_api_token = predicates.isType '"String",
                  okta_domain = predicates.isType '"String",
                  okta_groups_filter = predicates.isType '"String",
                  okta_groups_search = predicates.isType '"String",
                  okta_profile_to_group_name_attr = predicates.isType '"String",
                  okta_profile_to_group_name_regex = predicates.isType
                      '"String",
                  okta_profile_to_username_attr = predicates.isType '"String",
                  okta_profile_to_username_regex = predicates.isType '"String",
                  okta_users_filter = predicates.isType '"String",
                  okta_users_search = predicates.isType '"String",
                  page_size = predicates.isType 'Integer,
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                }
                {  }
                false
                predicates.never
              ],
          openapi = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.openapi_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "openapi" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          openapi_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "swagger_file", "url" ],
                predicates.records.record
                {
                  forced_examples = predicates.isType 'Record,
                  get_token = predicates.isType 'Record,
                  ignore_endpoints = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf predicates.always
                      ],
                  name = predicates.isType '"String",
                  password = predicates.isType '"String",
                  swagger_file = predicates.isType '"String",
                  token = predicates.isType '"String",
                  url = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          oracle = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.oracle_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "oracle" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          oracle_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "host_port" ],
                predicates.records.record
                {
                  add_database_name_to_urn = predicates.isType '"Bool",
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  scheme = predicates.isType '"String",
                  service_name = predicates.isType '"String",
                  sqlalchemy_uri = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          postgres = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.postgres_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "postgres" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          postgres_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "host_port" ],
                predicates.records.record
                {
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_view_lineage = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  initial_database = predicates.isType '"String",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  scheme = predicates.isType '"String",
                  sqlalchemy_uri = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          powerbi = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.powerbi_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "powerbi" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          powerbi-report-server = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.powerbi-report-server_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "powerbi-report-server" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          powerbi-report-server_config
            | doc m%"
            Any source that produces dataset urns in a single environment should inherit this class
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "host_port",
                  "password",
                  "report_server_virtual_directory_name",
                  "report_virtual_directory_name",
                  "username"
                ],
                predicates.records.record
                {
                  chart_pattern = definitions.predicate.AllowDenyPattern,
                  env = predicates.isType '"String",
                  extract_ownership = predicates.isType '"Bool",
                  graphql_url = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  ownership_type = predicates.isType '"String",
                  password = predicates.isType '"String",
                  platform_name = predicates.isType '"String",
                  platform_urn = predicates.isType '"String",
                  report_pattern = definitions.predicate.AllowDenyPattern,
                  report_server_virtual_directory_name = predicates.isType
                      '"String",
                  report_virtual_directory_name = predicates.isType '"String",
                  server_alias = predicates.isType '"String",
                  username = predicates.isType '"String",
                  workstation_name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          powerbi_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "client_id", "client_secret", "tenant_id" ],
                predicates.records.record
                {
                  admin_apis_only = predicates.isType '"Bool",
                  client_id = predicates.isType '"String",
                  client_secret = predicates.isType '"String",
                  convert_lineage_urns_to_lowercase = predicates.isType '"Bool",
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  enable_advance_lineage_sql_construct = predicates.isType
                      '"Bool",
                  env = predicates.isType '"String",
                  extract_column_level_lineage = predicates.isType '"Bool",
                  extract_dashboards = predicates.isType '"Bool",
                  extract_dataset_schema = predicates.isType '"Bool",
                  extract_datasets_to_containers = predicates.isType '"Bool",
                  extract_endorsements_to_tags = predicates.isType '"Bool",
                  extract_independent_datasets = predicates.isType '"Bool",
                  extract_lineage = predicates.isType '"Bool",
                  extract_ownership = predicates.isType '"Bool",
                  extract_reports = predicates.isType '"Bool",
                  extract_workspaces_to_containers = predicates.isType '"Bool",
                  filter_dataset_endorsements =
                    definitions.predicate.AllowDenyPattern,
                  modified_since = predicates.isType '"String",
                  native_query_parsing = predicates.isType '"Bool",
                  ownership = definitions.predicate.OwnershipMapping,
                  platform_instance = predicates.isType '"String",
                  scan_batch_size = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 100,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  scan_timeout = predicates.isType 'Integer,
                  server_to_platform_instance = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.PlatformDetail
                      ],
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  tenant_id = predicates.isType '"String",
                  workspace_id_as_urn_part = predicates.isType '"Bool",
                  workspace_id_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          presto = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.presto_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "presto" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          presto-on-hive = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.presto-on-hive_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "presto-on-hive" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          presto-on-hive_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  enable_properties_merge = predicates.isType '"Bool",
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_catalog_name_in_ids = predicates.isType '"Bool",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  ingestion_job_id = predicates.isType '"String",
                  metastore_db_name = predicates.isType '"String",
                  mode = definitions.predicate.PrestoOnHiveConfigMode,
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  schemas_where_clause_suffix = predicates.isType '"String",
                  simplify_nested_field_paths = predicates.isType '"Bool",
                  sqlalchemy_uri = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  tables_where_clause_suffix = predicates.isType '"String",
                  use_catalog_subtype = predicates.isType '"Bool",
                  use_dataset_pascalcase_subtype = predicates.isType '"Bool",
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                  views_where_clause_suffix = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          presto_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "host_port" ],
                predicates.records.record
                {
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  sqlalchemy_uri = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          pulsar = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.pulsar_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "pulsar" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          pulsar_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  client_id = predicates.isType '"String",
                  client_secret = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  exclude_individual_partitions = predicates.isType '"Bool",
                  issuer_url = predicates.isType '"String",
                  namespace_patterns = definitions.predicate.AllowDenyPattern,
                  oid_config = predicates.isType 'Record,
                  platform_instance = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  tenant_patterns = definitions.predicate.AllowDenyPattern,
                  tenants = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  timeout = predicates.isType 'Integer,
                  token = predicates.isType '"String",
                  topic_patterns = definitions.predicate.AllowDenyPattern,
                  verify_ssl = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  web_service_url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          redash = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.redash_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "redash" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          redash_config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  api_key = predicates.isType '"String",
                  api_page_limit = predicates.isType 'Integer,
                  chart_patterns = definitions.predicate.AllowDenyPattern,
                  connect_uri = predicates.isType '"String",
                  dashboard_patterns = definitions.predicate.AllowDenyPattern,
                  env = predicates.isType '"String",
                  page_size = predicates.isType 'Integer,
                  parallelism = predicates.isType 'Integer,
                  parse_table_names_from_sql = predicates.isType '"Bool",
                  skip_draft = predicates.isType '"Bool",
                  sql_parser = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          redshift = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.redshift_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "redshift" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          redshift-legacy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.redshift-legacy_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "redshift-legacy" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          redshift-legacy_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "host_port" ],
                predicates.records.record
                {
                  bucket_duration = definitions.predicate.BucketDuration,
                  capture_lineage_query_parser_failures = predicates.isType
                      '"Bool",
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  default_schema = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  end_time = predicates.isType '"String",
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_copy_lineage = predicates.isType '"Bool",
                  include_table_lineage = predicates.isType '"Bool",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_unload_lineage = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  platform_instance_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  s3_lineage_config =
                    definitions.predicate.S3LineageProviderConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  sqlalchemy_uri = predicates.isType '"String",
                  start_time = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_lineage_mode = definitions.predicate.LineageMode,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          redshift-usage-legacy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.redshift-usage-legacy_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "redshift-usage-legacy" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          redshift-usage-legacy_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "email_domain", "host_port" ],
                predicates.records.record
                {
                  bucket_duration = definitions.predicate.BucketDuration,
                  capture_lineage_query_parser_failures = predicates.isType
                      '"Bool",
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  default_schema = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  email_domain = predicates.isType '"String",
                  end_time = predicates.isType '"String",
                  env = predicates.isType '"String",
                  format_sql_queries = predicates.isType '"Bool",
                  host_port = predicates.isType '"String",
                  include_copy_lineage = predicates.isType '"Bool",
                  include_operational_stats = predicates.isType '"Bool",
                  include_read_operational_stats = predicates.isType '"Bool",
                  include_table_lineage = predicates.isType '"Bool",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_top_n_queries = predicates.isType '"Bool",
                  include_unload_lineage = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  platform_instance_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  s3_lineage_config =
                    definitions.predicate.S3LineageProviderConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  sqlalchemy_uri = predicates.isType '"String",
                  start_time = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_lineage_mode = definitions.predicate.LineageMode,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  top_n_queries = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  user_email_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          redshift_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "host_port" ],
                predicates.records.record
                {
                  bucket_duration = definitions.predicate.BucketDuration,
                  capture_lineage_query_parser_failures = predicates.isType
                      '"Bool",
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  default_schema = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  email_domain = predicates.isType '"String",
                  enable_stateful_lineage_ingestion = predicates.isType '"Bool",
                  enable_stateful_profiling = predicates.isType '"Bool",
                  enable_stateful_usage_ingestion = predicates.isType '"Bool",
                  end_time = predicates.isType '"String",
                  env = predicates.isType '"String",
                  extra_client_options = predicates.isType 'Record,
                  extract_column_level_lineage = predicates.isType '"Bool",
                  format_sql_queries = predicates.isType '"Bool",
                  host_port = predicates.isType '"String",
                  include_copy_lineage = predicates.isType '"Bool",
                  include_operational_stats = predicates.isType '"Bool",
                  include_read_operational_stats = predicates.isType '"Bool",
                  include_table_lineage = predicates.isType '"Bool",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_top_n_queries = predicates.isType '"Bool",
                  include_unload_lineage = predicates.isType '"Bool",
                  include_usage_statistics = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  incremental_lineage = predicates.isType '"Bool",
                  match_fully_qualified_names = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  platform_instance_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  s3_lineage_config =
                    definitions.predicate.S3LineageProviderConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  scheme = predicates.isType '"String",
                  sql_parser_use_external_process = predicates.isType '"Bool",
                  sqlalchemy_uri = predicates.isType '"String",
                  start_time = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_lineage_mode = definitions.predicate.LineageMode,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  top_n_queries = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  user_email_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          s3 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.s3_config,
                  type = predicates.allOf
                      [ predicates.isType '"String", predicates.enum [ "s3" ] ],
                }
                {  }
                true
                predicates.always
              ],
          s3_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path_specs" ],
                predicates.records.record
                {
                  aws_config = definitions.predicate.AwsConnectionConfig,
                  env = predicates.isType '"String",
                  max_rows = predicates.isType 'Integer,
                  number_of_files_to_sample = predicates.isType 'Integer,
                  path_specs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.PathSpec
                      ],
                  platform = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_patterns = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.DataLakeProfilerConfig,
                  spark_config = predicates.isType 'Record,
                  spark_driver_memory = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  use_s3_bucket_tags = predicates.isType '"Bool",
                  use_s3_object_tags = predicates.isType '"Bool",
                  verify_ssl = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          sagemaker = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.sagemaker_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "sagemaker" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          sagemaker_config
            | doc m%"
            Common AWS credentials config.
            
            Currently used by:
                - Glue source
                - SageMaker source
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "aws_region" ],
                predicates.records.record
                {
                  aws_access_key_id = predicates.isType '"String",
                  aws_endpoint_url = predicates.isType '"String",
                  aws_profile = predicates.isType '"String",
                  aws_proxy = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  aws_region = predicates.isType '"String",
                  aws_role = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.AwsAssumeRoleConfig
                          ])
                        ]
                      ],
                  aws_secret_access_key = predicates.isType '"String",
                  aws_session_token = predicates.isType '"String",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  env = predicates.isType '"String",
                  extract_feature_groups = predicates.isType '"Bool",
                  extract_jobs = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"Bool"
                      ],
                  extract_models = predicates.isType '"Bool",
                  table_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          salesforce = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.salesforce_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "salesforce" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          salesforce_config
            | doc m%"
            Any source that is a primary producer of Dataset metadata should inherit this class
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  access_token = predicates.isType '"String",
                  auth = definitions.predicate.SalesforceAuthType,
                  consumer_key = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  ingest_tags = predicates.isType '"Bool",
                  instance_url = predicates.isType '"String",
                  is_sandbox = predicates.isType '"Bool",
                  object_pattern = definitions.predicate.AllowDenyPattern,
                  password = predicates.isType '"String",
                  platform = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  private_key = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.SalesforceProfilingConfig,
                  security_token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          snowflake = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.snowflake_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "snowflake" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          snowflake_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "account_id" ],
                predicates.records.record
                {
                  account_id = predicates.isType '"String",
                  apply_view_usage_to_tables = predicates.isType '"Bool",
                  authentication_type = predicates.isType '"String",
                  bucket_duration = definitions.predicate.BucketDuration,
                  classification = definitions.predicate.ClassificationConfig,
                  connect_args = predicates.isType 'Record,
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  email_as_user_identifier = predicates.isType '"Bool",
                  email_domain = predicates.isType '"String",
                  enable_stateful_lineage_ingestion = predicates.isType '"Bool",
                  enable_stateful_profiling = predicates.isType '"Bool",
                  enable_stateful_usage_ingestion = predicates.isType '"Bool",
                  end_time = predicates.isType '"String",
                  env = predicates.isType '"String",
                  extract_tags = definitions.predicate.TagOption,
                  format_sql_queries = predicates.isType '"Bool",
                  ignore_start_time_lineage = predicates.isType '"Bool",
                  include_column_lineage = predicates.isType '"Bool",
                  include_external_url = predicates.isType '"Bool",
                  include_operational_stats = predicates.isType '"Bool",
                  include_read_operational_stats = predicates.isType '"Bool",
                  include_table_lineage = predicates.isType '"Bool",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_technical_schema = predicates.isType '"Bool",
                  include_top_n_queries = predicates.isType '"Bool",
                  include_usage_stats = predicates.isType '"Bool",
                  include_view_column_lineage = predicates.isType '"Bool",
                  include_view_lineage = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  incremental_lineage = predicates.isType '"Bool",
                  match_fully_qualified_names = predicates.isType '"Bool",
                  oauth_config = definitions.predicate.OAuthConfiguration,
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  private_key = predicates.isType '"String",
                  private_key_password = predicates.isType '"String",
                  private_key_path = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  role = predicates.isType '"String",
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  scheme = predicates.isType '"String",
                  shares = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.SnowflakeShareConfig
                      ],
                  sql_parser_use_external_process = predicates.isType '"Bool",
                  start_time = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  tag_pattern = definitions.predicate.AllowDenyPattern,
                  temporary_tables_pattern = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  top_n_queries = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  upstream_lineage_in_report = predicates.isType '"Bool",
                  user_email_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  validate_upstreams_against_patterns = predicates.isType
                      '"Bool",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                  warehouse = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          sql-queries = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.sql-queries_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "sql-queries" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          sql-queries_config
            | doc m%"
            Any source that connects to a platform should inherit this class
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "platform", "query_file" ],
                predicates.records.record
                {
                  default_db = predicates.isType '"String",
                  default_schema = predicates.isType '"String",
                  env = predicates.isType '"String",
                  platform = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  query_file = predicates.isType '"String",
                  usage = definitions.predicate.BaseUsageConfig,
                }
                {  }
                false
                predicates.never
              ],
          sqlalchemy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.sqlalchemy_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "sqlalchemy" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          sqlalchemy_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "connect_uri", "platform" ],
                predicates.records.record
                {
                  connect_uri = predicates.isType '"String",
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  platform = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          starburst-trino-usage = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.starburst-trino-usage_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "starburst-trino-usage" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          starburst-trino-usage_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "audit_catalog",
                  "audit_schema",
                  "database",
                  "email_domain",
                  "host_port"
                ],
                predicates.records.record
                {
                  audit_catalog = predicates.isType '"String",
                  audit_schema = predicates.isType '"String",
                  bucket_duration = definitions.predicate.BucketDuration,
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  email_domain = predicates.isType '"String",
                  end_time = predicates.isType '"String",
                  env = predicates.isType '"String",
                  format_sql_queries = predicates.isType '"Bool",
                  host_port = predicates.isType '"String",
                  include_operational_stats = predicates.isType '"Bool",
                  include_read_operational_stats = predicates.isType '"Bool",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_top_n_queries = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  sqlalchemy_uri = predicates.isType '"String",
                  start_time = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  top_n_queries = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  user_email_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          superset = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.superset_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "superset" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          superset_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  connect_uri = predicates.isType '"String",
                  database_alias = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  display_uri = predicates.isType '"String",
                  env = predicates.isType '"String",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  provider = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          tableau = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.tableau_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "tableau" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          tableau_config
            | doc m%"
            Any non-Dataset source that produces lineage to Datasets should inherit this class.
            e.g. Orchestrators, Pipelines, BI Tools etc.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "connect_uri" ],
                predicates.records.record
                {
                  connect_uri = predicates.isType '"String",
                  default_schema_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  env = predicates.isType '"String",
                  extract_column_level_lineage = predicates.isType '"Bool",
                  extract_lineage_from_unsupported_custom_sql_queries =
                    predicates.isType '"Bool",
                  extract_project_hierarchy = predicates.isType '"Bool",
                  extract_usage_stats = predicates.isType '"Bool",
                  ingest_embed_url = predicates.isType '"Bool",
                  ingest_external_links_for_charts = predicates.isType '"Bool",
                  ingest_external_links_for_dashboards = predicates.isType
                      '"Bool",
                  ingest_owner = predicates.isType '"Bool",
                  ingest_tables_external = predicates.isType '"Bool",
                  ingest_tags = predicates.isType '"Bool",
                  lineage_overrides =
                    definitions.predicate.TableauLineageOverrides,
                  page_size = predicates.isType 'Integer,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  platform_instance_map = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  project_path_separator = predicates.isType '"String",
                  project_pattern = definitions.predicate.AllowDenyPattern,
                  projects = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  site = predicates.isType '"String",
                  ssl_verify = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  token_name = predicates.isType '"String",
                  token_value = predicates.isType '"String",
                  username = predicates.isType '"String",
                  workbook_page_size = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          teradata = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.teradata_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "teradata" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          teradata_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "host_port" ],
                predicates.records.record
                {
                  bucket_duration = definitions.predicate.BucketDuration,
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  database_pattern = definitions.predicate.AllowDenyPattern,
                  default_db = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  end_time = predicates.isType '"String",
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_table_lineage = predicates.isType '"Bool",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_usage_statistics = predicates.isType '"Bool",
                  include_view_lineage = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  scheme = predicates.isType '"String",
                  sqlalchemy_uri = predicates.isType '"String",
                  start_time = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  usage = definitions.predicate.BaseUsageConfig,
                  use_file_backed_cache = predicates.isType '"Bool",
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          trino = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.trino_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "trino" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          trino_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "host_port" ],
                predicates.records.record
                {
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  sqlalchemy_uri = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
                }
                {  }
                false
                predicates.never
              ],
          unity-catalog = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.unity-catalog_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "unity-catalog" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          unity-catalog_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "token", "workspace_url" ],
                predicates.records.record
                {
                  bucket_duration = definitions.predicate.BucketDuration,
                  catalog_pattern = definitions.predicate.AllowDenyPattern,
                  column_lineage_column_limit = predicates.isType 'Integer,
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  enable_stateful_profiling = predicates.isType '"Bool",
                  end_time = predicates.isType '"String",
                  env = predicates.isType '"String",
                  format_sql_queries = predicates.isType '"Bool",
                  include_column_lineage = predicates.isType '"Bool",
                  include_metastore = predicates.isType '"Bool",
                  include_notebooks = predicates.isType '"Bool",
                  include_operational_stats = predicates.isType '"Bool",
                  include_ownership = predicates.isType '"Bool",
                  include_read_operational_stats = predicates.isType '"Bool",
                  include_table_lineage = predicates.isType '"Bool",
                  include_top_n_queries = predicates.isType '"Bool",
                  include_usage_statistics = predicates.isType '"Bool",
                  ingest_data_platform_instance_aspect = predicates.isType
                      '"Bool",
                  notebook_pattern = definitions.predicate.AllowDenyPattern,
                  platform_instance = predicates.isType '"String",
                  profiling = definitions.predicate.UnityCatalogProfilerConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  start_time = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  token = predicates.isType '"String",
                  top_n_queries = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.exclusiveMinimum 0
                      ],
                  user_email_pattern = definitions.predicate.AllowDenyPattern,
                  workspace_name = predicates.isType '"String",
                  workspace_url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          vertica = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "type" ],
                predicates.records.record
                {
                  config = definitions.predicate.vertica_config,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "vertica" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          vertica_config
            | doc m%"
            Base configuration class for stateful ingestion for source configs to inherit from.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "host_port" ],
                predicates.records.record
                {
                  convert_urns_to_lowercase = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  database_alias = predicates.isType '"String",
                  domain = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.AllowDenyPattern
                      ],
                  env = predicates.isType '"String",
                  host_port = predicates.isType '"String",
                  include_models = predicates.isType '"Bool",
                  include_projection_lineage = predicates.isType '"Bool",
                  include_projections = predicates.isType '"Bool",
                  include_table_location_lineage = predicates.isType '"Bool",
                  include_tables = predicates.isType '"Bool",
                  include_view_lineage = predicates.isType '"Bool",
                  include_views = predicates.isType '"Bool",
                  models_pattern = definitions.predicate.AllowDenyPattern,
                  options = predicates.isType 'Record,
                  password = predicates.isType '"String",
                  platform_instance = predicates.isType '"String",
                  profile_pattern = definitions.predicate.AllowDenyPattern,
                  profiling = definitions.predicate.GEProfilingConfig,
                  schema_pattern = definitions.predicate.AllowDenyPattern,
                  scheme = predicates.isType '"String",
                  sqlalchemy_uri = predicates.isType '"String",
                  stateful_ingestion =
                    definitions.predicate.StatefulStaleMetadataRemovalConfig,
                  table_pattern = definitions.predicate.AllowDenyPattern,
                  username = predicates.isType '"String",
                  view_pattern = definitions.predicate.AllowDenyPattern,
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
  predicates.records.required [ "source" ],
  predicates.records.record
  {
    sink = predicates.anyOf
        [
          definitions.predicate.datahub_kafka_sink,
          definitions.predicate.datahub_rest_sink,
          definitions.predicate.console_sink,
          definitions.predicate.file_sink
        ],
    source = predicates.anyOf
        [
          definitions.predicate.trino,
          definitions.predicate.openapi,
          definitions.predicate.lookml,
          definitions.predicate.gcs,
          definitions.predicate.datahub,
          definitions.predicate.mssql,
          definitions.predicate.mongodb,
          definitions.predicate.okta,
          definitions.predicate.dbt-cloud,
          definitions.predicate.sqlalchemy,
          definitions.predicate.s3,
          definitions.predicate.iceberg,
          definitions.predicate.hive,
          definitions.predicate.starburst-trino-usage,
          definitions.predicate.mysql,
          definitions.predicate.unity-catalog,
          definitions.predicate.mode,
          definitions.predicate.datahub-business-glossary,
          definitions.predicate.redash,
          definitions.predicate.vertica,
          definitions.predicate.oracle,
          definitions.predicate.sql-queries,
          definitions.predicate.redshift,
          definitions.predicate.bigquery,
          definitions.predicate.dbt,
          definitions.predicate.looker,
          definitions.predicate.ldap,
          definitions.predicate.datahub-lineage-file,
          definitions.predicate.presto,
          definitions.predicate.file,
          definitions.predicate.dynamodb,
          definitions.predicate.salesforce,
          definitions.predicate.elasticsearch,
          definitions.predicate.redshift-legacy,
          definitions.predicate.hana,
          definitions.predicate.presto-on-hive,
          definitions.predicate.sagemaker,
          definitions.predicate.snowflake,
          definitions.predicate.druid,
          definitions.predicate.nifi,
          definitions.predicate.metabase,
          definitions.predicate.athena,
          definitions.predicate.superset,
          definitions.predicate.feast,
          definitions.predicate.clickhouse-usage,
          definitions.predicate.powerbi-report-server,
          definitions.predicate.demo-data,
          definitions.predicate.glue,
          definitions.predicate.kafka,
          definitions.predicate.postgres,
          definitions.predicate.pulsar,
          definitions.predicate.kafka-connect,
          definitions.predicate.delta-lake,
          definitions.predicate.azure-ad,
          definitions.predicate.mlflow,
          definitions.predicate.clickhouse,
          definitions.predicate.csv-enricher,
          definitions.predicate.teradata,
          definitions.predicate.redshift-usage-legacy,
          definitions.predicate.json-schema,
          definitions.predicate.powerbi,
          definitions.predicate.tableau,
          definitions.predicate.mariadb
        ],
    transformers = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "type" ],
            predicates.records.record
            {
              config = predicates.isType 'Record,
              type = predicates.isType '"String",
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