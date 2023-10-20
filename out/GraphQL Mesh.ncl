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
          AdditionalStitchingBatchResolverObject = {
                additionalArgs | {  .. } | optional,
                keyField | String,
                keysArg | String,
                requiredSelectionSet | String | optional,
                result
                  | String
                  | doc m%"
                  Extract specific property from the result
                  "%
                  | optional,
                resultType
                  | String
                  | doc m%"
                  If return types don't match,
                  you can specify a result type to apply inline fragment
                  "%
                  | optional,
                sourceFieldName | String,
                sourceName | String,
                sourceSelectionSet | String | optional,
                sourceTypeName | String,
                targetFieldName | String,
                targetTypeName | String,
              },
          AdditionalStitchingResolverObject = {
                requiredSelectionSet | String | optional,
                result
                  | String
                  | doc m%"
                  Extract specific property from the result
                  "%
                  | optional,
                resultType
                  | String
                  | doc m%"
                  If return types don't match,
                  you can specify a result type to apply inline fragment
                  "%
                  | optional,
                sourceArgs | {  .. } | optional,
                sourceFieldName | String,
                sourceName | String,
                sourceSelectionSet | String | optional,
                sourceTypeName | String,
                targetFieldName | String,
                targetTypeName | String,
              },
          AdditionalSubscriptionObject = {
                filterBy | String | optional,
                pubsubTopic | String,
                result | String | optional,
                targetFieldName | String,
                targetTypeName | String,
              },
          CFWorkersKVCacheConfig = {
                namespace
                  | String
                  | doc m%"
                  The name of the Workers KV namespace to use for caching.
                  
                  Make sure you have configured the following namespace described in [here](https://developers.cloudflare.com/workers/wrangler/cli-wrangler/commands/#kv).
                  "%,
              },
          Cache = {
                cfwKv | definitions.contract.CFWorkersKVCacheConfig | optional,
                file | definitions.contract.FileCacheConfig | optional,
                localforage | definitions.contract.LocalforageConfig | optional,
                redis | definitions.contract.RedisConfig | optional,
                ..
              },
          CacheEffectingOperationConfig = {
                matchKey
                  | String
                  | doc m%"
                  Cache key to invalidate on successful resolver (no error), see `cacheKey` for list of available options in this field.
                  "%
                  | optional,
                operation
                  | String
                  | doc m%"
                  Path to the operation that could effect it. In a form: Mutation.something. Note that wildcard is not supported in this field.
                  "%,
              },
          CacheInvalidateConfig = {
                effectingOperations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.CacheEffectingOperationConfig
                  ])
                  | doc m%"
                  Invalidate the cache when a specific operation is done without an error
                  "%
                  | optional,
                ttl
                  | std.number.Integer
                  | doc m%"
                  Specified in seconds, the time-to-live (TTL) value limits the lifespan
                  "%
                  | optional,
              },
          CacheTransformConfig = {
                cacheKey
                  | String
                  | doc m%"
                  Cache key to use to store your resolvers responses.
                  The default is: `{typeName}-{fieldName}-{argsHash}-{fieldNamesHash}`
                  
                  Available variables:
                    - `{args.argName}` - use resolver argument
                    - `{typeName}` - use name of the type
                    - `{fieldName}` - use name of the field
                    - `{argsHash}` - a hash based on the 'args' object
                    - `{fieldNamesHash}` - a hash based on the field names selected by the client
                    - `{info}` - the GraphQLResolveInfo of the resolver
                  
                  Available interpolations:
                    - `{format|date}` - returns the current date with a specific format
                  "%
                  | optional,
                field
                  | String
                  | doc m%"
                  The type and field to apply cache to, you can use wild cards as well, for example: `Query.*`
                  "%,
                invalidate
                  | definitions.contract.CacheInvalidateConfig
                  | doc m%"
                  Invalidation rules
                  "%
                  | optional,
              },
          ComposeMongooseInputType = {
                description | String | optional,
                fields
                  | definitions.contract.ComposeWithMongooseFieldsOpts
                  | optional,
                name | String | optional,
                resolvers
                  | definitions.contract.TypeConverterResolversOpts
                  | optional,
              },
          ComposeWithMongooseFieldsOpts = {
                only
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                remove
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                required
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          ComposeWithMongooseOpts = {
                description | String | optional,
                fields
                  | definitions.contract.ComposeWithMongooseFieldsOpts
                  | optional,
                inputType
                  | definitions.contract.ComposeMongooseInputType
                  | optional,
                name | String | optional,
                resolvers
                  | definitions.contract.TypeConverterResolversOpts
                  | optional,
              },
          ComposeWithMongooseResolverOpts = {
                filter | definitions.contract.FilterHelperArgsOpts | optional,
                limit | definitions.contract.LimitHelperArgsOpts | optional,
                record | definitions.contract.RecordHelperArgsOpts | optional,
                skip | Bool | optional,
                sort | definitions.contract.SortHelperArgsOpts | optional,
              },
          ComputedAnnotation = { selectionSet | String, },
          CorsConfig = {
                allowedHeaders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                credentials | Bool | optional,
                exposedHeaders
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                maxAge | std.number.Integer | optional,
                optionsSuccessStatus | std.number.Integer | optional,
                origin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                preflightContinue | Bool | optional,
              },
          EncapsulateTransformApplyTo = {
                mutation | Bool | optional,
                query | Bool | optional,
                subscription | Bool | optional,
              },
          EncapsulateTransformObject = {
                applyTo
                  | definitions.contract.EncapsulateTransformApplyTo
                  | doc m%"
                  Allow you to choose which root operations you would like to apply. By default, it's applied to all root types.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Optional, name to use for grouping under the root types. If not specific, the API name is used.
                  "%
                  | optional,
              },
          ExtendTransform = {
                resolvers
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                typeDefs
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
              },
          FederationField = {
                config | definitions.contract.FederationFieldConfig,
                name | String,
              },
          FederationFieldConfig = {
                external | Bool | optional,
                inaccessible | Bool | optional,
                override
                  | definitions.contract.FederationFieldOverrideConfig
                  | optional,
                provides
                  | definitions.contract.FederationFieldProvidesConfig
                  | optional,
                requires
                  | definitions.contract.FederationFieldRequiresConfig
                  | optional,
                tag | definitions.contract.FederationFieldTagConfig | optional,
              },
          FederationFieldOverrideConfig = { from | String | optional, },
          FederationFieldProvidesConfig = { fields | String | optional, },
          FederationFieldRequiresConfig = { fields | String | optional, },
          FederationFieldTagConfig = { name | String | optional, },
          FederationObjectConfig = {
                extends | Bool | optional,
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.FederationField
                  ])
                  | optional,
                key
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.FederationObjectKeyConfig
                  ])
                  | optional,
                resolveReference
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.ResolveReferenceObject
                  ])
                  | doc m%"
                  Any of: String, ResolveReferenceObject
                  "%
                  | optional,
                shareable | Bool | optional,
              },
          FederationObjectKeyConfig = { fields | String | optional, },
          FederationTransform = {
                types
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.FederationTransformType
                  ])
                  | optional,
                version
                  | String
                  | doc m%"
                  Version of the federation spec
                  Default: v2.0
                  "%
                  | optional,
              },
          FederationTransformType = {
                config | definitions.contract.FederationObjectConfig | optional,
                name | String,
              },
          FileCacheConfig = { path | String | optional, },
          FilterHelperArgsOpts = {
                filterTypeName | String | optional,
                isRequired | Bool | optional,
                onlyIndexed | Bool | optional,
                operators
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Record ])
                  | doc m%"
                  Any of: Boolean, JSON
                  "%
                  | optional,
                removeFields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                requiredFields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          FilterSchemaTransform = {
                filters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Array of filter rules
                  "%,
                mode
                  | std.enum.TagOrString
                  | [| 'wrap, 'bare |]
                  | doc m%"
                  Specify to apply filter-schema transforms to bare schema or by wrapping original schema (Allowed values: bare, wrap)
                  "%
                  | optional,
              },
          GenerateOperationsConfig = {
                selectionSetDepth | std.number.Integer | optional,
              },
          GetFromMockStoreConfig = {
                fieldName | String | optional,
                key | String | optional,
                type | String | optional,
              },
          GraphQLHandlerCodeFirstConfiguration = {
                source
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  A file path to your GraphQL Schema
                  If you provide a path to a code file(js or ts),
                  other options will be ignored and the schema exported from the file will be used directly.
                  "%,
              },
          GraphQLHandlerHTTPConfiguration = {
                batch
                  | Bool
                  | doc m%"
                  Enable/Disable automatic query batching
                  "%
                  | optional,
                connectionParams
                  | {  .. }
                  | doc m%"
                  JSON object representing the `connectionParams` from a WebSocket connection to add to the runtime of the API calls only for operation during runtime.
                  More information about the WebSocket `connectionParams`:
                    - When using `subscriptionsProtocol=WS` (graphql-ws): https://github.com/enisdenjo/graphql-ws/blob/master/docs/interfaces/client.ClientOptions.md#connectionparams
                    - When using `subscriptionsProtocol=LEGACY_WS` (subscriptions-transport-ws): https://github.com/apollographql/subscriptions-transport-ws/blob/51270cc7dbaf09c7b9aa67368f1de58148c7d334/README.md#subscriptionclient
                  "%
                  | optional,
                credentials
                  | std.enum.TagOrString
                  | [| 'include, 'omit |]
                  | doc m%"
                  Request Credentials if your environment supports it.
                  [See more](https://developer.mozilla.org/en-US/docs/Web/API/Request/credentials)
                  
                  @default "same-origin" (Allowed values: omit, include)
                  "%
                  | optional,
                endpoint
                  | String
                  | doc m%"
                  A url or file path to your remote GraphQL endpoint.
                  If you provide a path to a code file(js or ts),
                  other options will be ignored and the schema exported from the file will be used directly.
                  "%,
                method
                  | std.enum.TagOrString
                  | [| 'POST, 'GET |]
                  | doc m%"
                  HTTP method used for GraphQL operations (Allowed values: GET, POST)
                  "%
                  | optional,
                operationHeaders
                  | {  .. }
                  | doc m%"
                  JSON object representing the Headers to add to the runtime of the API calls only for operation during runtime
                  "%
                  | optional,
                retry
                  | std.number.Integer
                  | doc m%"
                  Retry attempts if fails
                  "%
                  | optional,
                schemaHeaders
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  JSON object representing the Headers to add to the runtime of the API calls only for schema introspection
                  "%
                  | optional,
                source
                  | String
                  | doc m%"
                  Path to the introspection
                  You can separately give schema introspection or SDL
                  "%
                  | optional,
                subscriptionsEndpoint
                  | String
                  | doc m%"
                  URL to your endpoint serving all subscription queries for this source
                  "%
                  | optional,
                subscriptionsProtocol
                  | std.enum.TagOrString
                  | [| 'LEGACY_WS, 'WS, 'SSE |]
                  | doc m%"
                  SSE - Server Sent Events
                  WS - New graphql-ws
                  LEGACY_WS - Legacy subscriptions-transport-ws (Allowed values: SSE, WS, LEGACY_WS)
                  "%
                  | optional,
                timeout
                  | std.number.Integer
                  | doc m%"
                  Timeout in milliseconds
                  "%
                  | optional,
                useGETForQueries
                  | Bool
                  | doc m%"
                  Use HTTP GET for Query operations
                  "%
                  | optional,
                webSocketImpl
                  | String
                  | doc m%"
                  Path to a custom W3 Compatible WebSocket Implementation
                  "%
                  | optional,
              },
          GraphQLHandlerMultipleHTTPConfiguration = {
                sources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.GraphQLHandlerHTTPConfiguration
                  ])
                  | doc m%"
                  HTTP Source Configurations
                  "%,
                strategy
                  | std.enum.TagOrString
                  | [| 'highestValue, 'race, 'fallback |]
                  | doc m%"
                  Handling strategy (default: fallback) (Allowed values: fallback, race, highestValue)
                  "%
                  | optional,
                strategyConfig
                  | definitions.contract.GraphQLHandlerhighestValueStrategyConfig
                  | doc m%"
                  Handling strategy configuration
                  "%
                  | optional,
              },
          GraphQLHandlerhighestValueStrategyConfig = {
                selectionSet | String,
                value | String,
              },
          GrpcCredentialsSsl = {
                certChain | String | optional,
                privateKey | String | optional,
                rootCA | String | optional,
              },
          GrpcHandler = {
                credentialsSsl
                  | definitions.contract.GrpcCredentialsSsl
                  | doc m%"
                  SSL Credentials
                  "%
                  | optional,
                endpoint
                  | String
                  | doc m%"
                  gRPC Endpoint
                  "%,
                metaData
                  | {  .. }
                  | doc m%"
                  MetaData
                  "%
                  | optional,
                prefixQueryMethod
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  prefix to collect Query method default: list, get
                  "%
                  | optional,
                requestTimeout
                  | std.number.Integer
                  | doc m%"
                  Request timeout in milliseconds
                  Default: 200000
                  "%
                  | optional,
                schemaHeaders | {  .. } | optional,
                source
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ProtoFilePath,
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  gRPC Proto file that contains your protobuf schema
                  OR
                  Use a binary-encoded or JSON file descriptor set file (Any of: ProtoFilePath, String)
                  "%
                  | optional,
                useHTTPS
                  | Bool
                  | doc m%"
                  Use https instead of http for gRPC connection
                  "%
                  | optional,
              },
          HTTPCachePlugin = {
                ignores
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      definitions.predicate.URLPatternObj
                    ])
                  ])
                  | doc m%"
                  If the following patterns match the request URL, the response will not be cached. (Any of: String, URLPatternObj)
                  "%
                  | optional,
                matches
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      definitions.predicate.URLPatternObj
                    ])
                  ])
                  | doc m%"
                  If the following patterns match the request URL, the response will be cached. (Any of: String, URLPatternObj)
                  "%
                  | optional,
              },
          HTTPDetailsExtensionsConfig = {
                "if"
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
              },
          HTTPSConfig = { cert | String, key | String, },
          Handler = {
                graphql
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GraphQLHandlerHTTPConfiguration,
                    definitions.predicate.GraphQLHandlerCodeFirstConfiguration,
                    definitions.predicate.GraphQLHandlerMultipleHTTPConfiguration
                  ])
                  | doc m%"
                  Handler for remote/local/third-party GraphQL schema (Any of: GraphQLHandlerHTTPConfiguration, GraphQLHandlerCodeFirstConfiguration, GraphQLHandlerMultipleHTTPConfiguration)
                  "%
                  | optional,
                grpc
                  | definitions.contract.GrpcHandler
                  | doc m%"
                  Handler for gRPC and Protobuf schemas
                  "%
                  | optional,
                jsonSchema
                  | definitions.contract.JsonSchemaHandler
                  | doc m%"
                  Handler for JSON Schema specification.
                  Source could be a local json file, or a url to it.
                  "%
                  | optional,
                mongoose | definitions.contract.MongooseHandler | optional,
                mysql | definitions.contract.MySQLHandler | optional,
                neo4j
                  | definitions.contract.Neo4jHandler
                  | doc m%"
                  Handler for Neo4j
                  "%
                  | optional,
                odata
                  | definitions.contract.ODataHandler
                  | doc m%"
                  Handler for OData
                  "%
                  | optional,
                openapi
                  | definitions.contract.OpenapiHandler
                  | doc m%"
                  Handler for Swagger / OpenAPI 2/3 specification. Source could be a local json/swagger file, or a url to it.
                  "%
                  | optional,
                postgraphile
                  | definitions.contract.PostGraphileHandler
                  | doc m%"
                  Handler for Postgres database, based on `postgraphile`
                  "%
                  | optional,
                raml | definitions.contract.RAMLHandler | optional,
                soap
                  | definitions.contract.SoapHandler
                  | doc m%"
                  Handler for SOAP
                  "%
                  | optional,
                supergraph | definitions.contract.SupergraphHandler | optional,
                thrift
                  | definitions.contract.ThriftHandler
                  | doc m%"
                  Handler for OData
                  "%
                  | optional,
                tuql
                  | definitions.contract.TuqlHandler
                  | doc m%"
                  Handler for SQLite database, based on `tuql`
                  "%
                  | optional,
                ..
              },
          HiveAgentOptions = {
                maxRetries
                  | std.number.Integer
                  | doc m%"
                  5 by default
                  "%
                  | optional,
                maxSize
                  | std.number.Integer
                  | doc m%"
                  Max number of traces to send at once (defaults to 25)
                  "%
                  | optional,
                minTimeout
                  | std.number.Integer
                  | doc m%"
                  200 by default
                  "%
                  | optional,
                sendInterval
                  | std.number.Integer
                  | doc m%"
                  Send reports in interval (defaults to 10_000ms)
                  "%
                  | optional,
                timeout
                  | std.number.Integer
                  | doc m%"
                  30s by default
                  "%
                  | optional,
              },
          HiveClientInfo = {
                name
                  | String
                  | doc m%"
                  Extract client name
                  Example: `{context.headers['x-client-name']}`
                  "%
                  | optional,
                version
                  | String
                  | doc m%"
                  Extract client version
                  Example: `{context.headers['x-client-version']}`
                  "%
                  | optional,
              },
          HivePlugin = {
                agent
                  | definitions.contract.HiveAgentOptions
                  | doc m%"
                  Agent Options
                  "%
                  | optional,
                enabled
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  If this expression is truthy, mocking would be enabled
                  You can use environment variables expression, for example: `process.env.MOCKING_ENABLED != null`
                  "%
                  | optional,
                reporting
                  | definitions.contract.HiveReportingOptions
                  | doc m%"
                  Schema reporting
                  "%
                  | optional,
                selfHosting
                  | definitions.contract.HiveSelfHostingOptions
                  | doc m%"
                  Options for self-hosting
                  [See more](https://github.com/kamilkisiela/graphql-hive/tree/main/packages/libraries/client#self-hosting)
                  "%
                  | optional,
                token
                  | String
                  | doc m%"
                  Access Token
                  "%,
                usage
                  | definitions.contract.HiveUsageOptions
                  | doc m%"
                  Collects schema usage based on operations
                  "%
                  | optional,
              },
          HiveReportingOptions = {
                author
                  | String
                  | doc m%"
                  Author of current version of the schema
                  "%,
                commit
                  | String
                  | doc m%"
                  Commit SHA hash (or any identifier) related to the schema version
                  "%,
                serviceName | String | optional,
                serviceUrl | String | optional,
              },
          HiveSelfHostingOptions = {
                applicationUrl
                  | String
                  | doc m%"
                  Address of your own GraphQL Hive application
                  
                  Used by token info to generate a link to the organization, project and target.
                  "%,
                graphqlEndpoint
                  | String
                  | doc m%"
                  Point to your own instance of GraphQL Hive API
                  
                  Used by schema reporting and token info.
                  "%,
                usageEndpoint
                  | String
                  | doc m%"
                  Point to your own instance of GraphQL Hive Usage API
                  
                  Used by usage reporting.
                  "%
                  | optional,
              },
          HiveUsageOptions = {
                clientInfo
                  | definitions.contract.HiveClientInfo
                  | doc m%"
                  Extract client info from GraphQL Context
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
                  A list of operations (by name) to be ignored by Hive.
                  "%
                  | optional,
                max
                  | std.number.Integer
                  | doc m%"
                  Hive uses LRU cache to store info about operations.
                  This option represents the maximum size of the cache.
                  Default: 1000
                  "%
                  | optional,
                processVariables
                  | Bool
                  | doc m%"
                  (Experimental) Enables collecting Input fields usage based on the variables passed to the operation.
                  Default: false
                  "%
                  | optional,
                sampleRate
                  | Number
                  | doc m%"
                  Sample rate to determine sampling.
                  0.0 = 0% chance of being sent
                  1.0 = 100% chance of being sent
                  Default: 1.0
                  "%
                  | optional,
                ttl
                  | std.number.Integer
                  | doc m%"
                  Hive uses LRU cache to store info about operations.
                  This option represents the maximum age of an unused operation in the cache.
                  Default: no ttl
                  "%
                  | optional,
              },
          HoistFieldTransformConfig = {
                alias | String | optional,
                filterArgsInPath
                  | Bool
                  | doc m%"
                  Defines if args in path are filtered (default = false)
                  "%
                  | optional,
                newFieldName
                  | String
                  | doc m%"
                  Name the hoisted field should have when hoisted to the type specified in typeName
                  "%,
                pathConfig
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"String",
                      definitions.predicate.HoistFieldTransformFieldPathConfigObject
                    ])
                  ])
                  | doc m%"
                  Array of fieldsNames to reach the field to be hoisted (Any of: String, HoistFieldTransformFieldPathConfigObject)
                  "%,
                typeName
                  | String
                  | doc m%"
                  Type name that defines where field should be hoisted to
                  "%,
              },
          HoistFieldTransformFieldPathConfigObject = {
                fieldName
                  | String
                  | doc m%"
                  Field name
                  "%,
                filterArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Match fields based on argument, needs to implement `(arg: GraphQLArgument) => boolean`;
                  "%,
              },
          JsonSchemaHTTPOperation = {
                argTypeMap
                  | {  .. }
                  | doc m%"
                  Mapping the JSON Schema and define the arguments of the operation.
                  
                  # Example:
                  argTypeMap:
                    user_id:
                      type: string
                  "%
                  | optional,
                binary
                  | Bool
                  | doc m%"
                  If true, this operation cannot have requestSchema or requestSample
                  And the request body will be passed as binary with its mime type
                  unless you define an explicit Content-Type header
                  "%
                  | optional,
                deprecated
                  | Bool
                  | doc m%"
                  If true, `@deprecated` will be added to the field definition
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Your chance to describe the operation!
                  Make sure the description is clear and concise.
                  "%
                  | optional,
                exposeResponseMetadata
                  | Bool
                  | doc m%"
                  Expose response details done to the upstream API
                  When you enable this, you will see a new field in the response type;
                  ```graphql
                  type MyResponseType {
                    myFooField: String
                    _response: ResponseMetadata
                  }
                  
                  # And a new type for the response metadata object
                  type ResponseMetadata {
                    url: URL
                    status: Int
                    method: String
                    headers: JSON
                    body: String
                  }
                  ```
                  "%
                  | optional,
                field
                  | String
                  | doc m%"
                  This Field based on the field name of the URL path.
                  Example: "https://MyAPIURL.com/FieldNameHere/",
                  so we will set the "field: FieldNameHere".
                  "%,
                headers | {  .. } | optional,
                method
                  | std.enum.TagOrString
                  | [|
                    'PATCH,
                    'TRACE,
                    'OPTIONS,
                    'CONNECT,
                    'DELETE,
                    'PUT,
                    'POST,
                    'HEAD,
                    'GET
                  |]
                  | doc m%"
                  Allowed values: GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH
                  "%
                  | optional,
                path | String,
                queryParamArgMap
                  | {  .. }
                  | doc m%"
                  JSON object representing the mapping of query search parameters (added to the route path) and the matching argument.
                  
                  # Example:
                  queryParamArgMap:
                    id: user_id
                  "%
                  | optional,
                requestBaseBody
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  This body will be merged with the request body sent with
                  the underlying HTTP request
                  "%
                  | optional,
                requestSample
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  The path definition of the JSON Schema sample.
                  Example: "./jsons/questions.response.json".
                  "%
                  | optional,
                requestSchema
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  Your chance to provide request schema name.
                  "%
                  | optional,
                requestTypeName
                  | String
                  | doc m%"
                  Inset any name for the type of the request body.
                  "%
                  | optional,
                responseByStatusCode
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  You can define your response schemas by status codes;
                  ```yaml filename=".meshrc.yaml"
                  responseByStatusCode:
                    200:
                      responseSchema: ./someschema.json#/somepath
                    404:
                      responseSample: ./error-sample.json
                      responseTypeName: MyError
                  ```
                  "%
                  | optional,
                responseSample
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  Did you use Sample? Provide the response sample path.
                  "%
                  | optional,
                responseSchema
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  Yay! Now you can provide the response schema name.
                  "%
                  | optional,
                responseTypeName
                  | String
                  | doc m%"
                  Inset any name for the type of the response body.
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'Subscription, 'Mutation, 'Query |]
                  | doc m%"
                  Type field is set the opertion type: Query, Mutation or Subscription. (Allowed values: Query, Mutation, Subscription)
                  "%,
              },
          JsonSchemaHandler = {
                bundleHeaders
                  | {  .. }
                  | doc m%"
                  Will be removed later
                  "%
                  | optional,
                bundlePath
                  | String
                  | doc m%"
                  Will be removed later
                  "%
                  | optional,
                endpoint | String | optional,
                ignoreErrorResponses | Bool | optional,
                operationHeaders | {  .. } | optional,
                operations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.JsonSchemaHTTPOperation,
                      definitions.predicate.JsonSchemaPubSubOperation
                    ])
                  ])
                  | doc m%"
                  Any of: JsonSchemaHTTPOperation, JsonSchemaPubSubOperation
                  "%
                  | optional,
                queryParams
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                queryStringOptions
                  | definitions.contract.QueryStringOptions
                  | optional,
                schemaHeaders | {  .. } | optional,
                source
                  | String
                  | doc m%"
                  Path to the bundle file
                  "%
                  | optional,
                timeout
                  | std.number.Integer
                  | doc m%"
                  Timeout for the HTTP request in milliseconds
                  "%
                  | optional,
              },
          JsonSchemaPubSubOperation = {
                argTypeMap | {  .. } | optional,
                deprecated
                  | Bool
                  | doc m%"
                  If true, `@deprecated` will be added to the field definition
                  "%
                  | optional,
                description | String | optional,
                field | String,
                pubsubTopic | String,
                requestBaseBody
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  This body will be merged with the request body sent with
                  the underlying HTTP request
                  "%
                  | optional,
                requestSample
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                requestSchema
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                requestTypeName | String | optional,
                responseSample
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                responseSchema
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                responseTypeName | String | optional,
                type
                  | std.enum.TagOrString
                  | [| 'Subscription, 'Mutation, 'Query |]
                  | doc m%"
                  Allowed values: Query, Mutation, Subscription
                  "%,
              },
          KeyAnnotation = { selectionSet | String, },
          LimitHelperArgsOpts = {
                defaultValue | std.number.Integer | optional,
              },
          LiveQueryConfig = {
                idFieldName
                  | String
                  | doc m%"
                  Identifier unique field
                  
                  Default: "id"
                  "%
                  | optional,
                includeIdentifierExtension
                  | Bool
                  | doc m%"
                  Whether the extensions should include a list of all resource identifiers for the latest operation result.
                  Any of those can be used for invalidating and re-scheduling the operation execution.
                  
                  This is mainly useful for discovering and learning what kind of topics a given query will subscribe to.
                  The default value is `true` if `DEBUG` environment variable is set
                  "%
                  | optional,
                indexBy
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.LiveQueryIndexBy
                  ])
                  | doc m%"
                  Specify which fields should be indexed for specific invalidations.
                  "%
                  | optional,
                invalidations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.LiveQueryInvalidation
                  ])
                  | doc m%"
                  Invalidate a query or queries when a specific operation is done without an error
                  "%
                  | optional,
                resourceIdentifier
                  | String
                  | doc m%"
                  Custom strategy for building resources identifiers
                  By default resource identifiers are built by concatenating the Typename with the id separated by a color (`User:1`).
                  
                  This may be useful if you are using a relay compliant schema and the Typename information is not required for building a unique topic.
                  
                  Default: "{typename}:{id}"
                  "%
                  | optional,
              },
          LiveQueryIndexBy = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                field | String,
              },
          LiveQueryInvalidation = {
                field
                  | String
                  | doc m%"
                  Path to the operation that could effect it. In a form: Mutation.something. Note that wildcard is not supported in this field.
                  "%,
                invalidate
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
              },
          LoadOptions = {
                defaults | Bool | optional,
                includeDirs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          LocalforageConfig = {
                description | String | optional,
                driver
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "WEBSQL", "INDEXEDDB", "LOCALSTORAGE" ]
                    ])
                  ])
                  | doc m%"
                  Allowed values: WEBSQL, INDEXEDDB, LOCALSTORAGE
                  "%
                  | optional,
                name | String | optional,
                size | std.number.Integer | optional,
                storeName | String | optional,
                version | Number | optional,
              },
          MaskedErrorsPluginConfig = { errorMessage | String | optional, },
          MergedRootFieldConfig = {
                additionalArgs
                  | String
                  | doc m%"
                  Specifies a string of additional keys and values to apply to other arguments,
                  formatted as `\"\"\" arg1: "value", arg2: "value" \"\"\"`.
                  "%
                  | optional,
                argsExpr
                  | String
                  | doc m%"
                  Advanced use only; This argument specifies a string expression that allows more customization of the input arguments. Rules for evaluation of this argument are as follows:
                    - basic object parsing of the input key: `"arg1: $key.arg1, arg2: $key.arg2"`
                    - any expression enclosed by double brackets will be evaluated once for each of the requested keys, and then sent as a list: `"input: { keys: [[$key]] }"`
                    - selections from the key can be referenced by using the $ sign and dot notation: `"upcs: [[$key.upc]]"`, so that `$key.upc` refers to the `upc` field of the key.
                  "%
                  | optional,
                key
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Advanced use only; Allows building a custom key just for the argument from the selectionSet included by the `@key` directive.
                  "%
                  | optional,
                keyArg
                  | String
                  | doc m%"
                  Specifies which field argument receives the merge key. This may be omitted for fields with only one argument where the recipient can be inferred.
                  "%
                  | optional,
                keyField
                  | String
                  | doc m%"
                  Specifies the name of a field to pick off origin objects as the key value. When omitted, a `@key` directive must be included on the return type's definition to be built into an object key.
                  https://www.graphql-tools.com/docs/stitch-directives-sdl#object-keys
                  "%
                  | optional,
                queryFieldName | String,
              },
          MergedTypeConfig = {
                canonical
                  | Bool
                  | doc m%"
                  Specifies types and fields
                  that provide a [canonical definition](https://www.graphql-tools.com/docs/stitch-type-merging#canonical-definitions) to be built into the gateway schema. Useful for selecting preferred characteristics among types and fields that overlap across subschemas. Root fields marked as canonical specify which subschema the field proxies for new queries entering the graph.
                  "%
                  | optional,
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.MergedTypeField
                  ])
                  | optional,
                key
                  | definitions.contract.KeyAnnotation
                  | doc m%"
                  Specifies a base selection set needed to merge the annotated type across subschemas.
                  Analogous to the `selectionSet` setting specified in [merged type configuration](https://www.graphql-tools.com/docs/stitch-type-merging#basic-example).
                  "%
                  | optional,
                typeName
                  | String
                  | doc m%"
                  Name of the type (Query by default)
                  "%
                  | optional,
              },
          MergedTypeField = {
                computed
                  | definitions.contract.ComputedAnnotation
                  | doc m%"
                  specifies a selection of fields required from other services to compute the value of this field.
                  These additional fields are only selected when the computed field is requested.
                  Analogous to [computed field](https://www.graphql-tools.com/docs/stitch-type-merging#computed-fields) in merged type configuration.
                  Computed field dependencies must be sent into the subservice using an [object key](https://www.graphql-tools.com/docs/stitch-directives-sdl#object-keys).
                  "%
                  | optional,
                fieldName | String,
              },
          MockingConfig = {
                "if"
                  | Bool
                  | doc m%"
                  If this expression is truthy, mocking would be enabled
                  You can use environment variables expression, for example: `process.env.MOCKING_ENABLED != null`
                  "%
                  | optional,
                initializeStore
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  The path to the code runs before the store is attached to the schema
                  "%
                  | optional,
                mocks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.MockingFieldConfig
                  ])
                  | doc m%"
                  Mock configurations
                  "%
                  | optional,
                preserveResolvers
                  | Bool
                  | doc m%"
                  Do not mock any other resolvers other than defined in `mocks`.
                  For example, you can enable this if you don't want to mock entire schema but partially.
                  "%
                  | optional,
              },
          MockingFieldConfig = {
                apply
                  | String
                  | doc m%"
                  Resolver path
                  Example: User.firstName
                  "%,
                custom
                  | String
                  | doc m%"
                  Custom mocking
                  It can be a module or json file.
                  Both "moduleName#exportName" or only "moduleName" would work
                  "%
                  | optional,
                faker
                  | String
                  | doc m%"
                  Faker.js expression or function
                  Read more (https://github.com/marak/Faker.js/#fakerfake)
                  Example:
                  faker: `name.firstName`
                  faker: `{{ name.firstName }} {{ name.lastName }}`
                  "%
                  | optional,
                "if"
                  | Bool
                  | doc m%"
                  If this expression is truthy, mocking would be enabled
                  You can use environment variables expression, for example: `${MOCKING_ENABLED}`
                  "%
                  | optional,
                length
                  | std.number.Integer
                  | doc m%"
                  Length of the mock list
                  For the list types `[ObjectType]`, how many `ObjectType` you want to return?
                  default: 2
                  "%
                  | optional,
                store
                  | definitions.contract.GetFromMockStoreConfig
                  | doc m%"
                  Get the data from the mock store
                  "%
                  | optional,
                updateStore
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.UpdateMockStoreConfig
                  ])
                  | doc m%"
                  Update the data on the mock store
                  "%
                  | optional,
              },
          MongooseHandler = {
                connectionString | String | optional,
                discriminators
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.MongooseModel
                  ])
                  | optional,
                models
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.MongooseModel
                  ])
                  | optional,
              },
          MongooseModel = {
                name | String,
                options
                  | definitions.contract.ComposeWithMongooseOpts
                  | optional,
                path | String,
              },
          MySQLHandler = {
                database
                  | String
                  | doc m%"
                  Name of the database to use for this connection
                  "%
                  | optional,
                host
                  | String
                  | doc m%"
                  The hostname of the database you are connecting to. (Default: localhost)
                  "%
                  | optional,
                localAddress
                  | String
                  | doc m%"
                  The source IP address to use for TCP connection
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  The password of that MySQL user
                  "%
                  | optional,
                pool
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  Use existing `Pool` instance
                  Format: modulePath#exportName
                  "%
                  | optional,
                port
                  | std.number.Integer
                  | doc m%"
                  The port number to connect to. (Default: 3306)
                  "%
                  | optional,
                ssl
                  | definitions.contract.MySQLSSLOptions
                  | doc m%"
                  SSL Options for your MySQL connection
                  "%
                  | optional,
                tableFields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.TableField
                  ])
                  | doc m%"
                  Use specific fields of specific tables
                  "%
                  | optional,
                tables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Use specific tables for your schema
                  "%
                  | optional,
                user
                  | String
                  | doc m%"
                  The MySQL user to authenticate as
                  "%
                  | optional,
              },
          MySQLSSLOptions = {
                ca
                  | String
                  | doc m%"
                  Path to your CA
                  "%
                  | optional,
                rejectUnauthorized
                  | Bool
                  | doc m%"
                  Default: true
                  "%
                  | optional,
              },
          NamingConventionTransformConfig = {
                enumValues
                  | std.enum.TagOrString
                  | [|
                    'lowerCase,
                    'upperCase,
                    'snakeCase,
                    'sentenceCase,
                    'pathCase,
                    'pascalCase,
                    'paramCase,
                    'noCase,
                    'headerCase,
                    'dotCase,
                    'constantCase,
                    'capitalCase,
                    'camelCase
                  |]
                  | doc m%"
                  Allowed values: camelCase, capitalCase, constantCase, dotCase, headerCase, noCase, paramCase, pascalCase, pathCase, sentenceCase, snakeCase, upperCase, lowerCase
                  "%
                  | optional,
                fieldArgumentNames
                  | std.enum.TagOrString
                  | [|
                    'lowerCase,
                    'upperCase,
                    'snakeCase,
                    'sentenceCase,
                    'pathCase,
                    'pascalCase,
                    'paramCase,
                    'noCase,
                    'headerCase,
                    'dotCase,
                    'constantCase,
                    'capitalCase,
                    'camelCase
                  |]
                  | doc m%"
                  Allowed values: camelCase, capitalCase, constantCase, dotCase, headerCase, noCase, paramCase, pascalCase, pathCase, sentenceCase, snakeCase, upperCase, lowerCase
                  "%
                  | optional,
                fieldNames
                  | std.enum.TagOrString
                  | [|
                    'lowerCase,
                    'upperCase,
                    'snakeCase,
                    'sentenceCase,
                    'pathCase,
                    'pascalCase,
                    'paramCase,
                    'noCase,
                    'headerCase,
                    'dotCase,
                    'constantCase,
                    'capitalCase,
                    'camelCase
                  |]
                  | doc m%"
                  Allowed values: camelCase, capitalCase, constantCase, dotCase, headerCase, noCase, paramCase, pascalCase, pathCase, sentenceCase, snakeCase, upperCase, lowerCase
                  "%
                  | optional,
                mode
                  | std.enum.TagOrString
                  | [| 'wrap, 'bare |]
                  | doc m%"
                  Specify to apply naming-convention transforms to bare schema or by wrapping original schema (Allowed values: bare, wrap)
                  "%
                  | optional,
                typeNames
                  | std.enum.TagOrString
                  | [|
                    'lowerCase,
                    'upperCase,
                    'snakeCase,
                    'sentenceCase,
                    'pathCase,
                    'pascalCase,
                    'paramCase,
                    'noCase,
                    'headerCase,
                    'dotCase,
                    'constantCase,
                    'capitalCase,
                    'camelCase
                  |]
                  | doc m%"
                  Allowed values: camelCase, capitalCase, constantCase, dotCase, headerCase, noCase, paramCase, pascalCase, pathCase, sentenceCase, snakeCase, upperCase, lowerCase
                  "%
                  | optional,
              },
          Neo4jHandler = {
                alwaysIncludeRelationships
                  | Bool
                  | doc m%"
                  Specifies whether relationships should always be included in the type definitions as [relationship](https://grandstack.io/docs/neo4j-graphql-js.html#relationship-types) types, even if the relationships do not have properties.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  Specifies database name
                  "%
                  | optional,
                endpoint
                  | String
                  | doc m%"
                  URL for the Neo4j Instance e.g. neo4j://localhost
                  "%,
                password
                  | String
                  | doc m%"
                  Password for basic authentication
                  "%,
                source
                  | String
                  | doc m%"
                  Provide GraphQL Type Definitions instead of inferring
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  Username for basic authentication
                  "%,
              },
          NewrelicConfig = {
                extractOperationName
                  | String
                  | doc m%"
                  Allows to set a custom operation name to be used as transaction name and attribute
                  `extractOperationName: {context.headers['x-operation-name']}`
                  "%
                  | optional,
                includeExecuteVariables
                  | Bool
                  | doc m%"
                  default `false`. When set to `true`, includes all the operation variables with their values
                  "%
                  | optional,
                includeOperationDocument
                  | Bool
                  | doc m%"
                  default `false`. When set to `true`, includes the GraphQL document defining the operations and fragments
                  "%
                  | optional,
                includeRawResult
                  | Bool
                  | doc m%"
                  default: `false`. When set to `true`, includes the execution result of both delegation and execution
                  "%
                  | optional,
                includeResolverArgs
                  | Bool
                  | doc m%"
                  default `false`. When set to `true`, includes all the arguments passed to resolvers and delegation with their values
                  "%
                  | optional,
                rootFieldsNaming
                  | Bool
                  | doc m%"
                  default `false`. When set to `true` append the names of operation root fields to the transaction name
                  "%
                  | optional,
                trackResolvers
                  | Bool
                  | doc m%"
                  default `false`. When set to `true`, track resolvers as segments to monitor their performance
                  "%
                  | optional,
              },
          OASSelectQueryOrMutationFieldConfig = {
                fieldName | String,
                type
                  | std.enum.TagOrString
                  | [| 'Mutation, 'Query, 'mutation, 'query |]
                  | doc m%"
                  Allowed values: query, mutation, Query, Mutation
                  "%,
              },
          ODataHandler = {
                batch
                  | std.enum.TagOrString
                  | [| 'json, 'multipart |]
                  | doc m%"
                  Enable batching (Allowed values: multipart, json)
                  "%
                  | optional,
                endpoint
                  | String
                  | doc m%"
                  Base URL for OData API
                  "%,
                expandNavProps
                  | Bool
                  | doc m%"
                  Use $expand for navigation props instead of seperate HTTP requests (Default: false)
                  "%
                  | optional,
                operationHeaders
                  | {  .. }
                  | doc m%"
                  Headers to be used with the operation requests
                  "%
                  | optional,
                schemaHeaders
                  | {  .. }
                  | doc m%"
                  Headers to be used with the $metadata requests
                  "%
                  | optional,
                source
                  | String
                  | doc m%"
                  Custom $metadata File or URL
                  "%
                  | optional,
              },
          OpenapiHandler = {
                bundle | Bool | optional,
                endpoint
                  | String
                  | doc m%"
                  Specifies the URL on which all paths will be based on.
                  Overrides the server object in the OAS.
                  "%
                  | optional,
                fallbackFormat
                  | std.enum.TagOrString
                  | [| 'ts, 'js, 'yaml, 'json |]
                  | doc m%"
                  Format of the files referenced from the source file, for cases content type isn't detected automatically (Allowed values: json, yaml, js, ts)
                  "%
                  | optional,
                ignoreErrorResponses
                  | Bool
                  | doc m%"
                  Responses are converted to a Union type grouping all possible responses.
                  Applying this will ignore all responses with status code other than 2xx, resulting in simpler response types, usualy regular object type instead of union.
                  Default: false
                  "%
                  | optional,
                operationHeaders
                  | {  .. }
                  | doc m%"
                  JSON object representing the Headers to add to the runtime of the API calls
                  "%
                  | optional,
                queryParams
                  | {  .. }
                  | doc m%"
                  JSON object representing the query search parameters to add to the API calls
                  "%
                  | optional,
                schemaHeaders
                  | {  .. }
                  | doc m%"
                  If you are using a remote URL endpoint to fetch your schema, you can set headers for the HTTP request to fetch your schema.
                  "%
                  | optional,
                selectQueryOrMutationField
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.OASSelectQueryOrMutationFieldConfig
                  ])
                  | doc m%"
                  Allows to explicitly override the default operation (Query or Mutation) for any OAS operation
                  "%
                  | optional,
                source
                  | String
                  | doc m%"
                  A pointer to your API source (Support both JSON and YAML) - could be a local file, remote file or url endpoint
                  "%,
                timeout
                  | std.number.Integer
                  | doc m%"
                  Timeout for the HTTP request in milliseconds
                  "%
                  | optional,
              },
          OperationFieldPermission = {
                allow
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                "if" | String | optional,
              },
          OperationFieldPermissionsConfig = {
                permissions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.OperationFieldPermission
                  ])
                  | optional,
              },
          PaginationResolverOpts = { perPage | std.number.Integer | optional, },
          Plugin = {
                deduplicateRequest
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                hive | definitions.contract.HivePlugin | optional,
                httpCache | definitions.contract.HTTPCachePlugin | optional,
                httpDetailsExtensions
                  | definitions.contract.HTTPDetailsExtensionsConfig
                  | optional,
                immediateIntrospection
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                liveQuery | definitions.contract.LiveQueryConfig | optional,
                maskedErrors
                  | definitions.contract.MaskedErrorsPluginConfig
                  | optional,
                mock
                  | definitions.contract.MockingConfig
                  | doc m%"
                  Mock configuration for your source
                  "%
                  | optional,
                newrelic | definitions.contract.NewrelicConfig | optional,
                operationFieldPermissions
                  | definitions.contract.OperationFieldPermissionsConfig
                  | optional,
                prometheus | definitions.contract.PrometheusConfig | optional,
                rateLimit
                  | definitions.contract.RateLimitPluginConfig
                  | doc m%"
                  RateLimit plugin
                  "%
                  | optional,
                responseCache
                  | definitions.contract.ResponseCacheConfig
                  | optional,
                serializeHeaders
                  | definitions.contract.SerializeHeadersConfig
                  | optional,
                snapshot
                  | definitions.contract.SnapshotPluginConfig
                  | doc m%"
                  Configuration for Snapshot extension
                  "%
                  | optional,
                statsd | definitions.contract.StatsdPlugin | optional,
                ..
              },
          PostGraphileHandler = {
                appendPlugins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Extra Postgraphile Plugins to append
                  "%
                  | optional,
                connectionString
                  | String
                  | doc m%"
                  A connection string to your Postgres database
                  "%
                  | optional,
                contextOptions
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  A file that exports a function which takes context as a paramter and returns postgraphile context options (e.g. "./my-function#pgSettings"). See the [postgraphile docs](https://www.graphile.org/postgraphile/usage-schema/) for more information.
                  "%
                  | optional,
                live
                  | Bool
                  | doc m%"
                  Enables live-query support via GraphQL subscriptions (sends updated payload any time nested collections/records change) (default: true)
                  "%
                  | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Record, predicates.isType '"String" ])
                  | doc m%"
                  Extra Postgraphile options that will be added to the postgraphile constructor. It can either be an object or a string pointing to the object's path (e.g. "./my-config#options"). See the [postgraphile docs](https://www.graphile.org/postgraphile/usage-library/) for more information. (Any of: JSON, String)
                  "%
                  | optional,
                pool
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  Connection Pool instance or settings or you can provide the path of a code file that exports any of those
                  "%
                  | optional,
                schemaName
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of strings which specifies the PostgreSQL schemas that PostGraphile will use to create a GraphQL schema. The default schema is the public schema.
                  "%
                  | optional,
                skipPlugins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Postgraphile Plugins to skip (e.g. "graphile-build#NodePlugin")
                  "%
                  | optional,
                subscriptions
                  | Bool
                  | doc m%"
                  Enable GraphQL websocket transport support for subscriptions (default: true)
                  "%
                  | optional,
              },
          PrefixTransformConfig = {
                ignore
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of ignored types
                  "%
                  | optional,
                includeRootOperations
                  | Bool
                  | doc m%"
                  Changes root types and changes the field names (default: false)
                  "%
                  | optional,
                includeTypes
                  | Bool
                  | doc m%"
                  Changes types (default: true)
                  "%
                  | optional,
                mode
                  | std.enum.TagOrString
                  | [| 'wrap, 'bare |]
                  | doc m%"
                  Specify to apply prefix transform to bare schema or by wrapping original schema (Allowed values: bare, wrap)
                  "%
                  | optional,
                value
                  | String
                  | doc m%"
                  The prefix to apply to the schema types. By default it's the API name.
                  "%
                  | optional,
              },
          PrometheusConfig = {
                contextBuilding
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Any of: Boolean, String
                  "%
                  | optional,
                delegation
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Any of: Boolean, String
                  "%
                  | optional,
                deprecatedFields
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Any of: Boolean, String
                  "%
                  | optional,
                endpoint
                  | String
                  | doc m%"
                  The path to the metrics endpoint
                  default: `/metrics`
                  "%
                  | optional,
                errors
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Any of: Boolean, String
                  "%
                  | optional,
                execute
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Any of: Boolean, String
                  "%
                  | optional,
                fetch
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Any of: Boolean, String
                  "%
                  | optional,
                fetchRequestHeaders | Bool | optional,
                fetchResponseHeaders | Bool | optional,
                http
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Any of: Boolean, String
                  "%
                  | optional,
                httpRequestHeaders | Bool | optional,
                httpResponseHeaders | Bool | optional,
                parse
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Any of: Boolean, String
                  "%
                  | optional,
                registry | String | optional,
                requestCount
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Any of: Boolean, String
                  "%
                  | optional,
                requestSummary
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Any of: Boolean, String
                  "%
                  | optional,
                requestTotalDuration
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Any of: Boolean, String
                  "%
                  | optional,
                skipIntrospection | Bool | optional,
                validate
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"String" ])
                  | doc m%"
                  Any of: Boolean, String
                  "%
                  | optional,
              },
          ProtoFilePath = {
                file | String,
                load | definitions.contract.LoadOptions | optional,
              },
          PruneTransformConfig = {
                skipEmptyCompositeTypePruning
                  | Bool
                  | doc m%"
                  Set to `true` to skip pruning object types or interfaces with no fields
                  "%
                  | optional,
                skipEmptyUnionPruning
                  | Bool
                  | doc m%"
                  Set to `true` to skip pruning empty unions
                  "%
                  | optional,
                skipPruning
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Types to skip pruning
                  "%
                  | optional,
                skipUnimplementedInterfacesPruning
                  | Bool
                  | doc m%"
                  Set to `true` to skip pruning interfaces that are not implemented by any other types
                  "%
                  | optional,
                skipUnusedTypesPruning
                  | Bool
                  | doc m%"
                  Set to `true` to skip pruning unused types
                  "%
                  | optional,
              },
          PubSubConfig = {
                config
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                name | String,
              },
          QueryStringOptions = {
                arrayFormat
                  | std.enum.TagOrString
                  | [| 'comma, 'repeat, 'brackets, 'indices |]
                  | doc m%"
                  You can configure how to format arrays in the query strings.
                  
                  Note: when using arrayFormat set to 'comma', you can also pass the commaRoundTrip option set to true or false, to append [] on single-item arrays, so that they can round trip through a parse. (Allowed values: indices, brackets, repeat, comma)
                  "%
                  | optional,
                commaRoundTrip
                  | Bool
                  | doc m%"
                  Even if there is a single item in an array, this option treats them as arrays
                  (default: false)
                  "%
                  | optional,
                indices
                  | Bool
                  | doc m%"
                  When arrays are stringified, by default they are not given explicit indices:
                  `a=b&a=c&a=d`
                  You may override this by setting the indices option to true:
                  `a[0]=b&a[1]=c&a[2]=d`
                  "%
                  | optional,
              },
          RAMLHandler = {
                bundle | Bool | optional,
                endpoint | String | optional,
                ignoreErrorResponses | Bool | optional,
                operationHeaders | {  .. } | optional,
                queryParams
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                schemaHeaders | {  .. } | optional,
                selectQueryOrMutationField
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.RAMLSelectQueryOrMutationFieldConfig
                  ])
                  | optional,
                source | String,
                timeout
                  | std.number.Integer
                  | doc m%"
                  Timeout for the HTTP request in milliseconds
                  "%
                  | optional,
              },
          RAMLSelectQueryOrMutationFieldConfig = {
                fieldName | String,
                type
                  | std.enum.TagOrString
                  | [| 'Mutation, 'Query, 'mutation, 'query |]
                  | doc m%"
                  Allowed values: query, mutation, Query, Mutation
                  "%,
              },
          RateLimitPluginConfig = {
                config
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.RateLimitTransformConfig
                  ]),
              },
          RateLimitTransformConfig = {
                field
                  | String
                  | doc m%"
                  The field of the type that the rate limit is applied to
                  "%,
                identifier
                  | String
                  | doc m%"
                  The identifier expression that determines the identity of the request (e.g. `{context.req.socket.remoteAddress}`)
                  "%,
                max
                  | std.number.Integer
                  | doc m%"
                  The maximum number of requests that can be made in a given time period
                  "%,
                ttl
                  | std.number.Integer
                  | doc m%"
                  The time period in which the rate limit is applied
                  "%,
                type
                  | String
                  | doc m%"
                  The type name that the following field belongs to
                  "%,
              },
          RecordHelperArgsOpts = {
                isRequired | Bool | optional,
                recordTypeName | String | optional,
                removeFields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                requiredFields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          RedisConfig = {
                host | String | optional,
                lazyConnect
                  | Bool
                  | doc m%"
                  Flag to indicate lazyConnect value for Redis client.
                  
                  @default: true
                  "%
                  | optional,
                password | String | optional,
                port | String | optional,
                url | String | optional,
              },
          RenameConfig = {
                argument | String | optional,
                field | String | optional,
                type | String | optional,
              },
          RenameTransform = {
                mode
                  | std.enum.TagOrString
                  | [| 'wrap, 'bare |]
                  | doc m%"
                  Specify to apply rename transforms to bare schema or by wrapping original schema (Allowed values: bare, wrap)
                  "%
                  | optional,
                renames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.RenameTransformObject
                  ])
                  | doc m%"
                  Array of rename rules
                  "%,
              },
          RenameTransformObject = {
                from | definitions.contract.RenameConfig,
                includeDefaults
                  | Bool
                  | doc m%"
                  Flag to indicate whether certain default types (built-ins, scalars and other types specified an exclusion list) should be renamed or not.
                  
                  @default: false
                  "%
                  | optional,
                regExpFlags
                  | String
                  | doc m%"
                  Flags to use in the Regular Expression
                  "%
                  | optional,
                to | definitions.contract.RenameConfig,
                useRegExpForArguments
                  | Bool
                  | doc m%"
                  Use Regular Expression for field names
                  "%
                  | optional,
                useRegExpForFields
                  | Bool
                  | doc m%"
                  Use Regular Expression for field names
                  "%
                  | optional,
                useRegExpForTypes
                  | Bool
                  | doc m%"
                  Use Regular Expression for type names
                  "%
                  | optional,
              },
          ReplaceFieldConfig = { field | String, type | String, },
          ReplaceFieldTransformConfig = {
                replacements
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ReplaceFieldTransformObject
                  ])
                  | doc m%"
                  Array of rules to replace fields
                  "%,
                typeDefs
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  Additional type definition to used to replace field types
                  "%
                  | optional,
              },
          ReplaceFieldTransformObject = {
                composer
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                from | definitions.contract.ReplaceFieldConfig,
                name | String | optional,
                scope
                  | std.enum.TagOrString
                  | [| 'hoistValue, 'config |]
                  | doc m%"
                  Allowed values: config, hoistValue
                  "%
                  | optional,
                to | definitions.contract.ReplaceFieldConfig,
              },
          ResolveReferenceObject = {
                args
                  | {  .. }
                  | doc m%"
                  You need configure the arguments for that field;
                  ```yaml
                  args:
                    someArg: "{root.someKeyValue}"
                  ```
                  "%
                  | optional,
                queryFieldName
                  | String
                  | doc m%"
                  Name of root field name that resolves the reference
                  "%,
              },
          ResolversCompositionTransform = {
                compositions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ResolversCompositionTransformObject
                  ])
                  | doc m%"
                  Array of resolver/composer to apply
                  "%,
                mode
                  | std.enum.TagOrString
                  | [| 'wrap, 'bare |]
                  | doc m%"
                  Specify to apply resolvers-composition transforms to bare schema or by wrapping original schema (Allowed values: bare, wrap)
                  "%
                  | optional,
              },
          ResolversCompositionTransformObject = {
                composer
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  Path to the composer function
                  Example: ./src/auth.js#authComposer
                  "%,
                resolver
                  | String
                  | doc m%"
                  The GraphQL Resolver path
                  Example: Query.users
                  "%,
              },
          ResponseCacheConfig = {
                cacheKey
                  | String
                  | doc m%"
                  Customize the behavior how the response cache key is computed from the documentString, variableValues, contextValue and sessionId.
                  If the given string is interpolated as empty, default behavior is used.
                  Example;
                  ```yaml
                  # Cache by specific value
                  cacheKey: "{variableValues.userId}"
                  
                  # Cache by documentString
                  cacheKey: "{documentString}"
                  
                  # Cache by operationName
                  cacheKey: "{operationName}"
                  
                  # Cache by some header value
                  cacheKey: "{contextValue.headers.authorization}"
                  
                  # Or combine two of each
                  cacheKey: "{contextValue.headers.authorization}-{operationName}"
                  ```
                  "%
                  | optional,
                idFields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of fields that are used to identify the entity.
                  "%
                  | optional,
                "if"
                  | String
                  | doc m%"
                  Specify whether the cache should be used based on the context.
                  ```yaml
                  if: "context.headers.userId != null"
                  ```
                  "%
                  | optional,
                ignoredTypes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Skip caching of following the types.
                  "%
                  | optional,
                includeExtensionMetadata
                  | Bool
                  | doc m%"
                  Include extension values that provide useful information, such as whether the cache was hit or which resources a mutation invalidated.
                  "%
                  | optional,
                invalidateViaMutation
                  | Bool
                  | doc m%"
                  Whether the mutation execution result should be used for invalidating resources.
                  Defaults to `true`
                  "%
                  | optional,
                sessionId
                  | String
                  | doc m%"
                  Allows to cache responses based on the resolved session id.
                  Return a unique value for each session.
                  Creates a global session by default.
                  Example;
                  ```yaml
                  sessionId: "{context.headers.userId}"
                  ```
                  "%
                  | optional,
                shouldCacheResult
                  | String
                  | doc m%"
                  Checks if the result should be cached.
                  ```yaml
                  shouldCacheResult: "result.errors.length > 0"
                  ```
                  "%
                  | optional,
                ttl
                  | Number
                  | doc m%"
                  Maximum age in ms. Defaults to `Infinity`. Set it to 0 for disabling the global TTL.
                  "%
                  | optional,
                ttlPerCoordinate
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ResponseCacheTTLConfig
                  ])
                  | doc m%"
                  Overwrite the ttl for query operations whose selection contains a specific schema coordinate (e.g. Query.users).
                  Useful if the selection of a specific field should reduce the TTL of the query operation.
                  "%
                  | optional,
              },
          ResponseCacheTTLConfig = { coordinate | String, ttl | Number, },
          SDKConfig = {
                generateOperations
                  | definitions.contract.GenerateOperationsConfig
                  | doc m%"
                  Use this only if you don't want to use `documents` for SDK,
                  and let Mesh generate them for you
                  "%
                  | optional,
              },
          SerializeHeadersConfig = {
                names
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
              },
          ServeConfig = {
                batchingLimit
                  | std.number.Integer
                  | doc m%"
                  Enable and define a limit for [Request Batching](https://github.com/graphql/graphql-over-http/blob/main/rfcs/Batching.md)
                  "%
                  | optional,
                browser
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Path to the browser that will be used by `mesh serve` to open a playground window in development mode
                  This feature can be disabled by passing `false` (Any of: String, Boolean)
                  "%
                  | optional,
                cors
                  | definitions.contract.CorsConfig
                  | doc m%"
                  Configuration for CORS
                  "%
                  | optional,
                endpoint
                  | String
                  | doc m%"
                  Path to GraphQL Endpoint (default: /graphql)
                  "%
                  | optional,
                fork
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType '"Bool" ])
                  | doc m%"
                  Spawn multiple server instances as node clusters (default: `1`) (Any of: Int, Boolean)
                  "%
                  | optional,
                hostname
                  | String
                  | doc m%"
                  The binding hostname (default: `localhost`)
                  "%
                  | optional,
                playground
                  | Bool
                  | doc m%"
                  Show GraphiQL Playground
                  "%
                  | optional,
                playgroundTitle
                  | String
                  | doc m%"
                  Title of GraphiQL Playground
                  "%
                  | optional,
                port
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType '"String" ])
                  | doc m%"
                  TCP Port to listen (default: `4000`) (Any of: Int, String)
                  "%
                  | optional,
                sslCredentials
                  | definitions.contract.HTTPSConfig
                  | doc m%"
                  SSL Credentials for HTTPS Server
                  If this is provided, Mesh will be served via HTTPS
                  "%
                  | optional,
                staticFiles
                  | String
                  | doc m%"
                  Path to your static files you want to be served with GraphQL Mesh HTTP Server
                  "%
                  | optional,
                trustProxy
                  | String
                  | doc m%"
                  Configure Express Proxy Handling
                  [Learn more](https://expressjs.com/en/guide/behind-proxies.html)
                  "%
                  | optional,
              },
          SnapshotPluginConfig = {
                apply
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  HTTP URL pattern to be applied
                  For example;
                    apply:
                        - http://my-remote-api.com/* \<- * will apply this extension to all paths of remote API
                  "%,
                "if"
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Expression for when to activate this extension.
                  Value can be a valid JS expression string or a boolean (Any of: String, Boolean)
                  "%
                  | optional,
                outputDir
                  | String
                  | doc m%"
                  Path to the directory of the generated snapshot files
                  "%,
              },
          SoapHandler = {
                operationHeaders
                  | {  .. }
                  | doc m%"
                  JSON object representing the Headers to add to the runtime of the API calls only for operation during runtime
                  "%
                  | optional,
                schemaHeaders
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  JSON object representing the Headers to add to the runtime of the API calls only for schema introspection
                  You can also provide `.js` or `.ts` file path that exports schemaHeaders as an object
                  "%
                  | optional,
                source
                  | String
                  | doc m%"
                  A url to your WSDL or generated SDL with annotations
                  "%,
              },
          SortHelperArgsOpts = { sortTypeName | String | optional, },
          Source = {
                handler
                  | definitions.contract.Handler
                  | doc m%"
                  Point to the handler you wish to use, it can either be a predefined handler, or a custom
                  "%,
                name
                  | String
                  | doc m%"
                  The name you wish to set to your remote API, this will be used for building the GraphQL context
                  "%,
                transforms
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  List of transforms to apply to the current API source, before unifying it with the rest of the sources
                  "%
                  | optional,
              },
          StatsdClientBufferHolder = { buffer | String, },
          StatsdClientConfiguration = {
                bufferFlushInterval | std.number.Integer | optional,
                bufferHolder
                  | definitions.contract.StatsdClientBufferHolder
                  | optional,
                cacheDns | Bool | optional,
                cacheDnsTtl | std.number.Integer | optional,
                closingFlushInterval | std.number.Integer | optional,
                globalTags | {  .. } | optional,
                globalize | Bool | optional,
                host | String | optional,
                isChild | Bool | optional,
                maxBufferSize | std.number.Integer | optional,
                mock | Bool | optional,
                path | String | optional,
                port | std.number.Integer | optional,
                protocol
                  | std.enum.TagOrString
                  | [| 'stream, 'uds, 'udp, 'tcp |]
                  | doc m%"
                  Allowed values: tcp, udp, uds, stream
                  "%
                  | optional,
                sampleRate | Number | optional,
                suffix | String | optional,
                tagPrefix | String | optional,
                tagSeperator | String | optional,
                tcpGracefulErrorHandling | Bool | optional,
                tcpGracefulRestartRateLimit | std.number.Integer | optional,
                telegraf | Bool | optional,
                udsGracefulErrorHandling | Bool | optional,
                udsGracefulRestartRateLimit | std.number.Integer | optional,
                useDefaultRoute | Bool | optional,
              },
          StatsdPlugin = {
                client
                  | definitions.contract.StatsdClientConfiguration
                  | doc m%"
                  Client Configuration
                  "%
                  | optional,
                prefix
                  | String
                  | doc m%"
                  prefix.operations.count (default: graphql)
                  "%
                  | optional,
                skipIntrospection
                  | Bool
                  | doc m%"
                  If you wish to disable introspection for logging (default: false)
                  "%
                  | optional,
              },
          SupergraphHandler = {
                schemaHeaders
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | optional,
                source
                  | String
                  | doc m%"
                  A file path to your Supergraph Schema
                  If you provide a path to a code file(js or ts),
                  other options will be ignored and the schema exported from the file will be used directly.
                  "%,
              },
          TableField = {
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
                table | String,
              },
          ThriftHandler = {
                hostName
                  | String
                  | doc m%"
                  The name of the host to connect to.
                  "%,
                https
                  | Bool
                  | doc m%"
                  Boolean value indicating whether to use https. Defaults to false.
                  "%
                  | optional,
                idl
                  | String
                  | doc m%"
                  Path to IDL file
                  "%,
                operationHeaders
                  | {  .. }
                  | doc m%"
                  JSON object representing the Headers to add to the runtime of the API calls
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  The path on which the Thrift service is listening. Defaults to '/thrift'.
                  "%
                  | optional,
                port
                  | std.number.Integer
                  | doc m%"
                  The port number to attach to on the host.
                  "%,
                protocol
                  | std.enum.TagOrString
                  | [| 'json, 'compact, 'binary |]
                  | doc m%"
                  Name of the Thrift protocol type to use. Defaults to 'binary'. (Allowed values: binary, compact, json)
                  "%
                  | optional,
                schemaHeaders
                  | {  .. }
                  | doc m%"
                  If you are using a remote URL endpoint to fetch your schema, you can set headers for the HTTP request to fetch your schema.
                  "%
                  | optional,
                serviceName
                  | String
                  | doc m%"
                  The name of your service. Used for logging.
                  "%,
              },
          TransferSchemaTransformConfig = {
                transfers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.TransferSchemaTransformObject
                  ])
                  | doc m%"
                  Array of rules to transfer fields or args
                  "%,
              },
          TransferSchemaTransformObject = {
                action
                  | std.enum.TagOrString
                  | [| 'copy, 'move |]
                  | doc m%"
                  Allowed values: move, copy
                  "%
                  | optional,
                from | String,
                to | String,
              },
          Transform = {
                cache
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.CacheTransformConfig
                  ])
                  | doc m%"
                  Transformer to apply caching for your data sources
                  "%
                  | optional,
                encapsulate
                  | definitions.contract.EncapsulateTransformObject
                  | doc m%"
                  Transformer to apply encapsulation to the API source, by creating a field for it under the root query
                  "%
                  | optional,
                extend | definitions.contract.ExtendTransform | optional,
                federation
                  | definitions.contract.FederationTransform
                  | optional,
                filterSchema
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FilterSchemaTransform,
                    predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                      predicates.isType '"String",
                      predicates.isType '"Array"
                    ]
                  ])
                  | doc m%"
                  Transformer to filter (white/black list) GraphQL types, fields and arguments (Any of: FilterSchemaTransform, Any)
                  "%
                  | optional,
                hoistField
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.HoistFieldTransformConfig
                  ])
                  | doc m%"
                  Transformer to hoist GraphQL fields
                  "%
                  | optional,
                namingConvention
                  | definitions.contract.NamingConventionTransformConfig
                  | doc m%"
                  Transformer to apply naming convention to GraphQL Types
                  "%
                  | optional,
                prefix
                  | definitions.contract.PrefixTransformConfig
                  | doc m%"
                  Prefix transform
                  "%
                  | optional,
                prune
                  | definitions.contract.PruneTransformConfig
                  | doc m%"
                  Prune transform
                  "%
                  | optional,
                rateLimit
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.RateLimitTransformConfig
                  ])
                  | doc m%"
                  RateLimit transform
                  "%
                  | optional,
                rename
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.RenameTransform,
                    predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                      predicates.isType '"String",
                      predicates.isType '"Array"
                    ]
                  ])
                  | doc m%"
                  Transformer to rename GraphQL types and fields (Any of: RenameTransform, Any)
                  "%
                  | optional,
                replaceField
                  | definitions.contract.ReplaceFieldTransformConfig
                  | doc m%"
                  Transformer to replace GraphQL field with partial of full config from a different field
                  "%
                  | optional,
                resolversComposition
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ResolversCompositionTransform,
                    predicates.anyOf
                    [
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                      predicates.isType '"String",
                      predicates.isType '"Array"
                    ]
                  ])
                  | doc m%"
                  Transformer to apply composition to resolvers (Any of: ResolversCompositionTransform, Any)
                  "%
                  | optional,
                transferSchema
                  | definitions.contract.TransferSchemaTransformConfig
                  | doc m%"
                  Transformer to transfer (move or copy) GraphQL parts of GraphQL schema across Types and Fields
                  "%
                  | optional,
                typeMerging
                  | definitions.contract.TypeMergingConfig
                  | doc m%"
                  [Type Merging](https://www.graphql-tools.com/docs/stitch-type-merging) Configuration
                  "%
                  | optional,
                ..
              },
          TuqlHandler = {
                db
                  | String
                  | doc m%"
                  Pointer to your SQLite database
                  "%
                  | optional,
                infile
                  | String
                  | doc m%"
                  Path to the SQL Dump file if you want to build a in-memory database
                  "%
                  | optional,
              },
          TypeConverterResolversOpts = {
                connection
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Record ])
                  | doc m%"
                  Any of: Boolean, JSON
                  "%
                  | optional,
                count
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
                createMany
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
                createOne
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
                findById
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
                findByIds
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
                findMany
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
                findOne
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
                pagination
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.PaginationResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, PaginationResolverOpts
                  "%
                  | optional,
                removeById
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
                removeMany
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
                removeOne
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
                updateById
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
                updateMany
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
                updateOne
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.ComposeWithMongooseResolverOpts
                  ])
                  | doc m%"
                  Any of: Boolean, ComposeWithMongooseResolverOpts
                  "%
                  | optional,
              },
          TypeMergingConfig = {
                additionalConfiguration
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true predicates.always
                    ],
                    predicates.isType '"String",
                    predicates.isType '"Array"
                  ])
                  | doc m%"
                  The path to a code file that has additional type merging configuration
                  "%
                  | optional,
                queryFields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.MergedRootFieldConfig
                  ])
                  | doc m%"
                  Denotes a root field used to query a merged type across services.
                  The marked field's name is analogous
                  to the fieldName setting in
                  [merged type configuration](https://www.graphql-tools.com/docs/stitch-type-merging#basic-example),
                  while the field's arguments and return type are used to infer merge configuration.
                  Directive arguments tune the merge behavior
                  "%
                  | optional,
                types
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.MergedTypeConfig
                  ])
                  | optional,
              },
          URLPatternObj = {
                baseURL | String | optional,
                hash | String | optional,
                hostname | String | optional,
                password | String | optional,
                pathname | String | optional,
                port | String | optional,
                protocol | String | optional,
                search | String | optional,
                username | String | optional,
              },
          UpdateMockStoreConfig = {
                fieldName | String | optional,
                key | String | optional,
                type | String | optional,
                value | String | optional,
              },
        },
    predicate = {
          AdditionalStitchingBatchResolverObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "keyField",
                  "keysArg",
                  "sourceFieldName",
                  "sourceName",
                  "sourceTypeName",
                  "targetFieldName",
                  "targetTypeName"
                ],
                predicates.records.record
                {
                  additionalArgs = predicates.isType 'Record,
                  keyField = predicates.isType '"String",
                  keysArg = predicates.isType '"String",
                  requiredSelectionSet = predicates.isType '"String",
                  result = predicates.isType '"String",
                  resultType = predicates.isType '"String",
                  sourceFieldName = predicates.isType '"String",
                  sourceName = predicates.isType '"String",
                  sourceSelectionSet = predicates.isType '"String",
                  sourceTypeName = predicates.isType '"String",
                  targetFieldName = predicates.isType '"String",
                  targetTypeName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          AdditionalStitchingResolverObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "sourceFieldName",
                  "sourceName",
                  "sourceTypeName",
                  "targetFieldName",
                  "targetTypeName"
                ],
                predicates.records.record
                {
                  requiredSelectionSet = predicates.isType '"String",
                  result = predicates.isType '"String",
                  resultType = predicates.isType '"String",
                  sourceArgs = predicates.isType 'Record,
                  sourceFieldName = predicates.isType '"String",
                  sourceName = predicates.isType '"String",
                  sourceSelectionSet = predicates.isType '"String",
                  sourceTypeName = predicates.isType '"String",
                  targetFieldName = predicates.isType '"String",
                  targetTypeName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          AdditionalSubscriptionObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "pubsubTopic", "targetFieldName", "targetTypeName" ],
                predicates.records.record
                {
                  filterBy = predicates.isType '"String",
                  pubsubTopic = predicates.isType '"String",
                  result = predicates.isType '"String",
                  targetFieldName = predicates.isType '"String",
                  targetTypeName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CFWorkersKVCacheConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "namespace" ],
                predicates.records.record
                { namespace = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          Cache = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cfwKv = definitions.predicate.CFWorkersKVCacheConfig,
                  file = definitions.predicate.FileCacheConfig,
                  localforage = definitions.predicate.LocalforageConfig,
                  redis = definitions.predicate.RedisConfig,
                }
                {  }
                true
                predicates.always
              ],
          CacheEffectingOperationConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "operation" ],
                predicates.records.record
                {
                  matchKey = predicates.isType '"String",
                  operation = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CacheInvalidateConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  effectingOperations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.CacheEffectingOperationConfig
                      ],
                  ttl = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          CacheTransformConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "field" ],
                predicates.records.record
                {
                  cacheKey = predicates.isType '"String",
                  field = predicates.isType '"String",
                  invalidate = definitions.predicate.CacheInvalidateConfig,
                }
                {  }
                false
                predicates.never
              ],
          ComposeMongooseInputType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  fields = definitions.predicate.ComposeWithMongooseFieldsOpts,
                  name = predicates.isType '"String",
                  resolvers = definitions.predicate.TypeConverterResolversOpts,
                }
                {  }
                false
                predicates.never
              ],
          ComposeWithMongooseFieldsOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  only = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  remove = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  required = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ComposeWithMongooseOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  fields = definitions.predicate.ComposeWithMongooseFieldsOpts,
                  inputType = definitions.predicate.ComposeMongooseInputType,
                  name = predicates.isType '"String",
                  resolvers = definitions.predicate.TypeConverterResolversOpts,
                }
                {  }
                false
                predicates.never
              ],
          ComposeWithMongooseResolverOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  filter = definitions.predicate.FilterHelperArgsOpts,
                  limit = definitions.predicate.LimitHelperArgsOpts,
                  record = definitions.predicate.RecordHelperArgsOpts,
                  skip = predicates.isType '"Bool",
                  sort = definitions.predicate.SortHelperArgsOpts,
                }
                {  }
                false
                predicates.never
              ],
          ComputedAnnotation = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "selectionSet" ],
                predicates.records.record
                { selectionSet = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          CorsConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowedHeaders = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  credentials = predicates.isType '"Bool",
                  exposedHeaders = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  maxAge = predicates.isType 'Integer,
                  optionsSuccessStatus = predicates.isType 'Integer,
                  origin = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  preflightContinue = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          EncapsulateTransformApplyTo = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  mutation = predicates.isType '"Bool",
                  query = predicates.isType '"Bool",
                  subscription = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          EncapsulateTransformObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  applyTo = definitions.predicate.EncapsulateTransformApplyTo,
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ExtendTransform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  resolvers = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  typeDefs = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FederationField = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config", "name" ],
                predicates.records.record
                {
                  config = definitions.predicate.FederationFieldConfig,
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FederationFieldConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  external = predicates.isType '"Bool",
                  inaccessible = predicates.isType '"Bool",
                  override =
                    definitions.predicate.FederationFieldOverrideConfig,
                  provides =
                    definitions.predicate.FederationFieldProvidesConfig,
                  requires =
                    definitions.predicate.FederationFieldRequiresConfig,
                  tag = definitions.predicate.FederationFieldTagConfig,
                }
                {  }
                false
                predicates.never
              ],
          FederationFieldOverrideConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { from = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          FederationFieldProvidesConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { fields = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          FederationFieldRequiresConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { fields = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          FederationFieldTagConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { name = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          FederationObjectConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  extends = predicates.isType '"Bool",
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.FederationField
                      ],
                  key = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.FederationObjectKeyConfig
                      ],
                  resolveReference = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.ResolveReferenceObject
                      ],
                  shareable = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          FederationObjectKeyConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { fields = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          FederationTransform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  types = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.FederationTransformType
                      ],
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FederationTransformType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  config = definitions.predicate.FederationObjectConfig,
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FileCacheConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { path = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          FilterHelperArgsOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  filterTypeName = predicates.isType '"String",
                  isRequired = predicates.isType '"Bool",
                  onlyIndexed = predicates.isType '"Bool",
                  operators = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Record ],
                  removeFields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  requiredFields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FilterSchemaTransform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "filters" ],
                predicates.records.record
                {
                  filters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  mode = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "bare", "wrap" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          GenerateOperationsConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { selectionSetDepth = predicates.isType 'Integer, }
                {  }
                false
                predicates.never
              ],
          GetFromMockStoreConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fieldName = predicates.isType '"String",
                  key = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GraphQLHandlerCodeFirstConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "source" ],
                predicates.records.record
                {
                  source = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          GraphQLHandlerHTTPConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "endpoint" ],
                predicates.records.record
                {
                  batch = predicates.isType '"Bool",
                  connectionParams = predicates.isType 'Record,
                  credentials = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "omit", "include" ]
                      ],
                  endpoint = predicates.isType '"String",
                  method = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "GET", "POST" ]
                      ],
                  operationHeaders = predicates.isType 'Record,
                  retry = predicates.isType 'Integer,
                  schemaHeaders = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  source = predicates.isType '"String",
                  subscriptionsEndpoint = predicates.isType '"String",
                  subscriptionsProtocol = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "SSE", "WS", "LEGACY_WS" ]
                      ],
                  timeout = predicates.isType 'Integer,
                  useGETForQueries = predicates.isType '"Bool",
                  webSocketImpl = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GraphQLHandlerMultipleHTTPConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "sources" ],
                predicates.records.record
                {
                  sources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.GraphQLHandlerHTTPConfiguration
                      ],
                  strategy = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "fallback", "race", "highestValue" ]
                      ],
                  strategyConfig =
                    definitions.predicate.GraphQLHandlerhighestValueStrategyConfig,
                }
                {  }
                false
                predicates.never
              ],
          GraphQLHandlerhighestValueStrategyConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "selectionSet", "value" ],
                predicates.records.record
                {
                  selectionSet = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GrpcCredentialsSsl = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  certChain = predicates.isType '"String",
                  privateKey = predicates.isType '"String",
                  rootCA = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GrpcHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "endpoint" ],
                predicates.records.record
                {
                  credentialsSsl = definitions.predicate.GrpcCredentialsSsl,
                  endpoint = predicates.isType '"String",
                  metaData = predicates.isType 'Record,
                  prefixQueryMethod = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  requestTimeout = predicates.isType 'Integer,
                  schemaHeaders = predicates.isType 'Record,
                  source = predicates.anyOf
                      [
                        definitions.predicate.ProtoFilePath,
                        predicates.isType '"String"
                      ],
                  useHTTPS = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          HTTPCachePlugin = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ignores = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType '"String",
                          definitions.predicate.URLPatternObj
                        ])
                      ],
                  matches = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType '"String",
                          definitions.predicate.URLPatternObj
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          HTTPDetailsExtensionsConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "if" = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          HTTPSConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "cert", "key" ],
                predicates.records.record
                {
                  cert = predicates.isType '"String",
                  key = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Handler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  graphql = predicates.anyOf
                      [
                        definitions.predicate.GraphQLHandlerHTTPConfiguration,
                        definitions.predicate.GraphQLHandlerCodeFirstConfiguration,
                        definitions.predicate.GraphQLHandlerMultipleHTTPConfiguration
                      ],
                  grpc = definitions.predicate.GrpcHandler,
                  jsonSchema = definitions.predicate.JsonSchemaHandler,
                  mongoose = definitions.predicate.MongooseHandler,
                  mysql = definitions.predicate.MySQLHandler,
                  neo4j = definitions.predicate.Neo4jHandler,
                  odata = definitions.predicate.ODataHandler,
                  openapi = definitions.predicate.OpenapiHandler,
                  postgraphile = definitions.predicate.PostGraphileHandler,
                  raml = definitions.predicate.RAMLHandler,
                  soap = definitions.predicate.SoapHandler,
                  supergraph = definitions.predicate.SupergraphHandler,
                  thrift = definitions.predicate.ThriftHandler,
                  tuql = definitions.predicate.TuqlHandler,
                }
                {  }
                true
                predicates.always
              ],
          HiveAgentOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  maxRetries = predicates.isType 'Integer,
                  maxSize = predicates.isType 'Integer,
                  minTimeout = predicates.isType 'Integer,
                  sendInterval = predicates.isType 'Integer,
                  timeout = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          HiveClientInfo = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          HivePlugin = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "token" ],
                predicates.records.record
                {
                  agent = definitions.predicate.HiveAgentOptions,
                  enabled = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  reporting = definitions.predicate.HiveReportingOptions,
                  selfHosting = definitions.predicate.HiveSelfHostingOptions,
                  token = predicates.isType '"String",
                  usage = definitions.predicate.HiveUsageOptions,
                }
                {  }
                false
                predicates.never
              ],
          HiveReportingOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "author", "commit" ],
                predicates.records.record
                {
                  author = predicates.isType '"String",
                  commit = predicates.isType '"String",
                  serviceName = predicates.isType '"String",
                  serviceUrl = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          HiveSelfHostingOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "applicationUrl", "graphqlEndpoint" ],
                predicates.records.record
                {
                  applicationUrl = predicates.isType '"String",
                  graphqlEndpoint = predicates.isType '"String",
                  usageEndpoint = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          HiveUsageOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clientInfo = definitions.predicate.HiveClientInfo,
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  max = predicates.isType 'Integer,
                  processVariables = predicates.isType '"Bool",
                  sampleRate = predicates.isType '"Number",
                  ttl = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          HoistFieldTransformConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "newFieldName", "pathConfig", "typeName" ],
                predicates.records.record
                {
                  alias = predicates.isType '"String",
                  filterArgsInPath = predicates.isType '"Bool",
                  newFieldName = predicates.isType '"String",
                  pathConfig = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType '"String",
                          definitions.predicate.HoistFieldTransformFieldPathConfigObject
                        ])
                      ],
                  typeName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          HoistFieldTransformFieldPathConfigObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fieldName", "filterArgs" ],
                predicates.records.record
                {
                  fieldName = predicates.isType '"String",
                  filterArgs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          JsonSchemaHTTPOperation = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "field", "path", "type" ],
                predicates.records.record
                {
                  argTypeMap = predicates.isType 'Record,
                  binary = predicates.isType '"Bool",
                  deprecated = predicates.isType '"Bool",
                  description = predicates.isType '"String",
                  exposeResponseMetadata = predicates.isType '"Bool",
                  field = predicates.isType '"String",
                  headers = predicates.isType 'Record,
                  method = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "GET",
                          "HEAD",
                          "POST",
                          "PUT",
                          "DELETE",
                          "CONNECT",
                          "OPTIONS",
                          "TRACE",
                          "PATCH"
                        ]
                      ],
                  path = predicates.isType '"String",
                  queryParamArgMap = predicates.isType 'Record,
                  requestBaseBody = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  requestSample = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  requestSchema = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  requestTypeName = predicates.isType '"String",
                  responseByStatusCode = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  responseSample = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  responseSchema = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  responseTypeName = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Query", "Mutation", "Subscription" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          JsonSchemaHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bundleHeaders = predicates.isType 'Record,
                  bundlePath = predicates.isType '"String",
                  endpoint = predicates.isType '"String",
                  ignoreErrorResponses = predicates.isType '"Bool",
                  operationHeaders = predicates.isType 'Record,
                  operations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.JsonSchemaHTTPOperation,
                          definitions.predicate.JsonSchemaPubSubOperation
                        ])
                      ],
                  queryParams = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  queryStringOptions = definitions.predicate.QueryStringOptions,
                  schemaHeaders = predicates.isType 'Record,
                  source = predicates.isType '"String",
                  timeout = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          JsonSchemaPubSubOperation = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "field", "pubsubTopic", "type" ],
                predicates.records.record
                {
                  argTypeMap = predicates.isType 'Record,
                  deprecated = predicates.isType '"Bool",
                  description = predicates.isType '"String",
                  field = predicates.isType '"String",
                  pubsubTopic = predicates.isType '"String",
                  requestBaseBody = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  requestSample = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  requestSchema = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  requestTypeName = predicates.isType '"String",
                  responseSample = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  responseSchema = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  responseTypeName = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Query", "Mutation", "Subscription" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          KeyAnnotation = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "selectionSet" ],
                predicates.records.record
                { selectionSet = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          LimitHelperArgsOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { defaultValue = predicates.isType 'Integer, }
                {  }
                false
                predicates.never
              ],
          LiveQueryConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  idFieldName = predicates.isType '"String",
                  includeIdentifierExtension = predicates.isType '"Bool",
                  indexBy = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.LiveQueryIndexBy
                      ],
                  invalidations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.LiveQueryInvalidation
                      ],
                  resourceIdentifier = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          LiveQueryIndexBy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "args", "field" ],
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  field = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          LiveQueryInvalidation = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "field", "invalidate" ],
                predicates.records.record
                {
                  field = predicates.isType '"String",
                  invalidate = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LoadOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaults = predicates.isType '"Bool",
                  includeDirs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LocalforageConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  driver = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "WEBSQL", "INDEXEDDB", "LOCALSTORAGE" ]
                        ])
                      ],
                  name = predicates.isType '"String",
                  size = predicates.isType 'Integer,
                  storeName = predicates.isType '"String",
                  version = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          MaskedErrorsPluginConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { errorMessage = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          MergedRootFieldConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "queryFieldName" ],
                predicates.records.record
                {
                  additionalArgs = predicates.isType '"String",
                  argsExpr = predicates.isType '"String",
                  key = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  keyArg = predicates.isType '"String",
                  keyField = predicates.isType '"String",
                  queryFieldName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          MergedTypeConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  canonical = predicates.isType '"Bool",
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.MergedTypeField
                      ],
                  key = definitions.predicate.KeyAnnotation,
                  typeName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          MergedTypeField = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fieldName" ],
                predicates.records.record
                {
                  computed = definitions.predicate.ComputedAnnotation,
                  fieldName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          MockingConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "if" = predicates.isType '"Bool",
                  initializeStore = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  mocks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.MockingFieldConfig
                      ],
                  preserveResolvers = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          MockingFieldConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "apply" ],
                predicates.records.record
                {
                  apply = predicates.isType '"String",
                  custom = predicates.isType '"String",
                  faker = predicates.isType '"String",
                  "if" = predicates.isType '"Bool",
                  length = predicates.isType 'Integer,
                  store = definitions.predicate.GetFromMockStoreConfig,
                  updateStore = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.UpdateMockStoreConfig
                      ],
                }
                {  }
                false
                predicates.never
              ],
          MongooseHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  connectionString = predicates.isType '"String",
                  discriminators = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.MongooseModel
                      ],
                  models = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.MongooseModel
                      ],
                }
                {  }
                false
                predicates.never
              ],
          MongooseModel = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "path" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  options = definitions.predicate.ComposeWithMongooseOpts,
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          MySQLHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  database = predicates.isType '"String",
                  host = predicates.isType '"String",
                  localAddress = predicates.isType '"String",
                  password = predicates.isType '"String",
                  pool = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  port = predicates.isType 'Integer,
                  ssl = definitions.predicate.MySQLSSLOptions,
                  tableFields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TableField
                      ],
                  tables = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  user = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          MySQLSSLOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ca = predicates.isType '"String",
                  rejectUnauthorized = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          NamingConventionTransformConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enumValues = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "camelCase",
                          "capitalCase",
                          "constantCase",
                          "dotCase",
                          "headerCase",
                          "noCase",
                          "paramCase",
                          "pascalCase",
                          "pathCase",
                          "sentenceCase",
                          "snakeCase",
                          "upperCase",
                          "lowerCase"
                        ]
                      ],
                  fieldArgumentNames = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "camelCase",
                          "capitalCase",
                          "constantCase",
                          "dotCase",
                          "headerCase",
                          "noCase",
                          "paramCase",
                          "pascalCase",
                          "pathCase",
                          "sentenceCase",
                          "snakeCase",
                          "upperCase",
                          "lowerCase"
                        ]
                      ],
                  fieldNames = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "camelCase",
                          "capitalCase",
                          "constantCase",
                          "dotCase",
                          "headerCase",
                          "noCase",
                          "paramCase",
                          "pascalCase",
                          "pathCase",
                          "sentenceCase",
                          "snakeCase",
                          "upperCase",
                          "lowerCase"
                        ]
                      ],
                  mode = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "bare", "wrap" ]
                      ],
                  typeNames = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "camelCase",
                          "capitalCase",
                          "constantCase",
                          "dotCase",
                          "headerCase",
                          "noCase",
                          "paramCase",
                          "pascalCase",
                          "pathCase",
                          "sentenceCase",
                          "snakeCase",
                          "upperCase",
                          "lowerCase"
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Neo4jHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "endpoint", "password", "username" ],
                predicates.records.record
                {
                  alwaysIncludeRelationships = predicates.isType '"Bool",
                  database = predicates.isType '"String",
                  endpoint = predicates.isType '"String",
                  password = predicates.isType '"String",
                  source = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          NewrelicConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  extractOperationName = predicates.isType '"String",
                  includeExecuteVariables = predicates.isType '"Bool",
                  includeOperationDocument = predicates.isType '"Bool",
                  includeRawResult = predicates.isType '"Bool",
                  includeResolverArgs = predicates.isType '"Bool",
                  rootFieldsNaming = predicates.isType '"Bool",
                  trackResolvers = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          OASSelectQueryOrMutationFieldConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fieldName", "type" ],
                predicates.records.record
                {
                  fieldName = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "query", "mutation", "Query", "Mutation" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ODataHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "endpoint" ],
                predicates.records.record
                {
                  batch = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "multipart", "json" ]
                      ],
                  endpoint = predicates.isType '"String",
                  expandNavProps = predicates.isType '"Bool",
                  operationHeaders = predicates.isType 'Record,
                  schemaHeaders = predicates.isType 'Record,
                  source = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          OpenapiHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "source" ],
                predicates.records.record
                {
                  bundle = predicates.isType '"Bool",
                  endpoint = predicates.isType '"String",
                  fallbackFormat = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "json", "yaml", "js", "ts" ]
                      ],
                  ignoreErrorResponses = predicates.isType '"Bool",
                  operationHeaders = predicates.isType 'Record,
                  queryParams = predicates.isType 'Record,
                  schemaHeaders = predicates.isType 'Record,
                  selectQueryOrMutationField = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.OASSelectQueryOrMutationFieldConfig
                      ],
                  source = predicates.isType '"String",
                  timeout = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          OperationFieldPermission = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  "if" = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          OperationFieldPermissionsConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  permissions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.OperationFieldPermission
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PaginationResolverOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { perPage = predicates.isType 'Integer, }
                {  }
                false
                predicates.never
              ],
          Plugin = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  deduplicateRequest = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  hive = definitions.predicate.HivePlugin,
                  httpCache = definitions.predicate.HTTPCachePlugin,
                  httpDetailsExtensions =
                    definitions.predicate.HTTPDetailsExtensionsConfig,
                  immediateIntrospection = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  liveQuery = definitions.predicate.LiveQueryConfig,
                  maskedErrors = definitions.predicate.MaskedErrorsPluginConfig,
                  mock = definitions.predicate.MockingConfig,
                  newrelic = definitions.predicate.NewrelicConfig,
                  operationFieldPermissions =
                    definitions.predicate.OperationFieldPermissionsConfig,
                  prometheus = definitions.predicate.PrometheusConfig,
                  rateLimit = definitions.predicate.RateLimitPluginConfig,
                  responseCache = definitions.predicate.ResponseCacheConfig,
                  serializeHeaders =
                    definitions.predicate.SerializeHeadersConfig,
                  snapshot = definitions.predicate.SnapshotPluginConfig,
                  statsd = definitions.predicate.StatsdPlugin,
                }
                {  }
                true
                predicates.always
              ],
          PostGraphileHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appendPlugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  connectionString = predicates.isType '"String",
                  contextOptions = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  live = predicates.isType '"Bool",
                  options = predicates.anyOf
                      [
                        predicates.isType 'Record,
                        predicates.isType '"String"
                      ],
                  pool = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  schemaName = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  skipPlugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  subscriptions = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          PrefixTransformConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ignore = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  includeRootOperations = predicates.isType '"Bool",
                  includeTypes = predicates.isType '"Bool",
                  mode = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "bare", "wrap" ]
                      ],
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PrometheusConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  contextBuilding = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  delegation = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  deprecatedFields = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  endpoint = predicates.isType '"String",
                  errors = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  execute = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  fetch = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  fetchRequestHeaders = predicates.isType '"Bool",
                  fetchResponseHeaders = predicates.isType '"Bool",
                  http = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  httpRequestHeaders = predicates.isType '"Bool",
                  httpResponseHeaders = predicates.isType '"Bool",
                  parse = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  registry = predicates.isType '"String",
                  requestCount = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  requestSummary = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  requestTotalDuration = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                  skipIntrospection = predicates.isType '"Bool",
                  validate = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"String"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ProtoFilePath = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "file" ],
                predicates.records.record
                {
                  file = predicates.isType '"String",
                  load = definitions.predicate.LoadOptions,
                }
                {  }
                false
                predicates.never
              ],
          PruneTransformConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  skipEmptyCompositeTypePruning = predicates.isType '"Bool",
                  skipEmptyUnionPruning = predicates.isType '"Bool",
                  skipPruning = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  skipUnimplementedInterfacesPruning = predicates.isType
                      '"Bool",
                  skipUnusedTypesPruning = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          PubSubConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  config = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          QueryStringOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  arrayFormat = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "indices", "brackets", "repeat", "comma" ]
                      ],
                  commaRoundTrip = predicates.isType '"Bool",
                  indices = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          RAMLHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "source" ],
                predicates.records.record
                {
                  bundle = predicates.isType '"Bool",
                  endpoint = predicates.isType '"String",
                  ignoreErrorResponses = predicates.isType '"Bool",
                  operationHeaders = predicates.isType 'Record,
                  queryParams = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  schemaHeaders = predicates.isType 'Record,
                  selectQueryOrMutationField = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.RAMLSelectQueryOrMutationFieldConfig
                      ],
                  source = predicates.isType '"String",
                  timeout = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          RAMLSelectQueryOrMutationFieldConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fieldName", "type" ],
                predicates.records.record
                {
                  fieldName = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "query", "mutation", "Query", "Mutation" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          RateLimitPluginConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "config" ],
                predicates.records.record
                {
                  config = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.RateLimitTransformConfig
                      ],
                }
                {  }
                false
                predicates.never
              ],
          RateLimitTransformConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "field", "identifier", "max", "ttl", "type" ],
                predicates.records.record
                {
                  field = predicates.isType '"String",
                  identifier = predicates.isType '"String",
                  max = predicates.isType 'Integer,
                  ttl = predicates.isType 'Integer,
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RecordHelperArgsOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  isRequired = predicates.isType '"Bool",
                  recordTypeName = predicates.isType '"String",
                  removeFields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  requiredFields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          RedisConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  host = predicates.isType '"String",
                  lazyConnect = predicates.isType '"Bool",
                  password = predicates.isType '"String",
                  port = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RenameConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  argument = predicates.isType '"String",
                  field = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RenameTransform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "renames" ],
                predicates.records.record
                {
                  mode = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "bare", "wrap" ]
                      ],
                  renames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.RenameTransformObject
                      ],
                }
                {  }
                false
                predicates.never
              ],
          RenameTransformObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "from", "to" ],
                predicates.records.record
                {
                  from = definitions.predicate.RenameConfig,
                  includeDefaults = predicates.isType '"Bool",
                  regExpFlags = predicates.isType '"String",
                  to = definitions.predicate.RenameConfig,
                  useRegExpForArguments = predicates.isType '"Bool",
                  useRegExpForFields = predicates.isType '"Bool",
                  useRegExpForTypes = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ReplaceFieldConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "field", "type" ],
                predicates.records.record
                {
                  field = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ReplaceFieldTransformConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "replacements" ],
                predicates.records.record
                {
                  replacements = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ReplaceFieldTransformObject
                      ],
                  typeDefs = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ReplaceFieldTransformObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "from", "to" ],
                predicates.records.record
                {
                  composer = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  from = definitions.predicate.ReplaceFieldConfig,
                  name = predicates.isType '"String",
                  scope = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "config", "hoistValue" ]
                      ],
                  to = definitions.predicate.ReplaceFieldConfig,
                }
                {  }
                false
                predicates.never
              ],
          ResolveReferenceObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "queryFieldName" ],
                predicates.records.record
                {
                  args = predicates.isType 'Record,
                  queryFieldName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ResolversCompositionTransform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "compositions" ],
                predicates.records.record
                {
                  compositions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ResolversCompositionTransformObject
                      ],
                  mode = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "bare", "wrap" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ResolversCompositionTransformObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "composer", "resolver" ],
                predicates.records.record
                {
                  composer = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  resolver = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ResponseCacheConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cacheKey = predicates.isType '"String",
                  idFields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  "if" = predicates.isType '"String",
                  ignoredTypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  includeExtensionMetadata = predicates.isType '"Bool",
                  invalidateViaMutation = predicates.isType '"Bool",
                  sessionId = predicates.isType '"String",
                  shouldCacheResult = predicates.isType '"String",
                  ttl = predicates.isType '"Number",
                  ttlPerCoordinate = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ResponseCacheTTLConfig
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ResponseCacheTTLConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "coordinate", "ttl" ],
                predicates.records.record
                {
                  coordinate = predicates.isType '"String",
                  ttl = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          SDKConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  generateOperations =
                    definitions.predicate.GenerateOperationsConfig,
                }
                {  }
                false
                predicates.never
              ],
          SerializeHeadersConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "names" ],
                predicates.records.record
                {
                  names = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ServeConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  batchingLimit = predicates.isType 'Integer,
                  browser = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  cors = definitions.predicate.CorsConfig,
                  endpoint = predicates.isType '"String",
                  fork = predicates.anyOf
                      [ predicates.isType 'Integer, predicates.isType '"Bool" ],
                  hostname = predicates.isType '"String",
                  playground = predicates.isType '"Bool",
                  playgroundTitle = predicates.isType '"String",
                  port = predicates.anyOf
                      [
                        predicates.isType 'Integer,
                        predicates.isType '"String"
                      ],
                  sslCredentials = definitions.predicate.HTTPSConfig,
                  staticFiles = predicates.isType '"String",
                  trustProxy = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SnapshotPluginConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "apply", "outputDir" ],
                predicates.records.record
                {
                  apply = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  "if" = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  outputDir = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SoapHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "source" ],
                predicates.records.record
                {
                  operationHeaders = predicates.isType 'Record,
                  schemaHeaders = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  source = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SortHelperArgsOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { sortTypeName = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          Source = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "handler", "name" ],
                predicates.records.record
                {
                  handler = definitions.predicate.Handler,
                  name = predicates.isType '"String",
                  transforms = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                }
                {  }
                false
                predicates.never
              ],
          StatsdClientBufferHolder = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "buffer" ],
                predicates.records.record
                { buffer = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          StatsdClientConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bufferFlushInterval = predicates.isType 'Integer,
                  bufferHolder = definitions.predicate.StatsdClientBufferHolder,
                  cacheDns = predicates.isType '"Bool",
                  cacheDnsTtl = predicates.isType 'Integer,
                  closingFlushInterval = predicates.isType 'Integer,
                  globalTags = predicates.isType 'Record,
                  globalize = predicates.isType '"Bool",
                  host = predicates.isType '"String",
                  isChild = predicates.isType '"Bool",
                  maxBufferSize = predicates.isType 'Integer,
                  mock = predicates.isType '"Bool",
                  path = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                  protocol = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "tcp", "udp", "uds", "stream" ]
                      ],
                  sampleRate = predicates.isType '"Number",
                  suffix = predicates.isType '"String",
                  tagPrefix = predicates.isType '"String",
                  tagSeperator = predicates.isType '"String",
                  tcpGracefulErrorHandling = predicates.isType '"Bool",
                  tcpGracefulRestartRateLimit = predicates.isType 'Integer,
                  telegraf = predicates.isType '"Bool",
                  udsGracefulErrorHandling = predicates.isType '"Bool",
                  udsGracefulRestartRateLimit = predicates.isType 'Integer,
                  useDefaultRoute = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          StatsdPlugin = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  client = definitions.predicate.StatsdClientConfiguration,
                  prefix = predicates.isType '"String",
                  skipIntrospection = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          SupergraphHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "source" ],
                predicates.records.record
                {
                  schemaHeaders = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  source = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TableField = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fields", "table" ],
                predicates.records.record
                {
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  table = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ThriftHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "hostName", "idl", "port", "serviceName" ],
                predicates.records.record
                {
                  hostName = predicates.isType '"String",
                  https = predicates.isType '"Bool",
                  idl = predicates.isType '"String",
                  operationHeaders = predicates.isType 'Record,
                  path = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                  protocol = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "binary", "compact", "json" ]
                      ],
                  schemaHeaders = predicates.isType 'Record,
                  serviceName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TransferSchemaTransformConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "transfers" ],
                predicates.records.record
                {
                  transfers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TransferSchemaTransformObject
                      ],
                }
                {  }
                false
                predicates.never
              ],
          TransferSchemaTransformObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "from", "to" ],
                predicates.records.record
                {
                  action = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "move", "copy" ]
                      ],
                  from = predicates.isType '"String",
                  to = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Transform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cache = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.CacheTransformConfig
                      ],
                  encapsulate =
                    definitions.predicate.EncapsulateTransformObject,
                  extend = definitions.predicate.ExtendTransform,
                  federation = definitions.predicate.FederationTransform,
                  filterSchema = predicates.anyOf
                      [
                        definitions.predicate.FilterSchemaTransform,
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record {  } {  } true
                            predicates.always
                          ],
                          predicates.isType '"String",
                          predicates.isType '"Array"
                        ]
                      ],
                  hoistField = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.HoistFieldTransformConfig
                      ],
                  namingConvention =
                    definitions.predicate.NamingConventionTransformConfig,
                  prefix = definitions.predicate.PrefixTransformConfig,
                  prune = definitions.predicate.PruneTransformConfig,
                  rateLimit = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.RateLimitTransformConfig
                      ],
                  rename = predicates.anyOf
                      [
                        definitions.predicate.RenameTransform,
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record {  } {  } true
                            predicates.always
                          ],
                          predicates.isType '"String",
                          predicates.isType '"Array"
                        ]
                      ],
                  replaceField =
                    definitions.predicate.ReplaceFieldTransformConfig,
                  resolversComposition = predicates.anyOf
                      [
                        definitions.predicate.ResolversCompositionTransform,
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record {  } {  } true
                            predicates.always
                          ],
                          predicates.isType '"String",
                          predicates.isType '"Array"
                        ]
                      ],
                  transferSchema =
                    definitions.predicate.TransferSchemaTransformConfig,
                  typeMerging = definitions.predicate.TypeMergingConfig,
                }
                {  }
                true
                predicates.always
              ],
          TuqlHandler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  db = predicates.isType '"String",
                  infile = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TypeConverterResolversOpts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  connection = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Record ],
                  count = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                  createMany = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                  createOne = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                  findById = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                  findByIds = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                  findMany = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                  findOne = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                  pagination = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.PaginationResolverOpts
                      ],
                  removeById = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                  removeMany = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                  removeOne = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                  updateById = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                  updateMany = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                  updateOne = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.ComposeWithMongooseResolverOpts
                      ],
                }
                {  }
                false
                predicates.never
              ],
          TypeMergingConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  additionalConfiguration = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          predicates.always
                        ],
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                  queryFields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.MergedRootFieldConfig
                      ],
                  types = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.MergedTypeConfig
                      ],
                }
                {  }
                false
                predicates.never
              ],
          URLPatternObj = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  baseURL = predicates.isType '"String",
                  hash = predicates.isType '"String",
                  hostname = predicates.isType '"String",
                  password = predicates.isType '"String",
                  pathname = predicates.isType '"String",
                  port = predicates.isType '"String",
                  protocol = predicates.isType '"String",
                  search = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          UpdateMockStoreConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fieldName = predicates.isType '"String",
                  key = predicates.isType '"String",
                  type = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

