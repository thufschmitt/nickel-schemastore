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
          BuildSpec
            | doc m%"
            BuildSpec
            "%
            = {
                buildEnvs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Env
                  ])
                  | doc m%"
                  Build Env variables to be set
                  "%
                  | optional,
                builder
                  | std.enum.TagOrString
                  | [| 's2i, 'pack |]
                  | doc m%"
                  Builder is the name of the subsystem that will complete the underlying
                  build (pack, s2i, etc)
                  "%
                  | optional,
                builderImages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  BuilderImages define optional explicit builder images to use by
                  builder implementations in leau of the in-code defaults.  They key
                  is the builder's short name.  For example:
                  builderImages:
                    pack: example.com/user/my-pack-node-builder
                    s2i: example.com/user/my-s2i-node-builder
                  "%
                  | optional,
                buildpacks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Optional list of buildpacks to use when building the function
                  "%
                  | optional,
                git
                  | predicates.contract_from_predicate definitions.predicate.Git
                  | doc m%"
                  Git stores information about an optionally associated git repository.
                  "%
                  | optional,
                pvcSize
                  | String
                  | doc m%"
                  PVCSize specifies the size of persistent volume claim used to store function
                  when using deployment and remote build process (only relevant when Remote is true).
                  "%
                  | optional,
              },
          DeploySpec
            | doc m%"
            DeploySpec
            "%
            = {
                annotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Map containing user-supplied annotations
                  Example: { "division": "finance" }
                  "%
                  | optional,
                healthEndpoints
                  | predicates.contract_from_predicate
                  definitions.predicate.HealthEndpoints
                  | doc m%"
                  Health endpoints specified by the language pack
                  "%
                  | optional,
                labels
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Label
                  ])
                  | doc m%"
                  Map of user-supplied labels
                  "%
                  | optional,
                namespace
                  | String
                  | doc m%"
                  Namespace into which the function is deployed on supported platforms.
                  "%
                  | optional,
                options
                  | predicates.contract_from_predicate
                  definitions.predicate.Options
                  | doc m%"
                  Options to be set on deployed function (scaling, etc.)
                  "%
                  | optional,
                remote
                  | Bool
                  | doc m%"
                  Remote indicates the deployment (and possibly build) process are to
                  be triggered in a remote environment rather than run locally.
                  "%
                  | optional,
                serviceAccountName
                  | String
                  | doc m%"
                  ServiceAccountName is the name of the service account used for the
                  function pod. The service account must exist in the namespace to
                  succeed.
                  More info: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
                  "%
                  | optional,
              },
          EmptyDir = {
                medium
                  | String
                  | doc m%"
                  medium represents what type of storage medium should back this directory.
                  The default is "" which means to use the node's default medium.
                  Must be an empty string (default) or Memory.
                  More info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir
                  "%
                  | optional,
                sizeLimit
                  | String
                  | doc m%"
                  sizeLimit is the total amount of local storage required for this EmptyDir volume.
                  The size limit is also applicable for memory medium.
                  The maximum usage on memory medium EmptyDir would be the minimum value between
                  the SizeLimit specified here and the sum of memory limits of all containers in a pod.
                  The default is nil which means that the limit is undefined.
                  More info: http://kubernetes.io/docs/user-guide/volumes#emptydir
                  "%
                  | optional,
              },
          Env = {
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[-._a-zA-Z][-._a-zA-Z0-9]*$"
                  ])
                  | optional,
                value | String | optional,
              },
          Function
            | doc m%"
            Function
            "%
            = {
                build
                  | predicates.contract_from_predicate
                  definitions.predicate.BuildSpec
                  | doc m%"
                  Build defines the build properties for a function
                  "%
                  | optional,
                created
                  | String
                  | doc m%"
                  Created time is the moment that creation was successfully completed
                  according to the client which is in charge of what constitutes being
                  fully "Created" (aka initialized)
                  "%,
                deploy
                  | predicates.contract_from_predicate
                  definitions.predicate.DeploySpec
                  | doc m%"
                  Deploy defines the deployment properties for a function
                  "%
                  | optional,
                domain
                  | String
                  | doc m%"
                  Domain of the function optionally specifies the domain to use as the
                  route of the function. By default the cluster's default will be used.
                  Note that the value defined here must be one which the cluster is
                  configured to recognize, or this will have no effect and the cluster
                  default will be applied.  This value shuld therefore ideally be
                  validated by the client.
                  "%
                  | optional,
                image
                  | String
                  | doc m%"
                  Image is the full OCI image tag in form:
                    [registry]/[namespace]/[name]:[tag]
                  example:
                    quay.io/alice/my.function.name
                  Registry is optional and is defaulted to DefaultRegistry
                  example:
                    alice/my.function.name
                  If Image is provided, it overrides the default of concatenating
                  "Registry+Name:latest" to derive the Image.
                  "%
                  | optional,
                imageDigest
                  | String
                  | doc m%"
                  ImageDigest is the SHA256 hash of the latest image that has been built
                  "%
                  | optional,
                invoke
                  | String
                  | doc m%"
                  Invoke defines hints for use when invoking this function.
                  See Client.Invoke for usage.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^[a-z0-9]([-a-z0-9]*[a-z0-9])?$"
                  ])
                  | doc m%"
                  Name of the function.
                  "%
                  | optional,
                registry
                  | String
                  | doc m%"
                  Registry at which to store interstitial containers, in the form
                  [registry]/[user].
                  "%
                  | optional,
                run
                  | predicates.contract_from_predicate
                  definitions.predicate.RunSpec
                  | doc m%"
                  Run defines the runtime properties for a function
                  "%
                  | optional,
                runtime
                  | String
                  | doc m%"
                  Runtime is the language plus context.  nodejs|go|quarkus|rust etc.
                  "%
                  | optional,
                specVersion
                  | String
                  | doc m%"
                  SpecVersion at which this function is known to be compatible.
                  More specifically, it is the highest migration which has been applied.
                  For details see the .Migrated() and .Migrate() methods.
                  "%,
              },
          Git = {
                contextDir | String | optional,
                revision | String | optional,
                url | String | optional,
              },
          HealthEndpoints
            | doc m%"
            HealthEndpoints specify the liveness and readiness endpoints for a Runtime
            "%
            = { liveness | String | optional, readiness | String | optional, },
          Label = {
                key
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*\\/)?([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]$"
                  ])
                  | doc m%"
                  Key consist of optional prefix part (ended by '/') and name part
                  Prefix part validation pattern: [a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*
                  Name part validation pattern: ([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]
                  "%,
                value
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                  ])
                  | optional,
              },
          Options = {
                resources
                  | predicates.contract_from_predicate
                  definitions.predicate.ResourcesOptions
                  | optional,
                scale
                  | predicates.contract_from_predicate
                  definitions.predicate.ScaleOptions
                  | optional,
              },
          PersistentVolumeClaim = {
                claimName
                  | String
                  | doc m%"
                  claimName is the name of a PersistentVolumeClaim in the same namespace as the pod using this volume.
                  More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims
                  "%
                  | optional,
                readOnly
                  | Bool
                  | doc m%"
                  readOnly Will force the ReadOnly setting in VolumeMounts.
                  Default false.
                  "%
                  | optional,
              },
          ResourcesLimitsOptions = {
                concurrency
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | optional,
                cpu
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^([+-]?[0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$"
                  ])
                  | optional,
                memory
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^([+-]?[0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$"
                  ])
                  | optional,
              },
          ResourcesOptions = {
                limits
                  | predicates.contract_from_predicate
                  definitions.predicate.ResourcesLimitsOptions
                  | optional,
                requests
                  | predicates.contract_from_predicate
                  definitions.predicate.ResourcesRequestsOptions
                  | optional,
              },
          ResourcesRequestsOptions = {
                cpu
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^([+-]?[0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$"
                  ])
                  | optional,
                memory
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^([+-]?[0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$"
                  ])
                  | optional,
              },
          RunSpec
            | doc m%"
            RunSpec
            "%
            = {
                envs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Env
                  ])
                  | doc m%"
                  Env variables to be set
                  "%
                  | optional,
                startTimeout
                  | std.number.Integer
                  | doc m%"
                  StartTimeout specifies that this function should have a custom timeout
                  when starting. This setting is currently respected by the host runner,
                  with containerized docker runner and deployed Knative service integration
                  in development.
                  "%
                  | optional,
                volumes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Volume
                  ])
                  | doc m%"
                  List of volumes to be mounted to the function
                  "%
                  | optional,
              },
          ScaleOptions = {
                max
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | optional,
                metric
                  | std.enum.TagOrString
                  | [| 'rps, 'concurrency |]
                  | optional,
                min
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | optional,
                target
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | optional,
                utilization
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 100,
                    predicates.numbers.minimum 1
                  ])
                  | optional,
              },
          Volume = predicates.contract_from_predicate
              definitions.predicate.Volume,
        },
    predicate = {
          BuildSpec
            | doc m%"
            BuildSpec
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  buildEnvs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Env
                      ],
                  builder = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "pack", "s2i" ]
                      ],
                  builderImages = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  buildpacks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  git = definitions.predicate.Git,
                  pvcSize = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          DeploySpec
            | doc m%"
            DeploySpec
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  healthEndpoints = definitions.predicate.HealthEndpoints,
                  labels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Label
                      ],
                  namespace = predicates.isType '"String",
                  options = definitions.predicate.Options,
                  remote = predicates.isType '"Bool",
                  serviceAccountName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          EmptyDir = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  medium = predicates.isType '"String",
                  sizeLimit = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Env = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[-._a-zA-Z][-._a-zA-Z0-9]*$"
                      ],
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Function
            | doc m%"
            Function
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "created", "specVersion" ],
                predicates.records.record
                {
                  build = definitions.predicate.BuildSpec,
                  created = predicates.isType '"String",
                  deploy = definitions.predicate.DeploySpec,
                  domain = predicates.isType '"String",
                  image = predicates.isType '"String",
                  imageDigest = predicates.isType '"String",
                  invoke = predicates.isType '"String",
                  name = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[a-z0-9]([-a-z0-9]*[a-z0-9])?$"
                      ],
                  registry = predicates.isType '"String",
                  run = definitions.predicate.RunSpec,
                  runtime = predicates.isType '"String",
                  specVersion = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Git = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  contextDir = predicates.isType '"String",
                  revision = predicates.isType '"String",
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          HealthEndpoints
            | doc m%"
            HealthEndpoints specify the liveness and readiness endpoints for a Runtime
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  liveness = predicates.isType '"String",
                  readiness = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Label = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key" ],
                predicates.records.record
                {
                  key = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*\\/)?([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9]$"
                      ],
                  value = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Options = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  resources = definitions.predicate.ResourcesOptions,
                  scale = definitions.predicate.ScaleOptions,
                }
                {  }
                false
                predicates.never
              ],
          PersistentVolumeClaim = predicates.allOf
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
          ResourcesLimitsOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  concurrency = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  cpu = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^([+-]?[0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$"
                      ],
                  memory = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^([+-]?[0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ResourcesOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  limits = definitions.predicate.ResourcesLimitsOptions,
                  requests = definitions.predicate.ResourcesRequestsOptions,
                }
                {  }
                false
                predicates.never
              ],
          ResourcesRequestsOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cpu = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^([+-]?[0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$"
                      ],
                  memory = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^([+-]?[0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          RunSpec
            | doc m%"
            RunSpec
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  envs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Env
                      ],
                  startTimeout = predicates.isType 'Integer,
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
          ScaleOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  max = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  metric = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "concurrency", "rps" ]
                      ],
                  min = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  target = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  utilization = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 100,
                        predicates.numbers.minimum 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Volume = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "secret" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "configMap" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "presistentVolumeClaim" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "emptyDir" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  configMap = predicates.isType '"String",
                  emptyDir = definitions.predicate.EmptyDir,
                  path = predicates.isType '"String",
                  presistentVolumeClaim =
                    definitions.predicate.PersistentVolumeClaim,
                  secret = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

definitions.contract.Function