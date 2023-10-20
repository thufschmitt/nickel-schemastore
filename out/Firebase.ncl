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
          ExtensionsConfig = {  },
          FrameworksBackendOptions = {
                concurrency
                  | Number
                  | doc m%"
                  Number of requests a function can serve at once.
                  "%
                  | optional,
                cors
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  If true, allows CORS on requests to this function.
                  If this is a `string` or `RegExp`, allows requests from domains that match the provided value.
                  If this is an `Array`, allows requests from domains matching at least one entry of the array.
                  Defaults to true for {@link https.CallableFunction} and false otherwise.
                  "%
                  | optional,
                cpu
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "gcf_gen1" ]
                    ],
                    predicates.isType '"Number"
                  ])
                  | doc m%"
                  Fractional number of CPUs to allocate to a function.
                  "%
                  | optional,
                enforceAppCheck
                  | Bool
                  | doc m%"
                  Determines whether Firebase AppCheck is enforced. Defaults to false.
                  "%
                  | optional,
                ingressSettings
                  | std.enum.TagOrString
                  | [|
                    'ALLOW_INTERNAL_ONLY,
                    'ALLOW_INTERNAL_AND_GCLB,
                    'ALLOW_ALL
                  |]
                  | doc m%"
                  Ingress settings which control where this function can be called from.
                  "%
                  | optional,
                invoker
                  | std.enum.TagOrString
                  | [| 'public |]
                  | doc m%"
                  Invoker to set access control on https functions.
                  "%
                  | optional,
                labels
                  | definitions.contract."Record<string,string>"
                  | doc m%"
                  User labels to set on the function.
                  "%
                  | optional,
                maxInstances
                  | Number
                  | doc m%"
                  Max number of instances to be running in parallel.
                  "%
                  | optional,
                memory
                  | std.enum.TagOrString
                  | [|
                    '"8GiB",
                    '"512MiB",
                    '"4GiB",
                    '"32GiB",
                    '"2GiB",
                    '"256MiB",
                    '"1GiB",
                    '"16GiB",
                    '"128MiB"
                  |]
                  | doc m%"
                  Amount of memory to allocate to a function.
                  "%
                  | optional,
                minInstances
                  | Number
                  | doc m%"
                  Min number of actual instances to be running at a given time.
                  "%
                  | optional,
                omit
                  | Bool
                  | doc m%"
                  If true, do not deploy or emulate this function.
                  "%
                  | optional,
                preserveExternalChanges
                  | Bool
                  | doc m%"
                  Controls whether function configuration modified outside of function source is preserved. Defaults to false.
                  "%
                  | optional,
                region
                  | String
                  | doc m%"
                  HTTP functions can override global options and can specify multiple regions to deploy to.
                  "%
                  | optional,
                secrets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                serviceAccount
                  | String
                  | doc m%"
                  Specific service account for the function to run as.
                  "%
                  | optional,
                timeoutSeconds
                  | Number
                  | doc m%"
                  Timeout for the function in seconds, possible values are 0 to 540.
                  HTTPS functions can specify a higher timeout.
                  "%
                  | optional,
                vpcConnector
                  | String
                  | doc m%"
                  Connect cloud function to specified VPC connector.
                  "%
                  | optional,
                vpcConnectorEgressSettings
                  | std.enum.TagOrString
                  | [| 'PRIVATE_RANGES_ONLY, 'ALL_TRAFFIC |]
                  | doc m%"
                  Egress settings for VPC connector.
                  "%
                  | optional,
              },
          "Record<string,string>" = {  },
        },
    predicate = {
          ExtensionsConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } false predicates.never
              ],
          FrameworksBackendOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  concurrency = predicates.isType '"Number",
                  cors = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  cpu = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "gcf_gen1" ]
                        ],
                        predicates.isType '"Number"
                      ],
                  enforceAppCheck = predicates.isType '"Bool",
                  ingressSettings = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "ALLOW_ALL",
                          "ALLOW_INTERNAL_AND_GCLB",
                          "ALLOW_INTERNAL_ONLY"
                        ]
                      ],
                  invoker = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "public" ]
                      ],
                  labels = definitions.predicate."Record<string,string>",
                  maxInstances = predicates.isType '"Number",
                  memory = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "128MiB",
                          "16GiB",
                          "1GiB",
                          "256MiB",
                          "2GiB",
                          "32GiB",
                          "4GiB",
                          "512MiB",
                          "8GiB"
                        ]
                      ],
                  minInstances = predicates.isType '"Number",
                  omit = predicates.isType '"Bool",
                  preserveExternalChanges = predicates.isType '"Bool",
                  region = predicates.isType '"String",
                  secrets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  serviceAccount = predicates.isType '"String",
                  timeoutSeconds = predicates.isType '"Number",
                  vpcConnector = predicates.isType '"String",
                  vpcConnectorEgressSettings = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ALL_TRAFFIC", "PRIVATE_RANGES_ONLY" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "Record<string,string>" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } false predicates.never
              ],
        },
  }
