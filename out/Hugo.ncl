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
          cascade = predicates.contract_from_predicate
              definitions.predicate.cascade,
          hugoVersion = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  '"v0.84.2",
                  '"v0.84.3",
                  '"v0.84.4",
                  '"v0.85.0",
                  '"v0.86.0",
                  '"v0.86.1",
                  '"v0.87.0",
                  '"v0.88.0",
                  '"v0.88.1",
                  '"v0.89.0",
                  '"v0.89.1",
                  '"v0.89.2",
                  '"v0.89.3",
                  '"v0.89.4",
                  '"v0.90.0",
                  '"v0.90.1",
                  '"v0.91.0",
                  '"v0.91.1",
                  '"v0.91.2",
                  '"v0.92.0",
                  '"v0.92.1",
                  '"v0.92.2",
                  '"v0.93.0",
                  '"v0.93.1",
                  '"v0.93.2",
                  '"v0.93.3",
                  '"v0.94.0",
                  '"v0.94.1",
                  '"v0.94.2",
                  '"v0.95.0"
                |]
              ],
          outputFormats = predicates.contract_from_predicate
              definitions.predicate.outputFormats,
          uniqueStringArray = predicates.contract_from_predicate
              definitions.predicate.uniqueStringArray,
        },
    predicate = {
          cascade = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  aliases = definitions.predicate.uniqueStringArray,
                  audio = definitions.predicate.uniqueStringArray,
                  date = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  description = predicates.isType '"String",
                  draft = predicates.isType '"Bool",
                  expiryDate = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  headless = predicates.isType '"Bool",
                  images = definitions.predicate.uniqueStringArray,
                  isCJKLanguage = predicates.isType '"Bool",
                  keywords = definitions.predicate.uniqueStringArray,
                  lastmod = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  layout = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  linkTitle = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  markup = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "rst", "md" ]
                      ],
                  outputs = definitions.predicate.outputFormats,
                  publishDate = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  resources = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          name = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                          params = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                { "." = predicates.always, }
                                true
                                predicates.always
                              ],
                          title = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  series = definitions.predicate.uniqueStringArray,
                  slug = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  summary = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  title = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  url = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  videos = definitions.predicate.uniqueStringArray,
                  weight = predicates.isType 'Integer,
                }
                {
                  "^(?!aliases|audio|date|description|draft|expiryDate|headless|images|isCJKLanguage|keywords|layout|lastmod|linkTitle|markup|outputs|publishDate|resources|series|slug|summary|title|type|url|videos|weight)$" =
                    predicates.always,
                }
                true
                predicates.always
              ],
          hugoVersion = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "v0.95.0",
                  "v0.94.2",
                  "v0.94.1",
                  "v0.94.0",
                  "v0.93.3",
                  "v0.93.2",
                  "v0.93.1",
                  "v0.93.0",
                  "v0.92.2",
                  "v0.92.1",
                  "v0.92.0",
                  "v0.91.2",
                  "v0.91.1",
                  "v0.91.0",
                  "v0.90.1",
                  "v0.90.0",
                  "v0.89.4",
                  "v0.89.3",
                  "v0.89.2",
                  "v0.89.1",
                  "v0.89.0",
                  "v0.88.1",
                  "v0.88.0",
                  "v0.87.0",
                  "v0.86.1",
                  "v0.86.0",
                  "v0.85.0",
                  "v0.84.4",
                  "v0.84.3",
                  "v0.84.2"
                ]
              ],
          outputFormats = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "." = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          baseName = predicates.isType '"String",
                          isHTML = predicates.isType '"Bool",
                          isPlainText = predicates.isType '"Bool",
                          mediaType = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "application/javascript",
                                  "application/json",
                                  "application/manifest+json",
                                  "application/octet-stream",
                                  "application/pdf",
                                  "application/rss+xml",
                                  "application/toml",
                                  "application/typescript",
                                  "application/xml",
                                  "application/yaml",
                                  "font/otf",
                                  "font/ttf",
                                  "image/bmp",
                                  "image/gif",
                                  "image/jpeg",
                                  "image/png",
                                  "image/svg+xml",
                                  "image/webp",
                                  "text/calendar",
                                  "text/css",
                                  "text/csv",
                                  "text/html",
                                  "text/jsx",
                                  "text/plain",
                                  "text/tsx",
                                  "text/x-sass",
                                  "text/x-scss",
                                  "video/3gpp",
                                  "video/mp4",
                                  "video/mpeg",
                                  "video/ogg",
                                  "video/webm",
                                  "video/x-msvideo"
                                ]
                              ],
                          name = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                          noUgly = predicates.isType '"Bool",
                          notAlternative = predicates.isType '"Bool",
                          path = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                          permalinkable = predicates.isType '"Bool",
                          protocol = predicates.isType '"String",
                          rel = predicates.isType '"String",
                          weight = predicates.isType 'Integer,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                true
                predicates.always
              ],
          uniqueStringArray = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.minLength 1
                ]),
                predicates.arrays.uniqueItems
              ],
        },
  }
in

