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
          AutoDiscover
            | doc m%"
            Settings to determine how Flow should stay abreast of ongoing changes to collections and schemas.
            "%
            = {
                addNewBindings
                  | Bool
                  | doc m%"
                  Automatically add new bindings discovered from the source.
                  "%
                  | optional,
                evolveIncompatibleCollections
                  | Bool
                  | doc m%"
                  Whether to automatically evolve collections and/or materialization bindings to handle changes to collections that would otherwise be incompatible with the existing catalog.
                  "%
                  | optional,
              },
          Capture
            | doc m%"
            Capture names are paths of Unicode letters, numbers, '-', '_', or '.'. Each path component is separated by a slash '/', and a name may not begin or end in a '/'.
            "%
            = predicates.contract_from_predicate definitions.predicate.Capture,
          CaptureBinding = {
                disable
                  | Bool
                  | doc m%"
                  Disabled bindings are inactive, and not validated. They can be used to represent discovered resources that are intentionally not being captured.
                  "%
                  | optional,
                resource | predicates.contract_from_predicate predicates.always,
                target | definitions.contract.Collection,
              },
          CaptureDef
            | doc m%"
            A Capture binds an external system and target (e.x., a SQL table or cloud storage bucket) from which data should be continuously captured, with a Flow collection into that captured data is ingested. Multiple Captures may be bound to a single collection, but only one capture may exist for a given endpoint and target.
            "%
            = {
                autoDiscover | definitions.contract.AutoDiscover | optional,
                bindings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.CaptureBinding
                  ]),
                endpoint | definitions.contract.CaptureEndpoint,
                interval
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.pattern "^\\d+(s|m|h)$"
                  ])
                  | doc m%"
                  Configured intervals are applicable only to connectors which are unable to continuously tail their source, and which instead produce a current quantity of output and then exit. Flow will start the connector again after the given interval of time has passed.
                  
                  Intervals are relative to the start of an invocation and not its completion. For example, if the interval is five minutes, and an invocation of the capture finishes after two minutes, then the next invocation will be started after three additional minutes.
                  "%
                  | optional,
                shards | definitions.contract.ShardTemplate | optional,
              },
          CaptureEndpoint
            | doc m%"
            An endpoint from which Flow will capture.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CaptureEndpoint,
          Collection
            | doc m%"
            Collection names are paths of Unicode letters, numbers, '-', '_', or '.'. Each path component is separated by a slash '/', and a name may not begin or end in a '/'.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Collection,
          CollectionDef
            | doc m%"
            Collection describes a set of related documents, where each adheres to a common schema and grouping key. Collections are append-only: once a document is added to a collection, it is never removed. However, it may be replaced or updated (either in whole, or in part) by a future document sharing its key. Each new document of a given key is "reduced" into existing documents of the key. By default, this reduction is achieved by completely replacing the previous document, but much richer reduction behaviors can be specified through the use of annotated reduction strategies of the collection schema.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CollectionDef,
          CompositeKey
            | doc m%"
            Ordered JSON-Pointers which define how a composite key may be extracted from a collection document.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CompositeKey,
          CompressionCodec
            | doc m%"
            A CompressionCodec may be applied to compress journal fragments before they're persisted to cloud stoage. The compression applied to a journal fragment is included in its filename, such as ".gz" for GZIP. A collection's compression may be changed at any time, and will affect newly-written journal fragments.
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'GZIP_OFFLOAD_DECOMPRESSION,
                  'SNAPPY,
                  'ZSTANDARD,
                  'GZIP,
                  'NONE
                |]
              ],
          ConnectorConfig
            | doc m%"
            Connector image and configuration specification.
            "%
            = {
                config | predicates.contract_from_predicate predicates.always,
                image | String,
                ..
              },
          Derivation
            | doc m%"
            Derive specifies how a collection is derived from other collections.
            "%
            = {
                shards | definitions.contract.ShardTemplate | optional,
                shuffleKeyTypes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.ShuffleType
                  ])
                  | doc m%"
                  Typically you omit this and Flow infers it from your transform shuffle keys. In some circumstances, Flow may require that you explicitly tell it of your shuffled key types.
                  "%
                  | optional,
                transforms
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.TransformDef
                  ]),
                using | definitions.contract.DeriveUsing,
              },
          DeriveUsing
            | doc m%"
            A derivation runtime implementation.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DeriveUsing,
          DeriveUsingSqlite = {
                migrations
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
                        predicates.strings.pattern "^[^ ]+$"
                      ],
                      predicates.isType '"String"
                    ])
                  ])
                  | doc m%"
                  Migrations may be provided as an inline string, or as a relative URL to a file containing the migration SQL.
                  "%
                  | optional,
              },
          DeriveUsingTypescript = {
                module
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern "^[^ ]+$"
                    ],
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  Module is either a relative URL of a TypeScript module file, or is an inline representation of a Typescript module. The module must have a exported Derivation variable which is an instance implementing the corresponding Derivation interface.
                  "%,
              },
          Field
            | doc m%"
            Field names a projection of a document location. They may include '/', but cannot begin or end with one. Many Fields are automatically inferred by Flow from a collection JSON Schema, and are the JSON Pointer of the document location with the leading '/' removed. User-provided Fields which act as a logical partitions are restricted to Unicode letters, numbers, '-', '_', or '.'
            "%
            = predicates.contract_from_predicate definitions.predicate.Field,
          FragmentTemplate
            | doc m%"
            A FragmentTemplate configures how journal fragment files are produced as part of a collection.
            "%
            = {
                compressionCodec
                  | definitions.contract.CompressionCodec
                  | optional,
                flushInterval
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.pattern "^\\d+(s|m|h)$"
                  ])
                  | doc m%"
                  into cloud storage. Intervals are converted into uniform time segments: 24h will "roll" all fragments at midnight UTC every day, 1h at the top of every hour, 15m a :00, :15, :30, :45 past the hour, and so on. If not set, then fragments are not flushed on time-based intervals.
                  "%
                  | optional,
                length
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.maximum 4096,
                    predicates.numbers.minimum 32
                  ])
                  | doc m%"
                  When a collection journal fragment reaches this threshold, it will be closed off and pushed to cloud storage. If not set, a default of 512MB is used.
                  "%
                  | optional,
                retention
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.pattern "^\\d+(s|m|h)$"
                  ])
                  | doc m%"
                  If not set, then fragments are retained indefinitely.
                  "%
                  | optional,
              },
          FullSource
            | doc m%"
            A source collection and details of how it's read.
            "%
            = {
                name | definitions.contract.Collection,
                notAfter
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Source collection documents published after this date-time are filtered. `notAfter` is *only* a filter. Updating its value will not cause Flow to re-process documents that have already been read. Optional. Default is to process all documents.
                  "%
                  | optional,
                notBefore
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  Source collection documents published before this date-time are filtered. `notBefore` is *only* a filter. Updating its value will not cause Flow to re-process documents that have already been read. Optional. Default is to process all documents.
                  "%
                  | optional,
                partitions | definitions.contract.PartitionSelector | optional,
              },
          JournalTemplate
            | doc m%"
            A JournalTemplate configures the journals which make up the physical partitions of a collection.
            "%
            = { fragments | definitions.contract.FragmentTemplate, },
          JsonPointer
            | doc m%"
            JSON Pointer which identifies a location in a document.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.JsonPointer,
          LocalConfig
            | doc m%"
            Local command and its configuration.
            "%
            = {
                command
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                config | predicates.contract_from_predicate predicates.always,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | optional,
                protobuf | Bool | optional,
                ..
              },
          Materialization
            | doc m%"
            Materialization names are paths of Unicode letters, numbers, '-', '_', or '.'. Each path component is separated by a slash '/', and a name may not begin or end in a '/'.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Materialization,
          MaterializationBinding = {
                disable
                  | Bool
                  | doc m%"
                  Disabled bindings are inactive, and not validated.
                  "%
                  | optional,
                fields | definitions.contract.MaterializationFields | optional,
                "priority"
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  When all bindings are of equal priority, Flow processes documents according to their associated publishing time, as encoded in the document UUID.
                  
                  However, when one binding has a higher priority than others, then *all* ready documents are processed through the binding before *any* documents of other bindings are processed.
                  "%
                  | optional,
                resource | predicates.contract_from_predicate predicates.always,
                source | definitions.contract.Source,
              },
          MaterializationDef
            | doc m%"
            A Materialization binds a Flow collection with an external system & target (e.x, a SQL table) into which the collection is to be continuously materialized.
            "%
            = {
                bindings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.MaterializationBinding
                  ]),
                endpoint | definitions.contract.MaterializationEndpoint,
                shards | definitions.contract.ShardTemplate | optional,
                sourceCapture | definitions.contract.Capture | optional,
              },
          MaterializationEndpoint
            | doc m%"
            An Endpoint connector used for Flow materializations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.MaterializationEndpoint,
          MaterializationFields
            | doc m%"
            MaterializationFields defines a selection of projections to materialize, as well as optional per-projection, driver-specific configuration.
            "%
            = {
                exclude
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Field
                  ])
                  | doc m%"
                  This removes from recommended projections, where enabled.
                  "%
                  | optional,
                include
                  | {  .. }
                  | doc m%"
                  This supplements any recommended fields, where enabled. Values are passed through to the driver, e.x. for customization of the driver's schema generation or runtime behavior with respect to the field.
                  "%
                  | optional,
                recommended | Bool,
              },
          PartitionSelector
            | doc m%"
            Partition selectors identify a desired subset of the available logical partitions of a collection.
            "%
            = {
                exclude
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf predicates.always
                    ])
                  ])
                  | doc m%"
                  Partition field names and values which are excluded from the source collection. Any documents matching *any one* of the partition values will be excluded.
                  "%
                  | optional,
                include
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf predicates.always
                    ])
                  ])
                  | doc m%"
                  Partition field names and corresponding values which must be matched from the Source collection. Only documents having one of the specified values across all specified partition names will be matched. For example, source: [App, Web] region: [APAC] would mean only documents of 'App' or 'Web' source and also occurring in the 'APAC' region will be processed.
                  "%
                  | optional,
              },
          Projection
            | doc m%"
            Projections are named locations within a collection document which may be used for logical partitioning or directly exposed to databases into which collections are materialized.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Projection,
          RelativeUrl
            | doc m%"
            A URL identifying a resource, which may be a relative local path with respect to the current resource (i.e, ../path/to/flow.yaml), or may be an external absolute URL (i.e., http://example/flow.yaml).
            "%
            = predicates.contract_from_predicate
              definitions.predicate.RelativeUrl,
          Schema
            | doc m%"
            A schema is a draft 2020-12 JSON Schema which validates Flow documents. Schemas also provide annotations at document locations, such as reduction strategies for combining one document into another.
            
            Schemas may be defined inline to the catalog, or given as a relative or absolute URI. URIs may optionally include a JSON fragment pointer that locates a specific sub-schema therein.
            
            For example, "schemas/marketing.yaml#/$defs/campaign" would reference the schema at location {"$defs": {"campaign": ...}} within ./schemas/marketing.yaml.
            "%
            = predicates.contract_from_predicate definitions.predicate.Schema,
          ShardTemplate
            | doc m%"
            A ShardTemplate configures how shards process a catalog task.
            "%
            = {
                disable | Bool | optional,
                hotStandbys
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  Hot standbys of a shard actively replicate the shard's state to another machine, and are able to be quickly promoted to take over processing for the shard should its current primary fail. If not set, then no hot standbys are maintained. EXPERIMENTAL: this field MAY be removed.
                  "%
                  | optional,
                logLevel
                  | String
                  | doc m%"
                  Log levels may currently be "error", "warn", "info", "debug", or "trace". If not set, the effective log level is "info".
                  "%
                  | optional,
                maxTxnDuration
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.pattern "^\\d+(s|m|h)$"
                  ])
                  | doc m%"
                  This duration upper-bounds the amount of time during which a transaction may process documents before it must flush and commit. It may run for less time if there aren't additional ready documents for it to process. If not set, the maximum duration defaults to five minutes for materializations, and one second for captures and derivations. EXPERIMENTAL: this field MAY be removed.
                  "%
                  | optional,
                minTxnDuration
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.pattern "^\\d+(s|m|h)$"
                  ])
                  | doc m%"
                  This duration lower-bounds the amount of time during which a transaction must process documents before it must flush and commit. It may run for more time if additional documents are available. The default value is zero seconds. Larger values may result in more data reduction, at the cost of more latency. EXPERIMENTAL: this field MAY be removed.
                  "%
                  | optional,
                readChannelSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  Larger values are recommended for tasks having more than one shard split and long, bursty transaction durations. If not set, a reasonable default (currently 4,096) is used. EXPERIMENTAL: this field is LIKELY to be removed.
                  "%
                  | optional,
                ringBufferSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The ring buffer is a performance optimization only: catalog tasks will replay portions of journals as needed when messages aren't available in the buffer. It can remain small if upstream task transactions are small, but larger transactions will achieve better performance with a larger ring. If not set, a reasonable default (currently 65,536) is used. EXPERIMENTAL: this field is LIKELY to be removed.
                  "%
                  | optional,
              },
          Shuffle
            | doc m%"
            A Shuffle specifies how a shuffling key is to be extracted from collection documents.
            "%
            = predicates.contract_from_predicate definitions.predicate.Shuffle,
          ShuffleType
            | doc m%"
            Type of a shuffled key component.
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'string, 'integer, 'boolean |] ],
          Source
            | doc m%"
            A source collection and details of how it's read.
            "%
            = predicates.contract_from_predicate definitions.predicate.Source,
          Test
            | doc m%"
            Test names are paths of Unicode letters, numbers, '-', '_', or '.'. Each path component is separated by a slash '/', and a name may not begin or end in a '/'.
            "%
            = predicates.contract_from_predicate definitions.predicate.Test,
          TestDocuments
            | doc m%"
            A test step describes either an "ingest" of document fixtures into a collection, or a "verify" of expected document fixtures from a collection.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.TestDocuments,
          TestStep
            | doc m%"
            A test step describes either an "ingest" of document fixtures into a collection, or a "verify" of expected document fixtures from a collection.
            "%
            = predicates.contract_from_predicate definitions.predicate.TestStep,
          TestStepIngest
            | doc m%"
            An ingestion test step ingests document fixtures into the named collection.
            "%
            = {
                collection | definitions.contract.Collection,
                description | String | optional,
                documents
                  | definitions.contract.TestDocuments
                  | doc m%"
                  Each document must conform to the collection's schema.
                  "%,
              },
          TestStepVerify
            | doc m%"
            A verification test step verifies that the contents of the named collection match the expected fixtures, after fully processing all preceding ingestion test steps.
            "%
            = {
                collection | definitions.contract.Source,
                description | String | optional,
                documents
                  | definitions.contract.TestDocuments
                  | doc m%"
                  Each document may contain only a portion of the matched document's properties, and any properties present in the actual document but not in this document fixture are ignored. All other values must match or the test will fail.
                  "%,
              },
          Transform
            | doc m%"
            Transform names are Unicode letters, numbers, '-', '_', or '.'.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Transform,
          TransformDef
            | doc m%"
            A Transform reads and shuffles documents of a source collection, and processes each document through either one or both of a register "update" lambda and a derived document "publish" lambda.
            "%
            = {
                disable
                  | Bool
                  | doc m%"
                  Disabled transforms are completely ignored at runtime and are not validated.
                  "%
                  | optional,
                lambda
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  Lambdas may be provided inline, or as a relative URL to a file containing the lambda.
                  "%
                  | optional,
                name
                  | definitions.contract.Transform
                  | doc m%"
                  The names of transforms within a derivation must be unique and stable.
                  "%,
                "priority"
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  When all transforms are of equal priority, Flow processes documents according to their associated publishing time, as encoded in the document UUID.
                  
                  However, when one transform has a higher priority than others, then *all* ready documents are processed through the transform before *any* documents of other transforms are processed.
                  "%
                  | optional,
                readDelay
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"String", predicates.isType 'Null ],
                    predicates.strings.pattern "^\\d+(s|m|h)$"
                  ])
                  | doc m%"
                  Delays are applied as an adjustment to the UUID clock encoded within each document, which is then used to impose a relative ordering of all documents read by this derivation. This means that read delays are applied in a consistent way, even when back-filling over historical documents. When caught up and tailing the source collection, delays also "gate" documents such that they aren't processed until the current wall-time reflects the delay.
                  "%
                  | optional,
                shuffle | definitions.contract.Shuffle,
                source | definitions.contract.Source,
              },
        },
    predicate = {
          AutoDiscover
            | doc m%"
            Settings to determine how Flow should stay abreast of ongoing changes to collections and schemas.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addNewBindings = predicates.isType '"Bool",
                  evolveIncompatibleCollections = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          Capture
            | doc m%"
            Capture names are paths of Unicode letters, numbers, '-', '_', or '.'. Each path component is separated by a slash '/', and a name may not begin or end in a '/'.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$"
              ],
          CaptureBinding = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "resource", "target" ],
                predicates.records.record
                {
                  disable = predicates.isType '"Bool",
                  resource = predicates.always,
                  target = definitions.predicate.Collection,
                }
                {  }
                false
                predicates.never
              ],
          CaptureDef
            | doc m%"
            A Capture binds an external system and target (e.x., a SQL table or cloud storage bucket) from which data should be continuously captured, with a Flow collection into that captured data is ingested. Multiple Captures may be bound to a single collection, but only one capture may exist for a given endpoint and target.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "bindings", "endpoint" ],
                predicates.records.record
                {
                  autoDiscover = definitions.predicate.AutoDiscover,
                  bindings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.CaptureBinding
                      ],
                  endpoint = definitions.predicate.CaptureEndpoint,
                  interval = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.pattern "^\\d+(s|m|h)$"
                      ],
                  shards = definitions.predicate.ShardTemplate,
                }
                {  }
                false
                predicates.never
              ],
          CaptureEndpoint
            | doc m%"
            An endpoint from which Flow will capture.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "connector" ],
                  predicates.records.record
                  { connector = definitions.predicate.ConnectorConfig, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "local" ],
                  predicates.records.record
                  { local = definitions.predicate.LocalConfig, }
                  {  }
                  false
                  predicates.never
                ]
              ],
          Collection
            | doc m%"
            Collection names are paths of Unicode letters, numbers, '-', '_', or '.'. Each path component is separated by a slash '/', and a name may not begin or end in a '/'.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$"
              ],
          CollectionDef
            | doc m%"
            Collection describes a set of related documents, where each adheres to a common schema and grouping key. Collections are append-only: once a document is added to a collection, it is never removed. However, it may be replaced or updated (either in whole, or in part) by a future document sharing its key. Each new document of a given key is "reduced" into existing documents of the key. By default, this reduction is achieved by completely replacing the previous document, but much richer reduction behaviors can be specified through the use of annotated reduction strategies of the collection schema.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "schema" ],
                    predicates.records.record
                    {
                      readSchema = predicates.never,
                      writeSchema = predicates.never,
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "readSchema", "writeSchema" ],
                    predicates.records.record { schema = predicates.never, }
                    {  }
                    true
                    predicates.always
                  ]
                ],
                predicates.records.required [ "key" ],
                predicates.records.record
                {
                  derive = definitions.predicate.Derivation,
                  journals = definitions.predicate.JournalTemplate,
                  key = definitions.predicate.CompositeKey,
                  projections = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          "^([^/~]|(~[01]))+(/([^/~]|(~[01]))+)*$" =
                            definitions.predicate.Projection,
                        }
                        false
                        predicates.never
                      ],
                  readSchema = definitions.predicate.Schema,
                  schema = definitions.predicate.Schema,
                  writeSchema = definitions.predicate.Schema,
                }
                {  }
                false
                predicates.never
              ],
          CompositeKey
            | doc m%"
            Ordered JSON-Pointers which define how a composite key may be extracted from a collection document.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.JsonPointer
              ],
          CompressionCodec
            | doc m%"
            A CompressionCodec may be applied to compress journal fragments before they're persisted to cloud stoage. The compression applied to a journal fragment is included in its filename, such as ".gz" for GZIP. A collection's compression may be changed at any time, and will affect newly-written journal fragments.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "NONE",
                  "GZIP",
                  "ZSTANDARD",
                  "SNAPPY",
                  "GZIP_OFFLOAD_DECOMPRESSION"
                ]
              ],
          ConnectorConfig
            | doc m%"
            Connector image and configuration specification.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "image" ],
                predicates.records.record
                {
                  config = predicates.always,
                  image = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Derivation
            | doc m%"
            Derive specifies how a collection is derived from other collections.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "transforms", "using" ],
                predicates.records.record
                {
                  shards = definitions.predicate.ShardTemplate,
                  shuffleKeyTypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ShuffleType
                      ],
                  transforms = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TransformDef
                      ],
                  using = definitions.predicate.DeriveUsing,
                }
                {  }
                false
                predicates.never
              ],
          DeriveUsing
            | doc m%"
            A derivation runtime implementation.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "connector" ],
                  predicates.records.record
                  { connector = definitions.predicate.ConnectorConfig, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "sqlite" ],
                  predicates.records.record
                  { sqlite = definitions.predicate.DeriveUsingSqlite, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "typescript" ],
                  predicates.records.record
                  { typescript = definitions.predicate.DeriveUsingTypescript, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "local" ],
                  predicates.records.record
                  { local = definitions.predicate.LocalConfig, }
                  {  }
                  false
                  predicates.never
                ]
              ],
          DeriveUsingSqlite = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  migrations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "^[^ ]+$"
                          ],
                          predicates.isType '"String"
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          DeriveUsingTypescript = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "module" ],
                predicates.records.record
                {
                  module = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[^ ]+$"
                        ],
                        predicates.isType '"String"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Field
            | doc m%"
            Field names a projection of a document location. They may include '/', but cannot begin or end with one. Many Fields are automatically inferred by Flow from a collection JSON Schema, and are the JSON Pointer of the document location with the leading '/' removed. User-provided Fields which act as a logical partitions are restricted to Unicode letters, numbers, '-', '_', or '.'
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^([^/~]|(~[01]))+(/([^/~]|(~[01]))+)*$"
              ],
          FragmentTemplate
            | doc m%"
            A FragmentTemplate configures how journal fragment files are produced as part of a collection.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  compressionCodec = definitions.predicate.CompressionCodec,
                  flushInterval = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.pattern "^\\d+(s|m|h)$"
                      ],
                  length = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.maximum 4096,
                        predicates.numbers.minimum 32
                      ],
                  retention = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.pattern "^\\d+(s|m|h)$"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FullSource
            | doc m%"
            A source collection and details of how it's read.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = definitions.predicate.Collection,
                  notAfter = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  notBefore = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  partitions = definitions.predicate.PartitionSelector,
                }
                {  }
                false
                predicates.never
              ],
          JournalTemplate
            | doc m%"
            A JournalTemplate configures the journals which make up the physical partitions of a collection.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fragments" ],
                predicates.records.record
                { fragments = definitions.predicate.FragmentTemplate, }
                {  }
                false
                predicates.never
              ],
          JsonPointer
            | doc m%"
            JSON Pointer which identifies a location in a document.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^(/([^/~]|(~[01]))+)*$"
              ],
          LocalConfig
            | doc m%"
            Local command and its configuration.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "command", "config" ],
                predicates.records.record
                {
                  command = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  config = predicates.always,
                  env = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  protobuf = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          Materialization
            | doc m%"
            Materialization names are paths of Unicode letters, numbers, '-', '_', or '.'. Each path component is separated by a slash '/', and a name may not begin or end in a '/'.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$"
              ],
          MaterializationBinding = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "resource", "source" ],
                predicates.records.record
                {
                  disable = predicates.isType '"Bool",
                  fields = definitions.predicate.MaterializationFields,
                  "priority" = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  resource = predicates.always,
                  source = definitions.predicate.Source,
                }
                {  }
                false
                predicates.never
              ],
          MaterializationDef
            | doc m%"
            A Materialization binds a Flow collection with an external system & target (e.x, a SQL table) into which the collection is to be continuously materialized.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "bindings", "endpoint" ],
                predicates.records.record
                {
                  bindings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.MaterializationBinding
                      ],
                  endpoint = definitions.predicate.MaterializationEndpoint,
                  shards = definitions.predicate.ShardTemplate,
                  sourceCapture = definitions.predicate.Capture,
                }
                {  }
                false
                predicates.never
              ],
          MaterializationEndpoint
            | doc m%"
            An Endpoint connector used for Flow materializations.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "connector" ],
                  predicates.records.record
                  { connector = definitions.predicate.ConnectorConfig, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "local" ],
                  predicates.records.record
                  { local = definitions.predicate.LocalConfig, }
                  {  }
                  false
                  predicates.never
                ]
              ],
          MaterializationFields
            | doc m%"
            MaterializationFields defines a selection of projections to materialize, as well as optional per-projection, driver-specific configuration.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "recommended" ],
                predicates.records.record
                {
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Field
                      ],
                  include = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  recommended = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          PartitionSelector
            | doc m%"
            Partition selectors identify a desired subset of the available logical partitions of a collection.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  exclude = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf predicates.always
                        ])
                      ],
                  include = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf predicates.always
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Projection
            | doc m%"
            Projections are named locations within a collection document which may be used for logical partitioning or directly exposed to databases into which collections are materialized.
            "%
            = predicates.anyOf
              [
                definitions.predicate.JsonPointer,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "location" ],
                  predicates.records.record
                  {
                    location = definitions.predicate.JsonPointer,
                    partition = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          RelativeUrl
            | doc m%"
            A URL identifying a resource, which may be a relative local path with respect to the current resource (i.e, ../path/to/flow.yaml), or may be an external absolute URL (i.e., http://example/flow.yaml).
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[^ ]+$"
              ],
          Schema
            | doc m%"
            A schema is a draft 2020-12 JSON Schema which validates Flow documents. Schemas also provide annotations at document locations, such as reduction strategies for combining one document into another.
            
            Schemas may be defined inline to the catalog, or given as a relative or absolute URI. URIs may optionally include a JSON fragment pointer that locates a specific sub-schema therein.
            
            For example, "schemas/marketing.yaml#/$defs/campaign" would reference the schema at location {"$defs": {"campaign": ...}} within ./schemas/marketing.yaml.
            "%
            = predicates.always,
          ShardTemplate
            | doc m%"
            A ShardTemplate configures how shards process a catalog task.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  disable = predicates.isType '"Bool",
                  hotStandbys = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  logLevel = predicates.isType '"String",
                  maxTxnDuration = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.pattern "^\\d+(s|m|h)$"
                      ],
                  minTxnDuration = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.pattern "^\\d+(s|m|h)$"
                      ],
                  readChannelSize = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  ringBufferSize = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Shuffle
            | doc m%"
            A Shuffle specifies how a shuffling key is to be extracted from collection documents.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.enum [ "any" ] ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "key" ],
                  predicates.records.record
                  { key = definitions.predicate.CompositeKey, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "lambda" ],
                  predicates.records.record { lambda = predicates.always, } {  }
                  false
                  predicates.never
                ]
              ],
          ShuffleType
            | doc m%"
            Type of a shuffled key component.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "boolean", "integer", "string" ]
              ],
          Source
            | doc m%"
            A source collection and details of how it's read.
            "%
            = predicates.anyOf
              [
                definitions.predicate.FullSource,
                definitions.predicate.Collection
              ],
          Test
            | doc m%"
            Test names are paths of Unicode letters, numbers, '-', '_', or '.'. Each path component is separated by a slash '/', and a name may not begin or end in a '/'.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$"
              ],
          TestDocuments
            | doc m%"
            A test step describes either an "ingest" of document fixtures into a collection, or a "verify" of expected document fixtures from a collection.
            "%
            = predicates.always,
          TestStep
            | doc m%"
            A test step describes either an "ingest" of document fixtures into a collection, or a "verify" of expected document fixtures from a collection.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "ingest" ],
                  predicates.records.record
                  { ingest = definitions.predicate.TestStepIngest, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "verify" ],
                  predicates.records.record
                  { verify = definitions.predicate.TestStepVerify, }
                  {  }
                  false
                  predicates.never
                ]
              ],
          TestStepIngest
            | doc m%"
            An ingestion test step ingests document fixtures into the named collection.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "collection", "documents" ],
                predicates.records.record
                {
                  collection = definitions.predicate.Collection,
                  description = predicates.isType '"String",
                  documents = definitions.predicate.TestDocuments,
                }
                {  }
                false
                predicates.never
              ],
          TestStepVerify
            | doc m%"
            A verification test step verifies that the contents of the named collection match the expected fixtures, after fully processing all preceding ingestion test steps.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "collection", "documents" ],
                predicates.records.record
                {
                  collection = definitions.predicate.Source,
                  description = predicates.isType '"String",
                  documents = definitions.predicate.TestDocuments,
                }
                {  }
                false
                predicates.never
              ],
          Transform
            | doc m%"
            Transform names are Unicode letters, numbers, '-', '_', or '.'.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[\\p{Letter}\\p{Number}\\-_\\.]+$"
              ],
          TransformDef
            | doc m%"
            A Transform reads and shuffles documents of a source collection, and processes each document through either one or both of a register "update" lambda and a derived document "publish" lambda.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "shuffle", "source" ],
                predicates.records.record
                {
                  disable = predicates.isType '"Bool",
                  lambda = predicates.always,
                  name = definitions.predicate.Transform,
                  "priority" = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  readDelay = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                        predicates.strings.pattern "^\\d+(s|m|h)$"
                      ],
                  shuffle = definitions.predicate.Shuffle,
                  source = definitions.predicate.Source,
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

{
  "$schema" | String | optional,
  captures
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$" =
          definitions.predicate.CaptureDef,
      }
      false
      predicates.never
    ])
    | optional,
  collections
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$" =
          definitions.predicate.CollectionDef,
      }
      false
      predicates.never
    ])
    | optional,
  "import"
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.RelativeUrl
    ])
    | doc m%"
    By importing another Flow catalog source, its collections, schemas, and derivations are bundled into the publication context of this specification. Imports are relative or absolute URLs, relative to this specification's location.
    "%
    | optional,
  materializations
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$" =
          definitions.predicate.MaterializationDef,
      }
      false
      predicates.never
    ])
    | optional,
  tests
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$" =
          predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.TestStep
            ],
      }
      false
      predicates.never
    ])
    | optional,
}