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
          formatOptions
            | doc m%"
            Options to pass to gherkin-formatter, on how to format the output feature files.
            "%
            = {
                compact
                  | Bool
                  | doc m%"
                  Should empty lines be skipped, removed from the result?
                  "%
                  | optional,
                indentation
                  | String
                  | doc m%"
                  The indentation character(s).
                  "%
                  | optional,
                lineBreak
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  The line break character(s).
                  "%
                  | optional,
                oneTagPerLine
                  | Bool
                  | doc m%"
                  Should the tags be rendered separately, one by line?
                  "%
                  | optional,
                separateStepGroups
                  | Bool
                  | doc m%"
                  Should step groups (when-then) be separated?
                  "%
                  | optional,
              },
          gpcCustom
            | doc m%"
            A custom precompiler configuration, implemented either as an object or a PreCompiler class.
            "%
            = {
                configuration
                  | {  .. }
                  | doc m%"
                  The configuration object, if necessary, to be passed to the custom precompiler class.
                  "%
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ])
                  | doc m%"
                  Either the NPM package name to use, or the path to a JS file containing a PreCompiler.
                  "%,
              },
          gpcFilter
            | doc m%"
            The Filter precompiler is responsible for including or excluding the elements of a feature file in the result, which match a cucumber-tag-expression (e.g., has a given tag, does not have a given tag).
            "%
            = {
                configuration
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1,
                    predicates.strings.pattern "^.*@[^ ]+.*$"
                  ])
                  | doc m%"
                  Cucumber-tag-expression the filtering is based on
                  "%
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.const "gpc-filter"),
              },
          gpcForLoop
            | doc m%"
            A precompiler of GherKing to loop scenarios and scenario outlines to repeat them.
            "%
            = {
                configuration
                  | {
                    format
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.strings.pattern "^.*\\$\\{name\\}.*$",
                          predicates.strings.pattern "^.*\\$\\{i\\}.*$"
                        ],
                        predicates.strings.minLength 11
                      ])
                      | doc m%"
                      Format of the scenario or outline name after repeating. These tokens must be used: ${name}, ${i}.
                      "%
                      | optional,
                    limitToMaxValue
                      | Bool
                      | doc m%"
                      Whether higher iteration values than the max should be limited to the max or error should be thrown (false).
                      "%
                      | optional,
                    maxValue
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ])
                      | doc m%"
                      Maximum value of iteration.
                      "%
                      | optional,
                    tagName
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1,
                        predicates.strings.pattern "^[^ ]+$"
                      ])
                      | doc m%"
                      Tag used to mark scenarios or outlines to be repeated.
                      "%
                      | optional,
                  }
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.const "gpc-for-loop"),
              },
          gpcLicense
            | doc m%"
            This precompiler can be used to inject License statement into the feature files.
            "%
            = {
                configuration
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.records.required [ "licenseFile" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                      predicates.allOf
                      [
                        predicates.records.required [ "licenseText" ],
                        predicates.records.record {  } {  } true
                        predicates.always
                      ]
                    ],
                    predicates.records.record
                    {
                      licenseFile = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                      licenseText = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                      placement = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "start", "end" ]
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ]),
                path
                  | predicates.contract_from_predicate
                  (predicates.const "gpc-license"),
              },
          gpcMacro
            | doc m%"
            This precompiler is responsible for defining macros in feature files and then executing them.
            "%
            = {
                path
                  | predicates.contract_from_predicate
                  (predicates.const "gpc-macro"),
              },
          gpcRemoveComments
            | doc m%"
            This precompiler removes all or particular type of semantic comments from the feature file.
            "%
            = {
                configuration
                  | {
                    keep
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
                            "NONE",
                            "BEFORE_TAGS",
                            "PRECEDING",
                            "DESCRIPTION",
                            "TAG",
                            "ROW",
                            "DOC_STRING",
                            "STEP",
                            "START",
                            "END",
                            "ALL"
                          ]
                        ]),
                        predicates.arrays.minItems 1
                      ])
                      | doc m%"
                      To set which comment types should be kept, not removed.
                      "%
                      | optional,
                  }
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.const "gpc-remove-comments"),
              },
          gpcRemoveDuplicates
            | doc m%"
            The RemoveDuplicates precompiler is responsible for having only a reasonable amount of tags and/or rows in each feature file.
            "%
            = {
                configuration
                  | {
                    processRows
                      | Bool
                      | doc m%"
                      Should table rows be de-duplicated.
                      "%
                      | optional,
                    processTags
                      | Bool
                      | doc m%"
                      Should tags on the same level and from parent be de-duplicated.
                      "%
                      | optional,
                  }
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.const "gpc-remove-duplicates"),
              },
          gpcReplacer
            | doc m%"
            This GherKing Precompiler is responsible to replace keys in feature files with given values.
            "%
            = {
                configuration
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.minProperties 1,
                    predicates.records.record {  }
                    {
                      "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType 'Integer,
                            predicates.isType '"Bool",
                            predicates.isType '"Number"
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  The key-value pairs to replace in the feature files.
                  "%,
                path
                  | predicates.contract_from_predicate
                  (predicates.const "gpc-replacer"),
              },
          gpcScenarioNumbering
            | doc m%"
            The ScenarioNumbering precompiler is responsible for adding an index to all scenarios and scenario outlines.
            "%
            = {
                configuration
                  | {
                    format
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.strings.pattern "^.*\\$\\{name\\}.*$",
                          predicates.strings.pattern "^.*\\$\\{i\\}.*$"
                        ],
                        predicates.strings.minLength 11
                      ])
                      | doc m%"
                      The format, how index should be added to the name of the scenario/scenairo outline. Possible tokens: ${name} the original name, ${i} the index
                      "%
                      | optional,
                  }
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.const "gpc-scenario-numbering"),
              },
          gpcScenarioOutlineExpander
            | doc m%"
            This precompiler is responsible for converting Scenario Outlines to single Scenarios as Cucumber would do and adds the first column as a tag.
            "%
            = {
                configuration
                  | {
                    ignoreTag
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 2,
                        predicates.strings.pattern "^@[^ ]+$"
                      ])
                      | doc m%"
                      Tag used to mark scenarios to be ignored during expanding Scenario Outlines.
                      "%
                      | optional,
                  }
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.const "gpc-scenario-outline-expander"),
              },
          gpcScenarioOutlineNumbering
            | doc m%"
            This precompiler can add numbering column to Examples tables, and apply formatting to the name of the Scenario Outline.
            "%
            = {
                configuration
                  | {
                    addNumbering
                      | Bool
                      | doc m%"
                      Should an index be added to the name of the Scenario Outline.
                      "%
                      | optional,
                    addParameters
                      | Bool
                      | doc m%"
                      Should the example parameters be added to the name of the Scenario Outline.
                      "%
                      | optional,
                    numberingFormat
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.strings.pattern "^.*\\$\\{name\\}.*$",
                          predicates.strings.pattern "^.*\\$\\{i\\}.*$"
                        ],
                        predicates.strings.minLength 11
                      ])
                      | doc m%"
                      The format how the output Scenario Outline name should look with the index. Tokens to use: ${name}, ${i}
                      "%
                      | optional,
                    parameterDelimiter
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ])
                      | doc m%"
                      The delimiter to use when adding the parameters to the name of the Scenario Outline.
                      "%
                      | optional,
                    parameterFormat
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.strings.pattern "^.*\\$\\{name\\}.*$",
                          predicates.strings.pattern "^.*\\$\\{parameters\\}.*$"
                        ],
                        predicates.strings.minLength 20
                      ])
                      | doc m%"
                      The format how the output Scenario Outline name should look with the parameters. Tokens to use: ${name}, ${parameters}
                      "%
                      | optional,
                    strictNaming
                      | Bool
                      | doc m%"
                      Should the existing numbering field (num) block execution (true) or be used for numbering (false).
                      "%
                      | optional,
                  }
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.const "gpc-scenario-outline-numbering"),
              },
          gpcStepGroups
            | doc m%"
            The StepGroups precompiler is responsible for correcting the gherkin keywords of steps to make the tests more readable.
            "%
            = {
                path
                  | predicates.contract_from_predicate
                  (predicates.const "gpc-step-groups"),
              },
          gpcTestData
            | doc m%"
            This precompiler can load external data (JSON, CSV, or XLS/XLSX) into exmaples table.
            "%
            = {
                configuration
                  | {
                    appendData
                      | Bool
                      | doc m%"
                      Whether the loaded data should be appended to the existing rows of the examples table or overwritten.
                      "%
                      | optional,
                    defaultValue
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ])
                      | doc m%"
                      The default value to be added to the table if a column/value is not found.
                      "%
                      | optional,
                    ignoreKeyCase
                      | Bool
                      | doc m%"
                      Whether the casing of the example columns and data columns should be ignored.
                      "%
                      | optional,
                    keepTag
                      | Bool
                      | doc m%"
                      Whether the load-tags should be kept or removed.
                      "%
                      | optional,
                  }
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.const "gpc-test-data"),
              },
        },
    predicate = {
          formatOptions
            | doc m%"
            Options to pass to gherkin-formatter, on how to format the output feature files.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  compact = predicates.isType '"Bool",
                  indentation = predicates.isType '"String",
                  lineBreak = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  oneTagPerLine = predicates.isType '"Bool",
                  separateStepGroups = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          gpcCustom
            | doc m%"
            A custom precompiler configuration, implemented either as an object or a PreCompiler class.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  configuration = predicates.isType 'Record,
                  path = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          gpcFilter
            | doc m%"
            The Filter precompiler is responsible for including or excluding the elements of a feature file in the result, which match a cucumber-tag-expression (e.g., has a given tag, does not have a given tag).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  configuration = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1,
                        predicates.strings.pattern "^.*@[^ ]+.*$"
                      ],
                  path = predicates.const "gpc-filter",
                }
                {  }
                false
                predicates.never
              ],
          gpcForLoop
            | doc m%"
            A precompiler of GherKing to loop scenarios and scenario outlines to repeat them.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  configuration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          format = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.strings.pattern
                                  "^.*\\$\\{name\\}.*$",
                                  predicates.strings.pattern "^.*\\$\\{i\\}.*$"
                                ],
                                predicates.strings.minLength 11
                              ],
                          limitToMaxValue = predicates.isType '"Bool",
                          maxValue = predicates.allOf
                              [
                                predicates.isType 'Integer,
                                predicates.numbers.minimum 0
                              ],
                          tagName = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1,
                                predicates.strings.pattern "^[^ ]+$"
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  path = predicates.const "gpc-for-loop",
                }
                {  }
                false
                predicates.never
              ],
          gpcLicense
            | doc m%"
            This precompiler can be used to inject License statement into the feature files.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "configuration", "path" ],
                predicates.records.record
                {
                  configuration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.records.required [ "licenseFile" ],
                            predicates.records.record {  } {  } true
                            predicates.always
                          ],
                          predicates.allOf
                          [
                            predicates.records.required [ "licenseText" ],
                            predicates.records.record {  } {  } true
                            predicates.always
                          ]
                        ],
                        predicates.records.record
                        {
                          licenseFile = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                          licenseText = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                          placement = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "start", "end" ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  path = predicates.const "gpc-license",
                }
                {  }
                false
                predicates.never
              ],
          gpcMacro
            | doc m%"
            This precompiler is responsible for defining macros in feature files and then executing them.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                { path = predicates.const "gpc-macro", }
                {  }
                false
                predicates.never
              ],
          gpcRemoveComments
            | doc m%"
            This precompiler removes all or particular type of semantic comments from the feature file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  configuration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          keep = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [
                                    "NONE",
                                    "BEFORE_TAGS",
                                    "PRECEDING",
                                    "DESCRIPTION",
                                    "TAG",
                                    "ROW",
                                    "DOC_STRING",
                                    "STEP",
                                    "START",
                                    "END",
                                    "ALL"
                                  ]
                                ]),
                                predicates.arrays.minItems 1
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  path = predicates.const "gpc-remove-comments",
                }
                {  }
                false
                predicates.never
              ],
          gpcRemoveDuplicates
            | doc m%"
            The RemoveDuplicates precompiler is responsible for having only a reasonable amount of tags and/or rows in each feature file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  configuration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          processRows = predicates.isType '"Bool",
                          processTags = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  path = predicates.const "gpc-remove-duplicates",
                }
                {  }
                false
                predicates.never
              ],
          gpcReplacer
            | doc m%"
            This GherKing Precompiler is responsible to replace keys in feature files with given values.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "configuration", "path" ],
                predicates.records.record
                {
                  configuration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.minProperties 1,
                        predicates.records.record {  }
                        {
                          "^[a-zA-Z0-9_-]+$" = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType 'Integer,
                                predicates.isType '"Bool",
                                predicates.isType '"Number"
                              ],
                        }
                        true
                        predicates.always
                      ],
                  path = predicates.const "gpc-replacer",
                }
                {  }
                false
                predicates.never
              ],
          gpcScenarioNumbering
            | doc m%"
            The ScenarioNumbering precompiler is responsible for adding an index to all scenarios and scenario outlines.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  configuration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          format = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.strings.pattern
                                  "^.*\\$\\{name\\}.*$",
                                  predicates.strings.pattern "^.*\\$\\{i\\}.*$"
                                ],
                                predicates.strings.minLength 11
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  path = predicates.const "gpc-scenario-numbering",
                }
                {  }
                false
                predicates.never
              ],
          gpcScenarioOutlineExpander
            | doc m%"
            This precompiler is responsible for converting Scenario Outlines to single Scenarios as Cucumber would do and adds the first column as a tag.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  configuration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          ignoreTag = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 2,
                                predicates.strings.pattern "^@[^ ]+$"
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  path = predicates.const "gpc-scenario-outline-expander",
                }
                {  }
                false
                predicates.never
              ],
          gpcScenarioOutlineNumbering
            | doc m%"
            This precompiler can add numbering column to Examples tables, and apply formatting to the name of the Scenario Outline.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  configuration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          addNumbering = predicates.isType '"Bool",
                          addParameters = predicates.isType '"Bool",
                          numberingFormat = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.strings.pattern
                                  "^.*\\$\\{name\\}.*$",
                                  predicates.strings.pattern "^.*\\$\\{i\\}.*$"
                                ],
                                predicates.strings.minLength 11
                              ],
                          parameterDelimiter = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                          parameterFormat = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.strings.pattern
                                  "^.*\\$\\{name\\}.*$",
                                  predicates.strings.pattern
                                  "^.*\\$\\{parameters\\}.*$"
                                ],
                                predicates.strings.minLength 20
                              ],
                          strictNaming = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  path = predicates.const "gpc-scenario-outline-numbering",
                }
                {  }
                false
                predicates.never
              ],
          gpcStepGroups
            | doc m%"
            The StepGroups precompiler is responsible for correcting the gherkin keywords of steps to make the tests more readable.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                { path = predicates.const "gpc-step-groups", }
                {  }
                false
                predicates.never
              ],
          gpcTestData
            | doc m%"
            This precompiler can load external data (JSON, CSV, or XLS/XLSX) into exmaples table.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  configuration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          appendData = predicates.isType '"Bool",
                          defaultValue = predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ],
                          ignoreKeyCase = predicates.isType '"Bool",
                          keepTag = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  path = predicates.const "gpc-test-data",
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
  predicates.records.required [ "compilers" ],
  predicates.records.record
  {
    "$schema" = predicates.isType '"String",
    base = predicates.allOf
        [ predicates.isType '"String", predicates.strings.minLength 1 ],
    clean = predicates.isType '"Bool",
    compilers = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.anyOf
          [
            definitions.predicate.gpcCustom,
            definitions.predicate.gpcFilter,
            definitions.predicate.gpcForLoop,
            definitions.predicate.gpcLicense,
            definitions.predicate.gpcMacro,
            definitions.predicate.gpcRemoveComments,
            definitions.predicate.gpcRemoveDuplicates,
            definitions.predicate.gpcReplacer,
            definitions.predicate.gpcScenarioNumbering,
            definitions.predicate.gpcScenarioOutlineExpander,
            definitions.predicate.gpcScenarioOutlineNumbering,
            definitions.predicate.gpcStepGroups,
            definitions.predicate.gpcTestData
          ]),
          predicates.arrays.minItems 1
        ],
    destination = predicates.allOf
        [ predicates.isType '"String", predicates.strings.minLength 1 ],
    formatOptions = definitions.predicate.formatOptions,
    install = predicates.isType '"Bool",
    source = predicates.allOf
        [ predicates.isType '"String", predicates.strings.minLength 1 ],
    verbose = predicates.isType '"Bool",
  }
  {  }
  false
  predicates.never
])