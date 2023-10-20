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
          anti_features = predicates.contract_from_predicate
              definitions.predicate.anti_features,
          localized_string = predicates.contract_from_predicate
              definitions.predicate.localized_string,
          string_list = predicates.contract_from_predicate
              definitions.predicate.string_list,
          url = predicates.contract_from_predicate definitions.predicate.url,
        },
    predicate = {
          anti_features = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [
                      "Ads",
                      "ApplicationDebuggable",
                      "KnownVuln",
                      "NonFreeAdd",
                      "NonFreeAssets",
                      "NonFreeDep",
                      "NonFreeNet",
                      "NoSourceSince",
                      "NSFW",
                      "UpstreamNonFree",
                      "TetheredNet",
                      "Tracking"
                    ]
                  ]),
                  predicates.arrays.minItems 1,
                  predicates.arrays.uniqueItems
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^(Ads|Tracking|ApplicationDebuggable|KnownVuln|NonFreeAdd|NonFreeAssets|NonFreeDep|NonFreeNet|NoSourceSince|NSFW|UpstreamNonFree|Tracking)$" =
                      definitions.predicate.localized_string,
                  }
                  false
                  predicates.never
                ]
              ],
          localized_string = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-z]{2,3}(-([A-Z][a-zA-Z]+|\\d+|[a-z]+))*$" =
                    predicates.isType '"String",
                }
                false
                predicates.never
              ],
          string_list = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          url = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^https?://.*$"
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.allOf
  [
    predicates.anyOf
    [
      predicates.allOf
      [
        predicates.records.required [ "Repo", "RepoType", "SourceCode" ],
        predicates.records.record {  } {  } true predicates.always
      ],
      predicates.allOf
      [
        predicates.records.required [ "NoSourceSince" ],
        predicates.records.record {  } {  } true predicates.always
      ]
    ],
    predicates.ifThenElse
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.records.required [ "ArchivePolicy" ],
        predicates.records.record
        { ArchivePolicy = predicates.const "0 versions", }
        {  }
        true
        predicates.always
      ],
      predicates.allOf
      [
        predicates.records.required [ "NoSourceSince" ],
        predicates.records.record {  } {  } true predicates.always
      ]
    ])
    (predicates.records.record
    {
      AutoUpdateMode = predicates.const "None",
      UpdateCheckMode = predicates.const "None",
    }
    {  }
    true
    predicates.always)
    predicates.always,
    predicates.ifThenElse
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.records.required [ "Binaries" ],
        predicates.records.record {  } {  } true predicates.always
      ],
      predicates.allOf
      [
        predicates.records.required [ "Builds" ],
        predicates.records.record
        {
          Builds = predicates.arrays.contains
              (predicates.allOf
              [
                predicates.records.required [ "binary" ],
                predicates.records.record {  } {  } true predicates.always
              ]),
        }
        {  }
        true
        predicates.always
      ]
    ])
    (predicates.allOf
    [
      predicates.records.required [ "AllowedAPKSigningKeys" ],
      predicates.records.record {  } {  } true predicates.always
    ])
    predicates.always,
    predicates.ifThenElse
    (predicates.records.record
    { UpdateCheckMode = predicates.strings.pattern "^Tags", }
    {  }
    true
    predicates.always)
    (predicates.records.record
    {
      AutoUpdateMode = predicates.allOf
          [
            predicates.isType '"String",
            predicates.strings.pattern "^(None|Version( \\+.+)?)$"
          ],
    }
    {  }
    true
    predicates.always)
    predicates.always
  ],
  predicates.records.required [ "Builds", "Categories", "License" ],
  predicates.records.record
  {
    AllowedAPKSigningKeys = predicates.anyOf
        [
          predicates.allOf
          [
            predicates.isType '"String",
            predicates.strings.pattern "^[0-9a-f]{64}$"
          ],
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf
            (predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern "^[0-9a-f]{64}$"
            ])
          ]
        ],
    AntiFeatures = definitions.predicate.anti_features,
    ArchivePolicy = predicates.isType 'Integer,
    AuthorEmail = predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.pattern
          "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        ],
    AuthorName = predicates.isType '"String",
    AuthorWebSite = definitions.predicate.url,
    AutoName = predicates.isType '"String",
    AutoUpdateMode = predicates.allOf
        [
          predicates.isType '"String",
          predicates.anyOf
          [
            predicates.enum [ "None", "Version" ],
            predicates.strings.pattern "^Version( \\+.+)? [^+].+"
          ]
        ],
    Binaries = definitions.predicate.url,
    Bitcoin = predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.pattern "^(bc1|[13])[a-zA-HJ-NP-Z0-9]{25,39}$"
        ],
    Builds = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "versionCode", "versionName" ],
            predicates.records.record
            {
              androidupdate = predicates.anyOf
                  [
                    predicates.const "auto",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ],
              antcommands = definitions.predicate.string_list,
              antifeatures = definitions.predicate.anti_features,
              binary = definitions.predicate.url,
              build = definitions.predicate.string_list,
              buildjni = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "yes", "no" ]
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ],
              commit = predicates.isType '"String",
              disable = predicates.isType '"String",
              encoding = predicates.isType '"String",
              extlibs = definitions.predicate.string_list,
              forcevercode = predicates.const true,
              forceversion = predicates.const true,
              gradle = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.const "yes"),
                      predicates.arrays.maxItems 1
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ],
              gradleprops = definitions.predicate.string_list,
              init = definitions.predicate.string_list,
              maven = predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "yes", "yes@" ]
                    ]
                  ],
              ndk = predicates.isType '"String",
              novcheck = predicates.const true,
              oldsdkloc = predicates.const true,
              output = predicates.isType '"String",
              patch = definitions.predicate.string_list,
              postbuild = definitions.predicate.string_list,
              preassemble = definitions.predicate.string_list,
              prebuild = definitions.predicate.string_list,
              rm = definitions.predicate.string_list,
              scandelete = definitions.predicate.string_list,
              scanignore = definitions.predicate.string_list,
              srclibs = definitions.predicate.string_list,
              subdir = predicates.isType '"String",
              submodules = predicates.const true,
              sudo = definitions.predicate.string_list,
              target = predicates.isType '"String",
              timeout = predicates.isType 'Integer,
              versionCode = predicates.isType 'Integer,
              versionName = predicates.isType '"String",
            }
            {  }
            false
            predicates.never
          ]),
          predicates.arrays.minItems 1,
          predicates.arrays.uniqueItems
        ],
    Categories = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType '"String",
            predicates.enum
            [
              "Connectivity",
              "Development",
              "Games",
              "Graphics",
              "Internet",
              "Money",
              "Multimedia",
              "Navigation",
              "Phone & SMS",
              "Reading",
              "Science & Education",
              "Security",
              "Sports & Health",
              "System",
              "Theming",
              "Time",
              "Writing"
            ]
          ]),
          predicates.arrays.minItems 1,
          predicates.arrays.uniqueItems
        ],
    Changelog = definitions.predicate.url,
    CurrentVersion = predicates.isType '"String",
    CurrentVersionCode = predicates.isType 'Integer,
    Description = predicates.allOf
        [ predicates.isType '"String", predicates.strings.maxLength 4000 ],
    Disabled = predicates.isType '"String",
    Donate = definitions.predicate.url,
    FlattrID = predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.pattern "^[0-9a-z]+$"
        ],
    IssueTracker = definitions.predicate.url,
    Liberapay = predicates.isType '"String",
    License = predicates.allOf
        [
          predicates.isType '"String",
          predicates.enum
          [
            "0BSD",
            "AAL",
            "AFL-1.1",
            "AFL-1.2",
            "AFL-2.0",
            "AFL-2.1",
            "AFL-3.0",
            "AGPL-3.0-only",
            "AGPL-3.0-or-later",
            "APL-1.0",
            "APSL-1.0",
            "APSL-1.1",
            "APSL-1.2",
            "APSL-2.0",
            "Apache-1.0",
            "Apache-1.1",
            "Apache-2.0",
            "Artistic-1.0",
            "Artistic-1.0-Perl",
            "Artistic-1.0-cl8",
            "Artistic-2.0",
            "Beerware",
            "BSD-1-Clause",
            "BSD-2-Clause",
            "BSD-2-Clause-FreeBSD",
            "BSD-2-Clause-Patent",
            "BSD-3-Clause",
            "BSD-3-Clause-Clear",
            "BSD-3-Clause-LBNL",
            "BSD-4-Clause",
            "BSL-1.0",
            "BitTorrent-1.1",
            "CAL-1.0",
            "CAL-1.0-Combined-Work-Exception",
            "CATOSL-1.1",
            "CC-BY-4.0",
            "CC-BY-SA-4.0",
            "CC0-1.0",
            "CDDL-1.0",
            "CECILL-2.0",
            "CECILL-2.1",
            "CECILL-B",
            "CECILL-C",
            "CNRI-Python",
            "CPAL-1.0",
            "CPL-1.0",
            "CUA-OPL-1.0",
            "ClArtistic",
            "Condor-1.1",
            "ECL-1.0",
            "ECL-2.0",
            "EFL-1.0",
            "EFL-2.0",
            "EPL-1.0",
            "EPL-2.0",
            "EUDatagrid",
            "EUPL-1.1",
            "EUPL-1.2",
            "Entessa",
            "FSFAP",
            "FTL",
            "Fair",
            "Frameworx-1.0",
            "GFDL-1.1-only",
            "GFDL-1.1-or-later",
            "GFDL-1.2-only",
            "GFDL-1.2-or-later",
            "GFDL-1.3-only",
            "GFDL-1.3-or-later",
            "GPL-2.0-only",
            "GPL-2.0-or-later",
            "GPL-3.0-only",
            "GPL-3.0-or-later",
            "HPND",
            "IJG",
            "IPA",
            "IPL-1.0",
            "ISC",
            "Imlib2",
            "Intel",
            "LGPL-2.0-only",
            "LGPL-2.0-or-later",
            "LGPL-2.1-only",
            "LGPL-2.1-or-later",
            "LGPL-3.0-only",
            "LGPL-3.0-or-later",
            "LPL-1.0",
            "LPL-1.02",
            "LPPL-1.2",
            "LPPL-1.3a",
            "LPPL-1.3c",
            "LiLiQ-P-1.1",
            "LiLiQ-R-1.1",
            "LiLiQ-Rplus-1.1",
            "MIT",
            "MIT-0",
            "MIT-CMU",
            "MPL-1.0",
            "MPL-1.1",
            "MPL-2.0",
            "MPL-2.0-no-copyleft-exception",
            "MS-PL",
            "MS-RL",
            "MirOS",
            "Motosoto",
            "MulanPSL-2.0",
            "Multics",
            "NASA-1.3",
            "NCSA",
            "NGPL",
            "NOSL",
            "NPL-1.0",
            "NPL-1.1",
            "NPOSL-3.0",
            "NTP",
            "Naumen",
            "Nokia",
            "OCLC-2.0",
            "ODbL-1.0",
            "OFL-1.0",
            "OFL-1.1",
            "OFL-1.1-RFN",
            "OFL-1.1-no-RFN",
            "OGTSL",
            "OLDAP-2.3",
            "OLDAP-2.7",
            "OLDAP-2.8",
            "OSET-PL-2.1",
            "OSL-1.0",
            "OSL-1.1",
            "OSL-2.0",
            "OSL-2.1",
            "OSL-3.0",
            "OpenSSL",
            "PHP-3.0",
            "PHP-3.01",
            "PostgreSQL",
            "Python-2.0",
            "QPL-1.0",
            "RPL-1.1",
            "RPL-1.5",
            "RPSL-1.0",
            "RSCPL",
            "Ruby",
            "SGI-B-2.0",
            "SISSL",
            "SMLNJ",
            "SPL-1.0",
            "SimPL-2.0",
            "Sleepycat",
            "UCL-1.0",
            "UPL-1.0",
            "Unicode-DFS-2016",
            "Unlicense",
            "VSL-1.0",
            "Vim",
            "W3C",
            "WTFPL",
            "Watcom-1.0",
            "X11",
            "XFree86-1.1",
            "Xnet",
            "XSkat",
            "YPL-1.1",
            "ZPL-2.0",
            "ZPL-2.1",
            "Zend-2.0",
            "Zimbra-1.3",
            "Zlib",
            "gnuplot",
            "iMatix",
            "xinetd",
            "PublicDomain"
          ]
        ],
    Litecoin = predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.pattern
          "^([LM3][a-km-zA-HJ-NP-Z1-9]{26,33}|ltc1[a-km-z0-9]{39})$"
        ],
    MaintainerNotes = predicates.allOf
        [ predicates.isType '"String", predicates.strings.maxLength 4000 ],
    Name = predicates.isType '"String",
    NoSourceSince = predicates.isType '"String",
    OpenCollective = predicates.isType '"String",
    Repo = predicates.isType '"String",
    RepoType = predicates.allOf
        [
          predicates.isType '"String",
          predicates.enum [ "git", "svn", "git-svn", "hg", "bzr", "srclib" ]
        ],
    RequiresRoot = predicates.isType '"Bool",
    SourceCode = definitions.predicate.url,
    Summary = predicates.allOf
        [ predicates.isType '"String", predicates.strings.maxLength 80 ],
    Translation = definitions.predicate.url,
    UpdateCheckData = predicates.isType '"String",
    UpdateCheckIgnore = predicates.isType '"String",
    UpdateCheckMode = predicates.allOf
        [
          predicates.isType '"String",
          predicates.anyOf
          [
            predicates.enum [ "None", "Static", "HTTP" ],
            predicates.strings.pattern "^RepoManifest(/.+)?$",
            predicates.strings.pattern "^Tags( .*)?$"
          ]
        ],
    UpdateCheckName = predicates.anyOf
        [
          predicates.isType '"String",
          predicates.allOf
          [ predicates.isType '"String", predicates.enum [ "Ignore" ] ]
        ],
    VercodeOperation = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String"),
          predicates.arrays.minItems 1,
          predicates.arrays.uniqueItems
        ],
    WebSite = definitions.predicate.url,
  }
  {  }
  false
  predicates.never
])