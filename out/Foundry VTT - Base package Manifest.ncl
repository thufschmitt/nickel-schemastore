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
          File
            | doc m%"
            Relative path to a file, case sensitive.
            "%
            = String,
          FileArray = predicates.contract_from_predicate
              definitions.predicate.FileArray,
          Flags
            | doc m%"
            Flag data.
            "%
            = {  .. },
          Identifier = predicates.contract_from_predicate
              definitions.predicate.Identifier,
          NonBlankString = predicates.contract_from_predicate
              definitions.predicate.NonBlankString,
          PackageCompatibility = {
                maximum
                  | definitions.contract.Version
                  | doc m%"
                  The module will not function for newer versions than this.
                  "%
                  | optional,
                minimum
                  | definitions.contract.Version
                  | doc m%"
                  The module will not function for versions earlier than this.
                  "%
                  | optional,
                verified
                  | definitions.contract.Version
                  | doc m%"
                  The module has been verified to be compatible up to this version.
                  "%
                  | optional,
              },
          PackageRelationship = {
                compatibility
                  | definitions.contract.PackageCompatibility
                  | doc m%"
                  As above, the compatibility of a dependency can be defined, ensuring that the dependency will not be installed if it does not meet the defined requirements.
                  "%
                  | optional,
                flags | definitions.contract.Flags | optional,
                id
                  | definitions.contract.Identifier
                  | doc m%"
                  Dependency entries require the id attribute. If only an id is provided, additional details about the module will be discovered from the Foundry VTT website listing.
                  "%,
                manifest
                  | definitions.contract.URL
                  | doc m%"
                  The manifest attribute provides an explicit manifest url to be used for downloading the dependency. If a manifest is not provided, the dependency package must exist in the Foundry website directory.
                  "%
                  | optional,
                reason
                  | definitions.contract.NonBlankString
                  | doc m%"
                  (undocumented, intended to be used by core Foundry in the future)
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'world, 'system, 'module |]
                  | doc m%"
                  The type attribute instructs FoundryVTT that the dependency may be on a different type of package. By default dependencies are assumed to be a module, so if you want to depend on a system or world you should be explicit.
                  "%
                  | optional,
              },
          URL
            | doc m%"
            A public URL.
            "%
            = predicates.contract_from_predicate definitions.predicate.URL,
          Version = predicates.contract_from_predicate
              definitions.predicate.Version,
        },
    predicate = {
          File
            | doc m%"
            Relative path to a file, case sensitive.
            "%
            = predicates.isType '"String",
          FileArray = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.File,
                predicates.arrays.uniqueItems
              ],
          Flags
            | doc m%"
            Flag data.
            "%
            = predicates.isType 'Record,
          Identifier = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[a-zA-Z0-9_-]+$"
              ],
          NonBlankString = predicates.allOf
              [ predicates.isType '"String", predicates.strings.pattern ".+" ],
          PackageCompatibility = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  maximum = definitions.predicate.Version,
                  minimum = definitions.predicate.Version,
                  verified = definitions.predicate.Version,
                }
                {  }
                false
                predicates.never
              ],
          PackageRelationship = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  compatibility = definitions.predicate.PackageCompatibility,
                  flags = definitions.predicate.Flags,
                  id = definitions.predicate.Identifier,
                  manifest = definitions.predicate.URL,
                  reason = definitions.predicate.NonBlankString,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "module", "system", "world" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          URL
            | doc m%"
            A public URL.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^https?://[^.\\s]+\\.[^.\\s]"
              ],
          Version = predicates.oneOf
              [ predicates.isType '"String", predicates.isType '"Number" ],
        },
  }
in

