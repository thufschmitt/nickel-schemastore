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
          additional-properties-property
            | doc m%"
            Additional sub-properties of the current property or definition or whether to allow them
            https://json-schema.org/understanding-json-schema/reference/object.html?highlight=required#additional-properties
            "%
            = predicates.contract_from_predicate
              definitions.predicate.additional-properties-property,
          all-of-property
            | doc m%"
            A requirement to match all sub-schemas of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/combining.html?highlight=anyof#allof
            "%
            = predicates.contract_from_predicate
              definitions.predicate.all-of-property,
          any-of-property
            | doc m%"
            A requirement to match at least one sub-schema of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/combining.html?highlight=anyof#anyof
            "%
            = predicates.contract_from_predicate
              definitions.predicate.any-of-property,
          array-type-requirement = predicates.contract_from_predicate
              definitions.predicate.array-type-requirement,
          comment-property
            | doc m%"
            A comment of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html#id3
            "%
            = predicates.contract_from_predicate
              definitions.predicate.comment-property,
          condition-entity
            | doc m%"
            A mapping from sub-property name to conditions of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/conditionals.html?highlight=condition#if-then-else
            "%
            = {
                "$comment" | definitions.contract.comment-property | optional,
                "$ref" | definitions.contract.ref-property | optional,
                additionalProperties
                  | definitions.contract.additional-properties-property
                  | optional,
                const | definitions.contract.const-property | optional,
                "default" | definitions.contract.default-property | optional,
                enum | definitions.contract.enum-property | optional,
                exclusiveMaximum
                  | definitions.contract.exclusive-maximum-property
                  | optional,
                exclusiveMinimum
                  | definitions.contract.exclusive-minimum-property
                  | optional,
                items | definitions.contract.condition-entity | optional,
                maxItems | definitions.contract.max-items-property | optional,
                maxLength | definitions.contract.max-length-property | optional,
                maxProperties
                  | definitions.contract.max-properties-property
                  | optional,
                maximum | definitions.contract.maximum-property | optional,
                minItems | definitions.contract.min-items-property | optional,
                minLength | definitions.contract.min-length-property | optional,
                minProperties
                  | definitions.contract.min-properties-property
                  | optional,
                minimum | definitions.contract.minimum-property | optional,
                multipleOf
                  | definitions.contract.multiple-of-property
                  | optional,
                pattern | definitions.contract.pattern-property | optional,
                patternProperties
                  | definitions.contract.pattern-properties-property
                  | optional,
                properties
                  | definitions.contract.properties-property
                  | optional,
                required | definitions.contract.required-property | optional,
                type | definitions.contract.type-property | optional,
                uniqueItems
                  | definitions.contract.unique-items-property
                  | optional,
              },
          const-property
            | doc m%"
            A constant of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html?highlight=const#constant-values
            "%
            = definitions.contract.simple-type,
          default-property
            | doc m%"
            A default of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html?highlight=default#annotations
            "%
            = definitions.contract.simple-type,
          description-property
            | doc m%"
            A description of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html?highlight=title#annotations
            "%
            = predicates.contract_from_predicate
              definitions.predicate.description-property,
          else-property
            | doc m%"
            A conditional else branch of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/conditionals.html?highlight=condition#if-then-else
            "%
            = predicates.contract_from_predicate
              definitions.predicate.else-property,
          entity = predicates.contract_from_predicate
              definitions.predicate.entity,
          entity-dependencies = predicates.contract_from_predicate
              definitions.predicate.entity-dependencies,
          entity-requirements-and-dependencies =
            predicates.contract_from_predicate
              definitions.predicate.entity-requirements-and-dependencies,
          enum-property
            | doc m%"
            Valid values of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html?highlight=enum#enumerated-values
            "%
            = predicates.contract_from_predicate
              definitions.predicate.enum-property,
          examples-property
            | doc m%"
            Examples of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html?highlight=default#annotations
            "%
            = predicates.contract_from_predicate
              definitions.predicate.examples-property,
          exclusive-maximum-property
            | doc m%"
            An exclusive maximum of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/numeric.html?highlight=minimum#range
            "%
            = Number,
          exclusive-minimum-property
            | doc m%"
            An exclusive minimum of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/numeric.html?highlight=minimum#range
            "%
            = Number,
          if-property
            | doc m%"
            A conditional header of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/conditionals.html?highlight=condition#if-then-else
            "%
            = {
                properties
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { "." = definitions.predicate.condition-entity, }
                    false
                    predicates.never
                  ])
                  | doc m%"
                  A mapping from sub-property names to conditions of the current property or definition
                  https://json-schema.org/understanding-json-schema/reference/conditionals.html?highlight=condition#if-then-else
                  "%,
              },
          items-property
            | doc m%"
            Items of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/array.html?highlight=items#items
            "%
            = definitions.contract.entity,
          max-items-property
            | doc m%"
            A maximum item count of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/array.html?highlight=items#length
            "%
            = predicates.contract_from_predicate
              definitions.predicate.max-items-property,
          max-length-property
            | doc m%"
            A maximum length of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/string.html?highlight=minlength#length
            "%
            = predicates.contract_from_predicate
              definitions.predicate.max-length-property,
          max-properties-property
            | doc m%"
            A maximum count of sub-properties of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/object.html?highlight=required#size
            "%
            = predicates.contract_from_predicate
              definitions.predicate.max-properties-property,
          maximum-property
            | doc m%"
            A maximum of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/numeric.html?highlight=minimum#range
            "%
            = Number,
          min-items-property
            | doc m%"
            A minimum item count of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/array.html?highlight=items#length
            "%
            = predicates.contract_from_predicate
              definitions.predicate.min-items-property,
          min-length-property
            | doc m%"
            A minimum length of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/string.html?highlight=minlength#length
            "%
            = predicates.contract_from_predicate
              definitions.predicate.min-length-property,
          min-properties-property
            | doc m%"
            A minimum count of sub-properties of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/object.html?highlight=required#size
            "%
            = predicates.contract_from_predicate
              definitions.predicate.min-properties-property,
          minimum-property
            | doc m%"
            A minimum of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/numeric.html?highlight=minimum#range
            "%
            = Number,
          multiple-of-property
            | doc m%"
            A multiple of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/numeric.html?highlight=minimum#multiples
            "%
            = predicates.contract_from_predicate
              definitions.predicate.multiple-of-property,
          not-property
            | doc m%"
            A sub-schema should not match of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/combining.html?highlight=anyof#not
            "%
            = predicates.contract_from_predicate
              definitions.predicate.not-property,
          numeric-type-requirement = predicates.contract_from_predicate
              definitions.predicate.numeric-type-requirement,
          object-type-requirement = predicates.contract_from_predicate
              definitions.predicate.object-type-requirement,
          one-of-property
            | doc m%"
            A requirement to match at one sub-schema of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/combining.html?highlight=anyof#oneof
            "%
            = predicates.contract_from_predicate
              definitions.predicate.one-of-property,
          pattern-properties-property
            | doc m%"
            Pattern sub-properties of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/object.html?highlight=required#pattern-properties
            "%
            = predicates.contract_from_predicate
              definitions.predicate.pattern-properties-property,
          pattern-property
            | doc m%"
            A pattern of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/string.html?highlight=minlength#regular-expressions
            "%
            = String,
          properties-property
            | doc m%"
            Sub-properties of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/object.html?highlight=properties#properties
            "%
            = predicates.contract_from_predicate
              definitions.predicate.properties-property,
          ref-property
            | doc m%"
            A reference of the current property or definition
            https://json-schema.org/understanding-json-schema/structuring.html#ref
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ref-property,
          required-property
            | doc m%"
            Required sub-properties of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/object.html?highlight=required#required-properties
            "%
            = predicates.contract_from_predicate
              definitions.predicate.required-property,
          requirement-entity
            | doc m%"
            A mapping from sub-property name to requirements of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/conditionals.html?highlight=condition#if-then-else
            "%
            = {
                "$comment" | definitions.contract.comment-property | optional,
                "$ref" | definitions.contract.ref-property | optional,
                additionalProperties
                  | definitions.contract.additional-properties-property
                  | optional,
                "default" | definitions.contract.default-property | optional,
                description
                  | definitions.contract.description-property
                  | optional,
                enum | definitions.contract.enum-property | optional,
                examples | definitions.contract.examples-property | optional,
                exclusiveMaximum
                  | definitions.contract.exclusive-maximum-property
                  | optional,
                exclusiveMinimum
                  | definitions.contract.exclusive-minimum-property
                  | optional,
                items | definitions.contract.requirement-entity | optional,
                maxItems | definitions.contract.max-items-property | optional,
                maxLength | definitions.contract.max-length-property | optional,
                maxProperties
                  | definitions.contract.max-properties-property
                  | optional,
                maximum | definitions.contract.maximum-property | optional,
                minItems | definitions.contract.min-items-property | optional,
                minLength | definitions.contract.min-length-property | optional,
                minProperties
                  | definitions.contract.min-properties-property
                  | optional,
                minimum | definitions.contract.minimum-property | optional,
                multipleOf
                  | definitions.contract.multiple-of-property
                  | optional,
                pattern | definitions.contract.pattern-property | optional,
                patternProperties
                  | definitions.contract.pattern-properties-property
                  | optional,
                properties
                  | definitions.contract.properties-property
                  | optional,
                required | definitions.contract.required-property | optional,
                title | definitions.contract.title-property | optional,
                type | definitions.contract.type-property | optional,
                uniqueItems
                  | definitions.contract.unique-items-property
                  | optional,
              },
          requirements = predicates.contract_from_predicate
              definitions.predicate.requirements,
          root-entity = predicates.contract_from_predicate
              definitions.predicate.root-entity,
          simple-type = predicates.contract_from_predicate
              definitions.predicate.simple-type,
          simple-type-requirement = predicates.contract_from_predicate
              definitions.predicate.simple-type-requirement,
          space-string = predicates.contract_from_predicate
              definitions.predicate.space-string,
          string-type-requirement = predicates.contract_from_predicate
              definitions.predicate.string-type-requirement,
          sub-schema-entity = predicates.contract_from_predicate
              definitions.predicate.sub-schema-entity,
          then-property
            | doc m%"
            A conditional branch of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/conditionals.html?highlight=condition#if-then-else
            "%
            = predicates.contract_from_predicate
              definitions.predicate.then-property,
          title-property
            | doc m%"
            A title of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html?highlight=title#annotations
            "%
            = predicates.contract_from_predicate
              definitions.predicate.title-property,
          type-property
            | doc m%"
            A type of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/type.html
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'string,
                  'boolean,
                  'object,
                  'array,
                  '"null",
                  'integer,
                  'number
                |]
              ],
          unique-items-property
            | doc m%"
            Whether items of the current property or definition should be unique
            https://json-schema.org/understanding-json-schema/reference/array.html?highlight=items#uniqueness
            "%
            = Bool,
        },
    predicate = {
          additional-properties-property
            | doc m%"
            Additional sub-properties of the current property or definition or whether to allow them
            https://json-schema.org/understanding-json-schema/reference/object.html?highlight=required#additional-properties
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"Bool", predicates.const false ],
                definitions.predicate.entity
              ],
          all-of-property
            | doc m%"
            A requirement to match all sub-schemas of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/combining.html?highlight=anyof#allof
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.sub-schema-entity,
                predicates.arrays.minItems 2,
                predicates.arrays.uniqueItems
              ],
          any-of-property
            | doc m%"
            A requirement to match at least one sub-schema of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/combining.html?highlight=anyof#anyof
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.sub-schema-entity,
                predicates.arrays.minItems 2,
                predicates.arrays.uniqueItems
              ],
          array-type-requirement = predicates.records.record
              { type = predicates.const "array", }
              {  }
              true
              predicates.always,
          comment-property
            | doc m%"
            A comment of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html#id3
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          condition-entity
            | doc m%"
            A mapping from sub-property name to conditions of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/conditionals.html?highlight=condition#if-then-else
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "$comment" = definitions.predicate.comment-property,
                  "$ref" = definitions.predicate.ref-property,
                  additionalProperties =
                    definitions.predicate.additional-properties-property,
                  const = definitions.predicate.const-property,
                  "default" = definitions.predicate.default-property,
                  enum = definitions.predicate.enum-property,
                  exclusiveMaximum =
                    definitions.predicate.exclusive-maximum-property,
                  exclusiveMinimum =
                    definitions.predicate.exclusive-minimum-property,
                  items = definitions.predicate.condition-entity,
                  maxItems = definitions.predicate.max-items-property,
                  maxLength = definitions.predicate.max-length-property,
                  maxProperties = definitions.predicate.max-properties-property,
                  maximum = definitions.predicate.maximum-property,
                  minItems = definitions.predicate.min-items-property,
                  minLength = definitions.predicate.min-length-property,
                  minProperties = definitions.predicate.min-properties-property,
                  minimum = definitions.predicate.minimum-property,
                  multipleOf = definitions.predicate.multiple-of-property,
                  pattern = definitions.predicate.pattern-property,
                  patternProperties =
                    definitions.predicate.pattern-properties-property,
                  properties = definitions.predicate.properties-property,
                  required = definitions.predicate.required-property,
                  type = definitions.predicate.type-property,
                  uniqueItems = definitions.predicate.unique-items-property,
                }
                {  }
                false
                predicates.never
              ],
          const-property
            | doc m%"
            A constant of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html?highlight=const#constant-values
            "%
            = definitions.predicate.simple-type,
          default-property
            | doc m%"
            A default of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html?highlight=default#annotations
            "%
            = definitions.predicate.simple-type,
          description-property
            | doc m%"
            A description of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html?highlight=title#annotations
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.not definitions.predicate.space-string,
                predicates.strings.minLength 1,
                predicates.strings.pattern "\\nhttps?://."
              ],
          else-property
            | doc m%"
            A conditional else branch of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/conditionals.html?highlight=condition#if-then-else
            "%
            = predicates.allOf
              [ predicates.isType 'Record, definitions.predicate.requirements ],
          entity = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "$comment" = definitions.predicate.comment-property,
                  "$ref" = definitions.predicate.ref-property,
                  additionalProperties =
                    definitions.predicate.additional-properties-property,
                  allOf = definitions.predicate.all-of-property,
                  anyOf = definitions.predicate.any-of-property,
                  const = definitions.predicate.const-property,
                  "default" = definitions.predicate.default-property,
                  description = definitions.predicate.description-property,
                  "else" = definitions.predicate.else-property,
                  enum = definitions.predicate.enum-property,
                  examples = definitions.predicate.examples-property,
                  exclusiveMaximum =
                    definitions.predicate.exclusive-maximum-property,
                  exclusiveMinimum =
                    definitions.predicate.exclusive-minimum-property,
                  "if" = definitions.predicate.if-property,
                  items = definitions.predicate.items-property,
                  maxItems = definitions.predicate.max-items-property,
                  maxLength = definitions.predicate.max-length-property,
                  maxProperties = definitions.predicate.max-properties-property,
                  maximum = definitions.predicate.maximum-property,
                  minItems = definitions.predicate.min-items-property,
                  minLength = definitions.predicate.min-length-property,
                  minProperties = definitions.predicate.min-properties-property,
                  minimum = definitions.predicate.minimum-property,
                  multipleOf = definitions.predicate.multiple-of-property,
                  not = definitions.predicate.not-property,
                  oneOf = definitions.predicate.one-of-property,
                  pattern = definitions.predicate.pattern-property,
                  patternProperties =
                    definitions.predicate.pattern-properties-property,
                  properties = definitions.predicate.properties-property,
                  required = definitions.predicate.required-property,
                  "then" = definitions.predicate.then-property,
                  title = definitions.predicate.title-property,
                  type = definitions.predicate.type-property,
                  uniqueItems = definitions.predicate.unique-items-property,
                }
                {  }
                false
                predicates.never,
                definitions.predicate.entity-requirements-and-dependencies
              ],
          entity-dependencies = predicates.records.dependencies
              {
                "$ref" = predicates.always,
                additionalProperties =
                  definitions.predicate.object-type-requirement,
                "else" = [ "if", "then" ],
                enum = definitions.predicate.simple-type-requirement,
                exclusiveMaximum =
                  definitions.predicate.numeric-type-requirement,
                exclusiveMinimum =
                  definitions.predicate.numeric-type-requirement,
                "if" = [ "then" ],
                items = definitions.predicate.array-type-requirement,
                maxItems = definitions.predicate.array-type-requirement,
                maxLength = definitions.predicate.string-type-requirement,
                maxProperties = definitions.predicate.object-type-requirement,
                maximum = definitions.predicate.numeric-type-requirement,
                minItems = definitions.predicate.array-type-requirement,
                minLength = definitions.predicate.string-type-requirement,
                minProperties = definitions.predicate.object-type-requirement,
                minimum = definitions.predicate.numeric-type-requirement,
                multipleOf = definitions.predicate.numeric-type-requirement,
                pattern = definitions.predicate.string-type-requirement,
                patternProperties =
                  definitions.predicate.object-type-requirement,
                properties = definitions.predicate.object-type-requirement,
                required = definitions.predicate.object-type-requirement,
                "then" = [ "if" ],
                uniqueItems = definitions.predicate.array-type-requirement,
              },
          entity-requirements-and-dependencies = predicates.allOf
              [
                predicates.records.required [ "description", "title", "type" ],
                predicates.records.record {  } {  } true predicates.always,
                definitions.predicate.entity-dependencies
              ],
          enum-property
            | doc m%"
            Valid values of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html?highlight=enum#enumerated-values
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.simple-type,
                predicates.arrays.minItems 1,
                predicates.arrays.uniqueItems
              ],
          examples-property
            | doc m%"
            Examples of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html?highlight=default#annotations
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.strings.minLength 1,
                predicates.arrays.arrayOf definitions.predicate.simple-type,
                predicates.arrays.uniqueItems
              ],
          exclusive-maximum-property
            | doc m%"
            An exclusive maximum of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/numeric.html?highlight=minimum#range
            "%
            = predicates.isType '"Number",
          exclusive-minimum-property
            | doc m%"
            An exclusive minimum of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/numeric.html?highlight=minimum#range
            "%
            = predicates.isType '"Number",
          if-property
            | doc m%"
            A conditional header of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/conditionals.html?highlight=condition#if-then-else
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "properties" ],
                predicates.records.record
                {
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { "." = definitions.predicate.condition-entity, }
                        false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never
              ],
          items-property
            | doc m%"
            Items of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/array.html?highlight=items#items
            "%
            = definitions.predicate.entity,
          max-items-property
            | doc m%"
            A maximum item count of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/array.html?highlight=items#length
            "%
            = predicates.allOf
              [
                predicates.isType 'Integer,
                predicates.numbers.exclusiveMinimum 0
              ],
          max-length-property
            | doc m%"
            A maximum length of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/string.html?highlight=minlength#length
            "%
            = predicates.allOf
              [ predicates.isType 'Integer, predicates.numbers.minimum 0 ],
          max-properties-property
            | doc m%"
            A maximum count of sub-properties of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/object.html?highlight=required#size
            "%
            = predicates.allOf
              [ predicates.isType 'Integer, predicates.numbers.minimum 1 ],
          maximum-property
            | doc m%"
            A maximum of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/numeric.html?highlight=minimum#range
            "%
            = predicates.isType '"Number",
          min-items-property
            | doc m%"
            A minimum item count of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/array.html?highlight=items#length
            "%
            = predicates.allOf
              [
                predicates.isType 'Integer,
                predicates.numbers.exclusiveMinimum 0
              ],
          min-length-property
            | doc m%"
            A minimum length of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/string.html?highlight=minlength#length
            "%
            = predicates.allOf
              [ predicates.isType 'Integer, predicates.numbers.minimum 0 ],
          min-properties-property
            | doc m%"
            A minimum count of sub-properties of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/object.html?highlight=required#size
            "%
            = predicates.allOf
              [ predicates.isType 'Integer, predicates.numbers.minimum 1 ],
          minimum-property
            | doc m%"
            A minimum of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/numeric.html?highlight=minimum#range
            "%
            = predicates.isType '"Number",
          multiple-of-property
            | doc m%"
            A multiple of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/numeric.html?highlight=minimum#multiples
            "%
            = predicates.allOf
              [
                predicates.isType '"Number",
                predicates.numbers.exclusiveMinimum 0
              ],
          not-property
            | doc m%"
            A sub-schema should not match of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/combining.html?highlight=anyof#not
            "%
            = predicates.allOf
              [
                predicates.records.minProperties 1,
                predicates.records.record {  } {  } true predicates.always,
                definitions.predicate.sub-schema-entity
              ],
          numeric-type-requirement = predicates.oneOf
              [
                predicates.records.record { type = predicates.const "integer", }
                {  }
                true
                predicates.always,
                predicates.records.record { type = predicates.const "number", }
                {  }
                true
                predicates.always
              ],
          object-type-requirement = predicates.records.record
              { type = predicates.const "object", }
              {  }
              true
              predicates.always,
          one-of-property
            | doc m%"
            A requirement to match at one sub-schema of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/combining.html?highlight=anyof#oneof
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.sub-schema-entity,
                predicates.arrays.minItems 2,
                predicates.arrays.uniqueItems
              ],
          pattern-properties-property
            | doc m%"
            Pattern sub-properties of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/object.html?highlight=required#pattern-properties
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { "." = definitions.predicate.entity, }
                { "." = definitions.predicate.entity, }
                false
                predicates.never
              ],
          pattern-property
            | doc m%"
            A pattern of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/string.html?highlight=minlength#regular-expressions
            "%
            = predicates.isType '"String",
          properties-property
            | doc m%"
            Sub-properties of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/object.html?highlight=properties#properties
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                { "." = definitions.predicate.entity, }
                false
                predicates.never
              ],
          ref-property
            | doc m%"
            A reference of the current property or definition
            https://json-schema.org/understanding-json-schema/structuring.html#ref
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.minLength 1,
                predicates.strings.pattern "^#/definitions/."
              ],
          required-property
            | doc m%"
            Required sub-properties of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/object.html?highlight=required#required-properties
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.strings.minLength 1,
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.minLength 1
                ]),
                predicates.arrays.uniqueItems
              ],
          requirement-entity
            | doc m%"
            A mapping from sub-property name to requirements of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/conditionals.html?highlight=condition#if-then-else
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "$comment" = definitions.predicate.comment-property,
                  "$ref" = definitions.predicate.ref-property,
                  additionalProperties =
                    definitions.predicate.additional-properties-property,
                  "default" = definitions.predicate.default-property,
                  description = definitions.predicate.description-property,
                  enum = definitions.predicate.enum-property,
                  examples = definitions.predicate.examples-property,
                  exclusiveMaximum =
                    definitions.predicate.exclusive-maximum-property,
                  exclusiveMinimum =
                    definitions.predicate.exclusive-minimum-property,
                  items = definitions.predicate.requirement-entity,
                  maxItems = definitions.predicate.max-items-property,
                  maxLength = definitions.predicate.max-length-property,
                  maxProperties = definitions.predicate.max-properties-property,
                  maximum = definitions.predicate.maximum-property,
                  minItems = definitions.predicate.min-items-property,
                  minLength = definitions.predicate.min-length-property,
                  minProperties = definitions.predicate.min-properties-property,
                  minimum = definitions.predicate.minimum-property,
                  multipleOf = definitions.predicate.multiple-of-property,
                  pattern = definitions.predicate.pattern-property,
                  patternProperties =
                    definitions.predicate.pattern-properties-property,
                  properties = definitions.predicate.properties-property,
                  required = definitions.predicate.required-property,
                  title = definitions.predicate.title-property,
                  type = definitions.predicate.type-property,
                  uniqueItems = definitions.predicate.unique-items-property,
                }
                {  }
                false
                predicates.never
              ],
          requirements = predicates.allOf
              [
                predicates.records.required [ "properties" ],
                predicates.records.record
                {
                  additionalProperties =
                    definitions.predicate.additional-properties-property,
                  maxProperties = definitions.predicate.max-properties-property,
                  minProperties = definitions.predicate.min-properties-property,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.minProperties 1,
                        predicates.records.record {  }
                        { "." = definitions.predicate.requirement-entity, }
                        false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never
              ],
          root-entity = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "$comment" = definitions.predicate.comment-property,
                  "$ref" = definitions.predicate.ref-property,
                  "$schema" = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.minLength 1
                      ],
                  additionalProperties =
                    definitions.predicate.additional-properties-property,
                  allOf = definitions.predicate.all-of-property,
                  anyOf = definitions.predicate.any-of-property,
                  const = definitions.predicate.const-property,
                  "default" = definitions.predicate.default-property,
                  definitions = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { "." = definitions.predicate.entity, }
                        false
                        predicates.never
                      ],
                  description = definitions.predicate.description-property,
                  "else" = definitions.predicate.else-property,
                  enum = definitions.predicate.enum-property,
                  examples = definitions.predicate.examples-property,
                  exclusiveMaximum =
                    definitions.predicate.exclusive-maximum-property,
                  exclusiveMinimum =
                    definitions.predicate.exclusive-minimum-property,
                  "if" = definitions.predicate.if-property,
                  items = definitions.predicate.items-property,
                  maxItems = definitions.predicate.max-items-property,
                  maxLength = definitions.predicate.max-length-property,
                  maxProperties = definitions.predicate.max-properties-property,
                  maximum = definitions.predicate.maximum-property,
                  minItems = definitions.predicate.min-items-property,
                  minLength = definitions.predicate.min-length-property,
                  minProperties = definitions.predicate.min-properties-property,
                  minimum = definitions.predicate.minimum-property,
                  multipleOf = definitions.predicate.multiple-of-property,
                  not = definitions.predicate.not-property,
                  oneOf = definitions.predicate.one-of-property,
                  pattern = definitions.predicate.pattern-property,
                  patternProperties =
                    definitions.predicate.pattern-properties-property,
                  properties = definitions.predicate.properties-property,
                  required = definitions.predicate.required-property,
                  "then" = definitions.predicate.then-property,
                  title = definitions.predicate.title-property,
                  type = definitions.predicate.type-property,
                  uniqueItems = definitions.predicate.unique-items-property,
                }
                {  }
                false
                predicates.never,
                definitions.predicate.entity-requirements-and-dependencies
              ],
          simple-type = predicates.anyOf
              [
                predicates.isType '"Bool",
                predicates.isType 'Integer,
                predicates.isType 'Null,
                predicates.isType '"Number",
                predicates.isType '"String"
              ],
          simple-type-requirement = predicates.oneOf
              [
                predicates.records.record { type = predicates.const "boolean", }
                {  }
                true
                predicates.always,
                predicates.records.record { type = predicates.const "integer", }
                {  }
                true
                predicates.always,
                predicates.records.record { type = predicates.const "null", }
                {  }
                true
                predicates.always,
                predicates.records.record { type = predicates.const "number", }
                {  }
                true
                predicates.always,
                predicates.records.record { type = predicates.const "string", }
                {  }
                true
                predicates.always
              ],
          space-string = predicates.strings.pattern "^\\s+$|\\s{2,}",
          string-type-requirement = predicates.records.record
              { type = predicates.const "string", }
              {  }
              true
              predicates.always,
          sub-schema-entity = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.minProperties 1,
                predicates.records.record
                {
                  "$comment" = definitions.predicate.comment-property,
                  "$ref" = definitions.predicate.ref-property,
                  additionalProperties =
                    definitions.predicate.additional-properties-property,
                  allOf = definitions.predicate.all-of-property,
                  anyOf = definitions.predicate.any-of-property,
                  const = definitions.predicate.const-property,
                  "default" = definitions.predicate.default-property,
                  "else" = definitions.predicate.else-property,
                  enum = definitions.predicate.enum-property,
                  examples = definitions.predicate.examples-property,
                  exclusiveMaximum =
                    definitions.predicate.exclusive-maximum-property,
                  exclusiveMinimum =
                    definitions.predicate.exclusive-minimum-property,
                  "if" = definitions.predicate.if-property,
                  items = definitions.predicate.items-property,
                  maxItems = definitions.predicate.max-items-property,
                  maxLength = definitions.predicate.max-length-property,
                  maxProperties = definitions.predicate.max-properties-property,
                  maximum = definitions.predicate.maximum-property,
                  minItems = definitions.predicate.min-items-property,
                  minLength = definitions.predicate.min-length-property,
                  minProperties = definitions.predicate.min-properties-property,
                  minimum = definitions.predicate.minimum-property,
                  multipleOf = definitions.predicate.multiple-of-property,
                  not = definitions.predicate.not-property,
                  oneOf = definitions.predicate.one-of-property,
                  pattern = definitions.predicate.pattern-property,
                  patternProperties =
                    definitions.predicate.pattern-properties-property,
                  properties = definitions.predicate.properties-property,
                  required = definitions.predicate.required-property,
                  "then" = definitions.predicate.then-property,
                  type = definitions.predicate.type-property,
                  uniqueItems = definitions.predicate.unique-items-property,
                }
                {  }
                false
                predicates.never,
                definitions.predicate.entity-dependencies
              ],
          then-property
            | doc m%"
            A conditional branch of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/conditionals.html?highlight=condition#if-then-else
            "%
            = predicates.allOf
              [ predicates.isType 'Record, definitions.predicate.requirements ],
          title-property
            | doc m%"
            A title of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/generic.html?highlight=title#annotations
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.not definitions.predicate.space-string,
                predicates.strings.minLength 1
              ],
          type-property
            | doc m%"
            A type of the current property or definition
            https://json-schema.org/understanding-json-schema/reference/type.html
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "number",
                  "integer",
                  "null",
                  "array",
                  "object",
                  "boolean",
                  "string"
                ]
              ],
          unique-items-property
            | doc m%"
            Whether items of the current property or definition should be unique
            https://json-schema.org/understanding-json-schema/reference/array.html?highlight=items#uniqueness
            "%
            = predicates.isType '"Bool",
        },
  }
in

definitions.contract.root-entity