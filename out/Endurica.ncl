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
          historyOptions = predicates.contract_from_predicate
              definitions.predicate.historyOptions,
          historyOptionsBlock = {
                block_repeats
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | optional,
                ozone_concentration | Number | optional,
                period
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | optional,
                temperature | Number | optional,
                ..
              },
          historyOptionsGlobal = predicates.contract_from_predicate
              definitions.predicate.historyOptionsGlobal,
          historyOptionsStep = predicates.contract_from_predicate
              definitions.predicate.historyOptionsStep,
          units = predicates.contract_from_predicate
              definitions.predicate.units,
        },
    predicate = {
          historyOptions = predicates.records.record
              {
                block_repeats = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.minimum 0
                    ],
                material = predicates.isType '"String",
                ozone_concentration = predicates.isType '"Number",
                period = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.minimum 0
                    ],
                preage_temperature = predicates.isType '"Number",
                preage_time = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.minimum 0
                    ],
                step_repeats = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.minimum 0
                    ],
                temperature = predicates.isType '"Number",
                type = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "ne",
                          "le",
                          "dg",
                          "gls",
                          "ne_plane_stress",
                          "le_plane_stress",
                          "gls_plane_stress",
                          "dg_ss",
                          "ne_eq",
                          "ne_pl",
                          "ne_si",
                          "ne_vol",
                          "le_eq",
                          "le_pl",
                          "le_si",
                          "hydrostatic_stress",
                          "temperature"
                        ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                volume = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.exclusiveMinimum 0
                    ],
              }
              {  }
              true
              predicates.always,
          historyOptionsBlock = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  block_repeats = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  ozone_concentration = predicates.isType '"Number",
                  period = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  temperature = predicates.isType '"Number",
                }
                {  }
                true
                predicates.always
              ],
          historyOptionsGlobal = predicates.records.record
              {
                block_repeats = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.minimum 0
                    ],
                material = predicates.isType '"String",
                ozone_concentration = predicates.isType '"Number",
                period = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.minimum 0
                    ],
                preage_temperature = predicates.isType '"Number",
                preage_time = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.minimum 0
                    ],
                rolling = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        sectors = predicates.allOf
                            [
                              predicates.isType '"Number",
                              predicates.numbers.multipleOf 1
                            ],
                        stride = predicates.allOf
                            [
                              predicates.isType '"Number",
                              predicates.numbers.multipleOf 1
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ],
                step_repeats = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.minimum 0
                    ],
                temperature = predicates.isType '"Number",
                type = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "ne",
                          "le",
                          "dg",
                          "gls",
                          "ne_plane_stress",
                          "le_plane_stress",
                          "gls_plane_stress",
                          "dg_ss",
                          "ne_eq",
                          "ne_pl",
                          "ne_si",
                          "ne_vol",
                          "le_eq",
                          "le_pl",
                          "le_si",
                          "hydrostatic_stress",
                          "temperature"
                        ]
                      ]),
                      predicates.arrays.uniqueItems
                    ],
                volume = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.exclusiveMinimum 0
                    ],
              }
              {  }
              true
              predicates.always,
          historyOptionsStep = predicates.records.record
              {
                block_repeats = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.minimum 0
                    ],
                ozone_concentration = predicates.isType '"Number",
                period = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.minimum 0
                    ],
                step_repeats = predicates.allOf
                    [
                      predicates.isType '"Number",
                      predicates.numbers.minimum 0
                    ],
                temperature = predicates.isType '"Number",
              }
              {  }
              true
              predicates.always,
          units = predicates.always,
        },
  }
in