in

{
  "$schema" | String | optional,
  database
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "rules" ],
        predicates.records.record
        {
          postdeploy = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.isType '"String"
              ],
          predeploy = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.isType '"String"
              ],
          rules = predicates.isType '"String",
        }
        {  }
        false
        predicates.never
      ],
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf
        (predicates.anyOf
        [
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "instance", "rules" ],
            predicates.records.record
            {
              instance = predicates.isType '"String",
              postdeploy = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ],
              predeploy = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ],
              rules = predicates.isType '"String",
              target = predicates.isType '"String",
            }
            {  }
            false
            predicates.never
          ],
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "rules", "target" ],
            predicates.records.record
            {
              instance = predicates.isType '"String",
              postdeploy = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ],
              predeploy = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ],
              rules = predicates.isType '"String",
              target = predicates.isType '"String",
            }
            {  }
            false
            predicates.never
          ]
        ])
      ]
    ])
    | optional,
  emulators
    | {
      auth | { host | String | optional, port | Number | optional, } | optional,
      database
        | { host | String | optional, port | Number | optional, }
        | optional,
      eventarc
        | { host | String | optional, port | Number | optional, }
        | optional,
      extensions | {  .. } | optional,
      firestore
        | {
          host | String | optional,
          port | Number | optional,
          websocketPort | Number | optional,
        }
        | optional,
      functions
        | { host | String | optional, port | Number | optional, }
        | optional,
      hosting
        | { host | String | optional, port | Number | optional, }
        | optional,
      hub | { host | String | optional, port | Number | optional, } | optional,
      logging
        | { host | String | optional, port | Number | optional, }
        | optional,
      pubsub
        | { host | String | optional, port | Number | optional, }
        | optional,
      singleProjectMode | Bool | optional,
      storage
        | { host | String | optional, port | Number | optional, }
        | optional,
      ui
        | {
          enabled | Bool | optional,
          host | String | optional,
          port
            | predicates.contract_from_predicate
            (predicates.anyOf
            [ predicates.isType '"String", predicates.isType '"Number" ])
            | optional,
        }
        | optional,
    }
    | optional,
  extensions | definitions.contract.ExtensionsConfig | optional,
  firestore
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          database = predicates.isType '"String",
          indexes = predicates.isType '"String",
          postdeploy = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.isType '"String"
              ],
          predeploy = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.isType '"String"
              ],
          rules = predicates.isType '"String",
        }
        {  }
        false
        predicates.never
      ],
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf
        (predicates.anyOf
        [
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "target" ],
            predicates.records.record
            {
              database = predicates.isType '"String",
              indexes = predicates.isType '"String",
              postdeploy = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ],
              predeploy = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ],
              rules = predicates.isType '"String",
              target = predicates.isType '"String",
            }
            {  }
            false
            predicates.never
          ],
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "database" ],
            predicates.records.record
            {
              database = predicates.isType '"String",
              indexes = predicates.isType '"String",
              postdeploy = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ],
              predeploy = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ],
              rules = predicates.isType '"String",
              target = predicates.isType '"String",
            }
            {  }
            false
            predicates.never
          ]
        ])
      ]
    ])
    | optional,
  functions
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          codebase = predicates.isType '"String",
          ignore = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          postdeploy = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.isType '"String"
              ],
          predeploy = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.isType '"String"
              ],
          runtime = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "nodejs10",
                  "nodejs12",
                  "nodejs14",
                  "nodejs16",
                  "nodejs18",
                  "nodejs20"
                ]
              ],
          source = predicates.isType '"String",
        }
        {  }
        false
        predicates.never
      ],
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            codebase = predicates.isType '"String",
            ignore = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
            postdeploy = predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ],
                  predicates.isType '"String"
                ],
            predeploy = predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ],
                  predicates.isType '"String"
                ],
            runtime = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum
                  [
                    "nodejs10",
                    "nodejs12",
                    "nodejs14",
                    "nodejs16",
                    "nodejs18",
                    "nodejs20"
                  ]
                ],
            source = predicates.isType '"String",
          }
          {  }
          false
          predicates.never
        ])
      ]
    ])
    | optional,
  hosting
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          appAssociation = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "AUTO", "NONE" ]
              ],
          cleanUrls = predicates.isType '"Bool",
          frameworksBackend = definitions.predicate.FrameworksBackendOptions,
          headers = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "glob", "headers" ],
                    predicates.records.record
                    {
                      glob = predicates.isType '"String",
                      headers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "key", "value" ],
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
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "headers", "source" ],
                    predicates.records.record
                    {
                      headers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "key", "value" ],
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
                      source = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "headers", "regex" ],
                    predicates.records.record
                    {
                      headers = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "key", "value" ],
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
                      regex = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ])
              ],
          i18n = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "root" ],
                predicates.records.record
                { root = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          ignore = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          postdeploy = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.isType '"String"
              ],
          predeploy = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.isType '"String"
              ],
          public = predicates.isType '"String",
          redirects = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "destination", "glob" ],
                    predicates.records.record
                    {
                      destination = predicates.isType '"String",
                      glob = predicates.isType '"String",
                      type = predicates.isType '"Number",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "destination", "source" ],
                    predicates.records.record
                    {
                      destination = predicates.isType '"String",
                      source = predicates.isType '"String",
                      type = predicates.isType '"Number",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "destination", "regex" ],
                    predicates.records.record
                    {
                      destination = predicates.isType '"String",
                      regex = predicates.isType '"String",
                      type = predicates.isType '"Number",
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ])
              ],
          rewrites = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "destination", "glob" ],
                    predicates.records.record
                    {
                      destination = predicates.isType '"String",
                      glob = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "function", "glob" ],
                    predicates.records.record
                    {
                      function = predicates.isType '"String",
                      glob = predicates.isType '"String",
                      region = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "function", "glob" ],
                    predicates.records.record
                    {
                      function = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "functionId" ],
                            predicates.records.record
                            {
                              functionId = predicates.isType '"String",
                              pinTag = predicates.isType '"Bool",
                              region = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      glob = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "glob", "run" ],
                    predicates.records.record
                    {
                      glob = predicates.isType '"String",
                      run = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "serviceId" ],
                            predicates.records.record
                            {
                              pinTag = predicates.isType '"Bool",
                              region = predicates.isType '"String",
                              serviceId = predicates.isType '"String",
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
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "dynamicLinks", "glob" ],
                    predicates.records.record
                    {
                      dynamicLinks = predicates.isType '"Bool",
                      glob = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "destination", "source" ],
                    predicates.records.record
                    {
                      destination = predicates.isType '"String",
                      source = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "function", "source" ],
                    predicates.records.record
                    {
                      function = predicates.isType '"String",
                      region = predicates.isType '"String",
                      source = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "function", "source" ],
                    predicates.records.record
                    {
                      function = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "functionId" ],
                            predicates.records.record
                            {
                              functionId = predicates.isType '"String",
                              pinTag = predicates.isType '"Bool",
                              region = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      source = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "run", "source" ],
                    predicates.records.record
                    {
                      run = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "serviceId" ],
                            predicates.records.record
                            {
                              pinTag = predicates.isType '"Bool",
                              region = predicates.isType '"String",
                              serviceId = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      source = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "dynamicLinks", "source" ],
                    predicates.records.record
                    {
                      dynamicLinks = predicates.isType '"Bool",
                      source = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "destination", "regex" ],
                    predicates.records.record
                    {
                      destination = predicates.isType '"String",
                      regex = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "function", "regex" ],
                    predicates.records.record
                    {
                      function = predicates.isType '"String",
                      regex = predicates.isType '"String",
                      region = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "function", "regex" ],
                    predicates.records.record
                    {
                      function = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "functionId" ],
                            predicates.records.record
                            {
                              functionId = predicates.isType '"String",
                              pinTag = predicates.isType '"Bool",
                              region = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                      regex = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "regex", "run" ],
                    predicates.records.record
                    {
                      regex = predicates.isType '"String",
                      run = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "serviceId" ],
                            predicates.records.record
                            {
                              pinTag = predicates.isType '"Bool",
                              region = predicates.isType '"String",
                              serviceId = predicates.isType '"String",
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
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "dynamicLinks", "regex" ],
                    predicates.records.record
                    {
                      dynamicLinks = predicates.isType '"Bool",
                      regex = predicates.isType '"String",
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ])
              ],
          site = predicates.isType '"String",
          source = predicates.isType '"String",
          target = predicates.isType '"String",
          trailingSlash = predicates.isType '"Bool",
        }
        {  }
        false
        predicates.never
      ],
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf
        (predicates.anyOf
        [
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "target" ],
            predicates.records.record
            {
              appAssociation = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "AUTO", "NONE" ]
                  ],
              cleanUrls = predicates.isType '"Bool",
              frameworksBackend =
                definitions.predicate.FrameworksBackendOptions,
              headers = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "glob", "headers" ],
                        predicates.records.record
                        {
                          glob = predicates.isType '"String",
                          headers = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "key", "value" ],
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
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "headers", "source" ],
                        predicates.records.record
                        {
                          headers = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "key", "value" ],
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
                          source = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "headers", "regex" ],
                        predicates.records.record
                        {
                          headers = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "key", "value" ],
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
                          regex = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ])
                  ],
              i18n = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "root" ],
                    predicates.records.record
                    { root = predicates.isType '"String", }
                    {  }
                    false
                    predicates.never
                  ],
              ignore = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ],
              postdeploy = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ],
              predeploy = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ],
              public = predicates.isType '"String",
              redirects = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "destination", "glob" ],
                        predicates.records.record
                        {
                          destination = predicates.isType '"String",
                          glob = predicates.isType '"String",
                          type = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "destination", "source" ],
                        predicates.records.record
                        {
                          destination = predicates.isType '"String",
                          source = predicates.isType '"String",
                          type = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "destination", "regex" ],
                        predicates.records.record
                        {
                          destination = predicates.isType '"String",
                          regex = predicates.isType '"String",
                          type = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ])
                  ],
              rewrites = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "destination", "glob" ],
                        predicates.records.record
                        {
                          destination = predicates.isType '"String",
                          glob = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "function", "glob" ],
                        predicates.records.record
                        {
                          function = predicates.isType '"String",
                          glob = predicates.isType '"String",
                          region = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "function", "glob" ],
                        predicates.records.record
                        {
                          function = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "functionId" ],
                                predicates.records.record
                                {
                                  functionId = predicates.isType '"String",
                                  pinTag = predicates.isType '"Bool",
                                  region = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          glob = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "glob", "run" ],
                        predicates.records.record
                        {
                          glob = predicates.isType '"String",
                          run = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "serviceId" ],
                                predicates.records.record
                                {
                                  pinTag = predicates.isType '"Bool",
                                  region = predicates.isType '"String",
                                  serviceId = predicates.isType '"String",
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
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "dynamicLinks", "glob" ],
                        predicates.records.record
                        {
                          dynamicLinks = predicates.isType '"Bool",
                          glob = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "destination", "source" ],
                        predicates.records.record
                        {
                          destination = predicates.isType '"String",
                          source = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "function", "source" ],
                        predicates.records.record
                        {
                          function = predicates.isType '"String",
                          region = predicates.isType '"String",
                          source = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "function", "source" ],
                        predicates.records.record
                        {
                          function = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "functionId" ],
                                predicates.records.record
                                {
                                  functionId = predicates.isType '"String",
                                  pinTag = predicates.isType '"Bool",
                                  region = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          source = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "run", "source" ],
                        predicates.records.record
                        {
                          run = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "serviceId" ],
                                predicates.records.record
                                {
                                  pinTag = predicates.isType '"Bool",
                                  region = predicates.isType '"String",
                                  serviceId = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          source = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [ "dynamicLinks", "source" ],
                        predicates.records.record
                        {
                          dynamicLinks = predicates.isType '"Bool",
                          source = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "destination", "regex" ],
                        predicates.records.record
                        {
                          destination = predicates.isType '"String",
                          regex = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "function", "regex" ],
                        predicates.records.record
                        {
                          function = predicates.isType '"String",
                          regex = predicates.isType '"String",
                          region = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "function", "regex" ],
                        predicates.records.record
                        {
                          function = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "functionId" ],
                                predicates.records.record
                                {
                                  functionId = predicates.isType '"String",
                                  pinTag = predicates.isType '"Bool",
                                  region = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          regex = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "regex", "run" ],
                        predicates.records.record
                        {
                          regex = predicates.isType '"String",
                          run = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "serviceId" ],
                                predicates.records.record
                                {
                                  pinTag = predicates.isType '"Bool",
                                  region = predicates.isType '"String",
                                  serviceId = predicates.isType '"String",
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
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "dynamicLinks", "regex" ],
                        predicates.records.record
                        {
                          dynamicLinks = predicates.isType '"Bool",
                          regex = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ])
                  ],
              site = predicates.isType '"String",
              source = predicates.isType '"String",
              target = predicates.isType '"String",
              trailingSlash = predicates.isType '"Bool",
            }
            {  }
            false
            predicates.never
          ],
          predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "site" ],
            predicates.records.record
            {
              appAssociation = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "AUTO", "NONE" ]
                  ],
              cleanUrls = predicates.isType '"Bool",
              frameworksBackend =
                definitions.predicate.FrameworksBackendOptions,
              headers = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "glob", "headers" ],
                        predicates.records.record
                        {
                          glob = predicates.isType '"String",
                          headers = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "key", "value" ],
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
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "headers", "source" ],
                        predicates.records.record
                        {
                          headers = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "key", "value" ],
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
                          source = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "headers", "regex" ],
                        predicates.records.record
                        {
                          headers = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "key", "value" ],
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
                          regex = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ])
                  ],
              i18n = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "root" ],
                    predicates.records.record
                    { root = predicates.isType '"String", }
                    {  }
                    false
                    predicates.never
                  ],
              ignore = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ],
              postdeploy = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ],
              predeploy = predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ],
              public = predicates.isType '"String",
              redirects = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "destination", "glob" ],
                        predicates.records.record
                        {
                          destination = predicates.isType '"String",
                          glob = predicates.isType '"String",
                          type = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "destination", "source" ],
                        predicates.records.record
                        {
                          destination = predicates.isType '"String",
                          source = predicates.isType '"String",
                          type = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "destination", "regex" ],
                        predicates.records.record
                        {
                          destination = predicates.isType '"String",
                          regex = predicates.isType '"String",
                          type = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ])
                  ],
              rewrites = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "destination", "glob" ],
                        predicates.records.record
                        {
                          destination = predicates.isType '"String",
                          glob = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "function", "glob" ],
                        predicates.records.record
                        {
                          function = predicates.isType '"String",
                          glob = predicates.isType '"String",
                          region = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "function", "glob" ],
                        predicates.records.record
                        {
                          function = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "functionId" ],
                                predicates.records.record
                                {
                                  functionId = predicates.isType '"String",
                                  pinTag = predicates.isType '"Bool",
                                  region = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          glob = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "glob", "run" ],
                        predicates.records.record
                        {
                          glob = predicates.isType '"String",
                          run = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "serviceId" ],
                                predicates.records.record
                                {
                                  pinTag = predicates.isType '"Bool",
                                  region = predicates.isType '"String",
                                  serviceId = predicates.isType '"String",
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
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "dynamicLinks", "glob" ],
                        predicates.records.record
                        {
                          dynamicLinks = predicates.isType '"Bool",
                          glob = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "destination", "source" ],
                        predicates.records.record
                        {
                          destination = predicates.isType '"String",
                          source = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "function", "source" ],
                        predicates.records.record
                        {
                          function = predicates.isType '"String",
                          region = predicates.isType '"String",
                          source = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "function", "source" ],
                        predicates.records.record
                        {
                          function = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "functionId" ],
                                predicates.records.record
                                {
                                  functionId = predicates.isType '"String",
                                  pinTag = predicates.isType '"Bool",
                                  region = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          source = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "run", "source" ],
                        predicates.records.record
                        {
                          run = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "serviceId" ],
                                predicates.records.record
                                {
                                  pinTag = predicates.isType '"Bool",
                                  region = predicates.isType '"String",
                                  serviceId = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          source = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [ "dynamicLinks", "source" ],
                        predicates.records.record
                        {
                          dynamicLinks = predicates.isType '"Bool",
                          source = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "destination", "regex" ],
                        predicates.records.record
                        {
                          destination = predicates.isType '"String",
                          regex = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "function", "regex" ],
                        predicates.records.record
                        {
                          function = predicates.isType '"String",
                          regex = predicates.isType '"String",
                          region = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "function", "regex" ],
                        predicates.records.record
                        {
                          function = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "functionId" ],
                                predicates.records.record
                                {
                                  functionId = predicates.isType '"String",
                                  pinTag = predicates.isType '"Bool",
                                  region = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          regex = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "regex", "run" ],
                        predicates.records.record
                        {
                          regex = predicates.isType '"String",
                          run = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "serviceId" ],
                                predicates.records.record
                                {
                                  pinTag = predicates.isType '"Bool",
                                  region = predicates.isType '"String",
                                  serviceId = predicates.isType '"String",
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
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "dynamicLinks", "regex" ],
                        predicates.records.record
                        {
                          dynamicLinks = predicates.isType '"Bool",
                          regex = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ])
                  ],
              site = predicates.isType '"String",
              source = predicates.isType '"String",
              target = predicates.isType '"String",
              trailingSlash = predicates.isType '"Bool",
            }
            {  }
            false
            predicates.never
          ]
        ])
      ]
    ])
    | optional,
  remoteconfig
    | {
      postdeploy
        | predicates.contract_from_predicate
        (predicates.anyOf
        [
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf (predicates.isType '"String")
          ],
          predicates.isType '"String"
        ])
        | optional,
      predeploy
        | predicates.contract_from_predicate
        (predicates.anyOf
        [
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf (predicates.isType '"String")
          ],
          predicates.isType '"String"
        ])
        | optional,
      template | String,
    }
    | optional,
  storage
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "rules" ],
        predicates.records.record
        {
          postdeploy = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.isType '"String"
              ],
          predeploy = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.isType '"String"
              ],
          rules = predicates.isType '"String",
          target = predicates.isType '"String",
        }
        {  }
        false
        predicates.never
      ],
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "bucket", "rules" ],
          predicates.records.record
          {
            bucket = predicates.isType '"String",
            postdeploy = predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ],
                  predicates.isType '"String"
                ],
            predeploy = predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ],
                  predicates.isType '"String"
                ],
            rules = predicates.isType '"String",
            target = predicates.isType '"String",
          }
          {  }
          false
          predicates.never
        ])
      ]
    ])
    | optional,
}