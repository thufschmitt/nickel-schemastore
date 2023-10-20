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
  bench
    | {
      exclude
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of files, directories or globs that will not be searched for benchmarks.
        "%
        | optional,
      files
        | {
          exclude
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of files, directories or globs that will not be searched for benchmarks.
            "%
            | optional,
          include
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of files, directories or globs that will be searched for benchmarks.
            "%
            | optional,
          ..
        }
        | optional,
      include
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of files, directories or globs that will be searched for benchmarks.
        "%
        | optional,
      ..
    }
    | doc m%"
    Configuration for deno bench
    "%
    | optional,
  compilerOptions
    | {
      allowJs
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Allow JavaScript files to be a part of your program. Use the `checkJS` option to get errors from these files.
        "%
        | optional,
      allowUnreachableCode
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Disable error reporting for unreachable code.
        "%
        | optional,
      allowUnusedLabels
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Disable error reporting for unused labels.
        "%
        | optional,
      checkJs
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Enable error reporting in type-checked JavaScript files.
        "%
        | optional,
      exactOptionalPropertyTypes
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Differentiate between undefined and not present when type checking
        "%
        | optional,
      experimentalDecorators
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Enable experimental support for TC39 stage 2 draft decorators.
        "%
        | optional,
      jsx
        | predicates.contract_from_predicate
        (predicates.enum
        [ "preserve", "react", "react-jsx", "react-jsxdev", "react-native" ])
        | doc m%"
        Specify what JSX code is generated.
        "%
        | optional,
      jsxFactory
        | predicates.contract_from_predicate (predicates.isType '"String")
        | doc m%"
        Specify the JSX factory function used when targeting React JSX emit, e.g. 'React.createElement' or 'h'
        "%
        | optional,
      jsxFragmentFactory
        | predicates.contract_from_predicate (predicates.isType '"String")
        | doc m%"
        Specify the JSX Fragment reference used for fragments when targeting React JSX emit e.g. 'React.Fragment' or 'Fragment'.
        "%
        | optional,
      jsxImportSource
        | predicates.contract_from_predicate (predicates.isType '"String")
        | doc m%"
        Specify module specifier used to import the JSX factory functions when using jsx: 'react-jsx*'.
        "%
        | optional,
      keyofStringsOnly
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Make keyof only return strings instead of string, numbers or symbols. Legacy option.
        "%
        | optional,
      lib
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String"),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        Specify a set of bundled library declaration files that describe the target runtime environment.
        "%
        | optional,
      noErrorTruncation
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Do not truncate error messages.
        "%
        | optional,
      noFallthroughCasesInSwitch
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Enable error reporting for fallthrough cases in switch statements.
        "%
        | optional,
      noImplicitAny
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Enable error reporting for expressions and declarations with an implied `any` type..
        "%
        | optional,
      noImplicitOverride
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Ensure overriding members in derived classes are marked with an override modifier.
        "%
        | optional,
      noImplicitReturns
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Enable error reporting for codepaths that do not explicitly return in a function.
        "%
        | optional,
      noImplicitThis
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Enable error reporting when `this` is given the type `any`.
        "%
        | optional,
      noImplicitUseStrict
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Disable adding 'use strict' directives in emitted JavaScript files.
        "%
        | optional,
      noStrictGenericChecks
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Disable strict checking of generic signatures in function types.
        "%
        | optional,
      noUncheckedIndexedAccess
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Add `undefined` to a type when accessed using an index.
        "%
        | optional,
      noUnusedLocals
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Enable error reporting when a local variables aren't read.
        "%
        | optional,
      noUnusedParameters
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Raise an error when a function parameter isn't read
        "%
        | optional,
      strict
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Enable all strict type checking options.
        "%
        | optional,
      strictBindCallApply
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Check that the arguments for `bind`, `call`, and `apply` methods match the original function.
        "%
        | optional,
      strictFunctionTypes
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        When assigning functions, check to ensure parameters and the return values are subtype-compatible.
        "%
        | optional,
      strictNullChecks
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        When type checking, take into account `null` and `undefined`.
        "%
        | optional,
      strictPropertyInitialization
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Check for class properties that are declared but not set in the constructor.
        "%
        | optional,
      suppressExcessPropertyErrors
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Disable reporting of excess property errors during the creation of object literals.
        "%
        | optional,
      suppressImplicitAnyIndexErrors
        | predicates.contract_from_predicate (predicates.isType '"Bool")
        | doc m%"
        Suppress `noImplicitAny` errors when indexing objects that lack index signatures.
        "%
        | optional,
      ..
    }
    | doc m%"
    Instructs the TypeScript compiler how to compile .ts files.
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
    List of files, directories or globs that will be ignored by all other configurations. Requires Deno 1.34 or later.
    "%
    | optional,
  fmt
    | {
      exclude
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of files, directories or globs that will not be formatted.
        "%
        | optional,
      files
        | {
          exclude
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of files, directories or globs that will not be formatted.
            "%
            | optional,
          include
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of files, directories or globs that will be formatted.
            "%
            | optional,
          ..
        }
        | optional,
      include
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of files, directories or globs that will be formatted.
        "%
        | optional,
      indentWidth
        | Number
        | doc m%"
        The number of characters for an indent.
        "%
        | optional,
      lineWidth
        | Number
        | doc m%"
        The width of a line the printer will try to stay under. Note that the printer may exceed this width in certain cases.
        "%
        | optional,
      options
        | {
          indentWidth
            | Number
            | doc m%"
            The number of characters for an indent.
            "%
            | optional,
          lineWidth
            | Number
            | doc m%"
            The width of a line the printer will try to stay under. Note that the printer may exceed this width in certain cases.
            "%
            | optional,
          proseWrap
            | predicates.contract_from_predicate
            (predicates.enum [ "always", "never", "preserve" ])
            | doc m%"
            Define how prose should be wrapped in Markdown files.
            "%
            | optional,
          semiColons
            | Bool
            | doc m%"
            Whether to prefer using semicolons.
            "%
            | optional,
          singleQuote
            | Bool
            | doc m%"
            Whether to use single quote (true) or double quote (false) for quotation.
            "%
            | optional,
          useTabs
            | Bool
            | doc m%"
            Whether to use tabs (true) or spaces (false) for indentation.
            "%
            | optional,
          ..
        }
        | optional,
      proseWrap
        | predicates.contract_from_predicate
        (predicates.enum [ "always", "never", "preserve" ])
        | doc m%"
        Define how prose should be wrapped in Markdown files.
        "%
        | optional,
      semiColons
        | Bool
        | doc m%"
        Whether to prefer using semicolons.
        "%
        | optional,
      singleQuote
        | Bool
        | doc m%"
        Whether to use single quote (true) or double quote (false) for quotation.
        "%
        | optional,
      useTabs
        | Bool
        | doc m%"
        Whether to use tabs (true) or spaces (false) for indentation.
        "%
        | optional,
      ..
    }
    | doc m%"
    Configuration for formatter
    "%
    | optional,
  importMap
    | String
    | doc m%"
    The location of an import map to be used when resolving modules. If an import map is specified as an `--importmap` flag or using "imports" and "scopes" properties, they will override this value.
    "%
    | optional,
  imports
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true (predicates.isType '"String")
    ])
    | doc m%"
    A map of specifiers to their remapped specifiers.
    "%
    | optional,
  lint
    | {
      exclude
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of files, directories or globs that will not be linted.
        "%
        | optional,
      files
        | {
          exclude
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of files, directories or globs that will not be linted.
            "%
            | optional,
          include
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of files, directories or globs that will be linted.
            "%
            | optional,
          ..
        }
        | optional,
      include
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of files, directories or globs that will be linted.
        "%
        | optional,
      report
        | predicates.contract_from_predicate
        (predicates.enum [ "pretty", "json", "compact" ])
        | doc m%"
        The default report format to use when linting
        "%
        | optional,
      rules
        | {
          exclude
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String"),
              predicates.arrays.minItems 0,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            List of rule names that will be excluded from configured tag sets. If the same rule is in `include` it will be run.
            "%
            | optional,
          include
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String"),
              predicates.arrays.minItems 0,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            List of rule names that will be run. Even if the same rule is in `exclude` it will be run.
            "%
            | optional,
          tags
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String"),
              predicates.arrays.minItems 0,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            List of tag names that will be run. Empty list disables all tags and will only use rules from `include`.
            "%
            | optional,
          ..
        }
        | optional,
      ..
    }
    | doc m%"
    Configuration for linter
    "%
    | optional,
  lock
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ predicates.isType '"String", predicates.isType '"Bool" ])
    | doc m%"
    Whether to use a lock file or the path to use for the lock file. Can be overridden by CLI arguments.
    "%
    | optional,
  nodeModulesDir
    | Bool
    | doc m%"
    Enables or disables the use of a local node_modules folder for npm packages. Alternatively, use the `--node-modules-dir` flag or override the config via `--node-modules-dir=false`. Requires Deno 1.34 or later.
    "%
    | optional,
  scopes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record {  } {  } true (predicates.isType '"String")
      ])
    ])
    | doc m%"
    Define a scope which remaps a specifier in only a specified scope
    "%
    | optional,
  tasks
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      { "^[A-Za-z][A-Za-z0-9_\\-:]*$" = predicates.isType '"String", }
      false
      predicates.never
    ])
    | doc m%"
    Configuration for deno task
    "%
    | optional,
  test
    | {
      exclude
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of files, directories or globs that will not be searched for tests.
        "%
        | optional,
      files
        | {
          exclude
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of files, directories or globs that will not be searched for tests.
            "%
            | optional,
          include
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of files, directories or globs that will be searched for tests.
            "%
            | optional,
          ..
        }
        | optional,
      include
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of files, directories or globs that will be searched for tests.
        "%
        | optional,
      ..
    }
    | doc m%"
    Configuration for deno test
    "%
    | optional,
  vendor
    | Bool
    | doc m%"
    UNSTABLE: Enables or disables the use of a local vendor folder as a local cache for remote modules and node_modules folder for npm packages. Alternatively, use the `--vendor` flag or override the config via `--vendor=false`. Requires Deno 1.36.1 or later.
    "%
    | optional,
  ..
}