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
          ConfigParamKey = predicates.contract_from_predicate
              definitions.predicate.ConfigParamKey,
          EmailAddress
            | doc m%"
            Internet email address conforming to most of RFC 822 syntax rules and by that allowing a majority of internalized email addresses as well.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.EmailAddress,
          EncryptedSecret = predicates.contract_from_predicate
              definitions.predicate.EncryptedSecret,
          HashedSecret = predicates.contract_from_predicate
              definitions.predicate.HashedSecret,
          "Map(ConfigParamKey,String)" = predicates.contract_from_predicate
              definitions.predicate."Map(ConfigParamKey,String)",
          Role = predicates.contract_from_predicate definitions.predicate.Role,
          TimeOfDay = predicates.contract_from_predicate
              definitions.predicate.TimeOfDay,
        },
    predicate = {
          ConfigParamKey = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^(?=[^=]+$)(?!\\s+$)(.|\\n)+$"
              ],
          EmailAddress
            | doc m%"
            Internet email address conforming to most of RFC 822 syntax rules and by that allowing a majority of internalized email addresses as well.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^.+@.+$"
              ],
          EncryptedSecret = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(?:plain:.+|aes256:(?:\\s*[A-Za-z0-9+/]){16}:(?:\\s*[A-Za-z0-9+/]){16}:(?:(?:\\s*[A-Za-z0-9+/]){4})*(?:(?:\\s*[A-Za-z0-9+/]){2}(?:\\s*=){2}|(?:\\s*[A-Za-z0-9+/]){3}(?:\\s*=))?\\s*)$"
              ],
          HashedSecret = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(?:\\s*[A-Za-z0-9+/]){43}(?:\\s*=):(?:(?:\\s*[A-Za-z0-9+/]){4})*(?:(?:\\s*[A-Za-z0-9+/]){2}(?:\\s*=){2}|(?:\\s*[A-Za-z0-9+/]){3}(?:\\s*=))?\\s*$"
              ],
          "Map(ConfigParamKey,String)" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.propertyNames
                definitions.predicate.ConfigParamKey,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          Role = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.minProperties 1,
                predicates.records.record
                {
                  assignToNewExternalUsers = predicates.isType '"Bool",
                  description = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  displayName = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  externalValue = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  permissions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "viewScan",
                            "exportData",
                            "administerGe",
                            "administerProjects",
                            "administerCache",
                            "publishScan",
                            "testDistribution",
                            "readCache",
                            "writeCache",
                            "accessAllDataWithOrWithoutAssociatedProject",
                            "accessDataWithoutAssociatedProject",
                            "readCacheWriteCas"
                          ]
                        ]),
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          TimeOfDay = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^(?:[01]\\d|2[0-3]):[0-5]\\d$"
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.minProperties 1,
  predicates.records.required [ "systemPassword", "version" ],
  predicates.records.record
  {
    advanced = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.minProperties 1,
          predicates.records.record
          {
            app = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 1,
                  predicates.records.record
                  {
                    heapMemory = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 100
                        ],
                    offHeapMemory = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 100
                        ],
                    params = predicates.allOf
                        [
                          definitions.predicate."Map(ConfigParamKey,String)",
                          predicates.always
                        ],
                    scanPayloadCacheSize = predicates.isType 'Integer,
                  }
                  {  }
                  false
                  predicates.never
                ],
            appBackgroundProcessor = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 1,
                  predicates.records.record
                  {
                    heapMemory = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 100
                        ],
                    offHeapMemory = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 100
                        ],
                    params = predicates.allOf
                        [
                          definitions.predicate."Map(ConfigParamKey,String)",
                          predicates.always
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
            buildCacheNode = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 1,
                  predicates.records.record
                  {
                    heapMemory = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 100
                        ],
                    offHeapMemory = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 100
                        ],
                    params = predicates.allOf
                        [
                          definitions.predicate."Map(ConfigParamKey,String)",
                          predicates.always
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
            distributionBroker = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 1,
                  predicates.records.record
                  {
                    heapMemory = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 100
                        ],
                    offHeapMemory = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.minimum 100
                        ],
                    params = predicates.allOf
                        [
                          definitions.predicate."Map(ConfigParamKey,String)",
                          predicates.always
                        ],
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
    auth = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.minProperties 1,
          predicates.records.record
          {
            anonymousPermissions = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum
                    [
                      "viewScan",
                      "exportData",
                      "administerGe",
                      "administerProjects",
                      "administerCache",
                      "publishScan",
                      "testDistribution",
                      "readCache",
                      "writeCache",
                      "accessAllDataWithOrWithoutAssociatedProject",
                      "accessDataWithoutAssociatedProject",
                      "readCacheWriteCas"
                    ]
                  ]),
                  predicates.arrays.uniqueItems
                ],
            external = predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.allOf
                    [
                      predicates.ifThenElse
                      (predicates.records.record
                      { type = predicates.const "ldap", }
                      {  }
                      true
                      predicates.always)
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.minProperties 1,
                        predicates.records.required
                        [ "connectionUrl", "displayName", "roles", "users" ],
                        predicates.records.record
                        {
                          bindUser = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Record,
                                  predicates.isType 'Null
                                ],
                                predicates.records.minProperties 1,
                                predicates.records.required
                                [ "dn", "password" ],
                                predicates.records.record
                                {
                                  dn = predicates.isType '"String",
                                  password = predicates.allOf
                                      [
                                        definitions.predicate.EncryptedSecret,
                                        predicates.always
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          connectionUrl = predicates.isType '"String",
                          displayName = predicates.isType '"String",
                          roles = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.allOf
                                [
                                  predicates.ifThenElse
                                  (predicates.records.record
                                  { type = predicates.const "external", }
                                  {  }
                                  true
                                  predicates.always)
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.minProperties 1,
                                    predicates.records.required
                                    [
                                      "baseDn",
                                      "membershipAttribute",
                                      "membershipAttributeType",
                                      "nameAttribute",
                                      "objectClass"
                                    ],
                                    predicates.records.record
                                    {
                                      baseDn = predicates.isType '"String",
                                      membershipAttribute = predicates.isType
                                          '"String",
                                      membershipAttributeType = predicates.allOf
                                          [
                                            predicates.isType '"String",
                                            predicates.enum [ "dn", "uid" ]
                                          ],
                                      nameAttribute = predicates.isType
                                          '"String",
                                      objectClass = predicates.isType '"String",
                                      retrieveStrategy = predicates.allOf
                                          [
                                            predicates.isType '"String",
                                            predicates.enum
                                            [
                                              "groupMember",
                                              "userMemberof",
                                              "matchingRuleInChain"
                                            ]
                                          ],
                                      type = predicates.const "external",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                  predicates.always,
                                  predicates.ifThenElse
                                  (predicates.records.record
                                  { type = predicates.const "local", }
                                  {  }
                                  true
                                  predicates.always)
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.minProperties 1,
                                    predicates.records.record
                                    { type = predicates.const "local", }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                  predicates.always
                                ],
                                predicates.records.minProperties 1,
                                predicates.records.required [ "type" ],
                                predicates.records.record
                                {
                                  type = predicates.enum
                                      [ "external", "local" ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          type = predicates.const "ldap",
                          users = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.minProperties 1,
                                predicates.records.required
                                [ "attributes", "baseDn" ],
                                predicates.records.record
                                {
                                  attributes = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.minProperties 1,
                                        predicates.records.required
                                        [
                                          "email",
                                          "firstName",
                                          "lastName",
                                          "userName",
                                          "uuid"
                                        ],
                                        predicates.records.record
                                        {
                                          email = predicates.isType '"String",
                                          firstName = predicates.isType
                                              '"String",
                                          lastName = predicates.isType
                                              '"String",
                                          userName = predicates.isType
                                              '"String",
                                          uuid = predicates.isType '"String",
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                  baseDn = predicates.isType '"String",
                                  filter = predicates.allOf
                                      [
                                        predicates.anyOf
                                        [
                                          predicates.isType '"String",
                                          predicates.isType 'Null
                                        ],
                                        predicates.always
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ])
                      predicates.always,
                      predicates.ifThenElse
                      (predicates.records.record
                      { type = predicates.const "saml", }
                      {  }
                      true
                      predicates.always)
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.minProperties 1,
                        predicates.records.required
                        [ "displayName", "idpMetadata", "roles" ],
                        predicates.records.record
                        {
                          displayName = predicates.isType '"String",
                          idpMetadata = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(?:(?:\\s*[A-Za-z0-9+/]){4})*(?:(?:\\s*[A-Za-z0-9+/]){2}(?:\\s*=){2}|(?:\\s*[A-Za-z0-9+/]){3}(?:\\s*=))?\\s*$"
                              ],
                          options = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.minProperties 1,
                                predicates.records.record
                                {
                                  requireEncryptedAssertion = predicates.isType
                                      '"Bool",
                                  signAuthenticationRequests = predicates.isType
                                      '"Bool",
                                  validateAssertionSignature = predicates.isType
                                      '"Bool",
                                  validateResponseSignature = predicates.isType
                                      '"Bool",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          roles = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.allOf
                                [
                                  predicates.ifThenElse
                                  (predicates.records.record
                                  { type = predicates.const "external", }
                                  {  }
                                  true
                                  predicates.always)
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.minProperties 1,
                                    predicates.records.required [ "attribute" ],
                                    predicates.records.record
                                    {
                                      attribute = predicates.isType '"String",
                                      type = predicates.const "external",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                  predicates.always,
                                  predicates.ifThenElse
                                  (predicates.records.record
                                  { type = predicates.const "local", }
                                  {  }
                                  true
                                  predicates.always)
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.minProperties 1,
                                    predicates.records.record
                                    { type = predicates.const "local", }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                  predicates.always
                                ],
                                predicates.records.minProperties 1,
                                predicates.records.required [ "type" ],
                                predicates.records.record
                                {
                                  type = predicates.enum
                                      [ "external", "local" ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          type = predicates.const "saml",
                          userAttributes = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.minProperties 1,
                                predicates.records.record
                                {
                                  email = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  firstName = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                  lastName = predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType 'Null
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ])
                      predicates.always
                    ],
                    predicates.records.minProperties 1,
                    predicates.records.required [ "type" ],
                    predicates.records.record
                    { type = predicates.enum [ "ldap", "saml" ], }
                    {  }
                    true
                    predicates.always
                  ]
                ],
            projects = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 1,
                  predicates.records.record
                  {
                    acceptAnonymousProjects = predicates.isType '"Bool",
                    enabled = predicates.isType '"Bool",
                  }
                  {  }
                  false
                  predicates.never
                ],
            roles = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.propertyNames
                  (predicates.isType '"String"),
                  predicates.records.record {  } {  } true
                  definitions.predicate.Role
                ],
            scim = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 1,
                  predicates.records.record
                  {
                    enabled = predicates.isType '"Bool",
                    token = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.minProperties 1,
                          predicates.records.required
                          [ "hash", "length", "prefix" ],
                          predicates.records.record
                          {
                            hash = predicates.allOf
                                [
                                  definitions.predicate.HashedSecret,
                                  predicates.always
                                ],
                            length = predicates.isType 'Integer,
                            prefix = predicates.isType '"String",
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
            timeouts = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 1,
                  predicates.records.record
                  {
                    accessTokenLifespan = predicates.isType 'Integer,
                    ssoSessionIdleTimeout = predicates.isType 'Integer,
                    ssoSessionMaxLifespan = predicates.isType 'Integer,
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
    backups = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Record, predicates.isType 'Null ],
          predicates.records.minProperties 1,
          predicates.records.required [ "schedule" ],
          predicates.records.record
          {
            backupsToRetain = predicates.allOf
                [ predicates.isType 'Integer, predicates.numbers.minimum 1 ],
            emailNotification = predicates.isType '"Bool",
            schedule = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.allOf
                  [
                    predicates.ifThenElse
                    (predicates.records.record
                    { type = predicates.const "daily", }
                    {  }
                    true
                    predicates.always)
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.minProperties 1,
                      predicates.records.required [ "timeOfDay" ],
                      predicates.records.record
                      {
                        timeOfDay = predicates.allOf
                            [
                              definitions.predicate.TimeOfDay,
                              predicates.always
                            ],
                        type = predicates.const "daily",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                    predicates.always,
                    predicates.ifThenElse
                    (predicates.records.record
                    { type = predicates.const "weekly", }
                    {  }
                    true
                    predicates.always)
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.minProperties 1,
                      predicates.records.required [ "dayOfWeek", "timeOfDay" ],
                      predicates.records.record
                      {
                        dayOfWeek = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [
                                "monday",
                                "tuesday",
                                "wednesday",
                                "thursday",
                                "friday",
                                "saturday",
                                "sunday"
                              ]
                            ],
                        timeOfDay = predicates.allOf
                            [
                              definitions.predicate.TimeOfDay,
                              predicates.always
                            ],
                        type = predicates.const "weekly",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                    predicates.always,
                    predicates.ifThenElse
                    (predicates.records.record
                    { type = predicates.const "cron", }
                    {  }
                    true
                    predicates.always)
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.minProperties 1,
                      predicates.records.required [ "expression" ],
                      predicates.records.record
                      {
                        expression = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.pattern
                              "^(?:\\*|(?:(?:\\*\\/)?[1-5]?[0-9])) (?:\\*|(?:(?:\\*\\/)?(?:1?[0-9]|2[0-3]))) (?:\\*|(?:(?:\\*\\/)?(?:[1-9]|[12][0-9]|3[0-1]))) (?:\\*|(?:(?:\\*\\/)?(?:[1-9]|1[0-2]))) (?:\\*|(?:(?:\\*\\/)?[0-6]))$"
                            ],
                        type = predicates.const "cron",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                    predicates.always
                  ],
                  predicates.records.minProperties 1,
                  predicates.records.required [ "type" ],
                  predicates.records.record
                  { type = predicates.enum [ "daily", "weekly", "cron" ], }
                  {  }
                  true
                  predicates.always
                ],
          }
          {  }
          false
          predicates.never
        ],
    buildCache = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.minProperties 1,
          predicates.records.record
          {
            allowUntrustedNodeSsl = predicates.isType '"Bool",
            storageSize = predicates.isType 'Integer,
          }
          {  }
          false
          predicates.never
        ],
    buildScans = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.minProperties 1,
          predicates.records.record
          {
            diskSpaceMonitoring = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.minProperties 1,
                  predicates.records.record
                  {
                    autoDeleteWhileFreeSpaceLessThanPercentage =
                      predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Integer,
                            predicates.isType 'Null
                          ],
                          predicates.numbers.maximum 100,
                          predicates.numbers.minimum 1
                        ],
                    rejectIncomingWhileFreeSpaceLessThanPercentage =
                      predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Integer,
                            predicates.isType 'Null
                          ],
                          predicates.numbers.maximum 100,
                          predicates.numbers.minimum 1
                        ],
                    sendWarningEmailWhenFreeSpaceLessThanPercentage =
                      predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Integer,
                            predicates.isType 'Null
                          ],
                          predicates.numbers.maximum 100,
                          predicates.numbers.minimum 1
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
            incomingStorageType = predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ null, "database", "objectStorage" ]
                  ]
                ],
            keepDays = predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType 'Null ],
                  predicates.numbers.minimum 2
                ],
          }
          {  }
          false
          predicates.never
        ],
    dailyMaintenanceTime = predicates.allOf
        [ definitions.predicate.TimeOfDay, predicates.always ],
    email = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Record, predicates.isType 'Null ],
          predicates.records.minProperties 1,
          predicates.records.required
          [ "administratorAddress", "fromAddress", "smtpServer" ],
          predicates.records.record
          {
            administratorAddress = predicates.allOf
                [ definitions.predicate.EmailAddress, predicates.always ],
            authentication = predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType 'Record, predicates.isType 'Null ],
                  predicates.records.minProperties 1,
                  predicates.records.required
                  [ "password", "type", "username" ],
                  predicates.records.record
                  {
                    password = definitions.predicate.EncryptedSecret,
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "login", "cramMd5", "plain" ]
                        ],
                    username = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
            fromAddress = predicates.allOf
                [ definitions.predicate.EmailAddress, predicates.always ],
            smtpServer = predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern
                  "^(?:(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])|(?:(?:[a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*(?:[A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])):(?:[1-9][0-9]{0,3}|[1-6][0-5][0-5][0-3][0-5])$"
                ],
            sslProtocol = predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ null, "startTls", "implicitTls" ]
                  ]
                ],
          }
          {  }
          false
          predicates.never
        ],
    helpContact = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.minProperties 1,
          predicates.records.record
          {
            email = predicates.anyOf
                [ predicates.isType 'Null, definitions.predicate.EmailAddress ],
            name = predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Null ],
          }
          {  }
          false
          predicates.never
        ],
    legacyObjectStorage = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.minProperties 1,
          predicates.records.record
          {
            provider = predicates.anyOf
                [
                  predicates.isType 'Null,
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.ifThenElse
                    (predicates.records.record { type = predicates.const "s3", }
                    {  }
                    true
                    predicates.always)
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.minProperties 1,
                      predicates.records.required
                      [ "bucket", "credentials", "region" ],
                      predicates.records.record
                      {
                        bucket = predicates.isType '"String",
                        credentials = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.allOf
                              [
                                predicates.ifThenElse
                                (predicates.records.record
                                { source = predicates.const "configuration", }
                                {  }
                                true
                                predicates.always)
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.minProperties 1,
                                  predicates.records.required
                                  [ "accessKey", "secretKey" ],
                                  predicates.records.record
                                  {
                                    accessKey = predicates.isType '"String",
                                    secretKey =
                                      definitions.predicate.EncryptedSecret,
                                    source = predicates.const "configuration",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ])
                                predicates.always,
                                predicates.ifThenElse
                                (predicates.records.record
                                { source = predicates.const "environment", }
                                {  }
                                true
                                predicates.always)
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.minProperties 1,
                                  predicates.records.record
                                  { source = predicates.const "environment", }
                                  {  }
                                  false
                                  predicates.never
                                ])
                                predicates.always
                              ],
                              predicates.records.minProperties 1,
                              predicates.records.required [ "source" ],
                              predicates.records.record
                              {
                                source = predicates.enum
                                    [ "configuration", "environment" ],
                              }
                              {  }
                              true
                              predicates.always
                            ],
                        region = predicates.isType '"String",
                        type = predicates.const "s3",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                    predicates.always,
                    predicates.records.minProperties 1,
                    predicates.records.required [ "type" ],
                    predicates.records.record
                    { type = predicates.enum [ "s3" ], }
                    {  }
                    true
                    predicates.always
                  ]
                ],
          }
          {  }
          false
          predicates.never
        ],
    network = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Record, predicates.isType 'Null ],
          predicates.records.minProperties 1,
          predicates.records.record
          {
            additionalTrust = predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ],
                  predicates.strings.pattern
                  "(?:^|\\r?\\n)-----BEGIN CERTIFICATE-----(?:\\r?\\n)(?:(?:\\s*[A-Za-z0-9+/]){4})*(?:(?:\\s*[A-Za-z0-9+/]){2}(?:\\s*=){2}|(?:\\s*[A-Za-z0-9+/]){3}(?:\\s*=))?\\s*(?:\\r?\\n)-----END CERTIFICATE-----(?:$|\\r?\\n)"
                ],
            proxy = predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType 'Record, predicates.isType 'Null ],
                  predicates.records.minProperties 1,
                  predicates.records.required [ "host" ],
                  predicates.records.record
                  {
                    auth = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.minProperties 1,
                          predicates.records.required
                          [ "password", "username" ],
                          predicates.records.record
                          {
                            password = predicates.allOf
                                [
                                  definitions.predicate.EncryptedSecret,
                                  predicates.always
                                ],
                            username = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    excludedHosts = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern
                            "^(?:(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])|(?:(?:^[\\*]|[a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*(?:[A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9]))$"
                          ])
                        ],
                    host = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^(?:(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])|(?:(?:[a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*(?:[A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9]))$"
                        ],
                    port = predicates.allOf
                        [
                          predicates.isType 'Integer,
                          predicates.numbers.maximum 65535,
                          predicates.numbers.minimum 1
                        ],
                    protocol = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "http", "https" ]
                        ],
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
    systemPassword = predicates.allOf
        [ definitions.predicate.HashedSecret, predicates.always ],
    version = predicates.const 8,
  }
  {  }
  false
  predicates.never
])