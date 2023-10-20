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
          "components:bin" = predicates.contract_from_predicate
              definitions.predicate."components:bin",
          "components:opt" = predicates.contract_from_predicate
              definitions.predicate."components:opt",
          "components:schemas" = {
                lsp
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^(vscode:)?https://"
                  ])
                  | doc m%"
                  A URL to where the LSP JSON schema can be downloaded from. If the provided URL is a VSCode package.json you MUST prefix the url with vscode:
                  "%
                  | optional,
              },
          "components:share" = predicates.contract_from_predicate
              definitions.predicate."components:share",
          "components:source" = predicates.contract_from_predicate
              definitions.predicate."components:source",
          "components:sources:build" = {
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { "^[A-Z0-9_]+$" = predicates.isType '"String", }
                    false
                    predicates.never
                  ])
                  | optional,
                run
                  | String
                  | doc m%"
                  The shell script to run. Platform sensitive (bash on Unix, powershell on Windows).
                  "%,
                staged
                  | Bool
                  | doc m%"
                  Whether to run the build script in a staging location (defaults to true).
                  "%
                  | optional,
                target
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."enums:platform"
                    ],
                    definitions.predicate."enums:platform"
                  ])
                  | optional,
                ..
              },
          "components:sources:cargo" = {
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^pkg:cargo/.+@.+"
                  ]),
                supported_platforms
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."enums:platform"
                  ])
                  | doc m%"
                  List of platforms supported by the cargo package.
                  "%
                  | optional,
              },
          "components:sources:composer" = {
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^pkg:composer/.+/.+@.+"
                  ]),
              },
          "components:sources:gem" = {
                extra_packages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Extra gem packages required by the main package to function.
                  "%
                  | optional,
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^pkg:gem/.+@.+"
                  ]),
                supported_platforms
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."enums:platform"
                  ])
                  | doc m%"
                  List of platforms supported by the gem package.
                  "%
                  | optional,
              },
          "components:sources:generic" = predicates.contract_from_predicate
              definitions.predicate."components:sources:generic",
          "components:sources:generic:build" = {
                build
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."components:sources:build"
                    ],
                    definitions.predicate."components:sources:build"
                  ]),
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^pkg:generic/.+@.+"
                  ]),
              },
          "components:sources:generic:download" =
            predicates.contract_from_predicate
              definitions.predicate."components:sources:generic:download",
          "components:sources:github" = predicates.contract_from_predicate
              definitions.predicate."components:sources:github",
          "components:sources:github:build" = {
                build
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."components:sources:build"
                    ],
                    definitions.predicate."components:sources:build"
                  ]),
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^pkg:github/.+/.+@.+"
                  ]),
              },
          "components:sources:github:release" =
            predicates.contract_from_predicate
              definitions.predicate."components:sources:github:release",
          "components:sources:golang" = {
                extra_packages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Extra golang packages required by the main package to function.
                  "%
                  | optional,
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^pkg:golang/.+/.+@.+"
                  ]),
              },
          "components:sources:luarocks" = {
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^pkg:luarocks/.+@.+"
                  ]),
              },
          "components:sources:npm" = {
                extra_packages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Extra npm packages required by the main package to function.
                  "%
                  | optional,
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^pkg:npm/.+@.+"
                  ]),
              },
          "components:sources:nuget" = {
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^pkg:nuget/.+@.+"
                  ]),
              },
          "components:sources:opam" = {
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^pkg:opam/.+@.+"
                  ]),
              },
          "components:sources:pypi" = {
                extra_packages
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Extra pypi packages required by the main package to function.
                  "%
                  | optional,
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^pkg:pypi/.+@.+"
                  ]),
                supported_platforms
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."enums:platform"
                  ])
                  | doc m%"
                  List of platforms supported by the pypi package.
                  "%
                  | optional,
              },
          "enums:category" = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'Runtime, 'Linter, 'LSP, 'Formatter, 'DAP, 'Compiler |]
              ],
          "enums:language" = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'Zsh,
                  'Zig,
                  'YARA,
                  'YAML,
                  'XML,
                  'WGSL,
                  'Vue,
                  'Visualforce,
                  'VimScript,
                  'Veryl,
                  'Vala,
                  'V,
                  'Typst,
                  'TypeScript,
                  'Twig,
                  'Text,
                  'Terraform,
                  'Teal,
                  'TOML,
                  'SystemVerilog,
                  'Svelte,
                  'Stylelint,
                  'Starlark,
                  'Sphinx,
                  'Solidity,
                  'Snakemake,
                  '"Standard ML",
                  'Smithy,
                  'Slint,
                  'Shell,
                  'Sh,
                  'Scala,
                  'Sass,
                  'Salt,
                  'SQL,
                  'SCSS,
                  'Rust,
                  'Ruby,
                  '"Robot Framework",
                  'Reason,
                  'ReScript,
                  'Raku,
                  'R,
                  'Python,
                  'PureScript,
                  'Puppet,
                  'Protobuf,
                  'Progress,
                  'Prisma,
                  'PowerShell,
                  'Perl,
                  'PHP,
                  'OpenSCAD,
                  'OpenFOAM,
                  'OpenEdge,
                  'OpenCL,
                  'OpenAPI,
                  'OneScript,
                  'Odin,
                  'OCaml,
                  'Nunjucks,
                  'Nix,
                  'Nim,
                  'Nickel,
                  'Nginx,
                  'Mustache,
                  'Move,
                  'Mksh,
                  '"Metamath Zero",
                  'Markdown,
                  'Luau,
                  'Lua,
                  'Liquid,
                  'Lelwel,
                  'LaTeX,
                  'LESS,
                  'Ksh,
                  'Kotlin,
                  'Julia,
                  'Jsonnet,
                  'Jq,
                  'Jinja,
                  'JavaScript,
                  'Java,
                  'JSX,
                  'JSON,
                  'Hoon,
                  'Helm,
                  'Haxe,
                  'Haskell,
                  'Handlebars,
                  'Handlebargs,
                  'HTML,
                  'HAML,
                  'Groovy,
                  'GraphQL,
                  'Gradle,
                  'Go,
                  'Glimmer,
                  'Gleam,
                  'Fortran,
                  'Flux,
                  'Flow,
                  'Fennel,
                  '"F#",
                  'Erlang,
                  'Erg,
                  'Emmet,
                  'Ember,
                  'Elm,
                  'Elixir,
                  'Drools,
                  'Docker,
                  'Django,
                  'Dhall,
                  'Dart,
                  'DOT,
                  'D,
                  'Cue,
                  'Cucumber,
                  'Csh,
                  'Crystal,
                  'CodeQL,
                  'ClojureScript,
                  'Clojure,
                  'Clarity,
                  'CSS,
                  'CQL,
                  'CMake,
                  '"C++",
                  '"C#",
                  'C,
                  'BrighterScript,
                  'Blade,
                  'Bicep,
                  'Beancount,
                  'Bazel,
                  'Bash,
                  '"Azure Pipelines",
                  'Astro,
                  'Assembly,
                  'Arduino,
                  'Apex,
                  'Antlers,
                  'Ansible,
                  'Angular,
                  'Ada,
                  'AWK,
                  '"1С:Enterprise",
                  '".NET"
                |]
              ],
          "enums:platform" = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'win_x86,
                  'win_x64,
                  'win_armv7l,
                  'win_armv6l,
                  'win_arm64,
                  'win_arm,
                  'win,
                  'linux_x86_openbsd,
                  'linux_x86_musl,
                  'linux_x86_gnu,
                  'linux_x86,
                  'linux_x64_openbsd,
                  'linux_x64_musl,
                  'linux_x64_gnu,
                  'linux_x64,
                  'linux_armv7l,
                  'linux_armv7_gnu,
                  'linux_armv6l,
                  'linux_armv6_gnu,
                  'linux_arm_gnu,
                  'linux_arm64_openbsd,
                  'linux_arm64_musl,
                  'linux_arm64_gnu,
                  'linux_arm64,
                  'linux_arm,
                  'linux,
                  'darwin_x64,
                  'darwin_arm64,
                  'darwin,
                  'unix
                |]
              ],
          "enums:spdx-license" = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  '"ZPL-2.1",
                  '"ZPL-2.0",
                  '"ZPL-1.1",
                  'zlib-acknowledgement,
                  'Zlib,
                  '"Zimbra-1.4",
                  '"Zimbra-1.3",
                  '"Zend-2.0",
                  'Zed,
                  '"YPL-1.1",
                  '"YPL-1.0",
                  'XSkat,
                  'xpp,
                  'Xnet,
                  'xinetd,
                  '"XFree86-1.1",
                  'Xerox,
                  'X11-distribute-modifications-variant,
                  'X11,
                  'wxWindows,
                  'WTFPL,
                  'Wsuipa,
                  '"Watcom-1.0",
                  'W3C-20150513,
                  'W3C-19980720,
                  'W3C,
                  '"VSL-1.0",
                  'VOSTROM,
                  'Vim,
                  '"UPL-1.0",
                  'Unlicense,
                  'Unicode-TOU,
                  'Unicode-DFS-2016,
                  'Unicode-DFS-2015,
                  '"UCL-1.0",
                  '"TU-Berlin-2.0",
                  '"TU-Berlin-1.0",
                  'TOSL,
                  '"TORQUE-1.1",
                  'TMate,
                  'TCP-wrappers,
                  'TCL,
                  '"TAPR-OHL-1.0",
                  'Symlinks,
                  'SWL,
                  '"SugarCRM-1.1.3",
                  'StandardML-NJ,
                  '"SSPL-1.0",
                  'SSH-short,
                  'SSH-OpenSSH,
                  '"SPL-1.0",
                  'Spencer-99,
                  'Spencer-94,
                  'Spencer-86,
                  'SNIA,
                  'SMPPL,
                  'SMLNJ,
                  'Sleepycat,
                  '"SISSL-1.2",
                  'SISSL,
                  '"SimPL-2.0",
                  '"SHL-0.51",
                  '"SHL-0.5",
                  '"SGI-B-2.0",
                  '"SGI-B-1.1",
                  '"SGI-B-1.0",
                  '"Sendmail-8.23",
                  'Sendmail,
                  'SchemeReport,
                  'SCEA,
                  'Saxpath,
                  'SAX-PD,
                  'Ruby,
                  'RSCPL,
                  'RSA-MD,
                  '"RPSL-1.0",
                  '"RPL-1.5",
                  '"RPL-1.1",
                  '"RHeCos-1.1",
                  'Rdisc,
                  '"QPL-1.0",
                  'Qhull,
                  '"Python-2.0.1",
                  '"Python-2.0",
                  'psutils,
                  'psfrag,
                  '"PSF-2.0",
                  'PostgreSQL,
                  '"PolyForm-Small-Business-1.0.0",
                  '"PolyForm-Noncommercial-1.0.0",
                  'Plexus,
                  '"PHP-3.01",
                  '"PHP-3.0",
                  '"PDDL-1.0",
                  '"Parity-7.0.0",
                  '"Parity-6.0.0",
                  '"OSL-3.0",
                  '"OSL-2.1",
                  '"OSL-2.0",
                  '"OSL-1.1",
                  '"OSL-1.0",
                  '"OSET-PL-2.1",
                  '"OPUBL-1.0",
                  '"OPL-1.0",
                  'OpenSSL,
                  'OML,
                  '"OLDAP-2.8",
                  '"OLDAP-2.7",
                  '"OLDAP-2.6",
                  '"OLDAP-2.5",
                  '"OLDAP-2.4",
                  '"OLDAP-2.3",
                  '"OLDAP-2.2.2",
                  '"OLDAP-2.2.1",
                  '"OLDAP-2.2",
                  '"OLDAP-2.1",
                  '"OLDAP-2.0.1",
                  '"OLDAP-2.0",
                  '"OLDAP-1.4",
                  '"OLDAP-1.3",
                  '"OLDAP-1.2",
                  '"OLDAP-1.1",
                  'OGTSL,
                  '"OGL-UK-3.0",
                  '"OGL-UK-2.0",
                  '"OGL-UK-1.0",
                  '"OGL-Canada-2.0",
                  '"OGDL-Taiwan-1.0",
                  '"OGC-1.0",
                  '"OFL-1.1-RFN",
                  '"OFL-1.1-no-RFN",
                  '"OFL-1.1",
                  '"OFL-1.0-RFN",
                  '"OFL-1.0-no-RFN",
                  '"OFL-1.0",
                  '"ODC-By-1.0",
                  '"ODbL-1.0",
                  '"OCLC-2.0",
                  'OCCT-PL,
                  '"O-UDA-1.0",
                  'Nunit,
                  'NTP-0,
                  'NTP,
                  'NRL,
                  '"NPOSL-3.0",
                  '"NPL-1.1",
                  '"NPL-1.0",
                  'Noweb,
                  'NOSL,
                  'Nokia,
                  'NLPL,
                  '"NLOD-2.0",
                  '"NLOD-1.0",
                  'NIST-PD-fallback,
                  'NIST-PD,
                  '"NICTA-1.0",
                  'NGPL,
                  'Newsletr,
                  'NetCDF,
                  'Net-SNMP,
                  'NCSA,
                  '"NCGL-UK-2.0",
                  '"NBPL-1.0",
                  'Naumen,
                  '"NASA-1.3",
                  'NAIST-2003,
                  'Mup,
                  'Multics,
                  '"MulanPSL-2.0",
                  '"MulanPSL-1.0",
                  'MTLL,
                  'MS-RL,
                  'MS-PL,
                  'MS-LPL,
                  'mplus,
                  '"MPL-2.0-no-copyleft-exception",
                  '"MPL-2.0",
                  '"MPL-1.1",
                  '"MPL-1.0",
                  'mpich2,
                  'mpi-permissive,
                  'Motosoto,
                  'MITNFA,
                  'MIT-open-group,
                  'MIT-Modern-Variant,
                  'MIT-feh,
                  'MIT-enna,
                  'MIT-CMU,
                  'MIT-advertising,
                  'MIT-0,
                  'MIT,
                  'MirOS,
                  'Minpack,
                  'MakeIndex,
                  '"LZMA-SDK-9.22",
                  '"LZMA-SDK-9.11-to-9.20",
                  '"LPPL-1.3c",
                  '"LPPL-1.3a",
                  '"LPPL-1.2",
                  '"LPPL-1.1",
                  '"LPPL-1.0",
                  '"LPL-1.02",
                  '"LPL-1.0",
                  'LOOP,
                  'Linux-OpenIB,
                  'Linux-man-pages-copyleft,
                  '"LiLiQ-Rplus-1.1",
                  '"LiLiQ-R-1.1",
                  '"LiLiQ-P-1.1",
                  'libutil-David-Nugent,
                  'libtiff,
                  '"libselinux-1.0",
                  '"libpng-2.0",
                  'Libpng,
                  'LGPLLR,
                  '"LGPL-3.0+",
                  '"LGPL-3.0-or-later",
                  '"LGPL-3.0-only",
                  '"LGPL-3.0",
                  '"LGPL-2.1+",
                  '"LGPL-2.1-or-later",
                  '"LGPL-2.1-only",
                  '"LGPL-2.1",
                  '"LGPL-2.0+",
                  '"LGPL-2.0-or-later",
                  '"LGPL-2.0-only",
                  '"LGPL-2.0",
                  'Leptonica,
                  'Latex2e,
                  '"LAL-1.3",
                  '"LAL-1.2",
                  'Knuth-CTAN,
                  'JSON,
                  'JPNIC,
                  '"JasPer-2.0",
                  'Jam,
                  'ISC,
                  '"IPL-1.0",
                  'IPA,
                  '"Interbase-1.0",
                  'Intel-ACPI,
                  'Intel,
                  'Info-ZIP,
                  'Imlib2,
                  'iMatix,
                  'ImageMagick,
                  'IJG,
                  'ICU,
                  'IBM-pibs,
                  'HTMLTIDY,
                  'HPND-sell-variant,
                  'HPND,
                  '"Hippocratic-2.1",
                  'HaskellReport,
                  '"gSOAP-1.3b",
                  '"GPL-3.0+",
                  '"GPL-3.0-with-GCC-exception",
                  '"GPL-3.0-with-autoconf-exception",
                  '"GPL-3.0-or-later",
                  '"GPL-3.0-only",
                  '"GPL-3.0",
                  '"GPL-2.0+",
                  '"GPL-2.0-with-GCC-exception",
                  '"GPL-2.0-with-font-exception",
                  '"GPL-2.0-with-classpath-exception",
                  '"GPL-2.0-with-bison-exception",
                  '"GPL-2.0-with-autoconf-exception",
                  '"GPL-2.0-or-later",
                  '"GPL-2.0-only",
                  '"GPL-2.0",
                  '"GPL-1.0+",
                  '"GPL-1.0-or-later",
                  '"GPL-1.0-only",
                  '"GPL-1.0",
                  'gnuplot,
                  'GLWTPL,
                  'Glulxe,
                  'Glide,
                  'GL2PS,
                  'Giftware,
                  '"GFDL-1.3-or-later",
                  '"GFDL-1.3-only",
                  '"GFDL-1.3-no-invariants-or-later",
                  '"GFDL-1.3-no-invariants-only",
                  '"GFDL-1.3-invariants-or-later",
                  '"GFDL-1.3-invariants-only",
                  '"GFDL-1.3",
                  '"GFDL-1.2-or-later",
                  '"GFDL-1.2-only",
                  '"GFDL-1.2-no-invariants-or-later",
                  '"GFDL-1.2-no-invariants-only",
                  '"GFDL-1.2-invariants-or-later",
                  '"GFDL-1.2-invariants-only",
                  '"GFDL-1.2",
                  '"GFDL-1.1-or-later",
                  '"GFDL-1.1-only",
                  '"GFDL-1.1-no-invariants-or-later",
                  '"GFDL-1.1-no-invariants-only",
                  '"GFDL-1.1-invariants-or-later",
                  '"GFDL-1.1-invariants-only",
                  '"GFDL-1.1",
                  'GD,
                  'FTL,
                  'FSFULLRWD,
                  'FSFULLR,
                  'FSFUL,
                  'FSFAP,
                  'FreeImage,
                  'FreeBSD-DOC,
                  '"Frameworx-1.0",
                  'FDK-AAC,
                  'Fair,
                  'Eurosym,
                  '"EUPL-1.2",
                  '"EUPL-1.1",
                  '"EUPL-1.0",
                  'EUDatagrid,
                  '"etalab-2.0",
                  '"ErlPL-1.1",
                  '"EPL-2.0",
                  '"EPL-1.0",
                  'EPICS,
                  'Entessa,
                  '"Elastic-2.0",
                  'eGenix,
                  '"EFL-2.0",
                  '"EFL-1.0",
                  '"eCos-2.0",
                  '"ECL-2.0",
                  '"ECL-1.0",
                  'dvipdfm,
                  'DSDP,
                  '"DRL-1.0",
                  'Dotseqn,
                  'DOC,
                  '"DL-DE-BY-2.0",
                  'diffmark,
                  '"D-FSL-1.0",
                  'curl,
                  'Cube,
                  '"CUA-OPL-1.0",
                  'CrystalStacker,
                  'Crossword,
                  '"CPOL-1.02",
                  '"CPL-1.0",
                  '"CPAL-1.0",
                  '"copyleft-next-0.3.1",
                  '"copyleft-next-0.3.0",
                  '"Condor-1.1",
                  '"Community-Spec-1.0",
                  '"COIL-1.0",
                  'CNRI-Python-GPL-Compatible,
                  'CNRI-Python,
                  'CNRI-Jython,
                  'ClArtistic,
                  'checkmk,
                  '"CERN-OHL-W-2.0",
                  '"CERN-OHL-S-2.0",
                  '"CERN-OHL-P-2.0",
                  '"CERN-OHL-1.2",
                  '"CERN-OHL-1.1",
                  'CECILL-C,
                  'CECILL-B,
                  '"CECILL-2.1",
                  '"CECILL-2.0",
                  '"CECILL-1.1",
                  '"CECILL-1.0",
                  '"CDLA-Sharing-1.0",
                  '"CDLA-Permissive-2.0",
                  '"CDLA-Permissive-1.0",
                  '"CDL-1.0",
                  '"CDDL-1.1",
                  '"CDDL-1.0",
                  '"CC0-1.0",
                  'CC-PDDC,
                  '"CC-BY-SA-4.0",
                  '"CC-BY-SA-3.0-DE",
                  '"CC-BY-SA-3.0-AT",
                  '"CC-BY-SA-3.0",
                  '"CC-BY-SA-2.5",
                  '"CC-BY-SA-2.1-JP",
                  '"CC-BY-SA-2.0-UK",
                  '"CC-BY-SA-2.0",
                  '"CC-BY-SA-1.0",
                  '"CC-BY-ND-4.0",
                  '"CC-BY-ND-3.0-DE",
                  '"CC-BY-ND-3.0",
                  '"CC-BY-ND-2.5",
                  '"CC-BY-ND-2.0",
                  '"CC-BY-ND-1.0",
                  '"CC-BY-NC-SA-4.0",
                  '"CC-BY-NC-SA-3.0-IGO",
                  '"CC-BY-NC-SA-3.0-DE",
                  '"CC-BY-NC-SA-3.0",
                  '"CC-BY-NC-SA-2.5",
                  '"CC-BY-NC-SA-2.0-UK",
                  '"CC-BY-NC-SA-2.0-FR",
                  '"CC-BY-NC-SA-2.0",
                  '"CC-BY-NC-SA-1.0",
                  '"CC-BY-NC-ND-4.0",
                  '"CC-BY-NC-ND-3.0-IGO",
                  '"CC-BY-NC-ND-3.0-DE",
                  '"CC-BY-NC-ND-3.0",
                  '"CC-BY-NC-ND-2.5",
                  '"CC-BY-NC-ND-2.0",
                  '"CC-BY-NC-ND-1.0",
                  '"CC-BY-NC-4.0",
                  '"CC-BY-NC-3.0-DE",
                  '"CC-BY-NC-3.0",
                  '"CC-BY-NC-2.5",
                  '"CC-BY-NC-2.0",
                  '"CC-BY-NC-1.0",
                  '"CC-BY-4.0",
                  '"CC-BY-3.0-US",
                  '"CC-BY-3.0-NL",
                  '"CC-BY-3.0-IGO",
                  '"CC-BY-3.0-DE",
                  '"CC-BY-3.0-AT",
                  '"CC-BY-3.0",
                  '"CC-BY-2.5-AU",
                  '"CC-BY-2.5",
                  '"CC-BY-2.0",
                  '"CC-BY-1.0",
                  '"CATOSL-1.1",
                  'Caldera,
                  '"CAL-1.0-Combined-Work-Exception",
                  '"CAL-1.0",
                  '"C-UDA-1.0",
                  '"bzip2-1.0.6",
                  '"bzip2-1.0.5",
                  '"BUSL-1.1",
                  '"BSL-1.0",
                  'BSD-Source-Code,
                  'BSD-Protection,
                  'BSD-4-Clause-UC,
                  'BSD-4-Clause-Shortened,
                  'BSD-4-Clause,
                  'BSD-3-Clause-Open-MPI,
                  'BSD-3-Clause-No-Nuclear-Warranty,
                  'BSD-3-Clause-No-Nuclear-License-2014,
                  'BSD-3-Clause-No-Nuclear-License,
                  'BSD-3-Clause-No-Military-License,
                  'BSD-3-Clause-Modification,
                  'BSD-3-Clause-LBNL,
                  'BSD-3-Clause-Clear,
                  'BSD-3-Clause-Attribution,
                  'BSD-3-Clause,
                  'BSD-2-Clause-Views,
                  'BSD-2-Clause-Patent,
                  'BSD-2-Clause-NetBSD,
                  'BSD-2-Clause-FreeBSD,
                  'BSD-2-Clause,
                  'BSD-1-Clause,
                  'Borceux,
                  '"BlueOak-1.0.0",
                  'blessing,
                  '"BitTorrent-1.1",
                  '"BitTorrent-1.0",
                  'Bitstream-Vera,
                  'Beerware,
                  'Barr,
                  'Bahyph,
                  'Baekmuk,
                  '"Artistic-2.0",
                  '"Artistic-1.0-Perl",
                  '"Artistic-1.0-cl8",
                  '"Artistic-1.0",
                  'Arphic-1999,
                  '"APSL-2.0",
                  '"APSL-1.2",
                  '"APSL-1.1",
                  '"APSL-1.0",
                  'App-s2p,
                  '"APL-1.0",
                  'APAFML,
                  '"Apache-2.0",
                  '"Apache-1.1",
                  '"Apache-1.0",
                  'ANTLR-PD-fallback,
                  'ANTLR-PD,
                  'AMPAS,
                  'AML,
                  'AMDPLPA,
                  'Aladdin,
                  '"AGPL-3.0-or-later",
                  '"AGPL-3.0-only",
                  '"AGPL-3.0",
                  '"AGPL-1.0-or-later",
                  '"AGPL-1.0-only",
                  '"AGPL-1.0",
                  'Afmparse,
                  '"AFL-3.0",
                  '"AFL-2.1",
                  '"AFL-2.0",
                  '"AFL-1.2",
                  '"AFL-1.1",
                  'ADSL,
                  'Adobe-Glyph,
                  'Adobe-2006,
                  'Abstyles,
                  'AAL,
                  '"0BSD",
                  'proprietary
                |]
              ],
        },
    predicate = {
          "components:bin" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                { "^[a-zA-Z0-9_\\-\\.]+$" = predicates.isType '"String", }
                false
                predicates.never
              ],
          "components:opt" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                { "^[a-zA-Z0-9_\\-\\./]+$" = predicates.isType '"String", }
                false
                predicates.never
              ],
          "components:schemas" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  lsp = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^(vscode:)?https://"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:share" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                { "^[a-zA-Z0-9_\\-\\./]+$" = predicates.isType '"String", }
                false
                predicates.never
              ],
          "components:source" = predicates.oneOf
              [
                definitions.predicate."components:sources:cargo",
                definitions.predicate."components:sources:composer",
                definitions.predicate."components:sources:gem",
                definitions.predicate."components:sources:generic",
                definitions.predicate."components:sources:github",
                definitions.predicate."components:sources:golang",
                definitions.predicate."components:sources:luarocks",
                definitions.predicate."components:sources:npm",
                definitions.predicate."components:sources:nuget",
                definitions.predicate."components:sources:opam",
                definitions.predicate."components:sources:pypi"
              ],
          "components:sources:build" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "run" ],
                predicates.records.record
                {
                  env = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { "^[A-Z0-9_]+$" = predicates.isType '"String", }
                        false
                        predicates.never
                      ],
                  run = predicates.isType '"String",
                  staged = predicates.isType '"Bool",
                  target = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate."enums:platform"
                        ],
                        definitions.predicate."enums:platform"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          "components:sources:cargo" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:cargo/.+@.+"
                      ],
                  supported_platforms = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."enums:platform"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:sources:composer" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:composer/.+/.+@.+"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:sources:gem" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  extra_packages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:gem/.+@.+"
                      ],
                  supported_platforms = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."enums:platform"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:sources:generic" = predicates.oneOf
              [
                definitions.predicate."components:sources:generic:download",
                definitions.predicate."components:sources:generic:build"
              ],
          "components:sources:generic:build" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "build", "id" ],
                predicates.records.record
                {
                  build = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate."components:sources:build"
                        ],
                        definitions.predicate."components:sources:build"
                      ],
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:generic/.+@.+"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:sources:generic:download" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "download", "id" ],
                predicates.records.record
                {
                  download = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate."components:sources:generic:download/definitions/Download"
                        ],
                        definitions.predicate."components:sources:generic:download/definitions/Download"
                      ],
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:generic/.+@.+"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:sources:github" = predicates.oneOf
              [
                definitions.predicate."components:sources:github:release",
                definitions.predicate."components:sources:github:build"
              ],
          "components:sources:github:build" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "build", "id" ],
                predicates.records.record
                {
                  build = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate."components:sources:build"
                        ],
                        definitions.predicate."components:sources:build"
                      ],
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:github/.+/.+@.+"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:sources:github:release" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "asset", "id" ],
                predicates.records.record
                {
                  asset =
                    definitions.predicate."components:sources:github:release/definitions/Asset",
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:github/.+/.+@.+"
                      ],
                  version_overrides = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "asset", "constraint" ],
                          predicates.records.record
                          {
                            asset =
                              definitions.predicate."components:sources:github:release/definitions/Asset",
                            constraint = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^semver:(<=)?v?\\d+\\.\\d+\\.\\d+"
                                ],
                            id = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^pkg:github/.+/[^@]+$"
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:sources:golang" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  extra_packages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:golang/.+/.+@.+"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:sources:luarocks" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:luarocks/.+@.+"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:sources:npm" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  extra_packages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:npm/.+@.+"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:sources:nuget" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:nuget/.+@.+"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:sources:opam" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:opam/.+@.+"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "components:sources:pypi" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  extra_packages = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^pkg:pypi/.+@.+"
                      ],
                  supported_platforms = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."enums:platform"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "enums:category" = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "Compiler", "DAP", "Formatter", "LSP", "Linter", "Runtime" ]
              ],
          "enums:language" = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  ".NET",
                  "1С:Enterprise",
                  "AWK",
                  "Ada",
                  "Angular",
                  "Ansible",
                  "Antlers",
                  "Apex",
                  "Arduino",
                  "Assembly",
                  "Astro",
                  "Azure Pipelines",
                  "Bash",
                  "Bazel",
                  "Beancount",
                  "Bicep",
                  "Blade",
                  "BrighterScript",
                  "C",
                  "C#",
                  "C++",
                  "CMake",
                  "CQL",
                  "CSS",
                  "Clarity",
                  "Clojure",
                  "ClojureScript",
                  "CodeQL",
                  "Crystal",
                  "Csh",
                  "Cucumber",
                  "Cue",
                  "D",
                  "DOT",
                  "Dart",
                  "Dhall",
                  "Django",
                  "Docker",
                  "Drools",
                  "Elixir",
                  "Elm",
                  "Ember",
                  "Emmet",
                  "Erg",
                  "Erlang",
                  "F#",
                  "Fennel",
                  "Flow",
                  "Flux",
                  "Fortran",
                  "Gleam",
                  "Glimmer",
                  "Go",
                  "Gradle",
                  "GraphQL",
                  "Groovy",
                  "HAML",
                  "HTML",
                  "Handlebargs",
                  "Handlebars",
                  "Haskell",
                  "Haxe",
                  "Helm",
                  "Hoon",
                  "JSON",
                  "JSX",
                  "Java",
                  "JavaScript",
                  "Jinja",
                  "Jq",
                  "Jsonnet",
                  "Julia",
                  "Kotlin",
                  "Ksh",
                  "LESS",
                  "LaTeX",
                  "Lelwel",
                  "Liquid",
                  "Lua",
                  "Luau",
                  "Markdown",
                  "Metamath Zero",
                  "Mksh",
                  "Move",
                  "Mustache",
                  "Nginx",
                  "Nickel",
                  "Nim",
                  "Nix",
                  "Nunjucks",
                  "OCaml",
                  "Odin",
                  "OneScript",
                  "OpenAPI",
                  "OpenCL",
                  "OpenEdge",
                  "OpenFOAM",
                  "OpenSCAD",
                  "PHP",
                  "Perl",
                  "PowerShell",
                  "Prisma",
                  "Progress",
                  "Protobuf",
                  "Puppet",
                  "PureScript",
                  "Python",
                  "R",
                  "Raku",
                  "ReScript",
                  "Reason",
                  "Robot Framework",
                  "Ruby",
                  "Rust",
                  "SCSS",
                  "SQL",
                  "Salt",
                  "Sass",
                  "Scala",
                  "Sh",
                  "Shell",
                  "Slint",
                  "Smithy",
                  "Standard ML",
                  "Snakemake",
                  "Solidity",
                  "Sphinx",
                  "Starlark",
                  "Stylelint",
                  "Svelte",
                  "SystemVerilog",
                  "TOML",
                  "Teal",
                  "Terraform",
                  "Text",
                  "Twig",
                  "TypeScript",
                  "Typst",
                  "V",
                  "Vala",
                  "Veryl",
                  "VimScript",
                  "Visualforce",
                  "Vue",
                  "WGSL",
                  "XML",
                  "YAML",
                  "YARA",
                  "Zig",
                  "Zsh"
                ]
              ],
          "enums:platform" = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "unix",
                  "darwin",
                  "darwin_arm64",
                  "darwin_x64",
                  "linux",
                  "linux_arm",
                  "linux_arm64",
                  "linux_arm64_gnu",
                  "linux_arm64_musl",
                  "linux_arm64_openbsd",
                  "linux_arm_gnu",
                  "linux_armv6_gnu",
                  "linux_armv6l",
                  "linux_armv7_gnu",
                  "linux_armv7l",
                  "linux_x64",
                  "linux_x64_gnu",
                  "linux_x64_musl",
                  "linux_x64_openbsd",
                  "linux_x86",
                  "linux_x86_gnu",
                  "linux_x86_musl",
                  "linux_x86_openbsd",
                  "win",
                  "win_arm",
                  "win_arm64",
                  "win_armv6l",
                  "win_armv7l",
                  "win_x64",
                  "win_x86"
                ]
              ],
          "enums:spdx-license" = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "proprietary",
                  "0BSD",
                  "AAL",
                  "Abstyles",
                  "Adobe-2006",
                  "Adobe-Glyph",
                  "ADSL",
                  "AFL-1.1",
                  "AFL-1.2",
                  "AFL-2.0",
                  "AFL-2.1",
                  "AFL-3.0",
                  "Afmparse",
                  "AGPL-1.0",
                  "AGPL-1.0-only",
                  "AGPL-1.0-or-later",
                  "AGPL-3.0",
                  "AGPL-3.0-only",
                  "AGPL-3.0-or-later",
                  "Aladdin",
                  "AMDPLPA",
                  "AML",
                  "AMPAS",
                  "ANTLR-PD",
                  "ANTLR-PD-fallback",
                  "Apache-1.0",
                  "Apache-1.1",
                  "Apache-2.0",
                  "APAFML",
                  "APL-1.0",
                  "App-s2p",
                  "APSL-1.0",
                  "APSL-1.1",
                  "APSL-1.2",
                  "APSL-2.0",
                  "Arphic-1999",
                  "Artistic-1.0",
                  "Artistic-1.0-cl8",
                  "Artistic-1.0-Perl",
                  "Artistic-2.0",
                  "Baekmuk",
                  "Bahyph",
                  "Barr",
                  "Beerware",
                  "Bitstream-Vera",
                  "BitTorrent-1.0",
                  "BitTorrent-1.1",
                  "blessing",
                  "BlueOak-1.0.0",
                  "Borceux",
                  "BSD-1-Clause",
                  "BSD-2-Clause",
                  "BSD-2-Clause-FreeBSD",
                  "BSD-2-Clause-NetBSD",
                  "BSD-2-Clause-Patent",
                  "BSD-2-Clause-Views",
                  "BSD-3-Clause",
                  "BSD-3-Clause-Attribution",
                  "BSD-3-Clause-Clear",
                  "BSD-3-Clause-LBNL",
                  "BSD-3-Clause-Modification",
                  "BSD-3-Clause-No-Military-License",
                  "BSD-3-Clause-No-Nuclear-License",
                  "BSD-3-Clause-No-Nuclear-License-2014",
                  "BSD-3-Clause-No-Nuclear-Warranty",
                  "BSD-3-Clause-Open-MPI",
                  "BSD-4-Clause",
                  "BSD-4-Clause-Shortened",
                  "BSD-4-Clause-UC",
                  "BSD-Protection",
                  "BSD-Source-Code",
                  "BSL-1.0",
                  "BUSL-1.1",
                  "bzip2-1.0.5",
                  "bzip2-1.0.6",
                  "C-UDA-1.0",
                  "CAL-1.0",
                  "CAL-1.0-Combined-Work-Exception",
                  "Caldera",
                  "CATOSL-1.1",
                  "CC-BY-1.0",
                  "CC-BY-2.0",
                  "CC-BY-2.5",
                  "CC-BY-2.5-AU",
                  "CC-BY-3.0",
                  "CC-BY-3.0-AT",
                  "CC-BY-3.0-DE",
                  "CC-BY-3.0-IGO",
                  "CC-BY-3.0-NL",
                  "CC-BY-3.0-US",
                  "CC-BY-4.0",
                  "CC-BY-NC-1.0",
                  "CC-BY-NC-2.0",
                  "CC-BY-NC-2.5",
                  "CC-BY-NC-3.0",
                  "CC-BY-NC-3.0-DE",
                  "CC-BY-NC-4.0",
                  "CC-BY-NC-ND-1.0",
                  "CC-BY-NC-ND-2.0",
                  "CC-BY-NC-ND-2.5",
                  "CC-BY-NC-ND-3.0",
                  "CC-BY-NC-ND-3.0-DE",
                  "CC-BY-NC-ND-3.0-IGO",
                  "CC-BY-NC-ND-4.0",
                  "CC-BY-NC-SA-1.0",
                  "CC-BY-NC-SA-2.0",
                  "CC-BY-NC-SA-2.0-FR",
                  "CC-BY-NC-SA-2.0-UK",
                  "CC-BY-NC-SA-2.5",
                  "CC-BY-NC-SA-3.0",
                  "CC-BY-NC-SA-3.0-DE",
                  "CC-BY-NC-SA-3.0-IGO",
                  "CC-BY-NC-SA-4.0",
                  "CC-BY-ND-1.0",
                  "CC-BY-ND-2.0",
                  "CC-BY-ND-2.5",
                  "CC-BY-ND-3.0",
                  "CC-BY-ND-3.0-DE",
                  "CC-BY-ND-4.0",
                  "CC-BY-SA-1.0",
                  "CC-BY-SA-2.0",
                  "CC-BY-SA-2.0-UK",
                  "CC-BY-SA-2.1-JP",
                  "CC-BY-SA-2.5",
                  "CC-BY-SA-3.0",
                  "CC-BY-SA-3.0-AT",
                  "CC-BY-SA-3.0-DE",
                  "CC-BY-SA-4.0",
                  "CC-PDDC",
                  "CC0-1.0",
                  "CDDL-1.0",
                  "CDDL-1.1",
                  "CDL-1.0",
                  "CDLA-Permissive-1.0",
                  "CDLA-Permissive-2.0",
                  "CDLA-Sharing-1.0",
                  "CECILL-1.0",
                  "CECILL-1.1",
                  "CECILL-2.0",
                  "CECILL-2.1",
                  "CECILL-B",
                  "CECILL-C",
                  "CERN-OHL-1.1",
                  "CERN-OHL-1.2",
                  "CERN-OHL-P-2.0",
                  "CERN-OHL-S-2.0",
                  "CERN-OHL-W-2.0",
                  "checkmk",
                  "ClArtistic",
                  "CNRI-Jython",
                  "CNRI-Python",
                  "CNRI-Python-GPL-Compatible",
                  "COIL-1.0",
                  "Community-Spec-1.0",
                  "Condor-1.1",
                  "copyleft-next-0.3.0",
                  "copyleft-next-0.3.1",
                  "CPAL-1.0",
                  "CPL-1.0",
                  "CPOL-1.02",
                  "Crossword",
                  "CrystalStacker",
                  "CUA-OPL-1.0",
                  "Cube",
                  "curl",
                  "D-FSL-1.0",
                  "diffmark",
                  "DL-DE-BY-2.0",
                  "DOC",
                  "Dotseqn",
                  "DRL-1.0",
                  "DSDP",
                  "dvipdfm",
                  "ECL-1.0",
                  "ECL-2.0",
                  "eCos-2.0",
                  "EFL-1.0",
                  "EFL-2.0",
                  "eGenix",
                  "Elastic-2.0",
                  "Entessa",
                  "EPICS",
                  "EPL-1.0",
                  "EPL-2.0",
                  "ErlPL-1.1",
                  "etalab-2.0",
                  "EUDatagrid",
                  "EUPL-1.0",
                  "EUPL-1.1",
                  "EUPL-1.2",
                  "Eurosym",
                  "Fair",
                  "FDK-AAC",
                  "Frameworx-1.0",
                  "FreeBSD-DOC",
                  "FreeImage",
                  "FSFAP",
                  "FSFUL",
                  "FSFULLR",
                  "FSFULLRWD",
                  "FTL",
                  "GD",
                  "GFDL-1.1",
                  "GFDL-1.1-invariants-only",
                  "GFDL-1.1-invariants-or-later",
                  "GFDL-1.1-no-invariants-only",
                  "GFDL-1.1-no-invariants-or-later",
                  "GFDL-1.1-only",
                  "GFDL-1.1-or-later",
                  "GFDL-1.2",
                  "GFDL-1.2-invariants-only",
                  "GFDL-1.2-invariants-or-later",
                  "GFDL-1.2-no-invariants-only",
                  "GFDL-1.2-no-invariants-or-later",
                  "GFDL-1.2-only",
                  "GFDL-1.2-or-later",
                  "GFDL-1.3",
                  "GFDL-1.3-invariants-only",
                  "GFDL-1.3-invariants-or-later",
                  "GFDL-1.3-no-invariants-only",
                  "GFDL-1.3-no-invariants-or-later",
                  "GFDL-1.3-only",
                  "GFDL-1.3-or-later",
                  "Giftware",
                  "GL2PS",
                  "Glide",
                  "Glulxe",
                  "GLWTPL",
                  "gnuplot",
                  "GPL-1.0",
                  "GPL-1.0-only",
                  "GPL-1.0-or-later",
                  "GPL-1.0+",
                  "GPL-2.0",
                  "GPL-2.0-only",
                  "GPL-2.0-or-later",
                  "GPL-2.0-with-autoconf-exception",
                  "GPL-2.0-with-bison-exception",
                  "GPL-2.0-with-classpath-exception",
                  "GPL-2.0-with-font-exception",
                  "GPL-2.0-with-GCC-exception",
                  "GPL-2.0+",
                  "GPL-3.0",
                  "GPL-3.0-only",
                  "GPL-3.0-or-later",
                  "GPL-3.0-with-autoconf-exception",
                  "GPL-3.0-with-GCC-exception",
                  "GPL-3.0+",
                  "gSOAP-1.3b",
                  "HaskellReport",
                  "Hippocratic-2.1",
                  "HPND",
                  "HPND-sell-variant",
                  "HTMLTIDY",
                  "IBM-pibs",
                  "ICU",
                  "IJG",
                  "ImageMagick",
                  "iMatix",
                  "Imlib2",
                  "Info-ZIP",
                  "Intel",
                  "Intel-ACPI",
                  "Interbase-1.0",
                  "IPA",
                  "IPL-1.0",
                  "ISC",
                  "Jam",
                  "JasPer-2.0",
                  "JPNIC",
                  "JSON",
                  "Knuth-CTAN",
                  "LAL-1.2",
                  "LAL-1.3",
                  "Latex2e",
                  "Leptonica",
                  "LGPL-2.0",
                  "LGPL-2.0-only",
                  "LGPL-2.0-or-later",
                  "LGPL-2.0+",
                  "LGPL-2.1",
                  "LGPL-2.1-only",
                  "LGPL-2.1-or-later",
                  "LGPL-2.1+",
                  "LGPL-3.0",
                  "LGPL-3.0-only",
                  "LGPL-3.0-or-later",
                  "LGPL-3.0+",
                  "LGPLLR",
                  "Libpng",
                  "libpng-2.0",
                  "libselinux-1.0",
                  "libtiff",
                  "libutil-David-Nugent",
                  "LiLiQ-P-1.1",
                  "LiLiQ-R-1.1",
                  "LiLiQ-Rplus-1.1",
                  "Linux-man-pages-copyleft",
                  "Linux-OpenIB",
                  "LOOP",
                  "LPL-1.0",
                  "LPL-1.02",
                  "LPPL-1.0",
                  "LPPL-1.1",
                  "LPPL-1.2",
                  "LPPL-1.3a",
                  "LPPL-1.3c",
                  "LZMA-SDK-9.11-to-9.20",
                  "LZMA-SDK-9.22",
                  "MakeIndex",
                  "Minpack",
                  "MirOS",
                  "MIT",
                  "MIT-0",
                  "MIT-advertising",
                  "MIT-CMU",
                  "MIT-enna",
                  "MIT-feh",
                  "MIT-Modern-Variant",
                  "MIT-open-group",
                  "MITNFA",
                  "Motosoto",
                  "mpi-permissive",
                  "mpich2",
                  "MPL-1.0",
                  "MPL-1.1",
                  "MPL-2.0",
                  "MPL-2.0-no-copyleft-exception",
                  "mplus",
                  "MS-LPL",
                  "MS-PL",
                  "MS-RL",
                  "MTLL",
                  "MulanPSL-1.0",
                  "MulanPSL-2.0",
                  "Multics",
                  "Mup",
                  "NAIST-2003",
                  "NASA-1.3",
                  "Naumen",
                  "NBPL-1.0",
                  "NCGL-UK-2.0",
                  "NCSA",
                  "Net-SNMP",
                  "NetCDF",
                  "Newsletr",
                  "NGPL",
                  "NICTA-1.0",
                  "NIST-PD",
                  "NIST-PD-fallback",
                  "NLOD-1.0",
                  "NLOD-2.0",
                  "NLPL",
                  "Nokia",
                  "NOSL",
                  "Noweb",
                  "NPL-1.0",
                  "NPL-1.1",
                  "NPOSL-3.0",
                  "NRL",
                  "NTP",
                  "NTP-0",
                  "Nunit",
                  "O-UDA-1.0",
                  "OCCT-PL",
                  "OCLC-2.0",
                  "ODbL-1.0",
                  "ODC-By-1.0",
                  "OFL-1.0",
                  "OFL-1.0-no-RFN",
                  "OFL-1.0-RFN",
                  "OFL-1.1",
                  "OFL-1.1-no-RFN",
                  "OFL-1.1-RFN",
                  "OGC-1.0",
                  "OGDL-Taiwan-1.0",
                  "OGL-Canada-2.0",
                  "OGL-UK-1.0",
                  "OGL-UK-2.0",
                  "OGL-UK-3.0",
                  "OGTSL",
                  "OLDAP-1.1",
                  "OLDAP-1.2",
                  "OLDAP-1.3",
                  "OLDAP-1.4",
                  "OLDAP-2.0",
                  "OLDAP-2.0.1",
                  "OLDAP-2.1",
                  "OLDAP-2.2",
                  "OLDAP-2.2.1",
                  "OLDAP-2.2.2",
                  "OLDAP-2.3",
                  "OLDAP-2.4",
                  "OLDAP-2.5",
                  "OLDAP-2.6",
                  "OLDAP-2.7",
                  "OLDAP-2.8",
                  "OML",
                  "OpenSSL",
                  "OPL-1.0",
                  "OPUBL-1.0",
                  "OSET-PL-2.1",
                  "OSL-1.0",
                  "OSL-1.1",
                  "OSL-2.0",
                  "OSL-2.1",
                  "OSL-3.0",
                  "Parity-6.0.0",
                  "Parity-7.0.0",
                  "PDDL-1.0",
                  "PHP-3.0",
                  "PHP-3.01",
                  "Plexus",
                  "PolyForm-Noncommercial-1.0.0",
                  "PolyForm-Small-Business-1.0.0",
                  "PostgreSQL",
                  "PSF-2.0",
                  "psfrag",
                  "psutils",
                  "Python-2.0",
                  "Python-2.0.1",
                  "Qhull",
                  "QPL-1.0",
                  "Rdisc",
                  "RHeCos-1.1",
                  "RPL-1.1",
                  "RPL-1.5",
                  "RPSL-1.0",
                  "RSA-MD",
                  "RSCPL",
                  "Ruby",
                  "SAX-PD",
                  "Saxpath",
                  "SCEA",
                  "SchemeReport",
                  "Sendmail",
                  "Sendmail-8.23",
                  "SGI-B-1.0",
                  "SGI-B-1.1",
                  "SGI-B-2.0",
                  "SHL-0.5",
                  "SHL-0.51",
                  "SimPL-2.0",
                  "SISSL",
                  "SISSL-1.2",
                  "Sleepycat",
                  "SMLNJ",
                  "SMPPL",
                  "SNIA",
                  "Spencer-86",
                  "Spencer-94",
                  "Spencer-99",
                  "SPL-1.0",
                  "SSH-OpenSSH",
                  "SSH-short",
                  "SSPL-1.0",
                  "StandardML-NJ",
                  "SugarCRM-1.1.3",
                  "SWL",
                  "Symlinks",
                  "TAPR-OHL-1.0",
                  "TCL",
                  "TCP-wrappers",
                  "TMate",
                  "TORQUE-1.1",
                  "TOSL",
                  "TU-Berlin-1.0",
                  "TU-Berlin-2.0",
                  "UCL-1.0",
                  "Unicode-DFS-2015",
                  "Unicode-DFS-2016",
                  "Unicode-TOU",
                  "Unlicense",
                  "UPL-1.0",
                  "Vim",
                  "VOSTROM",
                  "VSL-1.0",
                  "W3C",
                  "W3C-19980720",
                  "W3C-20150513",
                  "Watcom-1.0",
                  "Wsuipa",
                  "WTFPL",
                  "wxWindows",
                  "X11",
                  "X11-distribute-modifications-variant",
                  "Xerox",
                  "XFree86-1.1",
                  "xinetd",
                  "Xnet",
                  "xpp",
                  "XSkat",
                  "YPL-1.0",
                  "YPL-1.1",
                  "Zed",
                  "Zend-2.0",
                  "Zimbra-1.3",
                  "Zimbra-1.4",
                  "Zlib",
                  "zlib-acknowledgement",
                  "ZPL-1.1",
                  "ZPL-2.0",
                  "ZPL-2.1"
                ]
              ],
        },
  }
in

{
  bin | definitions.contract."components:bin" | optional,
  categories
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate."enums:category"
    ]),
  ci_skip
    | predicates.contract_from_predicate
    (predicates.oneOf
    [
      predicates.isType '"Bool",
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf definitions.predicate."enums:platform"
      ]
    ])
    | optional,
  description
    | String
    | doc m%"
    The description of the package. Usually sourced upstream.
    "%,
  homepage
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.pattern "^https?://" ])
    | doc m%"
    A URL to the package's homepage.
    "%,
  languages
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate."enums:language"
    ]),
  licenses
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate."enums:spdx-license",
      predicates.arrays.minItems 1
    ]),
  name
    | String
    | doc m%"
    The package name. MUST be unique within the registry it belongs to.
    "%,
  opt | definitions.contract."components:opt" | optional,
  schemas | definitions.contract."components:schemas" | optional,
  share | definitions.contract."components:share" | optional,
  source | definitions.contract."components:source",
}