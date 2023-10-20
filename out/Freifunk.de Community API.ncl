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
          address
            | doc m%"
            The address of the place you meet
            "%
            = {
                name
                  | String
                  | doc m%"
                  The name of the place you meet
                  "%
                  | optional,
                street
                  | String
                  | doc m%"
                  The street address of your meeting place
                  "%
                  | optional,
                zipcode
                  | String
                  | doc m%"
                  The zip code of your meeting place
                  "%
                  | optional,
              },
          city
            | doc m%"
            Name of the city
            "%
            = String,
          country
            | doc m%"
            Your country, list has been taken from http://countrylist.net/de/
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'ZW,
                  'ZM,
                  'YE,
                  'EH,
                  'WF,
                  'VI,
                  'VG,
                  'VN,
                  'VE,
                  'VU,
                  'UZ,
                  'UY,
                  'US,
                  'GB,
                  'AE,
                  'UA,
                  'UG,
                  'TV,
                  'TC,
                  'TM,
                  'TR,
                  'TN,
                  'TA,
                  'TT,
                  'TO,
                  'TK,
                  'TG,
                  'TL,
                  'TH,
                  'TZ,
                  'TJ,
                  'TW,
                  'SY,
                  'CH,
                  'SE,
                  'SZ,
                  'SJ,
                  'SR,
                  'SD,
                  'LK,
                  'ES,
                  'SU,
                  'GS,
                  'ZA,
                  'SO,
                  'SB,
                  'SI,
                  'SK,
                  'SG,
                  'SL,
                  'SC,
                  'CS,
                  'SN,
                  'NT,
                  'SA,
                  'ST,
                  'SM,
                  'WS,
                  'VC,
                  'PM,
                  'LC,
                  'KN,
                  'SH,
                  'RW,
                  'RU,
                  'RO,
                  'RE,
                  'QA,
                  'PR,
                  'PT,
                  'PL,
                  'PN,
                  'PH,
                  'PE,
                  'PY,
                  'PG,
                  'PA,
                  'PS,
                  'PW,
                  'PK,
                  'OM,
                  'NO,
                  'MP,
                  'NF,
                  'NU,
                  'NG,
                  'NE,
                  'NI,
                  'NZ,
                  'NC,
                  'AN,
                  'NL,
                  'NP,
                  'NR,
                  'NA,
                  'MM,
                  'MZ,
                  'MA,
                  'MS,
                  'ME,
                  'MN,
                  'MC,
                  'MD,
                  'FM,
                  'MX,
                  'YT,
                  'MU,
                  'MR,
                  'MQ,
                  'MH,
                  'MT,
                  'ML,
                  'MV,
                  'MY,
                  'MW,
                  'MG,
                  'MK,
                  'MO,
                  'LU,
                  'LT,
                  'LI,
                  'LY,
                  'LR,
                  'LS,
                  'LB,
                  'LV,
                  'LA,
                  'KG,
                  'KW,
                  'KR,
                  'KP,
                  'KI,
                  'KE,
                  'KZ,
                  'JO,
                  'JE,
                  'JP,
                  'JM,
                  'IT,
                  'IL,
                  'IM,
                  'IE,
                  'IQ,
                  'IR,
                  'ID,
                  'IN,
                  'IS,
                  'HU,
                  'HK,
                  'HN,
                  'VA,
                  'HM,
                  'HT,
                  'GY,
                  'GW,
                  'GN,
                  'GG,
                  'GT,
                  'GU,
                  'GP,
                  'GD,
                  'GL,
                  'GR,
                  'GI,
                  'GH,
                  'DE,
                  'GE,
                  'GM,
                  'GA,
                  'TF,
                  'PF,
                  'GF,
                  'FR,
                  'FI,
                  'FJ,
                  'FO,
                  'FK,
                  'EU,
                  'ET,
                  'EE,
                  'ER,
                  'GQ,
                  'SV,
                  'EG,
                  'EC,
                  'DO,
                  'DM,
                  'DJ,
                  'DG,
                  'DK,
                  'CZ,
                  'CY,
                  'CU,
                  'HR,
                  'CI,
                  'CR,
                  'CK,
                  'CD,
                  'CG,
                  'KM,
                  'CO,
                  'CC,
                  'CX,
                  'CN,
                  'CL,
                  'TD,
                  'CF,
                  'KY,
                  'CV,
                  'IC,
                  'CA,
                  'CM,
                  'KH,
                  'BI,
                  'BF,
                  'BG,
                  'BN,
                  'IO,
                  'BR,
                  'BV,
                  'BW,
                  'BA,
                  'BO,
                  'BT,
                  'BM,
                  'BJ,
                  'BZ,
                  'BE,
                  'BY,
                  'BB,
                  'BD,
                  'BH,
                  'BS,
                  'AZ,
                  'AT,
                  'AU,
                  'AC,
                  'AW,
                  'AM,
                  'AR,
                  'AG,
                  'AQ,
                  'AI,
                  'AO,
                  'AD,
                  'AS,
                  'DZ,
                  'AL,
                  'AX,
                  'AF,
                  '""
                |]
              ],
          email = predicates.contract_from_predicate
              definitions.predicate.email,
          geoCode = {
                lat
                  | Number
                  | doc m%"
                  Lattitude of your city in decimal degrees
                  "%,
                lon
                  | Number
                  | doc m%"
                  Longitude of your city in decimal degrees
                  "%,
              },
          phone = String,
          url = predicates.contract_from_predicate definitions.predicate.url,
        },
    predicate = {
          address
            | doc m%"
            The address of the place you meet
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  street = predicates.isType '"String",
                  zipcode = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          city
            | doc m%"
            Name of the city
            "%
            = predicates.isType '"String",
          country
            | doc m%"
            Your country, list has been taken from http://countrylist.net/de/
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "",
                  "AF",
                  "AX",
                  "AL",
                  "DZ",
                  "AS",
                  "AD",
                  "AO",
                  "AI",
                  "AQ",
                  "AG",
                  "AR",
                  "AM",
                  "AW",
                  "AC",
                  "AU",
                  "AT",
                  "AZ",
                  "BS",
                  "BH",
                  "BD",
                  "BB",
                  "BY",
                  "BE",
                  "BZ",
                  "BJ",
                  "BM",
                  "BT",
                  "BO",
                  "BA",
                  "BW",
                  "BV",
                  "BR",
                  "IO",
                  "BN",
                  "BG",
                  "BF",
                  "BI",
                  "KH",
                  "CM",
                  "CA",
                  "IC",
                  "CV",
                  "KY",
                  "CF",
                  "TD",
                  "CL",
                  "CN",
                  "CX",
                  "CC",
                  "CO",
                  "KM",
                  "CG",
                  "CD",
                  "CK",
                  "CR",
                  "CI",
                  "HR",
                  "CU",
                  "CY",
                  "CZ",
                  "DK",
                  "DG",
                  "DJ",
                  "DM",
                  "DO",
                  "EC",
                  "EG",
                  "SV",
                  "GQ",
                  "ER",
                  "EE",
                  "ET",
                  "EU",
                  "FK",
                  "FO",
                  "FJ",
                  "FI",
                  "FR",
                  "GF",
                  "PF",
                  "TF",
                  "GA",
                  "GM",
                  "GE",
                  "DE",
                  "GH",
                  "GI",
                  "GR",
                  "GL",
                  "GD",
                  "GP",
                  "GU",
                  "GT",
                  "GG",
                  "GN",
                  "GW",
                  "GY",
                  "HT",
                  "HM",
                  "VA",
                  "HN",
                  "HK",
                  "HU",
                  "IS",
                  "IN",
                  "ID",
                  "IR",
                  "IQ",
                  "IE",
                  "IM",
                  "IL",
                  "IT",
                  "JM",
                  "JP",
                  "JE",
                  "JO",
                  "KZ",
                  "KE",
                  "KI",
                  "KP",
                  "KR",
                  "KW",
                  "KG",
                  "LA",
                  "LV",
                  "LB",
                  "LS",
                  "LR",
                  "LY",
                  "LI",
                  "LT",
                  "LU",
                  "MO",
                  "MK",
                  "MG",
                  "MW",
                  "MY",
                  "MV",
                  "ML",
                  "MT",
                  "MH",
                  "MQ",
                  "MR",
                  "MU",
                  "YT",
                  "MX",
                  "FM",
                  "MD",
                  "MC",
                  "MN",
                  "ME",
                  "MS",
                  "MA",
                  "MZ",
                  "MM",
                  "NA",
                  "NR",
                  "NP",
                  "NL",
                  "AN",
                  "NC",
                  "NZ",
                  "NI",
                  "NE",
                  "NG",
                  "NU",
                  "NF",
                  "MP",
                  "NO",
                  "OM",
                  "PK",
                  "PW",
                  "PS",
                  "PA",
                  "PG",
                  "PY",
                  "PE",
                  "PH",
                  "PN",
                  "PL",
                  "PT",
                  "PR",
                  "QA",
                  "RE",
                  "RO",
                  "RU",
                  "RW",
                  "SH",
                  "KN",
                  "LC",
                  "PM",
                  "VC",
                  "WS",
                  "SM",
                  "ST",
                  "SA",
                  "NT",
                  "SN",
                  "CS",
                  "SC",
                  "SL",
                  "SG",
                  "SK",
                  "SI",
                  "SB",
                  "SO",
                  "ZA",
                  "GS",
                  "SU",
                  "ES",
                  "LK",
                  "SD",
                  "SR",
                  "SJ",
                  "SZ",
                  "SE",
                  "CH",
                  "SY",
                  "TW",
                  "TJ",
                  "TZ",
                  "TH",
                  "TL",
                  "TG",
                  "TK",
                  "TO",
                  "TT",
                  "TA",
                  "TN",
                  "TR",
                  "TM",
                  "TC",
                  "TV",
                  "UG",
                  "UA",
                  "AE",
                  "GB",
                  "US",
                  "UY",
                  "UZ",
                  "VU",
                  "VE",
                  "VN",
                  "VG",
                  "VI",
                  "WF",
                  "EH",
                  "YE",
                  "ZM",
                  "ZW"
                ]
              ],
          email = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^[A-Za-z0-9äöüÄÖUß_\\-\\.]+@[A-Za-z0-9äöüÄÖUß_\\-\\.]+\\.[A-Za-z]{2,}$"
              ],
          geoCode = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "lat", "lon" ],
                predicates.records.record
                {
                  lat = predicates.isType '"Number",
                  lon = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          phone = predicates.isType '"String",
          url = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(http|https)://[A-Za-z0-9ÄÖÜäöüß\\-_\\./]+"
              ],
        },
  }