{
  archetypeDir
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The directory to store archetype files
    https://gohugo.io/getting-started/configuration/#archetypedir
    "%
    | optional,
  assetDir
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The directory to store asset files
    https://gohugo.io/getting-started/configuration/#assetdir
    "%
    | optional,
  baseURL
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The hostname and the path to the root
    https://gohugo.io/getting-started/configuration/#baseurl
    "%
    | optional,
  build
    | {
      noJSConfigInAssets
        | Bool
        | doc m%"
        Enable/disable `jsconfig.json` writing into your `/assets` folder with mapping of imports from running `js.Build`
        https://gohugo.io/getting-started/configuration/#configure-build
        "%
        | optional,
      useResourceCacheWhen
        | std.enum.TagOrString
        | [| 'fallback, 'always, 'never |]
        | doc m%"
        The time when to use the cached resources in `/resources/_gen` for `PostCSS` and `ToCSS`
        https://gohugo.io/getting-started/configuration/#configure-build
        "%
        | optional,
      writeStats
        | Bool
        | doc m%"
        Enable/disable `hugo_stats.json` writing to the root project directory
        https://gohugo.io/getting-started/configuration/#configure-build
        "%
        | optional,
    }
    | doc m%"
    The build options
    https://gohugo.io/getting-started/configuration/#configure-build
    "%
    | optional,
  buildDrafts
    | Bool
    | doc m%"
    Include/exclude the drafts when building
    https://gohugo.io/getting-started/configuration/#builddrafts-false
    "%
    | optional,
  buildExpired
    | Bool
    | doc m%"
    Include/exclude the content already expired
    https://gohugo.io/getting-started/configuration/#buildexpired
    "%
    | optional,
  buildFuture
    | Bool
    | doc m%"
    Include/exclude the content with `publishDate` in the future
    https://gohugo.io/getting-started/configuration/#buildfuture
    "%
    | optional,
  caches
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "." = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                dir = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.minLength 1
                    ],
                maxAge = predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^-?\\d+[smh]?$"
                      ]
                    ],
              }
              {  }
              false
              predicates.never
            ],
      }
      true
      predicates.always
    ])
    | doc m%"
    The cache options
    https://gohugo.io/getting-started/configuration/#configure-file-caches
    "%
    | optional,
  canonifyURLs
    | Bool
    | doc m%"
    Enable/disable relative URLs to absolute conversion
    https://gohugo.io/getting-started/configuration/#canonifyurls
    "%
    | optional,
  cascade
    | predicates.contract_from_predicate
    (predicates.oneOf
    [
      predicates.allOf
      [ predicates.isType 'Record, definitions.predicate.cascade ],
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.allOf
          [
            predicates.records.record
            {
              _target = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      kind = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                      lang = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
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
            }
            {  }
            true
            predicates.always,
            definitions.predicate.cascade
          ],
          predicates.records.required [ "_target" ],
          predicates.records.record {  } {  } true predicates.always
        ])
      ]
    ])
    | doc m%"
    The front matter options
    https://gohugo.io/content-management/front-matter#front-matter-cascade
    "%
    | optional,
  contentDir
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The directory where content files are stored
    https://gohugo.io/getting-started/configuration/#contentdir
    "%
    | optional,
  copyright
    | String
    | doc m%"
    The copyright notice for your site
    https://gohugo.io/getting-started/configuration/#copyright
    "%
    | optional,
  dataDir
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The directory where data files are stored
    https://gohugo.io/getting-started/configuration/#datadir
    "%
    | optional,
  defaultContentLanguage
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The default content language for the content without language indicator
    https://gohugo.io/getting-started/configuration/#defaultcontentlanguage
    "%
    | optional,
  defaultContentLanguageInSubdir
    | Bool
    | doc m%"
    Enable/disable rendering the default content language in subdir
    https://gohugo.io/getting-started/configuration/#defaultcontentlanguageinsubdir
    "%
    | optional,
  disableAliases
    | Bool
    | doc m%"
    Enable/disable generation of the alias redirects
    https://gohugo.io/getting-started/configuration/#disablealiases
    "%
    | optional,
  disableHugoGeneratorInject
    | Bool
    | doc m%"
    Enable/disable injecting a generator meta tag in the HTML head on the home page only
    https://gohugo.io/getting-started/configuration/#disablehugogeneratorinject
    "%
    | optional,
  disableKinds
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
          "page",
          "home",
          "section",
          "taxonomy",
          "term",
          "RSS",
          "sitemap",
          "robotsTXT",
          "404"
        ]
      ]),
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    Disabled kinds of pages
    https://gohugo.io/getting-started/configuration/#disablekinds
    "%
    | optional,
  disableLanguages
    | definitions.contract.uniqueStringArray
    | doc m%"
    The disabled languages
    https://gohugo.io/content-management/multilingual/#disable-a-language
    "%
    | optional,
  disableLiveReload
    | Bool
    | doc m%"
    Enable/disable automatic live reloading of browser window
    https://gohugo.io/getting-started/configuration/#disablelivereload
    "%
    | optional,
  disablePathToLower
    | Bool
    | doc m%"
    Enable/disable the url/path to lowercase conversion
    https://gohugo.io/getting-started/configuration/#disablepathtolower
    "%
    | optional,
  enableEmoji
    | Bool
    | doc m%"
    Enable/disable Emoji emoticons support for page content
    https://gohugo.io/getting-started/configuration/#enableemoji
    "%
    | optional,
  enableGitInfo
    | Bool
    | doc m%"
    Enable/disable .GitInfo object for each page
    https://gohugo.io/getting-started/configuration/#enablegitinfo
    "%
    | optional,
  enableInlineShortcodes
    | Bool
    | doc m%"
    Enable/disable inline shortcode support
    https://gohugo.io/getting-started/configuration/#enableinlineshortcodes
    "%
    | optional,
  enableMissingTranslationPlaceholders
    | Bool
    | doc m%"
    Enable/disable placeholder substitution instead of the default value or an empty string if a translation is missing
    https://gohugo.io/getting-started/configuration/#enablemissingtranslationplaceholders
    "%
    | optional,
  enableRobotsTXT
    | Bool
    | doc m%"
    Enable/disable generation of robots.txt file
    https://gohugo.io/getting-started/configuration/#enablerobotstxt
    "%
    | optional,
  footnoteAnchorPrefix
    | String
    | doc m%"
    The prefix for footnote anchors
    https://gohugo.io/getting-started/configuration/#footnoteanchorprefix
    "%
    | optional,
  footnoteReturnLinkContents
    | String
    | doc m%"
    The text to display for footnote return links
    https://gohugo.io/getting-started/configuration/#footnotereturnlinkcontents
    "%
    | optional,
  frontmatter
    | {
      date
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
              "date",
              "publishDate",
              "lastmod",
              ":default",
              ":filename",
              ":git",
              "modified",
              "pubdate"
            ]
          ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/getting-started/configuration/#configure-front-matter
        "%
        | optional,
      expiryDate
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType '"String",
            predicates.enum [ "expiryDate", "unpublishdate" ]
          ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/getting-started/configuration/#configure-front-matter
        "%
        | optional,
      lastmod
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
              ":git",
              "lastmod",
              "date",
              "publishDate",
              ":fileModTime",
              "modified",
              "pubdate"
            ]
          ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/getting-started/configuration/#configure-front-matter
        "%
        | optional,
      publishDate
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType '"String",
            predicates.enum [ "publishDate", "date", "pubdate" ]
          ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/getting-started/configuration/#configure-front-matter
        "%
        | optional,
    }
    | doc m%"
    The front matter options
    https://gohugo.io/getting-started/configuration/#configure-front-matter
    "%
    | optional,
  googleAnalytics
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.strings.pattern "(UA-\\d{6}-\\d)|(G-\\w+)"
    ])
    | doc m%"
    The Google Analytics tracking ID
    https://gohugo.io/getting-started/configuration/#googleanalytics
    "%
    | optional,
  hasCJKLanguage
    | Bool
    | doc m%"
    Enable/disable auto-detecting Chinese/Japanese/Korean Languages in the content
    https://gohugo.io/getting-started/configuration/#hascjklanguage
    "%
    | optional,
  imaging
    | {
      anchor
        | std.enum.TagOrString
        | [|
          'BottomRight,
          'Bottom,
          'BottomLeft,
          'Right,
          'Center,
          'Left,
          'TopRight,
          'Top,
          'TopLeft,
          'Smart
        |]
        | doc m%"
        The anchor used when cropping pictures with either .Fill or .Crop
        https://gohugo.io/content-management/image-processing/#image-processing-config
        "%
        | optional,
      bgColor
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.pattern "^#(\\d|[ABCDEFabcdef]){6}$"
        ])
        | doc m%"
        The default background color
        https://gohugo.io/content-management/image-processing/#image-processing-config
        "%
        | optional,
      exif
        | {
          disableDate
            | Bool
            | doc m%"
            Enable/disable extracting the 'photo taken' date/time into .Date
            https://gohugo.io/content-management/image-processing/#image-processing-config
            "%
            | optional,
          disableLatLong
            | Bool
            | doc m%"
            Enable/disable extracting the 'photo taken where' into .Long and .Lat
            https://gohugo.io/content-management/image-processing/#image-processing-config
            "%
            | optional,
          excludeFields
            | String
            | doc m%"
            The regexp matching the excluded fields
            https://gohugo.io/content-management/image-processing/#image-processing-config
            "%
            | optional,
          includeFields
            | String
            | doc m%"
            The regexp matching the included fields
            https://gohugo.io/content-management/image-processing/#image-processing-config
            "%
            | optional,
        }
        | doc m%"
        Exif options
        https://gohugo.io/content-management/image-processing/#image-processing-config
        "%
        | optional,
      hint
        | std.enum.TagOrString
        | [| 'text, 'icon, 'drawing, 'photo, 'picture |]
        | doc m%"
        The default hint about what type of image
        https://gohugo.io/content-management/image-processing/#image-processing-config
        "%
        | optional,
      quality
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Integer,
          predicates.numbers.maximum 100,
          predicates.numbers.minimum 0
        ])
        | doc m%"
        The default quality
        https://gohugo.io/content-management/image-processing/#image-processing-config
        "%
        | optional,
      resampleFilter
        | std.enum.TagOrString
        | [|
          'Cosine,
          'Welch,
          'Bartlett,
          'Blackman,
          'Hamming,
          'Hann,
          'Lanczos,
          'Gaussian,
          'BSpline,
          'CatmullRom,
          'MitchellNetravali,
          'Hermite,
          'Linear,
          'Box,
          'NearestNeighbor
        |]
        | doc m%"
        The default resample filter
        https://gohugo.io/content-management/image-processing/#resampling-filter
        "%
        | optional,
    }
    | doc m%"
    The image processing options
    https://gohugo.io/getting-started/configuration/#imaging
    "%
    | optional,
  languageCode
    | String
    | doc m%"
    The language tag as defined by RFC 5646
    https://gohugo.io/getting-started/configuration/#languagecode
    "%
    | optional,
  languages
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } { "." = predicates.isType 'Record, } true
      predicates.always
    ])
    | doc m%"
    The language options
    https://gohugo.io/content-management/multilingual/#configure-languages
    "%
    | optional,
  markup
    | {
      asciidocExt
        | {
          attributes
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record {  }
              { "." = predicates.isType '"String", }
              true
              predicates.always
            ])
            | doc m%"
            The document attributes
            https://docs.asciidoctor.org/asciidoctor/latest/cli/man1/asciidoctor/#document-settings
            "%
            | optional,
          backend
            | std.enum.TagOrString
            | [| 'html, 'manpage, 'docbook5, 'html5 |]
            | doc m%"
            The backend output file format
            https://docs.asciidoctor.org/asciidoctor/latest/cli/man1/asciidoctor/#document-settings
            "%
            | optional,
          extensions
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ]),
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            
            https://gohugo.io/getting-started/configuration-markup#configure-markup
            "%
            | optional,
          failureLevel
            | String
            | doc m%"
            The minimum logging level
            https://docs.asciidoctor.org/asciidoctor/latest/cli/man1/asciidoctor/#processing-information
            "%
            | optional,
          noHeaderOrFooter
            | Bool
            | doc m%"
            
            https://gohugo.io/getting-started/configuration-markup#configure-markup
            "%
            | optional,
          preserveTOC
            | Bool
            | doc m%"
            
            https://gohugo.io/getting-started/configuration-markup#configure-markup
            "%
            | optional,
          safeMode
            | std.enum.TagOrString
            | [| 'secure, 'server, 'safe, 'unsafe |]
            | doc m%"
            The safe mode
            https://docs.asciidoctor.org/asciidoctor/latest/safe-modes/
            "%
            | optional,
          sectionNumbers
            | Bool
            | doc m%"
            Enable/disable section title's auto-numbering
            https://docs.asciidoctor.org/asciidoctor.js/latest/cli/options/#document-conversion
            "%
            | optional,
          trace
            | Bool
            | doc m%"
            Include/exclude the backtrace information on errors
            https://gohugo.io/getting-started/configuration-markup#configure-markup
            "%
            | optional,
          verbose
            | Bool
            | doc m%"
            Enable/disable verbose error printing
            https://gohugo.io/getting-started/configuration-markup#configure-markup
            "%
            | optional,
          workingFolderCurrent
            | Bool
            | doc m%"
            
            https://gohugo.io/getting-started/configuration-markup#configure-markup
            "%
            | optional,
        }
        | doc m%"
        AsciidocExt options
        https://docs.asciidoctor.org/asciidoctor/latest/cli/man1/asciidoctor/#processing-information
        "%
        | optional,
      blackfriday
        | {
          angledQuotes
            | Bool
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          extensions
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.anyOf
              [ predicates.isType '"Array", predicates.isType 'Null ],
              predicates.arrays.arrayOf
              (predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ]),
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          extensionsMask
            | predicates.contract_from_predicate
            (predicates.anyOf
            [ predicates.isType '"String", predicates.isType 'Null ])
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          footnoteAnchorPrefix
            | String
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          footnoteReturnLinkContents
            | String
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          fractions
            | Bool
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          hrefTargetBlank
            | Bool
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          latexDashes
            | Bool
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          nofollowLinks
            | Bool
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          noreferrerLinks
            | Bool
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          plainIDAnchors
            | Bool
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          skipHTML
            | Bool
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          smartDashes
            | Bool
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          smartypants
            | Bool
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          smartypantsQuotesNBSP
            | Bool
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          taskLists
            | Bool
            | doc m%"
            https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
        }
        | doc m%"
        Blackfriday options
        https://gohugo.io/getting-started/configuration-markup#blackfriday
        "%
        | optional,
      defaultMarkdownHandler
        | std.enum.TagOrString
        | [| 'blackfriday, 'goldmark |]
        | doc m%"
        The default markdown renderer
        https://gohugo.io/getting-started/configuration-markup#blackfriday
        "%
        | optional,
      goldmark
        | {
          extensions
            | {
              definitionList
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              footnote
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              linkify
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              linkifyProtocol
                | String
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              strikethrough
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              table
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              taskList
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              typographer
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
            }
            | doc m%"
            The extension options
            https://gohugo.io/getting-started/configuration-markup#goldmark
            "%
            | optional,
          parser
            | {
              attribute
                | {
                  block
                    | Bool
                    | doc m%"
                    
                    https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  title
                    | Bool
                    | doc m%"
                    
                    https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                }
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              autoHeadingID
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              autoHeadingIDType
                | String
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
            }
            | doc m%"
            The parser options
            https://gohugo.io/getting-started/configuration-markup#goldmark
            "%
            | optional,
          renderer
            | {
              hardWraps
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              unsafe
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              xhtml
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
            }
            | doc m%"
            The renderer options
            https://gohugo.io/getting-started/configuration-markup#goldmark
            "%
            | optional,
        }
        | doc m%"
        Goldmark options
        https://gohugo.io/getting-started/configuration-markup#goldmark
        "%
        | optional,
      highlight
        | {
          anchorLineNos
            | Bool
            | doc m%"
            Enable/disable anchors on line numbers
            https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
          codeFences
            | Bool
            | doc m%"
            
            https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
          guessSyntax
            | Bool
            | doc m%"
            
            https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
          hl_Lines
            | predicates.contract_from_predicate
            (predicates.oneOf
            [
              predicates.allOf
              [ predicates.isType 'Integer, predicates.numbers.minimum 1 ],
              predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^\\d+( \\d+(-\\d+)?)*$"
              ]
            ])
            | doc m%"
            The highlighted line number range
            https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
          lineAnchors
            | String
            | doc m%"
            The prefix for the anchors on line numbers
            https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
          lineNoStart
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
            | doc m%"
            The first line
            https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
          lineNos
            | predicates.contract_from_predicate
            (predicates.oneOf
            [
              predicates.isType '"Bool",
              predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "table", "inline" ]
              ]
            ])
            | doc m%"
            Enable/disable line numbers
            https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
          lineNumbersInTable
            | Bool
            | doc m%"
            
            https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
          noClasses
            | Bool
            | doc m%"
            
            https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
          noHl
            | Bool
            | doc m%"
            
            https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
          style
            | std.enum.TagOrString
            | [|
              'xcode,
              'xcode-dark,
              'witchhazel,
              'vulcan,
              'vs,
              'vim,
              'trac,
              'tango,
              'swapoff,
              'solarized-light,
              'solarized-dark256,
              'solarized-dark,
              'rrt,
              'rose-pine,
              'rose-pine-moon,
              'rose-pine-dawn,
              'rainbow_dash,
              'pygments,
              'perldoc,
              'pastie,
              'paraiso-light,
              'paraiso-dark,
              'onesenterprise,
              'onedark,
              'nord,
              'native,
              'murphy,
              'monokailight,
              'monokai,
              'modus-vivendi,
              'modus-operandi,
              'manni,
              'lovelace,
              'igor,
              'hrdark,
              'hr_high_contrast,
              'gruvbox,
              'gruvbox-light,
              'github,
              'github-dark,
              'fruity,
              'friendly,
              'emacs,
              'dracula,
              'doom-one2,
              'doom-one,
              'colorful,
              'catppuccin-mocha,
              'catppuccin-macchiato,
              'catppuccin-latte,
              'catppuccin-frappe,
              'bw,
              'borland,
              'base16-snazzy,
              'average,
              'autumn,
              'arduino,
              'algol_nu,
              'algol,
              'abap
            |]
            | doc m%"
            
            https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
          tabWidth
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
            | doc m%"
            
            https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
        }
        | doc m%"
        The highlighting options
        https://gohugo.io/getting-started/configuration-markup#highlight
        "%
        | optional,
      tableOfContents
        | {
          endLevel
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType 'Integer,
              predicates.numbers.maximum 6,
              predicates.numbers.minimum 1
            ])
            | doc m%"
            The end heading level
            https://gohugo.io/getting-started/configuration-markup#table-of-contents
            "%
            | optional,
          ordered
            | Bool
            | doc m%"
            Enable/disable ordered list generation
            https://gohugo.io/getting-started/configuration-markup#table-of-contents
            "%
            | optional,
          startLevel
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType 'Integer,
              predicates.numbers.maximum 6,
              predicates.numbers.minimum 1
            ])
            | doc m%"
            The start heading level
            https://gohugo.io/getting-started/configuration-markup#table-of-contents
            "%
            | optional,
        }
        | doc m%"
        The table of contents options
        https://gohugo.io/getting-started/configuration-markup#table-of-contents
        "%
        | optional,
      ..
    }
    | doc m%"
    The markdown options
    https://gohugo.io/getting-started/configuration-markup
    "%
    | optional,
  mediaTypes
    | {
      "application/javascript"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "application/json"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "application/manifest+json"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "application/octet-stream"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "application/pdf"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "application/rss+xml"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "application/toml"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "application/typescript"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "application/xml"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "application/yaml"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "font/otf"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "font/ttf"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "image/bmp"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "image/gif"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "image/jpeg"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "image/png"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "image/svg+xml"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "image/webp"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "text/calendar"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "text/css"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "text/csv"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "text/html"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "text/jsx"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "text/plain"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "text/tsx"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "text/x-sass"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "text/x-scss"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "video/3gpp"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "video/mp4"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "video/mpeg"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "video/ogg"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "video/webm"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      "video/x-msvideo"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        
        https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
    }
    | doc m%"
    The media type's options
    https://gohugo.io/templates/output-formats/#media-types
    "%
    | optional,
  menu
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "." = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  identifier = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  pageRef = predicates.isType '"String",
                  parent = predicates.isType '"String",
                  post = predicates.isType '"String",
                  pre = predicates.isType '"String",
                  title = predicates.isType '"String",
                  url = predicates.isType '"String",
                  weight = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ])
            ],
      }
      true
      predicates.always
    ])
    | doc m%"
    The menu options
    https://gohugo.io/content-management/menus/#add-non-content-entries-to-a-menu
    "%
    | optional,
  minify
    | {
      disableCSS
        | Bool
        | doc m%"
        
        https://gohugo.io/getting-started/configuration/#configure-minify
        "%
        | optional,
      disableHTML
        | Bool
        | doc m%"
        
        https://gohugo.io/getting-started/configuration/#configure-minify
        "%
        | optional,
      disableJS
        | Bool
        | doc m%"
        
        https://gohugo.io/getting-started/configuration/#configure-minify
        "%
        | optional,
      disableJSON
        | Bool
        | doc m%"
        
        https://gohugo.io/getting-started/configuration/#configure-minify
        "%
        | optional,
      disableSVG
        | Bool
        | doc m%"
        
        https://gohugo.io/getting-started/configuration/#configure-minify
        "%
        | optional,
      disableXML
        | Bool
        | doc m%"
        
        https://gohugo.io/getting-started/configuration/#configure-minify
        "%
        | optional,
      minifyOutput
        | Bool
        | doc m%"
        
        https://gohugo.io/getting-started/configuration/#configure-minify
        "%
        | optional,
      tdewolff
        | {
          css
            | {
              keepCSS2
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              precision
                | std.number.Integer
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
            }
            | doc m%"
            
            https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
          html
            | {
              keepComments
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              keepConditionalComments
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              keepDefaultAttrVals
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              keepDocumentTags
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              keepEndTags
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              keepQuotes
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              keepWhitespace
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
            }
            | doc m%"
            
            https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
          js
            | {
              keepVarNames
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              noNullishOperator
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              precision
                | std.number.Integer
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
            }
            | doc m%"
            
            https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
          json
            | {
              keepNumbers
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              precision
                | std.number.Integer
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
            }
            | doc m%"
            
            https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
          svg
            | {
              precision
                | predicates.contract_from_predicate
                (predicates.allOf
                [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
            }
            | doc m%"
            
            https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
          xml
            | {
              keepWhitespace
                | Bool
                | doc m%"
                
                https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
            }
            | doc m%"
            
            https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
        }
        | doc m%"
        
        https://gohugo.io/getting-started/configuration/#configure-minify
        "%
        | optional,
    }
    | doc m%"
    
    https://gohugo.io/getting-started/configuration/#configure-minify
    "%
    | optional,
  module
    | {
      hugoVersion
        | {
          extended
            | Bool
            | doc m%"
            Enable/disable requiring the extended version
            https://gohugo.io/hugo-modules/configuration/#module-config-hugoversion
            "%
            | optional,
          max
            | definitions.contract.hugoVersion
            | doc m%"
            The maximum required version
            https://gohugo.io/hugo-modules/configuration/#module-config-hugoversion
            "%
            | optional,
          min
            | definitions.contract.hugoVersion
            | doc m%"
            The minimum required version
            https://gohugo.io/hugo-modules/configuration/#module-config-hugoversion
            "%
            | optional,
        }
        | doc m%"
        The version
        https://gohugo.io/hugo-modules/configuration/#module-config-hugoversion
        "%
        | optional,
      imports
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "path" ],
            predicates.records.record
            {
              disable = predicates.isType '"Bool",
              ignoreConfig = predicates.isType '"Bool",
              ignoreImports = predicates.isType '"Bool",
              noMounts = predicates.isType '"Bool",
              noVendor = predicates.isType '"Bool",
              path = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ],
            }
            {  }
            false
            predicates.never
          ])
        ])
        | doc m%"
        The import options
        https://gohugo.io/hugo-modules/configuration/#module-config-imports
        "%
        | optional,
      mounts
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.required [ "source", "target" ],
            predicates.records.record
            {
              excludeFiles = predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.uniqueItems
                    ]
                  ],
              includeFiles = predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.uniqueItems
                    ]
                  ],
              lang = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ],
              source = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ],
              target = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ],
            }
            {  }
            false
            predicates.never
          ])
        ])
        | doc m%"
        The mount options
        https://gohugo.io/hugo-modules/configuration/#module-config-mounts
        "%
        | optional,
      noProxy
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.pattern "^[^,]+(,[^,]+)*$"
        ])
        | doc m%"
        The glob list of the matching paths that should not use the proxy configured above
        https://gohugo.io/hugo-modules/configuration/#module-config-top-level
        "%
        | optional,
      noVendor
        | String
        | doc m%"
        The glob pattern matching the paths to skip when vendoring
        https://gohugo.io/hugo-modules/configuration/#module-config-top-level
        "%
        | optional,
      private
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.pattern "^[^,]+(,[^,]+)*$"
        ])
        | doc m%"
        The glob list of the matching paths that should be treated as private
        https://gohugo.io/hugo-modules/configuration/#module-config-top-level
        "%
        | optional,
      proxy
        | String
        | doc m%"
        The proxy server to download the remote modules
        https://gohugo.io/hugo-modules/configuration/#module-config-top-level
        "%
        | optional,
      replacements
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.pattern "^[^,]+ -> [^,]+(,[^,]+ -> [^,]+)*$"
        ])
        | doc m%"
        The list of the module path to directory replacement mapping
        https://gohugo.io/hugo-modules/configuration/#module-config-top-level
        "%
        | optional,
      vendorClosest
        | Bool
        | doc m%"
        Enable/disable picking the vendored module closest to the module using it
        https://gohugo.io/hugo-modules/configuration/#module-config-top-level
        "%
        | optional,
    }
    | doc m%"
    The module options
    https://gohugo.io/hugo-modules/configuration/
    "%
    | optional,
  newContentEditor
    | String
    | doc m%"
    The content editor
    https://gohugo.io/getting-started/configuration/#newcontenteditor
    "%
    | optional,
  noChmod
    | Bool
    | doc m%"
    Enable/disable syncing permission mode of files
    https://gohugo.io/getting-started/configuration/#nochmod
    "%
    | optional,
  noTimes
    | Bool
    | doc m%"
    Enable/disable syncing modification time of files
    https://gohugo.io/getting-started/configuration/#notimes
    "%
    | optional,
  outputFormats
    | definitions.contract.outputFormats
    | doc m%"
    The output format options
    https://gohugo.io/templates/output-formats/#configure-output-formats
    "%
    | optional,
  paginate
    | std.number.Integer
    | doc m%"
    The default number of elements per page in pagination
    https://gohugo.io/getting-started/configuration/#paginate
    "%
    | optional,
  paginatePath
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The path element used during pagination
    https://gohugo.io/getting-started/configuration/#paginatepath
    "%
    | optional,
  permalinks
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } { "." = predicates.isType '"String", } true
      predicates.always
    ])
    | doc m%"
    The permalink options
    https://gohugo.io/content-management/urls/#permalinks
    "%
    | optional,
  pluralizeListTitles
    | Bool
    | doc m%"
    Pluralize/leave titles in lists
    https://gohugo.io/getting-started/configuration/#pluralizelisttitles
    "%
    | optional,
  publishDir
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The directory where Hugo writes the final static site
    https://gohugo.io/getting-started/configuration/#publishdir
    "%
    | optional,
  refLinksErrorLevel
    | std.enum.TagOrString
    | [| 'WARNING, 'ERROR |]
    | doc m%"
    The logging level for page links cannot be resolved
    https://gohugo.io/getting-started/configuration/#reflinkserrorlevel
    "%
    | optional,
  refLinksNotFoundURL
    | String
    | doc m%"
    The placeholder when a page reference cannot be found in `ref` or `relref`
    https://gohugo.io/getting-started/configuration/#reflinksnotfoundurl
    "%
    | optional,
  related
    | {
      includeNewer
        | Bool
        | doc m%"
        Include/exclude the pages newer than the current page
        https://gohugo.io/content-management/related/#top-level-config-options
        "%
        | optional,
      indices
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
              name = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ],
              pattern = predicates.isType '"String",
              toLower = predicates.isType '"Bool",
              weight = predicates.isType '"String",
            }
            {  }
            false
            predicates.never
          ])
        ])
        | doc m%"
        The related content option's entry
        https://gohugo.io/content-management/related/#config-options-per-index
        "%
        | optional,
      threshold
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Integer,
          predicates.numbers.maximum 100,
          predicates.numbers.minimum 0
        ])
        | doc m%"
        
        https://gohugo.io/content-management/related/#top-level-config-options
        "%
        | optional,
      toLower
        | Bool
        | doc m%"
        Enable/disable lowering the case keywords in both the indexes and the queries
        https://gohugo.io/content-management/related/#top-level-config-options
        "%
        | optional,
    }
    | doc m%"
    The related content options
    https://gohugo.io/getting-started/configuration/#related
    "%
    | optional,
  relativeURLs
    | Bool
    | doc m%"
    Enable/disable making all relative URLs relative to content root
    https://gohugo.io/getting-started/configuration/#relativeurls
    "%
    | optional,
  removePathAccents
    | Bool
    | doc m%"
    Remove/leave non-spacing marks from composite characters in content paths
    https://gohugo.io/getting-started/configuration/#removepathaccents
    "%
    | optional,
  rssLimit
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType 'Integer, predicates.numbers.minimum (-1) ])
    | doc m%"
    
    https://gohugo.io/getting-started/configuration/#rsslimit
    "%
    | optional,
  sectionPagesMenu
    | String
    | doc m%"
    
    https://gohugo.io/templates/menu-templates/#section-menu-for-lazy-bloggers
    "%
    | optional,
  security
    | {
      enableInlineShortcodes
        | Bool
        | doc m%"
        
        https://gohugo.io/about/security-model/#security-policy
        "%
        | optional,
      exec
        | {
          allow
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ]),
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            
            https://gohugo.io/about/security-model/#security-policy
            "%
            | optional,
          osEnv
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ]),
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            
            https://gohugo.io/about/security-model/#security-policy
            "%
            | optional,
        }
        | doc m%"
        
        https://gohugo.io/about/security-model/#security-policy
        "%
        | optional,
      funcs
        | {
          getenv
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ]),
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            
            https://gohugo.io/about/security-model/#security-policy
            "%
            | optional,
        }
        | doc m%"
        
        https://gohugo.io/about/security-model/#security-policy
        "%
        | optional,
      http
        | {
          methods
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ]),
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            
            https://gohugo.io/about/security-model/#security-policy
            "%
            | optional,
          urls
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ]),
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            
            https://gohugo.io/about/security-model/#security-policy
            "%
            | optional,
        }
        | doc m%"
        
        https://gohugo.io/about/security-model/#security-policy
        "%
        | optional,
    }
    | doc m%"
    The security options
    https://gohugo.io/about/security-model/#security-policy
    "%
    | optional,
  sitemap
    | {
      changefreq
        | String
        | doc m%"
        
        https://gohugo.io/templates/sitemap-template/#configure-sitemapxml
        "%
        | optional,
      filename
        | String
        | doc m%"
        
        https://gohugo.io/templates/sitemap-template/#configure-sitemapxml
        "%
        | optional,
      "priority"
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Number",
          predicates.numbers.maximum 1,
          predicates.numbers.minimum 0
        ])
        | doc m%"
        
        https://gohugo.io/templates/sitemap-template/#configure-sitemapxml
        "%
        | optional,
    }
    | doc m%"
    The sitemap options
    https://gohugo.io/templates/sitemap-template/#configure-sitemapxml
    "%
    | optional,
  summaryLength
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
    | doc m%"
    The length of text in words to show in a .Summary
    https://gohugo.io/getting-started/configuration/#summarylength
    "%
    | optional,
  taxonomies
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record
      {
        category = predicates.allOf
            [ predicates.isType '"String", predicates.strings.minLength 1 ],
        tag = predicates.allOf
            [ predicates.isType '"String", predicates.strings.minLength 1 ],
      }
      {
        "^(?!tag|category)$" = predicates.allOf
            [ predicates.isType '"String", predicates.strings.minLength 1 ],
      }
      true
      predicates.always
    ])
    | doc m%"
    The taxonomy options
    https://gohugo.io/content-management/taxonomies#configure-taxonomies
    "%
    | optional,
  theme
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    
    https://gohugo.io/hugo-modules/configuration/#module-config-imports
    "%
    | optional,
  themesDir
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The directory where themes are stored
    https://gohugo.io/getting-started/configuration/#themesdir
    "%
    | optional,
  timeZone
    | std.enum.TagOrString
    | [|
      '"US/Samoa",
      '"US/Pacific",
      '"US/Mountain",
      '"US/Michigan",
      '"US/Indiana-Starke",
      '"US/Hawaii",
      '"US/Eastern",
      '"US/East-Indiana",
      '"US/Central",
      '"US/Arizona",
      '"US/Aleutian",
      '"US/Alaska",
      'Singapore,
      'ROC,
      'PRC,
      'Portugal,
      'Poland,
      '"Pacific/Yap",
      '"Pacific/Wallis",
      '"Pacific/Wake",
      '"Pacific/Truk",
      '"Pacific/Tongatapu",
      '"Pacific/Tarawa",
      '"Pacific/Tahiti",
      '"Pacific/Samoa",
      '"Pacific/Saipan",
      '"Pacific/Rarotonga",
      '"Pacific/Port_Moresby",
      '"Pacific/Ponape",
      '"Pacific/Pohnpei",
      '"Pacific/Pitcairn",
      '"Pacific/Palau",
      '"Pacific/Pago_Pago",
      '"Pacific/Noumea",
      '"Pacific/Norfolk",
      '"Pacific/Niue",
      '"Pacific/Nauru",
      '"Pacific/Midway",
      '"Pacific/Marquesas",
      '"Pacific/Majuro",
      '"Pacific/Kwajalein",
      '"Pacific/Kosrae",
      '"Pacific/Kiritimati",
      '"Pacific/Kanton",
      '"Pacific/Johnston",
      '"Pacific/Honolulu",
      '"Pacific/Guam",
      '"Pacific/Guadalcanal",
      '"Pacific/Gambier",
      '"Pacific/Galapagos",
      '"Pacific/Funafuti",
      '"Pacific/Fiji",
      '"Pacific/Fakaofo",
      '"Pacific/Enderbury",
      '"Pacific/Efate",
      '"Pacific/Easter",
      '"Pacific/Chuuk",
      '"Pacific/Chatham",
      '"Pacific/Bougainville",
      '"Pacific/Auckland",
      '"Pacific/Apia",
      'NZ-CHAT,
      'NZ,
      'Navajo,
      '"Mexico/General",
      '"Mexico/BajaSur",
      '"Mexico/BajaNorte",
      'Libya,
      'Kwajalein,
      'Japan,
      'Jamaica,
      'Israel,
      'Iran,
      '"Indian/Reunion",
      '"Indian/Mayotte",
      '"Indian/Mauritius",
      '"Indian/Maldives",
      '"Indian/Mahe",
      '"Indian/Kerguelen",
      '"Indian/Comoro",
      '"Indian/Cocos",
      '"Indian/Christmas",
      '"Indian/Chagos",
      '"Indian/Antananarivo",
      'Iceland,
      'Hongkong,
      'GB-Eire,
      'GB,
      '"Europe/Zurich",
      '"Europe/Zaporozhye",
      '"Europe/Zagreb",
      '"Europe/Warsaw",
      '"Europe/Volgograd",
      '"Europe/Vilnius",
      '"Europe/Vienna",
      '"Europe/Vatican",
      '"Europe/Vaduz",
      '"Europe/Uzhgorod",
      '"Europe/Ulyanovsk",
      '"Europe/Tiraspol",
      '"Europe/Tirane",
      '"Europe/Tallinn",
      '"Europe/Stockholm",
      '"Europe/Sofia",
      '"Europe/Skopje",
      '"Europe/Simferopol",
      '"Europe/Saratov",
      '"Europe/Sarajevo",
      '"Europe/San_Marino",
      '"Europe/Samara",
      '"Europe/Rome",
      '"Europe/Riga",
      '"Europe/Prague",
      '"Europe/Podgorica",
      '"Europe/Paris",
      '"Europe/Oslo",
      '"Europe/Nicosia",
      '"Europe/Moscow",
      '"Europe/Monaco",
      '"Europe/Minsk",
      '"Europe/Mariehamn",
      '"Europe/Malta",
      '"Europe/Madrid",
      '"Europe/Luxembourg",
      '"Europe/London",
      '"Europe/Ljubljana",
      '"Europe/Lisbon",
      '"Europe/Kirov",
      '"Europe/Kiev",
      '"Europe/Kaliningrad",
      '"Europe/Jersey",
      '"Europe/Istanbul",
      '"Europe/Isle_of_Man",
      '"Europe/Helsinki",
      '"Europe/Guernsey",
      '"Europe/Gibraltar",
      '"Europe/Dublin",
      '"Europe/Copenhagen",
      '"Europe/Chisinau",
      '"Europe/Busingen",
      '"Europe/Budapest",
      '"Europe/Bucharest",
      '"Europe/Brussels",
      '"Europe/Bratislava",
      '"Europe/Berlin",
      '"Europe/Belgrade",
      '"Europe/Belfast",
      '"Europe/Athens",
      '"Europe/Astrakhan",
      '"Europe/Andorra",
      '"Europe/Amsterdam",
      '"Etc/Zulu",
      '"Etc/UTC",
      '"Etc/Universal",
      '"Etc/UCT",
      '"Etc/Greenwich",
      '"Etc/GMT0",
      '"Etc/GMT-9",
      '"Etc/GMT-8",
      '"Etc/GMT-7",
      '"Etc/GMT-6",
      '"Etc/GMT-5",
      '"Etc/GMT-4",
      '"Etc/GMT-3",
      '"Etc/GMT-2",
      '"Etc/GMT-14",
      '"Etc/GMT-13",
      '"Etc/GMT-12",
      '"Etc/GMT-11",
      '"Etc/GMT-10",
      '"Etc/GMT-1",
      '"Etc/GMT-0",
      '"Etc/GMT+9",
      '"Etc/GMT+8",
      '"Etc/GMT+7",
      '"Etc/GMT+6",
      '"Etc/GMT+5",
      '"Etc/GMT+4",
      '"Etc/GMT+3",
      '"Etc/GMT+2",
      '"Etc/GMT+12",
      '"Etc/GMT+11",
      '"Etc/GMT+10",
      '"Etc/GMT+1",
      '"Etc/GMT+0",
      '"Etc/GMT",
      'Eire,
      'Egypt,
      'Cuba,
      '"Chile/EasterIsland",
      '"Chile/Continental",
      '"Canada/Yukon",
      '"Canada/Saskatchewan",
      '"Canada/Pacific",
      '"Canada/Newfoundland",
      '"Canada/Mountain",
      '"Canada/Eastern",
      '"Canada/Central",
      '"Canada/Atlantic",
      '"Brazil/West",
      '"Brazil/East",
      '"Brazil/DeNoronha",
      '"Brazil/Acre",
      '"Australia/Yancowinna",
      '"Australia/West",
      '"Australia/Victoria",
      '"Australia/Tasmania",
      '"Australia/Sydney",
      '"Australia/South",
      '"Australia/Queensland",
      '"Australia/Perth",
      '"Australia/NSW",
      '"Australia/North",
      '"Australia/Melbourne",
      '"Australia/Lord_Howe",
      '"Australia/Lindeman",
      '"Australia/LHI",
      '"Australia/Hobart",
      '"Australia/Eucla",
      '"Australia/Darwin",
      '"Australia/Currie",
      '"Australia/Canberra",
      '"Australia/Broken_Hill",
      '"Australia/Brisbane",
      '"Australia/Adelaide",
      '"Australia/ACT",
      '"Atlantic/Stanley",
      '"Atlantic/St_Helena",
      '"Atlantic/South_Georgia",
      '"Atlantic/Reykjavik",
      '"Atlantic/Madeira",
      '"Atlantic/Jan_Mayen",
      '"Atlantic/Faroe",
      '"Atlantic/Faeroe",
      '"Atlantic/Cape_Verde",
      '"Atlantic/Canary",
      '"Atlantic/Bermuda",
      '"Atlantic/Azores",
      '"Asia/Yerevan",
      '"Asia/Yekaterinburg",
      '"Asia/Yangon",
      '"Asia/Yakutsk",
      '"Asia/Vladivostok",
      '"Asia/Vientiane",
      '"Asia/Ust-Nera",
      '"Asia/Urumqi",
      '"Asia/Ulan_Bator",
      '"Asia/Ulaanbaatar",
      '"Asia/Ujung_Pandang",
      '"Asia/Tomsk",
      '"Asia/Tokyo",
      '"Asia/Thimphu",
      '"Asia/Thimbu",
      '"Asia/Tel_Aviv",
      '"Asia/Tehran",
      '"Asia/Tbilisi",
      '"Asia/Tashkent",
      '"Asia/Taipei",
      '"Asia/Srednekolymsk",
      '"Asia/Singapore",
      '"Asia/Shanghai",
      '"Asia/Seoul",
      '"Asia/Samarkand",
      '"Asia/Sakhalin",
      '"Asia/Saigon",
      '"Asia/Riyadh",
      '"Asia/Rangoon",
      '"Asia/Qyzylorda",
      '"Asia/Qostanay",
      '"Asia/Qatar",
      '"Asia/Pyongyang",
      '"Asia/Pontianak",
      '"Asia/Phnom_Penh",
      '"Asia/Oral",
      '"Asia/Omsk",
      '"Asia/Novosibirsk",
      '"Asia/Novokuznetsk",
      '"Asia/Nicosia",
      '"Asia/Muscat",
      '"Asia/Manila",
      '"Asia/Makassar",
      '"Asia/Magadan",
      '"Asia/Macau",
      '"Asia/Macao",
      '"Asia/Kuwait",
      '"Asia/Kuching",
      '"Asia/Kuala_Lumpur",
      '"Asia/Krasnoyarsk",
      '"Asia/Kolkata",
      '"Asia/Khandyga",
      '"Asia/Katmandu",
      '"Asia/Kathmandu",
      '"Asia/Kashgar",
      '"Asia/Karachi",
      '"Asia/Kamchatka",
      '"Asia/Kabul",
      '"Asia/Jerusalem",
      '"Asia/Jayapura",
      '"Asia/Jakarta",
      '"Asia/Istanbul",
      '"Asia/Irkutsk",
      '"Asia/Hovd",
      '"Asia/Hong_Kong",
      '"Asia/Ho_Chi_Minh",
      '"Asia/Hebron",
      '"Asia/Harbin",
      '"Asia/Gaza",
      '"Asia/Famagusta",
      '"Asia/Dushanbe",
      '"Asia/Dubai",
      '"Asia/Dili",
      '"Asia/Dhaka",
      '"Asia/Damascus",
      '"Asia/Dacca",
      '"Asia/Colombo",
      '"Asia/Chungking",
      '"Asia/Chongqing",
      '"Asia/Choibalsan",
      '"Asia/Chita",
      '"Asia/Calcutta",
      '"Asia/Brunei",
      '"Asia/Bishkek",
      '"Asia/Beirut",
      '"Asia/Barnaul",
      '"Asia/Bangkok",
      '"Asia/Baku",
      '"Asia/Bahrain",
      '"Asia/Baghdad",
      '"Asia/Atyrau",
      '"Asia/Ashkhabad",
      '"Asia/Ashgabat",
      '"Asia/Aqtobe",
      '"Asia/Aqtau",
      '"Asia/Anadyr",
      '"Asia/Amman",
      '"Asia/Almaty",
      '"Asia/Aden",
      '"Arctic/Longyearbyen",
      '"Antarctica/Vostok",
      '"Antarctica/Troll",
      '"Antarctica/Syowa",
      '"Antarctica/South_Pole",
      '"Antarctica/Rothera",
      '"Antarctica/Palmer",
      '"Antarctica/McMurdo",
      '"Antarctica/Mawson",
      '"Antarctica/Macquarie",
      '"Antarctica/DumontDUrville",
      '"Antarctica/Davis",
      '"Antarctica/Casey",
      '"America/Yellowknife",
      '"America/Yakutat",
      '"America/Winnipeg",
      '"America/Whitehorse",
      '"America/Virgin",
      '"America/Vancouver",
      '"America/Tortola",
      '"America/Toronto",
      '"America/Tijuana",
      '"America/Thunder_Bay",
      '"America/Thule",
      '"America/Tegucigalpa",
      '"America/Swift_Current",
      '"America/St_Vincent",
      '"America/St_Thomas",
      '"America/St_Lucia",
      '"America/St_Kitts",
      '"America/St_Johns",
      '"America/St_Barthelemy",
      '"America/Sitka",
      '"America/Shiprock",
      '"America/Scoresbysund",
      '"America/Sao_Paulo",
      '"America/Santo_Domingo",
      '"America/Santiago",
      '"America/Santarem",
      '"America/Santa_Isabel",
      '"America/Rosario",
      '"America/Rio_Branco",
      '"America/Resolute",
      '"America/Regina",
      '"America/Recife",
      '"America/Rankin_Inlet",
      '"America/Rainy_River",
      '"America/Punta_Arenas",
      '"America/Puerto_Rico",
      '"America/Porto_Velho",
      '"America/Porto_Acre",
      '"America/Port_of_Spain",
      '"America/Port-au-Prince",
      '"America/Phoenix",
      '"America/Paramaribo",
      '"America/Pangnirtung",
      '"America/Panama",
      '"America/Ojinaga",
      '"America/Nuuk",
      '"America/North_Dakota/New_Salem",
      '"America/North_Dakota/Center",
      '"America/North_Dakota/Beulah",
      '"America/Noronha",
      '"America/Nome",
      '"America/Nipigon",
      '"America/New_York",
      '"America/Nassau",
      '"America/Montserrat",
      '"America/Montreal",
      '"America/Montevideo",
      '"America/Monterrey",
      '"America/Moncton",
      '"America/Miquelon",
      '"America/Mexico_City",
      '"America/Metlakatla",
      '"America/Merida",
      '"America/Menominee",
      '"America/Mendoza",
      '"America/Mazatlan",
      '"America/Matamoros",
      '"America/Martinique",
      '"America/Marigot",
      '"America/Manaus",
      '"America/Managua",
      '"America/Maceio",
      '"America/Lower_Princes",
      '"America/Louisville",
      '"America/Los_Angeles",
      '"America/Lima",
      '"America/La_Paz",
      '"America/Kralendijk",
      '"America/Knox_IN",
      '"America/Kentucky/Monticello",
      '"America/Kentucky/Louisville",
      '"America/Juneau",
      '"America/Jujuy",
      '"America/Jamaica",
      '"America/Iqaluit",
      '"America/Inuvik",
      '"America/Indianapolis",
      '"America/Indiana/Winamac",
      '"America/Indiana/Vincennes",
      '"America/Indiana/Vevay",
      '"America/Indiana/Tell_City",
      '"America/Indiana/Petersburg",
      '"America/Indiana/Marengo",
      '"America/Indiana/Knox",
      '"America/Indiana/Indianapolis",
      '"America/Hermosillo",
      '"America/Havana",
      '"America/Halifax",
      '"America/Guyana",
      '"America/Guayaquil",
      '"America/Guatemala",
      '"America/Guadeloupe",
      '"America/Grenada",
      '"America/Grand_Turk",
      '"America/Goose_Bay",
      '"America/Godthab",
      '"America/Glace_Bay",
      '"America/Fortaleza",
      '"America/Fort_Wayne",
      '"America/Fort_Nelson",
      '"America/Ensenada",
      '"America/El_Salvador",
      '"America/Eirunepe",
      '"America/Edmonton",
      '"America/Dominica",
      '"America/Detroit",
      '"America/Denver",
      '"America/Dawson_Creek",
      '"America/Dawson",
      '"America/Danmarkshavn",
      '"America/Curacao",
      '"America/Cuiaba",
      '"America/Creston",
      '"America/Costa_Rica",
      '"America/Cordoba",
      '"America/Coral_Harbour",
      '"America/Chihuahua",
      '"America/Chicago",
      '"America/Cayman",
      '"America/Cayenne",
      '"America/Catamarca",
      '"America/Caracas",
      '"America/Cancun",
      '"America/Campo_Grande",
      '"America/Cambridge_Bay",
      '"America/Buenos_Aires",
      '"America/Boise",
      '"America/Bogota",
      '"America/Boa_Vista",
      '"America/Blanc-Sablon",
      '"America/Belize",
      '"America/Belem",
      '"America/Barbados",
      '"America/Bahia_Banderas",
      '"America/Bahia",
      '"America/Atka",
      '"America/Atikokan",
      '"America/Asuncion",
      '"America/Aruba",
      '"America/Argentina/Ushuaia",
      '"America/Argentina/Tucuman",
      '"America/Argentina/San_Luis",
      '"America/Argentina/San_Juan",
      '"America/Argentina/Salta",
      '"America/Argentina/Rio_Gallegos",
      '"America/Argentina/Mendoza",
      '"America/Argentina/La_Rioja",
      '"America/Argentina/Jujuy",
      '"America/Argentina/Cordoba",
      '"America/Argentina/ComodRivadavia",
      '"America/Argentina/Catamarca",
      '"America/Argentina/Buenos_Aires",
      '"America/Araguaina",
      '"America/Antigua",
      '"America/Anguilla",
      '"America/Anchorage",
      '"America/Adak",
      '"Africa/Windhoek",
      '"Africa/Tunis",
      '"Africa/Tripoli",
      '"Africa/Timbuktu",
      '"Africa/Sao_Tome",
      '"Africa/Porto-Novo",
      '"Africa/Ouagadougou",
      '"Africa/Nouakchott",
      '"Africa/Niamey",
      '"Africa/Ndjamena",
      '"Africa/Nairobi",
      '"Africa/Monrovia",
      '"Africa/Mogadishu",
      '"Africa/Mbabane",
      '"Africa/Maseru",
      '"Africa/Maputo",
      '"Africa/Malabo",
      '"Africa/Lusaka",
      '"Africa/Lubumbashi",
      '"Africa/Luanda",
      '"Africa/Lome",
      '"Africa/Libreville",
      '"Africa/Lagos",
      '"Africa/Kinshasa",
      '"Africa/Kigali",
      '"Africa/Khartoum",
      '"Africa/Kampala",
      '"Africa/Juba",
      '"Africa/Johannesburg",
      '"Africa/Harare",
      '"Africa/Gaborone",
      '"Africa/Freetown",
      '"Africa/El_Aaiun",
      '"Africa/Douala",
      '"Africa/Djibouti",
      '"Africa/Dar_es_Salaam",
      '"Africa/Dakar",
      '"Africa/Conakry",
      '"Africa/Ceuta",
      '"Africa/Casablanca",
      '"Africa/Cairo",
      '"Africa/Bujumbura",
      '"Africa/Brazzaville",
      '"Africa/Blantyre",
      '"Africa/Bissau",
      '"Africa/Banjul",
      '"Africa/Bangui",
      '"Africa/Bamako",
      '"Africa/Asmera",
      '"Africa/Asmara",
      '"Africa/Algiers",
      '"Africa/Addis_Ababa",
      '"Africa/Accra",
      '"Africa/Abidjan"
    |]
    | doc m%"
    The time zone
    https://gohugo.io/getting-started/configuration/#timezone
    "%
    | optional,
  timeout
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.pattern "^\\d+s$" ])
    | doc m%"
    The timeout for generating page contents
    https://gohugo.io/getting-started/configuration/#timeout
    "%
    | optional,
  title
    | String
    | doc m%"
    The site title
    https://gohugo.io/getting-started/configuration/#title
    "%
    | optional,
  titleCaseStyle
    | std.enum.TagOrString
    | [| 'Go, 'Chicago, 'AP |]
    | doc m%"
    The title case style
    https://gohugo.io/getting-started/configuration/#titlecasestyle
    "%
    | optional,
  uglyURLs
    | Bool
    | doc m%"
    Enable/disable adding file extensions to urls
    https://gohugo.io/getting-started/configuration/#uglyurls
    "%
    | optional,
  watch
    | Bool
    | doc m%"
    Enable/disable watching filesystem for changes and recreating as needed
    https://gohugo.io/getting-started/configuration/#watch
    "%
    | optional,
  ..
}