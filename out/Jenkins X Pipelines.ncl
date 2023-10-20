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
          AWSElasticBlockStoreVolumeSource = {
                fsType | String | optional,
                partition | std.number.Integer | optional,
                readOnly | Bool | optional,
                volumeID | String | optional,
              },
          AddonConfig = {
                name | String | optional,
                version | String | optional,
              },
          Agent = {
                container | String | optional,
                dir | String | optional,
                image | String | optional,
                label | String | optional,
              },
          AzureDiskVolumeSource = {
                cachingMode | String | optional,
                diskName | String | optional,
                diskURI | String | optional,
                fsType | String | optional,
                kind | String | optional,
                readOnly | Bool | optional,
              },
          AzureFileVolumeSource = {
                readOnly | Bool | optional,
                secretName | String | optional,
                shareName | String | optional,
              },
          CSIVolumeSource = {
                driver | String | optional,
                fsType | String | optional,
                nodePublishSecretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
                readOnly | Bool | optional,
                volumeAttributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | optional,
              },
          CephFSVolumeSource = {
                monitors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                path | String | optional,
                readOnly | Bool | optional,
                secretFile | String | optional,
                secretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
                user | String | optional,
              },
          ChatConfig = {
                developerChannel | String | optional,
                kind | String | optional,
                url | String | optional,
                userChannel | String | optional,
              },
          CinderVolumeSource = {
                fsType | String | optional,
                readOnly | Bool | optional,
                secretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
                volumeID | String | optional,
              },
          ConfigMapKeySelector = {
                key | String | optional,
                name | String | optional,
                "optional" | Bool | optional,
              },
          ConfigMapProjection = {
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KeyToPath
                  ])
                  | optional,
                name | String | optional,
                "optional" | Bool | optional,
              },
          ConfigMapVolumeSource = {
                defaultMode | std.number.Integer | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KeyToPath
                  ])
                  | optional,
                name | String | optional,
                "optional" | Bool | optional,
              },
          Container = {  .. },
          DownwardAPIProjection = {
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DownwardAPIVolumeFile
                  ])
                  | optional,
              },
          DownwardAPIVolumeFile = {
                fieldRef | definitions.contract.ObjectFieldSelector | optional,
                mode | std.number.Integer | optional,
                path | String | optional,
                resourceFieldRef
                  | definitions.contract.ResourceFieldSelector
                  | optional,
              },
          DownwardAPIVolumeSource = {
                defaultMode | std.number.Integer | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DownwardAPIVolumeFile
                  ])
                  | optional,
              },
          EmptyDirVolumeSource = {
                medium | String | optional,
                sizeLimit | definitions.contract.Quantity | optional,
              },
          EnvVar = {
                name | String | optional,
                value | String | optional,
                valueFrom
                  | predicates.contract_from_predicate
                  definitions.predicate.EnvVarSource
                  | optional,
              },
          EnvVarSource = {
                configMapKeyRef
                  | predicates.contract_from_predicate
                  definitions.predicate.ConfigMapKeySelector
                  | optional,
                fieldRef
                  | predicates.contract_from_predicate
                  definitions.predicate.ObjectFieldSelector
                  | optional,
                resourceFieldRef
                  | predicates.contract_from_predicate
                  definitions.predicate.ResourceFieldSelector
                  | optional,
                secretKeyRef
                  | predicates.contract_from_predicate
                  definitions.predicate.SecretKeySelector
                  | optional,
              },
          FCVolumeSource = {
                fsType | String | optional,
                lun | std.number.Integer | optional,
                readOnly | Bool | optional,
                targetWWNs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                wwids
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          FlexVolumeSource = {
                driver | String | optional,
                fsType | String | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | optional,
                readOnly | Bool | optional,
                secretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
              },
          FlockerVolumeSource = {
                datasetName | String | optional,
                datasetUUID | String | optional,
              },
          GCEPersistentDiskVolumeSource = {
                fsType | String | optional,
                partition | std.number.Integer | optional,
                pdName | String | optional,
                readOnly | Bool | optional,
              },
          GitRepoVolumeSource = {
                directory | String | optional,
                repository | String | optional,
                revision | String | optional,
              },
          GlusterfsVolumeSource = {
                endpoints | String | optional,
                path | String | optional,
                readOnly | Bool | optional,
              },
          HostPathVolumeSource = {
                path | String | optional,
                type | String | optional,
              },
          ISCSIVolumeSource = {
                chapAuthDiscovery | Bool | optional,
                chapAuthSession | Bool | optional,
                fsType | String | optional,
                initiatorName | String | optional,
                iqn | String | optional,
                iscsiInterface | String | optional,
                lun | std.number.Integer | optional,
                portals
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                readOnly | Bool | optional,
                secretRef
                  | predicates.contract_from_predicate
                  definitions.predicate.LocalObjectReference
                  | optional,
                targetPortal | String | optional,
              },
          IssueTrackerConfig = {
                kind | String | optional,
                project | String | optional,
                url | String | optional,
              },
          KeyToPath = {
                key | String | optional,
                mode | std.number.Integer | optional,
                path | String | optional,
              },
          LocalObjectReference = { name | String | optional, },
          Loop = {
                steps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Step
                  ])
                  | optional,
                values
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                variable | String | optional,
              },
          NFSVolumeSource = {
                path | String | optional,
                readOnly | Bool | optional,
                server | String | optional,
              },
          ObjectFieldSelector = {
                apiVersion | String | optional,
                fieldPath | String | optional,
              },
          ParsedPipeline = {
                agent | definitions.contract.Agent | optional,
                dir | String | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.EnvVar
                  ])
                  | optional,
                environment
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.EnvVar
                  ])
                  | optional,
                options
                  | predicates.contract_from_predicate
                  definitions.predicate.RootOptions
                  | optional,
                post
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Post
                  ])
                  | optional,
                stages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Stage
                  ])
                  | optional,
              },
          PersistentVolumeClaimVolumeSource = {
                claimName | String | optional,
                readOnly | Bool | optional,
              },
          PhotonPersistentDiskVolumeSource = {
                fsType | String | optional,
                pdID | String | optional,
              },
          PipelineConfig = {
                agent
                  | predicates.contract_from_predicate
                  definitions.predicate.Agent
                  | optional,
                containerOptions | definitions.contract.Container | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.EnvVar
                  ])
                  | optional,
                environment | String | optional,
                extends
                  | predicates.contract_from_predicate
                  definitions.predicate.PipelineExtends
                  | optional,
                pipelines
                  | predicates.contract_from_predicate
                  definitions.predicate.Pipelines
                  | optional,
              },
          PipelineExtends = {
                file | String | optional,
                "import" | String | optional,
              },
          PipelineLifecycle = {
                preSteps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Step
                  ])
                  | optional,
                replace | Bool | optional,
                steps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Step
                  ])
                  | optional,
              },
          PipelineLifecycles = {
                build | definitions.contract.PipelineLifecycle | optional,
                pipeline
                  | predicates.contract_from_predicate
                  definitions.predicate.ParsedPipeline
                  | optional,
                postBuild | definitions.contract.PipelineLifecycle | optional,
                preBuild | definitions.contract.PipelineLifecycle | optional,
                promote | definitions.contract.PipelineLifecycle | optional,
                setVersion | definitions.contract.PipelineLifecycle | optional,
                setup
                  | predicates.contract_from_predicate
                  definitions.predicate.PipelineLifecycle
                  | optional,
              },
          PipelineOverride = {
                agent | definitions.contract.Agent | optional,
                containerOptions | definitions.contract.Container | optional,
                name | String | optional,
                pipeline | String | optional,
                sidecars
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Container
                  ])
                  | optional,
                stage | String | optional,
                step | definitions.contract.Step | optional,
                steps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Step
                  ])
                  | optional,
                type | String | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Volume
                  ])
                  | optional,
              },
          Pipelines = {
                "default" | definitions.contract.ParsedPipeline | optional,
                feature | definitions.contract.PipelineLifecycles | optional,
                overrides
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.PipelineOverride
                  ])
                  | optional,
                post | definitions.contract.PipelineLifecycle | optional,
                pullRequest
                  | predicates.contract_from_predicate
                  definitions.predicate.PipelineLifecycles
                  | optional,
                release | definitions.contract.PipelineLifecycles | optional,
              },
          PortworxVolumeSource = {
                fsType | String | optional,
                readOnly | Bool | optional,
                volumeID | String | optional,
              },
          Post = {
                actions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.PostAction
                  ])
                  | optional,
                condition | String | optional,
              },
          PostAction = {
                name | String | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | optional,
              },
          PreviewEnvironmentConfig = {
                disabled | Bool | optional,
                maximumInstances | std.number.Integer | optional,
              },
          ProjectConfig = {
                addons
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.AddonConfig
                  ])
                  | optional,
                buildPack | String | optional,
                buildPackGitRef | String | optional,
                buildPackGitURL | String | optional,
                chat
                  | predicates.contract_from_predicate
                  definitions.predicate.ChatConfig
                  | optional,
                dockerRegistryHost | String | optional,
                dockerRegistryOwner | String | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.EnvVar
                  ])
                  | optional,
                issueTracker
                  | predicates.contract_from_predicate
                  definitions.predicate.IssueTrackerConfig
                  | optional,
                noReleasePrepare | Bool | optional,
                pipelineConfig
                  | predicates.contract_from_predicate
                  definitions.predicate.PipelineConfig
                  | optional,
                previewEnvironments
                  | predicates.contract_from_predicate
                  definitions.predicate.PreviewEnvironmentConfig
                  | optional,
                wiki
                  | predicates.contract_from_predicate
                  definitions.predicate.WikiConfig
                  | optional,
              },
          ProjectedVolumeSource = {
                defaultMode | std.number.Integer | optional,
                sources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.VolumeProjection
                  ])
                  | optional,
              },
          Quantity = {  },
          QuobyteVolumeSource = {
                group | String | optional,
                readOnly | Bool | optional,
                registry | String | optional,
                tenant | String | optional,
                user | String | optional,
                volume | String | optional,
              },
          RBDVolumeSource = {
                fsType | String | optional,
                image | String | optional,
                keyring | String | optional,
                monitors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                pool | String | optional,
                readOnly | Bool | optional,
                secretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
                user | String | optional,
              },
          ResourceFieldSelector = {
                containerName | String | optional,
                divisor
                  | predicates.contract_from_predicate
                  definitions.predicate.Quantity
                  | optional,
                resource | String | optional,
              },
          RootOptions = {
                containerOptions
                  | predicates.contract_from_predicate
                  definitions.predicate.Container
                  | optional,
                distributeParallelAcrossNodes | Bool | optional,
                podLabels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | optional,
                retry | std.number.Integer | optional,
                sidecars
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Container
                  ])
                  | optional,
                timeout
                  | predicates.contract_from_predicate
                  definitions.predicate.Timeout
                  | optional,
                tolerations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Toleration
                  ])
                  | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Volume
                  ])
                  | optional,
              },
          ScaleIOVolumeSource = {
                fsType | String | optional,
                gateway | String | optional,
                protectionDomain | String | optional,
                readOnly | Bool | optional,
                secretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
                sslEnabled | Bool | optional,
                storageMode | String | optional,
                storagePool | String | optional,
                system | String | optional,
                volumeName | String | optional,
              },
          SecretKeySelector = {
                key | String | optional,
                name | String | optional,
                "optional" | Bool | optional,
              },
          SecretProjection = {
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KeyToPath
                  ])
                  | optional,
                name | String | optional,
                "optional" | Bool | optional,
              },
          SecretVolumeSource = {
                defaultMode | std.number.Integer | optional,
                items
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.KeyToPath
                  ])
                  | optional,
                "optional" | Bool | optional,
                secretName | String | optional,
              },
          ServiceAccountTokenProjection = {
                audience | String | optional,
                expirationSeconds | std.number.Integer | optional,
                path | String | optional,
              },
          Stage = {
                agent | definitions.contract.Agent | optional,
                dir | String | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.EnvVar
                  ])
                  | optional,
                environment
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.EnvVar
                  ])
                  | optional,
                name | String | optional,
                options
                  | predicates.contract_from_predicate
                  definitions.predicate.StageOptions
                  | optional,
                parallel
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Stage
                  ])
                  | optional,
                post
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Post
                  ])
                  | optional,
                stages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Stage
                  ])
                  | optional,
                steps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Step
                  ])
                  | optional,
              },
          StageOptions = {
                containerOptions | definitions.contract.Container | optional,
                distributeParallelAcrossNodes | Bool | optional,
                podLabels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | optional,
                retry | std.number.Integer | optional,
                sidecars
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Container
                  ])
                  | optional,
                stash
                  | predicates.contract_from_predicate
                  definitions.predicate.Stash
                  | optional,
                timeout | definitions.contract.Timeout | optional,
                tolerations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Toleration
                  ])
                  | optional,
                unstash
                  | predicates.contract_from_predicate
                  definitions.predicate.Unstash
                  | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Volume
                  ])
                  | optional,
                workspace | String | optional,
              },
          Stash = { files | String | optional, name | String | optional, },
          Step = {
                agent | definitions.contract.Agent | optional,
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                command | String | optional,
                comment | String | optional,
                container | String | optional,
                dir | String | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.EnvVar
                  ])
                  | optional,
                groovy | String | optional,
                image | String | optional,
                loop
                  | predicates.contract_from_predicate
                  definitions.predicate.Loop
                  | optional,
                name | String | optional,
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | optional,
                sh | String | optional,
                step | String | optional,
                steps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Step
                  ])
                  | optional,
                when | String | optional,
              },
          StorageOSVolumeSource = {
                fsType | String | optional,
                readOnly | Bool | optional,
                secretRef
                  | definitions.contract.LocalObjectReference
                  | optional,
                volumeName | String | optional,
                volumeNamespace | String | optional,
              },
          Timeout = {
                time | std.number.Integer | optional,
                unit | String | optional,
              },
          Toleration = {
                effect | String | optional,
                key | String | optional,
                operator | String | optional,
                tolerationSeconds | std.number.Integer | optional,
                value | String | optional,
              },
          Unstash = { dir | String | optional, name | String | optional, },
          Volume = {
                awsElasticBlockStore
                  | predicates.contract_from_predicate
                  definitions.predicate.AWSElasticBlockStoreVolumeSource
                  | optional,
                azureDisk
                  | predicates.contract_from_predicate
                  definitions.predicate.AzureDiskVolumeSource
                  | optional,
                azureFile
                  | predicates.contract_from_predicate
                  definitions.predicate.AzureFileVolumeSource
                  | optional,
                cephfs
                  | predicates.contract_from_predicate
                  definitions.predicate.CephFSVolumeSource
                  | optional,
                cinder
                  | predicates.contract_from_predicate
                  definitions.predicate.CinderVolumeSource
                  | optional,
                configMap
                  | predicates.contract_from_predicate
                  definitions.predicate.ConfigMapVolumeSource
                  | optional,
                csi
                  | predicates.contract_from_predicate
                  definitions.predicate.CSIVolumeSource
                  | optional,
                downwardAPI
                  | predicates.contract_from_predicate
                  definitions.predicate.DownwardAPIVolumeSource
                  | optional,
                emptyDir
                  | predicates.contract_from_predicate
                  definitions.predicate.EmptyDirVolumeSource
                  | optional,
                fc
                  | predicates.contract_from_predicate
                  definitions.predicate.FCVolumeSource
                  | optional,
                flexVolume
                  | predicates.contract_from_predicate
                  definitions.predicate.FlexVolumeSource
                  | optional,
                flocker
                  | predicates.contract_from_predicate
                  definitions.predicate.FlockerVolumeSource
                  | optional,
                gcePersistentDisk
                  | predicates.contract_from_predicate
                  definitions.predicate.GCEPersistentDiskVolumeSource
                  | optional,
                gitRepo
                  | predicates.contract_from_predicate
                  definitions.predicate.GitRepoVolumeSource
                  | optional,
                glusterfs
                  | predicates.contract_from_predicate
                  definitions.predicate.GlusterfsVolumeSource
                  | optional,
                hostPath
                  | predicates.contract_from_predicate
                  definitions.predicate.HostPathVolumeSource
                  | optional,
                iscsi
                  | predicates.contract_from_predicate
                  definitions.predicate.ISCSIVolumeSource
                  | optional,
                name | String | optional,
                nfs
                  | predicates.contract_from_predicate
                  definitions.predicate.NFSVolumeSource
                  | optional,
                persistentVolumeClaim
                  | predicates.contract_from_predicate
                  definitions.predicate.PersistentVolumeClaimVolumeSource
                  | optional,
                photonPersistentDisk
                  | predicates.contract_from_predicate
                  definitions.predicate.PhotonPersistentDiskVolumeSource
                  | optional,
                portworxVolume
                  | predicates.contract_from_predicate
                  definitions.predicate.PortworxVolumeSource
                  | optional,
                projected
                  | predicates.contract_from_predicate
                  definitions.predicate.ProjectedVolumeSource
                  | optional,
                quobyte
                  | predicates.contract_from_predicate
                  definitions.predicate.QuobyteVolumeSource
                  | optional,
                rbd
                  | predicates.contract_from_predicate
                  definitions.predicate.RBDVolumeSource
                  | optional,
                scaleIO
                  | predicates.contract_from_predicate
                  definitions.predicate.ScaleIOVolumeSource
                  | optional,
                secret
                  | predicates.contract_from_predicate
                  definitions.predicate.SecretVolumeSource
                  | optional,
                storageos
                  | predicates.contract_from_predicate
                  definitions.predicate.StorageOSVolumeSource
                  | optional,
                vsphereVolume
                  | predicates.contract_from_predicate
                  definitions.predicate.VsphereVirtualDiskVolumeSource
                  | optional,
              },
          VolumeProjection = {
                configMap
                  | predicates.contract_from_predicate
                  definitions.predicate.ConfigMapProjection
                  | optional,
                downwardAPI
                  | predicates.contract_from_predicate
                  definitions.predicate.DownwardAPIProjection
                  | optional,
                secret
                  | predicates.contract_from_predicate
                  definitions.predicate.SecretProjection
                  | optional,
                serviceAccountToken
                  | predicates.contract_from_predicate
                  definitions.predicate.ServiceAccountTokenProjection
                  | optional,
              },
          VsphereVirtualDiskVolumeSource = {
                fsType | String | optional,
                storagePolicyID | String | optional,
                storagePolicyName | String | optional,
                volumePath | String | optional,
              },
          WikiConfig = {
                kind | String | optional,
                space | String | optional,
                url | String | optional,
              },
        },
    predicate = {
          AWSElasticBlockStoreVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  partition = predicates.isType 'Integer,
                  readOnly = predicates.isType '"Bool",
                  volumeID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          AddonConfig = predicates.allOf
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
          Agent = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  container = predicates.isType '"String",
                  dir = predicates.isType '"String",
                  image = predicates.isType '"String",
                  label = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          AzureDiskVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cachingMode = predicates.isType '"String",
                  diskName = predicates.isType '"String",
                  diskURI = predicates.isType '"String",
                  fsType = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          AzureFileVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  readOnly = predicates.isType '"Bool",
                  secretName = predicates.isType '"String",
                  shareName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CSIVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  driver = predicates.isType '"String",
                  fsType = predicates.isType '"String",
                  nodePublishSecretRef =
                    definitions.predicate.LocalObjectReference,
                  readOnly = predicates.isType '"Bool",
                  volumeAttributes = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          CephFSVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  monitors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  path = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretFile = predicates.isType '"String",
                  secretRef = definitions.predicate.LocalObjectReference,
                  user = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ChatConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  developerChannel = predicates.isType '"String",
                  kind = predicates.isType '"String",
                  url = predicates.isType '"String",
                  userChannel = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CinderVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretRef = definitions.predicate.LocalObjectReference,
                  volumeID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ConfigMapKeySelector = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ConfigMapProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.KeyToPath
                      ],
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ConfigMapVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultMode = predicates.isType 'Integer,
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.KeyToPath
                      ],
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          Container = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true predicates.always
              ],
          DownwardAPIProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DownwardAPIVolumeFile
                      ],
                }
                {  }
                false
                predicates.never
              ],
          DownwardAPIVolumeFile = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fieldRef = definitions.predicate.ObjectFieldSelector,
                  mode = predicates.isType 'Integer,
                  path = predicates.isType '"String",
                  resourceFieldRef =
                    definitions.predicate.ResourceFieldSelector,
                }
                {  }
                false
                predicates.never
              ],
          DownwardAPIVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultMode = predicates.isType 'Integer,
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DownwardAPIVolumeFile
                      ],
                }
                {  }
                false
                predicates.never
              ],
          EmptyDirVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  medium = predicates.isType '"String",
                  sizeLimit = definitions.predicate.Quantity,
                }
                {  }
                false
                predicates.never
              ],
          EnvVar = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  value = predicates.isType '"String",
                  valueFrom = definitions.predicate.EnvVarSource,
                }
                {  }
                false
                predicates.never
              ],
          EnvVarSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configMapKeyRef = definitions.predicate.ConfigMapKeySelector,
                  fieldRef = definitions.predicate.ObjectFieldSelector,
                  resourceFieldRef =
                    definitions.predicate.ResourceFieldSelector,
                  secretKeyRef = definitions.predicate.SecretKeySelector,
                }
                {  }
                false
                predicates.never
              ],
          FCVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  lun = predicates.isType 'Integer,
                  readOnly = predicates.isType '"Bool",
                  targetWWNs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  wwids = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FlexVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  driver = predicates.isType '"String",
                  fsType = predicates.isType '"String",
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  readOnly = predicates.isType '"Bool",
                  secretRef = definitions.predicate.LocalObjectReference,
                }
                {  }
                false
                predicates.never
              ],
          FlockerVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  datasetName = predicates.isType '"String",
                  datasetUUID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GCEPersistentDiskVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  partition = predicates.isType 'Integer,
                  pdName = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          GitRepoVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  directory = predicates.isType '"String",
                  repository = predicates.isType '"String",
                  revision = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GlusterfsVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  endpoints = predicates.isType '"String",
                  path = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          HostPathVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ISCSIVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  chapAuthDiscovery = predicates.isType '"Bool",
                  chapAuthSession = predicates.isType '"Bool",
                  fsType = predicates.isType '"String",
                  initiatorName = predicates.isType '"String",
                  iqn = predicates.isType '"String",
                  iscsiInterface = predicates.isType '"String",
                  lun = predicates.isType 'Integer,
                  portals = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  readOnly = predicates.isType '"Bool",
                  secretRef = definitions.predicate.LocalObjectReference,
                  targetPortal = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          IssueTrackerConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  kind = predicates.isType '"String",
                  project = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          KeyToPath = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  mode = predicates.isType 'Integer,
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          LocalObjectReference = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { name = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          Loop = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  steps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Step
                      ],
                  values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  variable = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          NFSVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  server = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ObjectFieldSelector = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  fieldPath = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ParsedPipeline = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  agent = definitions.predicate.Agent,
                  dir = predicates.isType '"String",
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.EnvVar
                      ],
                  environment = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.EnvVar
                      ],
                  options = definitions.predicate.RootOptions,
                  post = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Post
                      ],
                  stages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Stage
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PersistentVolumeClaimVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  claimName = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          PhotonPersistentDiskVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  pdID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PipelineConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  agent = definitions.predicate.Agent,
                  containerOptions = definitions.predicate.Container,
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.EnvVar
                      ],
                  environment = predicates.isType '"String",
                  extends = definitions.predicate.PipelineExtends,
                  pipelines = definitions.predicate.Pipelines,
                }
                {  }
                false
                predicates.never
              ],
          PipelineExtends = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  file = predicates.isType '"String",
                  "import" = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PipelineLifecycle = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  preSteps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Step
                      ],
                  replace = predicates.isType '"Bool",
                  steps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Step
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PipelineLifecycles = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  build = definitions.predicate.PipelineLifecycle,
                  pipeline = definitions.predicate.ParsedPipeline,
                  postBuild = definitions.predicate.PipelineLifecycle,
                  preBuild = definitions.predicate.PipelineLifecycle,
                  promote = definitions.predicate.PipelineLifecycle,
                  setVersion = definitions.predicate.PipelineLifecycle,
                  setup = definitions.predicate.PipelineLifecycle,
                }
                {  }
                false
                predicates.never
              ],
          PipelineOverride = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  agent = definitions.predicate.Agent,
                  containerOptions = definitions.predicate.Container,
                  name = predicates.isType '"String",
                  pipeline = predicates.isType '"String",
                  sidecars = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Container
                      ],
                  stage = predicates.isType '"String",
                  step = definitions.predicate.Step,
                  steps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Step
                      ],
                  type = predicates.isType '"String",
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Volume
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Pipelines = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "default" = definitions.predicate.ParsedPipeline,
                  feature = definitions.predicate.PipelineLifecycles,
                  overrides = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.PipelineOverride
                      ],
                  post = definitions.predicate.PipelineLifecycle,
                  pullRequest = definitions.predicate.PipelineLifecycles,
                  release = definitions.predicate.PipelineLifecycles,
                }
                {  }
                false
                predicates.never
              ],
          PortworxVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  volumeID = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Post = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  actions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.PostAction
                      ],
                  condition = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PostAction = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PreviewEnvironmentConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  disabled = predicates.isType '"Bool",
                  maximumInstances = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          ProjectConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addons = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.AddonConfig
                      ],
                  buildPack = predicates.isType '"String",
                  buildPackGitRef = predicates.isType '"String",
                  buildPackGitURL = predicates.isType '"String",
                  chat = definitions.predicate.ChatConfig,
                  dockerRegistryHost = predicates.isType '"String",
                  dockerRegistryOwner = predicates.isType '"String",
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.EnvVar
                      ],
                  issueTracker = definitions.predicate.IssueTrackerConfig,
                  noReleasePrepare = predicates.isType '"Bool",
                  pipelineConfig = definitions.predicate.PipelineConfig,
                  previewEnvironments =
                    definitions.predicate.PreviewEnvironmentConfig,
                  wiki = definitions.predicate.WikiConfig,
                }
                {  }
                false
                predicates.never
              ],
          ProjectedVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultMode = predicates.isType 'Integer,
                  sources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.VolumeProjection
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Quantity = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } false predicates.never
              ],
          QuobyteVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  group = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  registry = predicates.isType '"String",
                  tenant = predicates.isType '"String",
                  user = predicates.isType '"String",
                  volume = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RBDVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  image = predicates.isType '"String",
                  keyring = predicates.isType '"String",
                  monitors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  pool = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretRef = definitions.predicate.LocalObjectReference,
                  user = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ResourceFieldSelector = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  containerName = predicates.isType '"String",
                  divisor = definitions.predicate.Quantity,
                  resource = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RootOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  containerOptions = definitions.predicate.Container,
                  distributeParallelAcrossNodes = predicates.isType '"Bool",
                  podLabels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  retry = predicates.isType 'Integer,
                  sidecars = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Container
                      ],
                  timeout = definitions.predicate.Timeout,
                  tolerations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Toleration
                      ],
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Volume
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ScaleIOVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  gateway = predicates.isType '"String",
                  protectionDomain = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretRef = definitions.predicate.LocalObjectReference,
                  sslEnabled = predicates.isType '"Bool",
                  storageMode = predicates.isType '"String",
                  storagePool = predicates.isType '"String",
                  system = predicates.isType '"String",
                  volumeName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SecretKeySelector = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  key = predicates.isType '"String",
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          SecretProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.KeyToPath
                      ],
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          SecretVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultMode = predicates.isType 'Integer,
                  items = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.KeyToPath
                      ],
                  "optional" = predicates.isType '"Bool",
                  secretName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ServiceAccountTokenProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  audience = predicates.isType '"String",
                  expirationSeconds = predicates.isType 'Integer,
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Stage = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  agent = definitions.predicate.Agent,
                  dir = predicates.isType '"String",
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.EnvVar
                      ],
                  environment = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.EnvVar
                      ],
                  name = predicates.isType '"String",
                  options = definitions.predicate.StageOptions,
                  parallel = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Stage
                      ],
                  post = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Post
                      ],
                  stages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Stage
                      ],
                  steps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Step
                      ],
                }
                {  }
                false
                predicates.never
              ],
          StageOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  containerOptions = definitions.predicate.Container,
                  distributeParallelAcrossNodes = predicates.isType '"Bool",
                  podLabels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  retry = predicates.isType 'Integer,
                  sidecars = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Container
                      ],
                  stash = definitions.predicate.Stash,
                  timeout = definitions.predicate.Timeout,
                  tolerations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Toleration
                      ],
                  unstash = definitions.predicate.Unstash,
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Volume
                      ],
                  workspace = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Stash = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  files = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Step = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  agent = definitions.predicate.Agent,
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  command = predicates.isType '"String",
                  comment = predicates.isType '"String",
                  container = predicates.isType '"String",
                  dir = predicates.isType '"String",
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.EnvVar
                      ],
                  groovy = predicates.isType '"String",
                  image = predicates.isType '"String",
                  loop = definitions.predicate.Loop,
                  name = predicates.isType '"String",
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  sh = predicates.isType '"String",
                  step = predicates.isType '"String",
                  steps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Step
                      ],
                  when = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          StorageOSVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  readOnly = predicates.isType '"Bool",
                  secretRef = definitions.predicate.LocalObjectReference,
                  volumeName = predicates.isType '"String",
                  volumeNamespace = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Timeout = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  time = predicates.isType 'Integer,
                  unit = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Toleration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  effect = predicates.isType '"String",
                  key = predicates.isType '"String",
                  operator = predicates.isType '"String",
                  tolerationSeconds = predicates.isType 'Integer,
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Unstash = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  dir = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Volume = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  awsElasticBlockStore =
                    definitions.predicate.AWSElasticBlockStoreVolumeSource,
                  azureDisk = definitions.predicate.AzureDiskVolumeSource,
                  azureFile = definitions.predicate.AzureFileVolumeSource,
                  cephfs = definitions.predicate.CephFSVolumeSource,
                  cinder = definitions.predicate.CinderVolumeSource,
                  configMap = definitions.predicate.ConfigMapVolumeSource,
                  csi = definitions.predicate.CSIVolumeSource,
                  downwardAPI = definitions.predicate.DownwardAPIVolumeSource,
                  emptyDir = definitions.predicate.EmptyDirVolumeSource,
                  fc = definitions.predicate.FCVolumeSource,
                  flexVolume = definitions.predicate.FlexVolumeSource,
                  flocker = definitions.predicate.FlockerVolumeSource,
                  gcePersistentDisk =
                    definitions.predicate.GCEPersistentDiskVolumeSource,
                  gitRepo = definitions.predicate.GitRepoVolumeSource,
                  glusterfs = definitions.predicate.GlusterfsVolumeSource,
                  hostPath = definitions.predicate.HostPathVolumeSource,
                  iscsi = definitions.predicate.ISCSIVolumeSource,
                  name = predicates.isType '"String",
                  nfs = definitions.predicate.NFSVolumeSource,
                  persistentVolumeClaim =
                    definitions.predicate.PersistentVolumeClaimVolumeSource,
                  photonPersistentDisk =
                    definitions.predicate.PhotonPersistentDiskVolumeSource,
                  portworxVolume = definitions.predicate.PortworxVolumeSource,
                  projected = definitions.predicate.ProjectedVolumeSource,
                  quobyte = definitions.predicate.QuobyteVolumeSource,
                  rbd = definitions.predicate.RBDVolumeSource,
                  scaleIO = definitions.predicate.ScaleIOVolumeSource,
                  secret = definitions.predicate.SecretVolumeSource,
                  storageos = definitions.predicate.StorageOSVolumeSource,
                  vsphereVolume =
                    definitions.predicate.VsphereVirtualDiskVolumeSource,
                }
                {  }
                false
                predicates.never
              ],
          VolumeProjection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  configMap = definitions.predicate.ConfigMapProjection,
                  downwardAPI = definitions.predicate.DownwardAPIProjection,
                  secret = definitions.predicate.SecretProjection,
                  serviceAccountToken =
                    definitions.predicate.ServiceAccountTokenProjection,
                }
                {  }
                false
                predicates.never
              ],
          VsphereVirtualDiskVolumeSource = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fsType = predicates.isType '"String",
                  storagePolicyID = predicates.isType '"String",
                  storagePolicyName = predicates.isType '"String",
                  volumePath = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          WikiConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  kind = predicates.isType '"String",
                  space = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

definitions.contract.ProjectConfig