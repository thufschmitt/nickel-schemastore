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
          expressionSyntax = predicates.contract_from_predicate
              definitions.predicate.expressionSyntax,
          outputs
            | doc m%"
            Output parameters allow you to declare data that an action sets. Actions that run later in a workflow can use the output data set in previously run actions. For example, if you had an action that performed the addition of two inputs (x + y = z), the action could output the sum (z) for other actions to use as an input.
            If you don't declare an output in your action metadata file, you can still set outputs and use them in a workflow.
            "%
            = predicates.contract_from_predicate definitions.predicate.outputs,
          outputs-composite
            | doc m%"
            Output parameters allow you to declare data that an action sets. Actions that run later in a workflow can use the output data set in previously run actions. For example, if you had an action that performed the addition of two inputs (x + y = z), the action could output the sum (z) for other actions to use as an input.
            If you don't declare an output in your action metadata file, you can still set outputs and use them in a workflow.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.outputs-composite,
          post-if
            | doc m%"
            Allows you to define conditions for the `post:` action execution. The `post:` action will only run if the conditions in `post-if` are met. If not set, then `post-if` defaults to `always()`.
            "%
            = String,
          pre-if
            | doc m%"
            Allows you to define conditions for the `pre:` action execution. The `pre:` action will only run if the conditions in `pre-if` are met. If not set, then `pre-if` defaults to `always()`. Note that the `step` context is unavailable, as no steps have run yet.
            "%
            = String,
          runs-composite
            | doc m%"
            Configures the path to the composite action, and the application used to execute the code.
            "%
            = {
                steps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.records.required [ "run", "shell" ],
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.allOf
                        [
                          predicates.records.required [ "uses" ],
                          predicates.records.record {  } {  } true
                          predicates.always
                        ]
                      ],
                      predicates.records.record
                      {
                        continue-on-error = predicates.oneOf
                            [
                              predicates.isType '"Bool",
                              definitions.predicate.expressionSyntax
                            ],
                        env = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record {  } {  } true
                              (predicates.isType '"String")
                            ],
                        id = predicates.isType '"String",
                        "if" = predicates.isType '"String",
                        name = predicates.isType '"String",
                        run = predicates.isType '"String",
                        shell = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.anyOf
                              [
                                predicates.always,
                                predicates.enum
                                [
                                  "bash",
                                  "pwsh",
                                  "python",
                                  "sh",
                                  "cmd",
                                  "powershell"
                                ]
                              ]
                            ],
                        uses = predicates.isType '"String",
                        with = predicates.isType 'Record,
                        working-directory = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                  ])
                  | doc m%"
                  The run steps that you plan to run in this action.
                  "%,
                using
                  | predicates.contract_from_predicate
                  (predicates.const "composite")
                  | doc m%"
                  To use a composite run steps action, set this to 'composite'.
                  "%,
              },
          runs-docker
            | doc m%"
            Configures the image used for the Docker action.
            "%
            = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of strings that define the inputs for a Docker container. Inputs can include hardcoded strings. GitHub passes the `args` to the container's `ENTRYPOINT` when the container starts up.
                  The `args` are used in place of the `CMD` instruction in a `Dockerfile`. If you use `CMD` in your `Dockerfile`, use the guidelines ordered by preference:
                  - Document required arguments in the action's README and omit them from the `CMD` instruction.
                  - Use defaults that allow using the action without specifying any `args`.
                  - If the action exposes a `--help` flag, or something similar, use that to make your action self-documenting.
                  "%
                  | optional,
                entrypoint
                  | String
                  | doc m%"
                  Overrides the Docker `ENTRYPOINT` in the `Dockerfile`, or sets it if one wasn't already specified. Use `entrypoint` when the `Dockerfile` does not specify an `ENTRYPOINT` or you want to override the `ENTRYPOINT` instruction. If you omit `entrypoint`, the commands you specify in the Docker `ENTRYPOINT` instruction will execute. The Docker `ENTRYPOINT instruction has a *shell* form and *exec* form. The Docker `ENTRYPOINT` documentation recommends using the *exec* form of the `ENTRYPOINT` instruction.
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number",
                        predicates.isType '"Bool"
                      ])
                    ],
                    definitions.predicate.stringContainingExpressionSyntax
                  ])
                  | doc m%"
                  Specifies a key/value map of environment variables to set in the container environment.
                  "%
                  | optional,
                image
                  | String
                  | doc m%"
                  The Docker image to use as the container to run the action. The value can be the Docker base image name, a local `Dockerfile` in your repository, or a public image in Docker Hub or another registry. To reference a `Dockerfile` local to your repository, use a path relative to your action metadata file. The `docker` application will execute this file.
                  "%,
                post-entrypoint
                  | String
                  | doc m%"
                  Allows you to run a cleanup script once the `runs.entrypoint` action has completed. GitHub Actions uses `docker run` to launch this action. Because GitHub Actions runs the script inside a new container using the same base image, the runtime state is different from the main `entrypoint` container. You can access any state you need in either the workspace, `HOME`, or as a `STATE_` variable. The `post-entrypoint:` action always runs by default but you can override this using `post-if`.
                  "%
                  | optional,
                post-if | definitions.contract.post-if | optional,
                pre-entrypoint
                  | String
                  | doc m%"
                  Allows you to run a script before the `entrypoint` action begins. For example, you can use `pre-entrypoint:` to run a prerequisite setup script. GitHub Actions uses `docker run` to launch this action, and runs the script inside a new container that uses the same base image. This means that the runtime state is different from the main `entrypoint` container, and any states you require must be accessed in either the workspace, `HOME`, or as a `STATE_` variable. The `pre-entrypoint:` action always runs by default but you can override this using `pre-if`.
                  "%
                  | optional,
                pre-if | definitions.contract.pre-if | optional,
                using
                  | predicates.contract_from_predicate
                  (predicates.const "docker")
                  | doc m%"
                  You must set this value to 'docker'.
                  "%,
              },
          runs-javascript
            | doc m%"
            Configures the path to the action's code and the application used to execute the code.
            "%
            = {
                main
                  | String
                  | doc m%"
                  The file that contains your action code. The application specified in `using` executes this file.
                  "%,
                post
                  | String
                  | doc m%"
                  Allows you to run a script at the end of a job, once the `main:` action has completed. For example, you can use `post:` to terminate certain processes or remove unneeded files. The application specified with the `using` syntax will execute this file. The `post:` action always runs by default but you can override this using `post-if`.
                  "%
                  | optional,
                post-if | definitions.contract.post-if | optional,
                pre
                  | String
                  | doc m%"
                  Allows you to run a script at the start of a job, before the `main:` action begins. For example, you can use `pre:` to run a prerequisite setup script. The application specified with the `using` syntax will execute this file. The `pre:` action always runs by default but you can override this using `pre-if`.
                  "%
                  | optional,
                pre-if | definitions.contract.pre-if | optional,
                using
                  | predicates.contract_from_predicate
                  (predicates.enum [ "node12", "node16", "node20" ])
                  | doc m%"
                  The application used to execute the code specified in `main`.
                  "%,
              },
          stringContainingExpressionSyntax = predicates.contract_from_predicate
              definitions.predicate.stringContainingExpressionSyntax,
        },
    predicate = {
          expressionSyntax = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^\\$\\{\\{(.|[\n])*\\}\\}$"
              ],
          outputs
            | doc m%"
            Output parameters allow you to declare data that an action sets. Actions that run later in a workflow can use the output data set in previously run actions. For example, if you had an action that performed the addition of two inputs (x + y = z), the action could output the sum (z) for other actions to use as an input.
            If you don't declare an output in your action metadata file, you can still set outputs and use them in a workflow.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "description" ],
                        predicates.records.record
                        { description = predicates.isType '"String", }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          outputs-composite
            | doc m%"
            Output parameters allow you to declare data that an action sets. Actions that run later in a workflow can use the output data set in previously run actions. For example, if you had an action that performed the addition of two inputs (x + y = z), the action could output the sum (z) for other actions to use as an input.
            If you don't declare an output in your action metadata file, you can still set outputs and use them in a workflow.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "description", "value" ],
                        predicates.records.record
                        {
                          description = predicates.isType '"String",
                          value = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                false
                predicates.never
              ],
          post-if
            | doc m%"
            Allows you to define conditions for the `post:` action execution. The `post:` action will only run if the conditions in `post-if` are met. If not set, then `post-if` defaults to `always()`.
            "%
            = predicates.isType '"String",
          pre-if
            | doc m%"
            Allows you to define conditions for the `pre:` action execution. The `pre:` action will only run if the conditions in `pre-if` are met. If not set, then `pre-if` defaults to `always()`. Note that the `step` context is unavailable, as no steps have run yet.
            "%
            = predicates.isType '"String",
          runs-composite
            | doc m%"
            Configures the path to the composite action, and the application used to execute the code.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "steps", "using" ],
                predicates.records.record
                {
                  steps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.oneOf
                          [
                            predicates.allOf
                            [
                              predicates.records.required [ "run", "shell" ],
                              predicates.records.record {  } {  } true
                              predicates.always
                            ],
                            predicates.allOf
                            [
                              predicates.records.required [ "uses" ],
                              predicates.records.record {  } {  } true
                              predicates.always
                            ]
                          ],
                          predicates.records.record
                          {
                            continue-on-error = predicates.oneOf
                                [
                                  predicates.isType '"Bool",
                                  definitions.predicate.expressionSyntax
                                ],
                            env = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record {  } {  } true
                                  (predicates.isType '"String")
                                ],
                            id = predicates.isType '"String",
                            "if" = predicates.isType '"String",
                            name = predicates.isType '"String",
                            run = predicates.isType '"String",
                            shell = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.anyOf
                                  [
                                    predicates.always,
                                    predicates.enum
                                    [
                                      "bash",
                                      "pwsh",
                                      "python",
                                      "sh",
                                      "cmd",
                                      "powershell"
                                    ]
                                  ]
                                ],
                            uses = predicates.isType '"String",
                            with = predicates.isType 'Record,
                            working-directory = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                  using = predicates.const "composite",
                }
                {  }
                false
                predicates.never
              ],
          runs-docker
            | doc m%"
            Configures the image used for the Docker action.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image", "using" ],
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  entrypoint = predicates.isType '"String",
                  env = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            predicates.isType '"Number",
                            predicates.isType '"Bool"
                          ])
                        ],
                        definitions.predicate.stringContainingExpressionSyntax
                      ],
                  image = predicates.isType '"String",
                  post-entrypoint = predicates.isType '"String",
                  post-if = definitions.predicate.post-if,
                  pre-entrypoint = predicates.isType '"String",
                  pre-if = definitions.predicate.pre-if,
                  using = predicates.const "docker",
                }
                {  }
                false
                predicates.never
              ],
          runs-javascript
            | doc m%"
            Configures the path to the action's code and the application used to execute the code.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "main", "using" ],
                predicates.records.record
                {
                  main = predicates.isType '"String",
                  post = predicates.isType '"String",
                  post-if = definitions.predicate.post-if,
                  pre = predicates.isType '"String",
                  pre-if = definitions.predicate.pre-if,
                  using = predicates.enum [ "node12", "node16", "node20" ],
                }
                {  }
                false
                predicates.never
              ],
          stringContainingExpressionSyntax = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^.*\\$\\{\\{(.|[\n])*\\}\\}.*$"
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.ifThenElse
  (predicates.records.record
  {
    runs = predicates.records.record { using = predicates.const "composite", }
        {  }
        true
        predicates.always,
  }
  {  }
  true
  predicates.always)
  (predicates.records.record
  { outputs = definitions.predicate.outputs-composite, }
  {  }
  true
  predicates.always)
  (predicates.records.record { outputs = definitions.predicate.outputs, } {  }
  true
  predicates.always),
  predicates.records.required [ "description", "name", "runs" ],
  predicates.records.record
  {
    author = predicates.isType '"String",
    branding = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            color = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum
                  [
                    "white",
                    "yellow",
                    "blue",
                    "green",
                    "orange",
                    "red",
                    "purple",
                    "gray-dark"
                  ]
                ],
            icon = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum
                  [
                    "activity",
                    "airplay",
                    "alert-circle",
                    "alert-octagon",
                    "alert-triangle",
                    "align-center",
                    "align-justify",
                    "align-left",
                    "align-right",
                    "anchor",
                    "aperture",
                    "archive",
                    "arrow-down-circle",
                    "arrow-down-left",
                    "arrow-down-right",
                    "arrow-down",
                    "arrow-left-circle",
                    "arrow-left",
                    "arrow-right-circle",
                    "arrow-right",
                    "arrow-up-circle",
                    "arrow-up-left",
                    "arrow-up-right",
                    "arrow-up",
                    "at-sign",
                    "award",
                    "bar-chart-2",
                    "bar-chart",
                    "battery-charging",
                    "battery",
                    "bell-off",
                    "bell",
                    "bluetooth",
                    "bold",
                    "book-open",
                    "book",
                    "bookmark",
                    "box",
                    "briefcase",
                    "calendar",
                    "camera-off",
                    "camera",
                    "cast",
                    "check-circle",
                    "check-square",
                    "check",
                    "chevron-down",
                    "chevron-left",
                    "chevron-right",
                    "chevron-up",
                    "chevrons-down",
                    "chevrons-left",
                    "chevrons-right",
                    "chevrons-up",
                    "circle",
                    "clipboard",
                    "clock",
                    "cloud-drizzle",
                    "cloud-lightning",
                    "cloud-off",
                    "cloud-rain",
                    "cloud-snow",
                    "cloud",
                    "code",
                    "command",
                    "compass",
                    "copy",
                    "corner-down-left",
                    "corner-down-right",
                    "corner-left-down",
                    "corner-left-up",
                    "corner-right-down",
                    "corner-right-up",
                    "corner-up-left",
                    "corner-up-right",
                    "cpu",
                    "credit-card",
                    "crop",
                    "crosshair",
                    "database",
                    "delete",
                    "disc",
                    "dollar-sign",
                    "download-cloud",
                    "download",
                    "droplet",
                    "edit-2",
                    "edit-3",
                    "edit",
                    "external-link",
                    "eye-off",
                    "eye",
                    "facebook",
                    "fast-forward",
                    "feather",
                    "file-minus",
                    "file-plus",
                    "file-text",
                    "file",
                    "film",
                    "filter",
                    "flag",
                    "folder-minus",
                    "folder-plus",
                    "folder",
                    "gift",
                    "git-branch",
                    "git-commit",
                    "git-merge",
                    "git-pull-request",
                    "globe",
                    "grid",
                    "hard-drive",
                    "hash",
                    "headphones",
                    "heart",
                    "help-circle",
                    "home",
                    "image",
                    "inbox",
                    "info",
                    "italic",
                    "layers",
                    "layout",
                    "life-buoy",
                    "link-2",
                    "link",
                    "list",
                    "loader",
                    "lock",
                    "log-in",
                    "log-out",
                    "mail",
                    "map-pin",
                    "map",
                    "maximize-2",
                    "maximize",
                    "menu",
                    "message-circle",
                    "message-square",
                    "mic-off",
                    "mic",
                    "minimize-2",
                    "minimize",
                    "minus-circle",
                    "minus-square",
                    "minus",
                    "monitor",
                    "moon",
                    "more-horizontal",
                    "more-vertical",
                    "move",
                    "music",
                    "navigation-2",
                    "navigation",
                    "octagon",
                    "package",
                    "paperclip",
                    "pause-circle",
                    "pause",
                    "percent",
                    "phone-call",
                    "phone-forwarded",
                    "phone-incoming",
                    "phone-missed",
                    "phone-off",
                    "phone-outgoing",
                    "phone",
                    "pie-chart",
                    "play-circle",
                    "play",
                    "plus-circle",
                    "plus-square",
                    "plus",
                    "pocket",
                    "power",
                    "printer",
                    "radio",
                    "refresh-ccw",
                    "refresh-cw",
                    "repeat",
                    "rewind",
                    "rotate-ccw",
                    "rotate-cw",
                    "rss",
                    "save",
                    "scissors",
                    "search",
                    "send",
                    "server",
                    "settings",
                    "share-2",
                    "share",
                    "shield-off",
                    "shield",
                    "shopping-bag",
                    "shopping-cart",
                    "shuffle",
                    "sidebar",
                    "skip-back",
                    "skip-forward",
                    "slash",
                    "sliders",
                    "smartphone",
                    "speaker",
                    "square",
                    "star",
                    "stop-circle",
                    "sun",
                    "sunrise",
                    "sunset",
                    "tablet",
                    "tag",
                    "target",
                    "terminal",
                    "thermometer",
                    "thumbs-down",
                    "thumbs-up",
                    "toggle-left",
                    "toggle-right",
                    "trash-2",
                    "trash",
                    "trending-down",
                    "trending-up",
                    "triangle",
                    "truck",
                    "tv",
                    "type",
                    "umbrella",
                    "underline",
                    "unlock",
                    "upload-cloud",
                    "upload",
                    "user-check",
                    "user-minus",
                    "user-plus",
                    "user-x",
                    "user",
                    "users",
                    "video-off",
                    "video",
                    "voicemail",
                    "volume-1",
                    "volume-2",
                    "volume-x",
                    "volume",
                    "watch",
                    "wifi-off",
                    "wifi",
                    "wind",
                    "x-circle",
                    "x-square",
                    "x",
                    "zap-off",
                    "zap",
                    "zoom-in",
                    "zoom-out"
                  ]
                ],
          }
          {  }
          false
          predicates.never
        ],
    description = predicates.isType '"String",
    inputs = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^[_a-zA-Z][a-zA-Z0-9_-]*$" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "description" ],
                  predicates.records.record
                  {
                    "default" = predicates.isType '"String",
                    deprecationMessage = predicates.isType '"String",
                    description = predicates.isType '"String",
                    required = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ],
          }
          false
          predicates.never
        ],
    name = predicates.isType '"String",
    outputs = predicates.always,
    runs = predicates.oneOf
        [
          definitions.predicate.runs-javascript,
          definitions.predicate.runs-composite,
          definitions.predicate.runs-docker
        ],
  }
  {  }
  false
  predicates.never
])