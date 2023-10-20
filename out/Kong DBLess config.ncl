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
          ACLGroup = {
                consumer | definitions.contract.Consumer | optional,
                created_at | std.number.Integer | optional,
                group | String,
                id | String | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          ActiveHealthcheck = {
                concurrency | std.number.Integer | optional,
                healthy
                  | predicates.contract_from_predicate
                  definitions.predicate.Healthy
                  | optional,
                http_path | String | optional,
                https_sni | String | optional,
                https_verify_certificate | Bool | optional,
                timeout | std.number.Integer | optional,
                type | String | optional,
                unhealthy
                  | predicates.contract_from_predicate
                  definitions.predicate.Unhealthy
                  | optional,
              },
          BasicAuth = {
                consumer | definitions.contract.Consumer | optional,
                created_at | std.number.Integer | optional,
                id | String | optional,
                password | String,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                username | String,
              },
          CACertificate = {
                cert | String | optional,
                cert_digest | String | optional,
                created_at | std.number.Integer | optional,
                id | String | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          CIDRPort = {
                ip | String | optional,
                port | std.number.Integer | optional,
              },
          Certificate = {
                cert | String | optional,
                cert_alt | String | optional,
                created_at | std.number.Integer | optional,
                id | String | optional,
                key | String | optional,
                key_alt | String | optional,
                snis
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
              },
          Consumer = {
                created_at | std.number.Integer | optional,
                custom_id | String | optional,
                id | String | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                username | String | optional,
              },
          ConsumerGroup = {
                created_at | std.number.Integer | optional,
                id | String | optional,
                name | String | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          ConsumerGroupPlugin = {
                config | {  .. } | optional,
                consumer_group | definitions.contract.ConsumerGroup | optional,
                created_at | std.number.Integer | optional,
                id | String | optional,
                name | String | optional,
              },
          FCACertificate = {
                cert | String,
                cert_digest | String | optional,
                created_at | std.number.Integer | optional,
                id | String | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          FCertificate = {
                cert | String,
                created_at | std.number.Integer | optional,
                id | String,
                key | String,
                snis
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      { name = predicates.isType '"String", }
                      {  }
                      true
                      predicates.always
                    ])
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
              },
          FConsumer = predicates.contract_from_predicate
              definitions.predicate.FConsumer,
          FConsumerGroupObject = {
                consumers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Consumer
                  ])
                  | optional,
                created_at | std.number.Integer | optional,
                id | String | optional,
                name | String | optional,
                plugins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.ConsumerGroupPlugin
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
              },
          FDocument = {
                id | String | optional,
                path | String | optional,
                published | Bool | optional,
              },
          FPlugin = {
                _config | String | optional,
                config | {  .. } | optional,
                consumer | String | optional,
                created_at | std.number.Integer | optional,
                enabled | Bool | optional,
                id | String | optional,
                name | String,
                ordering
                  | predicates.contract_from_predicate
                  definitions.predicate.PluginOrdering
                  | optional,
                protocols
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                route | String | optional,
                run_on | String | optional,
                service | String | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          FRBACEndpointPermission = {
                actions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                comment | String | optional,
                created_at | std.number.Integer | optional,
                endpoint | String,
                negative | Bool | optional,
                role
                  | predicates.contract_from_predicate
                  definitions.predicate.RBACRole
                  | optional,
                workspace | String,
              },
          FRBACRole = {
                comment | String | optional,
                created_at | std.number.Integer | optional,
                endpoint_permissions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.FRBACEndpointPermission
                  ])
                  | optional,
                id | String | optional,
                is_default | Bool | optional,
                name | String,
              },
          FRoute = predicates.contract_from_predicate
              definitions.predicate.FRoute,
          FService = predicates.contract_from_predicate
              definitions.predicate.FService,
          FServicePackage = {
                description | String | optional,
                document | definitions.contract.FDocument | optional,
                id | String | optional,
                name | String,
                versions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.FServiceVersion
                  ])
                  | optional,
              },
          FServiceVersion = {
                document
                  | predicates.contract_from_predicate
                  definitions.predicate.FDocument
                  | optional,
                id | String | optional,
                implementation
                  | predicates.contract_from_predicate
                  definitions.predicate.Implementation
                  | optional,
                version | String,
              },
          FTarget = {
                created_at | Number | optional,
                id | String | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                target | String,
                upstream | definitions.contract.Upstream | optional,
                weight | std.number.Integer | optional,
              },
          FUpstream = {
                algorithm | String | optional,
                client_certificate
                  | definitions.contract.Certificate
                  | optional,
                created_at | std.number.Integer | optional,
                hash_fallback | String | optional,
                hash_fallback_header | String | optional,
                hash_fallback_query_arg | String | optional,
                hash_fallback_uri_capture | String | optional,
                hash_on | String | optional,
                hash_on_cookie | String | optional,
                hash_on_cookie_path | String | optional,
                hash_on_header | String | optional,
                hash_on_query_arg | String | optional,
                hash_on_uri_capture | String | optional,
                healthchecks | definitions.contract.Healthcheck | optional,
                host_header | String | optional,
                id | String | optional,
                name | String,
                slots | std.number.Integer | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                targets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.FTarget
                  ])
                  | optional,
              },
          FVault = {
                config | {  .. } | optional,
                created_at | std.number.Integer | optional,
                description | String | optional,
                id | String | optional,
                name | String | optional,
                prefix | String | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                updated_at | std.number.Integer | optional,
              },
          HMACAuth = {
                consumer | definitions.contract.Consumer | optional,
                created_at | std.number.Integer | optional,
                id | String | optional,
                secret | String,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                username | String,
              },
          Healthcheck = {
                active
                  | predicates.contract_from_predicate
                  definitions.predicate.ActiveHealthcheck
                  | optional,
                passive
                  | predicates.contract_from_predicate
                  definitions.predicate.PassiveHealthcheck
                  | optional,
                threshold | Number | optional,
              },
          Healthy = {
                http_statuses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType 'Integer)
                  ])
                  | optional,
                interval | std.number.Integer | optional,
                successes | std.number.Integer | optional,
              },
          Implementation = {
                kong
                  | predicates.contract_from_predicate
                  definitions.predicate.Kong,
                type | String,
              },
          Info = {
                defaults
                  | predicates.contract_from_predicate
                  definitions.predicate.KongDefaults
                  | optional,
                select_tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          JWTAuth = {
                algorithm | String,
                consumer | definitions.contract.Consumer | optional,
                created_at | std.number.Integer | optional,
                id | String | optional,
                key | String,
                rsa_public_key | String | optional,
                secret | String,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          KeyAuth = {
                consumer | definitions.contract.Consumer | optional,
                created_at | std.number.Integer | optional,
                id | String | optional,
                key | String,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                ttl | std.number.Integer | optional,
              },
          Kong = { service | definitions.contract.FService | optional, },
          KongDefaults = {
                route
                  | predicates.contract_from_predicate
                  definitions.predicate.Route
                  | optional,
                service
                  | predicates.contract_from_predicate
                  definitions.predicate.Service
                  | optional,
                target
                  | predicates.contract_from_predicate
                  definitions.predicate.Target
                  | optional,
                upstream
                  | predicates.contract_from_predicate
                  definitions.predicate.Upstream
                  | optional,
              },
          Konnect = { runtime_group_name | String | optional, },
          MTLSAuth = {
                ca_certificate
                  | predicates.contract_from_predicate
                  definitions.predicate.CACertificate
                  | optional,
                consumer | definitions.contract.Consumer | optional,
                created_at | std.number.Integer | optional,
                id | String,
                subject_name | String,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          Oauth2Credential = {
                client_id | String,
                client_secret | String,
                client_type | String | optional,
                consumer | definitions.contract.Consumer | optional,
                created_at | std.number.Integer | optional,
                hash_secret | Bool | optional,
                id | String | optional,
                name | String,
                redirect_uris
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
              },
          PassiveHealthcheck = {
                healthy | definitions.contract.Healthy | optional,
                type | String | optional,
                unhealthy | definitions.contract.Unhealthy | optional,
              },
          PluginOrdering = {
                after
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                before
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
              },
          RBACRole = {
                comment | String | optional,
                created_at | std.number.Integer | optional,
                id | String | optional,
                is_default | Bool | optional,
                name | String | optional,
              },
          Route = {
                created_at | std.number.Integer | optional,
                destinations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.CIDRPort
                  ])
                  | optional,
                expression | String | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String")
                          ],
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                hosts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                https_redirect_status_code | std.number.Integer | optional,
                id | String | optional,
                methods
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                name | String | optional,
                path_handling | String | optional,
                paths
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                preserve_host | Bool | optional,
                "priority" | std.number.Integer | optional,
                protocols
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                regex_priority | std.number.Integer | optional,
                request_buffering | Bool | optional,
                response_buffering | Bool | optional,
                service | definitions.contract.Service | optional,
                snis
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                sources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.CIDRPort
                  ])
                  | optional,
                strip_path | Bool | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                updated_at | std.number.Integer | optional,
              },
          SNI = {
                certificate | definitions.contract.Certificate | optional,
                created_at | std.number.Integer | optional,
                id | String | optional,
                name | String | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
          Service = {
                ca_certificates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                client_certificate
                  | predicates.contract_from_predicate
                  definitions.predicate.Certificate
                  | optional,
                connect_timeout | std.number.Integer | optional,
                created_at | std.number.Integer | optional,
                enabled | Bool | optional,
                host | String | optional,
                id | String | optional,
                name | String | optional,
                path | String | optional,
                port | std.number.Integer | optional,
                protocol | String | optional,
                read_timeout | std.number.Integer | optional,
                retries | std.number.Integer | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                tls_verify | Bool | optional,
                tls_verify_depth | std.number.Integer | optional,
                updated_at | std.number.Integer | optional,
                url | String | optional,
                write_timeout | std.number.Integer | optional,
              },
          Target = {
                created_at | Number | optional,
                id | String | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                target | String | optional,
                upstream | definitions.contract.Upstream | optional,
                weight | std.number.Integer | optional,
              },
          Unhealthy = {
                http_failures | std.number.Integer | optional,
                http_statuses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType 'Integer)
                  ])
                  | optional,
                interval | std.number.Integer | optional,
                tcp_failures | std.number.Integer | optional,
                timeouts | std.number.Integer | optional,
              },
          Upstream = {
                algorithm | String | optional,
                client_certificate
                  | definitions.contract.Certificate
                  | optional,
                created_at | std.number.Integer | optional,
                hash_fallback | String | optional,
                hash_fallback_header | String | optional,
                hash_fallback_query_arg | String | optional,
                hash_fallback_uri_capture | String | optional,
                hash_on | String | optional,
                hash_on_cookie | String | optional,
                hash_on_cookie_path | String | optional,
                hash_on_header | String | optional,
                hash_on_query_arg | String | optional,
                hash_on_uri_capture | String | optional,
                healthchecks
                  | predicates.contract_from_predicate
                  definitions.predicate.Healthcheck
                  | optional,
                host_header | String | optional,
                id | String | optional,
                name | String | optional,
                slots | std.number.Integer | optional,
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
              },
        },
    predicate = {
          ACLGroup = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "group" ],
                predicates.records.record
                {
                  consumer = definitions.predicate.Consumer,
                  created_at = predicates.isType 'Integer,
                  group = predicates.isType '"String",
                  id = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ActiveHealthcheck = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  concurrency = predicates.isType 'Integer,
                  healthy = definitions.predicate.Healthy,
                  http_path = predicates.isType '"String",
                  https_sni = predicates.isType '"String",
                  https_verify_certificate = predicates.isType '"Bool",
                  timeout = predicates.isType 'Integer,
                  type = predicates.isType '"String",
                  unhealthy = definitions.predicate.Unhealthy,
                }
                {  }
                false
                predicates.never
              ],
          BasicAuth = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "password", "username" ],
                predicates.records.record
                {
                  consumer = definitions.predicate.Consumer,
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  password = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CACertificate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cert = predicates.isType '"String",
                  cert_digest = predicates.isType '"String",
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          CIDRPort = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ip = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          Certificate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cert = predicates.isType '"String",
                  cert_alt = predicates.isType '"String",
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  key = predicates.isType '"String",
                  key_alt = predicates.isType '"String",
                  snis = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Consumer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  created_at = predicates.isType 'Integer,
                  custom_id = predicates.isType '"String",
                  id = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ConsumerGroup = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ConsumerGroupPlugin = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  consumer_group = definitions.predicate.ConsumerGroup,
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FCACertificate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "cert" ],
                predicates.records.record
                {
                  cert = predicates.isType '"String",
                  cert_digest = predicates.isType '"String",
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FCertificate = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "cert", "id", "key" ],
                predicates.records.record
                {
                  cert = predicates.isType '"String",
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  key = predicates.isType '"String",
                  snis = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { name = predicates.isType '"String", }
                          {  }
                          true
                          predicates.always
                        ])
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FConsumer = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "username" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "id" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  acls = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.ACLGroup
                      ],
                  basicauth_credentials = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.BasicAuth
                      ],
                  created_at = predicates.isType 'Integer,
                  custom_id = predicates.isType '"String",
                  groups = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ConsumerGroup
                      ],
                  hmacauth_credentials = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.HMACAuth
                      ],
                  id = predicates.isType '"String",
                  jwt_secrets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.JWTAuth
                      ],
                  keyauth_credentials = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.KeyAuth
                      ],
                  mtls_auth_credentials = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.MTLSAuth
                      ],
                  oauth2_credentials = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Oauth2Credential
                      ],
                  plugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.FPlugin
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FConsumerGroupObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  consumers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Consumer
                      ],
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  plugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ConsumerGroupPlugin
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FDocument = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  id = predicates.isType '"String",
                  path = predicates.isType '"String",
                  published = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          FPlugin = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  _config = predicates.isType '"String",
                  config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  consumer = predicates.isType '"String",
                  created_at = predicates.isType 'Integer,
                  enabled = predicates.isType '"Bool",
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  ordering = definitions.predicate.PluginOrdering,
                  protocols = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  route = predicates.isType '"String",
                  run_on = predicates.isType '"String",
                  service = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FRBACEndpointPermission = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "endpoint", "workspace" ],
                predicates.records.record
                {
                  actions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  comment = predicates.isType '"String",
                  created_at = predicates.isType 'Integer,
                  endpoint = predicates.isType '"String",
                  negative = predicates.isType '"Bool",
                  role = definitions.predicate.RBACRole,
                  workspace = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FRBACRole = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  comment = predicates.isType '"String",
                  created_at = predicates.isType 'Integer,
                  endpoint_permissions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.FRBACEndpointPermission
                      ],
                  id = predicates.isType '"String",
                  is_default = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FRoute = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "name" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "id" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  created_at = predicates.isType 'Integer,
                  destinations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.CIDRPort
                      ],
                  expression = predicates.isType '"String",
                  headers = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                        }
                        true
                        predicates.always
                      ],
                  hosts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  https_redirect_status_code = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  methods = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  path_handling = predicates.isType '"String",
                  paths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  plugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.FPlugin
                      ],
                  preserve_host = predicates.isType '"Bool",
                  "priority" = predicates.isType 'Integer,
                  protocols = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  regex_priority = predicates.isType 'Integer,
                  request_buffering = predicates.isType '"Bool",
                  response_buffering = predicates.isType '"Bool",
                  service = definitions.predicate.Service,
                  snis = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  sources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.CIDRPort
                      ],
                  strip_path = predicates.isType '"Bool",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  updated_at = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          FService = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "name" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "id" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  ca_certificates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  client_certificate = predicates.isType '"String",
                  connect_timeout = predicates.isType 'Integer,
                  created_at = predicates.isType 'Integer,
                  enabled = predicates.isType '"Bool",
                  host = predicates.isType '"String",
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  path = predicates.isType '"String",
                  plugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.FPlugin
                      ],
                  port = predicates.isType 'Integer,
                  protocol = predicates.isType '"String",
                  read_timeout = predicates.isType 'Integer,
                  retries = predicates.isType 'Integer,
                  routes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.FRoute
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  tls_verify = predicates.isType '"Bool",
                  tls_verify_depth = predicates.isType 'Integer,
                  updated_at = predicates.isType 'Integer,
                  url = predicates.isType '"String",
                  write_timeout = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          FServicePackage = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  document = definitions.predicate.FDocument,
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  versions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.FServiceVersion
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FServiceVersion = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "version" ],
                predicates.records.record
                {
                  document = definitions.predicate.FDocument,
                  id = predicates.isType '"String",
                  implementation = definitions.predicate.Implementation,
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FTarget = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "target" ],
                predicates.records.record
                {
                  created_at = predicates.isType '"Number",
                  id = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  target = predicates.isType '"String",
                  upstream = definitions.predicate.Upstream,
                  weight = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          FUpstream = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  algorithm = predicates.isType '"String",
                  client_certificate = definitions.predicate.Certificate,
                  created_at = predicates.isType 'Integer,
                  hash_fallback = predicates.isType '"String",
                  hash_fallback_header = predicates.isType '"String",
                  hash_fallback_query_arg = predicates.isType '"String",
                  hash_fallback_uri_capture = predicates.isType '"String",
                  hash_on = predicates.isType '"String",
                  hash_on_cookie = predicates.isType '"String",
                  hash_on_cookie_path = predicates.isType '"String",
                  hash_on_header = predicates.isType '"String",
                  hash_on_query_arg = predicates.isType '"String",
                  hash_on_uri_capture = predicates.isType '"String",
                  healthchecks = definitions.predicate.Healthcheck,
                  host_header = predicates.isType '"String",
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  slots = predicates.isType 'Integer,
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  targets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.FTarget
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FVault = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  config = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  created_at = predicates.isType 'Integer,
                  description = predicates.isType '"String",
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  prefix = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  updated_at = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          HMACAuth = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "secret", "username" ],
                predicates.records.record
                {
                  consumer = definitions.predicate.Consumer,
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  secret = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Healthcheck = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  active = definitions.predicate.ActiveHealthcheck,
                  passive = definitions.predicate.PassiveHealthcheck,
                  threshold = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          Healthy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  http_statuses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType 'Integer)
                      ],
                  interval = predicates.isType 'Integer,
                  successes = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          Implementation = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kong", "type" ],
                predicates.records.record
                {
                  kong = definitions.predicate.Kong,
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Info = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaults = definitions.predicate.KongDefaults,
                  select_tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          JWTAuth = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "algorithm", "key", "secret" ],
                predicates.records.record
                {
                  algorithm = predicates.isType '"String",
                  consumer = definitions.predicate.Consumer,
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  key = predicates.isType '"String",
                  rsa_public_key = predicates.isType '"String",
                  secret = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          KeyAuth = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "key" ],
                predicates.records.record
                {
                  consumer = definitions.predicate.Consumer,
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  key = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ttl = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          Kong = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { service = definitions.predicate.FService, }
                {  }
                false
                predicates.never
              ],
          KongDefaults = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  route = definitions.predicate.Route,
                  service = definitions.predicate.Service,
                  target = definitions.predicate.Target,
                  upstream = definitions.predicate.Upstream,
                }
                {  }
                false
                predicates.never
              ],
          Konnect = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { runtime_group_name = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          MTLSAuth = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id", "subject_name" ],
                predicates.records.record
                {
                  ca_certificate = definitions.predicate.CACertificate,
                  consumer = definitions.predicate.Consumer,
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  subject_name = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Oauth2Credential = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "client_id", "client_secret", "name" ],
                predicates.records.record
                {
                  client_id = predicates.isType '"String",
                  client_secret = predicates.isType '"String",
                  client_type = predicates.isType '"String",
                  consumer = definitions.predicate.Consumer,
                  created_at = predicates.isType 'Integer,
                  hash_secret = predicates.isType '"Bool",
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  redirect_uris = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PassiveHealthcheck = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  healthy = definitions.predicate.Healthy,
                  type = predicates.isType '"String",
                  unhealthy = definitions.predicate.Unhealthy,
                }
                {  }
                false
                predicates.never
              ],
          PluginOrdering = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  after = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                        }
                        true
                        predicates.always
                      ],
                  before = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                        }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          RBACRole = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  comment = predicates.isType '"String",
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  is_default = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Route = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  created_at = predicates.isType 'Integer,
                  destinations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.CIDRPort
                      ],
                  expression = predicates.isType '"String",
                  headers = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                        }
                        true
                        predicates.always
                      ],
                  hosts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  https_redirect_status_code = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  methods = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  path_handling = predicates.isType '"String",
                  paths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  preserve_host = predicates.isType '"Bool",
                  "priority" = predicates.isType 'Integer,
                  protocols = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  regex_priority = predicates.isType 'Integer,
                  request_buffering = predicates.isType '"Bool",
                  response_buffering = predicates.isType '"Bool",
                  service = definitions.predicate.Service,
                  snis = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  sources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.CIDRPort
                      ],
                  strip_path = predicates.isType '"Bool",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  updated_at = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          SNI = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  certificate = definitions.predicate.Certificate,
                  created_at = predicates.isType 'Integer,
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Service = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ca_certificates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  client_certificate = definitions.predicate.Certificate,
                  connect_timeout = predicates.isType 'Integer,
                  created_at = predicates.isType 'Integer,
                  enabled = predicates.isType '"Bool",
                  host = predicates.isType '"String",
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  path = predicates.isType '"String",
                  port = predicates.isType 'Integer,
                  protocol = predicates.isType '"String",
                  read_timeout = predicates.isType 'Integer,
                  retries = predicates.isType 'Integer,
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  tls_verify = predicates.isType '"Bool",
                  tls_verify_depth = predicates.isType 'Integer,
                  updated_at = predicates.isType 'Integer,
                  url = predicates.isType '"String",
                  write_timeout = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          Target = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  created_at = predicates.isType '"Number",
                  id = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  target = predicates.isType '"String",
                  upstream = definitions.predicate.Upstream,
                  weight = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          Unhealthy = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  http_failures = predicates.isType 'Integer,
                  http_statuses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType 'Integer)
                      ],
                  interval = predicates.isType 'Integer,
                  tcp_failures = predicates.isType 'Integer,
                  timeouts = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          Upstream = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  algorithm = predicates.isType '"String",
                  client_certificate = definitions.predicate.Certificate,
                  created_at = predicates.isType 'Integer,
                  hash_fallback = predicates.isType '"String",
                  hash_fallback_header = predicates.isType '"String",
                  hash_fallback_query_arg = predicates.isType '"String",
                  hash_fallback_uri_capture = predicates.isType '"String",
                  hash_on = predicates.isType '"String",
                  hash_on_cookie = predicates.isType '"String",
                  hash_on_cookie_path = predicates.isType '"String",
                  hash_on_header = predicates.isType '"String",
                  hash_on_query_arg = predicates.isType '"String",
                  hash_on_uri_capture = predicates.isType '"String",
                  healthchecks = definitions.predicate.Healthcheck,
                  host_header = predicates.isType '"String",
                  id = predicates.isType '"String",
                  name = predicates.isType '"String",
                  slots = predicates.isType 'Integer,
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.record
  {
    _format_version = predicates.isType '"String",
    _info = definitions.predicate.Info,
    _konnect = definitions.predicate.Konnect,
    _plugin_configs = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            ".*" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  } {  } true predicates.always
                ],
          }
          true
          predicates.always
        ],
    _transform = predicates.isType '"Bool",
    _workspace = predicates.isType '"String",
    ca_certificates = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.FCACertificate
        ],
    certificates = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.FCertificate
        ],
    consumer_groups = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.FConsumerGroupObject
        ],
    consumers = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.FConsumer
        ],
    plugins = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.FPlugin
        ],
    rbac_roles = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.FRBACRole
        ],
    routes = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.FRoute
        ],
    service_packages = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.FServicePackage
        ],
    services = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.FService
        ],
    upstreams = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.FUpstream
        ],
    vaults = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.FVault
        ],
  }
  {  }
  false
  predicates.never
])