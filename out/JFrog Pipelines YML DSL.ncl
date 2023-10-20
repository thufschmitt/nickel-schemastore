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
          JFrog-Pipelines
            | doc m%"
            https://www.jfrog.com/confluence/display/JFROG/Pipelines+Developer+Guide
            "%
            = predicates.contract_from_predicate
              definitions.predicate.JFrog-Pipelines,
          Pipeline
            | doc m%"
            https://www.jfrog.com/confluence/display/JFROG/Creating+Pipelines
            "%
            = {
                configuration
                  | {
                    affinityGroup | String | optional,
                    chronological | Bool | optional,
                    dependencyMode
                      | {
                        waitOnChildComplete | Bool | optional,
                        waitOnParentComplete | Bool | optional,
                        waitOnParentSuccess | Bool | optional,
                      }
                      | optional,
                    environmentVariables
                      | {
                        readOnly
                          | predicates.contract_from_predicate
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record {  } {  } true
                            (predicates.allOf
                            [
                              predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number",
                                predicates.isType 'Record
                              ],
                              predicates.records.required [ "default" ],
                              predicates.records.record
                              {
                                allowCustom = predicates.isType '"Bool",
                                "default" = predicates.anyOf
                                    [
                                      predicates.isType '"String",
                                      predicates.isType '"Number"
                                    ],
                                description = predicates.isType '"String",
                                values = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.anyOf
                                      [
                                        predicates.isType '"String",
                                        predicates.isType '"Number"
                                      ]),
                                      predicates.arrays.minItems 1
                                    ],
                              }
                              {  }
                              true
                              predicates.always
                            ])
                          ]),
                        ..
                      }
                      | optional,
                    inputResources
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
                            branch = predicates.isType '"String",
                            name = predicates.isType '"String",
                            newVersionOnly = predicates.isType '"Bool",
                            trigger = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ]),
                        predicates.arrays.minItems 1
                      ])
                      | optional,
                    integrations
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
                          { name = predicates.isType '"String", }
                          {  }
                          false
                          predicates.never
                        ]),
                        predicates.arrays.minItems 1
                      ])
                      | optional,
                    jfrogCliVersion
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Integer
                        ],
                        predicates.enum [ "1", "2", 1, 2 ]
                      ])
                      | optional,
                    nodePool | String | optional,
                    outputResources
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
                            branch = predicates.isType '"String",
                            name = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ]),
                        predicates.arrays.minItems 1
                      ])
                      | optional,
                    retentionPolicy
                      | {
                        maxAgeDays | Number | optional,
                        minRuns | Number | optional,
                      }
                      | optional,
                    runtime
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.ifThenElse
                        (predicates.records.record
                        { type = predicates.enum [ "image" ], }
                        {  }
                        true
                        predicates.always)
                        (predicates.records.record
                        {
                          image = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.oneOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.records.required [ "auto" ],
                                    predicates.records.record {  } {  } true
                                    predicates.always
                                  ],
                                  predicates.allOf
                                  [
                                    predicates.records.required [ "custom" ],
                                    predicates.records.record {  } {  } true
                                    predicates.always
                                  ]
                                ],
                                predicates.records.record
                                {
                                  auto = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.required
                                        [ "language", "versions" ],
                                        predicates.records.record
                                        {
                                          language = predicates.isType
                                              '"String",
                                          versions = predicates.allOf
                                              [
                                                predicates.isType '"Array",
                                                predicates.arrays.arrayOf
                                                (predicates.anyOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.isType '"Number"
                                                ])
                                              ],
                                        }
                                        {  }
                                        true
                                        predicates.always
                                      ],
                                  custom = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.required
                                        [ "name", "tag" ],
                                        predicates.records.record
                                        {
                                          autoPull = predicates.isType '"Bool",
                                          name = predicates.isType '"String",
                                          options = predicates.isType '"String",
                                          region = predicates.isType '"String",
                                          registry = predicates.isType
                                              '"String",
                                          sourceRepository = predicates.isType
                                              '"String",
                                          tag = predicates.isType '"String",
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
                          type = predicates.enum [ "image" ],
                        }
                        {  }
                        false
                        predicates.never)
                        (predicates.records.record
                        { type = predicates.enum [ "host" ], }
                        {  }
                        false
                        predicates.never),
                        predicates.records.required [ "type" ],
                        predicates.records.record
                        {
                          type = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "image", "host" ]
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ])
                      | optional,
                  }
                  | optional,
                name | String,
                steps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Step,
                    predicates.arrays.minItems 1
                  ]),
              },
          Resource
            | doc m%"
            https://www.jfrog.com/confluence/display/JFROG/Pipelines+Resources
            "%
            = predicates.contract_from_predicate definitions.predicate.Resource,
          Step
            | doc m%"
            https://www.jfrog.com/confluence/display/JFROG/Pipelines+Steps
            "%
            = predicates.contract_from_predicate definitions.predicate.Step,
          common = predicates.contract_from_predicate
              definitions.predicate.common,
          resourceTypes = predicates.contract_from_predicate
              definitions.predicate.resourceTypes,
          stepTypes = predicates.contract_from_predicate
              definitions.predicate.stepTypes,
        },
    predicate = {
          JFrog-Pipelines
            | doc m%"
            https://www.jfrog.com/confluence/display/JFROG/Pipelines+Developer+Guide
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "pipelines" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "resources" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  pipelines = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Pipeline
                      ],
                  resources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Resource
                      ],
                  template = predicates.isType '"Bool",
                  valuesFilePath = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Pipeline
            | doc m%"
            https://www.jfrog.com/confluence/display/JFROG/Creating+Pipelines
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "steps" ],
                predicates.records.record
                {
                  configuration = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          affinityGroup = predicates.isType '"String",
                          chronological = predicates.isType '"Bool",
                          dependencyMode = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  waitOnChildComplete = predicates.isType
                                      '"Bool",
                                  waitOnParentComplete = predicates.isType
                                      '"Bool",
                                  waitOnParentSuccess = predicates.isType
                                      '"Bool",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          environmentVariables = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "readOnly" ],
                                predicates.records.record
                                {
                                  readOnly = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record {  } {  } true
                                        (predicates.allOf
                                        [
                                          predicates.anyOf
                                          [
                                            predicates.isType '"String",
                                            predicates.isType '"Number",
                                            predicates.isType 'Record
                                          ],
                                          predicates.records.required
                                          [ "default" ],
                                          predicates.records.record
                                          {
                                            allowCustom = predicates.isType
                                                '"Bool",
                                            "default" = predicates.anyOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.isType '"Number"
                                                ],
                                            description = predicates.isType
                                                '"String",
                                            values = predicates.allOf
                                                [
                                                  predicates.isType '"Array",
                                                  predicates.arrays.arrayOf
                                                  (predicates.anyOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.isType '"Number"
                                                  ]),
                                                  predicates.arrays.minItems 1
                                                ],
                                          }
                                          {  }
                                          true
                                          predicates.always
                                        ])
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          inputResources = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required [ "name" ],
                                  predicates.records.record
                                  {
                                    branch = predicates.isType '"String",
                                    name = predicates.isType '"String",
                                    newVersionOnly = predicates.isType '"Bool",
                                    trigger = predicates.isType '"Bool",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ]),
                                predicates.arrays.minItems 1
                              ],
                          integrations = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required [ "name" ],
                                  predicates.records.record
                                  { name = predicates.isType '"String", }
                                  {  }
                                  false
                                  predicates.never
                                ]),
                                predicates.arrays.minItems 1
                              ],
                          jfrogCliVersion = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType '"String",
                                  predicates.isType 'Integer
                                ],
                                predicates.enum [ "1", "2", 1, 2 ]
                              ],
                          nodePool = predicates.isType '"String",
                          outputResources = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required [ "name" ],
                                  predicates.records.record
                                  {
                                    branch = predicates.isType '"String",
                                    name = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ]),
                                predicates.arrays.minItems 1
                              ],
                          retentionPolicy = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  maxAgeDays = predicates.isType '"Number",
                                  minRuns = predicates.isType '"Number",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          runtime = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.ifThenElse
                                (predicates.records.record
                                { type = predicates.enum [ "image" ], }
                                {  }
                                true
                                predicates.always)
                                (predicates.records.record
                                {
                                  image = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.oneOf
                                        [
                                          predicates.allOf
                                          [
                                            predicates.records.required
                                            [ "auto" ],
                                            predicates.records.record {  } {  }
                                            true
                                            predicates.always
                                          ],
                                          predicates.allOf
                                          [
                                            predicates.records.required
                                            [ "custom" ],
                                            predicates.records.record {  } {  }
                                            true
                                            predicates.always
                                          ]
                                        ],
                                        predicates.records.record
                                        {
                                          auto = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.required
                                                [ "language", "versions" ],
                                                predicates.records.record
                                                {
                                                  language = predicates.isType
                                                      '"String",
                                                  versions = predicates.allOf
                                                      [
                                                        predicates.isType
                                                        '"Array",
                                                        predicates.arrays.arrayOf
                                                        (predicates.anyOf
                                                        [
                                                          predicates.isType
                                                          '"String",
                                                          predicates.isType
                                                          '"Number"
                                                        ])
                                                      ],
                                                }
                                                {  }
                                                true
                                                predicates.always
                                              ],
                                          custom = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.required
                                                [ "name", "tag" ],
                                                predicates.records.record
                                                {
                                                  autoPull = predicates.isType
                                                      '"Bool",
                                                  name = predicates.isType
                                                      '"String",
                                                  options = predicates.isType
                                                      '"String",
                                                  region = predicates.isType
                                                      '"String",
                                                  registry = predicates.isType
                                                      '"String",
                                                  sourceRepository =
                                                    predicates.isType '"String",
                                                  tag = predicates.isType
                                                      '"String",
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
                                  type = predicates.enum [ "image" ],
                                }
                                {  }
                                false
                                predicates.never)
                                (predicates.records.record
                                { type = predicates.enum [ "host" ], }
                                {  }
                                false
                                predicates.never),
                                predicates.records.required [ "type" ],
                                predicates.records.record
                                {
                                  type = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum [ "image", "host" ]
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  name = predicates.isType '"String",
                  steps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Step,
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Resource
            | doc m%"
            https://www.jfrog.com/confluence/display/JFROG/Pipelines+Resources
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "Aql" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/Aql"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "BuildInfo" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/BuildInfo"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "CronTrigger" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/CronTrigger"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "DistributionRule" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/DistributionRule"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "FileSpec" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/FileSpec"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "GitRepo" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/GitRepo"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "HelmChart" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/HelmChart"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "Image" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/Image"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "IncomingWebhook" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/IncomingWebhook"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "OutgoingWebhook" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/OutgoingWebhook"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "PropertyBag" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/PropertyBag"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "ReleaseBundle" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/ReleaseBundle"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "RemoteFile" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/RemoteFile"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "VmCluster" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."resourceTypes/VmCluster"
                  predicates.always
                ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Aql",
                          "BuildInfo",
                          "CronTrigger",
                          "DistributionRule",
                          "FileSpec",
                          "GitRepo",
                          "HelmChart",
                          "Image",
                          "IncomingWebhook",
                          "OutgoingWebhook",
                          "PropertyBag",
                          "ReleaseBundle",
                          "RemoteFile",
                          "VmCluster"
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          Step
            | doc m%"
            https://www.jfrog.com/confluence/display/JFROG/Pipelines+Steps
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "Bash" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/BashStep"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "CreateReleaseBundle" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/CreateReleaseBundle"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "DistributeReleaseBundle" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/DistributeReleaseBundle"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "DockerBuild" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/DockerBuild"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "DockerPush" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/DockerPush"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "GoBuild" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/GoBuild"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "GoPublishBinary" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/GoPublishBinary"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "GoPublishModule" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/GoPublishModule"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "GradleBuild" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/GradleBuild"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "HelmBlueGreenCleanup" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/HelmBlueGreenCleanup"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "HelmBlueGreenDeploy" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/HelmBlueGreenDeploy"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "HelmBlueGreenRoleSwitch" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/HelmBlueGreenRoleSwitch"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "HelmDeploy" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/HelmDeploy"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "HelmPublish" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/HelmPublish"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "Jenkins" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/Jenkins"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "Matrix" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/Matrix"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "PreMatrix" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/PreMatrix"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "PostMatrix" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/PostMatrix"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "MvnBuild" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/MvnBuild"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "NpmBuild" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/NpmBuild"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "NpmPublish" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/NpmPublish"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "PowerShell" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/PowerShell"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "PromoteBuild" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/PromoteBuild"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "PublishBuildInfo" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/PublishBuildInfo"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "PushArtifactoryPackage" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/PushArtifactoryPackage"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "SignReleaseBundle" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/SignReleaseBundle"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "TriggerPipeline" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/TriggerPipeline"
                  predicates.always,
                  predicates.ifThenElse
                  (predicates.records.record
                  { type = predicates.enum [ "XrayScan" ], }
                  {  }
                  true
                  predicates.always)
                  definitions.predicate."stepTypes/XrayScan"
                  predicates.always
                ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Bash",
                          "CreateReleaseBundle",
                          "DistributeReleaseBundle",
                          "DockerBuild",
                          "DockerPush",
                          "GoBuild",
                          "GoPublishBinary",
                          "GoPublishModule",
                          "GradleBuild",
                          "HelmBlueGreenCleanup",
                          "HelmBlueGreenDeploy",
                          "HelmBlueGreenRoleSwitch",
                          "HelmDeploy",
                          "HelmPublish",
                          "Jenkins",
                          "Matrix",
                          "MvnBuild",
                          "NpmBuild",
                          "NpmPublish",
                          "PostMatrix",
                          "PowerShell",
                          "PreMatrix",
                          "PromoteBuild",
                          "PublishBuildInfo",
                          "PushArtifactoryPackage",
                          "SignReleaseBundle",
                          "TriggerPipeline",
                          "XrayScan"
                        ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          common = predicates.always,
          resourceTypes = predicates.always,
          stepTypes = predicates.always,
        },
  }
in

definitions.contract.JFrog-Pipelines