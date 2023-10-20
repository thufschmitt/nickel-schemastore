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
          addAutoIncrement
            | doc m%"
            Converts an existing column to be an auto-increment (a.k.a 'identity') column.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columnDataType
                  | String
                  | doc m%"
                  Current data type of the column to make auto-increment
                  "%
                  | optional,
                columnName
                  | String
                  | doc m%"
                  Name of the column
                  "%,
                defaultOnNull
                  | Bool
                  | doc m%"
                  When using generationType 'BY DEFAULT' then defaultOnNull = true allows the identity to be used if the identity column is referenced, but a value of NULL is specified.
                  "%
                  | optional,
                generationType
                  | predicates.contract_from_predicate
                  (predicates.enum [ "ALWAYS", "BY DEFAULT" ])
                  | doc m%"
                  Type of the generation in 'GENERATED %s AS IDENTITY'. ALWAYS | BY DEFAULT
                  "%
                  | optional,
                incrementBy
                  | std.number.Integer
                  | doc m%"
                  Integer value the increment increments at each call
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                startWith
                  | std.number.Integer
                  | doc m%"
                  Initial integer value of the increment
                  "%
                  | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          addColumn
            | doc m%"
            You can typically use the addColumn Change Type when you want to add a new column and deploy it to the table in your database.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columns | definitions.contract.columns,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          addDefaultValue
            | doc m%"
            The addDefaultValue Change Type adds a default value to the database definition for the specified column.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columnDataType
                  | String
                  | doc m%"
                  The current data type of the column for which to add a default value.
                  "%
                  | optional,
                columnName
                  | String
                  | doc m%"
                  The name of the column for which to add a default value.
                  "%,
                defaultValue
                  | String
                  | doc m%"
                  The default value. Either this property or one of the other defaultValue* properties are required.
                  "%
                  | optional,
                defaultValueBoolean
                  | Bool
                  | doc m%"
                  The attribute that sets the default value for a column of a boolean type.
                  "%
                  | optional,
                defaultValueComputed
                  | String
                  | doc m%"
                  The attribute that sets the default value for a column using a function which returns value of the same type as the column has.
                  "%
                  | optional,
                defaultValueConstraintName
                  | String
                  | doc m%"
                  The attribute that sets a unique name for default constraint used for a specific column. It works only along with any of defaultValue* attributes listed.
                  "%
                  | optional,
                defaultValueDate
                  | String
                  | doc m%"
                  The attribute that sets the default value for a column of a date type. For example: timestamp, datetime, date, and others.
                  "%
                  | optional,
                defaultValueNumeric
                  | Number
                  | doc m%"
                  The attribute that sets the default value for a column of a numeric type. For example: integer, bigint, bigdecimal, and others.
                  "%
                  | optional,
                defaultValueSequenceNext
                  | String
                  | doc m%"
                  The attribute that sets value for a specified column by using the value of the existing sequence. With every new input, the next value of the sequence will be taken.
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          addForeignKeyConstraint
            | doc m%"
            Adds a foreign key constraint to an existing column.
            "%
            = {
                baseColumnNames
                  | String
                  | doc m%"
                  Name of column(s) to place the foreign key constraint on. Comma-separate if multiple
                  "%,
                baseTableCatalogName
                  | String
                  | doc m%"
                  Catalog name of the base table
                  "%
                  | optional,
                baseTableName
                  | String
                  | doc m%"
                  Name of the table containing the column to constraint
                  "%,
                baseTableSchemaName
                  | String
                  | doc m%"
                  Schema name of the base table
                  "%
                  | optional,
                constraintName
                  | String
                  | doc m%"
                  Name of the new foreign key constraint
                  "%,
                deferrable
                  | Bool
                  | doc m%"
                  Is the foreign key deferrable
                  "%
                  | optional,
                deleteCascade | Bool | optional,
                initiallyDeferred
                  | Bool
                  | doc m%"
                  Is the foreign key initially deferred
                  "%
                  | optional,
                onDelete
                  | String
                  | doc m%"
                  ON DELETE functionality. Possible values: 'CASCADE', 'SET NULL', 'SET DEFAULT', 'RESTRICT', 'NO ACTION'
                  "%
                  | optional,
                onUpdate
                  | String
                  | doc m%"
                  ON UPDATE functionality. Possible values: 'CASCADE', 'SET NULL', 'SET DEFAULT', 'RESTRICT', 'NO ACTION'
                  "%
                  | optional,
                referencedColumnNames
                  | String
                  | doc m%"
                  Column(s) the foreign key points to. Comma-separate if multiple
                  "%,
                referencedTableCatalogName
                  | String
                  | doc m%"
                  Schema name of the referenced table
                  "%
                  | optional,
                referencedTableName
                  | String
                  | doc m%"
                  Name of the table the foreign key points to
                  "%,
                referencedTableSchemaName
                  | String
                  | doc m%"
                  Schema name of the referenced table
                  "%
                  | optional,
                referencesUniqueColumn | Bool | optional,
                validate
                  | Bool
                  | doc m%"
                  Shall be true if the foreign key should 'ENABLE VALIDATE' set, or false if the foreign key should 'ENABLE NOVALIDATE' set.
                  "%
                  | optional,
                ..
              },
          addLookupTable
            | doc m%"
            Creates a lookup table containing values stored in a column and creates a foreign key to the new table.
            "%
            = {
                constraintName
                  | String
                  | doc m%"
                  Name of the foreign-key constraint to create between the existing table and the lookup table
                  "%
                  | optional,
                existingColumnName
                  | String
                  | doc m%"
                  Name of the column in the new table to create
                  "%,
                existingTableCatalogName | String | optional,
                existingTableName
                  | String
                  | doc m%"
                  Name of the table containing the data to extract
                  "%,
                existingTableSchemaName | String | optional,
                newColumnDataType
                  | String
                  | doc m%"
                  Data type of the new table column
                  "%
                  | optional,
                newColumnName
                  | String
                  | doc m%"
                  Name of the column in the new table to create
                  "%,
                newTableCatalogName | String | optional,
                newTableName
                  | String
                  | doc m%"
                  Name of lookup table to create
                  "%,
                newTableSchemaName | String | optional,
                ..
              },
          addNotNullConstraint
            | doc m%"
            The addNotNullConstraint Change Type adds a NOT NULL constraint to an existing table.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columnDataType
                  | String
                  | doc m%"
                  The current data type of the column.
                  "%
                  | optional,
                columnName
                  | String
                  | doc m%"
                  The name of the column for which to add the constraint.
                  "%,
                constraintName
                  | String
                  | doc m%"
                  The created constraint name (if database supports names for NOT NULL constraints).
                  "%
                  | optional,
                defaultNullValue
                  | String
                  | doc m%"
                  The value for which you can set all values that currently equal null in a column. If null values exist and if defaultNullValue is not set, the change will fail.
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                validate
                  | Bool
                  | doc m%"
                  The attribute which is true if the NOT NULL constraint has 'ENABLE VALIDATE' set, or which is false if the NOT NULL constrain has 'ENABLE NOVALIDATE' set.
                  "%
                  | optional,
                ..
              },
          addPrimaryKey
            | doc m%"
            Adds a primary key out of an existing column or set of columns.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                clustered | Bool | optional,
                columnNames
                  | String
                  | doc m%"
                  Name of the column(s) to create the primary key on. Comma separated if multiple
                  "%,
                constraintName
                  | String
                  | doc m%"
                  Name of primary key constraint
                  "%
                  | optional,
                forIndexCatalogName | String | optional,
                forIndexName | String | optional,
                forIndexSchemaName | String | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                tablespace | String | optional,
                validate
                  | Bool
                  | doc m%"
                  This is true if the primary key has 'ENABLE VALIDATE' set, or false if the primary key has 'ENABLE NOVALIDATE' set.
                  "%
                  | optional,
                ..
              },
          addUniqueConstraint
            | doc m%"
            Adds a unique constraint to an existing column or set of columns.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                clustered
                  | Bool
                  | doc m%"
                  Whether create a clustered index
                  "%
                  | optional,
                columnNames
                  | String
                  | doc m%"
                  Name of the column(s) to create the unique constraint on. Comma separated if multiple
                  "%,
                constraintName
                  | String
                  | doc m%"
                  Name of the unique constraint
                  "%
                  | optional,
                deferrable
                  | Bool
                  | doc m%"
                  True if this constraint is deferrable, False otherwise
                  "%
                  | optional,
                disabled
                  | Bool
                  | doc m%"
                  True if this constraint is disabled, False otherwise
                  "%
                  | optional,
                forIndexCatalogName | String | optional,
                forIndexName | String | optional,
                forIndexSchemaName | String | optional,
                initiallyDeferred
                  | Bool
                  | doc m%"
                  True if this constraint is initially deferred, False otherwise
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                tablespace
                  | String
                  | doc m%"
                  'Tablespace' to create the index in. Corresponds to file group in mssql
                  "%
                  | optional,
                validate
                  | Bool
                  | doc m%"
                  Should be true if the unique constraint shall 'ENABLE VALIDATE' set, or false if the 'ENABLE NOVALIDATE' shall.
                  "%
                  | optional,
                ..
              },
          alterSequence
            | doc m%"
            Alters properties of an existing sequence.
            "%
            = {
                cacheSize
                  | std.number.Integer
                  | doc m%"
                  Change the cache size
                  "%
                  | optional,
                catalogName | definitions.contract.catalogName | optional,
                cycle
                  | Bool
                  | doc m%"
                  Can the sequence cycle when it hits the max value?
                  "%
                  | optional,
                dataType
                  | String
                  | doc m%"
                  Data type of the sequence
                  "%
                  | optional,
                incrementBy
                  | std.number.Integer
                  | doc m%"
                  New amount the sequence should increment by
                  "%
                  | optional,
                maxValue
                  | std.number.Integer
                  | doc m%"
                  New maximum value for the sequence
                  "%
                  | optional,
                minValue
                  | std.number.Integer
                  | doc m%"
                  New minimum value for the sequence
                  "%
                  | optional,
                ordered
                  | Bool
                  | doc m%"
                  Does the sequence need to be guaranteed to be generated in the order of request?
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                sequenceName
                  | String
                  | doc m%"
                  Name of the sequence to alter
                  "%,
                ..
              },
          catalogName
            | doc m%"
            The name of the catalog
            "%
            = String,
          changes = predicates.contract_from_predicate
              definitions.predicate.changes,
          column = {
                afterColumn
                  | String
                  | doc m%"
                  The attribute that allows you to control where in the table column order the new column goes if it is used in an addColumn command. Only one of beforeColumn, afterColumn, or position is allowed. Since 3.1
                  "%
                  | optional,
                autoIncrement
                  | Bool
                  | doc m%"
                  The auto-increment column. Ignored on databases that do not support the autoincrement/identity functionality.
                  "%
                  | optional,
                beforeColumn
                  | String
                  | doc m%"
                  The attribute that allows you to control where in the table column order the new column goes if it is used in an addColumn command. Only one of beforeColumn, afterColumn, or position is allowed. Since 3.1
                  "%
                  | optional,
                computed
                  | Bool
                  | doc m%"
                  The attribute which is used if the value in name isn't actually a column name but a function. Since 3.3.0
                  "%
                  | optional,
                constraints
                  | {
                    checkConstraint
                      | String
                      | doc m%"
                      The attribute that defines whether to validate the defined check constraint.
                      "%
                      | optional,
                    deferrable
                      | Bool
                      | doc m%"
                      The attribute that defines whether constraints are deferrable.
                      "%
                      | optional,
                    deleteCascade
                      | Bool
                      | doc m%"
                      The attribute that sets delete cascade.
                      "%
                      | optional,
                    foreignKeyName
                      | String
                      | doc m%"
                      The foreign key name.
                      "%
                      | optional,
                    initiallyDeferred
                      | Bool
                      | doc m%"
                      The attribute that defines whether constraints are initially deferred.
                      "%
                      | optional,
                    notNullConstraintName
                      | String
                      | doc m%"
                      The not null constraint name.
                      "%
                      | optional,
                    nullable
                      | Bool
                      | doc m%"
                      The attribute that defines whether the column is nullable.
                      "%
                      | optional,
                    primaryKey
                      | Bool
                      | doc m%"
                      The attribute that defines whether the column is a primary key.
                      "%
                      | optional,
                    primaryKeyName
                      | String
                      | doc m%"
                      The primary key name Since 1.6.
                      "%
                      | optional,
                    primaryKeyTablespace
                      | String
                      | doc m%"
                      The tablespace to use for the defined primary key.
                      "%
                      | optional,
                    referencedColumnNames
                      | String
                      | doc m%"
                      The name of the column.
                      "%
                      | optional,
                    referencedTableCatalogName
                      | String
                      | doc m%"
                      The name of the catalog.
                      "%
                      | optional,
                    referencedTableName
                      | String
                      | doc m%"
                      The name of the table.
                      "%
                      | optional,
                    referencedTableSchemaName
                      | String
                      | doc m%"
                      The name of the schema.
                      "%
                      | optional,
                    references
                      | String
                      | doc m%"
                      The foreign key definition.
                      "%
                      | optional,
                    unique
                      | Bool
                      | doc m%"
                      The attribute that defines whether a unique clause should be applied.
                      "%
                      | optional,
                    uniqueConstraintName
                      | String
                      | doc m%"
                      The unique constraint name.
                      "%
                      | optional,
                    validateForeignKey
                      | Bool
                      | doc m%"
                      The attribute that defines whether to validate the defined foreign key constraint.
                      "%
                      | optional,
                    validateNullable
                      | Bool
                      | doc m%"
                      The attribute that defines whether to validate the defined not null constraint.
                      "%
                      | optional,
                    validatePrimaryKey
                      | Bool
                      | doc m%"
                      The attribute that defines whether to validate the defined primary key constraint.
                      "%
                      | optional,
                    validateUnique
                      | Bool
                      | doc m%"
                      The attribute that defines whether to validate the defined unique constraint.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Constraint definitions
                  "%
                  | optional,
                defaultOnNull | Bool | optional,
                defaultValue
                  | String
                  | doc m%"
                  The default value for column.
                  "%
                  | optional,
                defaultValueBoolean
                  | Bool
                  | doc m%"
                  The default boolean value for column.
                  "%
                  | optional,
                defaultValueComputed
                  | String
                  | doc m%"
                  The default value that is returned from a function or procedure call. This attribute will contain the function to call.
                  "%
                  | optional,
                defaultValueConstraintName | String | optional,
                defaultValueDate
                  | String
                  | doc m%"
                  The default date and time value for column. The value is specified in one of the following forms: YYYY-MM-DD, hh:mm:ss, or YYYY-MM-DDThh:mm:ss.
                  "%
                  | optional,
                defaultValueNumeric
                  | Number
                  | doc m%"
                  The default numeric value for column.
                  "%
                  | optional,
                defaultValueSequenceCurrent | String | optional,
                defaultValueSequenceNext | String | optional,
                descending
                  | Bool
                  | doc m%"
                  The boolean attribute which allows you to specify that a column should be used in a descending order in the index if it is used in a createIndex command. Default value is false (in an ascending order) Since 3.4
                  "%
                  | optional,
                encoding
                  | String
                  | doc m%"
                  The name of the encoding (specified in java.nio.Charset javadoc, e.g. "UTF-8") of the CLOB file (specified in valueClobFile) contents.
                  "%
                  | optional,
                generationType | String | optional,
                header
                  | String
                  | doc m%"
                  Name of the column in the CSV file from which the value for the column will be taken if its different from the column name. Ignored if index is also defined.
                  "%
                  | optional,
                incrementBy
                  | std.number.Integer
                  | doc m%"
                  The value of each step by auto-increment. Ignored on databases that do not support autoincrement/identity functionality.
                  "%
                  | optional,
                index
                  | std.number.Integer
                  | doc m%"
                  Index of the column in the CSV file from which the value for the column will be taken.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the column.
                  "%,
                position
                  | Number
                  | doc m%"
                  The attribute that allows you to control where in the table column order the new column goes if it is used in an addColumn command. Only one of beforeColumn, afterColumn, or position is allowed. Uses one based index. Since 3.1
                  "%
                  | optional,
                remarks
                  | String
                  | doc m%"
                  A short description of the column (column comment).
                  "%
                  | optional,
                startWith
                  | std.number.Integer
                  | doc m%"
                  The value auto-increment start. Ignored on databases that do not support autoincrement/identity functionality.
                  "%
                  | optional,
                type
                  | String
                  | doc m%"
                  The column data type.
                  "%
                  | optional,
                value
                  | String
                  | doc m%"
                  The value for which to set the column. The value will be surrounded by quote marks and nested quote marks will be escaped.
                  "%
                  | optional,
                valueBlobFile
                  | String
                  | doc m%"
                  The path to a file, whose contents will be written as a BLOB (i.e. chunk of binary data).
                  
                  The path to the changelog file location must be either absolute or relative. An example of an absolute path is: /usr/local/somefile.dat on Unix or c:\Directory\somefile.dat on Windows.
                  "%
                  | optional,
                valueBoolean
                  | Bool
                  | doc m%"
                  The boolean value to set the column to. The actual value string inserted will depend on the database implementation.
                  "%
                  | optional,
                valueClobFile
                  | String
                  | doc m%"
                  The path to a file, whose contents will be written as a CLOB (i.e. chunk of character data).
                  The path to the changelog file location must be either absolute or relative. An example of an absolute path is: /usr/local/somefile.dat on Unix or c:\Directory\somefile.dat on Windows.
                  "%
                  | optional,
                valueComputed
                  | String
                  | doc m%"
                  The value that is returned from a function or procedure call. This attribute will contain the function to call.
                  "%
                  | optional,
                valueDate
                  | String
                  | doc m%"
                  The date and time value to set the column to. The value is specified in one of the following forms: YYYY-MM-DD, hh:mm:ss, or YYYY-MM-DDThh:mm:ss.
                  "%
                  | optional,
                valueNumeric
                  | Number
                  | doc m%"
                  The numeric value to set the column to. The value will not be escaped and will not be nested in quote marks.
                  "%
                  | optional,
                valueSequenceCurrent
                  | String
                  | doc m%"
                  The name of the sequence in which the current value is used.
                  "%
                  | optional,
                valueSequenceNext
                  | String
                  | doc m%"
                  The name of the sequence in which the next value is used.
                  "%
                  | optional,
                ..
              },
          columns
            | doc m%"
            The column constraint and foreign key information. Setting the defaultValue attribute will specify a default value for the column. Setting the value attribute will set all rows existing to the specified value without modifying the column default.
            See Information about the <column> tag section for more information.
            "%
            = predicates.contract_from_predicate definitions.predicate.columns,
          createIndex
            | doc m%"
            The createIndex Change Type creates an index on an existing column or a set of columns.
            "%
            = {
                associatedWith | String | optional,
                catalogName | definitions.contract.catalogName | optional,
                clustered
                  | Bool
                  | doc m%"
                  The attribute that creates a clustered index.
                  "%
                  | optional,
                column | definitions.contract.column | optional,
                columns | definitions.contract.columns | optional,
                indexName
                  | String
                  | doc m%"
                  The name of the index to create.
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                tablespace
                  | String
                  | doc m%"
                  The tablespace in which you create the index.
                  "%
                  | optional,
                unique
                  | Bool
                  | doc m%"
                  The unique values in the index.
                  "%
                  | optional,
                ..
              },
          createProcedure
            | doc m%"
            The createProcedure Change Type defines the definition for a stored procedure. This Change Type is better to use for creating procedures than the raw SQL command because it will not attempt to strip comments or break up lines.
            
            Often times it is best to use the CREATE OR REPLACE syntax along with setting runOnChange='true' on the enclosing changeset tag. That way if you need to make a change to your procedure, you can change your existing code rather than creating a new REPLACE PROCEDURE call. The advantage to this approach is that it keeps your changelog smaller and allows you to more easily see what has changed in your procedure code through your source control system's diff command.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                comments
                  | String
                  | doc m%"
                  The comments you can specify in the changeset.
                  "%
                  | optional,
                dbms | definitions.contract.dbms | optional,
                encoding
                  | String
                  | doc m%"
                  The encoding used in the file defined in the `path` attribute
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  The file containing the procedure text. Either this attribute or a nested procedure text is required.
                  "%,
                procedureName
                  | String
                  | doc m%"
                  The name of the procedure. It is required if replaceIfExists= true
                  "%
                  | optional,
                procedureText
                  | String
                  | doc m%"
                  The SQL creating the procedure. You need to define either this attribute or the path attribute. The procedureText attribute is not supported in the XML format; however, you can specify the procedure SQL within <createProcedure></<createProcedure> tags. See the XML example.
                  "%,
                relativeToChangelogFile
                  | Bool
                  | doc m%"
                  Defines whether the file path is relative to the root changelog file rather than to the classpath.
                  "%
                  | optional,
                replaceIfExists
                  | Bool
                  | doc m%"
                  If the stored procedure defined by procedureName already exits, alter it instead of creating it.
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                ..
              },
          createSequence
            | doc m%"
            Creates a new database sequence.
            "%
            = {
                cacheSize
                  | std.number.Integer
                  | doc m%"
                  Number of values to fetch per query
                  "%
                  | optional,
                catalogName | definitions.contract.catalogName | optional,
                cycle
                  | Bool
                  | doc m%"
                  Can the sequence cycle when it hits the max value?
                  "%
                  | optional,
                dataType
                  | String
                  | doc m%"
                  Data type of the sequence
                  "%
                  | optional,
                incrementBy
                  | std.number.Integer
                  | doc m%"
                  Interval between sequence numbers
                  "%
                  | optional,
                maxValue
                  | std.number.Integer
                  | doc m%"
                  The maximum value of the sequence
                  "%
                  | optional,
                minValue
                  | std.number.Integer
                  | doc m%"
                  The minimum value of the sequence
                  "%
                  | optional,
                ordered
                  | Bool
                  | doc m%"
                  Does the sequence need to be guaranteed to be generated in the order of request?
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                sequenceName
                  | String
                  | doc m%"
                  Name of the sequence to create
                  "%,
                startValue
                  | std.number.Integer
                  | doc m%"
                  The first sequence number to be generated.
                  "%
                  | optional,
                ..
              },
          createTable
            | doc m%"
            You can typically use the createTable Change Type when you want to create a table in your changelog file and then deploy it to your database. It can include columns and another values listed in this documentation.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columns | definitions.contract.columns,
                remarks | definitions.contract.remarks | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                tablespace
                  | String
                  | doc m%"
                  The name of the tablespace in which the table is created
                  "%
                  | optional,
                ..
              },
          createView
            | doc m%"
            Creates a new database view.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                encoding
                  | String
                  | doc m%"
                  Encoding used in the file defined in the `path` attribute
                  "%
                  | optional,
                fullDefinition
                  | Bool
                  | doc m%"
                  Set to true if selectQuery is the entire view definition. False if the CREATE VIEW header should be added.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Path to file containing view definition
                  "%
                  | optional,
                relativeToChangelogFile
                  | Bool
                  | doc m%"
                  Whether the file path relative to the root changelog file rather than to the classpath.
                  "%
                  | optional,
                remarks | definitions.contract.remarks | optional,
                replaceIfExists
                  | Bool
                  | doc m%"
                  Use 'create or replace' syntax
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                selectQuery
                  | String
                  | doc m%"
                  SQL for generating the view
                  "%
                  | optional,
                viewName
                  | String
                  | doc m%"
                  Name of the view to create
                  "%
                  | optional,
                ..
              },
          customChange
            | doc m%"
            The customChange type creates a custom Change Type class.
            "%
            = { class | String, .. },
          dbms
            | doc m%"
            Specifies logical expression of database type(s) on which the change must be applied. Valid database type names are listed on the supported databases page. It can be a comma-separated list of multiple databases or you can also specify that a change is not applicable to a particular database type by prefixing with !. The keywords all and none are also available.
            "%
            = String,
          delete
            | doc m%"
            Deletes data from an existing table.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                where | definitions.contract.where | optional,
                whereParams | definitions.contract.whereParams | optional,
                ..
              },
          dropAllForeignKeyConstraints
            | doc m%"
            Drops all foreign key constraints for a table.
            "%
            = {
                baseTableCatalogName
                  | String
                  | doc m%"
                  Catalog name of the table containing columns constrained by foreign keys
                  "%
                  | optional,
                baseTableName
                  | String
                  | doc m%"
                  Name of the table containing columns constrained by foreign keys
                  "%,
                baseTableSchemaName
                  | String
                  | doc m%"
                  Schema name of the table containing columns constrained by foreign keys
                  "%
                  | optional,
                ..
              },
          dropColumn
            | doc m%"
            Drops an existing column(s).
            
            To drop a single column, use the simple form of this element where the tableName and columnName are specified as attributes. To drop several columns, specify the tableName as an attribute, and then specify a set of nested <column> tags. If nested <column> tags are present, the columnName attribute will be ignored.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columnName
                  | String
                  | doc m%"
                  Name of the column to drop, if dropping a single column. Ignored if nested 'column's are defined
                  "%
                  | optional,
                columns | definitions.contract.columns | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          dropDefaultValue
            | doc m%"
            Removes the database default value for a column.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columnDataType | String | optional,
                columnName
                  | String
                  | doc m%"
                  Name of column to drop the default value from
                  "%,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          dropForeignKeyConstraint
            | doc m%"
            Drops an existing foreign key.
            "%
            = {
                baseTableCatalogName | String | optional,
                baseTableName
                  | String
                  | doc m%"
                  Name of the table containing the column constrained by the foreign key
                  "%,
                baseTableSchemaName | String | optional,
                constraintName
                  | String
                  | doc m%"
                  Name of the foreign key constraint to drop
                  "%,
                ..
              },
          dropIndex
            | doc m%"
            The dropIndex Change Type drops an existing index on a column.
            "%
            = {
                associatedWith | String | optional,
                catalogName | definitions.contract.catalogName | optional,
                indexName
                  | String
                  | doc m%"
                  The name of the index to drop.
                  "%,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName | optional,
                ..
              },
          dropNotNullConstraint
            | doc m%"
            Makes a column nullable.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columnDataType
                  | String
                  | doc m%"
                  Current data type of the column
                  "%
                  | optional,
                columnName
                  | String
                  | doc m%"
                  Name of the column to drop the constraint from
                  "%,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          dropPrimaryKey
            | doc m%"
            The dropPrimaryKey Change Type drops an existing primary key in the table.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                constraintName
                  | String
                  | doc m%"
                  The name of the primary key.
                  "%
                  | optional,
                dropIndex
                  | Bool
                  | doc m%"
                  The index to drop.
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          dropProcedure
            | doc m%"
            Drops an existing procedure
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                procedureName
                  | String
                  | doc m%"
                  Name of the stored procedure to drop
                  "%,
                schemaName | definitions.contract.schemaName | optional,
                ..
              },
          dropSequence
            | doc m%"
            Drops an existing sequence.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                schemaName | definitions.contract.schemaName | optional,
                sequenceName
                  | String
                  | doc m%"
                  Name of the sequence to drop
                  "%,
                ..
              },
          dropTable
            | doc m%"
            Drops an existing table from your database.
            "%
            = {
                cascadeConstraints
                  | Bool
                  | doc m%"
                  Add the `CASCADE CONSTRAINTS` to the statement
                  "%
                  | optional,
                catalogName | definitions.contract.catalogName | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          dropUniqueConstraint
            | doc m%"
            Drops an existing unique constraint.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                constraintName
                  | String
                  | doc m%"
                  Name of unique constraint to drop
                  "%,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                uniqueColumns | String | optional,
                ..
              },
          dropView
            | doc m%"
            Drops an existing view.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                schemaName | definitions.contract.schemaName | optional,
                viewName
                  | String
                  | doc m%"
                  Name of the view to drop
                  "%,
                ..
              },
          empty
            | doc m%"
            empty
            "%
            = {  .. },
          executeCommand
            | doc m%"
            The executeCommand Change Type executes a system command.
            "%
            = {
                arg
                  | {
                    value
                      | String
                      | doc m%"
                      The value of the attribute (for example: '-param')
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Arguments for the executable
                  "%
                  | optional,
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      { value = predicates.isType '"String", }
                      {  }
                      true
                      predicates.always
                    ])
                  ])
                  | doc m%"
                  Arguments for the executable
                  "%
                  | optional,
                executable
                  | String
                  | doc m%"
                  The name of the executable to run
                  "%,
                os
                  | String
                  | doc m%"
                  The list of operating systems on which to execute the command (taken from the os.name Java system property)
                  "%
                  | optional,
                timeout
                  | String
                  | doc m%"
                  The timeout value for executable to run
                  "%
                  | optional,
                ..
              },
          insert
            | doc m%"
            You can typically use the insert Change Type when you want to add and deploy the specific data or values to the existing table in your database. It can include columns and another attributes listed in this documentation.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columns | definitions.contract.columns | optional,
                dbms | definitions.contract.dbms | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          loadData
            | doc m%"
            Loads data from a CSV file into an existing table when you add it to your changelog.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                column | definitions.contract.column | optional,
                columns | definitions.contract.columns | optional,
                commentLineStartsWith
                  | String
                  | doc m%"
                  Lines starting with this are treated as comment and ignored.
                  "%
                  | optional,
                encoding
                  | String
                  | doc m%"
                  Encoding of the CSV file (defaults to UTF-8).
                  "%
                  | optional,
                file
                  | String
                  | doc m%"
                  CSV file to load.
                  "%,
                quotchar
                  | String
                  | doc m%"
                  The quote character for string fields containing the separator character.
                  "%
                  | optional,
                relativeToChangelogFile
                  | Bool
                  | doc m%"
                  Whether the file path relative to the root changelog file rather than to the classpath.
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                separator
                  | String
                  | doc m%"
                  Character separating the fields.
                  "%
                  | optional,
                tableName | definitions.contract.tableName,
                usePreparedStatements
                  | Bool
                  | doc m%"
                  Use prepared statements instead of insert statement strings if the database supports it.
                  "%
                  | optional,
                ..
              },
          loadUpdateData
            | doc m%"
            Loads or updates data from a CSV file into an existing table. Differs from loadData by issuing a SQL batch that checks for the existence of a record. If found, the record is UPDATEd, else the record is INSERTed. Also, generates DELETE statements for a rollback.
            
            A value of NULL in a cell will be converted to a database NULL rather than the string 'NULL'
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                column | definitions.contract.column | optional,
                columns | definitions.contract.columns | optional,
                commentLineStartsWith
                  | String
                  | doc m%"
                  Lines starting with this are treated as comment and ignored.
                  "%
                  | optional,
                encoding
                  | String
                  | doc m%"
                  Encoding of the CSV file (defaults to UTF-8)
                  "%
                  | optional,
                file
                  | String
                  | doc m%"
                  CSV file to load
                  "%,
                onlyUpdate
                  | Bool
                  | doc m%"
                  If true, records with no matching database record should be ignored
                  "%
                  | optional,
                primaryKey
                  | String
                  | doc m%"
                  Comma delimited list of the columns for the primary key
                  "%,
                quotchar
                  | String
                  | doc m%"
                  The quote character for string fields containing the separator character.
                  "%
                  | optional,
                relativeToChangelogFile
                  | Bool
                  | doc m%"
                  Whether the file path relative to the root changelog file rather than to the classpath.
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                separator
                  | String
                  | doc m%"
                  Character separating the fields.
                  "%
                  | optional,
                tableName | definitions.contract.tableName,
                usePreparedStatements
                  | Bool
                  | doc m%"
                  Use prepared statements instead of insert statement strings if the DB supports it.
                  "%
                  | optional,
                ..
              },
          mergeColumns
            | doc m%"
            The mergeColumns Change Type concatenates the values in two columns and joins them with a string. The Change Type stores the resulting value in a new column.
            You can typically use the mergeColumns Change Type when you want to combine the values from two columns into one.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                column1Name
                  | String
                  | doc m%"
                  The name of the column containing the first half of the data
                  "%,
                column2Name
                  | String
                  | doc m%"
                  The name of the column containing the second half of the data
                  "%,
                finalColumnName
                  | String
                  | doc m%"
                  The name of the column to create
                  "%,
                finalColumnType
                  | String
                  | doc m%"
                  The data type of the column to create
                  "%,
                joinString
                  | String
                  | doc m%"
                  The string to place between the values from column1 and column2 (may be empty)
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          modifyDataType
            | doc m%"
            Allows you to modify data types.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columnName
                  | String
                  | doc m%"
                  Name of the column
                  "%,
                newDataType | String,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          modifySql
            | doc m%"
            Although Liquibase supports most standard SQL statements with its Change Types, there are times when you need the generated SQL to be different. The following examples show how to change data types or add additional vendor-specific clauses such as ENGINE INNODB to CREATE TABLE statements. Since 1.9
            "%
            = {
                append
                  | { value | String | optional, .. }
                  | doc m%"
                  Adds SQL to the end of the statement.
                  "%
                  | optional,
                applyToRollback
                  | Bool
                  | doc m%"
                  Defines whether the SQL modification should be applied to rollback statements. The default value is false. Since 2.0
                  "%
                  | optional,
                context
                  | String
                  | doc m%"
                  Specifies the list of Contexts in which to run the SQL modification. If you do not specify any context, every changeset will be applied. Since 2.0
                  "%
                  | optional,
                dbms | definitions.contract.dbms | optional,
                labels | String | optional,
                prepend
                  | { value | String | optional, .. }
                  | doc m%"
                  Adds SQL to the beginning of the statement.
                  "%
                  | optional,
                regExpReplace
                  | {
                    replace | String | optional,
                    with | String | optional,
                    ..
                  }
                  | doc m%"
                  Replaces all instances of the regular expression specified.
                  "%
                  | optional,
                replace
                  | {
                    replace | String | optional,
                    with | String | optional,
                    ..
                  }
                  | doc m%"
                  Replaces all instances of the text specified.
                  "%
                  | optional,
                ..
              },
          output
            | doc m%"
            Logs a message and continues execution.
            "%
            = {
                message
                  | String
                  | doc m%"
                  Message to output
                  "%
                  | optional,
                target
                  | predicates.contract_from_predicate
                  (predicates.enum
                  [ "STDOUT", "STDERR", "FATAL", "WARN", "INFO", "DEBUG" ])
                  | doc m%"
                  Target for message. Possible values: STDOUT, STDERR, FATAL, WARN, INFO, DEBUG. Default value: STDERR
                  "%
                  | optional,
                ..
              },
          preConditions
            | doc m%"
            Preconditions are changelog or changeset tags which control the execution of an update based on the state of the database.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.preConditions,
          remarks
            | doc m%"
            The comments stored for the table/view/column
            "%
            = String,
          renameColumn
            | doc m%"
            Renames an existing column.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columnDataType
                  | String
                  | doc m%"
                  Data type of the column
                  "%
                  | optional,
                newColumnName
                  | String
                  | doc m%"
                  Name to rename the column to
                  "%,
                oldColumnName
                  | String
                  | doc m%"
                  Name of the existing column to rename
                  "%,
                remarks
                  | String
                  | doc m%"
                  Remarks of the column
                  "%
                  | optional,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          renameSequence
            | doc m%"
            Renames an existing sequence.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                newSequenceName
                  | String
                  | doc m%"
                  New name for the sequence
                  "%,
                oldSequenceName
                  | String
                  | doc m%"
                  Name of the sequence to rename
                  "%,
                schemaName | definitions.contract.schemaName | optional,
                ..
              },
          renameTable
            | doc m%"
            Renames an existing table.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                newTableName
                  | String
                  | doc m%"
                  New name for the table
                  "%,
                oldTableName
                  | String
                  | doc m%"
                  Name of the table to rename
                  "%,
                schemaName | definitions.contract.schemaName | optional,
                ..
              },
          renameView = {
                catalogName | definitions.contract.catalogName | optional,
                newViewName
                  | String
                  | doc m%"
                  Name to rename the view to
                  "%,
                oldViewName
                  | String
                  | doc m%"
                  Name of the view to rename
                  "%,
                schemaName | definitions.contract.schemaName | optional,
                ..
              },
          schemaName
            | doc m%"
            The name of the schema
            "%
            = String,
          setColumnRemarks
            | doc m%"
            The setColumnRemarks Change Type sets remarks on a column.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columnName
                  | String
                  | doc m%"
                  The name of the column
                  "%,
                remarks
                  | String
                  | doc m%"
                  The comment to set on the column
                  "%,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          setTableRemarks
            | doc m%"
            Sets remarks on a table.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                remarks
                  | String
                  | doc m%"
                  Comment to set on the table
                  "%,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                ..
              },
          sql
            | doc m%"
            It is useful for complex changes that aren't supported through Liquibase's automated Change Types and to work around bugs and limitations of Liquibase. The SQL contained in the <SQL> Change Type can be multi-line.
            "%
            = {
                comment | String | optional,
                dbms | definitions.contract.dbms | optional,
                endDelimiter
                  | String
                  | doc m%"
                  Indicates the end of the SQL statement and prevents incomplete SQL statements from being processed when the SQL files contain statements referencing a ; which Liquibase treats as the default end delimiter. You can use the endDelimiter when the changeset contains SQL to create a stored procedure or function that contains the default ; end delimiter to separate the statements inside the procedure.
                  For more information, see The endDelimiter SQL attribute.
                  "%
                  | optional,
                splitStatements
                  | Bool
                  | doc m%"
                  Set to false to not have Liquibase split statements on ;'s and GO's. Defaults to true if not set
                  "%
                  | optional,
                sql
                  | String
                  | doc m%"
                  Specifies the SQL to execute
                  "%,
                stripComments
                  | Bool
                  | doc m%"
                  Set to true to remove any comments in the SQL before executing, otherwise false.
                  "%
                  | optional,
                ..
              },
          sqlFile
            | doc m%"
            The <sqlFile> Change Type is useful for complex changes that are not supported through Liquibase automated Change Types such as stored procedures. The SQL contained in the <sqlFile> Change Type can be multi-line.
            "%
            = {
                comment | String | optional,
                dbms | definitions.contract.dbms | optional,
                encoding
                  | String
                  | doc m%"
                  Specifies encoding used in the file defined in the `path` attribute.
                  "%
                  | optional,
                endDelimiter
                  | String
                  | doc m%"
                  Indicates the end of the SQL statement and prevents incomplete SQL statements from being processed when the SQL files contain statements referencing a ; which Liquibase treats as the default end delimiter. You can use the endDelimiter when the changeset contains SQL to create a stored procedure or function that contains the default ; end delimiter to separate the statements inside the procedure.
                  For more information, see The endDelimiter SQL attribute.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  Specifies the file path of the SQL file to load.
                  "%,
                relativeToChangelogFile
                  | Bool
                  | doc m%"
                  Indicates whether the file path is relative to the root changelog file rather than to the classpath.
                  "%
                  | optional,
                splitStatements
                  | Bool
                  | doc m%"
                  Set to false to not have Liquibase split statements on ;'s and GO's. Defaults to true if not set.
                  "%
                  | optional,
                stripComments
                  | Bool
                  | doc m%"
                  Set to true to remove any comments in the SQL before executing, otherwise false.
                  "%
                  | optional,
                ..
              },
          stop
            | doc m%"
            Stops Liquibase execution with a message. Mainly useful for debugging and stepping through a changelog
            "%
            = {
                message
                  | String
                  | doc m%"
                  Message to output when execution stops
                  "%
                  | optional,
                ..
              },
          tableName
            | doc m%"
            The name of the table
            "%
            = String,
          tagDatabase
            | doc m%"
            The tagDatabase Change Type applies a tag to the database for future update or rollback.
            "%
            = {
                tag
                  | String
                  | doc m%"
                  The tag to apply
                  "%,
                ..
              },
          update
            | doc m%"
            You can typically use the update Change Type when you want to update a table in your changelog file and then deploy this update to your database. It can include columns and another values listed in this documentation.
            "%
            = {
                catalogName | definitions.contract.catalogName | optional,
                columns | definitions.contract.columns,
                schemaName | definitions.contract.schemaName | optional,
                tableName | definitions.contract.tableName,
                where | definitions.contract.where | optional,
                whereParams | definitions.contract.whereParams | optional,
                ..
              },
          where
            | doc m%"
            Allows to define the 'where' condition(s) string
            "%
            = String,
          whereParams = predicates.contract_from_predicate
              definitions.predicate.whereParams,
        },
    predicate = {
          addAutoIncrement
            | doc m%"
            Converts an existing column to be an auto-increment (a.k.a 'identity') column.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "columnName", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columnDataType = predicates.isType '"String",
                  columnName = predicates.isType '"String",
                  defaultOnNull = predicates.isType '"Bool",
                  generationType = predicates.enum [ "ALWAYS", "BY DEFAULT" ],
                  incrementBy = predicates.isType 'Integer,
                  schemaName = definitions.predicate.schemaName,
                  startWith = predicates.isType 'Integer,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          addColumn
            | doc m%"
            You can typically use the addColumn Change Type when you want to add a new column and deploy it to the table in your database.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "columns", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columns = definitions.predicate.columns,
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          addDefaultValue
            | doc m%"
            The addDefaultValue Change Type adds a default value to the database definition for the specified column.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "columnName", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columnDataType = predicates.isType '"String",
                  columnName = predicates.isType '"String",
                  defaultValue = predicates.isType '"String",
                  defaultValueBoolean = predicates.isType '"Bool",
                  defaultValueComputed = predicates.isType '"String",
                  defaultValueConstraintName = predicates.isType '"String",
                  defaultValueDate = predicates.isType '"String",
                  defaultValueNumeric = predicates.isType '"Number",
                  defaultValueSequenceNext = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          addForeignKeyConstraint
            | doc m%"
            Adds a foreign key constraint to an existing column.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "baseColumnNames",
                  "baseTableName",
                  "constraintName",
                  "referencedColumnNames",
                  "referencedTableName"
                ],
                predicates.records.record
                {
                  baseColumnNames = predicates.isType '"String",
                  baseTableCatalogName = predicates.isType '"String",
                  baseTableName = predicates.isType '"String",
                  baseTableSchemaName = predicates.isType '"String",
                  constraintName = predicates.isType '"String",
                  deferrable = predicates.isType '"Bool",
                  deleteCascade = predicates.isType '"Bool",
                  initiallyDeferred = predicates.isType '"Bool",
                  onDelete = predicates.isType '"String",
                  onUpdate = predicates.isType '"String",
                  referencedColumnNames = predicates.isType '"String",
                  referencedTableCatalogName = predicates.isType '"String",
                  referencedTableName = predicates.isType '"String",
                  referencedTableSchemaName = predicates.isType '"String",
                  referencesUniqueColumn = predicates.isType '"Bool",
                  validate = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          addLookupTable
            | doc m%"
            Creates a lookup table containing values stored in a column and creates a foreign key to the new table.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "existingColumnName",
                  "existingTableName",
                  "newColumnName",
                  "newTableName"
                ],
                predicates.records.record
                {
                  constraintName = predicates.isType '"String",
                  existingColumnName = predicates.isType '"String",
                  existingTableCatalogName = predicates.isType '"String",
                  existingTableName = predicates.isType '"String",
                  existingTableSchemaName = predicates.isType '"String",
                  newColumnDataType = predicates.isType '"String",
                  newColumnName = predicates.isType '"String",
                  newTableCatalogName = predicates.isType '"String",
                  newTableName = predicates.isType '"String",
                  newTableSchemaName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          addNotNullConstraint
            | doc m%"
            The addNotNullConstraint Change Type adds a NOT NULL constraint to an existing table.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "columnName", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columnDataType = predicates.isType '"String",
                  columnName = predicates.isType '"String",
                  constraintName = predicates.isType '"String",
                  defaultNullValue = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                  validate = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          addPrimaryKey
            | doc m%"
            Adds a primary key out of an existing column or set of columns.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "columnNames", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  clustered = predicates.isType '"Bool",
                  columnNames = predicates.isType '"String",
                  constraintName = predicates.isType '"String",
                  forIndexCatalogName = predicates.isType '"String",
                  forIndexName = predicates.isType '"String",
                  forIndexSchemaName = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                  tablespace = predicates.isType '"String",
                  validate = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          addUniqueConstraint
            | doc m%"
            Adds a unique constraint to an existing column or set of columns.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "columnNames", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  clustered = predicates.isType '"Bool",
                  columnNames = predicates.isType '"String",
                  constraintName = predicates.isType '"String",
                  deferrable = predicates.isType '"Bool",
                  disabled = predicates.isType '"Bool",
                  forIndexCatalogName = predicates.isType '"String",
                  forIndexName = predicates.isType '"String",
                  forIndexSchemaName = predicates.isType '"String",
                  initiallyDeferred = predicates.isType '"Bool",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                  tablespace = predicates.isType '"String",
                  validate = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          alterSequence
            | doc m%"
            Alters properties of an existing sequence.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "sequenceName" ],
                predicates.records.record
                {
                  cacheSize = predicates.isType 'Integer,
                  catalogName = definitions.predicate.catalogName,
                  cycle = predicates.isType '"Bool",
                  dataType = predicates.isType '"String",
                  incrementBy = predicates.isType 'Integer,
                  maxValue = predicates.isType 'Integer,
                  minValue = predicates.isType 'Integer,
                  ordered = predicates.isType '"Bool",
                  schemaName = definitions.predicate.schemaName,
                  sequenceName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          catalogName
            | doc m%"
            The name of the catalog
            "%
            = predicates.isType '"String",
          changes = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    addAutoIncrement = definitions.predicate.addAutoIncrement,
                    addColumn = definitions.predicate.addColumn,
                    addDefaultValue = definitions.predicate.addDefaultValue,
                    addForeignKeyConstraint =
                      definitions.predicate.addForeignKeyConstraint,
                    addLookupTable = definitions.predicate.addLookupTable,
                    addNotNullConstraint =
                      definitions.predicate.addNotNullConstraint,
                    addPrimaryKey = definitions.predicate.addPrimaryKey,
                    addUniqueConstraint =
                      definitions.predicate.addUniqueConstraint,
                    alterSequence = definitions.predicate.alterSequence,
                    createIndex = definitions.predicate.createIndex,
                    createProcedure = definitions.predicate.createProcedure,
                    createSequence = definitions.predicate.createSequence,
                    createTable = definitions.predicate.createTable,
                    createView = definitions.predicate.createView,
                    customChange = definitions.predicate.customChange,
                    delete = definitions.predicate.delete,
                    dropAllForeignKeyConstraints =
                      definitions.predicate.dropAllForeignKeyConstraints,
                    dropColumn = definitions.predicate.dropColumn,
                    dropDefaultValue = definitions.predicate.dropDefaultValue,
                    dropForeignKeyConstraint =
                      definitions.predicate.dropForeignKeyConstraint,
                    dropIndex = definitions.predicate.dropIndex,
                    dropNotNullConstraint =
                      definitions.predicate.dropNotNullConstraint,
                    dropPrimaryKey = definitions.predicate.dropPrimaryKey,
                    dropProcedure = definitions.predicate.dropProcedure,
                    dropSequence = definitions.predicate.dropSequence,
                    dropTable = definitions.predicate.dropTable,
                    dropUniqueConstraint =
                      definitions.predicate.dropUniqueConstraint,
                    dropView = definitions.predicate.dropView,
                    empty = definitions.predicate.empty,
                    executeCommand = definitions.predicate.executeCommand,
                    insert = definitions.predicate.insert,
                    loadData = definitions.predicate.loadData,
                    loadUpdateData = definitions.predicate.loadUpdateData,
                    mergeColumns = definitions.predicate.mergeColumns,
                    modifyDataType = definitions.predicate.modifyDataType,
                    modifySql = definitions.predicate.modifySql,
                    output = definitions.predicate.output,
                    renameColumn = definitions.predicate.renameColumn,
                    renameSequence = definitions.predicate.renameSequence,
                    renameTable = definitions.predicate.renameTable,
                    renameView = definitions.predicate.renameView,
                    setColumnRemarks = definitions.predicate.setColumnRemarks,
                    setTableRemarks = definitions.predicate.setTableRemarks,
                    sql = definitions.predicate.sql,
                    sqlFile = definitions.predicate.sqlFile,
                    stop = definitions.predicate.stop,
                    tagDatabase = definitions.predicate.tagDatabase,
                    update = definitions.predicate.update,
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          column = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  afterColumn = predicates.isType '"String",
                  autoIncrement = predicates.isType '"Bool",
                  beforeColumn = predicates.isType '"String",
                  computed = predicates.isType '"Bool",
                  constraints = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          checkConstraint = predicates.isType '"String",
                          deferrable = predicates.isType '"Bool",
                          deleteCascade = predicates.isType '"Bool",
                          foreignKeyName = predicates.isType '"String",
                          initiallyDeferred = predicates.isType '"Bool",
                          notNullConstraintName = predicates.isType '"String",
                          nullable = predicates.isType '"Bool",
                          primaryKey = predicates.isType '"Bool",
                          primaryKeyName = predicates.isType '"String",
                          primaryKeyTablespace = predicates.isType '"String",
                          referencedColumnNames = predicates.isType '"String",
                          referencedTableCatalogName = predicates.isType
                              '"String",
                          referencedTableName = predicates.isType '"String",
                          referencedTableSchemaName = predicates.isType
                              '"String",
                          references = predicates.isType '"String",
                          unique = predicates.isType '"Bool",
                          uniqueConstraintName = predicates.isType '"String",
                          validateForeignKey = predicates.isType '"Bool",
                          validateNullable = predicates.isType '"Bool",
                          validatePrimaryKey = predicates.isType '"Bool",
                          validateUnique = predicates.isType '"Bool",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  defaultOnNull = predicates.isType '"Bool",
                  defaultValue = predicates.isType '"String",
                  defaultValueBoolean = predicates.isType '"Bool",
                  defaultValueComputed = predicates.isType '"String",
                  defaultValueConstraintName = predicates.isType '"String",
                  defaultValueDate = predicates.isType '"String",
                  defaultValueNumeric = predicates.isType '"Number",
                  defaultValueSequenceCurrent = predicates.isType '"String",
                  defaultValueSequenceNext = predicates.isType '"String",
                  descending = predicates.isType '"Bool",
                  encoding = predicates.isType '"String",
                  generationType = predicates.isType '"String",
                  header = predicates.isType '"String",
                  incrementBy = predicates.isType 'Integer,
                  index = predicates.isType 'Integer,
                  name = predicates.isType '"String",
                  position = predicates.isType '"Number",
                  remarks = predicates.isType '"String",
                  startWith = predicates.isType 'Integer,
                  type = predicates.isType '"String",
                  value = predicates.isType '"String",
                  valueBlobFile = predicates.isType '"String",
                  valueBoolean = predicates.isType '"Bool",
                  valueClobFile = predicates.isType '"String",
                  valueComputed = predicates.isType '"String",
                  valueDate = predicates.isType '"String",
                  valueNumeric = predicates.isType '"Number",
                  valueSequenceCurrent = predicates.isType '"String",
                  valueSequenceNext = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          columns
            | doc m%"
            The column constraint and foreign key information. Setting the defaultValue attribute will specify a default value for the column. Setting the value attribute will set all rows existing to the specified value without modifying the column default.
            See Information about the <column> tag section for more information.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    column = definitions.predicate.column,
                    modifySql = definitions.predicate.modifySql,
                  }
                  {  }
                  true
                  predicates.always
                ]),
                predicates.arrays.minItems 1
              ],
          createIndex
            | doc m%"
            The createIndex Change Type creates an index on an existing column or a set of columns.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tableName" ],
                predicates.records.record
                {
                  associatedWith = predicates.isType '"String",
                  catalogName = definitions.predicate.catalogName,
                  clustered = predicates.isType '"Bool",
                  column = definitions.predicate.column,
                  columns = definitions.predicate.columns,
                  indexName = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                  tablespace = predicates.isType '"String",
                  unique = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          createProcedure
            | doc m%"
            The createProcedure Change Type defines the definition for a stored procedure. This Change Type is better to use for creating procedures than the raw SQL command because it will not attempt to strip comments or break up lines.
            
            Often times it is best to use the CREATE OR REPLACE syntax along with setting runOnChange='true' on the enclosing changeset tag. That way if you need to make a change to your procedure, you can change your existing code rather than creating a new REPLACE PROCEDURE call. The advantage to this approach is that it keeps your changelog smaller and allows you to more easily see what has changed in your procedure code through your source control system's diff command.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path", "procedureText" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  comments = predicates.isType '"String",
                  dbms = definitions.predicate.dbms,
                  encoding = predicates.isType '"String",
                  path = predicates.isType '"String",
                  procedureName = predicates.isType '"String",
                  procedureText = predicates.isType '"String",
                  relativeToChangelogFile = predicates.isType '"Bool",
                  replaceIfExists = predicates.isType '"Bool",
                  schemaName = definitions.predicate.schemaName,
                }
                {  }
                true
                predicates.always
              ],
          createSequence
            | doc m%"
            Creates a new database sequence.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "sequenceName" ],
                predicates.records.record
                {
                  cacheSize = predicates.isType 'Integer,
                  catalogName = definitions.predicate.catalogName,
                  cycle = predicates.isType '"Bool",
                  dataType = predicates.isType '"String",
                  incrementBy = predicates.isType 'Integer,
                  maxValue = predicates.isType 'Integer,
                  minValue = predicates.isType 'Integer,
                  ordered = predicates.isType '"Bool",
                  schemaName = definitions.predicate.schemaName,
                  sequenceName = predicates.isType '"String",
                  startValue = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          createTable
            | doc m%"
            You can typically use the createTable Change Type when you want to create a table in your changelog file and then deploy it to your database. It can include columns and another values listed in this documentation.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "columns", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columns = definitions.predicate.columns,
                  remarks = definitions.predicate.remarks,
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                  tablespace = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          createView
            | doc m%"
            Creates a new database view.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  encoding = predicates.isType '"String",
                  fullDefinition = predicates.isType '"Bool",
                  path = predicates.isType '"String",
                  relativeToChangelogFile = predicates.isType '"Bool",
                  remarks = definitions.predicate.remarks,
                  replaceIfExists = predicates.isType '"Bool",
                  schemaName = definitions.predicate.schemaName,
                  selectQuery = predicates.isType '"String",
                  viewName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          customChange
            | doc m%"
            The customChange type creates a custom Change Type class.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "class" ],
                predicates.records.record
                { class = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          dbms
            | doc m%"
            Specifies logical expression of database type(s) on which the change must be applied. Valid database type names are listed on the supported databases page. It can be a comma-separated list of multiple databases or you can also specify that a change is not applicable to a particular database type by prefixing with !. The keywords all and none are also available.
            "%
            = predicates.isType '"String",
          delete
            | doc m%"
            Deletes data from an existing table.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                  where = definitions.predicate.where,
                  whereParams = definitions.predicate.whereParams,
                }
                {  }
                true
                predicates.always
              ],
          dropAllForeignKeyConstraints
            | doc m%"
            Drops all foreign key constraints for a table.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "baseTableName" ],
                predicates.records.record
                {
                  baseTableCatalogName = predicates.isType '"String",
                  baseTableName = predicates.isType '"String",
                  baseTableSchemaName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dropColumn
            | doc m%"
            Drops an existing column(s).
            
            To drop a single column, use the simple form of this element where the tableName and columnName are specified as attributes. To drop several columns, specify the tableName as an attribute, and then specify a set of nested <column> tags. If nested <column> tags are present, the columnName attribute will be ignored.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columnName = predicates.isType '"String",
                  columns = definitions.predicate.columns,
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          dropDefaultValue
            | doc m%"
            Removes the database default value for a column.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "columnName", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columnDataType = predicates.isType '"String",
                  columnName = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          dropForeignKeyConstraint
            | doc m%"
            Drops an existing foreign key.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "baseTableName", "constraintName" ],
                predicates.records.record
                {
                  baseTableCatalogName = predicates.isType '"String",
                  baseTableName = predicates.isType '"String",
                  baseTableSchemaName = predicates.isType '"String",
                  constraintName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dropIndex
            | doc m%"
            The dropIndex Change Type drops an existing index on a column.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "indexName" ],
                predicates.records.record
                {
                  associatedWith = predicates.isType '"String",
                  catalogName = definitions.predicate.catalogName,
                  indexName = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          dropNotNullConstraint
            | doc m%"
            Makes a column nullable.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "columnName", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columnDataType = predicates.isType '"String",
                  columnName = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          dropPrimaryKey
            | doc m%"
            The dropPrimaryKey Change Type drops an existing primary key in the table.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  constraintName = predicates.isType '"String",
                  dropIndex = predicates.isType '"Bool",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          dropProcedure
            | doc m%"
            Drops an existing procedure
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "procedureName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  procedureName = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                }
                {  }
                true
                predicates.always
              ],
          dropSequence
            | doc m%"
            Drops an existing sequence.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "sequenceName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  schemaName = definitions.predicate.schemaName,
                  sequenceName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dropTable
            | doc m%"
            Drops an existing table from your database.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tableName" ],
                predicates.records.record
                {
                  cascadeConstraints = predicates.isType '"Bool",
                  catalogName = definitions.predicate.catalogName,
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          dropUniqueConstraint
            | doc m%"
            Drops an existing unique constraint.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "constraintName", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  constraintName = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                  uniqueColumns = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dropView
            | doc m%"
            Drops an existing view.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "viewName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  schemaName = definitions.predicate.schemaName,
                  viewName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          empty
            | doc m%"
            empty
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true predicates.always
              ],
          executeCommand
            | doc m%"
            The executeCommand Change Type executes a system command.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "executable" ],
                predicates.records.record
                {
                  arg = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { value = predicates.isType '"String", }
                        {  }
                        true
                        predicates.always
                      ],
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { value = predicates.isType '"String", }
                          {  }
                          true
                          predicates.always
                        ])
                      ],
                  executable = predicates.isType '"String",
                  os = predicates.isType '"String",
                  timeout = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          insert
            | doc m%"
            You can typically use the insert Change Type when you want to add and deploy the specific data or values to the existing table in your database. It can include columns and another attributes listed in this documentation.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columns = definitions.predicate.columns,
                  dbms = definitions.predicate.dbms,
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          loadData
            | doc m%"
            Loads data from a CSV file into an existing table when you add it to your changelog.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "file", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  column = definitions.predicate.column,
                  columns = definitions.predicate.columns,
                  commentLineStartsWith = predicates.isType '"String",
                  encoding = predicates.isType '"String",
                  file = predicates.isType '"String",
                  quotchar = predicates.isType '"String",
                  relativeToChangelogFile = predicates.isType '"Bool",
                  schemaName = definitions.predicate.schemaName,
                  separator = predicates.isType '"String",
                  tableName = definitions.predicate.tableName,
                  usePreparedStatements = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          loadUpdateData
            | doc m%"
            Loads or updates data from a CSV file into an existing table. Differs from loadData by issuing a SQL batch that checks for the existence of a record. If found, the record is UPDATEd, else the record is INSERTed. Also, generates DELETE statements for a rollback.
            
            A value of NULL in a cell will be converted to a database NULL rather than the string 'NULL'
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "file", "primaryKey", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  column = definitions.predicate.column,
                  columns = definitions.predicate.columns,
                  commentLineStartsWith = predicates.isType '"String",
                  encoding = predicates.isType '"String",
                  file = predicates.isType '"String",
                  onlyUpdate = predicates.isType '"Bool",
                  primaryKey = predicates.isType '"String",
                  quotchar = predicates.isType '"String",
                  relativeToChangelogFile = predicates.isType '"Bool",
                  schemaName = definitions.predicate.schemaName,
                  separator = predicates.isType '"String",
                  tableName = definitions.predicate.tableName,
                  usePreparedStatements = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          mergeColumns
            | doc m%"
            The mergeColumns Change Type concatenates the values in two columns and joins them with a string. The Change Type stores the resulting value in a new column.
            You can typically use the mergeColumns Change Type when you want to combine the values from two columns into one.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "column1Name",
                  "column2Name",
                  "finalColumnName",
                  "finalColumnType",
                  "tableName"
                ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  column1Name = predicates.isType '"String",
                  column2Name = predicates.isType '"String",
                  finalColumnName = predicates.isType '"String",
                  finalColumnType = predicates.isType '"String",
                  joinString = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          modifyDataType
            | doc m%"
            Allows you to modify data types.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "columnName", "newDataType", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columnName = predicates.isType '"String",
                  newDataType = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          modifySql
            | doc m%"
            Although Liquibase supports most standard SQL statements with its Change Types, there are times when you need the generated SQL to be different. The following examples show how to change data types or add additional vendor-specific clauses such as ENGINE INNODB to CREATE TABLE statements. Since 1.9
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  append = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { value = predicates.isType '"String", }
                        {  }
                        true
                        predicates.always
                      ],
                  applyToRollback = predicates.isType '"Bool",
                  context = predicates.isType '"String",
                  dbms = definitions.predicate.dbms,
                  labels = predicates.isType '"String",
                  prepend = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { value = predicates.isType '"String", }
                        {  }
                        true
                        predicates.always
                      ],
                  regExpReplace = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          replace = predicates.isType '"String",
                          with = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  replace = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          replace = predicates.isType '"String",
                          with = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          output
            | doc m%"
            Logs a message and continues execution.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  message = predicates.isType '"String",
                  target = predicates.enum
                      [ "STDOUT", "STDERR", "FATAL", "WARN", "INFO", "DEBUG" ],
                }
                {  }
                true
                predicates.always
              ],
          preConditions
            | doc m%"
            Preconditions are changelog or changeset tags which control the execution of an update based on the state of the database.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    and = definitions.predicate.preConditions,
                    changeLogPropertyDefined = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "property" ],
                          predicates.records.record
                          {
                            property = predicates.isType '"String",
                            value = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    changeSetExecuted = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "author", "changeLogFile", "id" ],
                          predicates.records.record
                          {
                            author = predicates.isType '"String",
                            changeLogFile = predicates.isType '"String",
                            id = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    columnExists = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "columnName", "tableName" ],
                          predicates.records.record
                          {
                            columnName = predicates.isType '"String",
                            schemaName = predicates.isType '"String",
                            tableName = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    customPrecondition = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "className" ],
                          predicates.records.record
                          { className = predicates.isType '"String", }
                          {  }
                          true
                          predicates.always
                        ],
                    dbms = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "type" ],
                          predicates.records.record
                          { type = predicates.isType '"String", }
                          {  }
                          true
                          predicates.always
                        ],
                    foreignKeyConstraintExists = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "foreignKeyName" ],
                          predicates.records.record
                          {
                            foreignKeyName = predicates.isType '"String",
                            schemaName = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    indexExists = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            columnName = predicates.isType '"String",
                            indexName = predicates.isType '"String",
                            schemaName = predicates.isType '"String",
                            tableName = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    not = definitions.predicate.preConditions,
                    onError = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.oneOf
                          [
                            predicates.const "HALT",
                            predicates.const "CONTINUE",
                            predicates.const "MARK_RAN",
                            predicates.const "WARN"
                          ]
                        ],
                    onErrorMessage = predicates.isType '"String",
                    onFail = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.oneOf
                          [
                            predicates.const "HALT",
                            predicates.const "CONTINUE",
                            predicates.const "MARK_RAN",
                            predicates.const "WARN"
                          ]
                        ],
                    onFailMessage = predicates.isType '"String",
                    onSqlOutput = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.oneOf
                          [
                            predicates.const "TEST",
                            predicates.const "FAIL",
                            predicates.const "IGNORE"
                          ]
                        ],
                    or = definitions.predicate.preConditions,
                    primaryKeyExists = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            primaryKeyName = predicates.isType '"String",
                            schemaName = predicates.isType '"String",
                            tableName = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    runningAs = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "username" ],
                          predicates.records.record
                          { username = predicates.isType '"String", }
                          {  }
                          true
                          predicates.always
                        ],
                    sequenceExists = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "sequenceName" ],
                          predicates.records.record
                          {
                            schemaName = predicates.isType '"String",
                            sequenceName = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    sqlCheck = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "expectedResult" ],
                          predicates.records.record
                          {
                            expectedResult = predicates.isType 'Integer,
                            sql = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    tableExists = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "tableName" ],
                          predicates.records.record
                          {
                            schemaName = predicates.isType '"String",
                            tableName = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                    viewExists = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "viewName" ],
                          predicates.records.record
                          {
                            schemaName = predicates.isType '"String",
                            viewName = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          remarks
            | doc m%"
            The comments stored for the table/view/column
            "%
            = predicates.isType '"String",
          renameColumn
            | doc m%"
            Renames an existing column.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "newColumnName", "oldColumnName", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columnDataType = predicates.isType '"String",
                  newColumnName = predicates.isType '"String",
                  oldColumnName = predicates.isType '"String",
                  remarks = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          renameSequence
            | doc m%"
            Renames an existing sequence.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "newSequenceName", "oldSequenceName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  newSequenceName = predicates.isType '"String",
                  oldSequenceName = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                }
                {  }
                true
                predicates.always
              ],
          renameTable
            | doc m%"
            Renames an existing table.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "newTableName", "oldTableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  newTableName = predicates.isType '"String",
                  oldTableName = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                }
                {  }
                true
                predicates.always
              ],
          renameView = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "newViewName", "oldViewName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  newViewName = predicates.isType '"String",
                  oldViewName = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                }
                {  }
                true
                predicates.always
              ],
          schemaName
            | doc m%"
            The name of the schema
            "%
            = predicates.isType '"String",
          setColumnRemarks
            | doc m%"
            The setColumnRemarks Change Type sets remarks on a column.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "columnName", "remarks", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columnName = predicates.isType '"String",
                  remarks = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          setTableRemarks
            | doc m%"
            Sets remarks on a table.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "remarks", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  remarks = predicates.isType '"String",
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                }
                {  }
                true
                predicates.always
              ],
          sql
            | doc m%"
            It is useful for complex changes that aren't supported through Liquibase's automated Change Types and to work around bugs and limitations of Liquibase. The SQL contained in the <SQL> Change Type can be multi-line.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "sql" ],
                predicates.records.record
                {
                  comment = predicates.isType '"String",
                  dbms = definitions.predicate.dbms,
                  endDelimiter = predicates.isType '"String",
                  splitStatements = predicates.isType '"Bool",
                  sql = predicates.isType '"String",
                  stripComments = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          sqlFile
            | doc m%"
            The <sqlFile> Change Type is useful for complex changes that are not supported through Liquibase automated Change Types such as stored procedures. The SQL contained in the <sqlFile> Change Type can be multi-line.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  comment = predicates.isType '"String",
                  dbms = definitions.predicate.dbms,
                  encoding = predicates.isType '"String",
                  endDelimiter = predicates.isType '"String",
                  path = predicates.isType '"String",
                  relativeToChangelogFile = predicates.isType '"Bool",
                  splitStatements = predicates.isType '"Bool",
                  stripComments = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          stop
            | doc m%"
            Stops Liquibase execution with a message. Mainly useful for debugging and stepping through a changelog
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { message = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          tableName
            | doc m%"
            The name of the table
            "%
            = predicates.isType '"String",
          tagDatabase
            | doc m%"
            The tagDatabase Change Type applies a tag to the database for future update or rollback.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tag" ],
                predicates.records.record { tag = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          update
            | doc m%"
            You can typically use the update Change Type when you want to update a table in your changelog file and then deploy this update to your database. It can include columns and another values listed in this documentation.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "columns", "tableName" ],
                predicates.records.record
                {
                  catalogName = definitions.predicate.catalogName,
                  columns = definitions.predicate.columns,
                  schemaName = definitions.predicate.schemaName,
                  tableName = definitions.predicate.tableName,
                  where = definitions.predicate.where,
                  whereParams = definitions.predicate.whereParams,
                }
                {  }
                true
                predicates.always
              ],
          where
            | doc m%"
            Allows to define the 'where' condition(s) string
            "%
            = predicates.isType '"String",
          whereParams = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    param = predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            name = predicates.isType '"String",
                            value = predicates.isType '"String",
                            valueBoolean = predicates.isType '"Bool",
                            valueComputed = predicates.isType '"String",
                            valueDate = predicates.isType '"String",
                            valueNumeric = predicates.isType '"Number",
                            valueSequenceCurrent = predicates.isType '"String",
                            valueSequenceNext = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
        },
  }