{
  additionalEnvelopPlugins
    | String
    | doc m%"
    You can provide Envelop plugins
    "%
    | optional,
  additionalResolvers
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.anyOf
      [
        predicates.isType '"String",
        definitions.predicate.AdditionalStitchingResolverObject,
        definitions.predicate.AdditionalStitchingBatchResolverObject,
        definitions.predicate.AdditionalSubscriptionObject
      ])
    ])
    | doc m%"
    Additional resolvers, or resolvers overrides you wish to add to the schema mesh (Any of: String, AdditionalStitchingResolverObject, AdditionalStitchingBatchResolverObject, AdditionalSubscriptionObject)
    "%
    | optional,
  additionalTypeDefs
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record {  } {  } true predicates.always
      ],
      predicates.isType '"String",
      predicates.isType '"Array"
    ])
    | doc m%"
    Additional type definitions, or type definitions overrides you wish to add to the schema mesh
    "%
    | optional,
  cache
    | definitions.contract.Cache
    | doc m%"
    Backend cache
    "%
    | optional,
  codegen
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record {  } {  } true predicates.always
      ],
      predicates.isType '"String",
      predicates.isType '"Array"
    ])
    | doc m%"
    Codegen Configuration
    "%
    | optional,
  customFetch
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record {  } {  } true predicates.always
      ],
      predicates.isType '"String",
      predicates.isType '"Array"
    ])
    | doc m%"
    Path to a custom W3 Compatible Fetch Implementation
    "%
    | optional,
  documents
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Provide a query or queries for GraphQL Playground, validation and SDK Generation
    The value can be the file path, glob expression for the file paths or the SDL.
    (.js, .jsx, .graphql, .gql, .ts and .tsx files are supported.
    "%
    | optional,
  logger
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record {  } {  } true predicates.always
      ],
      predicates.isType '"String",
      predicates.isType '"Array"
    ])
    | doc m%"
    Logger instance that matches `Console` interface of NodeJS
    "%
    | optional,
  merger
    | String
    | doc m%"
    Merge method
    "%
    | optional,
  plugins
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.Plugin
    ])
    | optional,
  pubsub
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ predicates.isType '"String", definitions.predicate.PubSubConfig ])
    | doc m%"
    PubSub Implementation (Any of: String, PubSubConfig)
    "%
    | optional,
  require
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | optional,
  sdk
    | definitions.contract.SDKConfig
    | doc m%"
    SDK Configuration
    "%
    | optional,
  serve
    | definitions.contract.ServeConfig
    | doc m%"
    Configuration for `mesh start` or `mesh dev` command.
    Those commands won't be available in programmatic usage.
    "%
    | optional,
  skipSSLValidation
    | Bool
    | doc m%"
    Allow connections to an SSL endpoint without certificates
    "%
    | optional,
  sources
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.Source
    ])
    | doc m%"
    Defines the list of your external data sources for your API mesh
    "%,
  transforms
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.Transform
    ])
    | doc m%"
    Transform to apply to the unified mesh schema
    "%
    | optional,
}