{
  header
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
    Text section used to document the analysis.
    "%
    | optional,
  history
    | {
      histories
        | predicates.contract_from_predicate
        (predicates.oneOf
        [
          predicates.isType '"String",
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf
            (predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.required [ "label" ],
              predicates.records.record
              {
                label = predicates.isType '"String",
                options = definitions.predicate.historyOptions,
                steps = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          blocks = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    data = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType '"Array",
                                            predicates.arrays.arrayOf
                                            (predicates.isType '"Number")
                                          ])
                                        ],
                                    options =
                                      definitions.predicate.historyOptionsBlock,
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ])
                              ],
                          options = definitions.predicate.historyOptionsStep,
                        }
                        {  }
                        true
                        predicates.always
                      ])
                    ],
              }
              {  }
              true
              predicates.always
            ])
          ]
        ])
        | doc m%"
        An array of histories or a file path to an external input file containing an array of histories
        "%
        | optional,
      length
        | predicates.contract_from_predicate
        (predicates.allOf
        [ predicates.isType '"Number", predicates.numbers.multipleOf 1 ])
        | doc m%"
        Specify the number of histories in the analysis
        "%
        | optional,
      options | definitions.contract.historyOptionsGlobal | optional,
      schedule
        | {
          steps
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "blocks" ],
                predicates.records.record
                {
                  blocks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "file" ],
                          predicates.records.record
                          {
                            file = predicates.isType '"String",
                            options = definitions.predicate.historyOptionsBlock,
                          }
                          {  }
                          true
                          predicates.always
                        ])
                      ],
                  options = definitions.predicate.historyOptionsStep,
                }
                {  }
                true
                predicates.always
              ])
            ]),
          ..
        }
        | doc m%"
        A schedule definition of steps and blocks, where a block is defined by an external input file containing an array of histories
        "%
        | optional,
    }
    | doc m%"
    History definitions.
    "%
    | optional,
  material_analysis
    | {
      ageing_crack_growth_rate
        | {
          T_max | Number | optional,
          T_min | Number | optional,
          age_max
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.exclusiveMinimum 0
            ]),
          age_min
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
            | optional,
          n_T
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.multipleOf 1,
              predicates.numbers.minimum 2
            ])
            | optional,
          n_age
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.multipleOf 1,
              predicates.numbers.minimum 2
            ])
            | optional,
        }
        | doc m%"
        Crack growth rate curves at varying ages.
        "%
        | optional,
      ageing_strain_life
        | {
          age_max
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.exclusiveMinimum 0
            ]),
          age_min
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
            | optional,
          n_age
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.multipleOf 1,
              predicates.numbers.minimum 2
            ])
            | optional,
          n_strain
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.multipleOf 1,
              predicates.numbers.minimum 2
            ])
            | optional,
          strain_max
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.exclusiveMinimum 0
            ]),
          strain_min
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.exclusiveMinimum 0
            ]),
        }
        | doc m%"
        Strain-life curves at varying ages.
        "%
        | optional,
      crack_growth_rate
        | {
          R_max
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.maximum 1,
              predicates.numbers.minimum 0
            ])
            | optional,
          R_min
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.maximum 1,
              predicates.numbers.minimum 0
            ])
            | optional,
          T_max
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.exclusiveMinimum 0
            ])
            | optional,
          T_min
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.exclusiveMinimum 0
            ])
            | optional,
          n_R
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.multipleOf 1,
              predicates.numbers.minimum 2
            ])
            | optional,
          n_T
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.multipleOf 1,
              predicates.numbers.minimum 2
            ])
            | optional,
        }
        | doc m%"
        Crack growth rate curves at varying R ratios.
        "%
        | optional,
      haigh_diagram
        | {
          n
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.multipleOf 1,
              predicates.numbers.minimum 2
            ])
            | optional,
          strain_amplitude_max | Number | optional,
          strain_mean_max | Number | optional,
        }
        | doc m%"
        Haigh diagram output.
        "%
        | optional,
      stress_strain
        | {
          n_points
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.multipleOf 1,
              predicates.numbers.minimum 2
            ])
            | optional,
          n_unloads
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.multipleOf 1,
              predicates.numbers.minimum 2
            ])
            | optional,
          strain_max | Number | optional,
          strain_min | Number | optional,
          volume_strain_max | Number | optional,
          volume_strain_min | Number | optional,
        }
        | doc m%"
        Stress-Strain curves for different modes of deformation.
        "%
        | optional,
    }
    | doc m%"
    Material analysis definitions that will be performed for each material definition.
    "%
    | optional,
  materials
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "name" ],
        predicates.records.record
        {
          ageing = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  { type = predicates.enum [ "default" ], }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    absolute_zero = predicates.always,
                    activation_energy = predicates.always,
                    gas_constant = predicates.always,
                    stiffness = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"Number",
                            predicates.numbers.minimum 0
                          ])
                        ],
                    temp_ref = predicates.always,
                    time = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"Number",
                            predicates.numbers.minimum 0
                          ])
                        ],
                    type = predicates.enum [ "arrhenius" ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          c0 = predicates.allOf
              [
                predicates.isType '"Number",
                predicates.numbers.exclusiveMinimum 0,
                definitions.predicate."units/length"
              ],
          cf = predicates.allOf
              [
                predicates.isType '"Number",
                predicates.numbers.exclusiveMinimum 0,
                definitions.predicate."units/length"
              ],
          crack_growth_rate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    F0 = definitions.predicate."units/unitless",
                    Tcritical = definitions.predicate."units/energyReleaseRate",
                    rc = definitions.predicate."units/length_over_cycle",
                    temp_coef =
                      definitions.predicate."units/temperatureCoefficient",
                    temp_ref = definitions.predicate."units/temperature",
                    temperatures = definitions.predicate."units/temperature",
                    type = predicates.enum [ "thomas" ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    F0 = definitions.predicate."units/unitless",
                    Tcritical = definitions.predicate."units/energyReleaseRate",
                    rc = definitions.predicate."units/length_over_cycle",
                    temp_coef =
                      definitions.predicate."units/temperatureCoefficient",
                    temp_ref = definitions.predicate."units/temperature",
                    temperatures = definitions.predicate."units/temperature",
                    threshold = definitions.predicate."units/energyReleaseRate",
                    transition =
                      definitions.predicate."units/energyReleaseRate",
                    type = predicates.enum [ "lakelindley" ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    table = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.items
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Number",
                                predicates.numbers.minimum 0
                              ],
                              predicates.allOf
                              [
                                predicates.isType '"Number",
                                predicates.numbers.minimum 0
                              ]
                            ],
                            predicates.arrays.maxItems 2,
                            predicates.arrays.minItems 2
                          ]),
                          predicates.arrays.minItems 2
                        ],
                    temp_coef =
                      definitions.predicate."units/temperatureCoefficient",
                    temp_ref = definitions.predicate."units/temperature",
                    type = predicates.enum [ "tabular" ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          cyclic_softening = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  { type = predicates.enum [ "default" ], }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    table = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.items
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Number",
                                predicates.numbers.maximum 1,
                                predicates.numbers.minimum 0
                              ],
                              predicates.allOf
                              [
                                predicates.isType '"Number",
                                predicates.numbers.maximum 1,
                                predicates.numbers.minimum 0
                              ]
                            ],
                            predicates.arrays.maxItems 2,
                            predicates.arrays.minItems 2
                          ])
                        ],
                    type = predicates.enum [ "tabular" ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          elasticity = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    D1 = definitions.predicate."units/1_over_pressure",
                    bulk_modulus = definitions.predicate."units/pressure",
                    limit_stretch = definitions.predicate."units/unitless",
                    shear_modulus = definitions.predicate."units/pressure",
                    temperatures = definitions.predicate."units/temperature",
                    type = predicates.enum [ "arrudaboyce" ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    alpha1 = definitions.predicate."units/unitless",
                    alpha2 = definitions.predicate."units/unitless",
                    alpha3 = definitions.predicate."units/unitless",
                    alpha4 = definitions.predicate."units/unitless",
                    alpha5 = definitions.predicate."units/unitless",
                    alpha6 = definitions.predicate."units/unitless",
                    mu1 = definitions.predicate."units/pressure",
                    mu2 = definitions.predicate."units/pressure",
                    mu3 = definitions.predicate."units/pressure",
                    mu4 = definitions.predicate."units/pressure",
                    mu5 = definitions.predicate."units/pressure",
                    mu6 = definitions.predicate."units/pressure",
                    nu1 = definitions.predicate."units/unitless",
                    nu2 = definitions.predicate."units/unitless",
                    nu3 = definitions.predicate."units/unitless",
                    nu4 = definitions.predicate."units/unitless",
                    nu5 = definitions.predicate."units/unitless",
                    nu6 = definitions.predicate."units/unitless",
                    temperatures = definitions.predicate."units/temperature",
                    type = predicates.enum [ "hyperfoam" ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    C01 = definitions.predicate."units/pressure",
                    C10 = definitions.predicate."units/pressure",
                    D1 = definitions.predicate."units/1_over_pressure",
                    bulk_modulus = definitions.predicate."units/pressure",
                    temperatures = definitions.predicate."units/temperature",
                    type = predicates.enum [ "mooneyrivlin" ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    C10 = definitions.predicate."units/pressure",
                    D1 = definitions.predicate."units/1_over_pressure",
                    bulk_modulus = definitions.predicate."units/pressure",
                    temperatures = definitions.predicate."units/temperature",
                    type = predicates.enum [ "neohookean" ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    D1 = definitions.predicate."units/1_over_pressure",
                    D2 = definitions.predicate."units/1_over_pressure",
                    D3 = definitions.predicate."units/1_over_pressure",
                    D4 = definitions.predicate."units/1_over_pressure",
                    D5 = definitions.predicate."units/1_over_pressure",
                    D6 = definitions.predicate."units/1_over_pressure",
                    alpha1 = definitions.predicate."units/unitless",
                    alpha2 = definitions.predicate."units/unitless",
                    alpha3 = definitions.predicate."units/unitless",
                    alpha4 = definitions.predicate."units/unitless",
                    alpha5 = definitions.predicate."units/unitless",
                    alpha6 = definitions.predicate."units/unitless",
                    mu1 = definitions.predicate."units/pressure",
                    mu2 = definitions.predicate."units/pressure",
                    mu3 = definitions.predicate."units/pressure",
                    mu4 = definitions.predicate."units/pressure",
                    mu5 = definitions.predicate."units/pressure",
                    mu6 = definitions.predicate."units/pressure",
                    temperatures = definitions.predicate."units/temperature",
                    type = predicates.enum [ "ogden" ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    D1 = definitions.predicate."units/1_over_pressure",
                    D2 = definitions.predicate."units/1_over_pressure",
                    D3 = definitions.predicate."units/1_over_pressure",
                    D4 = definitions.predicate."units/1_over_pressure",
                    D5 = definitions.predicate."units/1_over_pressure",
                    D6 = definitions.predicate."units/1_over_pressure",
                    alpha1 = definitions.predicate."units/unitless",
                    alpha2 = definitions.predicate."units/unitless",
                    alpha3 = definitions.predicate."units/unitless",
                    alpha4 = definitions.predicate."units/unitless",
                    alpha5 = definitions.predicate."units/unitless",
                    alpha6 = definitions.predicate."units/unitless",
                    mu1 = definitions.predicate."units/pressure",
                    mu2 = definitions.predicate."units/pressure",
                    mu3 = definitions.predicate."units/pressure",
                    mu4 = definitions.predicate."units/pressure",
                    mu5 = definitions.predicate."units/pressure",
                    mu6 = definitions.predicate."units/pressure",
                    temperatures = definitions.predicate."units/temperature",
                    type = predicates.enum [ "ogden2" ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    C10 = definitions.predicate."units/pressure",
                    C20 = definitions.predicate."units/pressure",
                    C30 = definitions.predicate."units/pressure",
                    C40 = definitions.predicate."units/pressure",
                    C50 = definitions.predicate."units/pressure",
                    C60 = definitions.predicate."units/pressure",
                    D1 = definitions.predicate."units/1_over_pressure",
                    D2 = definitions.predicate."units/1_over_pressure",
                    D3 = definitions.predicate."units/1_over_pressure",
                    D4 = definitions.predicate."units/1_over_pressure",
                    D5 = definitions.predicate."units/1_over_pressure",
                    D6 = definitions.predicate."units/1_over_pressure",
                    temperatures = definitions.predicate."units/temperature",
                    type = predicates.enum [ "reducedpolynomial" ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    D1 = definitions.predicate."units/1_over_pressure",
                    alpha = definitions.predicate."units/unitless",
                    beta = definitions.predicate."units/unitless",
                    bulk_modulus = definitions.predicate."units/pressure",
                    limit_stretch = definitions.predicate."units/unitless",
                    shear_modulus = definitions.predicate."units/pressure",
                    temperatures = definitions.predicate."units/temperature",
                    type = predicates.enum [ "vanderwaals" ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          hysteresis = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    chi = predicates.always,
                    gamma = predicates.always,
                    hys_ref = predicates.always,
                    rate_coef = predicates.always,
                    rate_ref = predicates.always,
                    scaling_factor = predicates.always,
                    strain_amplitude_ref = predicates.always,
                    temp_coef = predicates.always,
                    temp_ref = predicates.always,
                    type = predicates.enum [ "powerlaw" ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          mullins = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    beta = definitions.predicate."units/unitless",
                    m = definitions.predicate."units/pressure",
                    r = definitions.predicate."units/unitless",
                    type = predicates.enum [ "ogdenroxburgh" ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          name = predicates.isType '"String",
          nonrelaxing = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  { type = predicates.enum [ "paris" ], }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    table = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.items
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Number",
                                predicates.numbers.maximum 1,
                                predicates.numbers.minimum 0
                              ],
                              predicates.allOf
                              [
                                predicates.isType '"Number",
                                predicates.numbers.maximum 1,
                                predicates.numbers.minimum 0
                              ]
                            ],
                            predicates.arrays.maxItems 2,
                            predicates.arrays.minItems 2
                          ])
                        ],
                    type = predicates.enum [ "xR_tabular" ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  { type = predicates.enum [ "lindley73" ], }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    F1 = definitions.predicate."units/unitless",
                    F2 = definitions.predicate."units/unitless",
                    F3 = definitions.predicate."units/unitless",
                    Fexp = definitions.predicate."units/unitless",
                    temperatures = definitions.predicate."units/temperature",
                    type = predicates.enum [ "marsfatemi" ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          ozone_attack = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    Tz = definitions.predicate."units/energyReleaseRate",
                    rz = definitions.predicate."units/length_over_time",
                    type = predicates.enum [ "williams" ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    Fv = definitions.predicate."units/unitless",
                    Gv = definitions.predicate."units/temperature",
                    Kv = definitions.predicate."units/length_over_time",
                    Kz =
                      definitions.predicate."units/length_over_time_concentration",
                    Tg = definitions.predicate."units/temperature",
                    Tz = definitions.predicate."units/energyReleaseRate",
                    type = predicates.enum [ "gentmcgrath" ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          viscoelastic_rupture = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.records.record
                  {
                    F = definitions.predicate."units/unitless",
                    T0 = definitions.predicate."units/energyReleaseRate",
                    Tq = definitions.predicate."units/energyReleaseRate",
                    rq = definitions.predicate."units/length_over_time",
                    temp_coef =
                      definitions.predicate."units/temperatureCoefficient",
                    temp_ref = definitions.predicate."units/temperature",
                    type = predicates.enum [ "powerlaw" ],
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    table = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.items
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Number",
                                predicates.numbers.minimum 0
                              ],
                              predicates.allOf
                              [
                                predicates.isType '"Number",
                                predicates.numbers.minimum 0
                              ]
                            ],
                            predicates.arrays.maxItems 2,
                            predicates.arrays.minItems 2
                          ]),
                          predicates.arrays.minItems 2
                        ],
                    temp_coef =
                      definitions.predicate."units/temperatureCoefficient",
                    temp_ref = definitions.predicate."units/temperature",
                    type = predicates.enum [ "tabular" ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
        }
        {  }
        false
        predicates.never
      ]),
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    List of material definitions.
    "%
    | optional,
  outputs
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.oneOf
      [
        predicates.allOf
        [
          predicates.isType '"String",
          predicates.enum
          [
            "age",
            "block_cycle",
            "cauchy_stress",
            "cavitation",
            "ced",
            "ced_cycle_count",
            "ced_sphere",
            "crack_growth",
            "crack_size_calibration",
            "engineering_strain",
            "engineering_stress",
            "factor_of_safety",
            "factor_of_safety_ced",
            "factor_of_safety_sphere",
            "history_compression",
            "hysteresis",
            "life",
            "life_sphere",
            "logarithmic_strain",
            "principal_cauchy_stress",
            "principal_engineering_strain",
            "principal_engineering_stress",
            "principal_logarithmic_strain",
            "residual_strength",
            "sed",
            "stiffness_ratio",
            "stiffness_ratio_ageing",
            "stiffness_ratio_cyclic",
            "volume_adjustment",
            "wrinkling"
          ]
        ],
        predicates.allOf
        [
          predicates.isType 'Record,
          predicates.oneOf
          [
            predicates.records.record { name = predicates.enum [ "age" ], } {  }
            false
            predicates.never,
            predicates.records.record
            {
              n_ced = predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.multipleOf 1,
                    predicates.numbers.minimum 1
                  ],
              n_r_ratio = predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.multipleOf 1,
                    predicates.numbers.minimum 1
                  ],
              name = predicates.enum [ "block_cycle" ],
            }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "cauchy_stress" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "cavitation" ], }
            {  }
            false
            predicates.never,
            predicates.records.record { name = predicates.enum [ "ced" ], } {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "ced_cycle_cout" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "ced_sphere" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "crack_growth" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            {
              c0_min = predicates.isType '"Number",
              n_points = predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.multipleOf 1,
                    predicates.numbers.minimum 1
                  ],
              name = predicates.enum [ "crack_size_calibration" ],
              target_life = predicates.isType '"Number",
            }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "engineering_strain" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "engineering_stress" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "factor_of_safety" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "factor_of_safety_ced" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "factor_of_safety_sphere" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            {
              keep = predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ],
              n_ced = predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.multipleOf 1,
                    predicates.numbers.minimum 1
                  ],
              n_r_ratio = predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.multipleOf 1,
                    predicates.numbers.minimum 1
                  ],
              name = predicates.enum [ "history_compression" ],
            }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "hysteresis" ], }
            {  }
            false
            predicates.never,
            predicates.records.record { name = predicates.enum [ "life" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "life_sphere" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "logarithmic_strain" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "principal_cauchy_stress" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "principal_engineering_strain" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "principal_engineering_stress" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "principal_logarithmic_strain" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "residual_strength" ], }
            {  }
            false
            predicates.never,
            predicates.records.record { name = predicates.enum [ "sed" ], } {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "stiffness_ratio" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "stiffness_ratio_ageing" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "stiffness_ratio_cyclic" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "volume_adjustment" ], }
            {  }
            false
            predicates.never,
            predicates.records.record
            { name = predicates.enum [ "wrinkling" ], }
            {  }
            false
            predicates.never
          ],
          predicates.records.record { name = predicates.isType '"String", } {  }
          true
          predicates.always
        ]
      ]),
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    List of output requests for the analysis.
    "%
    | optional,
  settings
    | {
      ced_integration
        | {
          steps
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.multipleOf 1,
              predicates.numbers.minimum 1
            ])
            | optional,
          type | std.enum.TagOrString | [| 'fixed |] | optional,
        }
        | optional,
      crack_plane_discretization
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.oneOf
          [
            predicates.records.record
            {
              nmesh = predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.multipleOf 1,
                    predicates.numbers.maximum 10,
                    predicates.numbers.minimum 1
                  ],
              type = predicates.allOf
                  [ predicates.isType '"String", predicates.enum [ "tri3d" ] ],
            }
            {  }
            false
            predicates.never,
            predicates.records.record
            {
              planes = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.items
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Number",
                          predicates.numbers.maximum 1
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Number",
                          predicates.numbers.maximum 1
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Number",
                          predicates.numbers.maximum 1
                        ]
                      ],
                      predicates.arrays.maxItems 3,
                      predicates.arrays.minItems 3
                    ]),
                    predicates.arrays.minItems 1
                  ],
              type = predicates.allOf
                  [ predicates.isType '"String", predicates.enum [ "user" ] ],
            }
            {  }
            false
            predicates.never
          ]
        ])
        | optional,
      history_subset
        | {
          labels
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | optional,
          materials
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | optional,
          type | std.enum.TagOrString | [| '"default" |] | optional,
        }
        | optional,
      microsphere_discretization
        | {
          nmesh
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.multipleOf 1,
              predicates.numbers.maximum 10,
              predicates.numbers.minimum 1
            ])
            | optional,
          type | std.enum.TagOrString | [| 'tri3d |] | optional,
        }
        | optional,
    }
    | doc m%"
    Settings that control different aspects of the analysis.
    "%
    | optional,
}