in

{
  databaseChangeLog
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
          changeSet = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "author", "id" ],
                predicates.records.record
                {
                  author = predicates.isType '"String",
                  changes = definitions.predicate.changes,
                  comment = predicates.isType '"String",
                  context = predicates.isType '"String",
                  created = predicates.isType '"String",
                  dbms = definitions.predicate.dbms,
                  failOnError = predicates.isType '"Bool",
                  id = predicates.isType '"String",
                  ignore = predicates.isType '"Bool",
                  labels = predicates.isType '"String",
                  logicalFilePath = predicates.isType '"String",
                  modifySql = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.modifySql
                      ],
                  objectQuotingStrategy = predicates.isType '"String",
                  onValidationFail = predicates.isType '"String",
                  preConditions = definitions.predicate.preConditions,
                  rollback = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } false
                          predicates.never
                        ],
                        definitions.predicate.changes,
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "changeSetAuthor", "changeSetId" ],
                          predicates.records.record
                          {
                            changeSetAuthor = predicates.isType '"String",
                            changeSetId = predicates.isType '"String",
                            changeSetPath = predicates.isType '"String",
                          }
                          {  }
                          true
                          predicates.always
                        ]
                      ],
                  runAlways = predicates.isType '"Bool",
                  runInTransaction = predicates.isType '"Bool",
                  runOnChange = predicates.isType '"Bool",
                  runOrder = predicates.isType '"String",
                  runWith = predicates.isType '"String",
                  validCheckSum = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          context = predicates.isType '"String",
          include = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  author = predicates.isType '"String",
                  context = predicates.isType '"String",
                  created = predicates.isType '"String",
                  file = predicates.isType '"String",
                  id = predicates.isType '"String",
                  ignore = predicates.isType '"String",
                  labels = predicates.isType '"String",
                  relativeToChangelogFile = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          includeAll = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  context = predicates.isType '"String",
                  errorIfMissingOrEmpty = predicates.isType '"Bool",
                  filter = predicates.isType '"String",
                  path = predicates.isType '"String",
                  relativeToChangelogFile = predicates.isType '"Bool",
                  resourceComparator = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          logicalFilePath = predicates.isType '"String",
          objectQuotingStrategy = predicates.isType '"String",
          preConditions = definitions.predicate.preConditions,
          property = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  context = predicates.isType '"String",
                  dbms = definitions.predicate.dbms,
                  file = predicates.isType '"String",
                  global = predicates.isType '"Bool",
                  labels = predicates.isType '"String",
                  name = predicates.isType '"String",
                  target = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
        }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    The root of all Liquibase changes is the changelog file. Liquibase uses a changelog to sequentially list all changes made to your database. Think of it as a ledger. It is a file that contains a record of all your database changes (changesets). Liquibase uses this changelog record to audit your database and execute any changes that are not yet applied to your database.
    "%,
  ..
}