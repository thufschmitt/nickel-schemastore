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
          Active = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'SNAPSHOT,
                  'RELEASE_PRERELEASE,
                  'PRERELEASE,
                  'RELEASE,
                  'NEVER,
                  'ALWAYS
                |]
              ],
          Algorithm = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'SHA3_512,
                  'SHA3_384,
                  'SHA3_256,
                  'SHA3_224,
                  'SHA_512,
                  'SHA_384,
                  'SHA_256,
                  'SHA_1,
                  'RMD160,
                  'MD5,
                  'MD2
                |]
              ],
          Announce = {
                active | definitions.contract.Active | optional,
                article | definitions.contract.ArticleAnnouncer | optional,
                bluesky | definitions.contract.BlueskyAnnouncer | optional,
                configuredHttp | definitions.contract.HttpAnnouncers | optional,
                configuredWebhooks
                  | definitions.contract.WebhooksAnnouncer
                  | optional,
                discord
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.DiscordAnnouncer, predicates.always ])
                  | optional,
                discourse | definitions.contract.DiscourseAnnouncer | optional,
                discussions
                  | definitions.contract.DiscussionsAnnouncer
                  | optional,
                gitter
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.GitterAnnouncer, predicates.always ])
                  | optional,
                googleChat
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.GoogleChatAnnouncer,
                    predicates.always
                  ])
                  | optional,
                http
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.HttpAnnouncerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.HttpAnnouncer
                    ]
                  ])
                  | optional,
                linkedin | definitions.contract.LinkedinAnnouncer | optional,
                mail
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.SmtpAnnouncer, predicates.always ])
                  | optional,
                mastodon | definitions.contract.MastodonAnnouncer | optional,
                mattermost
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.MattermostAnnouncer,
                    predicates.always
                  ])
                  | optional,
                openCollective
                  | definitions.contract.OpenCollectiveAnnouncer
                  | optional,
                sdkman | definitions.contract.SdkmanAnnouncer | optional,
                slack | definitions.contract.SlackAnnouncer | optional,
                smtp | definitions.contract.SmtpAnnouncer | optional,
                teams
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ definitions.predicate.TeamsAnnouncer, predicates.always ])
                  | optional,
                telegram | definitions.contract.TelegramAnnouncer | optional,
                twitter | definitions.contract.TwitterAnnouncer | optional,
                webhooks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.WebhookAnnouncerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.WebhookAnnouncer
                    ]
                  ])
                  | optional,
                zulip | definitions.contract.ZulipAnnouncer | optional,
              },
          AppImagePackager = {
                active | definitions.contract.Active | optional,
                categories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                componentId | String | optional,
                continueOnError | Bool | optional,
                developerName | String | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                icons
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Icon
                  ])
                  | optional,
                repository | definitions.contract.AppImageRepository | optional,
                requiresTerminal | Bool | optional,
                screenshots
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Screenshot
                  ])
                  | optional,
                skipReleases
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                templateDirectory | String | optional,
              },
          AppImageRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          Append = {
                content | String | optional,
                contentTemplate | String | optional,
                enabled | Bool | optional,
                target | String | optional,
                title | String | optional,
              },
          ApplicationPackage = {
                appName | String | optional,
                appVersion | String | optional,
                copyright | String | optional,
                fileAssociations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                licenseFile | String | optional,
                vendor | String | optional,
              },
          Apply = std.contract.Sequence
              [ std.enum.TagOrString, [| 'FORCE, 'WARN, 'ALWAYS, 'NEVER |] ],
          Architecture = {
                buildOn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                ignoreError | Bool | optional,
                runOn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          ArchiveAssembler = {
                active | definitions.contract.Active | optional,
                archiveName | String | optional,
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Artifact
                  ])
                  | optional,
                attachPlatform | Bool | optional,
                distributionType
                  | definitions.contract.DistributionType
                  | optional,
                exported | Bool | optional,
                extraProperties | definitions.contract.Properties | optional,
                fileSets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.FileSet
                  ])
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Glob
                  ])
                  | optional,
                formats
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Format-1
                  ])
                  | optional,
                options | definitions.contract.ArchiveOptions | optional,
                platform | definitions.contract.Platform | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                stereotype | definitions.contract.Stereotype | optional,
                templateDirectory | String | optional,
              },
          ArchiveAssemblerMap = predicates.contract_from_predicate
              definitions.predicate.ArchiveAssemblerMap,
          ArchiveOptions = {
                bigNumberMode | definitions.contract.TarMode | optional,
                longFileMode | definitions.contract.TarMode | optional,
                timestamp | String | optional,
              },
          ArticleAnnouncer = {
                active | definitions.contract.Active | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Artifact
                  ])
                  | optional,
                readTimeout | std.number.Integer | optional,
                repository | definitions.contract.Repository | optional,
                templateDirectory | String | optional,
              },
          Artifact = {
                active | definitions.contract.Active | optional,
                extraProperties | definitions.contract.Properties | optional,
                path | String | optional,
                platform | String | optional,
                transform | String | optional,
              },
          ArtifactOverride = {
                artifactId | String | optional,
                groupId | String | optional,
                javadocJar | Bool | optional,
                sourceJar | Bool | optional,
              },
          ArtifactoryMavenDeployer = {
                active | definitions.contract.Active | optional,
                applyMavenCentralRules | Bool | optional,
                artifactOverrides
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ArtifactOverride
                  ])
                  | optional,
                authorization | definitions.contract.Authorization | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                javadocJar | Bool | optional,
                password | String | optional,
                readTimeout | std.number.Integer | optional,
                sign | Bool | optional,
                sourceJar | Bool | optional,
                stagingRepositories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                url | String | optional,
                username | String | optional,
                verifyPom | Bool | optional,
              },
          ArtifactoryMavenDeployerMap = predicates.contract_from_predicate
              definitions.predicate.ArtifactoryMavenDeployerMap,
          ArtifactoryRepository = {
                active | definitions.contract.Active | optional,
                fileTypes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.FileType
                  ])
                  | optional,
                path | String | optional,
              },
          ArtifactoryUploader = {
                active | definitions.contract.Active | optional,
                artifacts | Bool | optional,
                authorization | definitions.contract.Authorization | optional,
                catalogs | Bool | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                files | Bool | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                host | String | optional,
                password | String | optional,
                readTimeout | std.number.Integer | optional,
                repositories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ArtifactoryRepository
                  ])
                  | optional,
                signatures | Bool | optional,
                username | String | optional,
              },
          ArtifactoryUploaderMap = predicates.contract_from_predicate
              definitions.predicate.ArtifactoryUploaderMap,
          AsdfPackager = {
                active | definitions.contract.Active | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                continueOnError | Bool | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                repository | definitions.contract.AsdfRepository | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                templateDirectory | String | optional,
                toolCheck | String | optional,
              },
          AsdfRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          Assemble = {
                active | definitions.contract.Active | optional,
                archive
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.ArchiveAssemblerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.ArchiveAssembler
                    ]
                  ])
                  | optional,
                javaArchive
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.JavaArchiveAssemblerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.JavaArchiveAssembler
                    ]
                  ])
                  | optional,
                jlink
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.JlinkAssemblerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.JlinkAssembler
                    ]
                  ])
                  | optional,
                jpackage
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.JpackageAssemblerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.JpackageAssembler
                    ]
                  ])
                  | optional,
                nativeImage
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.NativeImageAssemblerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.NativeImageAssembler
                    ]
                  ])
                  | optional,
              },
          Asset = {
                input | String | optional,
                output | String | optional,
                unpack | definitions.contract.Unpack | optional,
              },
          Authorization = std.contract.Sequence
              [ std.enum.TagOrString, [| 'BEARER, 'BASIC, 'NONE |] ],
          AzureMavenDeployer = {
                active | definitions.contract.Active | optional,
                applyMavenCentralRules | Bool | optional,
                artifactOverrides
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ArtifactOverride
                  ])
                  | optional,
                authorization | definitions.contract.Authorization | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                javadocJar | Bool | optional,
                password | String | optional,
                readTimeout | std.number.Integer | optional,
                sign | Bool | optional,
                sourceJar | Bool | optional,
                stagingRepositories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                url | String | optional,
                username | String | optional,
                verifyPom | Bool | optional,
              },
          AzureMavenDeployerMap = predicates.contract_from_predicate
              definitions.predicate.AzureMavenDeployerMap,
          BlueskyAnnouncer = {
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                handle | String | optional,
                host | String | optional,
                password | String | optional,
                readTimeout | std.number.Integer | optional,
                status | String | optional,
                statusTemplate | String | optional,
                statuses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          BrewPackager = {
                active | definitions.contract.Active | optional,
                cask | definitions.contract.Cask | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                continueOnError | Bool | optional,
                dependencies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Dependency
                  ])
                  | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                formulaName | String | optional,
                livecheck
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                multiPlatform | Bool | optional,
                repository | definitions.contract.HomebrewRepository | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                templateDirectory | String | optional,
              },
          Buildx = {
                createBuilder | Bool | optional,
                createBuilderFlags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                enabled | Bool | optional,
                platforms
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          Cask = {
                appName | String | optional,
                appcast | String | optional,
                displayName | String | optional,
                enabled | Bool | optional,
                name | String | optional,
                pkgName | String | optional,
                uninstall
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.CaskItem
                  ])
                  | optional,
                zap
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.CaskItem
                  ])
                  | optional,
              },
          CaskItem = {
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                name | String | optional,
              },
          Catalog = {
                active | definitions.contract.Active | optional,
                sbom | definitions.contract.Sbom | optional,
                slsa | definitions.contract.SlsaCataloger | optional,
              },
          Category = {
                format | String | optional,
                key | String | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                order | std.number.Integer | optional,
                title | String | optional,
              },
          Changelog = {
                append | definitions.contract.Append | optional,
                categories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Category
                  ])
                  | optional,
                categoryTitleFormat | String | optional,
                content | String | optional,
                contentTemplate | String | optional,
                contributors | definitions.contract.Contributors | optional,
                contributorsTitleFormat | String | optional,
                enabled | Bool | optional,
                excludeLabels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                external | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                format | String | optional,
                formatted | definitions.contract.Active | optional,
                hide | definitions.contract.Hide | optional,
                includeLabels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                labelers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Labeler
                  ])
                  | optional,
                links | Bool | optional,
                preset | String | optional,
                replacers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Replacer
                  ])
                  | optional,
                skipMergeCommits | Bool | optional,
                sort | definitions.contract.Sort | optional,
              },
          Checksum = {
                algorithms
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Algorithm
                  ])
                  | optional,
                artifacts | Bool | optional,
                files | Bool | optional,
                individual | Bool | optional,
                name | String | optional,
              },
          ChocolateyPackager = {
                active | definitions.contract.Active | optional,
                apiKey | String | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                continueOnError | Bool | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                iconUrl | String | optional,
                packageName | String | optional,
                packageVersion | String | optional,
                remoteBuild | Bool | optional,
                repository
                  | definitions.contract.ChocolateyRepository
                  | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                source | String | optional,
                templateDirectory | String | optional,
                title | String | optional,
                username | String | optional,
              },
          ChocolateyRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          CodebergReleaser = {
                apiEndpoint | String | optional,
                artifacts | Bool | optional,
                branch | String | optional,
                branchPush | String | optional,
                catalogs | Bool | optional,
                changelog | definitions.contract.Changelog | optional,
                checksums | Bool | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                commitUrl | String | optional,
                connectTimeout | std.number.Integer | optional,
                downloadUrl | String | optional,
                draft | Bool | optional,
                enabled | Bool | optional,
                files | Bool | optional,
                host | String | optional,
                issueTrackerUrl | String | optional,
                issues | definitions.contract.Issues | optional,
                latestReleaseUrl | String | optional,
                milestone | definitions.contract.Milestone | optional,
                name | String | optional,
                overwrite | Bool | optional,
                owner | String | optional,
                prerelease | definitions.contract.Prerelease | optional,
                previousTagName | String | optional,
                readTimeout | std.number.Integer | optional,
                releaseName | String | optional,
                releaseNotesUrl | String | optional,
                repoCloneUrl | String | optional,
                repoUrl | String | optional,
                sign | Bool | optional,
                signatures | Bool | optional,
                skipRelease | Bool | optional,
                skipTag | Bool | optional,
                srcUrl | String | optional,
                tagName | String | optional,
                token | String | optional,
                update | definitions.contract.Update | optional,
                uploadAssets | definitions.contract.Active | optional,
                username | String | optional,
              },
          Command-1 = std.contract.Sequence
              [ std.enum.TagOrString, [| 'MINOR, 'MAJOR |] ],
          Command-2 = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                defaultKeyring | Bool | optional,
                executable | String | optional,
                homeDir | String | optional,
                keyName | String | optional,
                publicKeyring | String | optional,
              },
          CommandHook = {
                active | definitions.contract.Active | optional,
                cmd | String | optional,
                condition | String | optional,
                continueOnError | Bool | optional,
                environment
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                filter | definitions.contract.Filter | optional,
                platforms
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                verbose | Bool | optional,
              },
          CommandHooks = {
                active | definitions.contract.Active | optional,
                before
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.CommandHook
                  ])
                  | optional,
                environment
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                failure
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.CommandHook
                  ])
                  | optional,
                success
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.CommandHook
                  ])
                  | optional,
              },
          CommitAuthor = {
                email | String | optional,
                name | String | optional,
              },
          Contributors = {
                enabled | Bool | optional,
                format | String | optional,
              },
          Cosign = {
                privateKeyFile | String | optional,
                publicKeyFile | String | optional,
                version | String | optional,
              },
          CyclonedxSbomCataloger = {
                active | definitions.contract.Active | optional,
                distributions | Bool | optional,
                extraProperties | definitions.contract.Properties | optional,
                files | Bool | optional,
                formats
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Format-2
                  ])
                  | optional,
                pack | definitions.contract.Pack | optional,
                version | String | optional,
              },
          Dependency = { key | String | optional, value | String | optional, },
          Deploy = {
                active | definitions.contract.Active | optional,
                maven | definitions.contract.Maven | optional,
              },
          DiscordAnnouncer = {
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                message | String | optional,
                messageTemplate | String | optional,
                readTimeout | std.number.Integer | optional,
                webhook | String | optional,
              },
          DiscourseAnnouncer = {
                active | definitions.contract.Active | optional,
                apiKey | String | optional,
                categoryName | String | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                host | String | optional,
                message | String | optional,
                messageTemplate | String | optional,
                readTimeout | std.number.Integer | optional,
                title | String | optional,
                username | String | optional,
              },
          DiscussionsAnnouncer = {
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                message | String | optional,
                messageTemplate | String | optional,
                organization | String | optional,
                readTimeout | std.number.Integer | optional,
                team | String | optional,
                title | String | optional,
              },
          Distribution = {
                active | definitions.contract.Active | optional,
                appImage | definitions.contract.AppImagePackager | optional,
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Artifact
                  ])
                  | optional,
                asdf | definitions.contract.AsdfPackager | optional,
                brew | definitions.contract.BrewPackager | optional,
                chocolatey | definitions.contract.ChocolateyPackager | optional,
                docker | definitions.contract.DockerPackager | optional,
                executable | definitions.contract.Executable | optional,
                extraProperties | definitions.contract.Properties | optional,
                flatpak | definitions.contract.FlatpakPackager | optional,
                gofish | definitions.contract.GofishPackager | optional,
                java | definitions.contract.Java-2 | optional,
                jbang | definitions.contract.JbangPackager | optional,
                jib | definitions.contract.JibPackager | optional,
                macports | definitions.contract.MacportsPackager | optional,
                name | String | optional,
                platform | definitions.contract.Platform | optional,
                scoop | definitions.contract.ScoopPackager | optional,
                sdkman | definitions.contract.SdkmanPackager | optional,
                snap | definitions.contract.SnapPackager | optional,
                spec | definitions.contract.SpecPackager | optional,
                stereotype | definitions.contract.Stereotype | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                type | definitions.contract.DistributionType | optional,
                winget | definitions.contract.WingetPackager | optional,
              },
          DistributionMap = predicates.contract_from_predicate
              definitions.predicate.DistributionMap,
          DistributionType = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'NATIVE_PACKAGE,
                  'NATIVE_IMAGE,
                  'SINGLE_JAR,
                  'JLINK,
                  'JAVA_BINARY,
                  'FLAT_BINARY,
                  'BINARY
                |]
              ],
          DockerPackager = {
                active | definitions.contract.Active | optional,
                baseImage | String | optional,
                buildArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                buildx | definitions.contract.Buildx | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                continueOnError | Bool | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                imageNames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                postCommands
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                preCommands
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                registries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Registry-1
                  ])
                  | optional,
                repository | definitions.contract.DockerRepository | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                specs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.DockerSpecMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.DockerSpec
                    ]
                  ])
                  | optional,
                templateDirectory | String | optional,
                useLocalArtifact | Bool | optional,
              },
          DockerRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
                versionedSubfolders | Bool | optional,
              },
          DockerSpec = {
                active | definitions.contract.Active | optional,
                artifact | definitions.contract.Artifact | optional,
                baseImage | String | optional,
                buildArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                buildx | definitions.contract.Buildx | optional,
                extraProperties | definitions.contract.Properties | optional,
                imageNames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                matchers | definitions.contract.Properties | optional,
                name | String | optional,
                postCommands
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                preCommands
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                registries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Registry-1
                  ])
                  | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                templateDirectory | String | optional,
                useLocalArtifact | Bool | optional,
              },
          DockerSpecMap = predicates.contract_from_predicate
              definitions.predicate.DockerSpecMap,
          Download = {
                active | definitions.contract.Active | optional,
                ftp
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.FtpDownloaderMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.FtpDownloader
                    ]
                  ])
                  | optional,
                http
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.HttpDownloaderMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.HttpDownloader
                    ]
                  ])
                  | optional,
                scp
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.ScpDownloaderMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.ScpDownloader
                    ]
                  ])
                  | optional,
                sftp
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.SftpDownloaderMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.SftpDownloader
                    ]
                  ])
                  | optional,
              },
          Environment = {
                properties | definitions.contract.Properties | optional,
                variables | String | optional,
              },
          Executable = {
                name | String | optional,
                unixExtension | String | optional,
                windowsExtension | String | optional,
              },
          Extension = {
                directory | String | optional,
                enabled | Bool | optional,
                gav | String | optional,
                name | String | optional,
                providers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Provider
                  ])
                  | optional,
              },
          ExtensionMap = predicates.contract_from_predicate
              definitions.predicate.ExtensionMap,
          FileSet = {
                active | definitions.contract.Active | optional,
                excludes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extraProperties | definitions.contract.Properties | optional,
                failOnMissingInput | Bool | optional,
                includes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                input | String | optional,
                output | String | optional,
                platform | String | optional,
              },
          FileType = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'ZST,
                  'ZIP,
                  'TXZ,
                  'TGZ,
                  'TBZ2,
                  'TAR_ZST,
                  'TAR_XZ,
                  'TAR_GZ,
                  'TAR_BZ2,
                  'TAR,
                  'SIG,
                  'SH,
                  'RPM,
                  'PS1,
                  'PKG,
                  'NUGET,
                  'MSI,
                  'JAR,
                  'EXE,
                  'DMG,
                  'DEB,
                  'CMD,
                  'BAT,
                  'ASC
                |]
              ],
          Files = {
                active | definitions.contract.Active | optional,
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Artifact
                  ])
                  | optional,
                globs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Glob
                  ])
                  | optional,
              },
          Filter = {
                excludes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                includes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          FlatpakPackager = {
                active | definitions.contract.Active | optional,
                categories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                componentId | String | optional,
                continueOnError | Bool | optional,
                developerName | String | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                finishArgs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                icons
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Icon
                  ])
                  | optional,
                repository | definitions.contract.FlatpakRepository | optional,
                runtime | definitions.contract.Runtime | optional,
                runtimeVersion | String | optional,
                screenshots
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Screenshot
                  ])
                  | optional,
                sdkExtensions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                skipReleases
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                templateDirectory | String | optional,
              },
          FlatpakRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          Format-1 = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'TXZ,
                  'TGZ,
                  'TBZ2,
                  'TAR_ZST,
                  'TAR_XZ,
                  'TAR_GZ,
                  'TAR_BZ2,
                  'TAR,
                  'ZIP
                |]
              ],
          Format-2 = std.contract.Sequence
              [ std.enum.TagOrString, [| 'PROTOBUF, 'XML, 'JSON |] ],
          Format-3 = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'TEXT,
                  'TABLE,
                  'SPDX_JSON,
                  'GITHUB_JSON,
                  'CYCLONEDX_JSON,
                  'CYCLONEDX_XML,
                  'SYFT_JSON
                |]
              ],
          Format-4 = std.contract.Sequence
              [ std.enum.TagOrString, [| 'OCI, 'DOCKER |] ],
          FtpDownloader = {
                active | definitions.contract.Active | optional,
                assets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Asset
                  ])
                  | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                host | String | optional,
                password | String | optional,
                port | std.number.Integer | optional,
                readTimeout | std.number.Integer | optional,
                username | String | optional,
              },
          FtpDownloaderMap = predicates.contract_from_predicate
              definitions.predicate.FtpDownloaderMap,
          FtpUploader = {
                active | definitions.contract.Active | optional,
                artifacts | Bool | optional,
                catalogs | Bool | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                files | Bool | optional,
                host | String | optional,
                password | String | optional,
                path | String | optional,
                port | std.number.Integer | optional,
                readTimeout | std.number.Integer | optional,
                signatures | Bool | optional,
                username | String | optional,
              },
          FtpUploaderMap = predicates.contract_from_predicate
              definitions.predicate.FtpUploaderMap,
          GenericGitReleaser = {
                apiEndpoint | String | optional,
                artifacts | Bool | optional,
                branch | String | optional,
                branchPush | String | optional,
                catalogs | Bool | optional,
                changelog | definitions.contract.Changelog | optional,
                checksums | Bool | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                commitUrl | String | optional,
                connectTimeout | std.number.Integer | optional,
                downloadUrl | String | optional,
                enabled | Bool | optional,
                files | Bool | optional,
                host | String | optional,
                issueTrackerUrl | String | optional,
                issues | definitions.contract.Issues | optional,
                latestReleaseUrl | String | optional,
                milestone | definitions.contract.Milestone | optional,
                name | String | optional,
                overwrite | Bool | optional,
                owner | String | optional,
                prerelease | definitions.contract.Prerelease | optional,
                previousTagName | String | optional,
                readTimeout | std.number.Integer | optional,
                releaseName | String | optional,
                releaseNotesUrl | String | optional,
                repoCloneUrl | String | optional,
                repoUrl | String | optional,
                sign | Bool | optional,
                signatures | Bool | optional,
                skipRelease | Bool | optional,
                skipTag | Bool | optional,
                srcUrl | String | optional,
                tagName | String | optional,
                token | String | optional,
                update | definitions.contract.Update | optional,
                uploadAssets | definitions.contract.Active | optional,
                username | String | optional,
              },
          GiteaMavenDeployer = {
                active | definitions.contract.Active | optional,
                applyMavenCentralRules | Bool | optional,
                artifactOverrides
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ArtifactOverride
                  ])
                  | optional,
                authorization | definitions.contract.Authorization | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                javadocJar | Bool | optional,
                password | String | optional,
                readTimeout | std.number.Integer | optional,
                sign | Bool | optional,
                sourceJar | Bool | optional,
                stagingRepositories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                url | String | optional,
                username | String | optional,
                verifyPom | Bool | optional,
              },
          GiteaMavenDeployerMap = predicates.contract_from_predicate
              definitions.predicate.GiteaMavenDeployerMap,
          GiteaReleaser = {
                apiEndpoint | String | optional,
                artifacts | Bool | optional,
                branch | String | optional,
                branchPush | String | optional,
                catalogs | Bool | optional,
                changelog | definitions.contract.Changelog | optional,
                checksums | Bool | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                commitUrl | String | optional,
                connectTimeout | std.number.Integer | optional,
                downloadUrl | String | optional,
                draft | Bool | optional,
                enabled | Bool | optional,
                files | Bool | optional,
                host | String | optional,
                issueTrackerUrl | String | optional,
                issues | definitions.contract.Issues | optional,
                latestReleaseUrl | String | optional,
                milestone | definitions.contract.Milestone | optional,
                name | String | optional,
                overwrite | Bool | optional,
                owner | String | optional,
                prerelease | definitions.contract.Prerelease | optional,
                previousTagName | String | optional,
                readTimeout | std.number.Integer | optional,
                releaseName | String | optional,
                releaseNotesUrl | String | optional,
                repoCloneUrl | String | optional,
                repoUrl | String | optional,
                sign | Bool | optional,
                signatures | Bool | optional,
                skipRelease | Bool | optional,
                skipTag | Bool | optional,
                srcUrl | String | optional,
                tagName | String | optional,
                token | String | optional,
                update | definitions.contract.Update | optional,
                uploadAssets | definitions.contract.Active | optional,
                username | String | optional,
              },
          GiteaUploader = {
                active | definitions.contract.Active | optional,
                artifacts | Bool | optional,
                catalogs | Bool | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                files | Bool | optional,
                host | String | optional,
                owner | String | optional,
                packageName | String | optional,
                packageVersion | String | optional,
                readTimeout | std.number.Integer | optional,
                signatures | Bool | optional,
                token | String | optional,
              },
          GiteaUploaderMap = predicates.contract_from_predicate
              definitions.predicate.GiteaUploaderMap,
          GithubMavenDeployer = {
                active | definitions.contract.Active | optional,
                applyMavenCentralRules | Bool | optional,
                artifactOverrides
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ArtifactOverride
                  ])
                  | optional,
                authorization | definitions.contract.Authorization | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                javadocJar | Bool | optional,
                password | String | optional,
                readTimeout | std.number.Integer | optional,
                repository | String | optional,
                sign | Bool | optional,
                sourceJar | Bool | optional,
                stagingRepositories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                url | String | optional,
                username | String | optional,
                verifyPom | Bool | optional,
              },
          GithubMavenDeployerMap = predicates.contract_from_predicate
              definitions.predicate.GithubMavenDeployerMap,
          GithubReleaser = {
                apiEndpoint | String | optional,
                artifacts | Bool | optional,
                branch | String | optional,
                branchPush | String | optional,
                catalogs | Bool | optional,
                changelog | definitions.contract.Changelog | optional,
                checksums | Bool | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                commitUrl | String | optional,
                connectTimeout | std.number.Integer | optional,
                discussionCategoryName | String | optional,
                downloadUrl | String | optional,
                draft | Bool | optional,
                enabled | Bool | optional,
                files | Bool | optional,
                host | String | optional,
                issueTrackerUrl | String | optional,
                issues | definitions.contract.Issues | optional,
                latestReleaseUrl | String | optional,
                milestone | definitions.contract.Milestone | optional,
                name | String | optional,
                overwrite | Bool | optional,
                owner | String | optional,
                prerelease | definitions.contract.Prerelease | optional,
                previousTagName | String | optional,
                readTimeout | std.number.Integer | optional,
                releaseName | String | optional,
                releaseNotes | definitions.contract.ReleaseNotes | optional,
                releaseNotesUrl | String | optional,
                repoCloneUrl | String | optional,
                repoUrl | String | optional,
                sign | Bool | optional,
                signatures | Bool | optional,
                skipRelease | Bool | optional,
                skipTag | Bool | optional,
                srcUrl | String | optional,
                tagName | String | optional,
                token | String | optional,
                update | definitions.contract.Update | optional,
                uploadAssets | definitions.contract.Active | optional,
                username | String | optional,
              },
          GitlabMavenDeployer = {
                active | definitions.contract.Active | optional,
                applyMavenCentralRules | Bool | optional,
                artifactOverrides
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ArtifactOverride
                  ])
                  | optional,
                authorization | definitions.contract.Authorization | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                javadocJar | Bool | optional,
                password | String | optional,
                projectIdentifier | String | optional,
                readTimeout | std.number.Integer | optional,
                sign | Bool | optional,
                sourceJar | Bool | optional,
                stagingRepositories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                url | String | optional,
                username | String | optional,
                verifyPom | Bool | optional,
              },
          GitlabMavenDeployerMap = predicates.contract_from_predicate
              definitions.predicate.GitlabMavenDeployerMap,
          GitlabReleaser = {
                apiEndpoint | String | optional,
                artifacts | Bool | optional,
                branch | String | optional,
                branchPush | String | optional,
                catalogs | Bool | optional,
                changelog | definitions.contract.Changelog | optional,
                checksums | Bool | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                commitUrl | String | optional,
                connectTimeout | std.number.Integer | optional,
                downloadUrl | String | optional,
                enabled | Bool | optional,
                files | Bool | optional,
                host | String | optional,
                issueTrackerUrl | String | optional,
                issues | definitions.contract.Issues | optional,
                latestReleaseUrl | String | optional,
                milestone | definitions.contract.Milestone | optional,
                name | String | optional,
                overwrite | Bool | optional,
                owner | String | optional,
                prerelease | definitions.contract.Prerelease | optional,
                previousTagName | String | optional,
                projectIdentifier | String | optional,
                readTimeout | std.number.Integer | optional,
                releaseName | String | optional,
                releaseNotesUrl | String | optional,
                repoCloneUrl | String | optional,
                repoUrl | String | optional,
                sign | Bool | optional,
                signatures | Bool | optional,
                skipRelease | Bool | optional,
                skipTag | Bool | optional,
                srcUrl | String | optional,
                tagName | String | optional,
                token | String | optional,
                update | definitions.contract.Update | optional,
                uploadAssets | definitions.contract.Active | optional,
                uploadLinks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                username | String | optional,
              },
          GitlabUploader = {
                active | definitions.contract.Active | optional,
                artifacts | Bool | optional,
                catalogs | Bool | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                files | Bool | optional,
                host | String | optional,
                packageName | String | optional,
                packageVersion | String | optional,
                projectIdentifier | String | optional,
                readTimeout | std.number.Integer | optional,
                signatures | Bool | optional,
                token | String | optional,
              },
          GitlabUploaderMap = predicates.contract_from_predicate
              definitions.predicate.GitlabUploaderMap,
          GitterAnnouncer = {
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                message | String | optional,
                messageTemplate | String | optional,
                readTimeout | std.number.Integer | optional,
                webhook | String | optional,
              },
          Glob = {
                active | definitions.contract.Active | optional,
                directory | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                pattern | String | optional,
                platform | String | optional,
              },
          GofishPackager = {
                active | definitions.contract.Active | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                continueOnError | Bool | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                repository | definitions.contract.GofishRepository | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                templateDirectory | String | optional,
              },
          GofishRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          GoogleChatAnnouncer = {
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                message | String | optional,
                messageTemplate | String | optional,
                readTimeout | std.number.Integer | optional,
                webhook | String | optional,
              },
          Hide = {
                categories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                contributors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                uncategorized | Bool | optional,
              },
          HomebrewRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          Hooks = {
                active | definitions.contract.Active | optional,
                command | definitions.contract.CommandHooks | optional,
                environment
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                script | definitions.contract.ScriptHooks | optional,
              },
          HttpAnnouncer = {
                active | definitions.contract.Active | optional,
                authorization | definitions.contract.Authorization | optional,
                bearerKeyword | String | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                method | definitions.contract.Method | optional,
                password | String | optional,
                payload | String | optional,
                payloadTemplate | String | optional,
                readTimeout | std.number.Integer | optional,
                url | String | optional,
                username | String | optional,
              },
          HttpAnnouncerMap = predicates.contract_from_predicate
              definitions.predicate.HttpAnnouncerMap,
          HttpAnnouncers = {
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                http
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.HttpAnnouncerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.HttpAnnouncer
                    ]
                  ])
                  | optional,
                readTimeout | std.number.Integer | optional,
              },
          HttpDownloader = {
                active | definitions.contract.Active | optional,
                assets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Asset
                  ])
                  | optional,
                authorization | definitions.contract.Authorization | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                password | String | optional,
                readTimeout | std.number.Integer | optional,
                username | String | optional,
              },
          HttpDownloaderMap = predicates.contract_from_predicate
              definitions.predicate.HttpDownloaderMap,
          HttpUploader = {
                active | definitions.contract.Active | optional,
                artifacts | Bool | optional,
                authorization | definitions.contract.Authorization | optional,
                catalogs | Bool | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                files | Bool | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                method | definitions.contract.Method | optional,
                password | String | optional,
                readTimeout | std.number.Integer | optional,
                signatures | Bool | optional,
                uploadUrl | String | optional,
                username | String | optional,
              },
          HttpUploaderMap = predicates.contract_from_predicate
              definitions.predicate.HttpUploaderMap,
          Icon = {
                extraProperties | definitions.contract.Properties | optional,
                height | std.number.Integer | optional,
                primary | Bool | optional,
                url | String | optional,
                width | std.number.Integer | optional,
              },
          Installer = {
                command | String | optional,
                modes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Mode-1
                  ])
                  | optional,
                scope | definitions.contract.Scope | optional,
                type | definitions.contract.Type-2 | optional,
                upgradeBehavior
                  | definitions.contract.UpgradeBehavior
                  | optional,
              },
          Issues = {
                applyMilestone | definitions.contract.Apply | optional,
                comment | String | optional,
                enabled | Bool | optional,
                label | definitions.contract.Label | optional,
              },
          JReleaserModel
            | doc m%"
            JReleaser 1.8.0
            "%
            = {
                announce | definitions.contract.Announce | optional,
                assemble | definitions.contract.Assemble | optional,
                catalog | definitions.contract.Catalog | optional,
                checksum | definitions.contract.Checksum | optional,
                deploy | definitions.contract.Deploy | optional,
                distributions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.DistributionMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.Distribution
                    ]
                  ])
                  | optional,
                download | definitions.contract.Download | optional,
                environment | definitions.contract.Environment | optional,
                extensions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.ExtensionMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.Extension
                    ]
                  ])
                  | optional,
                files | definitions.contract.Files | optional,
                hooks | definitions.contract.Hooks | optional,
                packagers | definitions.contract.Packagers | optional,
                platform | definitions.contract.Platform | optional,
                project | definitions.contract.Project | optional,
                release | definitions.contract.Release | optional,
                signing | definitions.contract.Signing | optional,
                upload | definitions.contract.Upload | optional,
              },
          Java-1 = {
                mainClass | String | optional,
                mainModule | String | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          Java-2 = {
                artifactId | String | optional,
                enabled | Bool | optional,
                extraProperties | definitions.contract.Properties | optional,
                groupId | String | optional,
                mainClass | String | optional,
                mainModule | String | optional,
                multiProject | Bool | optional,
                version | String | optional,
              },
          JavaArchive = {
                libDirectoryName | String | optional,
                mainJarName | String | optional,
                path | String | optional,
              },
          JavaArchiveAssembler = {
                active | definitions.contract.Active | optional,
                archiveName | String | optional,
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Artifact
                  ])
                  | optional,
                executable | definitions.contract.Executable | optional,
                exported | Bool | optional,
                extraProperties | definitions.contract.Properties | optional,
                fileSets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.FileSet
                  ])
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Glob
                  ])
                  | optional,
                formats
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Format-1
                  ])
                  | optional,
                jars
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Glob
                  ])
                  | optional,
                java | definitions.contract.Java-1 | optional,
                mainJar | definitions.contract.Artifact | optional,
                options | definitions.contract.ArchiveOptions | optional,
                platform | definitions.contract.Platform | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                stereotype | definitions.contract.Stereotype | optional,
                templateDirectory | String | optional,
              },
          JavaArchiveAssemblerMap = predicates.contract_from_predicate
              definitions.predicate.JavaArchiveAssemblerMap,
          JbangPackager = {
                active | definitions.contract.Active | optional,
                alias | String | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                continueOnError | Bool | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                repository | definitions.contract.JbangRepository | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                templateDirectory | String | optional,
              },
          JbangRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          Jdeps = {
                enabled | Bool | optional,
                ignoreMissingDeps | Bool | optional,
                multiRelease | String | optional,
                targets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                useWildcardInPath | Bool | optional,
              },
          JibPackager = {
                active | definitions.contract.Active | optional,
                baseImage | String | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                continueOnError | Bool | optional,
                creationTime | String | optional,
                downloadUrl | String | optional,
                environment
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                exposedPorts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extraProperties | definitions.contract.Properties | optional,
                format | definitions.contract.Format-4 | optional,
                imageNames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                registries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Registry-2
                  ])
                  | optional,
                repository | definitions.contract.JibRepository | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                specs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.JibSpecMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.JibSpec
                    ]
                  ])
                  | optional,
                templateDirectory | String | optional,
                user | String | optional,
                version | String | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                workingDirectory | String | optional,
              },
          JibRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
                versionedSubfolders | Bool | optional,
              },
          JibSpec = {
                active | definitions.contract.Active | optional,
                artifact | definitions.contract.Artifact | optional,
                baseImage | String | optional,
                creationTime | String | optional,
                environment
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                exposedPorts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extraProperties | definitions.contract.Properties | optional,
                format | definitions.contract.Format-4 | optional,
                imageNames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                matchers | definitions.contract.Properties | optional,
                name | String | optional,
                registries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Registry-2
                  ])
                  | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                templateDirectory | String | optional,
                user | String | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                workingDirectory | String | optional,
              },
          JibSpecMap = predicates.contract_from_predicate
              definitions.predicate.JibSpecMap,
          JlinkAssembler = {
                active | definitions.contract.Active | optional,
                additionalModuleNames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                archiveFormat | definitions.contract.Format-1 | optional,
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Artifact
                  ])
                  | optional,
                copyJars | Bool | optional,
                executable | String | optional,
                exported | Bool | optional,
                extraProperties | definitions.contract.Properties | optional,
                fileSets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.FileSet
                  ])
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Glob
                  ])
                  | optional,
                imageName | String | optional,
                imageNameTransform | String | optional,
                jars
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Glob
                  ])
                  | optional,
                java | definitions.contract.Java-2 | optional,
                javaArchive | definitions.contract.JavaArchive | optional,
                jdeps | definitions.contract.Jdeps | optional,
                jdk | definitions.contract.Artifact | optional,
                mainJar | definitions.contract.Artifact | optional,
                moduleNames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                options | definitions.contract.ArchiveOptions | optional,
                platform | definitions.contract.Platform | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                stereotype | definitions.contract.Stereotype | optional,
                targetJdks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Artifact
                  ])
                  | optional,
                templateDirectory | String | optional,
              },
          JlinkAssemblerMap = predicates.contract_from_predicate
              definitions.predicate.JlinkAssemblerMap,
          JpackageAssembler = {
                active | definitions.contract.Active | optional,
                applicationPackage
                  | definitions.contract.ApplicationPackage
                  | optional,
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Artifact
                  ])
                  | optional,
                attachPlatform | Bool | optional,
                executable | String | optional,
                exported | Bool | optional,
                extraProperties | definitions.contract.Properties | optional,
                fileSets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.FileSet
                  ])
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Glob
                  ])
                  | optional,
                jars
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Glob
                  ])
                  | optional,
                java | definitions.contract.Java-2 | optional,
                jlink | String | optional,
                launcher | definitions.contract.Launcher | optional,
                linux | definitions.contract.Linux-1 | optional,
                mainJar | definitions.contract.Artifact | optional,
                osx | definitions.contract.Osx-1 | optional,
                platform | definitions.contract.Platform | optional,
                runtimeImages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Artifact
                  ])
                  | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                stereotype | definitions.contract.Stereotype | optional,
                templateDirectory | String | optional,
                verbose | Bool | optional,
                windows | definitions.contract.Windows-1 | optional,
              },
          JpackageAssemblerMap = predicates.contract_from_predicate
              definitions.predicate.JpackageAssemblerMap,
          Label = {
                color | String | optional,
                description | String | optional,
                name | String | optional,
              },
          Labeler = {
                body | String | optional,
                label | String | optional,
                order | std.number.Integer | optional,
                title | String | optional,
              },
          Launcher = {
                arguments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                javaOptions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                launchers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          LinkedinAnnouncer = {
                accessToken | String | optional,
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                message | String | optional,
                messageTemplate | String | optional,
                owner | String | optional,
                readTimeout | std.number.Integer | optional,
                subject | String | optional,
              },
          Links = {
                bugTracker | String | optional,
                contact | String | optional,
                contribute | String | optional,
                documentation | String | optional,
                donation | String | optional,
                faq | String | optional,
                help | String | optional,
                homepage | String | optional,
                license | String | optional,
                translate | String | optional,
                vcsBrowser | String | optional,
              },
          Linux-1 = {
                appCategory | String | optional,
                appName | String | optional,
                appRelease | String | optional,
                icon | String | optional,
                installDir | String | optional,
                jdk | definitions.contract.Artifact | optional,
                license | String | optional,
                maintainer | String | optional,
                menuGroup | String | optional,
                packageDeps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                packageName | String | optional,
                platform | String | optional,
                resourceDir | String | optional,
                shortcut | Bool | optional,
                types
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                validTypes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          Linux-2 = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                platform | String | optional,
              },
          MacportsPackager = {
                active | definitions.contract.Active | optional,
                categories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                continueOnError | Bool | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                maintainers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                packageName | String | optional,
                repository | definitions.contract.MacportsRepository | optional,
                revision | std.number.Integer | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                templateDirectory | String | optional,
              },
          MacportsRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          MastodonAnnouncer = {
                accessToken | String | optional,
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                host | String | optional,
                readTimeout | std.number.Integer | optional,
                status | String | optional,
                statusTemplate | String | optional,
                statuses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          MattermostAnnouncer = {
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                message | String | optional,
                messageTemplate | String | optional,
                readTimeout | std.number.Integer | optional,
                structuredMessage | Bool | optional,
                webhook | String | optional,
              },
          Maven = {
                active | definitions.contract.Active | optional,
                artifactory
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.ArtifactoryMavenDeployerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.ArtifactoryMavenDeployer
                    ]
                  ])
                  | optional,
                azure
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.AzureMavenDeployerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.AzureMavenDeployer
                    ]
                  ])
                  | optional,
                gitea
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.GiteaMavenDeployerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.GiteaMavenDeployer
                    ]
                  ])
                  | optional,
                github
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.GithubMavenDeployerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.GithubMavenDeployer
                    ]
                  ])
                  | optional,
                gitlab
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.GitlabMavenDeployerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.GitlabMavenDeployer
                    ]
                  ])
                  | optional,
                nexus2
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.Nexus2MavenDeployerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.Nexus2MavenDeployer
                    ]
                  ])
                  | optional,
                pomchecker | definitions.contract.Pomchecker | optional,
              },
          Method = std.contract.Sequence
              [ std.enum.TagOrString, [| 'POST, 'PUT |] ],
          Milestone = { close | Bool | optional, name | String | optional, },
          MimeType = std.contract.Sequence
              [ std.enum.TagOrString, [| 'HTML, 'TEXT |] ],
          Mode-1 = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'SILENT_WITH_PROGRESS, 'SILENT, 'INTERACTIVE |]
              ],
          Mode-2 = std.contract.Sequence
              [ std.enum.TagOrString, [| 'COSIGN, 'COMMAND, 'FILE, 'MEMORY |] ],
          NativeImageAssembler = {
                active | definitions.contract.Active | optional,
                archiveFormat | definitions.contract.Format-1 | optional,
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Artifact
                  ])
                  | optional,
                components
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                executable | String | optional,
                exported | Bool | optional,
                extraProperties | definitions.contract.Properties | optional,
                fileSets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.FileSet
                  ])
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Glob
                  ])
                  | optional,
                graal | definitions.contract.Artifact | optional,
                graalJdks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Artifact
                  ])
                  | optional,
                imageName | String | optional,
                imageNameTransform | String | optional,
                jars
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Glob
                  ])
                  | optional,
                java | definitions.contract.Java-2 | optional,
                linux | definitions.contract.Linux-2 | optional,
                mainJar | definitions.contract.Artifact | optional,
                options | definitions.contract.ArchiveOptions | optional,
                osx | definitions.contract.Osx-2 | optional,
                platform | definitions.contract.Platform | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                stereotype | definitions.contract.Stereotype | optional,
                templateDirectory | String | optional,
                upx | definitions.contract.Upx | optional,
                windows | definitions.contract.Windows-2 | optional,
              },
          NativeImageAssemblerMap = predicates.contract_from_predicate
              definitions.predicate.NativeImageAssemblerMap,
          Nexus2MavenDeployer = {
                active | definitions.contract.Active | optional,
                applyMavenCentralRules | Bool | optional,
                artifactOverrides
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ArtifactOverride
                  ])
                  | optional,
                authorization | definitions.contract.Authorization | optional,
                checksums | Bool | optional,
                closeRepository | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                javadocJar | Bool | optional,
                password | String | optional,
                readTimeout | std.number.Integer | optional,
                releaseRepository | Bool | optional,
                sign | Bool | optional,
                snapshotUrl | String | optional,
                sourceJar | Bool | optional,
                stagingRepositories
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                transitionDelay | std.number.Integer | optional,
                transitionMaxRetries | std.number.Integer | optional,
                url | String | optional,
                username | String | optional,
                verifyPom | Bool | optional,
              },
          Nexus2MavenDeployerMap = predicates.contract_from_predicate
              definitions.predicate.Nexus2MavenDeployerMap,
          OpenCollectiveAnnouncer = {
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                host | String | optional,
                message | String | optional,
                messageTemplate | String | optional,
                readTimeout | std.number.Integer | optional,
                slug | String | optional,
                title | String | optional,
                token | String | optional,
              },
          Osx-1 = {
                appName | String | optional,
                icon | String | optional,
                installDir | String | optional,
                jdk | definitions.contract.Artifact | optional,
                packageIdentifier | String | optional,
                packageName | String | optional,
                packageSigningPrefix | String | optional,
                platform | String | optional,
                resourceDir | String | optional,
                sign | Bool | optional,
                signingKeyUsername | String | optional,
                signingKeychain | String | optional,
                types
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                validTypes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          Osx-2 = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                platform | String | optional,
              },
          Pack = { enabled | Bool | optional, name | String | optional, },
          Package = {
                identifier | String | optional,
                name | String | optional,
                url | String | optional,
                version | String | optional,
              },
          Packagers = {
                active | definitions.contract.Active | optional,
                appImage | definitions.contract.AppImagePackager | optional,
                asdf | definitions.contract.AsdfPackager | optional,
                brew | definitions.contract.BrewPackager | optional,
                chocolatey | definitions.contract.ChocolateyPackager | optional,
                docker | definitions.contract.DockerPackager | optional,
                flatpak | definitions.contract.FlatpakPackager | optional,
                gofish | definitions.contract.GofishPackager | optional,
                jbang | definitions.contract.JbangPackager | optional,
                jib | definitions.contract.JibPackager | optional,
                macports | definitions.contract.MacportsPackager | optional,
                scoop | definitions.contract.ScoopPackager | optional,
                sdkman | definitions.contract.SdkmanPackager | optional,
                snap | definitions.contract.SnapPackager | optional,
                spec | definitions.contract.SpecPackager | optional,
                winget | definitions.contract.WingetPackager | optional,
              },
          Platform = {
                replacements
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
              },
          Plug = {
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                name | String | optional,
                reads
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                writes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          Pomchecker = {
                failOnError | Bool | optional,
                failOnWarning | Bool | optional,
                version | String | optional,
              },
          Prerelease = {
                enabled | Bool | optional,
                pattern | String | optional,
              },
          Project = {
                authors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                copyright | String | optional,
                description | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                icons
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Icon
                  ])
                  | optional,
                inceptionYear | String | optional,
                java | definitions.contract.Java-2 | optional,
                license | String | optional,
                links | definitions.contract.Links | optional,
                longDescription | String | optional,
                maintainers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                name | String | optional,
                screenshots
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Screenshot
                  ])
                  | optional,
                snapshot | definitions.contract.Snapshot | optional,
                stereotype | definitions.contract.Stereotype | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                vendor | String | optional,
                version | String | optional,
                versionPattern | definitions.contract.VersionPattern | optional,
              },
          Properties = predicates.contract_from_predicate
              definitions.predicate.Properties,
          Provider = {
                properties | definitions.contract.Properties | optional,
                type | String | optional,
              },
          Publisher = {
                name | String | optional,
                supportUrl | String | optional,
                url | String | optional,
              },
          Registry-1 = {
                externalLogin | Bool | optional,
                password | String | optional,
                repositoryName | String | optional,
                server | String | optional,
                serverName | String | optional,
                username | String | optional,
              },
          Registry-2 = {
                fromPassword | String | optional,
                fromUsername | String | optional,
                name | String | optional,
                password | String | optional,
                server | String | optional,
                toPassword | String | optional,
                toUsername | String | optional,
                username | String | optional,
              },
          Release = {
                codeberg | definitions.contract.CodebergReleaser | optional,
                generic | definitions.contract.GenericGitReleaser | optional,
                gitea | definitions.contract.GiteaReleaser | optional,
                github | definitions.contract.GithubReleaser | optional,
                gitlab | definitions.contract.GitlabReleaser | optional,
              },
          ReleaseNotes = {
                configurationFile | String | optional,
                enabled | Bool | optional,
              },
          Replacer = {
                replace | String | optional,
                search | String | optional,
              },
          Repository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          Runtime = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'ELEMENTARY, 'KDE, 'GNOME, 'FREEDESKTOP |]
              ],
          S3Uploader = {
                accessKeyId | String | optional,
                active | definitions.contract.Active | optional,
                artifacts | Bool | optional,
                bucket | String | optional,
                catalogs | Bool | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                downloadUrl | String | optional,
                endpoint | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                files | Bool | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                path | String | optional,
                readTimeout | std.number.Integer | optional,
                region | String | optional,
                secretKey | String | optional,
                sessionToken | String | optional,
                signatures | Bool | optional,
              },
          S3UploaderMap = predicates.contract_from_predicate
              definitions.predicate.S3UploaderMap,
          Sbom = {
                active | definitions.contract.Active | optional,
                cyclonedx
                  | definitions.contract.CyclonedxSbomCataloger
                  | optional,
                syft | definitions.contract.SyftSbomCataloger | optional,
              },
          ScoopPackager = {
                active | definitions.contract.Active | optional,
                autoupdateUrl | String | optional,
                checkverUrl | String | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                continueOnError | Bool | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                packageName | String | optional,
                repository | definitions.contract.ScoopRepository | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                templateDirectory | String | optional,
              },
          ScoopRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          Scope = std.contract.Sequence
              [ std.enum.TagOrString, [| 'MACHINE, 'USER |] ],
          ScpDownloader = {
                active | definitions.contract.Active | optional,
                assets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Asset
                  ])
                  | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                fingerprint | String | optional,
                host | String | optional,
                knownHostsFile | String | optional,
                passphrase | String | optional,
                password | String | optional,
                port | std.number.Integer | optional,
                privateKey | String | optional,
                publicKey | String | optional,
                readTimeout | std.number.Integer | optional,
                username | String | optional,
              },
          ScpDownloaderMap = predicates.contract_from_predicate
              definitions.predicate.ScpDownloaderMap,
          ScpUploader = {
                active | definitions.contract.Active | optional,
                artifacts | Bool | optional,
                catalogs | Bool | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                files | Bool | optional,
                fingerprint | String | optional,
                host | String | optional,
                knownHostsFile | String | optional,
                passphrase | String | optional,
                password | String | optional,
                path | String | optional,
                port | std.number.Integer | optional,
                privateKey | String | optional,
                publicKey | String | optional,
                readTimeout | std.number.Integer | optional,
                signatures | Bool | optional,
                username | String | optional,
              },
          ScpUploaderMap = predicates.contract_from_predicate
              definitions.predicate.ScpUploaderMap,
          Screenshot = {
                caption | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                height | std.number.Integer | optional,
                primary | Bool | optional,
                type | definitions.contract.Type-1 | optional,
                url | String | optional,
                width | std.number.Integer | optional,
              },
          ScriptHook = {
                active | definitions.contract.Active | optional,
                condition | String | optional,
                continueOnError | Bool | optional,
                environment
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                filter | definitions.contract.Filter | optional,
                platforms
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                run | String | optional,
                shell | definitions.contract.Shell | optional,
                verbose | Bool | optional,
              },
          ScriptHooks = {
                active | definitions.contract.Active | optional,
                before
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.ScriptHook
                  ])
                  | optional,
                environment
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                failure
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.ScriptHook
                  ])
                  | optional,
                success
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.ScriptHook
                  ])
                  | optional,
              },
          SdkmanAnnouncer = {
                active | definitions.contract.Active | optional,
                candidate | String | optional,
                command | definitions.contract.Command-1 | optional,
                connectTimeout | std.number.Integer | optional,
                consumerKey | String | optional,
                consumerToken | String | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                readTimeout | std.number.Integer | optional,
                releaseNotesUrl | String | optional,
              },
          SdkmanPackager = {
                active | definitions.contract.Active | optional,
                candidate | String | optional,
                command | definitions.contract.Command-1 | optional,
                connectTimeout | std.number.Integer | optional,
                consumerKey | String | optional,
                consumerToken | String | optional,
                continueOnError | Bool | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                readTimeout | std.number.Integer | optional,
                releaseNotesUrl | String | optional,
              },
          SftpDownloader = {
                active | definitions.contract.Active | optional,
                assets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Asset
                  ])
                  | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                fingerprint | String | optional,
                host | String | optional,
                knownHostsFile | String | optional,
                passphrase | String | optional,
                password | String | optional,
                port | std.number.Integer | optional,
                privateKey | String | optional,
                publicKey | String | optional,
                readTimeout | std.number.Integer | optional,
                username | String | optional,
              },
          SftpDownloaderMap = predicates.contract_from_predicate
              definitions.predicate.SftpDownloaderMap,
          SftpUploader = {
                active | definitions.contract.Active | optional,
                artifacts | Bool | optional,
                catalogs | Bool | optional,
                checksums | Bool | optional,
                connectTimeout | std.number.Integer | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                files | Bool | optional,
                fingerprint | String | optional,
                host | String | optional,
                knownHostsFile | String | optional,
                passphrase | String | optional,
                password | String | optional,
                path | String | optional,
                port | std.number.Integer | optional,
                privateKey | String | optional,
                publicKey | String | optional,
                readTimeout | std.number.Integer | optional,
                signatures | Bool | optional,
                username | String | optional,
              },
          SftpUploaderMap = predicates.contract_from_predicate
              definitions.predicate.SftpUploaderMap,
          Shell = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'POWERSHELL, 'PWSH, 'CMD, 'SH, 'BASH |]
              ],
          Signing = {
                active | definitions.contract.Active | optional,
                armored | Bool | optional,
                artifacts | Bool | optional,
                catalogs | Bool | optional,
                checksums | Bool | optional,
                command | definitions.contract.Command-2 | optional,
                cosign | definitions.contract.Cosign | optional,
                files | Bool | optional,
                mode | definitions.contract.Mode-2 | optional,
                passphrase | String | optional,
                publicKey | String | optional,
                secretKey | String | optional,
                verify | Bool | optional,
              },
          SlackAnnouncer = {
                active | definitions.contract.Active | optional,
                channel | String | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                message | String | optional,
                messageTemplate | String | optional,
                readTimeout | std.number.Integer | optional,
                token | String | optional,
                webhook | String | optional,
              },
          Slot = {
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                name | String | optional,
                reads
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                writes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          SlsaCataloger = {
                active | definitions.contract.Active | optional,
                artifacts | Bool | optional,
                attestationName | String | optional,
                deployables | Bool | optional,
                extraProperties | definitions.contract.Properties | optional,
                files | Bool | optional,
              },
          SmtpAnnouncer = {
                active | definitions.contract.Active | optional,
                auth | Bool | optional,
                bcc | String | optional,
                cc | String | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                from | String | optional,
                host | String | optional,
                message | String | optional,
                messageTemplate | String | optional,
                mimeType | definitions.contract.MimeType | optional,
                password | String | optional,
                port | std.number.Integer | optional,
                properties
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.StringProperties,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                readTimeout | std.number.Integer | optional,
                subject | String | optional,
                to | String | optional,
                transport | definitions.contract.Transport | optional,
                username | String | optional,
              },
          SnapPackager = {
                active | definitions.contract.Active | optional,
                architectures
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Architecture
                  ])
                  | optional,
                base | String | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                confinement | String | optional,
                continueOnError | Bool | optional,
                downloadUrl | String | optional,
                exportedLogin | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                grade | String | optional,
                localPlugs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                localSlots
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                packageName | String | optional,
                plugs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Plug
                  ])
                  | optional,
                remoteBuild | Bool | optional,
                repository | definitions.contract.SnapRepository | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                slots
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Slot
                  ])
                  | optional,
                templateDirectory | String | optional,
              },
          SnapRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          Snapshot = {
                fullChangelog | Bool | optional,
                label | String | optional,
                pattern | String | optional,
              },
          Sort = std.contract.Sequence
              [ std.enum.TagOrString, [| 'DESC, 'ASC |] ],
          SpecPackager = {
                active | definitions.contract.Active | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                continueOnError | Bool | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                packageName | String | optional,
                release | String | optional,
                repository | definitions.contract.SpecRepository | optional,
                requires
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                templateDirectory | String | optional,
              },
          SpecRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          Stereotype = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'MOBILE, 'WEB, 'DESKTOP, 'CLI, 'NONE |]
              ],
          StringProperties = predicates.contract_from_predicate
              definitions.predicate.StringProperties,
          SyftSbomCataloger = {
                active | definitions.contract.Active | optional,
                distributions | Bool | optional,
                extraProperties | definitions.contract.Properties | optional,
                files | Bool | optional,
                formats
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Format-3
                  ])
                  | optional,
                pack | definitions.contract.Pack | optional,
                version | String | optional,
              },
          TarMode = std.contract.Sequence
              [ std.enum.TagOrString, [| 'TRUNCATE, 'ERROR, 'POSIX, 'GNU |] ],
          TeamsAnnouncer = {
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                messageTemplate | String | optional,
                readTimeout | std.number.Integer | optional,
                webhook | String | optional,
              },
          TelegramAnnouncer = {
                active | definitions.contract.Active | optional,
                chatId | String | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                message | String | optional,
                messageTemplate | String | optional,
                readTimeout | std.number.Integer | optional,
                token | String | optional,
              },
          Transport = std.contract.Sequence
              [ std.enum.TagOrString, [| 'SMTPS, 'SMTP |] ],
          TwitterAnnouncer = {
                accessToken | String | optional,
                accessTokenSecret | String | optional,
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                consumerKey | String | optional,
                consumerSecret | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                readTimeout | std.number.Integer | optional,
                status | String | optional,
                statusTemplate | String | optional,
                statuses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          Type-1 = std.contract.Sequence
              [ std.enum.TagOrString, [| 'THUMBNAIL, 'SOURCE |] ],
          Type-2 = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'PWA,
                  'BURN,
                  'WIX,
                  'NULLSOFT,
                  'INNO,
                  'ZIP,
                  'EXE,
                  'APPX,
                  'MSI,
                  'MSIX
                |]
              ],
          Type-3 = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'CUSTOM,
                  'JAVA_MODULE,
                  'JAVA_RUNTIME,
                  'CHRONVER,
                  'CALVER,
                  'SEMVER
                |]
              ],
          Unpack = {
                enabled | Bool | optional,
                skipRootEntry | Bool | optional,
              },
          Update = {
                enabled | Bool | optional,
                sections
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.UpdateSection
                  ])
                  | optional,
              },
          UpdateSection = std.contract.Sequence
              [ std.enum.TagOrString, [| 'ASSETS, 'BODY, 'TITLE |] ],
          UpgradeBehavior = std.contract.Sequence
              [ std.enum.TagOrString, [| 'UNINSTALL_PREVIOUS, 'INSTALL |] ],
          Upload = {
                active | definitions.contract.Active | optional,
                artifactory
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.ArtifactoryUploaderMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.ArtifactoryUploader
                    ]
                  ])
                  | optional,
                ftp
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.FtpUploaderMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.FtpUploader
                    ]
                  ])
                  | optional,
                gitea
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.GiteaUploaderMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.GiteaUploader
                    ]
                  ])
                  | optional,
                gitlab
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.GitlabUploaderMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.GitlabUploader
                    ]
                  ])
                  | optional,
                http
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.HttpUploaderMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.HttpUploader
                    ]
                  ])
                  | optional,
                s3
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.S3UploaderMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.S3Uploader
                    ]
                  ])
                  | optional,
                scp
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.ScpUploaderMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.ScpUploader
                    ]
                  ])
                  | optional,
                sftp
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.SftpUploaderMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.SftpUploader
                    ]
                  ])
                  | optional,
              },
          Upx = {
                active | definitions.contract.Active | optional,
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                version | String | optional,
              },
          VersionPattern = {
                format | String | optional,
                type | definitions.contract.Type-3 | optional,
              },
          WebhookAnnouncer = {
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                message | String | optional,
                messageProperty | String | optional,
                messageTemplate | String | optional,
                readTimeout | std.number.Integer | optional,
                structuredMessage | Bool | optional,
                webhook | String | optional,
              },
          WebhookAnnouncerMap = predicates.contract_from_predicate
              definitions.predicate.WebhookAnnouncerMap,
          WebhooksAnnouncer = {
                active | definitions.contract.Active | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                readTimeout | std.number.Integer | optional,
                webhooks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    definitions.predicate.WebhookAnnouncerMap,
                    predicates.allOf
                    [
                      predicates.anyOf
                      [ predicates.isType 'Record, predicates.isType 'Null ],
                      predicates.records.record {  } {  } true
                      definitions.predicate.WebhookAnnouncer
                    ]
                  ])
                  | optional,
              },
          Windows-1 = {
                appName | String | optional,
                console | Bool | optional,
                dirChooser | Bool | optional,
                icon | String | optional,
                installDir | String | optional,
                jdk | definitions.contract.Artifact | optional,
                menu | Bool | optional,
                menuGroup | String | optional,
                perUserInstall | Bool | optional,
                platform | String | optional,
                resourceDir | String | optional,
                shortcut | Bool | optional,
                types
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                upgradeUuid | String | optional,
                validTypes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          Windows-2 = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                platform | String | optional,
              },
          WingetPackager = {
                active | definitions.contract.Active | optional,
                author | String | optional,
                commitAuthor | definitions.contract.CommitAuthor | optional,
                continueOnError | Bool | optional,
                defaultLocale | String | optional,
                downloadUrl | String | optional,
                extraProperties | definitions.contract.Properties | optional,
                installer | definitions.contract.Installer | optional,
                minimumOsVersion | String | optional,
                moniker | String | optional,
                package | definitions.contract.Package | optional,
                productCode | String | optional,
                publisher | definitions.contract.Publisher | optional,
                repository | definitions.contract.WingetRepository | optional,
                skipTemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                templateDirectory | String | optional,
              },
          WingetRepository = {
                active | definitions.contract.Active | optional,
                branch | String | optional,
                branchPush | String | optional,
                commitMessage | String | optional,
                name | String | optional,
                owner | String | optional,
                tagName | String | optional,
                token | String | optional,
                username | String | optional,
              },
          ZulipAnnouncer = {
                account | String | optional,
                active | definitions.contract.Active | optional,
                apiHost | String | optional,
                apiKey | String | optional,
                channel | String | optional,
                connectTimeout | std.number.Integer | optional,
                extraProperties | definitions.contract.Properties | optional,
                message | String | optional,
                messageTemplate | String | optional,
                readTimeout | std.number.Integer | optional,
                subject | String | optional,
              },
        },
    predicate = {
          Active = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "ALWAYS",
                  "NEVER",
                  "RELEASE",
                  "PRERELEASE",
                  "RELEASE_PRERELEASE",
                  "SNAPSHOT"
                ]
              ],
          Algorithm = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "MD2",
                  "MD5",
                  "RMD160",
                  "SHA_1",
                  "SHA_256",
                  "SHA_384",
                  "SHA_512",
                  "SHA3_224",
                  "SHA3_256",
                  "SHA3_384",
                  "SHA3_512"
                ]
              ],
          Announce = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  article = definitions.predicate.ArticleAnnouncer,
                  bluesky = definitions.predicate.BlueskyAnnouncer,
                  configuredHttp = definitions.predicate.HttpAnnouncers,
                  configuredWebhooks = definitions.predicate.WebhooksAnnouncer,
                  discord = predicates.allOf
                      [
                        definitions.predicate.DiscordAnnouncer,
                        predicates.always
                      ],
                  discourse = definitions.predicate.DiscourseAnnouncer,
                  discussions = definitions.predicate.DiscussionsAnnouncer,
                  gitter = predicates.allOf
                      [
                        definitions.predicate.GitterAnnouncer,
                        predicates.always
                      ],
                  googleChat = predicates.allOf
                      [
                        definitions.predicate.GoogleChatAnnouncer,
                        predicates.always
                      ],
                  http = predicates.allOf
                      [
                        definitions.predicate.HttpAnnouncerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.HttpAnnouncer
                        ]
                      ],
                  linkedin = definitions.predicate.LinkedinAnnouncer,
                  mail = predicates.allOf
                      [
                        definitions.predicate.SmtpAnnouncer,
                        predicates.always
                      ],
                  mastodon = definitions.predicate.MastodonAnnouncer,
                  mattermost = predicates.allOf
                      [
                        definitions.predicate.MattermostAnnouncer,
                        predicates.always
                      ],
                  openCollective =
                    definitions.predicate.OpenCollectiveAnnouncer,
                  sdkman = definitions.predicate.SdkmanAnnouncer,
                  slack = definitions.predicate.SlackAnnouncer,
                  smtp = definitions.predicate.SmtpAnnouncer,
                  teams = predicates.allOf
                      [
                        definitions.predicate.TeamsAnnouncer,
                        predicates.always
                      ],
                  telegram = definitions.predicate.TelegramAnnouncer,
                  twitter = definitions.predicate.TwitterAnnouncer,
                  webhooks = predicates.allOf
                      [
                        definitions.predicate.WebhookAnnouncerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.WebhookAnnouncer
                        ]
                      ],
                  zulip = definitions.predicate.ZulipAnnouncer,
                }
                {  }
                false
                predicates.never
              ],
          AppImagePackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  categories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  commitAuthor = definitions.predicate.CommitAuthor,
                  componentId = predicates.isType '"String",
                  continueOnError = predicates.isType '"Bool",
                  developerName = predicates.isType '"String",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  icons = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Icon
                      ],
                  repository = definitions.predicate.AppImageRepository,
                  requiresTerminal = predicates.isType '"Bool",
                  screenshots = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Screenshot
                      ],
                  skipReleases = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          AppImageRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Append = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  content = predicates.isType '"String",
                  contentTemplate = predicates.isType '"String",
                  enabled = predicates.isType '"Bool",
                  target = predicates.isType '"String",
                  title = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ApplicationPackage = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appName = predicates.isType '"String",
                  appVersion = predicates.isType '"String",
                  copyright = predicates.isType '"String",
                  fileAssociations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  licenseFile = predicates.isType '"String",
                  vendor = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Apply = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "NEVER", "ALWAYS", "WARN", "FORCE" ]
              ],
          Architecture = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  buildOn = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ignoreError = predicates.isType '"Bool",
                  runOn = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ArchiveAssembler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  archiveName = predicates.isType '"String",
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Artifact
                      ],
                  attachPlatform = predicates.isType '"Bool",
                  distributionType = definitions.predicate.DistributionType,
                  exported = predicates.isType '"Bool",
                  extraProperties = definitions.predicate.Properties,
                  fileSets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.FileSet
                      ],
                  files = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Glob
                      ],
                  formats = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Format-1
                      ],
                  options = definitions.predicate.ArchiveOptions,
                  platform = definitions.predicate.Platform,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  stereotype = definitions.predicate.Stereotype,
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ArchiveAssemblerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.ArchiveAssembler,
                }
                true
                definitions.predicate.ArchiveAssembler
              ],
          ArchiveOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bigNumberMode = definitions.predicate.TarMode,
                  longFileMode = definitions.predicate.TarMode,
                  timestamp = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ArticleAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  commitAuthor = definitions.predicate.CommitAuthor,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  files = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Artifact
                      ],
                  readTimeout = predicates.isType 'Integer,
                  repository = definitions.predicate.Repository,
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Artifact = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  extraProperties = definitions.predicate.Properties,
                  path = predicates.isType '"String",
                  platform = predicates.isType '"String",
                  transform = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ArtifactOverride = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactId = predicates.isType '"String",
                  groupId = predicates.isType '"String",
                  javadocJar = predicates.isType '"Bool",
                  sourceJar = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ArtifactoryMavenDeployer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  applyMavenCentralRules = predicates.isType '"Bool",
                  artifactOverrides = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ArtifactOverride
                      ],
                  authorization = definitions.predicate.Authorization,
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  javadocJar = predicates.isType '"Bool",
                  password = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  sign = predicates.isType '"Bool",
                  sourceJar = predicates.isType '"Bool",
                  stagingRepositories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  url = predicates.isType '"String",
                  username = predicates.isType '"String",
                  verifyPom = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ArtifactoryMavenDeployerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.ArtifactoryMavenDeployer,
                }
                true
                definitions.predicate.ArtifactoryMavenDeployer
              ],
          ArtifactoryRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  fileTypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.FileType
                      ],
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ArtifactoryUploader = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifacts = predicates.isType '"Bool",
                  authorization = definitions.predicate.Authorization,
                  catalogs = predicates.isType '"Bool",
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  files = predicates.isType '"Bool",
                  headers = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  host = predicates.isType '"String",
                  password = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  repositories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ArtifactoryRepository
                      ],
                  signatures = predicates.isType '"Bool",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ArtifactoryUploaderMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.ArtifactoryUploader,
                }
                true
                definitions.predicate.ArtifactoryUploader
              ],
          AsdfPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  commitAuthor = definitions.predicate.CommitAuthor,
                  continueOnError = predicates.isType '"Bool",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  repository = definitions.predicate.AsdfRepository,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  templateDirectory = predicates.isType '"String",
                  toolCheck = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          AsdfRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Assemble = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  archive = predicates.allOf
                      [
                        definitions.predicate.ArchiveAssemblerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.ArchiveAssembler
                        ]
                      ],
                  javaArchive = predicates.allOf
                      [
                        definitions.predicate.JavaArchiveAssemblerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.JavaArchiveAssembler
                        ]
                      ],
                  jlink = predicates.allOf
                      [
                        definitions.predicate.JlinkAssemblerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.JlinkAssembler
                        ]
                      ],
                  jpackage = predicates.allOf
                      [
                        definitions.predicate.JpackageAssemblerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.JpackageAssembler
                        ]
                      ],
                  nativeImage = predicates.allOf
                      [
                        definitions.predicate.NativeImageAssemblerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.NativeImageAssembler
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Asset = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  input = predicates.isType '"String",
                  output = predicates.isType '"String",
                  unpack = definitions.predicate.Unpack,
                }
                {  }
                false
                predicates.never
              ],
          Authorization = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "NONE", "BASIC", "BEARER" ]
              ],
          AzureMavenDeployer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  applyMavenCentralRules = predicates.isType '"Bool",
                  artifactOverrides = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ArtifactOverride
                      ],
                  authorization = definitions.predicate.Authorization,
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  javadocJar = predicates.isType '"Bool",
                  password = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  sign = predicates.isType '"Bool",
                  sourceJar = predicates.isType '"Bool",
                  stagingRepositories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  url = predicates.isType '"String",
                  username = predicates.isType '"String",
                  verifyPom = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          AzureMavenDeployerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.AzureMavenDeployer,
                }
                true
                definitions.predicate.AzureMavenDeployer
              ],
          BlueskyAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  handle = predicates.isType '"String",
                  host = predicates.isType '"String",
                  password = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  status = predicates.isType '"String",
                  statusTemplate = predicates.isType '"String",
                  statuses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          BrewPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  cask = definitions.predicate.Cask,
                  commitAuthor = definitions.predicate.CommitAuthor,
                  continueOnError = predicates.isType '"Bool",
                  dependencies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Dependency
                      ],
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  formulaName = predicates.isType '"String",
                  livecheck = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  multiPlatform = predicates.isType '"Bool",
                  repository = definitions.predicate.HomebrewRepository,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Buildx = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createBuilder = predicates.isType '"Bool",
                  createBuilderFlags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  enabled = predicates.isType '"Bool",
                  platforms = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Cask = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appName = predicates.isType '"String",
                  appcast = predicates.isType '"String",
                  displayName = predicates.isType '"String",
                  enabled = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  pkgName = predicates.isType '"String",
                  uninstall = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.CaskItem
                      ],
                  zap = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.CaskItem
                      ],
                }
                {  }
                false
                predicates.never
              ],
          CaskItem = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Catalog = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  sbom = definitions.predicate.Sbom,
                  slsa = definitions.predicate.SlsaCataloger,
                }
                {  }
                false
                predicates.never
              ],
          Category = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  format = predicates.isType '"String",
                  key = predicates.isType '"String",
                  labels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  order = predicates.isType 'Integer,
                  title = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Changelog = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  append = definitions.predicate.Append,
                  categories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Category
                      ],
                  categoryTitleFormat = predicates.isType '"String",
                  content = predicates.isType '"String",
                  contentTemplate = predicates.isType '"String",
                  contributors = definitions.predicate.Contributors,
                  contributorsTitleFormat = predicates.isType '"String",
                  enabled = predicates.isType '"Bool",
                  excludeLabels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  external = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  format = predicates.isType '"String",
                  formatted = definitions.predicate.Active,
                  hide = definitions.predicate.Hide,
                  includeLabels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  labelers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Labeler
                      ],
                  links = predicates.isType '"Bool",
                  preset = predicates.isType '"String",
                  replacers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Replacer
                      ],
                  skipMergeCommits = predicates.isType '"Bool",
                  sort = definitions.predicate.Sort,
                }
                {  }
                false
                predicates.never
              ],
          Checksum = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  algorithms = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Algorithm
                      ],
                  artifacts = predicates.isType '"Bool",
                  files = predicates.isType '"Bool",
                  individual = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ChocolateyPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  apiKey = predicates.isType '"String",
                  commitAuthor = definitions.predicate.CommitAuthor,
                  continueOnError = predicates.isType '"Bool",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  iconUrl = predicates.isType '"String",
                  packageName = predicates.isType '"String",
                  packageVersion = predicates.isType '"String",
                  remoteBuild = predicates.isType '"Bool",
                  repository = definitions.predicate.ChocolateyRepository,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  source = predicates.isType '"String",
                  templateDirectory = predicates.isType '"String",
                  title = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ChocolateyRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CodebergReleaser = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiEndpoint = predicates.isType '"String",
                  artifacts = predicates.isType '"Bool",
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  catalogs = predicates.isType '"Bool",
                  changelog = definitions.predicate.Changelog,
                  checksums = predicates.isType '"Bool",
                  commitAuthor = definitions.predicate.CommitAuthor,
                  commitUrl = predicates.isType '"String",
                  connectTimeout = predicates.isType 'Integer,
                  downloadUrl = predicates.isType '"String",
                  draft = predicates.isType '"Bool",
                  enabled = predicates.isType '"Bool",
                  files = predicates.isType '"Bool",
                  host = predicates.isType '"String",
                  issueTrackerUrl = predicates.isType '"String",
                  issues = definitions.predicate.Issues,
                  latestReleaseUrl = predicates.isType '"String",
                  milestone = definitions.predicate.Milestone,
                  name = predicates.isType '"String",
                  overwrite = predicates.isType '"Bool",
                  owner = predicates.isType '"String",
                  prerelease = definitions.predicate.Prerelease,
                  previousTagName = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  releaseName = predicates.isType '"String",
                  releaseNotesUrl = predicates.isType '"String",
                  repoCloneUrl = predicates.isType '"String",
                  repoUrl = predicates.isType '"String",
                  sign = predicates.isType '"Bool",
                  signatures = predicates.isType '"Bool",
                  skipRelease = predicates.isType '"Bool",
                  skipTag = predicates.isType '"Bool",
                  srcUrl = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  update = definitions.predicate.Update,
                  uploadAssets = definitions.predicate.Active,
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Command-1 = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "MAJOR", "MINOR" ]
              ],
          Command-2 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  defaultKeyring = predicates.isType '"Bool",
                  executable = predicates.isType '"String",
                  homeDir = predicates.isType '"String",
                  keyName = predicates.isType '"String",
                  publicKeyring = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CommandHook = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  cmd = predicates.isType '"String",
                  condition = predicates.isType '"String",
                  continueOnError = predicates.isType '"Bool",
                  environment = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  filter = definitions.predicate.Filter,
                  platforms = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  verbose = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          CommandHooks = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  before = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.CommandHook
                      ],
                  environment = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  failure = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.CommandHook
                      ],
                  success = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.CommandHook
                      ],
                }
                {  }
                false
                predicates.never
              ],
          CommitAuthor = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  email = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Contributors = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  format = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Cosign = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  privateKeyFile = predicates.isType '"String",
                  publicKeyFile = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CyclonedxSbomCataloger = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  distributions = predicates.isType '"Bool",
                  extraProperties = definitions.predicate.Properties,
                  files = predicates.isType '"Bool",
                  formats = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Format-2
                      ],
                  pack = definitions.predicate.Pack,
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Dependency = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Deploy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  maven = definitions.predicate.Maven,
                }
                {  }
                false
                predicates.never
              ],
          DiscordAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  message = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  webhook = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          DiscourseAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  apiKey = predicates.isType '"String",
                  categoryName = predicates.isType '"String",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  host = predicates.isType '"String",
                  message = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  title = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          DiscussionsAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  message = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  organization = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  team = predicates.isType '"String",
                  title = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Distribution = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  appImage = definitions.predicate.AppImagePackager,
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Artifact
                      ],
                  asdf = definitions.predicate.AsdfPackager,
                  brew = definitions.predicate.BrewPackager,
                  chocolatey = definitions.predicate.ChocolateyPackager,
                  docker = definitions.predicate.DockerPackager,
                  executable = definitions.predicate.Executable,
                  extraProperties = definitions.predicate.Properties,
                  flatpak = definitions.predicate.FlatpakPackager,
                  gofish = definitions.predicate.GofishPackager,
                  java = definitions.predicate.Java-2,
                  jbang = definitions.predicate.JbangPackager,
                  jib = definitions.predicate.JibPackager,
                  macports = definitions.predicate.MacportsPackager,
                  name = predicates.isType '"String",
                  platform = definitions.predicate.Platform,
                  scoop = definitions.predicate.ScoopPackager,
                  sdkman = definitions.predicate.SdkmanPackager,
                  snap = definitions.predicate.SnapPackager,
                  spec = definitions.predicate.SpecPackager,
                  stereotype = definitions.predicate.Stereotype,
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  type = definitions.predicate.DistributionType,
                  winget = definitions.predicate.WingetPackager,
                }
                {  }
                false
                predicates.never
              ],
          DistributionMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.Distribution,
                }
                true
                definitions.predicate.Distribution
              ],
          DistributionType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "BINARY",
                  "FLAT_BINARY",
                  "JAVA_BINARY",
                  "JLINK",
                  "SINGLE_JAR",
                  "NATIVE_IMAGE",
                  "NATIVE_PACKAGE"
                ]
              ],
          DockerPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  baseImage = predicates.isType '"String",
                  buildArgs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  buildx = definitions.predicate.Buildx,
                  commitAuthor = definitions.predicate.CommitAuthor,
                  continueOnError = predicates.isType '"Bool",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  imageNames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  labels = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  postCommands = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  preCommands = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  registries = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Registry-1
                      ],
                  repository = definitions.predicate.DockerRepository,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  specs = predicates.allOf
                      [
                        definitions.predicate.DockerSpecMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.DockerSpec
                        ]
                      ],
                  templateDirectory = predicates.isType '"String",
                  useLocalArtifact = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          DockerRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                  versionedSubfolders = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          DockerSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifact = definitions.predicate.Artifact,
                  baseImage = predicates.isType '"String",
                  buildArgs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  buildx = definitions.predicate.Buildx,
                  extraProperties = definitions.predicate.Properties,
                  imageNames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  labels = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  matchers = definitions.predicate.Properties,
                  name = predicates.isType '"String",
                  postCommands = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  preCommands = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  registries = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Registry-1
                      ],
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  templateDirectory = predicates.isType '"String",
                  useLocalArtifact = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          DockerSpecMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.DockerSpec,
                }
                true
                definitions.predicate.DockerSpec
              ],
          Download = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  ftp = predicates.allOf
                      [
                        definitions.predicate.FtpDownloaderMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.FtpDownloader
                        ]
                      ],
                  http = predicates.allOf
                      [
                        definitions.predicate.HttpDownloaderMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.HttpDownloader
                        ]
                      ],
                  scp = predicates.allOf
                      [
                        definitions.predicate.ScpDownloaderMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.ScpDownloader
                        ]
                      ],
                  sftp = predicates.allOf
                      [
                        definitions.predicate.SftpDownloaderMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.SftpDownloader
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Environment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  properties = definitions.predicate.Properties,
                  variables = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Executable = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  unixExtension = predicates.isType '"String",
                  windowsExtension = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Extension = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  directory = predicates.isType '"String",
                  enabled = predicates.isType '"Bool",
                  gav = predicates.isType '"String",
                  name = predicates.isType '"String",
                  providers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Provider
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ExtensionMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.Extension,
                }
                true
                definitions.predicate.Extension
              ],
          FileSet = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  excludes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extraProperties = definitions.predicate.Properties,
                  failOnMissingInput = predicates.isType '"Bool",
                  includes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  input = predicates.isType '"String",
                  output = predicates.isType '"String",
                  platform = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FileType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "ASC",
                  "BAT",
                  "CMD",
                  "DEB",
                  "DMG",
                  "EXE",
                  "JAR",
                  "MSI",
                  "NUGET",
                  "PKG",
                  "PS1",
                  "RPM",
                  "SH",
                  "SIG",
                  "TAR",
                  "TAR_BZ2",
                  "TAR_GZ",
                  "TAR_XZ",
                  "TAR_ZST",
                  "TBZ2",
                  "TGZ",
                  "TXZ",
                  "ZIP",
                  "ZST"
                ]
              ],
          Files = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Artifact
                      ],
                  globs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Glob
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Filter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  excludes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  includes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FlatpakPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  categories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  commitAuthor = definitions.predicate.CommitAuthor,
                  componentId = predicates.isType '"String",
                  continueOnError = predicates.isType '"Bool",
                  developerName = predicates.isType '"String",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  finishArgs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  icons = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Icon
                      ],
                  repository = definitions.predicate.FlatpakRepository,
                  runtime = definitions.predicate.Runtime,
                  runtimeVersion = predicates.isType '"String",
                  screenshots = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Screenshot
                      ],
                  sdkExtensions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  skipReleases = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FlatpakRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Format-1 = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "ZIP",
                  "TAR",
                  "TAR_BZ2",
                  "TAR_GZ",
                  "TAR_XZ",
                  "TAR_ZST",
                  "TBZ2",
                  "TGZ",
                  "TXZ"
                ]
              ],
          Format-2 = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "JSON", "XML", "PROTOBUF" ]
              ],
          Format-3 = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "SYFT_JSON",
                  "CYCLONEDX_XML",
                  "CYCLONEDX_JSON",
                  "GITHUB_JSON",
                  "SPDX_JSON",
                  "TABLE",
                  "TEXT"
                ]
              ],
          Format-4 = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "DOCKER", "OCI" ]
              ],
          FtpDownloader = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  assets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Asset
                      ],
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  host = predicates.isType '"String",
                  password = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                  readTimeout = predicates.isType 'Integer,
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FtpDownloaderMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.FtpDownloader,
                }
                true
                definitions.predicate.FtpDownloader
              ],
          FtpUploader = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifacts = predicates.isType '"Bool",
                  catalogs = predicates.isType '"Bool",
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  files = predicates.isType '"Bool",
                  host = predicates.isType '"String",
                  password = predicates.isType '"String",
                  path = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                  readTimeout = predicates.isType 'Integer,
                  signatures = predicates.isType '"Bool",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FtpUploaderMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.FtpUploader,
                }
                true
                definitions.predicate.FtpUploader
              ],
          GenericGitReleaser = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiEndpoint = predicates.isType '"String",
                  artifacts = predicates.isType '"Bool",
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  catalogs = predicates.isType '"Bool",
                  changelog = definitions.predicate.Changelog,
                  checksums = predicates.isType '"Bool",
                  commitAuthor = definitions.predicate.CommitAuthor,
                  commitUrl = predicates.isType '"String",
                  connectTimeout = predicates.isType 'Integer,
                  downloadUrl = predicates.isType '"String",
                  enabled = predicates.isType '"Bool",
                  files = predicates.isType '"Bool",
                  host = predicates.isType '"String",
                  issueTrackerUrl = predicates.isType '"String",
                  issues = definitions.predicate.Issues,
                  latestReleaseUrl = predicates.isType '"String",
                  milestone = definitions.predicate.Milestone,
                  name = predicates.isType '"String",
                  overwrite = predicates.isType '"Bool",
                  owner = predicates.isType '"String",
                  prerelease = definitions.predicate.Prerelease,
                  previousTagName = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  releaseName = predicates.isType '"String",
                  releaseNotesUrl = predicates.isType '"String",
                  repoCloneUrl = predicates.isType '"String",
                  repoUrl = predicates.isType '"String",
                  sign = predicates.isType '"Bool",
                  signatures = predicates.isType '"Bool",
                  skipRelease = predicates.isType '"Bool",
                  skipTag = predicates.isType '"Bool",
                  srcUrl = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  update = definitions.predicate.Update,
                  uploadAssets = definitions.predicate.Active,
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GiteaMavenDeployer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  applyMavenCentralRules = predicates.isType '"Bool",
                  artifactOverrides = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ArtifactOverride
                      ],
                  authorization = definitions.predicate.Authorization,
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  javadocJar = predicates.isType '"Bool",
                  password = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  sign = predicates.isType '"Bool",
                  sourceJar = predicates.isType '"Bool",
                  stagingRepositories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  url = predicates.isType '"String",
                  username = predicates.isType '"String",
                  verifyPom = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          GiteaMavenDeployerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.GiteaMavenDeployer,
                }
                true
                definitions.predicate.GiteaMavenDeployer
              ],
          GiteaReleaser = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiEndpoint = predicates.isType '"String",
                  artifacts = predicates.isType '"Bool",
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  catalogs = predicates.isType '"Bool",
                  changelog = definitions.predicate.Changelog,
                  checksums = predicates.isType '"Bool",
                  commitAuthor = definitions.predicate.CommitAuthor,
                  commitUrl = predicates.isType '"String",
                  connectTimeout = predicates.isType 'Integer,
                  downloadUrl = predicates.isType '"String",
                  draft = predicates.isType '"Bool",
                  enabled = predicates.isType '"Bool",
                  files = predicates.isType '"Bool",
                  host = predicates.isType '"String",
                  issueTrackerUrl = predicates.isType '"String",
                  issues = definitions.predicate.Issues,
                  latestReleaseUrl = predicates.isType '"String",
                  milestone = definitions.predicate.Milestone,
                  name = predicates.isType '"String",
                  overwrite = predicates.isType '"Bool",
                  owner = predicates.isType '"String",
                  prerelease = definitions.predicate.Prerelease,
                  previousTagName = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  releaseName = predicates.isType '"String",
                  releaseNotesUrl = predicates.isType '"String",
                  repoCloneUrl = predicates.isType '"String",
                  repoUrl = predicates.isType '"String",
                  sign = predicates.isType '"Bool",
                  signatures = predicates.isType '"Bool",
                  skipRelease = predicates.isType '"Bool",
                  skipTag = predicates.isType '"Bool",
                  srcUrl = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  update = definitions.predicate.Update,
                  uploadAssets = definitions.predicate.Active,
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GiteaUploader = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifacts = predicates.isType '"Bool",
                  catalogs = predicates.isType '"Bool",
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  files = predicates.isType '"Bool",
                  host = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  packageName = predicates.isType '"String",
                  packageVersion = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  signatures = predicates.isType '"Bool",
                  token = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GiteaUploaderMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.GiteaUploader,
                }
                true
                definitions.predicate.GiteaUploader
              ],
          GithubMavenDeployer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  applyMavenCentralRules = predicates.isType '"Bool",
                  artifactOverrides = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ArtifactOverride
                      ],
                  authorization = definitions.predicate.Authorization,
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  javadocJar = predicates.isType '"Bool",
                  password = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  repository = predicates.isType '"String",
                  sign = predicates.isType '"Bool",
                  sourceJar = predicates.isType '"Bool",
                  stagingRepositories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  url = predicates.isType '"String",
                  username = predicates.isType '"String",
                  verifyPom = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          GithubMavenDeployerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.GithubMavenDeployer,
                }
                true
                definitions.predicate.GithubMavenDeployer
              ],
          GithubReleaser = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiEndpoint = predicates.isType '"String",
                  artifacts = predicates.isType '"Bool",
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  catalogs = predicates.isType '"Bool",
                  changelog = definitions.predicate.Changelog,
                  checksums = predicates.isType '"Bool",
                  commitAuthor = definitions.predicate.CommitAuthor,
                  commitUrl = predicates.isType '"String",
                  connectTimeout = predicates.isType 'Integer,
                  discussionCategoryName = predicates.isType '"String",
                  downloadUrl = predicates.isType '"String",
                  draft = predicates.isType '"Bool",
                  enabled = predicates.isType '"Bool",
                  files = predicates.isType '"Bool",
                  host = predicates.isType '"String",
                  issueTrackerUrl = predicates.isType '"String",
                  issues = definitions.predicate.Issues,
                  latestReleaseUrl = predicates.isType '"String",
                  milestone = definitions.predicate.Milestone,
                  name = predicates.isType '"String",
                  overwrite = predicates.isType '"Bool",
                  owner = predicates.isType '"String",
                  prerelease = definitions.predicate.Prerelease,
                  previousTagName = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  releaseName = predicates.isType '"String",
                  releaseNotes = definitions.predicate.ReleaseNotes,
                  releaseNotesUrl = predicates.isType '"String",
                  repoCloneUrl = predicates.isType '"String",
                  repoUrl = predicates.isType '"String",
                  sign = predicates.isType '"Bool",
                  signatures = predicates.isType '"Bool",
                  skipRelease = predicates.isType '"Bool",
                  skipTag = predicates.isType '"Bool",
                  srcUrl = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  update = definitions.predicate.Update,
                  uploadAssets = definitions.predicate.Active,
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GitlabMavenDeployer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  applyMavenCentralRules = predicates.isType '"Bool",
                  artifactOverrides = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ArtifactOverride
                      ],
                  authorization = definitions.predicate.Authorization,
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  javadocJar = predicates.isType '"Bool",
                  password = predicates.isType '"String",
                  projectIdentifier = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  sign = predicates.isType '"Bool",
                  sourceJar = predicates.isType '"Bool",
                  stagingRepositories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  url = predicates.isType '"String",
                  username = predicates.isType '"String",
                  verifyPom = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          GitlabMavenDeployerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.GitlabMavenDeployer,
                }
                true
                definitions.predicate.GitlabMavenDeployer
              ],
          GitlabReleaser = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiEndpoint = predicates.isType '"String",
                  artifacts = predicates.isType '"Bool",
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  catalogs = predicates.isType '"Bool",
                  changelog = definitions.predicate.Changelog,
                  checksums = predicates.isType '"Bool",
                  commitAuthor = definitions.predicate.CommitAuthor,
                  commitUrl = predicates.isType '"String",
                  connectTimeout = predicates.isType 'Integer,
                  downloadUrl = predicates.isType '"String",
                  enabled = predicates.isType '"Bool",
                  files = predicates.isType '"Bool",
                  host = predicates.isType '"String",
                  issueTrackerUrl = predicates.isType '"String",
                  issues = definitions.predicate.Issues,
                  latestReleaseUrl = predicates.isType '"String",
                  milestone = definitions.predicate.Milestone,
                  name = predicates.isType '"String",
                  overwrite = predicates.isType '"Bool",
                  owner = predicates.isType '"String",
                  prerelease = definitions.predicate.Prerelease,
                  previousTagName = predicates.isType '"String",
                  projectIdentifier = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  releaseName = predicates.isType '"String",
                  releaseNotesUrl = predicates.isType '"String",
                  repoCloneUrl = predicates.isType '"String",
                  repoUrl = predicates.isType '"String",
                  sign = predicates.isType '"Bool",
                  signatures = predicates.isType '"Bool",
                  skipRelease = predicates.isType '"Bool",
                  skipTag = predicates.isType '"Bool",
                  srcUrl = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  update = definitions.predicate.Update,
                  uploadAssets = definitions.predicate.Active,
                  uploadLinks = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GitlabUploader = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifacts = predicates.isType '"Bool",
                  catalogs = predicates.isType '"Bool",
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  files = predicates.isType '"Bool",
                  host = predicates.isType '"String",
                  packageName = predicates.isType '"String",
                  packageVersion = predicates.isType '"String",
                  projectIdentifier = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  signatures = predicates.isType '"Bool",
                  token = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GitlabUploaderMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.GitlabUploader,
                }
                true
                definitions.predicate.GitlabUploader
              ],
          GitterAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  message = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  webhook = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Glob = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  directory = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  pattern = predicates.isType '"String",
                  platform = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GofishPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  commitAuthor = definitions.predicate.CommitAuthor,
                  continueOnError = predicates.isType '"Bool",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  repository = definitions.predicate.GofishRepository,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GofishRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GoogleChatAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  message = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  webhook = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Hide = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  categories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  contributors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  uncategorized = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          HomebrewRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Hooks = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  command = definitions.predicate.CommandHooks,
                  environment = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  script = definitions.predicate.ScriptHooks,
                }
                {  }
                false
                predicates.never
              ],
          HttpAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  authorization = definitions.predicate.Authorization,
                  bearerKeyword = predicates.isType '"String",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  headers = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  method = definitions.predicate.Method,
                  password = predicates.isType '"String",
                  payload = predicates.isType '"String",
                  payloadTemplate = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  url = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          HttpAnnouncerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.HttpAnnouncer,
                }
                true
                definitions.predicate.HttpAnnouncer
              ],
          HttpAnnouncers = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  http = predicates.allOf
                      [
                        definitions.predicate.HttpAnnouncerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.HttpAnnouncer
                        ]
                      ],
                  readTimeout = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          HttpDownloader = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  assets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Asset
                      ],
                  authorization = definitions.predicate.Authorization,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  headers = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  password = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          HttpDownloaderMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.HttpDownloader,
                }
                true
                definitions.predicate.HttpDownloader
              ],
          HttpUploader = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifacts = predicates.isType '"Bool",
                  authorization = definitions.predicate.Authorization,
                  catalogs = predicates.isType '"Bool",
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  files = predicates.isType '"Bool",
                  headers = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  method = definitions.predicate.Method,
                  password = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  signatures = predicates.isType '"Bool",
                  uploadUrl = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          HttpUploaderMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.HttpUploader,
                }
                true
                definitions.predicate.HttpUploader
              ],
          Icon = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  extraProperties = definitions.predicate.Properties,
                  height = predicates.isType 'Integer,
                  primary = predicates.isType '"Bool",
                  url = predicates.isType '"String",
                  width = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          Installer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  command = predicates.isType '"String",
                  modes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Mode-1
                      ],
                  scope = definitions.predicate.Scope,
                  type = definitions.predicate.Type-2,
                  upgradeBehavior = definitions.predicate.UpgradeBehavior,
                }
                {  }
                false
                predicates.never
              ],
          Issues = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  applyMilestone = definitions.predicate.Apply,
                  comment = predicates.isType '"String",
                  enabled = predicates.isType '"Bool",
                  label = definitions.predicate.Label,
                }
                {  }
                false
                predicates.never
              ],
          JReleaserModel
            | doc m%"
            JReleaser 1.8.0
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  announce = definitions.predicate.Announce,
                  assemble = definitions.predicate.Assemble,
                  catalog = definitions.predicate.Catalog,
                  checksum = definitions.predicate.Checksum,
                  deploy = definitions.predicate.Deploy,
                  distributions = predicates.allOf
                      [
                        definitions.predicate.DistributionMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.Distribution
                        ]
                      ],
                  download = definitions.predicate.Download,
                  environment = definitions.predicate.Environment,
                  extensions = predicates.allOf
                      [
                        definitions.predicate.ExtensionMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.Extension
                        ]
                      ],
                  files = definitions.predicate.Files,
                  hooks = definitions.predicate.Hooks,
                  packagers = definitions.predicate.Packagers,
                  platform = definitions.predicate.Platform,
                  project = definitions.predicate.Project,
                  release = definitions.predicate.Release,
                  signing = definitions.predicate.Signing,
                  upload = definitions.predicate.Upload,
                }
                {  }
                false
                predicates.never
              ],
          Java-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  mainClass = predicates.isType '"String",
                  mainModule = predicates.isType '"String",
                  options = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Java-2 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactId = predicates.isType '"String",
                  enabled = predicates.isType '"Bool",
                  extraProperties = definitions.predicate.Properties,
                  groupId = predicates.isType '"String",
                  mainClass = predicates.isType '"String",
                  mainModule = predicates.isType '"String",
                  multiProject = predicates.isType '"Bool",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          JavaArchive = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  libDirectoryName = predicates.isType '"String",
                  mainJarName = predicates.isType '"String",
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          JavaArchiveAssembler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  archiveName = predicates.isType '"String",
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Artifact
                      ],
                  executable = definitions.predicate.Executable,
                  exported = predicates.isType '"Bool",
                  extraProperties = definitions.predicate.Properties,
                  fileSets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.FileSet
                      ],
                  files = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Glob
                      ],
                  formats = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Format-1
                      ],
                  jars = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Glob
                      ],
                  java = definitions.predicate.Java-1,
                  mainJar = definitions.predicate.Artifact,
                  options = definitions.predicate.ArchiveOptions,
                  platform = definitions.predicate.Platform,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  stereotype = definitions.predicate.Stereotype,
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          JavaArchiveAssemblerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.JavaArchiveAssembler,
                }
                true
                definitions.predicate.JavaArchiveAssembler
              ],
          JbangPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  alias = predicates.isType '"String",
                  commitAuthor = definitions.predicate.CommitAuthor,
                  continueOnError = predicates.isType '"Bool",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  repository = definitions.predicate.JbangRepository,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          JbangRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Jdeps = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  ignoreMissingDeps = predicates.isType '"Bool",
                  multiRelease = predicates.isType '"String",
                  targets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  useWildcardInPath = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          JibPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  baseImage = predicates.isType '"String",
                  commitAuthor = definitions.predicate.CommitAuthor,
                  continueOnError = predicates.isType '"Bool",
                  creationTime = predicates.isType '"String",
                  downloadUrl = predicates.isType '"String",
                  environment = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  exposedPorts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extraProperties = definitions.predicate.Properties,
                  format = definitions.predicate.Format-4,
                  imageNames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  labels = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  registries = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Registry-2
                      ],
                  repository = definitions.predicate.JibRepository,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  specs = predicates.allOf
                      [
                        definitions.predicate.JibSpecMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.JibSpec
                        ]
                      ],
                  templateDirectory = predicates.isType '"String",
                  user = predicates.isType '"String",
                  version = predicates.isType '"String",
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  workingDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          JibRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                  versionedSubfolders = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          JibSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifact = definitions.predicate.Artifact,
                  baseImage = predicates.isType '"String",
                  creationTime = predicates.isType '"String",
                  environment = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  exposedPorts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extraProperties = definitions.predicate.Properties,
                  format = definitions.predicate.Format-4,
                  imageNames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  labels = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  matchers = definitions.predicate.Properties,
                  name = predicates.isType '"String",
                  registries = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Registry-2
                      ],
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  templateDirectory = predicates.isType '"String",
                  user = predicates.isType '"String",
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  workingDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          JibSpecMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.JibSpec,
                }
                true
                definitions.predicate.JibSpec
              ],
          JlinkAssembler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  additionalModuleNames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  archiveFormat = definitions.predicate.Format-1,
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Artifact
                      ],
                  copyJars = predicates.isType '"Bool",
                  executable = predicates.isType '"String",
                  exported = predicates.isType '"Bool",
                  extraProperties = definitions.predicate.Properties,
                  fileSets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.FileSet
                      ],
                  files = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Glob
                      ],
                  imageName = predicates.isType '"String",
                  imageNameTransform = predicates.isType '"String",
                  jars = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Glob
                      ],
                  java = definitions.predicate.Java-2,
                  javaArchive = definitions.predicate.JavaArchive,
                  jdeps = definitions.predicate.Jdeps,
                  jdk = definitions.predicate.Artifact,
                  mainJar = definitions.predicate.Artifact,
                  moduleNames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  options = definitions.predicate.ArchiveOptions,
                  platform = definitions.predicate.Platform,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  stereotype = definitions.predicate.Stereotype,
                  targetJdks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Artifact
                      ],
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          JlinkAssemblerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.JlinkAssembler,
                }
                true
                definitions.predicate.JlinkAssembler
              ],
          JpackageAssembler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  applicationPackage = definitions.predicate.ApplicationPackage,
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Artifact
                      ],
                  attachPlatform = predicates.isType '"Bool",
                  executable = predicates.isType '"String",
                  exported = predicates.isType '"Bool",
                  extraProperties = definitions.predicate.Properties,
                  fileSets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.FileSet
                      ],
                  files = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Glob
                      ],
                  jars = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Glob
                      ],
                  java = definitions.predicate.Java-2,
                  jlink = predicates.isType '"String",
                  launcher = definitions.predicate.Launcher,
                  linux = definitions.predicate.Linux-1,
                  mainJar = definitions.predicate.Artifact,
                  osx = definitions.predicate.Osx-1,
                  platform = definitions.predicate.Platform,
                  runtimeImages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Artifact
                      ],
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  stereotype = definitions.predicate.Stereotype,
                  templateDirectory = predicates.isType '"String",
                  verbose = predicates.isType '"Bool",
                  windows = definitions.predicate.Windows-1,
                }
                {  }
                false
                predicates.never
              ],
          JpackageAssemblerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.JpackageAssembler,
                }
                true
                definitions.predicate.JpackageAssembler
              ],
          Label = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  color = predicates.isType '"String",
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Labeler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  body = predicates.isType '"String",
                  label = predicates.isType '"String",
                  order = predicates.isType 'Integer,
                  title = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Launcher = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  arguments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  javaOptions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  launchers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LinkedinAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessToken = predicates.isType '"String",
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  message = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  subject = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Links = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bugTracker = predicates.isType '"String",
                  contact = predicates.isType '"String",
                  contribute = predicates.isType '"String",
                  documentation = predicates.isType '"String",
                  donation = predicates.isType '"String",
                  faq = predicates.isType '"String",
                  help = predicates.isType '"String",
                  homepage = predicates.isType '"String",
                  license = predicates.isType '"String",
                  translate = predicates.isType '"String",
                  vcsBrowser = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Linux-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appCategory = predicates.isType '"String",
                  appName = predicates.isType '"String",
                  appRelease = predicates.isType '"String",
                  icon = predicates.isType '"String",
                  installDir = predicates.isType '"String",
                  jdk = definitions.predicate.Artifact,
                  license = predicates.isType '"String",
                  maintainer = predicates.isType '"String",
                  menuGroup = predicates.isType '"String",
                  packageDeps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  packageName = predicates.isType '"String",
                  platform = predicates.isType '"String",
                  resourceDir = predicates.isType '"String",
                  shortcut = predicates.isType '"Bool",
                  types = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  validTypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Linux-2 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  platform = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          MacportsPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  categories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  commitAuthor = definitions.predicate.CommitAuthor,
                  continueOnError = predicates.isType '"Bool",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  maintainers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  packageName = predicates.isType '"String",
                  repository = definitions.predicate.MacportsRepository,
                  revision = predicates.isType 'Integer,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          MacportsRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          MastodonAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessToken = predicates.isType '"String",
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  host = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  status = predicates.isType '"String",
                  statusTemplate = predicates.isType '"String",
                  statuses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          MattermostAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  message = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  structuredMessage = predicates.isType '"Bool",
                  webhook = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Maven = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifactory = predicates.allOf
                      [
                        definitions.predicate.ArtifactoryMavenDeployerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.ArtifactoryMavenDeployer
                        ]
                      ],
                  azure = predicates.allOf
                      [
                        definitions.predicate.AzureMavenDeployerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.AzureMavenDeployer
                        ]
                      ],
                  gitea = predicates.allOf
                      [
                        definitions.predicate.GiteaMavenDeployerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.GiteaMavenDeployer
                        ]
                      ],
                  github = predicates.allOf
                      [
                        definitions.predicate.GithubMavenDeployerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.GithubMavenDeployer
                        ]
                      ],
                  gitlab = predicates.allOf
                      [
                        definitions.predicate.GitlabMavenDeployerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.GitlabMavenDeployer
                        ]
                      ],
                  nexus2 = predicates.allOf
                      [
                        definitions.predicate.Nexus2MavenDeployerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.Nexus2MavenDeployer
                        ]
                      ],
                  pomchecker = definitions.predicate.Pomchecker,
                }
                {  }
                false
                predicates.never
              ],
          Method = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "PUT", "POST" ]
              ],
          Milestone = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  close = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          MimeType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "TEXT", "HTML" ]
              ],
          Mode-1 = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "INTERACTIVE", "SILENT", "SILENT_WITH_PROGRESS" ]
              ],
          Mode-2 = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "MEMORY", "FILE", "COMMAND", "COSIGN" ]
              ],
          NativeImageAssembler = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  archiveFormat = definitions.predicate.Format-1,
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Artifact
                      ],
                  components = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  executable = predicates.isType '"String",
                  exported = predicates.isType '"Bool",
                  extraProperties = definitions.predicate.Properties,
                  fileSets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.FileSet
                      ],
                  files = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Glob
                      ],
                  graal = definitions.predicate.Artifact,
                  graalJdks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Artifact
                      ],
                  imageName = predicates.isType '"String",
                  imageNameTransform = predicates.isType '"String",
                  jars = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Glob
                      ],
                  java = definitions.predicate.Java-2,
                  linux = definitions.predicate.Linux-2,
                  mainJar = definitions.predicate.Artifact,
                  options = definitions.predicate.ArchiveOptions,
                  osx = definitions.predicate.Osx-2,
                  platform = definitions.predicate.Platform,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  stereotype = definitions.predicate.Stereotype,
                  templateDirectory = predicates.isType '"String",
                  upx = definitions.predicate.Upx,
                  windows = definitions.predicate.Windows-2,
                }
                {  }
                false
                predicates.never
              ],
          NativeImageAssemblerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.NativeImageAssembler,
                }
                true
                definitions.predicate.NativeImageAssembler
              ],
          Nexus2MavenDeployer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  applyMavenCentralRules = predicates.isType '"Bool",
                  artifactOverrides = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ArtifactOverride
                      ],
                  authorization = definitions.predicate.Authorization,
                  checksums = predicates.isType '"Bool",
                  closeRepository = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  javadocJar = predicates.isType '"Bool",
                  password = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  releaseRepository = predicates.isType '"Bool",
                  sign = predicates.isType '"Bool",
                  snapshotUrl = predicates.isType '"String",
                  sourceJar = predicates.isType '"Bool",
                  stagingRepositories = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  transitionDelay = predicates.isType 'Integer,
                  transitionMaxRetries = predicates.isType 'Integer,
                  url = predicates.isType '"String",
                  username = predicates.isType '"String",
                  verifyPom = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          Nexus2MavenDeployerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.Nexus2MavenDeployer,
                }
                true
                definitions.predicate.Nexus2MavenDeployer
              ],
          OpenCollectiveAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  host = predicates.isType '"String",
                  message = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  slug = predicates.isType '"String",
                  title = predicates.isType '"String",
                  token = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Osx-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appName = predicates.isType '"String",
                  icon = predicates.isType '"String",
                  installDir = predicates.isType '"String",
                  jdk = definitions.predicate.Artifact,
                  packageIdentifier = predicates.isType '"String",
                  packageName = predicates.isType '"String",
                  packageSigningPrefix = predicates.isType '"String",
                  platform = predicates.isType '"String",
                  resourceDir = predicates.isType '"String",
                  sign = predicates.isType '"Bool",
                  signingKeyUsername = predicates.isType '"String",
                  signingKeychain = predicates.isType '"String",
                  types = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  validTypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Osx-2 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  platform = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Pack = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Package = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  identifier = predicates.isType '"String",
                  name = predicates.isType '"String",
                  url = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Packagers = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  appImage = definitions.predicate.AppImagePackager,
                  asdf = definitions.predicate.AsdfPackager,
                  brew = definitions.predicate.BrewPackager,
                  chocolatey = definitions.predicate.ChocolateyPackager,
                  docker = definitions.predicate.DockerPackager,
                  flatpak = definitions.predicate.FlatpakPackager,
                  gofish = definitions.predicate.GofishPackager,
                  jbang = definitions.predicate.JbangPackager,
                  jib = definitions.predicate.JibPackager,
                  macports = definitions.predicate.MacportsPackager,
                  scoop = definitions.predicate.ScoopPackager,
                  sdkman = definitions.predicate.SdkmanPackager,
                  snap = definitions.predicate.SnapPackager,
                  spec = definitions.predicate.SpecPackager,
                  winget = definitions.predicate.WingetPackager,
                }
                {  }
                false
                predicates.never
              ],
          Platform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  replacements = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Plug = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  attributes = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  name = predicates.isType '"String",
                  reads = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  writes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Pomchecker = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  failOnError = predicates.isType '"Bool",
                  failOnWarning = predicates.isType '"Bool",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Prerelease = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  pattern = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Project = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  authors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  copyright = predicates.isType '"String",
                  description = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  icons = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Icon
                      ],
                  inceptionYear = predicates.isType '"String",
                  java = definitions.predicate.Java-2,
                  license = predicates.isType '"String",
                  links = definitions.predicate.Links,
                  longDescription = predicates.isType '"String",
                  maintainers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  screenshots = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Screenshot
                      ],
                  snapshot = definitions.predicate.Snapshot,
                  stereotype = definitions.predicate.Stereotype,
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  vendor = predicates.isType '"String",
                  version = predicates.isType '"String",
                  versionPattern = definitions.predicate.VersionPattern,
                }
                {  }
                false
                predicates.never
              ],
          Properties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          Provider = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  properties = definitions.predicate.Properties,
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Publisher = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  supportUrl = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Registry-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  externalLogin = predicates.isType '"Bool",
                  password = predicates.isType '"String",
                  repositoryName = predicates.isType '"String",
                  server = predicates.isType '"String",
                  serverName = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Registry-2 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fromPassword = predicates.isType '"String",
                  fromUsername = predicates.isType '"String",
                  name = predicates.isType '"String",
                  password = predicates.isType '"String",
                  server = predicates.isType '"String",
                  toPassword = predicates.isType '"String",
                  toUsername = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Release = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  codeberg = definitions.predicate.CodebergReleaser,
                  generic = definitions.predicate.GenericGitReleaser,
                  gitea = definitions.predicate.GiteaReleaser,
                  github = definitions.predicate.GithubReleaser,
                  gitlab = definitions.predicate.GitlabReleaser,
                }
                {  }
                false
                predicates.never
              ],
          ReleaseNotes = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configurationFile = predicates.isType '"String",
                  enabled = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          Replacer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  replace = predicates.isType '"String",
                  search = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Repository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Runtime = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "FREEDESKTOP", "GNOME", "KDE", "ELEMENTARY" ]
              ],
          S3Uploader = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessKeyId = predicates.isType '"String",
                  active = definitions.predicate.Active,
                  artifacts = predicates.isType '"Bool",
                  bucket = predicates.isType '"String",
                  catalogs = predicates.isType '"Bool",
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  downloadUrl = predicates.isType '"String",
                  endpoint = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  files = predicates.isType '"Bool",
                  headers = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  path = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  region = predicates.isType '"String",
                  secretKey = predicates.isType '"String",
                  sessionToken = predicates.isType '"String",
                  signatures = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          S3UploaderMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.S3Uploader,
                }
                true
                definitions.predicate.S3Uploader
              ],
          Sbom = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  cyclonedx = definitions.predicate.CyclonedxSbomCataloger,
                  syft = definitions.predicate.SyftSbomCataloger,
                }
                {  }
                false
                predicates.never
              ],
          ScoopPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  autoupdateUrl = predicates.isType '"String",
                  checkverUrl = predicates.isType '"String",
                  commitAuthor = definitions.predicate.CommitAuthor,
                  continueOnError = predicates.isType '"Bool",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  packageName = predicates.isType '"String",
                  repository = definitions.predicate.ScoopRepository,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ScoopRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Scope = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "USER", "MACHINE" ]
              ],
          ScpDownloader = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  assets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Asset
                      ],
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  fingerprint = predicates.isType '"String",
                  host = predicates.isType '"String",
                  knownHostsFile = predicates.isType '"String",
                  passphrase = predicates.isType '"String",
                  password = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                  privateKey = predicates.isType '"String",
                  publicKey = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ScpDownloaderMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.ScpDownloader,
                }
                true
                definitions.predicate.ScpDownloader
              ],
          ScpUploader = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifacts = predicates.isType '"Bool",
                  catalogs = predicates.isType '"Bool",
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  files = predicates.isType '"Bool",
                  fingerprint = predicates.isType '"String",
                  host = predicates.isType '"String",
                  knownHostsFile = predicates.isType '"String",
                  passphrase = predicates.isType '"String",
                  password = predicates.isType '"String",
                  path = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                  privateKey = predicates.isType '"String",
                  publicKey = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  signatures = predicates.isType '"Bool",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ScpUploaderMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.ScpUploader,
                }
                true
                definitions.predicate.ScpUploader
              ],
          Screenshot = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  caption = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  height = predicates.isType 'Integer,
                  primary = predicates.isType '"Bool",
                  type = definitions.predicate.Type-1,
                  url = predicates.isType '"String",
                  width = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          ScriptHook = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  condition = predicates.isType '"String",
                  continueOnError = predicates.isType '"Bool",
                  environment = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  filter = definitions.predicate.Filter,
                  platforms = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  run = predicates.isType '"String",
                  shell = definitions.predicate.Shell,
                  verbose = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ScriptHooks = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  before = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ScriptHook
                      ],
                  environment = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  failure = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ScriptHook
                      ],
                  success = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ScriptHook
                      ],
                }
                {  }
                false
                predicates.never
              ],
          SdkmanAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  candidate = predicates.isType '"String",
                  command = definitions.predicate.Command-1,
                  connectTimeout = predicates.isType 'Integer,
                  consumerKey = predicates.isType '"String",
                  consumerToken = predicates.isType '"String",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  readTimeout = predicates.isType 'Integer,
                  releaseNotesUrl = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SdkmanPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  candidate = predicates.isType '"String",
                  command = definitions.predicate.Command-1,
                  connectTimeout = predicates.isType 'Integer,
                  consumerKey = predicates.isType '"String",
                  consumerToken = predicates.isType '"String",
                  continueOnError = predicates.isType '"Bool",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  readTimeout = predicates.isType 'Integer,
                  releaseNotesUrl = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SftpDownloader = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  assets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Asset
                      ],
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  fingerprint = predicates.isType '"String",
                  host = predicates.isType '"String",
                  knownHostsFile = predicates.isType '"String",
                  passphrase = predicates.isType '"String",
                  password = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                  privateKey = predicates.isType '"String",
                  publicKey = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SftpDownloaderMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.SftpDownloader,
                }
                true
                definitions.predicate.SftpDownloader
              ],
          SftpUploader = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifacts = predicates.isType '"Bool",
                  catalogs = predicates.isType '"Bool",
                  checksums = predicates.isType '"Bool",
                  connectTimeout = predicates.isType 'Integer,
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  files = predicates.isType '"Bool",
                  fingerprint = predicates.isType '"String",
                  host = predicates.isType '"String",
                  knownHostsFile = predicates.isType '"String",
                  passphrase = predicates.isType '"String",
                  password = predicates.isType '"String",
                  path = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                  privateKey = predicates.isType '"String",
                  publicKey = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  signatures = predicates.isType '"Bool",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SftpUploaderMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.SftpUploader,
                }
                true
                definitions.predicate.SftpUploader
              ],
          Shell = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "BASH", "SH", "CMD", "PWSH", "POWERSHELL" ]
              ],
          Signing = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  armored = predicates.isType '"Bool",
                  artifacts = predicates.isType '"Bool",
                  catalogs = predicates.isType '"Bool",
                  checksums = predicates.isType '"Bool",
                  command = definitions.predicate.Command-2,
                  cosign = definitions.predicate.Cosign,
                  files = predicates.isType '"Bool",
                  mode = definitions.predicate.Mode-2,
                  passphrase = predicates.isType '"String",
                  publicKey = predicates.isType '"String",
                  secretKey = predicates.isType '"String",
                  verify = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          SlackAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  channel = predicates.isType '"String",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  message = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  token = predicates.isType '"String",
                  webhook = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Slot = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  attributes = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  name = predicates.isType '"String",
                  reads = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  writes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          SlsaCataloger = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifacts = predicates.isType '"Bool",
                  attestationName = predicates.isType '"String",
                  deployables = predicates.isType '"Bool",
                  extraProperties = definitions.predicate.Properties,
                  files = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          SmtpAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  auth = predicates.isType '"Bool",
                  bcc = predicates.isType '"String",
                  cc = predicates.isType '"String",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  from = predicates.isType '"String",
                  host = predicates.isType '"String",
                  message = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  mimeType = definitions.predicate.MimeType,
                  password = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                  properties = predicates.allOf
                      [
                        definitions.predicate.StringProperties,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          (predicates.isType '"String")
                        ]
                      ],
                  readTimeout = predicates.isType 'Integer,
                  subject = predicates.isType '"String",
                  to = predicates.isType '"String",
                  transport = definitions.predicate.Transport,
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SnapPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  architectures = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Architecture
                      ],
                  base = predicates.isType '"String",
                  commitAuthor = definitions.predicate.CommitAuthor,
                  confinement = predicates.isType '"String",
                  continueOnError = predicates.isType '"Bool",
                  downloadUrl = predicates.isType '"String",
                  exportedLogin = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  grade = predicates.isType '"String",
                  localPlugs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  localSlots = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  packageName = predicates.isType '"String",
                  plugs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Plug
                      ],
                  remoteBuild = predicates.isType '"Bool",
                  repository = definitions.predicate.SnapRepository,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  slots = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Slot
                      ],
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SnapRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Snapshot = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fullChangelog = predicates.isType '"Bool",
                  label = predicates.isType '"String",
                  pattern = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Sort = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "ASC", "DESC" ]
              ],
          SpecPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  commitAuthor = definitions.predicate.CommitAuthor,
                  continueOnError = predicates.isType '"Bool",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  packageName = predicates.isType '"String",
                  release = predicates.isType '"String",
                  repository = definitions.predicate.SpecRepository,
                  requires = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SpecRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Stereotype = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "NONE", "CLI", "DESKTOP", "WEB", "MOBILE" ]
              ],
          StringProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          SyftSbomCataloger = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  distributions = predicates.isType '"Bool",
                  extraProperties = definitions.predicate.Properties,
                  files = predicates.isType '"Bool",
                  formats = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Format-3
                      ],
                  pack = definitions.predicate.Pack,
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TarMode = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "GNU", "POSIX", "ERROR", "TRUNCATE" ]
              ],
          TeamsAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  messageTemplate = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  webhook = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TelegramAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  chatId = predicates.isType '"String",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  message = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  token = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Transport = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "SMTP", "SMTPS" ]
              ],
          TwitterAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accessToken = predicates.isType '"String",
                  accessTokenSecret = predicates.isType '"String",
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  consumerKey = predicates.isType '"String",
                  consumerSecret = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  readTimeout = predicates.isType 'Integer,
                  status = predicates.isType '"String",
                  statusTemplate = predicates.isType '"String",
                  statuses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Type-1 = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "SOURCE", "THUMBNAIL" ]
              ],
          Type-2 = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "MSIX",
                  "MSI",
                  "APPX",
                  "EXE",
                  "ZIP",
                  "INNO",
                  "NULLSOFT",
                  "WIX",
                  "BURN",
                  "PWA"
                ]
              ],
          Type-3 = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "SEMVER",
                  "CALVER",
                  "CHRONVER",
                  "JAVA_RUNTIME",
                  "JAVA_MODULE",
                  "CUSTOM"
                ]
              ],
          Unpack = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  skipRootEntry = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          Update = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  sections = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.UpdateSection
                      ],
                }
                {  }
                false
                predicates.never
              ],
          UpdateSection = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "TITLE", "BODY", "ASSETS" ]
              ],
          UpgradeBehavior = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "INSTALL", "UNINSTALL_PREVIOUS" ]
              ],
          Upload = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  artifactory = predicates.allOf
                      [
                        definitions.predicate.ArtifactoryUploaderMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.ArtifactoryUploader
                        ]
                      ],
                  ftp = predicates.allOf
                      [
                        definitions.predicate.FtpUploaderMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.FtpUploader
                        ]
                      ],
                  gitea = predicates.allOf
                      [
                        definitions.predicate.GiteaUploaderMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.GiteaUploader
                        ]
                      ],
                  gitlab = predicates.allOf
                      [
                        definitions.predicate.GitlabUploaderMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.GitlabUploader
                        ]
                      ],
                  http = predicates.allOf
                      [
                        definitions.predicate.HttpUploaderMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.HttpUploader
                        ]
                      ],
                  s3 = predicates.allOf
                      [
                        definitions.predicate.S3UploaderMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.S3Uploader
                        ]
                      ],
                  scp = predicates.allOf
                      [
                        definitions.predicate.ScpUploaderMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.ScpUploader
                        ]
                      ],
                  sftp = predicates.allOf
                      [
                        definitions.predicate.SftpUploaderMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.SftpUploader
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Upx = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          VersionPattern = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  format = predicates.isType '"String",
                  type = definitions.predicate.Type-3,
                }
                {  }
                false
                predicates.never
              ],
          WebhookAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  message = predicates.isType '"String",
                  messageProperty = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  structuredMessage = predicates.isType '"Bool",
                  webhook = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          WebhookAnnouncerMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    definitions.predicate.WebhookAnnouncer,
                }
                true
                definitions.predicate.WebhookAnnouncer
              ],
          WebhooksAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  readTimeout = predicates.isType 'Integer,
                  webhooks = predicates.allOf
                      [
                        definitions.predicate.WebhookAnnouncerMap,
                        predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record {  } {  } true
                          definitions.predicate.WebhookAnnouncer
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Windows-1 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appName = predicates.isType '"String",
                  console = predicates.isType '"Bool",
                  dirChooser = predicates.isType '"Bool",
                  icon = predicates.isType '"String",
                  installDir = predicates.isType '"String",
                  jdk = definitions.predicate.Artifact,
                  menu = predicates.isType '"Bool",
                  menuGroup = predicates.isType '"String",
                  perUserInstall = predicates.isType '"Bool",
                  platform = predicates.isType '"String",
                  resourceDir = predicates.isType '"String",
                  shortcut = predicates.isType '"Bool",
                  types = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  upgradeUuid = predicates.isType '"String",
                  validTypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Windows-2 = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  platform = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          WingetPackager = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  author = predicates.isType '"String",
                  commitAuthor = definitions.predicate.CommitAuthor,
                  continueOnError = predicates.isType '"Bool",
                  defaultLocale = predicates.isType '"String",
                  downloadUrl = predicates.isType '"String",
                  extraProperties = definitions.predicate.Properties,
                  installer = definitions.predicate.Installer,
                  minimumOsVersion = predicates.isType '"String",
                  moniker = predicates.isType '"String",
                  package = definitions.predicate.Package,
                  productCode = predicates.isType '"String",
                  publisher = definitions.predicate.Publisher,
                  repository = definitions.predicate.WingetRepository,
                  skipTemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  templateDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          WingetRepository = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.Active,
                  branch = predicates.isType '"String",
                  branchPush = predicates.isType '"String",
                  commitMessage = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owner = predicates.isType '"String",
                  tagName = predicates.isType '"String",
                  token = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ZulipAnnouncer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  account = predicates.isType '"String",
                  active = definitions.predicate.Active,
                  apiHost = predicates.isType '"String",
                  apiKey = predicates.isType '"String",
                  channel = predicates.isType '"String",
                  connectTimeout = predicates.isType 'Integer,
                  extraProperties = definitions.predicate.Properties,
                  message = predicates.isType '"String",
                  messageTemplate = predicates.isType '"String",
                  readTimeout = predicates.isType 'Integer,
                  subject = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

definitions.contract.JReleaserModel