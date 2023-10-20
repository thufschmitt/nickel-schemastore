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
          identifier
            | doc m%"
            Unique identifier for this mod.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.identifier,
          install_to
            | doc m%"
            Where file should be installed to. As of v1.2, GameData may take a path
            "%
            = predicates.contract_from_predicate
              definitions.predicate.install_to,
          ksp_version
            | doc m%"
            A game version
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ksp_version,
          license
            | doc m%"
            A license.
            "%
            = predicates.contract_from_predicate definitions.predicate.license,
          licenses
            | doc m%"
            A license, or array of licenses
            "%
            = predicates.contract_from_predicate definitions.predicate.licenses,
          one_or_more_strings
            | doc m%"
            One or more strings
            "%
            = predicates.contract_from_predicate
              definitions.predicate.one_or_more_strings,
          redistributable_license
            | doc m%"
            A license that grants us the right to redistribute.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.redistributable_license,
          relationship
            | doc m%"
            A relationship to a list of mods
            "%
            = predicates.contract_from_predicate
              definitions.predicate.relationship,
          version
            | doc m%"
            A version string
            "%
            = String,
        },
    predicate = {
          identifier
            | doc m%"
            Unique identifier for this mod.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[A-Za-z0-9][A-Za-z0-9-]+$"
              ],
          install_to
            | doc m%"
            Where file should be installed to. As of v1.2, GameData may take a path
            "%
            = predicates.anyOf
              [
                predicates.enum
                [ "GameData", "Ships", "GameRoot", "Tutorial", "Scenarios" ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^GameData/"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^Ships/(SPH|VAB|Script)$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^Ships/@thumbs/(SPH|VAB)$"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^Missions"
                ],
                predicates.enum [ "GameData/Mods" ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^GameData/Mods/"
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern "^BepInEx/plugins$"
                ]
              ],
          ksp_version
            | doc m%"
            A game version
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(any|[0-9]+(\\.[0-9]+(\\.[0-9]+)?)?)$"
              ],
          license
            | doc m%"
            A license.
            "%
            = predicates.enum
              [
                "public-domain",
                "AFL-3.0",
                "AGPL-3.0",
                "Apache",
                "Apache-1.0",
                "Apache-2.0",
                "APSL-2.0",
                "Artistic",
                "Artistic-1.0",
                "Artistic-2.0",
                "BSD-2-clause",
                "BSD-3-clause",
                "BSD-4-clause",
                "ISC",
                "CC-BY",
                "CC-BY-1.0",
                "CC-BY-2.0",
                "CC-BY-2.5",
                "CC-BY-3.0",
                "CC-BY-4.0",
                "CC-BY-SA",
                "CC-BY-SA-1.0",
                "CC-BY-SA-2.0",
                "CC-BY-SA-2.5",
                "CC-BY-SA-3.0",
                "CC-BY-SA-4.0",
                "CC-BY-NC",
                "CC-BY-NC-1.0",
                "CC-BY-NC-2.0",
                "CC-BY-NC-2.5",
                "CC-BY-NC-3.0",
                "CC-BY-NC-4.0",
                "CC-BY-NC-SA",
                "CC-BY-NC-SA-1.0",
                "CC-BY-NC-SA-2.0",
                "CC-BY-NC-SA-2.5",
                "CC-BY-NC-SA-3.0",
                "CC-BY-NC-SA-4.0",
                "CC-BY-NC-ND",
                "CC-BY-NC-ND-1.0",
                "CC-BY-NC-ND-2.0",
                "CC-BY-NC-ND-2.5",
                "CC-BY-NC-ND-3.0",
                "CC-BY-NC-ND-4.0",
                "CC-BY-ND",
                "CC-BY-ND-1.0",
                "CC-BY-ND-2.0",
                "CC-BY-ND-2.5",
                "CC-BY-ND-3.0",
                "CC-BY-ND-4.0",
                "CC0",
                "CDDL",
                "CPL",
                "EFL-1.0",
                "EFL-2.0",
                "Expat",
                "MIT",
                "GPL-1.0",
                "GPL-2.0",
                "GPL-3.0",
                "LGPL-2.0",
                "LGPL-2.1",
                "LGPL-3.0",
                "GFDL-1.0",
                "GFDL-1.1",
                "GFDL-1.2",
                "GFDL-1.3",
                "GFDL-NIV-1.0",
                "GFDL-NIV-1.1",
                "GFDL-NIV-1.2",
                "GFDL-NIV-1.3",
                "LPPL-1.0",
                "LPPL-1.1",
                "LPPL-1.2",
                "LPPL-1.3c",
                "MPL-1.0",
                "MPL-1.1",
                "MPL-2.0",
                "Ms-PL",
                "Ms-RL",
                "Perl",
                "Python-2.0",
                "QPL-1.0",
                "Unlicense",
                "W3C",
                "WTFPL",
                "Zlib",
                "Zope",
                "open-source",
                "restricted",
                "unrestricted",
                "unknown"
              ],
          licenses
            | doc m%"
            A license, or array of licenses
            "%
            = predicates.anyOf
              [
                definitions.predicate.license,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.license,
                  predicates.arrays.uniqueItems
                ]
              ],
          one_or_more_strings
            | doc m%"
            One or more strings
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String"),
                  predicates.arrays.uniqueItems
                ]
              ],
          redistributable_license
            | doc m%"
            A license that grants us the right to redistribute.
            "%
            = predicates.enum
              [
                "public-domain",
                "Apache",
                "Apache-1.0",
                "Apache-2.0",
                "Artistic",
                "Artistic-1.0",
                "Artistic-2.0",
                "BSD-2-clause",
                "BSD-3-clause",
                "BSD-4-clause",
                "ISC",
                "CC-BY",
                "CC-BY-1.0",
                "CC-BY-2.0",
                "CC-BY-2.5",
                "CC-BY-3.0",
                "CC-BY-4.0",
                "CC-BY-SA",
                "CC-BY-SA-1.0",
                "CC-BY-SA-2.0",
                "CC-BY-SA-2.5",
                "CC-BY-SA-3.0",
                "CC-BY-SA-4.0",
                "CC-BY-NC",
                "CC-BY-NC-1.0",
                "CC-BY-NC-2.0",
                "CC-BY-NC-2.5",
                "CC-BY-NC-3.0",
                "CC-BY-NC-4.0",
                "CC-BY-NC-SA",
                "CC-BY-NC-SA-1.0",
                "CC-BY-NC-SA-2.0",
                "CC-BY-NC-SA-2.5",
                "CC-BY-NC-SA-3.0",
                "CC-BY-NC-SA-4.0",
                "CC-BY-NC-ND",
                "CC-BY-NC-ND-1.0",
                "CC-BY-NC-ND-2.0",
                "CC-BY-NC-ND-2.5",
                "CC-BY-NC-ND-3.0",
                "CC-BY-NC-ND-4.0",
                "CC-BY-ND",
                "CC-BY-ND-1.0",
                "CC-BY-ND-2.0",
                "CC-BY-ND-2.5",
                "CC-BY-ND-3.0",
                "CC-BY-ND-4.0",
                "CC0",
                "CDDL",
                "CPL",
                "EFL-1.0",
                "EFL-2.0",
                "Expat",
                "MIT",
                "GPL-1.0",
                "GPL-2.0",
                "GPL-3.0",
                "LGPL-2.0",
                "LGPL-2.1",
                "LGPL-3.0",
                "GFDL-1.0",
                "GFDL-1.1",
                "GFDL-1.2",
                "GFDL-1.3",
                "GFDL-NIV-1.0",
                "GFDL-NIV-1.1",
                "GFDL-NIV-1.2",
                "GFDL-NIV-1.3",
                "LPPL-1.0",
                "LPPL-1.1",
                "LPPL-1.2",
                "LPPL-1.3c",
                "MPL-1.1",
                "MPL-2.0",
                "Perl",
                "Python-2.0",
                "QPL-1.0",
                "W3C",
                "Zlib",
                "Zope",
                "WTFPL",
                "Unlicense",
                "open-source",
                "unrestricted"
              ],
          relationship
            | doc m%"
            A relationship to a list of mods
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "name" ],
                    predicates.records.record
                    {
                      choice_help_text = predicates.isType '"String",
                      max_version = definitions.predicate.version,
                      min_version = definitions.predicate.version,
                      name = definitions.predicate.identifier,
                      suppress_recommendations = predicates.isType '"Bool",
                      version = definitions.predicate.version,
                    }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "any_of" ],
                    predicates.records.record
                    {
                      any_of = definitions.predicate.relationship,
                      choice_help_text = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ]
                ])
              ],
          version
            | doc m%"
            A version string
            "%
            = predicates.isType '"String",
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.oneOf
  [
    predicates.allOf
    [
      predicates.records.required [ "download" ],
      predicates.records.record {  } {  } true predicates.always
    ],
    predicates.allOf
    [
      predicates.not
      (predicates.allOf
      [
        predicates.records.required [ "download" ],
        predicates.records.record {  } {  } true predicates.always
      ]),
      predicates.records.required [ "kind" ],
      predicates.records.record
      { kind = predicates.enum [ "metapackage", "dlc" ], }
      {  }
      true
      predicates.always
    ]
  ],
  predicates.records.required
  [
    "abstract",
    "author",
    "identifier",
    "license",
    "name",
    "spec_version",
    "version"
  ],
  predicates.records.record
  {
    abstract = predicates.isType '"String",
    author = predicates.oneOf
        [
          predicates.isType '"String",
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf (predicates.isType '"String"),
            predicates.arrays.uniqueItems
          ]
        ],
    comment = predicates.isType '"String",
    conflicts = definitions.predicate.relationship,
    depends = definitions.predicate.relationship,
    description = predicates.isType '"String",
    download = predicates.oneOf
        [
          predicates.isType '"String",
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf (predicates.isType '"String"),
            predicates.arrays.uniqueItems
          ]
        ],
    download_content_type = predicates.isType '"String",
    download_hash = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            sha1 = predicates.isType '"String",
            sha256 = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    download_size = predicates.isType 'Integer,
    identifier = definitions.predicate.identifier,
    install = predicates.allOf
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
                predicates.records.required [ "file" ],
                predicates.records.record {  } {  } true predicates.always
              ],
              predicates.allOf
              [
                predicates.records.required [ "find" ],
                predicates.records.record {  } {  } true predicates.always
              ],
              predicates.allOf
              [
                predicates.records.required [ "find_regexp" ],
                predicates.records.record {  } {  } true predicates.always
              ]
            ],
            predicates.not
            (predicates.anyOf
            [
              predicates.allOf
              [
                predicates.records.required [ "filter", "include_only" ],
                predicates.records.record {  } {  } true predicates.always
              ],
              predicates.allOf
              [
                predicates.records.required [ "filter", "include_only_regexp" ],
                predicates.records.record {  } {  } true predicates.always
              ],
              predicates.allOf
              [
                predicates.records.required [ "filter_regexp", "include_only" ],
                predicates.records.record {  } {  } true predicates.always
              ],
              predicates.allOf
              [
                predicates.records.required
                [ "filter_regexp", "include_only_regexp" ],
                predicates.records.record {  } {  } true predicates.always
              ]
            ]),
            predicates.records.required [ "install_to" ],
            predicates.records.record
            {
              as = predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[^\\\\/]+$"
                  ],
              file = predicates.isType '"String",
              filter = definitions.predicate.one_or_more_strings,
              filter_regexp = definitions.predicate.one_or_more_strings,
              find = predicates.isType '"String",
              find_matches_files = predicates.isType '"Bool",
              find_regexp = predicates.isType '"String",
              include_only = definitions.predicate.one_or_more_strings,
              include_only_regexp = definitions.predicate.one_or_more_strings,
              install_to = definitions.predicate.install_to,
            }
            {  }
            true
            predicates.always
          ])
        ],
    install_size = predicates.isType 'Integer,
    kind = predicates.enum [ "package", "metapackage", "dlc" ],
    ksp_version = definitions.predicate.ksp_version,
    ksp_version_max = definitions.predicate.ksp_version,
    ksp_version_min = definitions.predicate.ksp_version,
    ksp_version_strict = predicates.isType '"Bool",
    license = definitions.predicate.licenses,
    localizations = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String"),
          predicates.arrays.uniqueItems
        ],
    name = predicates.isType '"String",
    provides = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.identifier,
          predicates.arrays.uniqueItems
        ],
    recommends = definitions.predicate.relationship,
    release_date = predicates.isType '"String",
    release_status = predicates.enum [ "stable", "testing", "development" ],
    replaced_by = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.required [ "name" ],
          predicates.records.record
          {
            min_version = definitions.predicate.version,
            name = definitions.predicate.identifier,
            version = definitions.predicate.version,
          }
          {  }
          true
          predicates.always
        ],
    resources = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            bugtracker = predicates.isType '"String",
            ci = predicates.isType '"String",
            curse = predicates.isType '"String",
            homepage = predicates.isType '"String",
            license = predicates.isType '"String",
            manual = predicates.isType '"String",
            metanetkan = predicates.isType '"String",
            remote-avc = predicates.isType '"String",
            remote-swinfo = predicates.isType '"String",
            repository = predicates.isType '"String",
            spacedock = predicates.isType '"String",
            steamstore = predicates.isType '"String",
            store = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
    spec_version = predicates.oneOf
        [
          predicates.allOf
          [
            predicates.isType 'Integer,
            predicates.numbers.maximum 1,
            predicates.numbers.minimum 1
          ],
          predicates.allOf
          [
            predicates.isType '"String",
            predicates.strings.pattern "^v[0-9]+\\.[0-9]+$"
          ]
        ],
    suggests = definitions.predicate.relationship,
    supports = definitions.predicate.relationship,
    tags = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType '"String",
            predicates.strings.pattern "^[a-z0-9-]+$"
          ])
        ],
    version = definitions.predicate.version,
  }
  {  }
  true
  predicates.always
])