{
  author
    | predicates.contract_from_predicate definitions.predicate.NonBlankString
    | optional,
  authors
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
          discord = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^.+#\\d+$|^[a-z0-9._]+$"
              ],
          email = definitions.predicate.NonBlankString,
          flags = definitions.predicate.Flags,
          ko-fi = definitions.predicate.NonBlankString,
          name = definitions.predicate.NonBlankString,
          patreon = definitions.predicate.NonBlankString,
          reddit = definitions.predicate.NonBlankString,
          twitter = definitions.predicate.NonBlankString,
          url = definitions.predicate.URL,
        }
        {  }
        false
        predicates.never
      ]),
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    An array listing each author as an object that contains a name and potentially some contact details.
    "%
    | optional,
  bugs
    | definitions.contract.URL
    | doc m%"
    A publicly accessible URL where issues, suggestions, and bug reports may be filed.
    "%
    | optional,
  changelog
    | definitions.contract.URL
    | doc m%"
    A publicly accessible URL where update and release notes about the package may be found.
    "%
    | optional,
  compatibility
    | definitions.contract.PackageCompatibility
    | doc m%"
    The compatibility field is an object key for capturing the sub-fields which defines the limits of your package's compatibility based on Foundry Virtual Tabletop version.
    "%
    | optional,
  compatibleCoreVersion
    | predicates.contract_from_predicate definitions.predicate.Version
    | optional,
  conflicts
    | {  .. }
    | doc m%"
    (Manifest+ field)
    "%
    | optional,
  dependencies
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          id = definitions.predicate.Identifier,
          manifest = definitions.predicate.URL,
          name = definitions.predicate.Identifier,
          type = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "module", "system", "world" ]
              ],
        }
        {  }
        false
        predicates.never
      ])
    ])
    | optional,
  deprecated
    | {  .. }
    | doc m%"
    (Manifest+ field)
    "%
    | optional,
  description
    | String
    | doc m%"
    This field can contain a more lengthy description of the package. This text can be used to describe the functionality, list contact information, provide recommendations to contributors or testers, or any other information you feel is important to provide. This field can contain HTML to structure and style your text. For a system, this is also a good place to include any special licensing or attribution information that you need to distribute.
    "%,
  documentTypes
    | {  .. }
    | doc m%"
    (intended to be used by core Foundry in the future, see Module Sub-Types article)
    "%
    | optional,
  download
    | definitions.contract.URL
    | doc m%"
    A public URL that provides a zip archive of the package for the manifest version which points to it. The archive at this URL is retrieved during the installation or update process. If you are using version control for your package - it is recommended to manage download archives using the tags and releases features which are supported by most git repositories.
    "%
    | optional,
  esmodules
    | definitions.contract.FileArray
    | doc m%"
    The preferred method for including Javascript with your project. This field allows you to define an array of JS files which use the newer ES6 modules specification. As with scripts, this should be declared as an array. These files are identified separately in the manifest so they may be correctly loaded as a module rather than a script.
    "%
    | optional,
  exclusive
    | Bool
    | doc m%"
    (undocumented)
    "%
    | optional,
  flags | definitions.contract.Flags | optional,
  id
    | definitions.contract.Identifier
    | doc m%"
    Choose a unique package identifier. This must be an all lower-case string with no special characters and should use hyphens (not underscores) to separate multiple terms. This name must match exactly with the name of the parent directory within which you create the package.
    "%,
  includes
    | Array Dyn
    | doc m%"
    (Manifest+ field)
    "%
    | optional,
  languages
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "lang", "path" ],
        predicates.records.record
        {
          flags = definitions.predicate.Flags,
          lang = definitions.predicate.NonBlankString,
          module = definitions.predicate.Identifier,
          name = definitions.predicate.NonBlankString,
          path = definitions.predicate.File,
          system = definitions.predicate.Identifier,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    A list of localization files that Foundry can use to translate strings.
    "%
    | optional,
  license
    | predicates.contract_from_predicate
    (predicates.anyOf [ definitions.predicate.URL, definitions.predicate.File ])
    | doc m%"
    A path to a license file relative to the root package folder or a publicly accessible URL which contains the software license that applies to this package.
    "%
    | optional,
  manifest
    | definitions.contract.URL
    | doc m%"
    A stable URL that describes the latest release version of your manifest file. This URL is used for automatic system installation in the Foundry VTT setup screen. This manifest URL is consulted during the system/module update check to see whether a new version is available for download. It is important that this address remain stable, otherwise updates will not be detected.
    "%
    | optional,
  manifestPlusVersion
    | definitions.contract.Version
    | doc m%"
    (Manifest+ field)
    "%
    | optional,
  media
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          caption = definitions.predicate.NonBlankString,
          flags = definitions.predicate.Flags,
          loop = predicates.isType '"Bool",
          thumbnail = definitions.predicate.NonBlankString,
          type = definitions.predicate.NonBlankString,
          url = definitions.predicate.URL,
        }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    (undocumented, intended to be used by core Foundry in the future)
    "%
    | optional,
  minimumCoreVersion
    | predicates.contract_from_predicate definitions.predicate.Version
    | optional,
  name
    | predicates.contract_from_predicate definitions.predicate.Identifier
    | optional,
  packs
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "label", "name", "path", "type" ],
        predicates.records.record
        {
          entity = predicates.isType '"String",
          flags = definitions.predicate.Flags,
          label = definitions.predicate.NonBlankString,
          name = definitions.predicate.Identifier,
          path = definitions.predicate.File,
          private = predicates.isType '"Bool",
          system = predicates.oneOf
              [
                definitions.predicate.Identifier,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.Identifier
                ]
              ],
          type = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "Actor",
                  "Cards",
                  "Adventure",
                  "Item",
                  "Journal",
                  "JournalEntry",
                  "Macro",
                  "Playlist",
                  "RollTable",
                  "Table",
                  "Scene"
                ]
              ],
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Packages may come bundled with Compendium packs which include game content for various Document types. Compendium packs are defined as objects which have their own internal metadata structure.
    "%
    | optional,
  persistentStorage
    | Bool
    | doc m%"
    (undocumented, intended to be used by core Foundry in the future)
    "%
    | optional,
  protected
    | Bool
    | doc m%"
    (undocumented, used for premium packages)
    "%
    | optional,
  readme
    | predicates.contract_from_predicate
    (predicates.anyOf [ definitions.predicate.URL, definitions.predicate.File ])
    | doc m%"
    A path to a read-me file relative to the root package folder or a publicly accessible URL which contains instructions or information about the package.
    "%
    | optional,
  relationships
    | {
      conflicts
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.PackageRelationship
        ])
        | doc m%"
        (undocumented, intended to be used by core Foundry in the future)
        "%
        | optional,
      recommends
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.PackageRelationship
        ])
        | doc m%"
        (undocumented, intended to be used by core Foundry in the future)
        "%
        | optional,
      requires
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.PackageRelationship
        ])
        | doc m%"
        If a package has been installed with dependencies, but its dependencies are missing, it cannot be enabled.
        "%
        | optional,
      systems
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.PackageRelationship
        ])
        | doc m%"
        Will only allow the package to activated within Worlds which are running one of these systems and with a compatible version.
        "%
        | optional,
    }
    | doc m%"
    Packages can require modules, systems, or worlds be installed to allow their use. If a package has been installed with dependencies, but its dependencies are missing, it cannot be enabled.
    "%
    | optional,
  scripts
    | definitions.contract.FileArray
    | doc m%"
    A less common way of including Javascript with the increasing adoption of ESModules, this field allows you to define an array of JavaScript file paths which should be included whenever this package is being used. Each listed script path should be relative to the package root directory. All scripts which exist will be automatically included in the game session and loaded in their listed order.
    "%
    | optional,
  socket
    | Bool
    | doc m%"
    A package may request for a specialized socket namespace to be provided. If set to true, a socket event will be handled by the server with the name `system.${id}` (for a system) or `module.${id}` (for a module), and will transact a arbitrary data object by broadcasting that data to all connected clients. This allows the package to have a reserved channel for messaging events which are needed to coordinate actions across multiple connected clients.
    "%
    | optional,
  styles
    | definitions.contract.FileArray
    | doc m%"
    You can designate an array of CSS files which should be included in the game session whenever this package is used. Each listed stylesheet path should be relative to the package root directory. All stylesheets which exist will be automatically included in the game session and loaded in their listed order.
    "%
    | optional,
  system
    | predicates.contract_from_predicate (predicates.isType '"String")
    | optional,
  title
    | definitions.contract.NonBlankString
    | doc m%"
    Provide a human readable title for the package which is displayed as the visible name for the package in the Setup menu and elsewhere.
    "%,
  url
    | definitions.contract.URL
    | doc m%"
    A public URL that links to the repository or documentation pages for the package. This link will be displayed for users to allow them to find more information about your package. If your package is hosted in version control like GitHub or GitLab, linking to the repository in this field is a good choice.
    "%
    | optional,
  version
    | definitions.contract.Version
    | doc m%"
    The package version number can be a number or a string which denotes the version of your module/system/world. When making changes to your package, incrementing the version number in your manifest file is used to signal to users that an update is available. We discuss some supported options for versioning in the Introduction to Development article.
    "%,
  ..
}