in

{
  api
    | std.enum.TagOrString
    | [|
      '"0.5.2",
      '"0.5.1",
      '"0.5.0",
      '"0.4.16",
      '"0.4.15",
      '"0.4.14",
      '"0.4.13",
      '"0.4.12",
      '"0.4.11",
      '"0.4.10",
      '"0.4.9",
      '"0.4.8",
      '"0.4.7",
      '"0.4.6",
      '"0.4.5",
      '"0.4.4",
      '"0.4.3",
      '"0.4.2",
      '"0.4.1",
      '"0.4.0",
      '"0.3.2",
      '"0.3.1",
      '"0.3.0",
      '"0.2.1",
      '"0.2.0",
      '"0.1"
    |]
    | doc m%"
    The Freifunk Community API version you use
    "%
    | optional,
  contact
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.minProperties 1,
      predicates.records.record
      {
        email = definitions.predicate.email,
        facebook = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern
              "^(http|https)://([a-z\\-]*\\.|)facebook\\.com/[A-Za-z0-9ÄÖÜäöüß\\-_\\.]+"
            ],
        googleplus = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern
              "^(http|https)://plus\\.google\\.com/[A-Za-z0-9ÄÖÜäöüß\\+\\-\\./_]+"
            ],
        identica = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern
              "^(http|https)://([a-z\\-]*\\.|)identi\\.ca/[A-Za-z0-9ÄÖÜäöüß\\-_\\.]+"
            ],
        irc = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern "^(irc|ircs)://.*"
            ],
        jabber = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern
              "^[A-Za-z0-9äöüÄÖUß_\\-\\.]+@[A-Za-z0-9äöüÄÖUß_\\-\\.]+\\.[A-Za-z]{2,}(\\?join){0,1}$"
            ],
        mastodon = definitions.predicate.url,
        matrix = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern "^https://matrix\\.to/#/"
            ],
        ml = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern
              "^([A-Za-z0-9äöüÄÖUß_\\-\\.]+@[A-Za-z0-9äöüÄÖUß_\\-\\.]+\\.[A-Za-z]{2,}|(http|https)://[A-Za-z0-9ÄÖÜäöüß\\-_\\./]+)$"
            ],
        phone = definitions.predicate.phone,
        twitter = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern "^@[A-Za-z0-9_\\-]{1,15}"
            ],
        webform = definitions.predicate.url,
      }
      {  }
      false
      predicates.never
    ]),
  feeds
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
          category = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "blog", "forum", "ics", "podcast", "wiki", "others", "" ]
              ],
          name = predicates.isType '"String",
          type = predicates.isType '"String",
          url = definitions.predicate.url,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Feeds you provide your community
    "%
    | optional,
  location
    | {
      additionalLocations
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "city", "geoCode" ],
            predicates.records.record
            {
              address = definitions.predicate.address,
              city = definitions.predicate.city,
              country = definitions.predicate.country,
              geoCode = definitions.predicate.geoCode,
            }
            {  }
            false
            predicates.never
          ])
        ])
        | doc m%"
        Add some more locations where your community is active.
        "%
        | optional,
      address | definitions.contract.address | optional,
      city | definitions.contract.city,
      country | definitions.contract.country | optional,
      geoCode | definitions.contract.geoCode,
    }
    | doc m%"
    Position data such as a postal address or geographic coordinates
    "%,
  metacommunity
    | String
    | doc m%"
    The name of your metacommunity, if your local community belongs to a bigger one
    "%
    | optional,
  name
    | String
    | doc m%"
    The name of your community
    "%,
  nodeMaps
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
          interval = predicates.isType '"String",
          mapType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "", "geographical", "structural", "list/status" ]
              ],
          technicalType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "",
                  "ffmap",
                  "ffsomething",
                  "olsr-dot",
                  "openwifimap",
                  "netmon",
                  "libremap",
                  "nodewatcher",
                  "kml",
                  "nodelist",
                  "meshviewer",
                  "hopglass"
                ]
              ],
          url = definitions.predicate.url,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Maps of nodes or topology your community provides
    "%
    | optional,
  privacy
    | {
      policyurl
        | definitions.contract.url
        | doc m%"
        URL to your privacy policy description
        "%
        | optional,
    }
    | optional,
  services
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
          externalUri = predicates.isType '"String",
          internalUri = predicates.isType '"String",
          serviceDescription = predicates.isType '"String",
          serviceName = predicates.isType '"String",
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Services Provided by your community
    "%
    | optional,
  socialprojects
    | {
      contact
        | definitions.contract.email
        | doc m%"
        Please provide an email address to contact you on refugees and social projects
        "%
        | optional,
      number
        | predicates.contract_from_predicate (predicates.isType 'Integer)
        | doc m%"
        Number of projects supported by your Community
        "%
        | optional,
      website
        | definitions.contract.url
        | doc m%"
        A link to a web site where people can find an overview over your projects
        "%
        | optional,
    }
    | optional,
  state
    | {
      description
        | String
        | doc m%"
        Describe your community in a few lines
        "%
        | optional,
      focus
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType '"String",
            predicates.enum
            [
              "infrastructure/backbone",
              "Public Free Wifi",
              "Social Community Building",
              "Local services and content",
              "Free internet access"
            ]
          ])
        ])
        | doc m%"
        What's the focus of your local community?
        "%
        | optional,
      lastchange
        | String
        | doc m%"
        At what ISO 8601 timestamp has your community status lastly changed?
        "%,
      message
        | String
        | doc m%"
        A free-form string something like 'open for public', 'members only' or whatever you want it to be)
        "%
        | optional,
      nodes
        | predicates.contract_from_predicate
        (predicates.allOf
        [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
        | doc m%"
        Number of active nodes. This field is predestined to be updated regularly, please see sample solutions for <a href="https://github.com/Freifunk-Mainz/changeffapi" target="_blank">Gluon</a> or <a href="https://github.com/freifunk/common.api.freifunk.net/blob/master/contrib/ffapi-update-nodes.py" target="_blank">OLSR</a>
        "%
        | optional,
    }
    | doc m%"
    A collection of status-related data. Actual open/closed status, icons, last change timestamp etc.
    "%,
  support
    | {
      club
        | {
          board
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            Who are the board members of the club?
            "%
            | optional,
          city | definitions.contract.city | optional,
          email
            | definitions.contract.email
            | doc m%"
            Email address to contact the club (user@domain.com)
            "%
            | optional,
          name
            | String
            | doc m%"
            Name of the Club
            "%
            | optional,
          street
            | String
            | doc m%"
            Address - Street
            "%
            | optional,
          url
            | definitions.contract.url
            | doc m%"
            The club's website (http{s}://...)
            "%
            | optional,
          zip
            | String
            | doc m%"
            Address - ZIP
            "%
            | optional,
        }
        | optional,
      donations
        | {
          bankaccount
            | {
              BIC | String | optional,
              IBAN | String | optional,
              usage
                | String
                | doc m%"
                Please use this string as transfer-purpose to define a special usage of your donation.
                "%
                | optional,
            }
            | optional,
          campaigns
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
                  projectid = predicates.isType '"String",
                  provider = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "", "betterplace", "boost" ]
                      ],
                }
                {  }
                false
                predicates.never
              ])
            ])
            | optional,
        }
        | optional,
    }
    | optional,
  techDetails
    | {
      dns
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
              domainname = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[A-Za-z0-9äöüÄÖÜß\\.\\-\\_]{2,}$"
                  ],
              nameserver = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern "^[A-Za-z0-9äöüÄÖÜß_\\-\\.:]*$"
                    ])
                  ],
            }
            {  }
            false
            predicates.never
          ])
        ])
        | doc m%"
        DNS servers for domains used by your community
        "%
        | optional,
      firmware
        | {
          docs
            | definitions.contract.url
            | doc m%"
            Link to your firmware docs
            "%
            | optional,
          name
            | String
            | doc m%"
            Name of your firmware
            "%
            | optional,
          orgrestrictions
            | String
            | doc m%"
            Are there any organizational restrictions when using/installing your firmware?
            "%
            | optional,
          registrationurl
            | definitions.contract.url
            | doc m%"
            link to your website to request a new VPN key
            "%
            | optional,
          techrestrictions
            | String
            | doc m%"
            Are there any technical restrictions like hardware?
            "%
            | optional,
          url
            | definitions.contract.url
            | doc m%"
            Link to your firmware images
            "%
            | optional,
          vpnaccess
            | std.enum.TagOrString
            | [| '"else", 'webform, 'mail, 'fwimage, 'automatic, '"" |]
            | doc m%"
            How to access your VPN services
            "%
            | optional,
        }
        | optional,
      legals
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType '"String",
            predicates.enum
            [
              "nothing",
              "vpnnational",
              "vpninternational",
              "zappscript",
              "p2pblock",
              "splashpage",
              "termsconditions",
              "anonymizer",
              "institutions"
            ]
          ])
        ])
        | doc m%"
        What do you use to handle legal issues, e.g. the German Störerhaftung or restrictions in your country?
        "%
        | optional,
      networks
        | {
          ipv4
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
                  network = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/(\\d|[1-2]\\d|3[0-2]))$"
                      ],
                }
                {  }
                false
                predicates.never
              ])
            ])
            | doc m%"
            IPv4 networks used by your community
            "%
            | optional,
          ipv6
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
                  network = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^\\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:)))(%.+)?\\s*(\\/(\\d|\\d\\d|1[0-1]\\d|12[0-8]))$"
                      ],
                }
                {  }
                false
                predicates.never
              ])
            ])
            | doc m%"
            IPv6 networks used by your community
            "%
            | optional,
        }
        | doc m%"
        Networks used by your community
        "%
        | optional,
      routing
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType '"String",
            predicates.enum
            [
              "802.11s",
              "Babel",
              "batman-adv",
              "bmx6",
              "bmxd",
              "cjdns",
              "OLSR",
              "OLSRv2"
            ]
          ])
        ])
        | doc m%"
        Routing protocols used within your community
        "%
        | optional,
      updatemode
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType '"String",
            predicates.enum [ "none", "manual", "autoupdate" ]
          ])
        ])
        | doc m%"
        How do you deploy firmware updates?
        "%
        | optional,
    }
    | doc m%"
    Technical details of your community's Freifunk implementation
    "%,
  timeline
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
          description = predicates.isType '"String",
          timestamp = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^([0-9]{4})(?:-?W([0-9]+)(?:-?([0-9]+)D?)?|(?:-([0-9]+))?-([0-9]+))(?:[T ]([0-9]+):([0-9]+)(?::([0-9]+)(?:\\.([0-9]+))?)?)?(?:Z(-?[0-9]*))?"
              ],
          url = definitions.predicate.url,
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    These are lifetime events something like date of birth (and rebirth :-) of your community or other important milestones
    "%
    | optional,
  url
    | definitions.contract.url
    | doc m%"
    The main website (http{s}://...)
    "%,
}